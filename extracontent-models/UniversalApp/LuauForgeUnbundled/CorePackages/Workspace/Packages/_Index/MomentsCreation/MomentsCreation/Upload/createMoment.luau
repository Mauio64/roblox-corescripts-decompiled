local CaptureService = game:GetService("CaptureService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local normalizeMomentMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/normalizeMomentMetadata")
local getFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local getFFlagMomentsUseMomentsServiceForUpload = MomentsCommon.Flags.GetFFlagMomentsUseMomentsServiceForUpload
local makePostMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makePostMetadata")
local FFlagMomentsCreationSessionId = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationSessionId")

local game2 = game

local engineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p2)
	local gameId = game2.GameId

	if gameId ~= nil and gameId > 0 then
		return p2
	end

	local clone = table.clone(p2)
	clone.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
	return clone
end

local function createMoment(p2, p3, p4, p5, p6): boolean
	local v5

	if engineFeature then
		local gameId = game2.GameId

		if gameId == nil or not (gameId > 0) then
			v5 = table.clone(p3)
			v5.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		else
			v5 = p3
		end
	else
		v5 = p3
	end

	local v6 = normalizeMomentMetadata(v5)
	local success, result

	if getFFlagMomentsUseUploadPostAsync() then
		local v8 = if getFFlagMomentsUseMomentsServiceForUpload() then p2 else nil
		local v9 = if FFlagMomentsCreationSessionId then p5 else nil
		local v10 = makePostMetadata(p3, v8, v9)

		success, result = pcall(function()
			if getFFlagMomentsUseMomentsServiceForUpload() then
				(p6 or game:GetService("MomentsService")):CreatePostAsync(v10)
			else
				CaptureService:UploadPostAsync(p2, v10)
			end
		end)
	else
		success, result = pcall(function()
			CaptureService:UploadCaptureAndPostMoment(p2, v6, p4)
		end)
	end

	if success then
		local captureDescriptorFields = makeCreationEventFields.makeCaptureDescriptorFields(p2)

		for k, v7 in makeCreationEventFields.makeCreationBaseFields(p5) do
			captureDescriptorFields[k] = v7
		end

		fireAnalyticsEvent(eventNames.EditingFlowMomentPublished, captureDescriptorFields)
		return true
	else
		local v7 = {
			captureType = makeCreationEventFields.enumName(p2.CaptureType),
			localId = tostring(p2.LocalId),
			error = tostring(result),
			status = "GenericFailure"
		}

		for k, v8 in makeCreationEventFields.makeCreationBaseFields(p5) do
			v7[k] = v8
		end

		fireAnalyticsEvent(eventNames.UploadCaptureFailed, v7)
		return false
	end
end

return createMoment
