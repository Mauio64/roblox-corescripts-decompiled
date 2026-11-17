local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(parent.Signals)

local createInspectAvatarSpinIntroStore = require(script.createInspectAvatarSpinIntroStore)

return Signals.createComputed(createInspectAvatarSpinIntroStore)
