local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local SocialContextToastsParent = SocialContextToasts.Parent
local React = require(SocialContextToastsParent.React)
local UIBlox = require(SocialContextToastsParent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local useStyle = UIBlox.Core.Style.useStyle
local Colors = UIBlox.App.Style.Colors
local Cryo = require(SocialContextToastsParent.Cryo)
local CoPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local getLocalizedStrings = require(SocialContextToastsParent.NotificationsCommon).LocalizationHelper.getLocalizedStrings
local SocialContextToastAnalyticsActionTypes = require(SocialContextToasts.Enums.SocialContextToastAnalyticsActionTypes)
local SocialContextToastEvents = require(SocialContextToasts.SocialContextToastEvents)
local GetFFlagSocialContextToastEventStream = require(SocialContextToastsParent.SharedFlags).GetFFlagSocialContextToastEventStream
local vector2 = Vector2.new(48, 48)
local vector2_2 = Vector2.new(36, 36)

local function makeCoPlayFooter(p1, p2, p3) -- line: 34
	-- upvalues: React (copy), CoPlayFooter (copy), Colors (copy)
	return function(p4) -- line: 35
		-- upvalues: p1 (copy), React (copy), CoPlayFooter (copy), p3 (copy), p2 (copy), Colors (copy)
		local XOffset = p4.Size.X.Offset
		local v38 = if #p1 ~= 1 then (XOffset - -9) / 2 else XOffset

		return React.createElement(CoPlayFooter, {
			faceGroupCount = 1,
			users = p1,
			size = p4.Size,
			showEmphasisBorder = p3,
			styleProps = {
				faceGroupGap = -9,
				faceWidth = v38,
				faceHeight = v38,
				badgeHeight = v38,
				badgeBorderColor = p2.Theme.SystemPrimaryContent,
				faceBorderColor = p2.Theme.SystemPrimaryContent,
				faceBackgroundColor = {
					Colors.Smoke,
					Transparency = 0
				},
				showEmphasisBorder = p3
			}
		})
	end
end

local t1 = {
	areUsersActive = true
}

local function ToastWrapper(t2: {[any]: any}) -- line: 62
	-- upvalues: Cryo (copy), t1 (copy), GetFFlagSocialContextToastEventStream (copy), React (copy), SocialContextToastEvents (copy), SocialContextToastAnalyticsActionTypes (copy), useStyle (copy), getLocalizedStrings (copy), Toast (copy), CoPlayFooter (copy), Colors (copy), vector2 (copy), vector2_2 (copy)
	local v23 = Cryo.Dictionary.join(t1, t2)
	local v24 = nil
	local g35 = nil
	local v34 = nil

	if GetFFlagSocialContextToastEventStream() then
		local analyticsProps = v23.analyticsProps

		v24 = React.useCallback(function() -- line: 68
			-- upvalues: v23 (copy), SocialContextToastEvents (copy), analyticsProps (copy), SocialContextToastAnalyticsActionTypes (copy)
			local v39 = nil

			if v23.userIdList then
				v39 = table.concat(v23.userIdList)
			end

			SocialContextToastEvents(analyticsProps.eventIngest, {
				toastType = analyticsProps.toastType,
				friendId = v39,
				universeId = analyticsProps.gameId,
				placeId = analyticsProps.placeId,
				actionType = SocialContextToastAnalyticsActionTypes.ForceDismissed
			})
		end)
	end

	if v23.onActivated == nil then
		if GetFFlagSocialContextToastEventStream() then
			v23.onActivated = v24
		else
			function v23.onActivated() -- line: 89
			end
		end
	end

	local v26 = useStyle()
	local v27 = getLocalizedStrings(v23.toastStrings)
	local userIdList = v23.userIdList
	local createElement = React.createElement
	local v30 = Toast
	local t3 = {
		duration = 6
	}
	local t4 = {}

	if userIdList then
		local areUsersActive = v23.areUsersActive

		function v34(p5) -- line: 35
			-- upvalues: userIdList (copy), React (copy), CoPlayFooter (copy), areUsersActive (copy), v26 (copy), Colors (copy)
			local XOffset = p5.Size.X.Offset
			local v42 = if #userIdList ~= 1 then (XOffset - -9) / 2 else XOffset

			return React.createElement(CoPlayFooter, {
				faceGroupCount = 1,
				users = userIdList,
				size = p5.Size,
				showEmphasisBorder = areUsersActive,
				styleProps = {
					faceGroupGap = -9,
					faceWidth = v42,
					faceHeight = v42,
					badgeHeight = v42,
					badgeBorderColor = v26.Theme.SystemPrimaryContent,
					faceBorderColor = v26.Theme.SystemPrimaryContent,
					faceBackgroundColor = {
						Colors.Smoke,
						Transparency = 0
					},
					showEmphasisBorder = areUsersActive
				}
			})
		end

		if v34 then
			g35 = true
		end
	end

	if not g35 then
		v34 = nil
	end

	g35 = false
	t4.iconImage = v34
	t4.toastTitle = v27.label
	t4.iconSize = if not userIdList or not (#userIdList > 1) then vector2_2 else vector2
	t4.onActivated = v23.onActivated
	t4.buttonText = v27.button
	t4.buttonType = v23.buttonType
	t4.onTouchSwipeUp = if not GetFFlagSocialContextToastEventStream() then nil else v24
	t3.toastContent = t4

	return createElement(v30, t3)
end

return ToastWrapper
