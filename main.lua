function love.load()
    love.window.setTitle("Clash of Hands") -- Set window title
    love.window.setMode(1680, 1000)
    
    colors = {
        {1, 0, 0}, -- Red
        {0, 0, 1}, -- Blue
        {0, 1, 0}, -- Green
        {1, 1, 0}, -- Yellow
        {1, 0, 1}  -- Magenta
    }
    
    images = {}
    for i = 0, 4 do
        images[i] = love.graphics.newImage("assets/" .. i .. ".png")
    end
    
    gameState = "menu" -- Initial game state
    AI_STATES = { IDLE = "idle", SELECTING = "selecting", MOVING = "moving", RELEASING = "releasing", END_TURN = "end_turn" }
    aiState = AI_STATES.IDLE
    aiSelectedCircle = nil
    moveSpeed = 300 -- AI movement speed
    
    function resetGame()
        if not players then
            local screenWidth, screenHeight = love.graphics.getDimensions()
            local centerX = screenWidth / 2
            local spacingX = 300  -- Horizontal spacing between hands
            local aiY = screenHeight * 0.25
            local playerY = screenHeight * 0.75
    
    
    
            players = {
                {name = "AI Player", score = 0, xLabel = 750, yLabel = aiY - 200, circles = {
                    {x = centerX - spacingX, y = aiY, origX = centerX - spacingX, origY = aiY, radius = 120, dragging = false, offsetX = 0, offsetY = 0, points = 1},
                    {x = centerX + spacingX, y = aiY, origX = centerX + spacingX, origY = aiY, radius = 120, dragging = false, offsetX = 0, offsetY = 0, points = 1}
                }},
                {name = "Human", score = 0, xLabel = 750, yLabel = playerY + 200, circles = {
                    {x = centerX - spacingX, y = playerY, origX = centerX - spacingX, origY = playerY, radius = 120, dragging = false, offsetX = 0, offsetY = 0, points = 1},
                    {x = centerX + spacingX, y = playerY, origX = centerX + spacingX, origY = playerY, radius = 120, dragging = false, offsetX = 0, offsetY = 0, points = 1}
                }}
            }
        else
            -- Reset points & positions without modifying x and y
            for _, player in ipairs(players) do
                for _, circle in ipairs(player.circles) do
                    circle.points = 1
                    circle.x, circle.y = circle.origX, circle.origY -- Reset position only to original values
                    circle.dragging = false
                end
            end
        end
    
        if not startingPlayerIndex then
            startingPlayerIndex = 1
        else
            startingPlayerIndex = (startingPlayerIndex % #players) + 1
        end
        currentPlayerIndex = startingPlayerIndex
    
        gameOver = false
        winner = nil
        aiState = AI_STATES.IDLE
    end
    
    
    resetGame()
end


function love.update(dt)
    if gameState == "playing" then
        if gameOver then
            return
        end

        if currentPlayerIndex == 1 then -- AI's Turn
            updateAI(dt)
        else
            for _, circle in ipairs(players[currentPlayerIndex].circles) do
                if circle.dragging then
                    circle.x = love.mouse.getX() - circle.offsetX
                    circle.y = love.mouse.getY() - circle.offsetY
                end
            end
        end
    end
end


-- AI FSM LOGIC
function updateAI(dt)
    local aiPlayer = players[1] -- AI Player

    if aiState == AI_STATES.IDLE then
        aiState = AI_STATES.SELECTING

    elseif aiState == AI_STATES.SELECTING then
        aiSelectedCircle = selectBestAICircle()
        aiState = AI_STATES.MOVING

    elseif aiState == AI_STATES.MOVING and aiSelectedCircle then
        local target = selectBestTarget()
        if target then
            local dx = target.x - aiSelectedCircle.x
            local dy = target.y - aiSelectedCircle.y
            local dist = math.sqrt(dx * dx + dy * dy)

            if dist > aiSelectedCircle.radius * 2 then
                aiSelectedCircle.x = aiSelectedCircle.x + (dx / dist) * moveSpeed * dt
                aiSelectedCircle.y = aiSelectedCircle.y + (dy / dist) * moveSpeed * dt
            else
                aiState = AI_STATES.RELEASING
            end
        else
            aiState = AI_STATES.END_TURN
        end

    elseif aiState == AI_STATES.RELEASING then
        handleCollision(aiSelectedCircle)
        aiSelectedCircle.x, aiSelectedCircle.y = aiSelectedCircle.origX, aiSelectedCircle.origY
        aiState = AI_STATES.END_TURN

    elseif aiState == AI_STATES.END_TURN then
        currentPlayerIndex = 2
        aiState = AI_STATES.IDLE
    end
end

-- AI Selects the Best Hand to Play
function selectBestAICircle()
    local bestCircle = nil
    for _, circle in ipairs(players[1].circles) do
        if bestCircle == nil or circle.points > bestCircle.points then
            bestCircle = circle
        end
    end
    return bestCircle
end

-- AI Selects the Best Target (Prioritizes 4-Finger Hands)
-- TODO: implement split
function selectBestTarget()
    local bestTarget = nil
    for _, circle in ipairs(players[2].circles) do
        if circle.points == 4 then
            return circle -- Attack immediately if opponent has 4 fingers
        elseif bestTarget == nil or circle.points > bestTarget.points then
            bestTarget = circle
        end
    end
    return bestTarget
end

-- Handles collisions for AI
function handleCollision(circle)
    for _, otherPlayer in ipairs(players) do
        if players[currentPlayerIndex] ~= otherPlayer then -- Ensure different players
            for _, other in ipairs(otherPlayer.circles) do
                local dx = circle.x - other.x
                local dy = circle.y - other.y
                local distance = math.sqrt(dx * dx + dy * dy)
                if distance < circle.radius * 2 then
                    if other.points < 5 then
                        other.points = other.points + circle.points
                        if other.points >= 5 then
                            other.points = 0
                        end
                    end
                    return
                end
            end
        end
    end
end


function love.draw()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local centerX = screenWidth / 2
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(30)) -- Bigger font for better visibility

    if gameState == "menu" then
        love.graphics.printf("Click to Start", 0, screenHeight * 0.4, screenWidth, "center")
        return
    end

    if gameOver then
        love.graphics.printf(winner .. " wins!", 0, screenHeight * 0.35, screenWidth, "center")
        love.graphics.printf("Click to restart", 0, screenHeight * 0.42, screenWidth, "center")
        return
    end

    -- Show current turn at the top
    love.graphics.printf("Current Turn: " .. players[currentPlayerIndex].name, 50, screenHeight * 0.05, screenWidth, "left")

    for _, player in ipairs(players) do
        -- Display player name & score
        love.graphics.printf(player.name .. " (" .. player.score .. ")", 0, player.yLabel, screenWidth, "center")

        for _, circle in ipairs(player.circles) do
            -- Set color based on points
            love.graphics.setColor(colors[circle.points] or {1, 1, 1})
            love.graphics.circle("fill", circle.x, circle.y, circle.radius)

            -- Center the number/image inside the circle
            local img = images[circle.points] or images[0]
            if img then
                local imgWidth, imgHeight = img:getDimensions()
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(img, circle.x - imgWidth / 2, circle.y - imgHeight / 2, 0, 1, 1)
            end
        end
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if gameState == "menu" then
        gameState = "playing"
        return
    end
    
    if gameOver then
        resetGame()
        return
    end
    
    if button == 1 then -- Left mouse button
        for _, circle in ipairs(players[currentPlayerIndex].circles) do
            local dx = x - circle.x
            local dy = y - circle.y
            if dx * dx + dy * dy <= circle.radius * circle.radius then
                circle.dragging = true
                circle.offsetX = dx
                circle.offsetY = dy
                break
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 and not gameOver then
        local switchTurn = false
        local currentPlayer = players[currentPlayerIndex]

        for _, circle in ipairs(currentPlayer.circles) do
            if circle.dragging then
                for _, otherPlayer in ipairs(players) do
                    for _, other in ipairs(otherPlayer.circles) do
                        local dx = circle.x - other.x
                        local dy = circle.y - other.y
                        local distance = math.sqrt(dx * dx + dy * dy)

                        -- Handle attack (different players)
                        if players[currentPlayerIndex] ~= otherPlayer then
                            if distance < circle.radius * 2 then
                                if other.points < 5 then
                                    other.points = other.points + circle.points
                                    if other.points >= 5 then
                                        other.points = 0
                                    end
                                    switchTurn = true
                                end
                            end
                        end

                        -- Handle split (same player, only when touching own empty hand)
                        if players[currentPlayerIndex] == otherPlayer and distance < circle.radius * 2 then
                            local hand1, hand2 = currentPlayer.circles[1], currentPlayer.circles[2]

                            -- Check if the dragging hand has even points and is touching the empty hand
                            if circle.points > 0 and circle.points % 2 == 0 then
                                if hand1 == circle and hand2 == other and hand2.points == 0 then
                                    hand2.points = hand1.points / 2
                                    hand1.points = hand2.points
                                    switchTurn = true
                                elseif hand2 == circle and hand1 == other and hand1.points == 0 then
                                    hand1.points = hand2.points / 2
                                    hand2.points = hand1.points
                                    switchTurn = true
                                end
                            end
                        end                        
                    end
                end
                circle.x, circle.y = circle.origX, circle.origY
                circle.dragging = false
            end
        end

        for i, player in ipairs(players) do
            if player.circles[1].points == 0 and player.circles[2].points == 0 then
                gameOver = true
                local winningPlayer = players[(i % #players) + 1]
                winner = winningPlayer.name
                winningPlayer.score = winningPlayer.score + 1
                return
            end
        end

        if switchTurn then
            currentPlayerIndex = (currentPlayerIndex % #players) + 1
        end
    end
end


