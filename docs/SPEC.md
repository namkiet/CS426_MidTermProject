# Specification — The Code Cup

## Requirements

### Screens

**1. Home Screen**
   - **UI:** Header Component, Bottom Navigation Bar, Loyalty Card View, Coffee List View
   - **Interaction:** Click "Coffee ListItem": Navigate to Details screen

**2. Details Screen**
   - **UI:** Product Customization controls (shot, size, ice); Cart Preview overlay
   - **Logic:** Dynamic Price Calculation: Total updates in real-time on quantity/options change
   - **Interaction:**
     - Click "Cart Icon": Show Cart Preview overlay
     - Click "Add to Cart Button": Persist item & navigate to My Cart
     - Click "Back Button": Return to Home Screen

**3. My Cart Screen**
   - **UI:** Cart Item Rendering (ListView reflecting selected customizations)
   - **Logic:** Total Price Display: Compute and show aggregate total
   - **Interaction:**
     - Click "Checkout Button": Navigate to Order Success screen
     - Swipe left "Cart Item": Remove item from cart

**4. Order Success Screen**
   - **UI:** Order success confirmation layout
   - **Interaction:** Click "Track My Order Button": Navigate to My Orders screen

**5. My Orders Screen**
   - **UI:** Two tabs "Ongoing" and "History"; order list filtered by active tab
   - **Interaction:**
     - Click "Ongoing Tab": Show only ongoing orders
     - Click "History Tab": Show only completed/past orders
     - Swipe left "Order Card": Toggle status between ongoing and history

**6. Rewards Screen**
   - **UI:** Points list display
   - **Logic:**
     - Loyalty Stamp Logic: +1 stamp per completed order, max 8
     - Points Calculation & Display: Award points by order value, show in list
     - Total Points Aggregation: Display sum of all accumulated points
   - **Interaction:**
     - Click "Loyalty Card": Reset stamps to 0 upon reaching 8
     - Click "Redeem Button": Navigate to Redeem Rewards screen

**7. Redeem Rewards**
   - **UI:** Product catalog with point costs
   - **Logic:** Points Redemption: Deduct selected item's cost from total points on confirmation
   - **Interaction:**
     - Click "Redeemable Item": Show confirmation dialog
     - Click "Confirm": Deduct points & record redemption

**8. Profile Screen**
   - **UI:** Profile layout
   - **Logic:** Profile Editing: Click "edit Icon" to toggle edit mode for modifying profile data

### General

**1.** State & Lifecycle Management (handle pause/resume/stop, preserve data across config changes)
**2.** Data Persistence & Seeding (SharedPreferences / Room / SQLite + initial seed data)
**3.** User-Defined Features (novel features beyond the document)
**4.** Code Quality, Report & Demo

---

## Business Rules

- Loyalty stamps: +1 per completed order, max 8. At 8 stamps, user may reset to 0.
- Reward points: 1 point per 10,000 VND of order value. Redeemable for products.
- Order lifecycle: An order is created as "ongoing". User can move it to "history" manually.
- Cart: Items persist with their customizations until removed or checked out.
- Price calculation: Total updates reactively when quantity or customization options change.

---

## Entities

**Product**
- Attributes: id (required, unique), name (required, non-empty), description (optional), basePrice (required, > 0), imageUrl (optional), availableCustomizations (required, { [type]: { [label]: delta } })

**CartItem**
- Attributes: product (required), selectedCustomizations (required, { [type]: label }), quantity (required, >= 1)
- Functions:
  - calculateSubtotal() = (basePrice + sum of customization deltas) × quantity

**Order**
- Attributes: id (required, unique), items (required, list of CartItem, non-empty), status (required, one of: ongoing / history), createdAt (required, auto-set)
- Functions:
  - calculateTotalPrice() = sum of items.calculateSubtotal()
  - calculatePointsEarned() = calculateTotalPrice() / 10,000

**LoyaltyCard**
- Attributes: stampCount (required, integer 0–8, default 0)

**RewardPoints**
- Attributes: balance (required, >= 0, default 0), transactions (list of Transaction)
- Functions:
  - calculateTotalEarned() = sum of transactions where type = earn

**Transaction**
- Attributes: type (required, earn / redeem), amount (required, > 0), createdAt (required, auto-set)
- Relationships: orderId (optional, references Order), redeemableItemId (optional, references RedeemableItem)

**RedeemableItem**
- Attributes: id (required, unique), name (required), pointCost (required, > 0), imageUrl (optional)

**UserProfile**
- Attributes: name (required, non-empty), email (required, valid format), phone (optional), avatarUrl (optional)

---

## Notes

- Currency: All prices are in VND.
- Target Platform: Android
- Source must be cleaned (remove temp/build files)

## Scoring

```
Score = Min(10, (Total + Additional Criteria) / 15)
```

Total is capped at **150** from all requirements above.
