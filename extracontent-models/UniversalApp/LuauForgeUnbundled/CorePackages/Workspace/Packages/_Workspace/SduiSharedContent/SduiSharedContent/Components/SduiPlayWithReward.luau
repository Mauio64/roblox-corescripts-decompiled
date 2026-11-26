local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local PlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/PlayWithRewardComponent")
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GamePlayButton")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local playWithRewardComponent = PlayWithRewardComponent.PlayWithRewardComponent
local usePlayWithRewardData = PlayWithRewardComponent.usePlayWithRewardData
local usePlayButtonState = GamePlayButton.usePlayButtonState
local playButtonStates = GamePlayButton.PlayButtonStates
local useNavigationFocus = Navigation.useNavigationFocus
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function SduiPlayWithReward(props)
	local v5 = useNavigationFocus()
	local state, setState = React.useState(false)

	local networking = props.sduiContext
		and props.sduiContext.dependencies
		and props.sduiContext.dependencies.networking
	local v6 = usePlayButtonState(networking, props.universeId)
	local v7 = v6.playButtonState == playButtonStates.Playable

	React.useEffect(function()
		if v5 then
			setState(true)
		end
	end, { v5 })

	local v8 = usePlayWithRewardData({
		universeId = props.universeId,
		shouldFetch = state,
		onFetchDispatched = function()
			setState(false)
		end
	})

	local playWithRewardData = v8.playWithRewardData
	local showPlayWithReward = v8.showPlayWithReward
	local v9 = v7 and showPlayWithReward and playWithRewardData
	local v10 = v6.playButtonState ~= playButtonStates.Loading and playWithRewardData and not v9

	local configKey = props.sduiContext and props.sduiContext.configKey

	React.useEffect(function()
		if configKey and v10 then
			getSduiClientPageScope(configKey).set("filterPlayWithReward", true)
		end
	end, { configKey, v10 })

	if v9 then
		return React.createElement(playWithRewardComponent, {
			universeId = props.universeId,
			placeId = props.placeId,
			placeIdOverride = props.placeIdOverride,
			experienceJoinData = props.experienceJoinData,
			flowId = playWithRewardData.flowId,
			fetchedUniverseId = playWithRewardData.universeId,
			isAdDataExpected = playWithRewardData.isAdDataExpected,
			playWithRewardAdData = playWithRewardData.adData,
			useLargerStyles = props.useLargerStyles,
			layoutOrder = props.layoutOrder
		})
	end

	return nil
end

return React.memo(SduiPlayWithReward)
