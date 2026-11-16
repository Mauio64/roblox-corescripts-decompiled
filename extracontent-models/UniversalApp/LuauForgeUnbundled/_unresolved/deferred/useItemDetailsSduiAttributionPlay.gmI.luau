local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@luauforge/deferred/gmJ").useNavigation
local useRoactService = require("@luauforge/deferred/gmK").useRoactService
local roactNetworking = require("@luauforge/deferred/gmL").RoactNetworking
local module2 = require("@luauforge/deferred/gmM")
local module3 = require("@luauforge/deferred/gmN")
local gameInfosReducer = require("@luauforge/deferred/gmO").GameInfosReducer
local avatarScreen = require("@luauforge/bundled/dQv").Enums.AvatarScreen
local module4 = require("@luauforge/deferred/gmP")
local fFlagMigrateGameInfoToStore = module4.FFlagMigrateGameInfoToStore
local fFlagLuaAppPlayButtonLoadingDurationTelemetry = module4.FFlagLuaAppPlayButtonLoadingDurationTelemetry

local AttributionConstants = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/AttributionConstants")
local module6 = require("@luauforge/deferred/gkC")
require("@luauforge/bundled/dQr")

local function useItemDetailsSduiAttributionPlay(p2, p3, p4, p5)
	local v5 = useRoactService(roactNetworking)
	local v6 = useNavigation()

	local v7 = React.useMemo(function()
		local v8 = module6(p4, p3, p5, nil)

		if v8 then
			return { gameJoinContext = v8 }
		end

		return nil
	end, { p4, p3, p5 })

	local v8 = module2.usePlayButtonState(
		v5,
		p2,
		nil,
		nil,
		nil,
		fFlagLuaAppPlayButtonLoadingDurationTelemetry and "PlayButton" or nil
	)

	local v9 = module2.useOnPlayButtonCallback(
		p2,
		"ItemDetailsPage",
		"PlayButton",
		nil,
		"AttributionItemRow",
		v7,
		nil
	)

	local v10 = useSelector((React.useCallback(function(p6)
		local gameDetail = p6.GameDetails[p2]

		if gameDetail then
			return gameDetail.name
		end

		return nil
	end, { p2 })))

	if fFlagMigrateGameInfoToStore then
		local v11 = module3.useGameInfo(p2)

		if not v10 then
			v10 = if v11 then v11.name else nil
		end
	else
		local v11 = useSelector((React.useCallback(function(p6)
			local v12 = p6.Personalization[gameInfosReducer.key][p2]

			if v12 then
				return v12.name
			end

			return nil
		end, { p2 })))
		v10 = v10 or v11
	end

	local v11 = module3.useGameIcon(p2)

	local playButtonState = v8.playButtonState
	local playabilityStatus = v8.playabilityStatus
	local playabilityStatus2 = if playabilityStatus then playabilityStatus.playabilityStatus else nil
	local v12

	if playabilityStatus2 then
		v12 = AttributionConstants.ShowTraversalAlertMapper[playabilityStatus2] == true
	else
		v12 = false
	end

	return React.useMemo(function()
		local function launch()
			v9(playButtonState)
		end
		return {
			universeId = p2,
			play = function()
				if v12 then
					v6.navigate(avatarScreen.OpenExperienceTraversalPrompt, {
						onPlayButtonActivated = launch,
						gameName = v10,
						gameUniverseId = p2,
						thumbnailUrl = v11
					})
				else
					v9(playButtonState)
				end
			end
		}
	end, { p2, v6, v9, playButtonState, v12, v10, v11 })
end

return useItemDetailsSduiAttributionPlay
