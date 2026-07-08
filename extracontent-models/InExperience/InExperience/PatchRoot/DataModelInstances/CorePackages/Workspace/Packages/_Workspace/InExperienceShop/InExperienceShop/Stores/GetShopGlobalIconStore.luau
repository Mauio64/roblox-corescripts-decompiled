local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local Signals = require(Parent.Signals)
local createShopGlobalIconStore = require(script.createShopGlobalIconStore)

return Signals.createComputed(createShopGlobalIconStore)
