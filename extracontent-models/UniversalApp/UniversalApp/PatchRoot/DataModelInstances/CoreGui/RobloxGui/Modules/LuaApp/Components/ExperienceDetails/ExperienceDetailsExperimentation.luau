local CorePackages = game:GetService("CorePackages")
local FFlagSduiExperienceDetailsSocialProof = require(CorePackages.Workspace.Packages._Workspace.SharedFlags.SharedFlags.FFlagSduiExperienceDetailsSocialProof)
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local v4 = game:DefineFastString("LuaAppEdpExperimentLayer", "PlayerApp.GameDetailsPage.Exposure")
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local function getExperimentVariableAndSendExposureLog(s1: string) -- line: 13
	-- upvalues: v4 (copy), ExperimentCacheManager (copy)
	local v12 = v4
	local v13 = ExperimentCacheManager.default:getLayerVariables(v12, true)

	if v13 and v13[s1] ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v12)

		return v13[s1]
	end

	return nil
end
local function getShouldHydrateLegacy() -- line: 25
	-- upvalues: v4 (copy), ExperimentCacheManager (copy)
	local v14 = v4
	local v15 = ExperimentCacheManager.default:getLayerVariables(v14, true)

	if v15 and v15.shouldHydrateLegacy ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v14)

		return v15.shouldHydrateLegacy
	end

	return nil
end
local function getShouldInterleaveSdui() -- line: 29
	-- upvalues: v4 (copy), ExperimentCacheManager (copy)
	local v16 = v4
	local v17 = ExperimentCacheManager.default:getLayerVariables(v16, true)

	if v17 and v17.shouldInterleaveSdui ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v16)

		return v17.shouldInterleaveSdui
	end

	return nil
end
local function getShouldRaisePeekViewBriefHeight() -- line: 33
	-- upvalues: v4 (copy), ExperimentCacheManager (copy)
	local v18 = v4
	local v19 = ExperimentCacheManager.default:getLayerVariables(v18, true)
	local socialProofVariant

	if v19 and v19.socialProofVariant ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v18)
		socialProofVariant = v19.socialProofVariant
	else
		socialProofVariant = nil
	end

	return socialProofVariant == "text"
end

return {
	getShouldHydrateLegacy = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else getShouldHydrateLegacy,
	getShouldInterleaveSdui = if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else getShouldInterleaveSdui,
	getShouldRaisePeekViewBriefHeight = if not FFlagSduiExperienceDetailsSocialProof then nil else getShouldRaisePeekViewBriefHeight
}
