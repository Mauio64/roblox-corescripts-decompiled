local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local axTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").AXTooltipComponents.AXTooltip

local useAXTooltipViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AXTooltip/useAXTooltipViewModel")

return function(p2)
	local v5 = useAXTooltipViewModel(p2)
	return React.createElement(axTooltip, v5)
end
