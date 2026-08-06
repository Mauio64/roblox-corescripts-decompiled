local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local Signals = require(Parent.Signals)
local createInspectAvatarTooltipStore = require(script.createInspectAvatarTooltipStore)

return Signals.createComputed(createInspectAvatarTooltipStore)
