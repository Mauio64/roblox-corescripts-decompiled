local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
require(CorePackages.Packages.UIBlox)

local Dependencies = require(script.Dependencies)
local Localization = Dependencies.Localization
local LocalizationProvider = require(Dependencies.LocalizationProvider)
local playerInterface = require(Dependencies.playerInterface)

local Constants = require(script.Resources.Constants)
local GlobalConfig = require(script.GlobalConfig)
local Reducers = require(script.Reducers)
local TrustAndSafetyApp = require(script.Components.TrustAndSafetyApp)
local TrustAndSafetyAppPolicy = require(script.TrustAndSafetyAppPolicy)

require(script.Actions.OpenReportDialog)
require(script.Actions.OpenReportMenu)
local BeginReportFlow = require(script.Actions.BeginReportFlow)
local SetVoiceReportingFlow = require(script.Actions.SetVoiceReportingFlow)
local SessionUtility = require(script.Utility.SessionUtility)

local FetchPlaceInfo = require(script.Thunks.FetchPlaceInfo)

local v = {
	getInstance = function(self)
		if not self._initialized then
			self:initialize()
			self._initialized = true
		end

		return self
	end,
	initialize = function(self)
		if GlobalConfig.propValidation then
			Roact.setGlobalConfig({ propValidation = true })
		end

		if GlobalConfig.elementTracing then
			Roact.setGlobalConfig({ elementTracing = true })
		end

		self.store = self:createStore()
		self.store:dispatch(FetchPlaceInfo(game.GameId))

		self.localization = self:createLocalization()

		self.root = Roact.createElement(RoactRodux.StoreProvider, { store = self.store }, {
			PolicyProvider = Roact.createElement(TrustAndSafetyAppPolicy.Provider, {
				policy = { TrustAndSafetyAppPolicy.Mapper }
			}, {
				LocalizationProvider = Roact.createElement(LocalizationProvider, {
					localization = self.localization
				}, {
					TrustAndSafety = Roact.createElement(TrustAndSafetyApp)
				})
			})
		})

		self.element = Roact.mount(self.root, CoreGui, "TrustAndSafety")
	end,
	createStore = function(self)
		local loggerMiddlewares = { Rodux.thunkMiddleware }

		if GlobalConfig.logStore then
			table.insert(loggerMiddlewares, Rodux.loggerMiddleware)
		end

		return Rodux.Store.new(Reducers, nil, loggerMiddlewares)
	end,
	createLocalization = function(self)
		local robloxLocaleId = LocalizationService.RobloxLocaleId
		local localization = Localization.new(robloxLocaleId)

		LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
			localization:SetLocale(LocalizationService.RobloxLocaleId)
		end)

		return localization
	end,
	openReportDialog = function(self, p, p2)
		self.store:dispatch(SetVoiceReportingFlow(true))
		self.store:dispatch(BeginReportFlow(p, p2))
	end,
	openReportMenu = function(self)
		self.store:dispatch(SetVoiceReportingFlow(true))
		self.store:dispatch(BeginReportFlow())
	end
}
local TrustAndSafety = {}

function TrustAndSafety.openReportDialogForPlayer(p, p2)
	assert(playerInterface(p) and t.instanceIsA("Player")(p))
	SessionUtility.startAbuseReportSession(p2)
	v:getInstance():openReportDialog(Constants.ReportType.Player, p)
end
function TrustAndSafety.openReportDialogForPlace(p)
	SessionUtility.startAbuseReportSession(p)
	v:getInstance():openReportDialog(Constants.ReportType.Place)
end
function TrustAndSafety:openReportMenu()
	SessionUtility.startAbuseReportSession(self)
	v:getInstance():openReportMenu()
end

return TrustAndSafety
