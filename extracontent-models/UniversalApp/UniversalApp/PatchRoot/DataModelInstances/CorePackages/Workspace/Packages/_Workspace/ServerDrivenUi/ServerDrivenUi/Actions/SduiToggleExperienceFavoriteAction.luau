local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local DataHydration = require(Parent.DataHydration)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Foundation = require(Parent.Foundation)
local Game = DataHydration.Game
local Signals = require(Parent.Signals)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local gameFavorite = DiscoveryAnalytics.Events.gameFavorite
local getSduiPageEntrySnackbarStore = require(Parent.SduiSharedUtilities).getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFavoriteAction(p1, _, p3, _) -- line: 23
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Game (copy), Players (copy), gameFavorite (copy), Signals (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy)
	local v18 = p1 and p1.actionParams or nil

	if v18 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.ToggleExperienceFavorite
		}, p3.appPage)

		return
	end

	local universeId = v18.universeId

	if universeId == nil or typeof(universeId) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing universeId",
			name = SduiActionType.ToggleExperienceFavorite
		}, p3.appPage)

		return
	end

	local placeId = v18.placeId
	local v21 = v18.ctx or ""
	local v22 = Game.getFavoritesStore(false)
	local v23 = v22.getAndFetchFavorite(universeId).data(false)
	local v24 = not (v23 ~= nil and v23.isFavorited)
	local v25 = Players.LocalPlayer and Players.LocalPlayer.UserId

	gameFavorite({
		uid = tostring(v25),
		ctx = v21,
		placeId = tostring(placeId),
		state = not v24 and "off" or "on"
	}, v21)

	local v26 = v22.updateFavorite(universeId, v24)
	local t1 = {}

	t1.dispose = Signals.createEffect(function(p5) -- line: 67
		-- upvalues: v26 (copy), p3 (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), t1 (copy)
		local v29 = v26(p5)

		if v29 == nil then
			return
		end

		if v29.type == "error" then
			local configKey = p3.configKey

			if configKey then
				local v31 = p3.dependencies.localization:Format("Feature.Toast.NetworkingError.SomethingIsWrong")

				getSduiPageEntrySnackbarStore().show(configKey, {
					title = v31,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		end

		local dispose = t1.dispose

		if dispose then
			dispose()
			t1.dispose = nil
		end
	end)
end

return SduiToggleExperienceFavoriteAction
