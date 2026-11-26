local Players = game:GetService("Players")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Game = DataHydration.Game
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").localizeStrings

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local gameFollow = DiscoveryAnalytics.Events.gameFollow
local getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFollowAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceFollow,
				message = "Missing action params"
			},
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId
	local gameName = actionParams.gameName or ""

	if universeId == nil or typeof(universeId) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceFollow,
				message = "Missing universeId"
			},
			data.appPage
		)
		return
	end

	local placeId = actionParams.placeId
	local ctx = actionParams.ctx or ""

	local followingsStore = Game.getFollowingsStore(false)
	local data2 = followingsStore.getAndFetchFollowing(universeId).data(false)
	local v5 = not (data2 and data2.isFollowing)

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
	gameFollow({
		uid = tostring(userId),
		placeId = tostring(placeId),
		state = v5 and "on" or "off",
		ctx = ctx,
		universeId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
	}, ctx)

	local v9 = followingsStore.updateFollowing(universeId, v5)
	local localization = data.dependencies.localization

	local v10 = {}
	v10.dispose = Signals.createEffect(function(p5)
		local v11 = v9(p5)

		if v11 == nil then
			return
		end

		local configKey = data.configKey

		if v11.type == "error" then
			if configKey then
				local formatted = localization:Format(v11.errorType == "LimitReached" and "Feature.GameFollows.TooltipNotificationsLimitReached" or "Feature.Toast.NetworkingError.SomethingIsWrong")
				getSduiPageEntrySnackbarStore().show(configKey, {
					title = formatted,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v11.type == "success" and configKey then
			local v12 = localizeStrings(localization, {
				notificationsTurnedOn = {
					"Feature.GameFollows.TooltipTurnedOnNotifications",
					experienceName = gameName
				},
				notificationsTurnedOff = {
					"Feature.GameFollows.TooltipTurnedOffNotifications",
					experienceName = gameName
				}
			})

			local v13 = if v11.isFollowing then v12.notificationsTurnedOn else v12.notificationsTurnedOff

			local show = getSduiPageEntrySnackbarStore().show

			local v15 = if v11.isFollowing then Foundation.Enums.IconName.Bell else Foundation.Enums.IconName.BellSlash
			show(configKey, { title = v13, icon = v15 })
		end

		local dispose = v10.dispose

		if dispose then
			dispose()
			v10.dispose = nil
		end
	end)
end

return SduiToggleExperienceFollowAction
