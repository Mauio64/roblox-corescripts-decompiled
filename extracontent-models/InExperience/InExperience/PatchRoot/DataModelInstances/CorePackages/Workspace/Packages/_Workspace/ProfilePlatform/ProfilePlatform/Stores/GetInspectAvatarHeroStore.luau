local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(parent.Signals)

local createInspectAvatarHeroStore = require(script.createInspectAvatarHeroStore)

return Signals.createComputed(createInspectAvatarHeroStore)
