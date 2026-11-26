local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local MemStorageService = game:GetService("MemStorageService")

local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")

local module2 = require("@luauforge/bundled/ggn")

local experimentCacheManager = require("@luauforge/bundled/ggm").ExperimentCacheManager
local module3 = require("@luauforge/bundled/gfG")
local module4 = require("@luauforge/bundled/ggd")
local module5 = require("@luauforge/bundled/gfK")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module6 = require("@luauforge/bundled/ggq")
local module7 = require("@luauforge/bundled/dzD")

local function resetAppState()
	return function(object)
		object:dispatch(module4())
		Models.clearLocalStorage()
		experimentCacheManager.default:clearCache()

		if module2() then
			AppStorageService:SetItem(
				module6.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS,
				module7.Auth.DefaultUnauthenticatedCsatCompletedSurveyIds
			)
		end

		module3.setRobloxLocaleId(module7.Auth.DefaultUnauthenticatedRobloxLocaleId)
		module3.setDiscoveryClientFallbackCache("")
		MemStorageService:Fire(module5.ThemeUpdate, module7.Auth.DefaultUnauthenticatedAppTheme)
		MemStorageService:SetItem(module5.RobuxBalance, module7.Auth.DefaultUnauthenticatedRobuxBalance)
		MemStorageService:SetItem(
			module5.RobuxBalanceLocalized,
			module7.Auth.DefaultUnauthenticatedRobuxBalanceLocalized
		)

		RoactAppExperiment.clearUserLayers()
	end
end

return resetAppState
