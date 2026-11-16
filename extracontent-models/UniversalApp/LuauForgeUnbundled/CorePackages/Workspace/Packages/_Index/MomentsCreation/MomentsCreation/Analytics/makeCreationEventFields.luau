local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local eventNames = MomentsCommon.Analytics.EventNames
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration

local creationFlowSteps = funnelEventNames.CreationFlowSteps

local v5 = {
	[eventNames.MomentsEditingFlowContinueToEditButtonPressed] = creationFlowSteps.GalleryItemSelectedContinuePressed,
	[eventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = creationFlowSteps.EditingScreenContinuePressed,
	[eventNames.MomentsEditingFlowPublished] = creationFlowSteps.Published,
	[eventNames.EditingFlowGalleryPageAppear] = creationFlowSteps.CreateIntent,
	[eventNames.EditingFlowEditPageAppear] = creationFlowSteps.GalleryItemSelectedContinuePressed,
	[eventNames.EditingFlowPreviewPageAppear] = creationFlowSteps.EditingScreenContinuePressed,
	[eventNames.MomentsEditingFlowExited] = creationFlowSteps.CreateIntent
}

local v6 = {
	Gallery = creationFlowSteps.GalleryItemSelectedContinuePressed,
	Preview = creationFlowSteps.EditingScreenContinuePressed,
	Description = creationFlowSteps.EditingScreenContinuePressed
}

return {
	makeStepField = function(p2)
		local v7 = v5[p2]

		if v7 == nil then
			return {}
		end

		return { step = v7 }
	end,
	makeStepFieldFromState = function(p2)
		local v7 = if p2 ~= nil then v6[p2] else nil

		if v7 == nil then
			return {}
		end

		return { step = v7 }
	end,
	makeToolField = function(p2)
		if p2 == nil or p2.kind == nil then
			return {}
		end

		return { tool = p2.kind }
	end,
	makeToolFieldFromKind = function(p2)
		if p2 == nil then
			return {}
		end

		return { tool = p2 }
	end,
	makeCreationBaseFields = function(p2)
		if p2 == nil then
			return {}
		end

		return { creationSessionId = p2 }
	end,
	makeVoiceEventFields = function(items)
		local voiceEventFields = { tool = "voice" }

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		local v7

		if sessionId == nil then
			v7 = {}
		else
			v7 = { creationSessionId = sessionId }
		end

		for k, v10 in v7 do
			voiceEventFields[k] = v10
		end

		if items ~= nil then
			for k, item in items do
				voiceEventFields[k] = item
			end
		end

		return voiceEventFields
	end,
	makeTextOverlayEventFields = function(items)
		local textOverlayEventFields = { tool = "text" }

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		local v7

		if sessionId == nil then
			v7 = {}
		else
			v7 = { creationSessionId = sessionId }
		end

		for k, v10 in v7 do
			textOverlayEventFields[k] = v10
		end

		if items ~= nil then
			for k, item in items do
				textOverlayEventFields[k] = item
			end
		end

		return textOverlayEventFields
	end,
	makeTextOverlayPublishSummaryFields = function(data)
		if data == nil then
			return {}
		end

		local v7 = {}
		local textOverlayStyle = data.textOverlayStyle

		if textOverlayStyle ~= nil then
			if textOverlayStyle.font ~= nil then
				v7.font = textOverlayStyle.font.Name
			end

			if textOverlayStyle.fontSize ~= nil then
				v7.fontSize = tostring(textOverlayStyle.fontSize)
			end

			if textOverlayStyle.fontColor ~= nil then
				v7.color = "#" .. textOverlayStyle.fontColor:ToHex()
			end

			if textOverlayStyle.textXAlignment ~= nil then
				v7.alignment = textOverlayStyle.textXAlignment.Name
			end
		end

		if data.rotation ~= nil then
			v7.rotation = tostring(data.rotation)
		end

		if typeof(data.position) == "UDim2" then
			v7.positionX = tostring(data.position.X.Scale)
			v7.positionY = tostring(data.position.Y.Scale)
		end

		if data.scale ~= nil then
			v7.scale = tostring(data.scale)
		end

		if next(v7) == nil then
			return {}
		end

		return v7
	end,
	makeVoicePublishSummaryFields = function(data, p2, p3)
		if data == nil then
			return {}
		end

		local v7 = {}

		if data.voiceId ~= nil then
			v7.ttsVoiceId = tostring(data.voiceId)
		end

		if data.text ~= nil then
			v7.ttsCharCount = tostring(utf8.len(data.text) or #data.text)
		end

		if p3 ~= nil and p3 > 0 then
			v7.ttsDuration = tostring(p3)
		end

		local startTime = data.startTime or 0
		v7.ttsStartTimeSeconds = tostring(startTime)

		if p2 ~= nil then
			v7.ttsVideoDurationSeconds = tostring(p2)
			v7.ttsStartTimeFraction = tostring(not (p2 > 0) and 0 or startTime / p2)
		end

		return v7
	end,
	makeCaptureDescriptorFields = function(data)
		local captureDescriptorFields = {
			sourcePlaceId = tostring(data.SourcePlaceId),
			localId = tostring(data.LocalId),
			captureType = 0
		}
		local captureType = data.CaptureType
		local v7

		if typeof(captureType) == "EnumItem" then
			v7 = captureType.Name
		elseif captureType ~= nil then
			v7 = tostring(captureType)
		end

		captureDescriptorFields.captureType = v7

		captureDescriptorFields.universeId = tostring(data.SourceUniverseId)
		return captureDescriptorFields
	end,
	makeGeneratedTextOutcomeFields = function(p2, p3, p4, p5)
		if getFFlagEnableMomentTextGeneration() then
			return {
				generatedDescriptionOutcome = p2 == nil and "none" or p3 == p2 and "verbatim" or (p3 == nil or p3 == "") and "discarded" or "edited",
				generatedSummaryOutcome = p4 == nil and "none" or p5 == p4 and "verbatim" or (p5 == nil or p5 == "") and "discarded" or "edited"
			}
		end

		return {}
	end,
	classifyGeneratedTextOutcome = function(p2, p3): string
		if p2 == nil then
			return "none"
		end

		if p3 == p2 then
			return "verbatim"
		end

		if p3 == nil or p3 == "" then
			return "discarded"
		end

		return "edited"
	end,
	enumName = function(p2)
		if typeof(p2) == "EnumItem" then
			return p2.Name
		end

		if p2 == nil then
			return nil
		end

		return (tostring(p2))
	end
}
