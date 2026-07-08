local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Signals = require(InExperienceShopParent.Signals)
local createInExperienceShopStore = require(InExperienceShop.Stores.createInExperienceShopStore)

return Signals.createComputed(createInExperienceShopStore)
