local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TelemetryService = game:GetService("TelemetryService")
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local LoginResult = require(Modules.LuaApp.Models.Authentication.LoginResult)
local LoginErrorCodes = require(CorePackages.Workspace.Packages.AuthCommon).Enums.LoginErrorCodes
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local KeystoreConstants = AuthCommon.Common.KeystoreConstants
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagRemoveKeystoreIxpLogic = SharedFlags.GetFFlagRemoveKeystoreIxpLogic
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local KeystoreGetCredentialsTelemetryConfig = AuthAnalytics.TelemetryConfigs.KeystoreGetCredentialsTelemetryConfig
local KeystoreAutoLoginTelemetryConfig = AuthAnalytics.TelemetryConfigs.KeystoreAutoLoginTelemetryConfig

return function(p1, p2, p3) -- line: 20
	-- upvalues: Promise (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreGetCredentialsTelemetryConfig (copy), HttpService (copy), GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreConstants (copy), KeystoreAutoLoginTelemetryConfig (copy), LoginResult (copy), LoginErrorCodes (copy)
	return function(p4) -- line: 21
		-- upvalues: Promise (copy), p2 (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreGetCredentialsTelemetryConfig (copy), HttpService (copy), GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreConstants (copy), p1 (copy), p3 (copy), KeystoreAutoLoginTelemetryConfig (copy), LoginResult (copy), LoginErrorCodes (copy)
		local u23 = false

		local function keystoreStateImpl(p5) -- line: 23
			-- upvalues: Promise (copy), u23 (ref)
			return function(p6, p7, p8) -- line: 24
				-- upvalues: p5 (copy), Promise (copy), u23 (ref)
				local v32, v33 = p5(p6, p7, p8)

				return v32:andThen(function(p9) -- line: 27
					-- upvalues: Promise (copy)
					return Promise.resolve(p9)
				end):catch(function(p10) -- line: 31
					-- upvalues: u23 (ref), Promise (copy)
					u23 = true

					return Promise.reject(p10)
				end), v33
			end
		end

		return Promise.new(function(resolve, reject) -- line: 40
			-- upvalues: p2 (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreGetCredentialsTelemetryConfig (copy), HttpService (copy), GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreConstants (copy), p1 (copy), Promise (copy), u23 (ref), p3 (copy), p4 (copy), KeystoreAutoLoginTelemetryConfig (copy), LoginResult (copy), LoginErrorCodes (copy)
			local t1 = {
				username = nil,
				userId = nil,
				password = nil
			}

			p2():andThen(function(p11) -- line: 48
				-- upvalues: KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreGetCredentialsTelemetryConfig (copy), reject (copy), t1 (copy), HttpService (copy), GetFFlagRemoveKeystoreIxpLogic (copy), KeystoreConstants (copy), p1 (copy), Promise (copy), u23 (ref), p3 (copy), p4 (copy), KeystoreAutoLoginTelemetryConfig (copy), resolve (copy), LoginResult (copy), LoginErrorCodes (copy)
				if p11 == nil then
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.getCredentialsNilResult)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreGetCredentialsTelemetryConfig, {
							customFields = {
								result = "nil_result"
							}
						}, 1)
					end

					reject({
						credentialsValidForLogin = false,
						redirectToLoginPage = false,
						credentials = t1
					})

					return
				end

				local v35 = HttpService:JSONDecode(p11).response[1]

				t1.username = v35.username
				t1.userId = v35.userId
				t1.password = v35.password

				if GetFFlagRemoveKeystoreIxpLogic() then
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.getCredentials, t1.userId)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreGetCredentialsTelemetryConfig, {
							customFields = {
								result = "has_credentials"
							}
						}, 1)
					end
				else
					t1.experimentGroup = v35.experimentGroup

					local v36 = ({
						[KeystoreConstants.Experiment] = KeystoreEventConstants.origin.getCredentialsExperimentGroup,
						[KeystoreConstants.Control] = KeystoreEventConstants.origin.getCredentialsControlGroup
					})[t1.experimentGroup] or KeystoreEventConstants.origin.getCredentialsNoIxpGroup

					KeystoreAnalyticsEvents.sendPageLoadEvent(v36, t1.userId)

					if t1.experimentGroup ~= KeystoreConstants.Experiment then
						reject({
							credentialsValidForLogin = false,
							redirectToLoginPage = false,
							credentials = t1
						})
					end
				end

				if v35.username == "" then
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.getCredentialsEmptyResult)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreGetCredentialsTelemetryConfig, {
							customFields = {
								result = "empty_result"
							}
						}, 1)
					end

					reject({
						credentialsValidForLogin = false,
						redirectToLoginPage = false,
						credentials = t1
					})

					return
				end

				if not v35.errorCode or v35.errorCode ~= "" then
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.getCredentialsPopulateUsername, t1.userId)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreGetCredentialsTelemetryConfig, {
							customFields = {
								result = "populate_username"
							}
						}, 1)
					end

					reject({
						credentialsValidForLogin = false,
						redirectToLoginPage = true,
						credentials = t1
					})

					return
				end

				local v37 = p1

				p3(function(p12, p13, p14) -- line: 24
					-- upvalues: v37 (copy), Promise (copy), u23 (ref)
					local v44, v45 = v37(p12, p13, p14)

					return v44:andThen(function(p15) -- line: 27
						-- upvalues: Promise (copy)
						return Promise.resolve(p15)
					end):catch(function(p16) -- line: 31
						-- upvalues: u23 (ref), Promise (copy)
						u23 = true

						return Promise.reject(p16)
					end), v45
				end, t1)(p4):andThen(function(p17) -- line: 150
					-- upvalues: KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), t1 (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreAutoLoginTelemetryConfig (copy), u23 (ref), resolve (copy), LoginResult (copy)
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.successfulLogin, t1.userId)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
							customFields = {
								outcome = "success"
							}
						}, 1)
					end

					if u23 then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.gcsCase, t1.userId)

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
								customFields = {
									outcome = "gcs"
								}
							}, 1)
						end

						resolve({
							credentialsValidForLogin = false,
							redirectToLoginPage = false,
							credentials = t1
						})

						return
					end

					if LoginResult.hasTwoStepData(p17) then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.hasTwoStepData, t1.userId)

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
								customFields = {
									outcome = "two_step"
								}
							}, 1)
						end

						resolve({
							credentialsValidForLogin = true,
							redirectToLoginPage = true,
							credentials = t1
						})

						return
					end

					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.regularAccountSuccess, t1.userId)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
							customFields = {
								outcome = "regular_success"
							}
						}, 1)
					end

					resolve({
						credentialsValidForLogin = true,
						redirectToLoginPage = false,
						loginResult = p17,
						credentials = t1
					})
				end):catch(function(p18) -- line: 223
					-- upvalues: KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), t1 (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreAutoLoginTelemetryConfig (copy), u23 (ref), LoginErrorCodes (copy), reject (copy)
					KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.failedLogin, t1.userId)

					if GetFFlagAddPromCounterToKeystoreOps() then
						TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
							customFields = {
								outcome = "failed"
							}
						}, 1)
					end

					local v48 = not u23

					if p18 and p18.errorCode == LoginErrorCodes.IncorrectCValueOrPassword then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.failedLoginIncorrectPassword, t1.userId)

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreAutoLoginTelemetryConfig, {
								customFields = {
									outcome = "failed_incorrect_password"
								}
							}, 1)
						end

						v48 = true
					end

					reject({
						credentialsValidForLogin = false,
						credentials = t1,
						redirectToLoginPage = v48
					})
				end)
			end):catch(function(_) -- line: 262
				-- upvalues: GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreGetCredentialsTelemetryConfig (copy), reject (copy), t1 (copy), u23 (ref)
				if GetFFlagAddPromCounterToKeystoreOps() then
					TelemetryService:LogCounter(KeystoreGetCredentialsTelemetryConfig, {
						customFields = {
							result = "error"
						}
					}, 1)
				end

				reject({
					credentialsValidForLogin = false,
					credentials = t1,
					redirectToLoginPage = not u23
				})
			end)
		end)
	end
end
