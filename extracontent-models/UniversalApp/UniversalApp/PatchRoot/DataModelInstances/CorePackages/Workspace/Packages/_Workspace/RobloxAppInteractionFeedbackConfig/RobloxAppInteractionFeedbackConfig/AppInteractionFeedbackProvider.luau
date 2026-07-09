local Parent = script:FindFirstAncestor("RobloxAppInteractionFeedbackConfig").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local InteractionFeedbackContext = require(Parent.InteractionFeedback).InteractionFeedbackContext
local SpatialConfig = require(script.Parent.SpatialConfig)
local DirectionalConfig = require(script.Parent.DirectionalConfig)
local PointerConfig = require(script.Parent.PointerConfig)
local TouchConfig = require(script.Parent.TouchConfig)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local v12 = game:DefineFastFlag("MobileSoundAndHapticsEnabledIXP", false)
local v13 = game:DefineFastFlag("MobileSoundAndHapticsIXPBypass", false)

local function InteractionFeedbackProvider(t1: {[any]: any}) -- line: 17
	-- upvalues: Responsive (copy), v12 (copy), useUserExperiment (copy), AppUserLayers (copy), React (copy), SpatialConfig (copy), v13 (copy), TouchConfig (copy), DirectionalConfig (copy), PointerConfig (copy), InteractionFeedbackContext (copy)
	local v16 = Responsive.useLastInput()
	local v17 = Responsive.useIsSpatial()
	local u18 = nil

	if v12 then
		u18 = useUserExperiment({ AppUserLayers.MobileSoundAndHapticsLayer }, function(p1) -- line: 22
			-- upvalues: AppUserLayers (copy)
			return (p1[AppUserLayers.MobileSoundAndHapticsLayer] or {}).mobileSoundAndHapticsEnabled
		end)
	end

	local v19 = React.useMemo(function() -- line: 28
		-- upvalues: v17 (copy), SpatialConfig (copy), v16 (copy), Responsive (copy), v13 (copy), v12 (copy), u18 (ref), TouchConfig (copy), DirectionalConfig (copy), PointerConfig (copy)
		if v17 then
			return SpatialConfig
		end

		if v16 == Responsive.Input.Touch then
			if v13 or v12 and u18 then
				return TouchConfig
			end

			return {}
		end

		if v16 == Responsive.Input.Directional then
			return DirectionalConfig
		end

		if v16 == Responsive.Input.Pointer then
			return PointerConfig
		end

		return {}
	end, {
		v17,
		v16
	})

	return React.createElement(InteractionFeedbackContext.Provider, {
		value = v19
	}, t1.children)
end

return InteractionFeedbackProvider
