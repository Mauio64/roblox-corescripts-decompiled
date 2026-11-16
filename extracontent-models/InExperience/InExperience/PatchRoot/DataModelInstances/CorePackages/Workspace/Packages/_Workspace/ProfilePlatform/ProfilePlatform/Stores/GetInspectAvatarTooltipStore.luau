local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(parent.Signals)

local createInspectAvatarTooltipStore = require(script.createInspectAvatarTooltipStore)

return Signals.createComputed(createInspectAvatarTooltipStore)
