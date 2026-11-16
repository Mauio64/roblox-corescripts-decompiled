local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("SharedFlags").Parent
local AppCommonLib = require(parent.AppCommonLib)
local AppStorageJsonCacheUtils = AppCommonLib.Utils.AppStorageJsonCacheUtils

local GetFFlagEnableAppStorageJsonCacheInABTest = require(script.Parent.GetFFlagEnableAppStorageJsonCacheInABTest)

local defineFastString = game:DefineFastString("ExperienceReactDeferredScheduler_LayerName", "UIEcosystem.User")

return function()
	if GetFFlagEnableAppStorageJsonCacheInABTest() then
		local cachedJsonForKey = AppStorageJsonCacheUtils.default:getCachedJsonForKey("ExperimentCache")

		if cachedJsonForKey then
			return cachedJsonForKey[defineFastString]
		end
	else
		local success, result = pcall(function()
			return AppStorageService:GetItem("ExperimentCache")
		end)

		if success then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if success2 and result2 then
				return result2[defineFastString]
			end
		end
	end

	return nil
end
