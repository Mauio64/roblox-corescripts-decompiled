local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)

require(MomentsCreation.Types.CreationFlowTypes)
local DialogType = require(MomentsCreation.Enums.DialogType)
local GetFFlagMomentsTextGenTonePicker = require(MomentsCreation.Flags.GetFFlagMomentsTextGenTonePicker)
local GetFFlagMomentsGenerateTextInTextOverlay = require(MomentsCreation.Flags.GetFFlagMomentsGenerateTextInTextOverlay)

local EventNames = MomentsCommon.Analytics.EventNames
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GenerateTextTool = {}
GenerateTextTool.kind = "generateText"
GenerateTextTool.presentation = "InstantAction"
GenerateTextTool.cta = {
	icon = BuilderIcons.Icon.TagSparkle,
	localizationKey = "Feature.Moments.Action.GenerateText",
	analyticsEvent = EventNames.EditingFlowGenerateTextButtonPressed,
	order = GetFFlagEnableMomentTextGeneration() and 5 or 4
}

GenerateTextTool.supportedCaptureTypes = { Enum.CaptureType.Video }
function GenerateTextTool.isAvailable(p): boolean
	return not GetFFlagMomentsGenerateTextInTextOverlay() and p.canGenerateText == true
end

function GenerateTextTool.apply(data)
	local RunService = game:GetService("RunService")
	local isStudio = RunService:IsStudio()
	local engineFeature = GetFFlagMomentsTextGenTonePicker()
		and (game:GetEngineFeature("CaptureServiceMomentTextTone") or isStudio)

	if engineFeature then
		data.showModal({
			modalType = DialogType.GenerateTextOptions,
			modalProps = {
				showTone = engineFeature,
				onSelect = function(p: string?)
					data.dismissModal()
					data.generateText(p)
				end,
				onCancel = data.dismissModal
			}
		})
	else
		data.generateText()
	end
end

return GenerateTextTool
