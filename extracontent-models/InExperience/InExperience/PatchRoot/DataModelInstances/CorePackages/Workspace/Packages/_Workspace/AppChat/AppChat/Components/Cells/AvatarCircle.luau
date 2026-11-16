local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local AvatarOneToOne = require(script.AvatarOneToOne)
local AvatarGroup = require(script.AvatarGroup)

local v = { presenceIndicatorSize = 14 }

local function AvatarCircle(p)
	local union = Cryo.Dictionary.union(p, v)

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
