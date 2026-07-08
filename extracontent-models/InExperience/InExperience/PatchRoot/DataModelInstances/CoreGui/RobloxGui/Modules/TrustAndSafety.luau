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
local IdentifyAvatars = require(script.Thunks.IdentifyAvatars)
local SessionUtility = require(script.Utility.SessionUtility)
local ScreenshotHookManager = require(script.Utility.ScreenshotHookManager)
local FetchPlaceInfo = require(script.Thunks.FetchPlaceInfo)
local GetFFlagReportAnythingScreenshot = require(script.Flags.GetFFlagReportAnythingScreenshot)
local t2 = {
	getInstance = function(p1) -- line: 36
		if not p1._initialized then
			p1:initialize()
			p1._initialized = true
		end

		return p1
	end,
	initialize = function(p2) -- line: 45
		-- upvalues: GlobalConfig (copy), Roact (copy), FetchPlaceInfo (copy), RoactRodux (copy), TrustAndSafetyAppPolicy (copy), LocalizationProvider (copy), TrustAndSafetyApp (copy), CoreGui (copy)
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

		p2.store = p2:createStore()
		p2.store:dispatch(FetchPlaceInfo(game.GameId))
		p2.localization = p2:createLocalization()
		p2.root = Roact.createElement(RoactRodux.StoreProvider, {
			store = p2.store
		}, {
			PolicyProvider = Roact.createElement(TrustAndSafetyAppPolicy.Provider, {
				policy = { TrustAndSafetyAppPolicy.Mapper }
			}, {
				LocalizationProvider = Roact.createElement(LocalizationProvider, {
					localization = p2.localization
				}, {
					TrustAndSafety = Roact.createElement(TrustAndSafetyApp)
				})
			})
		})
		p2.element = Roact.mount(p2.root, CoreGui, "TrustAndSafety")
	end,
	createStore = function(_) -- line: 79
		-- upvalues: Reducers (copy), Rodux (copy), GlobalConfig (copy)
		local v28 = Reducers
		local t1 = { Rodux.thunkMiddleware }

		if GlobalConfig.logStore then
			table.insert(t1, Rodux.loggerMiddleware)
		end

		return Rodux.Store.new(v28, nil, t1)
	end,
	createLocalization = function(_) -- line: 90
		-- upvalues: LocalizationService (copy), Localization (copy)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId
		local v32 = Localization.new(RobloxLocaleId)

		LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 94
			-- upvalues: LocalizationService (copy), v32 (copy)
			local RobloxLocaleId2 = LocalizationService.RobloxLocaleId

			v32:SetLocale(RobloxLocaleId2)
		end)

		return v32
	end,
	openReportDialog = function(p5, p6, p7) -- line: 102
		-- upvalues: SetVoiceReportingFlow (copy), GetFFlagReportAnythingScreenshot (copy), IdentifyAvatars (copy), BeginReportFlow (copy)
		p5.store:dispatch(SetVoiceReportingFlow(true))

		if GetFFlagReportAnythingScreenshot() then
			p5.store:dispatch(IdentifyAvatars())
		end

		p5.store:dispatch(BeginReportFlow(p6, p7))
	end,
	openReportMenu = function(p8) -- line: 110
		-- upvalues: SetVoiceReportingFlow (copy), GetFFlagReportAnythingScreenshot (copy), IdentifyAvatars (copy), BeginReportFlow (copy)
		p8.store:dispatch(SetVoiceReportingFlow(true))

		if GetFFlagReportAnythingScreenshot() then
			p8.store:dispatch(IdentifyAvatars())
		end

		p8.store:dispatch(BeginReportFlow())
	end
}

return {
	openReportDialogForPlayer = function(p9, p10) -- line: 119
		-- upvalues: playerInterface (copy), t (copy), SessionUtility (copy), t2 (copy), Constants (copy)
		assert(playerInterface(p9) and t.instanceIsA("Player")(p9))
		SessionUtility.startAbuseReportSession(p10)
		t2:getInstance():openReportDialog(Constants.ReportType.Player, p9)
	end,
	openReportDialogForPlace = function(p11) -- line: 124
		-- upvalues: SessionUtility (copy), t2 (copy), Constants (copy)
		SessionUtility.startAbuseReportSession(p11)
		t2:getInstance():openReportDialog(Constants.ReportType.Place)
	end,
	openReportMenu = function(p12) -- line: 128
		-- upvalues: SessionUtility (copy), t2 (copy)
		SessionUtility.startAbuseReportSession(p12)
		t2:getInstance():openReportMenu()
	end,
	setPreReportScreenshotHook = function(p13) -- line: 132
		-- upvalues: ScreenshotHookManager (copy)
		ScreenshotHookManager.setPreScreenshotHook(p13)
	end,
	setPostReportScreenshotHook = function(p14) -- line: 135
		-- upvalues: ScreenshotHookManager (copy)
		ScreenshotHookManager.setPostScreenshotHook(p14)
	end
}
