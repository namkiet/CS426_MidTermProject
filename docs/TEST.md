# Tests — The Code Cup

Refer to [SPEC.md](SPEC.md) for the full specification this test suite covers.

Files: `lib/utils/format.dart` — shared `formatPrice()` / `formatDate()` used by all screens.

---

## Unit Tests

Unit tests cover all entities and logic in isolation. Each module/class/function is tested independently with mocked dependencies.

### Entities

**Product**
- Normal: Create product with valid name, price, and available customizations
- Normal: Calculate unit price from base price
- Normal: Calculate unit price with selected customization adjustments
- Edge: Product with zero or negative base price
- Edge: Product name with maximum length or special characters

**CartItem**
- Normal: Create cart item with product and selected customizations
- Normal: Update quantity
- Normal: Verify subtotal recalculates after quantity change
- Edge: Quantity set to zero or negative
- Edge: CartItem without any customizations selected

**Order**
- Normal: Create order from a list of cart items with correct total price
- Normal: Toggle order status from ongoing to history and back
- Normal: Timestamp recorded correctly on creation
- Edge: Order with empty items list
- Edge: Toggle an already-history order (idempotent)

**LoyaltyCard**
- Normal: Start with 0 stamps
- Normal: Increment stamps up to the maximum of 8
- Edge: Increment beyond 8 — no change
- Edge: Reset at exactly 8 stamps
- Edge: Reset when stamps are below 8 — no change

**RewardPoints**
- Normal: Award points based on order monetary value
- Normal: Deduct points on successful redemption
- Normal: Track earn transactions
- Normal: Track redeem transactions
- Normal: Verify transaction amounts are recorded correctly
- Normal: calculateTotalEarned() sums all earn transactions
- Edge: Redeem with insufficient balance — reject and keep balance unchanged
- Edge: Redeem with zero or negative points

**RedeemableItem**
- Normal: Create item with valid name and positive point cost
- Edge: Point cost set to zero or negative

**Transaction**
- Normal: Create earn transaction with amount and orderId
- Normal: Create redeem transaction with amount and redeemableItemId
- Normal: createdAt auto-set on creation
- Edge: Transaction with zero or negative amount

**UserProfile**
- Normal: Create profile with name, email, phone, avatar
- Normal: Update name
- Normal: Update email
- Normal: Update phone
- Normal: Update avatar
- Edge: Profile with empty fields
- Edge: Update email to invalid format

### Logic

**Dynamic Price Calculation**
- Normal: Compute total from base price alone
- Normal: Compute total with customization adjustments added
- Normal: Multiply by quantity for correct aggregate
- Normal: Update total in real-time when customization option changes
- Edge: Zero quantity produces zero total

**Total Price Display**
- Normal: Compute total for a single item
- Normal: Compute aggregate total for multiple items
- Normal: Recalculate total after an item is removed from cart
- Edge: Empty cart shows total of 0

**Points Calculation**
- Normal: Award correct points based on a given order monetary value
- Normal: Order.calculateTotalPrice() returns sum of all cart items
- Normal: Order.calculatePointsEarned() returns correct points from total price
- Edge: Zero-value order awards 0 points
- Edge: Very large order value (overflow check)

**Points Aggregation**
- Normal: Sum points from multiple earn transactions
- Normal: Deduct points on partial redemption
- Normal: Calculate remaining balance after partial redemption
- Edge: Balance of 0 returns 0
- Edge: Repeated redemptions deplete balance correctly

**Loyalty Stamp Logic**
- Normal: +1 stamp per completed order
- Normal: Stops incrementing at the max of 8
- Edge: Reset at 8 stamps
- Edge: Increment from empty loyalty card (first order)

---

## UI Tests

UI tests cover user interactions with screen components in isolation. Each interaction is tested with mocked state and navigation.

| Interaction | Tests |
|---|---|
| Add to Cart | Persist item with customizations; SnackBar confirmation; navigate to My Cart |
| Cart Preview | Navigate to My Cart screen |
| Cart Item Removal | Swipe left removes item from list; total recalculated |
| Checkout | Empty cart cannot checkout; cart cleared after successful checkout |
| My Orders | Two-tab layout (Ongoing/History); swipe left toggles status; empty state |
| Rewards | Points balance, Redeem button, loyalty card, empty transaction history |
| Redeem Rewards | Product catalog with point costs; disabled button when insufficient; confirm dialog deducts points |
| Profile Editing | Toggle edit mode; save changes; cancel discards changes |

---

## Integration Tests

File: `tests/unit/integration_test.dart`

Integration tests exercise real workflows spanning multiple entities without mocking:

| Workflow | Scenarios |
|---|---|
| **Add to Cart → Checkout → Order** | Add items, calculate totals, modify cart, empty cart rejected, order lifecycle |
| **Complete Order → Loyalty Stamps → Reward Points** | Award stamps & points on completion, 8-stamp reset, redeem & deduct, insufficient balance |
| **Loyalty Card Reset** | Reset only at 8 stamps, no-op below 8 |

---

## E2E Tests

**TODO**