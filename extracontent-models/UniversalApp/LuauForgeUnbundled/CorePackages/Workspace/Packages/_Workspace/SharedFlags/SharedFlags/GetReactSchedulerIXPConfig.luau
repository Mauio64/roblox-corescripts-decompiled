local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local appStorageJsonCacheUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/AppCommonLib").Utils.AppStorageJsonCacheUtils

local GetFFlagEnableAppStorageJsonCacheInABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAppStorageJsonCacheInABTest")

local defineFastString = game:DefineFastString(
	"ExperienceReactDeferredScheduler_LayerName",
	"UIEcosystem.User"
)

return function()
	if GetFFlagEnableAppStorageJsonCacheInABTest() then
		local cachedJsonForKey = appStorageJsonCacheUtils.default:getCachedJsonForKey("ExperimentCache")

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
