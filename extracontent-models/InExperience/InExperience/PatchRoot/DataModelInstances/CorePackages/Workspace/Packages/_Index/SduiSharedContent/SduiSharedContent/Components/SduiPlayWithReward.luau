local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local Navigation = require(Parent.Navigation)
local React = require(Parent.React)
local PlayWithRewardComponent = require(Parent.PlayWithRewardComponent)
local GamePlayButton = require(Parent.GamePlayButton)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local PlayWithRewardComponent2 = PlayWithRewardComponent.PlayWithRewardComponent
local usePlayWithRewardData = PlayWithRewardComponent.usePlayWithRewardData
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local useNavigationFocus = Navigation.useNavigationFocus
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local FFlagSduiPlayWithRewardGapFix = require(Parent.SharedFlags).FFlagSduiPlayWithRewardGapFix

local function SduiPlayWithReward(t1: {[any]: any}) -- line: 28
	-- upvalues: useNavigationFocus (copy), React (copy), usePlayButtonState (copy), PlayButtonStates (copy), usePlayWithRewardData (copy), FFlagSduiPlayWithRewardGapFix (copy), getSduiClientPageScope (copy), PlayWithRewardComponent2 (copy)
	local v16 = useNavigationFocus()
	local v17, v18 = React.useState(false)
	local v19 = t1.sduiContext and (t1.sduiContext.dependencies and t1.sduiContext.dependencies.networking)
	local v20 = usePlayButtonState(v19, t1.universeId)
	local v21 = v20.playButtonState == PlayButtonStates.Playable

	React.useEffect(function() -- line: 38
		-- upvalues: v16 (copy), v18 (copy)
		if v16 then
			v18(true)
		end
	end, { v16 })

	local v22 = usePlayWithRewardData({
		universeId = t1.universeId,
		shouldFetch = v17,
		onFetchDispatched = function() -- line: 47
			-- upvalues: v18 (copy)
			v18(false)
		end
	})
	local playWithRewardData = v22.playWithRewardData
	local showPlayWithReward = v22.showPlayWithReward
	local v25 = nil

	if FFlagSduiPlayWithRewardGapFix then
		v25 = v21 and (showPlayWithReward and playWithRewardData)

		local v26 = v20.playButtonState ~= PlayButtonStates.Loading and (playWithRewardData and not v25)
		local v27 = t1.sduiContext and t1.sduiContext.configKey

		React.useEffect(function() -- line: 62
			-- upvalues: v27 (copy), v26 (copy), getSduiClientPageScope (copy)
			if not v27 or not v26 then
				return
			end

			getSduiClientPageScope(v27).set("filterPlayWithReward", true)
		end, {
			v27,
			v26
		})
	end

	if FFlagSduiPlayWithRewardGapFix and not v25 or not v21 or not showPlayWithReward or not playWithRewardData then
		return nil
	end

	return React.createElement(PlayWithRewardComponent2, {
		universeId = t1.universeId,
		placeId = t1.placeId,
		placeIdOverride = t1.placeIdOverride,
		experienceJoinData = t1.experienceJoinData,
		flowId = playWithRewardData.flowId,
		fetchedUniverseId = playWithRewardData.universeId,
		isAdDataExpected = playWithRewardData.isAdDataExpected,
		playWithRewardAdData = playWithRewardData.adData,
		useLargerStyles = t1.useLargerStyles,
		layoutOrder = t1.layoutOrder
	})
end

return React.memo(SduiPlayWithReward)
