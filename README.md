# Clash of Hands

**Objective:**
The goal is to "kill" both of the opponent's hands (i.e., make them have 5 or more fingers) before they do the same to you.

**Players:**
Two players take turns.

---

## Game Rules
1. **Starting Configuration:**
   - Each player starts with two hands, each showing **1 finger**.

2. **Player Actions:**
   - On their turn, a player can choose one of their hands to touch one of the opponent's hands. 
   - The number of fingers on the player's chosen hand is added to the number of fingers on the opponent's chosen hand.
   - If the sum equals 5 or more, the opponent's hand "dies" and can no longer be used.

3. **Reactivation Rule:**
   - If a player has only one active hand and the total number of fingers on that hand is **even**, they may split the fingers evenly between their two hands, "reviving" the dead hand.

4. **Victory Condition:**
   - The game ends when both hands of one player are dead. The opponent wins.

---

## Game Flow
1. **Initialization:**
   - Each player starts with two hands, both set to 1 finger.
   - Player 1 begins the game.

2. **Turn Structure:**
   - The current player selects:
     1. One of their active hands.
     2. One of the opponent's active hands.
   - The number of fingers on the current player's hand is added to the opponent's hand.

3. **Check for Death:**
   - After a touch:
     - If any hand has 5 or more fingers, it is considered dead and cannot be used further.

4. **Split Option:**
   - If a player has one hand remaining and its fingers are even, they may choose to split the fingers evenly between their two hands, reactivating the dead hand.

5. **Victory Check:**
   - If both hands of a player are dead, the opponent wins.

---

## Game Design Details
### **1. UI/UX:**
- **Player Hands:**
  - Show each player's hands visually with fingers displayed (e.g., small hand icons or counters).
  - Dead hands should be grayed out or crossed out to indicate they can't be used.
- **Action Selection:**
  - On a player's turn:
    - Highlight the active hands they can use.
    - Highlight the opponent's hands they can target.
- **Victory Screen:**
  - Display a message like: "Player X Wins!" when the game ends.

### **2. Backend Logic:**
- **Game State Variables:**
  - `player1_hands` and `player2_hands`: Arrays storing the number of fingers on each hand (e.g., `[1, 1]`).
  - `player_turn`: Tracks whose turn it is (Player 1 or Player 2).

- **Core Functions:**
  1. **`touch_hand(from_hand, to_hand)`**
     - Adds the fingers from `from_hand` to `to_hand`.
     - Checks if `to_hand` has 5 or more fingers and marks it as dead if necessary.
  2. **`split_hand(player)`**
     - Splits the fingers of the remaining hand into two hands if the condition is met (one hand with an even number of fingers).
  3. **`check_victory()`**
     - Checks if both hands of a player are dead to declare the winner.

---

## Development Plan
### **1. Prototype the Core Mechanics**
- Implement the basic logic for the touch mechanic and hand death.
- Test interactions to ensure the rules work correctly.

### **2. Add Splitting Logic**
- Implement the splitting rule for reactivating hands.
- Ensure it only triggers under the correct conditions (one hand, even fingers).

### **3. Create the Visuals**
- Design a simple interface with:
  - Two players and their hands.
  - Buttons or click events for selecting actions.

### **4. Add Turn System**
- Ensure players alternate turns.
- Highlight the current player's active options.

### **5. Endgame and Victory Conditions**
- Check for the victory condition at the end of each turn.
- Display the winner and reset/restart option.

---

## Tools and Technologies
- **Frontend Framework:** Use a browser-friendly tool like:
  - **HTML/CSS/JavaScript** (with or without libraries like React.js).
- **Game Logic:** Use JavaScript to handle game state and interactions.
- **Optional Enhancements:**
  - Animations for hand touches.
  - Sound effects for touches and splits.

---

Would you like to get started with the implementation? Let me know if you need help setting up the code structure or any specific part of the game!
