local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")
local User = require(script.Parent.User)
local Modules = CoreGui.RobloxGui.Modules
local GetFFlagDebugResetSurveyStorage = require(Modules.LuaApp.Flags.GetFFlagDebugResetSurveyStorage)
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local ClearApp = require(Modules.LuaApp.Thunks.Authentication.ClearApp)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local CsatSurveyConstants = require(Modules.LuaApp.Components.OnPlatformSurveys.CsatSurveyConstants)
local Constants = require(Modules.LuaApp.Constants)

local function resetAppState() -- line: 18
	-- upvalues: ClearApp (copy), User (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), AppStorageService (copy), CsatSurveyConstants (copy), Constants (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
	return function(p1) -- line: 19
		-- upvalues: ClearApp (copy), User (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), AppStorageService (copy), CsatSurveyConstants (copy), Constants (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
		p1:dispatch(ClearApp())
		User.clearLocalStorage()
		ExperimentCacheManager.default:clearCache()

		if GetFFlagDebugResetSurveyStorage() then
			AppStorageService:SetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, Constants.Auth.DefaultUnauthenticatedCsatCompletedSurveyIds)
		end

		AppStorageUtilities.setRobloxLocaleId(Constants.Auth.DefaultUnauthenticatedRobloxLocaleId)
		AppStorageUtilities.setDiscoveryClientFallbackCache("")
		MemStorageService:Fire(MemStorageKeys.ThemeUpdate, Constants.Auth.DefaultUnauthenticatedAppTheme)
		MemStorageService:SetItem(MemStorageKeys.RobuxBalance, Constants.Auth.DefaultUnauthenticatedRobuxBalance)
		MemStorageService:SetItem(MemStorageKeys.RobuxBalanceLocalized, Constants.Auth.DefaultUnauthenticatedRobuxBalanceLocalized)
		RoactAppExperiment.clearUserLayers()
	end
end

return resetAppState
