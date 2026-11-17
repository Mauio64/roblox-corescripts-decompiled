local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local Game = DataHydration.Game
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents
local Localization = require(parent.Localization)
local localizeStrings = Localization.localizeStrings

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local gameFollow = DiscoveryAnalytics.Events.gameFollow
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore

local function SduiToggleExperienceFollowAction(p, _, data, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ToggleExperienceFollow, message = "Missing action params" },
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId
	local gameName = actionParams.gameName or ""

	if universeId == nil or typeof(universeId) ~= "string" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ToggleExperienceFollow, message = "Missing universeId" },
			data.appPage
		)
		return
	end

	local placeId = actionParams.placeId
	local ctx = actionParams.ctx or ""

	local followingsStore = Game.getFollowingsStore(false)
	local data2 = followingsStore.getAndFetchFollowing(universeId).data(false)
	local v = not (data2 and data2.isFollowing)

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
	local v2 = {
		uid = tostring(userId),
		placeId = tostring(placeId),
		state = v and "on" or "off",
		ctx = ctx,
		universeId = 0
	}
	local universeId2

	if FFlagLuaAppAddUniverseIdToEngagementEvents then
		universeId2 = universeId
	end

	v2.universeId = universeId2
	gameFollow(v2, ctx)

	local v3 = followingsStore.updateFollowing(universeId, v)
	local localization = data.dependencies.localization

	local v4 = {}
	v4.dispose = Signals.createEffect(function(p2)
		local v5 = v3(p2)

		if v5 == nil then
			return
		end

		local configKey = data.configKey

		if v5.type == "error" then
			if configKey then
				local formatted = localization:Format(v5.errorType == "LimitReached" and "Feature.GameFollows.TooltipNotificationsLimitReached" or "Feature.Toast.NetworkingError.SomethingIsWrong")
				getSduiPageEntrySnackbarStore().show(configKey, {
					title = formatted,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v5.type == "success" and configKey then
			local v6 = localizeStrings(localization, {
				notificationsTurnedOn = {
					"Feature.GameFollows.TooltipTurnedOnNotifications",
					experienceName = gameName
				},
				notificationsTurnedOff = {
					"Feature.GameFollows.TooltipTurnedOffNotifications",
					experienceName = gameName
				}
			})
			local title

			if v5.isFollowing then
				title = v6.notificationsTurnedOn
			else
				title = v6.notificationsTurnedOff
			end

			local show = getSduiPageEntrySnackbarStore().show
			local icon

			if v5.isFollowing then
				icon = Foundation.Enums.IconName.Bell
			else
				icon = Foundation.Enums.IconName.BellSlash
			end

			show(configKey, { title = title, icon = icon })
		end

		local dispose = v4.dispose

		if dispose then
			dispose()
			v4.dispose = nil
		end
	end)
end

return SduiToggleExperienceFollowAction
