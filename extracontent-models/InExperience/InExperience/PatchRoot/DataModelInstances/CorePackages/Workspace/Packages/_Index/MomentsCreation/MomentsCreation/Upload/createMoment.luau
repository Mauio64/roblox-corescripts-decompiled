local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 46
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v13 = table.clone(p1)

	v13.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v13
end
local function createMoment(p2, p3, p4) -- line: 56
	-- upvalues: EngineFeature (copy), _game (copy), CaptureService (copy), fireAnalyticsEvent (copy), EventNames (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p3 = table.clone(p3)
			p3.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v18 = p3

	pcall(function() -- line: 64
		-- upvalues: CaptureService (copy), p2 (copy), v18 (copy), p4 (copy)
		CaptureService:UploadCaptureAndPostMoment(p2, v18, p4)
	end)
	fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, {
		sourcePlaceId = tostring(p2.SourcePlaceId),
		localId = tostring(p2.LocalId),
		captureType = tostring(p2.CaptureType)
	})
end

return createMoment
