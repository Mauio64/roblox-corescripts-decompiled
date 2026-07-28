local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local normalizeMomentMetadata = require(MomentsCreation.Utils.normalizeMomentMetadata)
local GetFFlagMomentsCreationNormalizeMetadataEnums = require(MomentsCreation.Flags.GetFFlagMomentsCreationNormalizeMetadataEnums)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 62
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v17 = table.clone(p1)

	v17.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v17
end
local function createMoment(p2, p3, p4, s1: string?) -- line: 72
	-- upvalues: EngineFeature (copy), _game (copy), GetFFlagMomentsCreationNormalizeMetadataEnums (copy), normalizeMomentMetadata (copy), CaptureService (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), makeCreationEventFields (copy), fireAnalyticsEvent (copy), EventNames (copy)
	local u23

	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
			u23 = p3
		else
			local v24 = table.clone(p3)

			v24.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
			u23 = v24
		end
	else
		u23 = p3
	end

	if GetFFlagMomentsCreationNormalizeMetadataEnums() then
		u23 = normalizeMomentMetadata(u23)
	end

	local ok, result = pcall(function() -- line: 87
		-- upvalues: CaptureService (copy), p2 (copy), u23 (ref), p4 (copy)
		CaptureService:UploadCaptureAndPostMoment(p2, u23, p4)
	end)

	if GetFFlagMomentsAnalyticsProducerPrereqs() and not ok then
		local t1 = {
			status = "GenericFailure",
			captureType = makeCreationEventFields.enumName(p2.CaptureType),
			localId = tostring(p2.LocalId),
			error = tostring(result)
		}

		for v28, v29 in makeCreationEventFields.makeCreationBaseFields(s1) do
			t1[v28] = v29
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t1)

		return
	end

	local v30 = makeCreationEventFields.makeCaptureDescriptorFields(p2)

	for v31, v32 in makeCreationEventFields.makeCreationBaseFields(s1) do
		v30[v31] = v32
	end

	fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, v30)
end

return createMoment
