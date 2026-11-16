local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(parent.Roact)

return (Roact.createContext(nil))
