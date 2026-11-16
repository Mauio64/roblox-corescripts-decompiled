local parent = script:FindFirstAncestor("InExperienceShop").Parent
local Signals = require(parent.Signals)
local createShopGlobalIconStore = require(script.createShopGlobalIconStore)

return Signals.createComputed(createShopGlobalIconStore)
