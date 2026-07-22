local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 59
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v15 = table.clone(p1)

	v15.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v15
end
local function createMoment(p2, p3, p4, s1: string?) -- line: 69
	-- upvalues: EngineFeature (copy), _game (copy), CaptureService (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), makeCreationEventFields (copy), fireAnalyticsEvent (copy), EventNames (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p3 = table.clone(p3)
			p3.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v21 = p3
	local ok, result = pcall(function() -- line: 81
		-- upvalues: CaptureService (copy), p2 (copy), v21 (copy), p4 (copy)
		CaptureService:UploadCaptureAndPostMoment(p2, v21, p4)
	end)

	if GetFFlagMomentsAnalyticsProducerPrereqs() and not ok then
		local t1 = {
			status = "GenericFailure",
			captureType = makeCreationEventFields.enumName(p2.CaptureType),
			localId = tostring(p2.LocalId),
			error = tostring(result)
		}

		for v25, v26 in makeCreationEventFields.makeCreationBaseFields(s1) do
			t1[v25] = v26
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t1)

		return
	end

	local v27 = makeCreationEventFields.makeCaptureDescriptorFields(p2)

	for v28, v29 in makeCreationEventFields.makeCreationBaseFields(s1) do
		v27[v28] = v29
	end

	fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, v27)
end

return createMoment
