# Clash of Hands

## Play the Game
You can play **Clash of Hands** on **Itch.io**:  
[https://matheus-camilo.itch.io/clash-of-hands](https://matheus-camilo.itch.io/clash-of-hands)

---

**Objective:**  
The goal is to **eliminate both of the opponent's hands** (i.e., make them have 5 or more fingers) before they do the same to you.

**Players:**  
Two players take turns—**Human vs. AI**.

---

## How to Play
1. **Starting Configuration:**
   - Each player starts with **two hands**, each showing **1 finger**.

2. **Player Actions (Per Turn):**
   - Choose **one of your hands** to tap **one of the opponent's hands**.
   - The number of fingers on your hand **adds** to the opponent's hand.
   - If a hand reaches **5 or more fingers**, it becomes **"dead"** and cannot be used.

3. **Splitting Mechanic:**
   - If you have only **one active hand** and its fingers are **even**, you may split the fingers evenly between both hands, reactivating the dead hand.

4. **Victory Condition:**
   - The game ends when **both hands of a player are dead**. The opponent wins.

---

## Game Flow
1. **Game Start:**
   - Each player begins with two hands, both set to 1 finger.
   - The starting player is chosen randomly.

2. **Turn Structure:**
   - The current player selects:
     1. One of their active hands.
     2. One of the opponent's active hands.
   - The number of fingers on the current player's hand is added to the opponent's hand.

3. **Check for Death:**
   - After a touch:
     - If any hand has **5 or more fingers**, it becomes **dead** and cannot be used further.

4. **Split Option:**
   - If a player has **one active hand** and its fingers are **even**, they may choose to **split** the fingers evenly, reviving the dead hand.

5. **Victory Check:**
   - If both hands of a player are dead, the opponent wins.

---

## Development
### Technologies Used
- **Game Engine:** [LÖVE (Love2D)](https://love2d.org/)
- **Programming Language:** Lua
- **Platform:** Windows, Linux, macOS

### Features
- Turn-based gameplay
- AI opponent
- Drag-and-drop mechanics
- Real-time hand interactions
- Win/loss detection system

---


