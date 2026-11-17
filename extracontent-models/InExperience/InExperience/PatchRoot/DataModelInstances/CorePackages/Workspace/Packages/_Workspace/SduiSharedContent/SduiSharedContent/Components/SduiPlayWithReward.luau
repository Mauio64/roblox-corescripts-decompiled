local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Navigation = require(parent.Navigation)
local React = require(parent.React)
local PlayWithRewardComponent = require(parent.PlayWithRewardComponent)
local GamePlayButton = require(parent.GamePlayButton)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local playWithRewardComponent = PlayWithRewardComponent.PlayWithRewardComponent
local usePlayWithRewardData = PlayWithRewardComponent.usePlayWithRewardData
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local useNavigationFocus = Navigation.useNavigationFocus
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function SduiPlayWithReward(props)
	local v = useNavigationFocus()
	local state, setState = React.useState(false)

	local networking = props.sduiContext
		and props.sduiContext.dependencies
		and props.sduiContext.dependencies.networking
	local v2 = usePlayButtonState(networking, props.universeId)
	local v3 = v2.playButtonState == PlayButtonStates.Playable

	React.useEffect(function()
		if v then
			setState(true)
		end
	end, { v })

	local v4 = usePlayWithRewardData({
		universeId = props.universeId,
		shouldFetch = state,
		onFetchDispatched = function()
			setState(false)
		end
	})

	local playWithRewardData = v4.playWithRewardData
	local showPlayWithReward = v4.showPlayWithReward
	local v5 = v3 and showPlayWithReward and playWithRewardData
	local v6 = v2.playButtonState ~= PlayButtonStates.Loading and playWithRewardData and not v5

	local configKey = props.sduiContext and props.sduiContext.configKey

	React.useEffect(function()
		if configKey and v6 then
			getSduiClientPageScope(configKey).set("filterPlayWithReward", true)
		end
	end, { configKey, v6 })

	if v5 then
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
