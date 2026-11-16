local parent = script:FindFirstAncestor("RobloxAppInteractionFeedbackConfig").Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RoactAppExperiment = require(parent.RoactAppExperiment)
local InteractionFeedback = require(parent.InteractionFeedback)
local InteractionFeedbackContext = InteractionFeedback.InteractionFeedbackContext
local SpatialConfig = require(script.Parent.SpatialConfig)
local DirectionalConfig = require(script.Parent.DirectionalConfig)
local PointerConfig = require(script.Parent.PointerConfig)
local TouchConfig = require(script.Parent.TouchConfig)

local useUserExperiment = RoactAppExperiment.useUserExperiment
local defineFastFlag = game:DefineFastFlag("MobileSoundAndHapticsEnabledIXP", false)
local defineFastFlag2 = game:DefineFastFlag("MobileSoundAndHapticsIXPBypass", false)

local function InteractionFeedbackProvider(p)
	local v = Responsive.useLastInput()
	local v2 = Responsive.useIsSpatial()
	local v3

	if defineFastFlag then
		v3 = useUserExperiment({ AppUserLayers.MobileSoundAndHapticsLayer }, function(p2)
			return (p2[AppUserLayers.MobileSoundAndHapticsLayer] or {}).mobileSoundAndHapticsEnabled
		end)
	else
		v3 = nil
	end

	local v4 = React.useMemo(function()
		if v2 then
			return SpatialConfig
		end

		if v == Responsive.Input.Touch then
			if defineFastFlag2 or defineFastFlag and v3 then
				return TouchConfig
			end
		else
			if v == Responsive.Input.Directional then
				return DirectionalConfig
			end

			if v == Responsive.Input.Pointer then
				return PointerConfig
			end
		end

		return {}
	end, { v2, v })

	return React.createElement(InteractionFeedbackContext.Provider, { value = v4 }, p.children)
end

return InteractionFeedbackProvider
