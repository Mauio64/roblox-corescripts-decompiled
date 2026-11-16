local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)

local SduiSharedContent = require(parent.SduiSharedContent)
local SduiChip = SduiSharedContent.SduiChip

local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameFollow = DiscoveryAnalytics.Events.gameFollow

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local useOptimisticUpdateStatus = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useOptimisticUpdateStatus)

local function ExperienceDetailsNotifyChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId

	local v = useDispatch()

	local v2 = SignalsReact.useSignalState(Game.getFollowingsStore(false).getAndFetchFollowing(universeId).data)
	local isFollowing = v2 and v2.isFollowing or false

	local v3 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local name = v3 and v3.name or ""

	local v4 = useLocalization({
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

	local rootPlaceId = v3 and v3.rootPlaceId or nil

	local onActivated = useOptimisticUpdateStatus(React.useCallback(function()
		local v5 = not isFollowing

		if rootPlaceId then
			local v6 = {
				uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
				placeId = rootPlaceId,
				state = v5 and "on" or "off",
				ctx = "ExperienceDetailsNotifyChip",
				universeId = 0
			}
			local universeId2

			if FFlagLuaAppAddUniverseIdToEngagementEvents then
				universeId2 = universeId
			end

			v6.universeId = universeId2
			gameFollow(v6, "ExperienceDetailsNotifyChip")
		end

		return Game.getFollowingsStore(false).updateFollowing(universeId, v5)
	end, { universeId, rootPlaceId, isFollowing }), (React.useCallback(function(data)
		if not data then
			return
		end

		if data.type == "error" then
			local toastMessage = data.errorType == "LimitReached"
				and "Feature.GameFollows.TooltipNotificationsLimitReached"
				or data.errorType == "NetworkError" and "Feature.Toast.NetworkingError.SomethingIsWrong"
				or "Feature.GameFollows.TooltipFollowLimitReached"
			local toastType

			if data.errorType == "LimitReached" then
				toastType = ToastType.GameFollowError
			else
				toastType = ToastType.NetworkingError
			end

			v(SetCurrentToastMessage({ toastType = toastType, toastMessage = toastMessage }))
		elseif data.type == "success" then
			if data.isFollowing then
				v(SetCurrentToastMessage({
					toastType = ToastType.NotificationsTurnedOn,
					toastMessage = v4.notificationsTurnedOn,
					isLocalized = true
				}))
			else
				v(SetCurrentToastMessage({
					toastType = ToastType.NotificationsTurnedOff,
					toastMessage = v4.notificationsTurnedOff,
					isLocalized = true
				}))
			end
		end
	end, { v, name, v4 })))

	if not useAppPolicy(function(p2)
		return p2.getNotificationsCanReceiveExperience()
	end) then
		return nil
	end

	local createElement = React.createElement
	local v5 = {
		text = v4.notifications,
		leadingIconName = Foundation.Enums.IconName.Bell,
		leadingIconVariant = 0,
		onActivated = 0,
		layoutOrder = 0
	}
	local leadingIconVariant

	if isFollowing then
		leadingIconVariant = Foundation.Enums.IconVariant.Filled
	end

	v5.leadingIconVariant = leadingIconVariant
	v5.onActivated = onActivated
	v5.layoutOrder = layoutOrder
	return createElement(SduiChip, v5)
end

return React.memo(ExperienceDetailsNotifyChip)
