local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Signals = require(Parent.Signals)
local createAXTooltipStore = require(script.createAXTooltipStore)

return Signals.createComputed(createAXTooltipStore)
