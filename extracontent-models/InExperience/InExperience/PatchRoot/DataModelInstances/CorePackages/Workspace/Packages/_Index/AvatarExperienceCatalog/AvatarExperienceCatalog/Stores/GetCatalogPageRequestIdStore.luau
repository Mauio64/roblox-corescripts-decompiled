local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Signals = require(parent.Signals)

local createCatalogPageRequestIdStore = require(script.createCatalogPageRequestIdStore)

return Signals.createComputed(createCatalogPageRequestIdStore)
