local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Signals = require(parent.Signals)

local createAXTooltipStore = require(script.createAXTooltipStore)

return Signals.createComputed(createAXTooltipStore)
