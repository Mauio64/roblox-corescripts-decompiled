local FFlagSduiExperienceDetailsSocialProof = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSduiExperienceDetailsSocialProof")
local experimentCacheManager = require("@luauforge/bundled/fBT").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"LuaAppEdpExperimentLayer",
	"PlayerApp.GameDetailsPage.Exposure"
)

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local function getExperimentVariableAndSendExposureLog(p2)
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables[p2] == nil then
		return nil
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables[p2]
end

local function getShouldHydrateLegacy()
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables.shouldHydrateLegacy == nil then
		return nil
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables.shouldHydrateLegacy
end

local function getShouldInterleaveSdui()
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables.shouldInterleaveSdui == nil then
		return nil
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables.shouldInterleaveSdui
end

local function getShouldRaisePeekViewBriefHeight(): boolean
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)
	local socialProofVariant

	if layerVariables and layerVariables.socialProofVariant ~= nil then
		experimentCacheManager.default:sendCustomExposureLog(v5)
		socialProofVariant = layerVariables.socialProofVariant
	end

	return socialProofVariant == "text"
end

if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
	getShouldHydrateLegacy = nil
end

if not fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
	getShouldInterleaveSdui = nil
end

if not FFlagSduiExperienceDetailsSocialProof then
	getShouldRaisePeekViewBriefHeight = nil
end

return {
	getShouldHydrateLegacy = getShouldHydrateLegacy,
	getShouldInterleaveSdui = getShouldInterleaveSdui,
	getShouldRaisePeekViewBriefHeight = getShouldRaisePeekViewBriefHeight
}
