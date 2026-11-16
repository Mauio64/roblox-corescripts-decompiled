local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)

local createInExperienceShopStore = require(InExperienceShop.Stores.createInExperienceShopStore)

return Signals.createComputed(createInExperienceShopStore)
