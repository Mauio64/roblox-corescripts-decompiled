local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local AvatarOneToOne = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/AvatarOneToOne")
local AvatarGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/AvatarGroup")

local v5 = { presenceIndicatorSize = 14 }

local function AvatarCircle(p2)
	local union = Cryo.Dictionary.union(p2, v5)

	if #union.thumbnails == 1 then
		return React.createElement(AvatarOneToOne, {
			circleColor3 = union.circleColor3,
			circleDividerColor3 = union.circleDividerColor3,
			circleDividerTransparency = union.circleDividerTransparency,
			circleInteriorBackgroundColor3 = union.circleInteriorBackgroundColor3,
			circleInteriorBackgroundTransparency = union.circleInteriorBackgroundTransparency,
			circleTransparency = union.circleTransparency,
			onActivated = union.onActivated,
			overlaySize = union.overlaySize,
			presenceImage = union.presenceImage,
			presenceImageColor3 = union.presenceImageColor3,
			presenceImageTransparency = union.presenceImageTransparency,
			presenceIndicatorSize = union.presenceIndicatorSize,
			selectable = union.selectable,
			showNewPresenceImage = union.showNewPresenceImage,
			thumbnail = union.thumbnails[1]
		})
	end

	return React.createElement(AvatarGroup, {
		circleColor3 = union.circleColor3,
		circleDividerColor3 = union.circleDividerColor3,
		circleDividerTransparency = union.circleDividerTransparency,
		circleInteriorBackgroundColor3 = union.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = union.circleInteriorBackgroundTransparency,
		circleTransparency = union.circleTransparency,
		onActivated = union.onActivated,
		overlaySize = union.overlaySize,
		selectable = union.selectable,
		thumbnails = union.thumbnails
	})
end

return AvatarCircle
