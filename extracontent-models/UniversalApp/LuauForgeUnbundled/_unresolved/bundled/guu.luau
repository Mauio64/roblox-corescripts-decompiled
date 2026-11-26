local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/guv")
local module2 = require("@luauforge/bundled/ggd")
local module3 = require("@luauforge/bundled/gfG")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local Promise = require(CorePackages.Packages.Promise)
local module5 = require("@luauforge/bundled/fvN")
local experimentCacheManager = require("@luauforge/bundled/ggm").ExperimentCacheManager
local module6 = require("@luauforge/bundled/ggn")
local AppStorageService = game:GetService("AppStorageService")
local module7 = require("@luauforge/bundled/ggq")
local module8 = require("@luauforge/bundled/gfH")
local module9 = require("@luauforge/bundled/dzD")
local MemStorageService = game:GetService("MemStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module10 = require("@luauforge/bundled/gfK")
local module11 = require("@luauforge/bundled/gut")
local module12 = require("@luauforge/bundled/guw")
local GuiService = game:GetService("GuiService")
local module13 = require("@luauforge/bundled/fCM")
local module14 = require("@luauforge/bundled/ggs")
local module15 = require("@luauforge/bundled/geZ")

local module16 = require("@luauforge/bundled/grR")
local module17 = require("@luauforge/bundled/gux")
local defineFastFlag = game:DefineFastFlag("UseResetAppStateForSwitchToAccount2", false)

local function responseHasInvalidStoredSession(p2): boolean
	for k, err in p2.errors do
		if typeof(err) == "table" and err.code == 1 then
			return true
		end
	end

	return false
end

return function(p2, p3, p4, p5, p6, p7)
	return function(object)
		local accountBlob = module3.getAccountBlob()
		local userId = tostring(Models.fromLocalStorage().userId)

		local function fn()
			object:dispatch(module13())
		end

		local function showSwitchFailure(p8)
			if module17 and p7 ~= nil then
				object:dispatch(module12(p8, p7))
			else
				object:dispatch(module11(
					"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
					"Authentication.AccountSwitch.Description.TryLoggingInDirectly.2",
					"CommonUI.Messages.Action.OK",
					"",
					fn,
					nil,
					module9.Auth.AccountSwitcherSwitchError
				))
			end
		end

		return module(p2, p3, accountBlob, userId):andThen(function(p8)
			if p8 == nil or p8.responseBody == nil or p8.responseBody.encrypted_users_data_blob == nil then
				return Promise.reject(false)
			end

			local encrypted_users_data_blob = p8.responseBody.encrypted_users_data_blob

			module3.setAccountBlob(encrypted_users_data_blob)
			module3.flush()

			if p8.responseBody.errors == nil or not (#p8.responseBody.errors > 0) then
				if encrypted_users_data_blob == nil then
					return Promise.reject(false)
				end

				if defineFastFlag then
					object:dispatch(module14())
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
			else
				local flag = true
				local v5

				for k, err in p8.responseBody.errors do
					if typeof(err) == "table" and err.code == 1 then
						v5 = true
						flag = false
						break
					end
				end

				if flag then
					v5 = false
				end

				local v6 = v5 and "invalidStoredSession" or "switchError"

				if module17 and p7 ~= nil then
					object:dispatch(module12(v6, p7))
				else
					object:dispatch(module11(
						"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
						"Authentication.AccountSwitch.Description.TryLoggingInDirectly.2",
						"CommonUI.Messages.Action.OK",
						"",
						fn,
						nil,
						module9.Auth.AccountSwitcherSwitchError
					))
				end

				return Promise.reject(false)
			end
		end, function(p8)
			if module17 and p7 ~= nil then
				object:dispatch(module12("switchError", p7))
			else
				object:dispatch(module11(
					"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
					"Authentication.AccountSwitch.Description.TryLoggingInDirectly.2",
					"CommonUI.Messages.Action.OK",
					"",
					fn,
					nil,
					module9.Auth.AccountSwitcherSwitchError
				))
			end

			return Promise.reject(false)
		end):andThen(function(p8)
			if p8 then
				if userId and userId ~= "-1" and userId ~= "" then
					if module16 then
						GuiService:BroadcastNotification("", module5.DID_SWITCH_ACCOUNT)
					else
						GuiService:BroadcastNotification("", module5.DID_LOG_OUT)
					end
				else
					object:dispatch(module15(p2, p5, p6, p4, module8.Login))
				end
			end
		end, function(p8)
			return Promise.reject(false)
		end)
	end
end
