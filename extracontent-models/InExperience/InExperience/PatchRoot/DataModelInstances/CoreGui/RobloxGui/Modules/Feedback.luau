local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local GlobalConfig = require(script.GlobalConfig)
local Reducers = require(script.Reducers)
local FeedbackApp = require(script.Components.FeedbackApp)

return {
	initialize = function() -- line: 23
		-- upvalues: GlobalConfig (copy), Roact (copy), Rodux (copy), Reducers (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), FeedbackApp (copy), CoreGui (copy)
		if GlobalConfig.propValidation then
			Roact.setGlobalConfig({
				propValidation = true
			})
		end

		if GlobalConfig.elementTracing then
			Roact.setGlobalConfig({
				elementTracing = true
			})
		end

		local t1 = { Rodux.thunkMiddleware }

		if GlobalConfig.logStore then
			table.insert(t1, Rodux.loggerMiddleware)
		end

		local v13 = Rodux.Store.new(Reducers, nil, t1)
		local v14 = Roact.createElement(RoactRodux.StoreProvider, {
			store = v13
		}, {
			LocalizationProvider = Roact.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				Feedback = Roact.createElement(FeedbackApp)
			})
		})

		Roact.mount(v14, CoreGui, "Feedback")
	end
}
