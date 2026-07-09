local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Players = game:GetService("Players")
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local Game = require(ServerDrivenUiParent.DataHydration).Game
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)
local Localization = require(ServerDrivenUiParent.Localization)
local SduiChip = require(ServerDrivenUiParent.SduiSharedContent).SduiChip
local ToastRodux = require(ServerDrivenUiParent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local UniversalAppPolicy = require(ServerDrivenUiParent.UniversalAppPolicy)
local gameFollow = require(ServerDrivenUiParent.DiscoveryAnalytics).Events.gameFollow
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useOptimisticUpdateStatus = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useOptimisticUpdateStatus)

local function ExperienceDetailsNotifyChip(t1: {[any]: any}) -- line: 37
	-- upvalues: useDispatch (copy), SignalsReact (copy), Game (copy), useLocalization (copy), React (copy), Players (copy), gameFollow (copy), SetCurrentToastMessage (copy), ToastType (copy), useOptimisticUpdateStatus (copy), useAppPolicy (copy), SduiChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v24 = useDispatch()
	local v25 = SignalsReact.useSignalState(Game.getFollowingsStore(false).getAndFetchFollowing(universeId).data)
	local v26 = not not v25 and (v25.isFollowing or false)
	local v27 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v28 = v27 and v27.name or ""
	local v29 = useLocalization({
		notifications = "Feature.GameFollows.LabelNotifications",
		notificationsTurnedOn = {
			"Feature.GameFollows.TooltipTurnedOnNotifications",
			experienceName = v28
		},
		notificationsTurnedOff = {
			"Feature.GameFollows.TooltipTurnedOffNotifications",
			experienceName = v28
		}
	})
	local v30 = v27 and v27.rootPlaceId or nil
	local v31 = React.useCallback(function() -- line: 58
		-- upvalues: v26 (copy), v30 (copy), Players (copy), gameFollow (copy), Game (copy), universeId (copy)
		local v34 = not v26

		if v30 then
			local v35 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameFollow({
				ctx = "ExperienceDetailsNotifyChip",
				uid = tostring(v35),
				placeId = v30,
				state = not v34 and "off" or "on"
			}, "ExperienceDetailsNotifyChip")
		end

		return Game.getFollowingsStore(false).updateFollowing(universeId, v34)
	end, {
		universeId,
		v30,
		v26
	})
	local v32 = React.useCallback(function(p1) -- line: 74
		-- upvalues: v24 (copy), SetCurrentToastMessage (copy), ToastType (copy), v29 (copy)
		if not p1 then
			return
		end

		if p1.type == "error" then
			local s1 = "Feature.GameFollows.TooltipFollowLimitReached"

			if p1.errorType == "LimitReached" then
				s1 = "Feature.GameFollows.TooltipNotificationsLimitReached"
			elseif p1.errorType == "NetworkError" then
				s1 = "Feature.Toast.NetworkingError.SomethingIsWrong"
			end

			v24(SetCurrentToastMessage({
				toastType = if p1.errorType ~= "LimitReached" then ToastType.NetworkingError else ToastType.GameFollowError,
				toastMessage = s1
			}))

			return
		end

		if p1.type == "success" then
			if p1.isFollowing then
				v24(SetCurrentToastMessage({
					isLocalized = true,
					toastType = ToastType.NotificationsTurnedOn,
					toastMessage = v29.notificationsTurnedOn
				}))

				return
			end

			v24(SetCurrentToastMessage({
				isLocalized = true,
				toastType = ToastType.NotificationsTurnedOff,
				toastMessage = v29.notificationsTurnedOff
			}))
		end
	end, {
		v24,
		v28,
		v29
	})
	local v33 = useOptimisticUpdateStatus(v31, v32)

	if not useAppPolicy(function(p2) -- line: 112
		return p2.getNotificationsCanReceiveExperience()
	end) then
		return nil
	end

	return React.createElement(SduiChip, {
		text = v29.notifications,
		leadingIconName = Foundation.Enums.IconName.Bell,
		leadingIconVariant = if not v26 then nil else Foundation.Enums.IconVariant.Filled,
		onActivated = v33,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsNotifyChip)
