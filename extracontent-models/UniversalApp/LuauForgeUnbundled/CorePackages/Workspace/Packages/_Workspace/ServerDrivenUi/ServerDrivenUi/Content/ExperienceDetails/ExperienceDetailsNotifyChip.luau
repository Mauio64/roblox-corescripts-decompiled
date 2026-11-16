local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")

local sduiChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiChip

local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ToastRodux")
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy")
local gameFollow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameFollow

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local useOptimisticUpdateStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/Hooks/useOptimisticUpdateStatus")

local function ExperienceDetailsNotifyChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId

	local v5 = useDispatch()

	local v6 = SignalsReact.useSignalState(Game.getFollowingsStore(false).getAndFetchFollowing(universeId).data)
	local isFollowing = v6 and v6.isFollowing or false

	local v7 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local name = v7 and v7.name or ""

	local v8 = useLocalization({
		notifications = "Feature.GameFollows.LabelNotifications",
		notificationsTurnedOn = {
			"Feature.GameFollows.TooltipTurnedOnNotifications",
			experienceName = name
		},
		notificationsTurnedOff = {
			"Feature.GameFollows.TooltipTurnedOffNotifications",
			experienceName = name
		}
	})

	local rootPlaceId = v7 and v7.rootPlaceId or nil

	local v11 = useOptimisticUpdateStatus(React.useCallback(function()
		local v10 = not isFollowing

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameFollow({
				uid = tostring(userId),
				placeId = rootPlaceId,
				state = v10 and "on" or "off",
				ctx = "ExperienceDetailsNotifyChip",
				universeId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
			}, "ExperienceDetailsNotifyChip")
		end

		return Game.getFollowingsStore(false).updateFollowing(universeId, v10)
	end, { universeId, rootPlaceId, isFollowing }), (React.useCallback(function(data)
		if not data then
			return
		end

		if data.type == "error" then
			local v11 = data.errorType == "LimitReached"
				and "Feature.GameFollows.TooltipNotificationsLimitReached"
				or data.errorType == "NetworkError" and "Feature.Toast.NetworkingError.SomethingIsWrong"
				or "Feature.GameFollows.TooltipFollowLimitReached"

			local v15 = if data.errorType == "LimitReached" then toastType.GameFollowError else toastType.NetworkingError
			v5(setCurrentToastMessage({ toastType = v15, toastMessage = v11 }))
		elseif data.type == "success" then
			if data.isFollowing then
				v5(setCurrentToastMessage({
					toastType = toastType.NotificationsTurnedOn,
					toastMessage = v8.notificationsTurnedOn,
					isLocalized = true
				}))
			else
				v5(setCurrentToastMessage({
					toastType = toastType.NotificationsTurnedOff,
					toastMessage = v8.notificationsTurnedOff,
					isLocalized = true
				}))
			end
		end
	end, { v5, name, v8 })))

	if not useAppPolicy(function(p3)
		return p3.getNotificationsCanReceiveExperience()
	end) then
		return nil
	end

	local createElement = React.createElement
	local v13 = {
		text = v8.notifications,
		leadingIconName = Foundation.Enums.IconName.Bell,
		leadingIconVariant = 0,
		onActivated = 0,
		layoutOrder = 0
	}
	local v14 = if isFollowing then Foundation.Enums.IconVariant.Filled else nil
	v13.leadingIconVariant = v14
	v13.onActivated = v11
	v13.layoutOrder = layoutOrder
	return createElement(sduiChip, v13)
end

return React.memo(ExperienceDetailsNotifyChip)
