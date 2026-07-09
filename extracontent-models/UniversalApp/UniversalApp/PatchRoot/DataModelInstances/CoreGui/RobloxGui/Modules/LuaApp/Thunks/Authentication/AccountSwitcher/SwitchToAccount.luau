local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local SwitchAccount = require(Modules.LuaApp.Http.Requests.AccountSwitcher.SwitchAccount)
local ClearApp = require(script.Parent.Parent.ClearApp)
local AppStorageUtilities = require(script.Parent.Parent.AppStorageUtilities)
local User = require(script.Parent.Parent.User)
local Promise = require(CorePackages.Packages.Promise)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local GetFFlagDebugResetSurveyStorage = require(Modules.LuaApp.Flags.GetFFlagDebugResetSurveyStorage)
local AppStorageService = game:GetService("AppStorageService")
local CsatSurveyConstants = require(Modules.LuaApp.Components.OnPlatformSurveys.CsatSurveyConstants)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local Constants = require(Modules.LuaApp.Constants)
local MemStorageService = game:GetService("MemStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local OpenAccountSwitchingErrorOverlay = require(script.Parent.Parent.OpenAccountSwitchingErrorOverlay)
local GuiService = game:GetService("GuiService")
local CloseCentralOverlay = require(script.Parent.Parent.Parent.CloseCentralOverlay)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local FFlagLuaEnableDidSwitchAccount = require(Modules.LuaApp.Flags.FFlagLuaEnableDidSwitchAccount)
local v24 = game:DefineFastFlag("UseResetAppStateForSwitchToAccount2", false)
local GetFFlagEnableAccountSwitcherFoundationDesign = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign

return function(p1, p2, p3, p4, p5) -- line: 30
	-- upvalues: AppStorageUtilities (copy), User (copy), CloseCentralOverlay (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), Constants (copy), SwitchAccount (copy), Promise (copy), v24 (copy), ResetAppState (copy), ClearApp (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), AppStorageService (copy), CsatSurveyConstants (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), LaunchApp (copy), LaunchContext (copy)
	return function(p6) -- line: 31
		-- upvalues: AppStorageUtilities (copy), User (copy), CloseCentralOverlay (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), Constants (copy), SwitchAccount (copy), p1 (copy), p2 (copy), Promise (copy), v24 (copy), ResetAppState (copy), ClearApp (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), AppStorageService (copy), CsatSurveyConstants (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), LaunchApp (copy), p4 (copy), p5 (copy), p3 (copy), LaunchContext (copy)
		local v32 = AppStorageUtilities.getAccountBlob()
		local str = tostring(User.fromLocalStorage().userId)

		local function v34() -- line: 35
			-- upvalues: p6 (copy), CloseCentralOverlay (copy)
			p6:dispatch(CloseCentralOverlay())
		end

		return SwitchAccount(p1, p2, v32, str):andThen(function(p7) -- line: 55
			-- upvalues: Promise (copy), AppStorageUtilities (copy), p6 (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), v34 (copy), Constants (copy), v24 (copy), ResetAppState (copy), ClearApp (copy), User (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), AppStorageService (copy), CsatSurveyConstants (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
			if p7 == nil or (p7.responseBody == nil or p7.responseBody.encrypted_users_data_blob == nil) then
				return Promise.reject(false)
			end

			local encrypted_users_data_blob = p7.responseBody.encrypted_users_data_blob

			AppStorageUtilities.setAccountBlob(encrypted_users_data_blob)
			AppStorageUtilities.flush()

			if p7.responseBody.errors ~= nil and #p7.responseBody.errors > 0 then
				p6:dispatch(OpenAccountSwitchingErrorOverlay(not GetFFlagEnableAccountSwitcherFoundationDesign() and "Authentication.AccountSwitch.Header.CantSwitchAccounts" or "Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase", "Authentication.AccountSwitch.Description.TryLoggingInDirectly.2", "CommonUI.Messages.Action.OK", "", v34, nil, Constants.Auth.AccountSwitcherSwitchError))

				return Promise.reject(false)
			end

			if encrypted_users_data_blob ~= nil then
				if v24 then
					p6:dispatch(ResetAppState())
				else
					p6:dispatch(ClearApp())
					User.clearLocalStorage()
					ExperimentCacheManager.default:clearCache()

					if GetFFlagDebugResetSurveyStorage() then
						AppStorageService:SetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, "{}")
					end

					AppStorageUtilities.setRobloxLocaleId("")
					AppStorageUtilities.setDiscoveryClientFallbackCache("")
					MemStorageService:Fire(MemStorageKeys.ThemeUpdate, "dark")
					MemStorageService:SetItem(MemStorageKeys.RobuxBalance, "0")
					MemStorageService:SetItem(MemStorageKeys.RobuxBalanceLocalized, "--")
					RoactAppExperiment.clearUserLayers()
				end

				AppStorageUtilities.setAccountSwitchStatus(Constants.Auth.AccountSwitcherSwitchedStatus)

				return Promise.resolve(true)
			end

			return Promise.reject(false)
		end, function(_) -- line: 93
			-- upvalues: p6 (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), v34 (copy), Constants (copy), Promise (copy)
			p6:dispatch(OpenAccountSwitchingErrorOverlay(not GetFFlagEnableAccountSwitcherFoundationDesign() and "Authentication.AccountSwitch.Header.CantSwitchAccounts" or "Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase", "Authentication.AccountSwitch.Description.TryLoggingInDirectly.2", "CommonUI.Messages.Action.OK", "", v34, nil, Constants.Auth.AccountSwitcherSwitchError))

			return Promise.reject(false)
		end):andThen(function(p9) -- line: 97
			-- upvalues: str (copy), FFlagLuaEnableDidSwitchAccount (copy), GuiService (copy), NotificationType (copy), p6 (copy), LaunchApp (copy), p1 (copy), p4 (copy), p5 (copy), p3 (copy), LaunchContext (copy)
			if p9 then
				if str and str ~= "-1" and str ~= "" then
					if FFlagLuaEnableDidSwitchAccount then
						GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)

						return
					end

					GuiService:BroadcastNotification("", NotificationType.DID_LOG_OUT)

					return
				end

				p6:dispatch(LaunchApp(p1, p4, p5, p3, LaunchContext.Login))
			end
		end, function(_) -- line: 113
			-- upvalues: Promise (copy)
			return Promise.reject(false)
		end)
	end
end
