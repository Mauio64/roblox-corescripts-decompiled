local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local AXTooltip = AvatarExperienceUIKit.AXTooltipComponents.AXTooltip

local useAXTooltipViewModel = require(script.Parent.useAXTooltipViewModel)

return function(p)
	local v = useAXTooltipViewModel(p)
	return React.createElement(AXTooltip, v)
end
