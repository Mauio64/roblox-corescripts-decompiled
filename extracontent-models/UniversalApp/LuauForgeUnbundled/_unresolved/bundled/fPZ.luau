local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/fQa")
local module2 = require("@luauforge/bundled/fBK")
local module3 = require("@luauforge/bundled/fBn")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local Promise = require(CorePackages.Packages.Promise)
local module5 = require("@luauforge/bundled/fot")
local experimentCacheManager = require("@luauforge/bundled/fBT").ExperimentCacheManager
local module6 = require("@luauforge/bundled/fBU")
local AppStorageService = game:GetService("AppStorageService")
local module7 = require("@luauforge/bundled/fBX")
local module8 = require("@luauforge/bundled/fBo")
local module9 = require("@luauforge/bundled/dwA")
local MemStorageService = game:GetService("MemStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module10 = require("@luauforge/bundled/fBr")
local module11 = require("@luauforge/bundled/fPY")
local GuiService = game:GetService("GuiService")
local module12 = require("@luauforge/bundled/fvl")
local module13 = require("@luauforge/bundled/fBZ")
local module14 = require("@luauforge/bundled/fAH")

local module15 = require("@luauforge/bundled/fNw")
local defineFastFlag = game:DefineFastFlag("UseResetAppStateForSwitchToAccount2", false)

return function(p2, p3, p4, p5, p6)
	return function(object)
		local accountBlob = module3.getAccountBlob()
		local userId = tostring(Models.fromLocalStorage().userId)

		local function fn()
			object:dispatch(module12())
		end

		return module(p2, p3, accountBlob, userId):andThen(function(p7)
			if p7 == nil or p7.responseBody == nil or p7.responseBody.encrypted_users_data_blob == nil then
				return Promise.reject(false)
			end

			local encrypted_users_data_blob = p7.responseBody.encrypted_users_data_blob

			module3.setAccountBlob(encrypted_users_data_blob)
			module3.flush()

			if p7.responseBody.errors ~= nil and #p7.responseBody.errors > 0 then
				object:dispatch(module11(
					"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
					"Authentication.AccountSwitch.Description.TryLoggingInDirectly.2",
					"CommonUI.Messages.Action.OK",
					"",
					fn,
					nil,
					module9.Auth.AccountSwitcherSwitchError
				))

				return Promise.reject(false)
			end

			if encrypted_users_data_blob == nil then
				return Promise.reject(false)
			end

			if defineFastFlag then
				object:dispatch(module13())
			else
				object:dispatch(module2())
				Models.clearLocalStorage()

				experimentCacheManager.default:clearCache()

				if module6() then
					AppStorageService:SetItem(module7.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, "{}")
				end

				module3.setRobloxLocaleId("")
				module3.setDiscoveryClientFallbackCache("")

				MemStorageService:Fire(module10.ThemeUpdate, "dark")
				MemStorageService:SetItem(module10.RobuxBalance, "0")
				MemStorageService:SetItem(module10.RobuxBalanceLocalized, "--")
				RoactAppExperiment.clearUserLayers()
			end

			module3.setAccountSwitchStatus(module9.Auth.AccountSwitcherSwitchedStatus)

			module3.flush()
			return Promise.resolve(true)
		end, function(p7)
			object:dispatch(module11(
				"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
				"Authentication.AccountSwitch.Description.TryLoggingInDirectly.2",
				"CommonUI.Messages.Action.OK",
				"",
				fn,
				nil,
				module9.Auth.AccountSwitcherSwitchError
			))

			return Promise.reject(false)
		end):andThen(function(p7)
			if p7 then
				if userId and userId ~= "-1" and userId ~= "" then
					if module15 then
						GuiService:BroadcastNotification("", module5.DID_SWITCH_ACCOUNT)
					else
						GuiService:BroadcastNotification("", module5.DID_LOG_OUT)
					end
				else
					object:dispatch(module14(p2, p5, p6, p4, module8.Login))
				end
			end
		end, function(p7)
			return Promise.reject(false)
		end)
	end
end
