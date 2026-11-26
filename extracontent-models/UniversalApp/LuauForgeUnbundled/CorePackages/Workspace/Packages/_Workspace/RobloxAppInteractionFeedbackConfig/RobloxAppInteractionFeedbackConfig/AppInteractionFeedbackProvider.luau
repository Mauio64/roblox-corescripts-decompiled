local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/Responsive")
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/ExperimentLayers").AppUserLayers
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/RoactAppExperiment")
local interactionFeedbackContext = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/InteractionFeedback").InteractionFeedbackContext
local SpatialConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/RobloxAppInteractionFeedbackConfig/SpatialConfig")
local DirectionalConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/RobloxAppInteractionFeedbackConfig/DirectionalConfig")
local PointerConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/RobloxAppInteractionFeedbackConfig/PointerConfig")
local TouchConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/RobloxAppInteractionFeedbackConfig/TouchConfig")

local useUserExperiment = RoactAppExperiment.useUserExperiment
local defineFastFlag = game:DefineFastFlag("MobileSoundAndHapticsEnabledIXP", false)
local defineFastFlag2 = game:DefineFastFlag("MobileSoundAndHapticsIXPBypass", false)

local function InteractionFeedbackProvider(p2)
	local v5 = Responsive.useLastInput()
	local v6 = Responsive.useIsSpatial()
	local v7

	if defineFastFlag then
		v7 = useUserExperiment({ appUserLayers.MobileSoundAndHapticsLayer }, function(p3)
			return (p3[appUserLayers.MobileSoundAndHapticsLayer] or {}).mobileSoundAndHapticsEnabled
		end)
	else
		v7 = nil
	end

	local v8 = React.useMemo(function()
		if v6 then
			return SpatialConfig
		end

		if v5 == Responsive.Input.Touch then
			if defineFastFlag2 or defineFastFlag and v7 then
				return TouchConfig
			end
		else
			if v5 == Responsive.Input.Directional then
				return DirectionalConfig
			end

			if v5 == Responsive.Input.Pointer then
				return PointerConfig
			end
		end

		return {}
	end, { v6, v5 })

	return React.createElement(interactionFeedbackContext.Provider, { value = v8 }, p2.children)
end

return InteractionFeedbackProvider
