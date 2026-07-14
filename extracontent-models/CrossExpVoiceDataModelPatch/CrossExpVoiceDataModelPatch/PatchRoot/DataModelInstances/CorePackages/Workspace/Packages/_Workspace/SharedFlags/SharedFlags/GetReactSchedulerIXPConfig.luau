local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SharedFlags").Parent
local AppStorageJsonCacheUtils = require(Parent.AppCommonLib).Utils.AppStorageJsonCacheUtils
local GetFFlagEnableAppStorageJsonCacheInABTest = require(script.Parent.GetFFlagEnableAppStorageJsonCacheInABTest)
local v6 = game:DefineFastString("ExperienceReactDeferredScheduler_LayerName", "UIEcosystem.User")
local v7 = game:DefineFastFlag("EnableReactSchedulerIXP", false)

return function() -- line: 28
	-- upvalues: v7 (copy), GetFFlagEnableAppStorageJsonCacheInABTest (copy), AppStorageJsonCacheUtils (copy), v6 (copy), AppStorageService (copy), HttpService (copy)
	if not v7 then
		return nil
	end

	if GetFFlagEnableAppStorageJsonCacheInABTest() then
		local v8 = AppStorageJsonCacheUtils.default:getCachedJsonForKey("ExperimentCache")

		if v8 then
			return v8[v6]
		end
	else
		local ok, result = pcall(function() -- line: 39
			-- upvalues: AppStorageService (copy)
			return AppStorageService:GetItem("ExperimentCache")
		end)

		if ok then
			local ok2, result2 = pcall(function() -- line: 43
				-- upvalues: HttpService (copy), result (copy)
				return HttpService:JSONDecode(result)
			end)

			if ok2 and result2 then
				return result2[v6]
			end
		end
	end

	return nil
end
