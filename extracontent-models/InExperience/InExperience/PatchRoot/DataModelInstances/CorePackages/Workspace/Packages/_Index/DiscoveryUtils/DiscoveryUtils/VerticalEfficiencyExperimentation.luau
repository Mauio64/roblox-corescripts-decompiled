local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("LuaAppVerticalEfficiencyExpLayer", "PlayerApp.HomePage.UX")

local function getIsUserInTreatmentAndSendExposureLog(s1: string) -- line: 12
	-- upvalues: v3 (copy), ExperimentCacheManager (copy)
	local v6 = v3
	local v7 = ExperimentCacheManager.default:getLayerVariables(v6, true)

	if v7 and v7[s1] ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v6)

		return v7[s1]
	end

	return false
end

return {
	getIsProfileMovedToTopBar = function() -- line: 24
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v8 = v3
		local v9 = ExperimentCacheManager.default:getLayerVariables(v8, true)

		if v9 and v9.IsProfileMovedToTopBar ~= nil then
			ExperimentCacheManager.default:sendCustomExposureLog(v8)

			return v9.IsProfileMovedToTopBar
		end

		return false
	end,
	getIsRobloxLogoHeaderEnabled = function() -- line: 28
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v10 = v3
		local v11 = ExperimentCacheManager.default:getLayerVariables(v10, true)

		if v11 and v11.IsRobloxLogoHeaderEnabled ~= nil then
			ExperimentCacheManager.default:sendCustomExposureLog(v10)

			return v11.IsRobloxLogoHeaderEnabled
		end

		return false
	end
}
