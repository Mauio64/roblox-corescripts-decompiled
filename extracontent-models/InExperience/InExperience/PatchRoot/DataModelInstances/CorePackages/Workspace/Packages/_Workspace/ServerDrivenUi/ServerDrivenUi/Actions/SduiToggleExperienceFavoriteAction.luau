local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local Game = DataHydration.Game
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local gameFavorite = DiscoveryAnalytics.Events.gameFavorite
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFavoriteAction(p, _, data, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ToggleExperienceFavorite, message = "Missing action params" },
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil or typeof(universeId) ~= "string" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ToggleExperienceFavorite, message = "Missing universeId" },
			data.appPage
		)
		return
	end

	local placeId = actionParams.placeId
	local ctx = actionParams.ctx or ""

	local favoritesStore = Game.getFavoritesStore(false)
	local data2 = favoritesStore.getAndFetchFavorite(universeId).data(false)
	local v = data2 == nil or not data2.isFavorited

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
	local v2 = {
		uid = tostring(userId),
		ctx = ctx,
		placeId = tostring(placeId),
		state = v and "on" or "off",
		targetId = 0
	}
	local targetId

	if FFlagLuaAppAddUniverseIdToEngagementEvents then
		targetId = universeId
	end

	v2.targetId = targetId
	gameFavorite(v2, ctx)

	local v3 = favoritesStore.updateFavorite(universeId, v)

	local v4 = {}
	v4.dispose = Signals.createEffect(function(p2)
		local v5 = v3(p2)

		if v5 == nil then
			return
		end

		local configKey = v5.type == "error" and data.configKey

		if configKey then
			local formatted = data.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")
			getSduiPageEntrySnackbarStore().show(configKey, {
				title = formatted,
				icon = Foundation.Enums.IconName.TriangleExclamation
			})
		end

		local dispose = v4.dispose

		if dispose then
			dispose()
			v4.dispose = nil
		end
	end)
end

return SduiToggleExperienceFavoriteAction
