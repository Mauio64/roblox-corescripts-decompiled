local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local DataHydration = require(Parent.DataHydration)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Foundation = require(Parent.Foundation)
local Game = DataHydration.Game
local Signals = require(Parent.Signals)
local localizeStrings = require(Parent.Localization).localizeStrings
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local gameFollow = DiscoveryAnalytics.Events.gameFollow
local getSduiPageEntrySnackbarStore = require(Parent.SduiSharedUtilities).getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFollowAction(p1, _, p3, _) -- line: 24
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Game (copy), Players (copy), gameFollow (copy), Signals (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), localizeStrings (copy)
	local v19 = p1 and p1.actionParams or nil

	if v19 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.ToggleExperienceFollow
		}, p3.appPage)

		return
	end

	local universeId = v19.universeId
	local v21 = v19.gameName or ""

	if universeId == nil or typeof(universeId) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing universeId",
			name = SduiActionType.ToggleExperienceFollow
		}, p3.appPage)

		return
	end

	local placeId = v19.placeId
	local v23 = v19.ctx or ""
	local v24 = Game.getFollowingsStore(false)
	local v25 = v24.getAndFetchFollowing(universeId).data(false)
	local v26 = not (not not v25 and (v25.isFollowing or false))
	local v27 = Players.LocalPlayer and Players.LocalPlayer.UserId

	gameFollow({
		uid = tostring(v27),
		placeId = tostring(placeId),
		state = not v26 and "off" or "on",
		ctx = v23
	}, v23)

	local v28 = v24.updateFollowing(universeId, v26)
	local localization = p3.dependencies.localization
	local t1 = {}

	t1.dispose = Signals.createEffect(function(p5) -- line: 70
		-- upvalues: v28 (copy), p3 (copy), localization (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), localizeStrings (copy), v21 (copy), t1 (copy)
		local v32 = v28(p5)

		if v32 == nil then
			return
		end

		local configKey = p3.configKey

		if v32.type == "error" then
			if configKey then
				local s1 = "Feature.Toast.NetworkingError.SomethingIsWrong"

				if v32.errorType == "LimitReached" then
					s1 = "Feature.GameFollows.TooltipNotificationsLimitReached"
				end

				local v35 = localization:Format(s1)

				getSduiPageEntrySnackbarStore().show(configKey, {
					title = v35,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v32.type == "success" and configKey then
			local v36 = localizeStrings(localization, {
				notificationsTurnedOn = {
					"Feature.GameFollows.TooltipTurnedOnNotifications",
					experienceName = v21
				},
				notificationsTurnedOff = {
					"Feature.GameFollows.TooltipTurnedOffNotifications",
					experienceName = v21
				}
			})
			local v37 = if not v32.isFollowing then v36.notificationsTurnedOff else v36.notificationsTurnedOn

			getSduiPageEntrySnackbarStore().show(configKey, {
				title = v37,
				icon = if not v32.isFollowing then Foundation.Enums.IconName.BellSlash else Foundation.Enums.IconName.Bell
			})
		end

		local dispose = t1.dispose

		if dispose then
			dispose()
			t1.dispose = nil
		end
	end)
end

return SduiToggleExperienceFollowAction
