local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local AXTooltip = require(Parent.AvatarExperienceUIKit).AXTooltipComponents.AXTooltip
local useAXTooltipViewModel = require(script.Parent.useAXTooltipViewModel)

return function(p1) -- line: 12
	-- upvalues: useAXTooltipViewModel (copy), React (copy), AXTooltip (copy)
	local v6 = useAXTooltipViewModel(p1)

	return React.createElement(AXTooltip, v6)
end
