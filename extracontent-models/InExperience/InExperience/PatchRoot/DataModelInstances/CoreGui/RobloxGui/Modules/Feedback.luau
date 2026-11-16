local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local GlobalConfig = require(script.GlobalConfig)
local Reducers = require(script.Reducers)
local FeedbackApp = require(script.Components.FeedbackApp)

return {
	initialize = function()
		if GlobalConfig.propValidation then
			Roact.setGlobalConfig({ propValidation = true })
		end

		if GlobalConfig.elementTracing then
			Roact.setGlobalConfig({ elementTracing = true })
		end

		local loggerMiddlewares = { Rodux.thunkMiddleware }

		if GlobalConfig.logStore then
			table.insert(loggerMiddlewares, Rodux.loggerMiddleware)
		end

		local store = Rodux.Store.new(Reducers, nil, loggerMiddlewares)

		local element = Roact.createElement(RoactRodux.StoreProvider, { store = store }, {
			LocalizationProvider = Roact.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					Feedback = Roact.createElement(FeedbackApp)
				}
			)
		})

		Roact.mount(element, CoreGui, "Feedback")
	end
}
