local CaptureService = game:GetService("CaptureService")

local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local normalizeMomentMetadata = require(MomentsCreation.Utils.normalizeMomentMetadata)
local GetFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local GetFFlagMomentsUseMomentsServiceForUpload = MomentsCommon.Flags.GetFFlagMomentsUseMomentsServiceForUpload
local makePostMetadata = require(MomentsCreation.Utils.makePostMetadata)
local FFlagMomentsCreationSessionId = require(MomentsCreation.Flags.FFlagMomentsCreationSessionId)

local game2 = game

local engineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p)
	local gameId = game2.GameId

	if gameId ~= nil and gameId > 0 then
		return p
	end

	local clone = table.clone(p)
	clone.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
	return clone
end

local function createMoment(p, p2, p3, p4: string?, p5): boolean
	local v

	if engineFeature then
		local gameId = game2.GameId

		if gameId == nil or not (gameId > 0) then
			v = table.clone(p2)
			v.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		else
			v = p2
		end
	else
		v = p2
	end

	local momentMetadata = normalizeMomentMetadata(v)
	local success, result

	if GetFFlagMomentsUseUploadPostAsync() then
		local v2

		if GetFFlagMomentsUseMomentsServiceForUpload() then
			v2 = p
		end

		local v3

		if FFlagMomentsCreationSessionId then
			v3 = p4
		end

		local postMetadata = makePostMetadata(p2, v2, v3)

		success, result = pcall(function()
			if GetFFlagMomentsUseMomentsServiceForUpload() then
				(p5 or game:GetService("MomentsService")):CreatePostAsync(postMetadata)
			else
				CaptureService:UploadPostAsync(p, postMetadata)
			end
		end)
	else
		success, result = pcall(function()
			CaptureService:UploadCaptureAndPostMoment(p, momentMetadata, p3)
		end)
	end

	if success then
		local captureDescriptorFields = makeCreationEventFields.makeCaptureDescriptorFields(p)

		for k, v2 in makeCreationEventFields.makeCreationBaseFields(p4) do
			captureDescriptorFields[k] = v2
		end

		fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, captureDescriptorFields)
		return true
	else
		local v2 = {
			captureType = makeCreationEventFields.enumName(p.CaptureType),
			localId = tostring(p.LocalId),
			error = tostring(result),
			status = "GenericFailure"
		}

		for k, v3 in makeCreationEventFields.makeCreationBaseFields(p4) do
			v2[k] = v3
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, v2)
		return false
	end
end

return createMoment
