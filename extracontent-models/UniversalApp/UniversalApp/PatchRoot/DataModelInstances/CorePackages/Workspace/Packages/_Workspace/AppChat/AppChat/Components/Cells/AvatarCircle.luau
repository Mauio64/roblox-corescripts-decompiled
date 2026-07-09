local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local AvatarOneToOne = require(script.AvatarOneToOne)
local AvatarGroup = require(script.AvatarGroup)
local t1 = {
	presenceIndicatorSize = 14
}

local function AvatarCircle(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), React (copy), AvatarOneToOne (copy), AvatarGroup (copy)
	local v9 = Cryo.Dictionary.union(t2, t1)

	if #v9.thumbnails == 1 then
		return React.createElement(AvatarOneToOne, {
			circleColor3 = v9.circleColor3,
			circleDividerColor3 = v9.circleDividerColor3,
			circleDividerTransparency = v9.circleDividerTransparency,
			circleInteriorBackgroundColor3 = v9.circleInteriorBackgroundColor3,
			circleInteriorBackgroundTransparency = v9.circleInteriorBackgroundTransparency,
			circleTransparency = v9.circleTransparency,
			onActivated = v9.onActivated,
			overlaySize = v9.overlaySize,
			presenceImage = v9.presenceImage,
			presenceImageColor3 = v9.presenceImageColor3,
			presenceImageTransparency = v9.presenceImageTransparency,
			presenceIndicatorSize = v9.presenceIndicatorSize,
			selectable = v9.selectable,
			showNewPresenceImage = v9.showNewPresenceImage,
			thumbnail = v9.thumbnails[1]
		})
	end

	return React.createElement(AvatarGroup, {
		circleColor3 = v9.circleColor3,
		circleDividerColor3 = v9.circleDividerColor3,
		circleDividerTransparency = v9.circleDividerTransparency,
		circleInteriorBackgroundColor3 = v9.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = v9.circleInteriorBackgroundTransparency,
		circleTransparency = v9.circleTransparency,
		onActivated = v9.onActivated,
		overlaySize = v9.overlaySize,
		selectable = v9.selectable,
		thumbnails = v9.thumbnails
	})
end

return AvatarCircle
