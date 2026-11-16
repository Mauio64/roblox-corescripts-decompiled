local Players = game:GetService("Players")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Game = DataHydration.Game
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local gameFavorite = DiscoveryAnalytics.Events.gameFavorite
local getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFavoriteAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceFavorite,
				message = "Missing action params"
			},
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil or typeof(universeId) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceFavorite,
				message = "Missing universeId"
			},
			data.appPage
		)
		return
	end

	local placeId = actionParams.placeId
	local ctx = actionParams.ctx or ""

	local favoritesStore = Game.getFavoritesStore(false)
	local data2 = favoritesStore.getAndFetchFavorite(universeId).data(false)
	local v6 = data2 == nil or not data2.isFavorited

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
	gameFavorite({
		uid = tostring(userId),
		ctx = ctx,
		placeId = tostring(placeId),
		state = v6 and "on" or "off",
		targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
	}, ctx)

	local v10 = favoritesStore.updateFavorite(universeId, v6)

	local v11 = {}
	v11.dispose = Signals.createEffect(function(p5)
		local v12 = v10(p5)

		if v12 == nil then
			return
		end

		local configKey = v12.type == "error" and data.configKey

		if configKey then
			local formatted = data.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")
			getSduiPageEntrySnackbarStore().show(configKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.TriangleExclamation
			})
		end

		local dispose = v11.dispose

		if dispose then
			dispose()
			v11.dispose = nil
		end
	end)
end

return SduiToggleExperienceFavoriteAction
