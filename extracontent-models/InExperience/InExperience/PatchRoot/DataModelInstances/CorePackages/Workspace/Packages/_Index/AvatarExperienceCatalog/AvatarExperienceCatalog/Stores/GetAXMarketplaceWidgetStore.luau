local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Signals = require(parent.Signals)

local createAXMarketplaceWidgetStore = require(script.createAXMarketplaceWidgetStore)

return Signals.createComputed(createAXMarketplaceWidgetStore)
