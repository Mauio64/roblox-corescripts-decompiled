local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local parent = SocialContextToasts.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local useStyle = UIBlox.Core.Style.useStyle
local Colors = UIBlox.App.Style.Colors
local Cryo = require(parent.Cryo)
local CoPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local NotificationsCommon = require(parent.NotificationsCommon)
local getLocalizedStrings = NotificationsCommon.LocalizationHelper.getLocalizedStrings
local SocialContextToastAnalyticsActionTypes = require(SocialContextToasts.Enums.SocialContextToastAnalyticsActionTypes)
local SocialContextToastEvents = require(SocialContextToasts.SocialContextToastEvents)

local vector2 = Vector2.new(48, 48)
local vector2_2 = Vector2.new(36, 36)

local function makeCoPlayFooter(userIdList, p, areUsersActive) -- 1 equivalent call inferred from this helper
	return function(p2)
		local v = p2.Size.X.Offset

		if #userIdList ~= 1 then
			v = (v - -9) / 2
		end

		return React.createElement(CoPlayFooter, {
			users = userIdList,
			size = p2.Size,
			faceGroupCount = 1,
			showEmphasisBorder = areUsersActive,
			styleProps = {
				faceWidth = v,
				faceHeight = v,
				faceGroupGap = -9,
				badgeHeight = v,
				badgeBorderColor = p.Theme.SystemPrimaryContent,
				faceBorderColor = p.Theme.SystemPrimaryContent,
				faceBackgroundColor = {
					Colors.Smoke,
					Transparency = 0
				},
				showEmphasisBorder = areUsersActive
			}
		})
	end
end

local v = { areUsersActive = true }

local function ToastWrapper(p)
	local joined = Cryo.Dictionary.join(v, p)

	local analyticsProps = joined.analyticsProps
	local v2 = React.useCallback(function()
		local friendId

		if joined.userIdList then
			friendId = table.concat(joined.userIdList)
		end

		SocialContextToastEvents(analyticsProps.eventIngest, {
			toastType = analyticsProps.toastType,
			friendId = friendId,
			universeId = analyticsProps.gameId,
			placeId = analyticsProps.placeId,
			actionType = SocialContextToastAnalyticsActionTypes.ForceDismissed
		})
	end)

	if joined.onActivated == nil then
		joined.onActivated = v2
	end

	local v3 = useStyle()
	local localizedStrings = getLocalizedStrings(joined.toastStrings)

	local userIdList = joined.userIdList
	local createElement = React.createElement
	local iconImage

	if userIdList then
		iconImage = makeCoPlayFooter(userIdList, v3, joined.areUsersActive) or nil -- inferred equivalent call
	end

	local toastContent = {
		iconImage = iconImage,
		toastTitle = localizedStrings.label,
		iconSize = 0,
		onActivated = 0,
		buttonText = 0,
		buttonType = 0,
		onTouchSwipeUp = 0
	}
	local iconSize

	if userIdList and #userIdList > 1 then
		iconSize = vector2
	else
		iconSize = vector2_2
	end

	toastContent.iconSize = iconSize
	toastContent.onActivated = joined.onActivated
	toastContent.buttonText = localizedStrings.button
	toastContent.buttonType = joined.buttonType
	toastContent.onTouchSwipeUp = v2
	return createElement(Toast, { duration = 6, toastContent = toastContent })
end

return ToastWrapper
