local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local DialogType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
local GetFFlagMomentsTextGenTonePicker = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTextGenTonePicker")
local GetFFlagMomentsGenerateTextInTextOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsGenerateTextInTextOverlay")

local eventNames = MomentsCommon.Analytics.EventNames
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration

return {
	kind = "generateText",
	presentation = "InstantAction",
	cta = {
		icon = BuilderIcons.Icon.TagSparkle,
		localizationKey = "Feature.Moments.Action.GenerateText",
		analyticsEvent = eventNames.EditingFlowGenerateTextButtonPressed,
		order = getFFlagEnableMomentTextGeneration() and 5 or 4
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	isAvailable = function(p2): boolean
		if GetFFlagMomentsGenerateTextInTextOverlay() then
			return false
		end

		return p2.canGenerateText == true
	end,
	apply = function(data)
		local RunService = game:GetService("RunService")
		local isStudio = RunService:IsStudio()
		local engineFeature = GetFFlagMomentsTextGenTonePicker()
			and (game:GetEngineFeature("CaptureServiceMomentTextTone") or isStudio)

		if engineFeature then
			data.showModal({
				modalType = DialogType.GenerateTextOptions,
				modalProps = {
					showTone = engineFeature,
					onSelect = function(p2)
						data.dismissModal()
						data.generateText(p2)
					end,
					onCancel = data.dismissModal
				}
			})
		else
			data.generateText()
		end
	end
}
