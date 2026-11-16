local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Signals = require(parent.Signals)

local createAvatarsTabSearchInfoStore = require(script.createAvatarsTabSearchInfoStore)

return Signals.createComputed(createAvatarsTabSearchInfoStore)
