local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 47
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v14 = table.clone(p1)

	v14.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v14
end
local function createMoment(p2, p3, p4) -- line: 57
	-- upvalues: EngineFeature (copy), _game (copy), CaptureService (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p3 = table.clone(p3)
			p3.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v19 = p3

	pcall(function() -- line: 65
		-- upvalues: CaptureService (copy), p2 (copy), v19 (copy), p4 (copy)
		CaptureService:UploadCaptureAndPostMoment(p2, v19, p4)
	end)
	fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, makeCreationEventFields.makeCaptureDescriptorFields(p2))
end

return createMoment
