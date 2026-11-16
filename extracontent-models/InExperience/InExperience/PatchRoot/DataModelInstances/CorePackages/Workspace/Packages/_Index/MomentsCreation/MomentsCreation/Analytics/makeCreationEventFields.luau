local parent = script:FindFirstAncestor("MomentsCreation").Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration

local CreationFlowSteps = FunnelEventNames.CreationFlowSteps

local v = {
	[EventNames.MomentsEditingFlowContinueToEditButtonPressed] = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	[EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = CreationFlowSteps.EditingScreenContinuePressed,
	[EventNames.MomentsEditingFlowPublished] = CreationFlowSteps.Published,
	[EventNames.EditingFlowGalleryPageAppear] = CreationFlowSteps.CreateIntent,
	[EventNames.EditingFlowEditPageAppear] = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	[EventNames.EditingFlowPreviewPageAppear] = CreationFlowSteps.EditingScreenContinuePressed,
	[EventNames.MomentsEditingFlowExited] = CreationFlowSteps.CreateIntent
}

local v2 = {
	Gallery = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	Preview = CreationFlowSteps.EditingScreenContinuePressed,
	Description = CreationFlowSteps.EditingScreenContinuePressed
}

local function makeCreationBaseFields(creationSessionId: string?) -- 2 equivalent calls inferred from this helper
	if creationSessionId == nil then
		return {}
	end

	return { creationSessionId = creationSessionId }
end

local function enumName(captureType) -- 1 equivalent call inferred from this helper
	if typeof(captureType) == "EnumItem" then
		return captureType.Name
	end

	if captureType == nil then
		return nil
	end

	return (tostring(captureType))
end

local MakeCreationEventFields = {}

function MakeCreationEventFields.makeStepField(p: string)
	local step = v[p]

	if step == nil then
		return {}
	end

	return { step = step }
end

function MakeCreationEventFields.makeStepFieldFromState(p: string?)
	local step

	if p ~= nil then
		step = v2[p]
	end

	if step == nil then
		return {}
	end

	return { step = step }
end

function MakeCreationEventFields.makeToolField(p)
	if p == nil or p.kind == nil then
		return {}
	end

	return { tool = p.kind }
end

function MakeCreationEventFields.makeToolFieldFromKind(tool: string?)
	if tool == nil then
		return {}
	end

	return { tool = tool }
end

MakeCreationEventFields.makeCreationBaseFields = makeCreationBaseFields

function MakeCreationEventFields.makeVoiceEventFields(items)
	local voiceEventFields = { tool = "voice" }

	local creationBaseFields = makeCreationBaseFields(SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)) -- inferred equivalent call

	for k, creationBaseField in creationBaseFields do
		voiceEventFields[k] = creationBaseField
	end

	if items ~= nil then
		for k, item in items do
			voiceEventFields[k] = item
		end
	end

	return voiceEventFields
end

function MakeCreationEventFields.makeTextOverlayEventFields(items)
	local textOverlayEventFields = { tool = "text" }

	local creationBaseFields = makeCreationBaseFields(SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)) -- inferred equivalent call

	for k, creationBaseField in creationBaseFields do
		textOverlayEventFields[k] = creationBaseField
	end

	if items ~= nil then
		for k, item in items do
			textOverlayEventFields[k] = item
		end
	end

	return textOverlayEventFields
end

function MakeCreationEventFields.makeTextOverlayPublishSummaryFields(data)
	if data == nil then
		return {}
	end

	local v3 = {}
	local textOverlayStyle = data.textOverlayStyle

	if textOverlayStyle ~= nil then
		if textOverlayStyle.font ~= nil then
			v3.font = textOverlayStyle.font.Name
		end

		if textOverlayStyle.fontSize ~= nil then
			v3.fontSize = tostring(textOverlayStyle.fontSize)
		end

		if textOverlayStyle.fontColor ~= nil then
			v3.color = "#" .. textOverlayStyle.fontColor:ToHex()
		end

		if textOverlayStyle.textXAlignment ~= nil then
			v3.alignment = textOverlayStyle.textXAlignment.Name
		end
	end

	if data.rotation ~= nil then
		v3.rotation = tostring(data.rotation)
	end

	if typeof(data.position) == "UDim2" then
		v3.positionX = tostring(data.position.X.Scale)
		v3.positionY = tostring(data.position.Y.Scale)
	end

	if data.scale ~= nil then
		v3.scale = tostring(data.scale)
	end

	if next(v3) == nil then
		return {}
	end

	return v3
end

function MakeCreationEventFields.makeVoicePublishSummaryFields(data, p: number?, p2: number?)
	if data == nil then
		return {}
	end

	local v3 = {}

	if data.voiceId ~= nil then
		v3.ttsVoiceId = tostring(data.voiceId)
	end

	if data.text ~= nil then
		v3.ttsCharCount = tostring(utf8.len(data.text) or #data.text)
	end

	if p2 ~= nil and p2 > 0 then
		v3.ttsDuration = tostring(p2)
	end

	local startTime = data.startTime or 0
	v3.ttsStartTimeSeconds = tostring(startTime)

	if p ~= nil then
		v3.ttsVideoDurationSeconds = tostring(p)
		v3.ttsStartTimeFraction = tostring(not (p > 0) and 0 or startTime / p)
	end

	return v3
end

function MakeCreationEventFields.makeCaptureDescriptorFields(data)
	local captureDescriptorFields = {
		sourcePlaceId = tostring(data.SourcePlaceId),
		localId = tostring(data.LocalId),
		captureType = enumName(data.CaptureType) -- inferred equivalent call
	}

	captureDescriptorFields.universeId = tostring(data.SourceUniverseId)
	return captureDescriptorFields
end

function MakeCreationEventFields.makeGeneratedTextOutcomeFields(p: string?, p2: string?, p3: string?, p4: string?)
	if GetFFlagEnableMomentTextGeneration() then
		return {
			generatedDescriptionOutcome = p == nil and "none" or p2 == p and "verbatim" or (p2 == nil or p2 == "") and "discarded" or "edited",
			generatedSummaryOutcome = p3 == nil and "none" or p4 == p3 and "verbatim" or (p4 == nil or p4 == "") and "discarded" or "edited"
		}
	end

	return {}
end

function MakeCreationEventFields.classifyGeneratedTextOutcome(p: string?, p2: string?): string
	if p == nil then
		return "none"
	end

	if p2 == p then
		return "verbatim"
	end

	return if p2 == nil or p2 == "" then "discarded" else "edited"
end

MakeCreationEventFields.enumName = enumName
return MakeCreationEventFields
