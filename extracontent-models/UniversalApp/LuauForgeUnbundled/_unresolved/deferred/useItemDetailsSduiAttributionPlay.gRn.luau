local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@luauforge/deferred/gRo").useNavigation
local useRoactService = require("@luauforge/deferred/gRp").useRoactService
local roactNetworking = require("@luauforge/deferred/gRq").RoactNetworking
local module2 = require("@luauforge/deferred/gRr")
local module3 = require("@luauforge/deferred/gRs")
local avatarScreen = require("@luauforge/bundled/dTL").Enums.AvatarScreen
local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@luauforge/deferred/gRt").FFlagLuaAppPlayButtonLoadingDurationTelemetry

local AttributionConstants = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/AttributionConstants")
local module5 = require("@luauforge/deferred/gPi")
require("@luauforge/bundled/dTH")

local function useItemDetailsSduiAttributionPlay(p2, p3, p4, p5)
	local v5 = useRoactService(roactNetworking)
	local v6 = useNavigation()

	local v7 = React.useMemo(function()
		local v8 = module5(p4, p3, p5, nil)

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

	local v11 = useSelector((React.useCallback(function(p6)
		local gameDetail = p6.GameDetails[p2]

		if gameDetail then
			return gameDetail.name
		end

		return nil
	end, { p2 })))
	local v12 = module3.useGameInfo(p2)

	if not v11 then
		v11 = if v12 then v12.name else nil
	end

	local v13 = module3.useGameIcon(p2)

	local playButtonState = v8.playButtonState
	local playabilityStatus = v8.playabilityStatus
	local playabilityStatus2 = if playabilityStatus then playabilityStatus.playabilityStatus else nil
	local v14

	if playabilityStatus2 then
		v14 = AttributionConstants.ShowTraversalAlertMapper[playabilityStatus2] == true
	else
		v14 = false
	end

	return React.useMemo(function()
		local function launch()
			v9(playButtonState)
		end
		return {
			universeId = p2,
			play = function()
				if v14 then
					v6.navigate(avatarScreen.OpenExperienceTraversalPrompt, {
						onPlayButtonActivated = launch,
						gameName = v11,
						gameUniverseId = p2,
						thumbnailUrl = v13
					})
				else
					v9(playButtonState)
				end
			end
		}
	end, { p2, v6, v9, playButtonState, v14, v11, v13 })
end

return useItemDetailsSduiAttributionPlay
