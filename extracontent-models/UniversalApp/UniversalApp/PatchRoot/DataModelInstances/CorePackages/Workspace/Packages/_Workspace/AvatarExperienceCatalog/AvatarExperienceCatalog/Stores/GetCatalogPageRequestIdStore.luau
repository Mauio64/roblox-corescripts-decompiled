local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Signals = require(Parent.Signals)
local createCatalogPageRequestIdStore = require(script.createCatalogPageRequestIdStore)

return Signals.createComputed(createCatalogPageRequestIdStore)
