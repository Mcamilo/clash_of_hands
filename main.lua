function love.load()
    love.window.setTitle("Drag the Circles") -- Set window title
    love.window.setMode(1000, 800) -- Increased window size
    
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
    
    players = {
        {name = "Player 1", yLabel = 100, circles = {
            {x = 350, y = 200, origX = 350, origY = 200, radius = 130, dragging = false, offsetX = 0, offsetY = 0, points = 1},
            {x = 650, y = 200, origX = 650, origY = 200, radius = 130, dragging = false, offsetX = 0, offsetY = 0, points = 1}
        }},
        {name = "Player 2", yLabel = 700, circles = {
            {x = 350, y = 600, origX = 350, origY = 600, radius = 130, dragging = false, offsetX = 0, offsetY = 0, points = 1},
            {x = 650, y = 600, origX = 650, origY = 600, radius = 130, dragging = false, offsetX = 0, offsetY = 0, points = 1}
        }}
    }
    
    currentPlayerIndex = 1
end

function love.update(dt)
    for _, circle in ipairs(players[currentPlayerIndex].circles) do
        if circle.dragging then
            circle.x = love.mouse.getX() - circle.offsetX
            circle.y = love.mouse.getY() - circle.offsetY
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("Current Turn: " .. players[currentPlayerIndex].name, 0, 50, 1000, "center")
    for _, player in ipairs(players) do
        love.graphics.printf(player.name, 0, player.yLabel, 1000, "center")
        for _, circle in ipairs(player.circles) do
            love.graphics.setColor(colors[circle.points] or {1, 1, 1})
            love.graphics.circle("fill", circle.x, circle.y, circle.radius)
            
            local img = images[circle.points] or images[0]
            if img then
                local imgWidth, imgHeight = img:getDimensions()
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(img, circle.x - imgWidth / 2, circle.y - imgHeight / 2)
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
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
    if button == 1 then
        local switchTurn = false
        for _, circle in ipairs(players[currentPlayerIndex].circles) do
            if circle.dragging then
                for _, otherPlayer in ipairs(players) do
                    if players[currentPlayerIndex] ~= otherPlayer then -- Ensure circles belong to different players
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
        
        if switchTurn then
            currentPlayerIndex = (currentPlayerIndex % #players) + 1
        end
    end
end
