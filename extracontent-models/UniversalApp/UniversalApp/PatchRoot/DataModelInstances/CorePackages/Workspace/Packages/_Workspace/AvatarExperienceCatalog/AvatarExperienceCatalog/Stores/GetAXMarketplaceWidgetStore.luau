local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Signals = require(Parent.Signals)
local createAXMarketplaceWidgetStore = require(script.createAXMarketplaceWidgetStore)

return Signals.createComputed(createAXMarketplaceWidgetStore)
