local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local TelemetryService = game:GetService("TelemetryService")
local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/fDB")
local loginErrorCodes = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.LoginErrorCodes
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local module3 = require("@luauforge/bundled/fsz")
local keystoreGetCredentialsTelemetryConfig = module3.TelemetryConfigs.KeystoreGetCredentialsTelemetryConfig
local keystoreAutoLoginTelemetryConfig = module3.TelemetryConfigs.KeystoreAutoLoginTelemetryConfig

local credentialsProtocolErrorCodes = require("@luauforge/bundled/fCb").CredentialsProtocolErrorCodes

local module4 = require("@luauforge/bundled/fDC")

return function(p2, callback, callback2)
	return function(p3)
		local flag = false
		local function keystoreStateImpl(callback3)
			return function(p4, p5, p6)
				local v5, v6 = callback3(p4, p5, p6)

				return v5:andThen(function(p7)
					return Promise.resolve(p7)
				end):catch(function(p7)
					flag = true
					return Promise.reject(p7)
				end), v6
			end
		end

		return Promise.new(function(callback3, callback4)
			local v5 = { username = nil, userId = nil, password = nil }

			callback():andThen(function(json)
				if json == nil then
					keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.getCredentialsNilResult)
					TelemetryService:LogCounter(keystoreGetCredentialsTelemetryConfig, {
						customFields = { result = "nil_result" }
					}, 1)

					callback4({
						credentials = v5,
						credentialsValidForLogin = false,
						redirectToLoginPage = false
					})
				else
					local v6 = HttpService:JSONDecode(json)

					if module4 and v6.response == nil and v6.errorCode ~= nil then
						local errorCode = tostring(v6.errorCode)

						v6 = credentialsProtocolErrorCodes.GetCredentialsErrorCodes[tonumber(errorCode) or -1] == "NO_CREDENTIALS_FOUND"
							and {
								response = {
									{
										username = "",
										userId = "",
										password = "",
										errorCode = errorCode
									}
								}
							}
							or v6
					end

					local v7 = v6.response[1]

					v5.username = v7.username
					v5.userId = v7.userId
					v5.password = v7.password

					keystoreAnalyticsEvents.sendPageLoadEvent(
						keystoreEventConstants.origin.getCredentials,
						v5.userId
					)
					TelemetryService:LogCounter(keystoreGetCredentialsTelemetryConfig, {
						customFields = { result = "has_credentials" }
					}, 1)

					if v7.username == "" then
						keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.getCredentialsEmptyResult)
						TelemetryService:LogCounter(keystoreGetCredentialsTelemetryConfig, {
							customFields = { result = "empty_result" }
						}, 1)

						callback4({
							credentials = v5,
							credentialsValidForLogin = false,
							redirectToLoginPage = false
						})
					elseif v7.errorCode and v7.errorCode == "" then
						local v8 = p2
						callback2(function(p4, p5, p6)
							local v9, v10 = v8(p4, p5, p6)

							return v9:andThen(function(p7)
								return Promise.resolve(p7)
							end):catch(function(p7)
								flag = true
								return Promise.reject(p7)
							end), v10
						end, v5)(p3):andThen(function(p4)
							keystoreAnalyticsEvents.sendPageLoadEvent(
								keystoreEventConstants.origin.successfulLogin,
								v5.userId
							)

							TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
								customFields = { outcome = "success" }
							}, 1)

							if flag then
								keystoreAnalyticsEvents.sendPageLoadEvent(
									keystoreEventConstants.origin.gcsCase,
									v5.userId
								)

								TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
									customFields = { outcome = "gcs" }
								}, 1)

								callback3({
									credentials = v5,
									credentialsValidForLogin = false,
									redirectToLoginPage = false
								})
							elseif module.hasTwoStepData(p4) then
								keystoreAnalyticsEvents.sendPageLoadEvent(
									keystoreEventConstants.origin.hasTwoStepData,
									v5.userId
								)

								TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
									customFields = { outcome = "two_step" }
								}, 1)

								callback3({
									credentials = v5,
									credentialsValidForLogin = true,
									redirectToLoginPage = true
								})
							else
								keystoreAnalyticsEvents.sendPageLoadEvent(
									keystoreEventConstants.origin.regularAccountSuccess,
									v5.userId
								)

								TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
									customFields = { outcome = "regular_success" }
								}, 1)

								callback3({
									loginResult = p4,
									credentials = v5,
									credentialsValidForLogin = true,
									redirectToLoginPage = false
								})
							end
						end):catch(function(p4)
							keystoreAnalyticsEvents.sendPageLoadEvent(
								keystoreEventConstants.origin.failedLogin,
								v5.userId
							)

							TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
								customFields = { outcome = "failed" }
							}, 1)

							local v9 = not flag

							if p4 and p4.errorCode == loginErrorCodes.IncorrectCValueOrPassword then
								keystoreAnalyticsEvents.sendPageLoadEvent(
									keystoreEventConstants.origin.failedLoginIncorrectPassword,
									v5.userId
								)

								TelemetryService:LogCounter(keystoreAutoLoginTelemetryConfig, {
									customFields = {
										outcome = "failed_incorrect_password"
									}
								}, 1)
								v9 = true
							end

							callback4({
								credentials = v5,
								credentialsValidForLogin = false,
								redirectToLoginPage = v9
							})
						end)
					else
						keystoreAnalyticsEvents.sendPageLoadEvent(
							keystoreEventConstants.origin.getCredentialsPopulateUsername,
							v5.userId
						)

						TelemetryService:LogCounter(keystoreGetCredentialsTelemetryConfig, {
							customFields = { result = "populate_username" }
						}, 1)

						callback4({
							credentials = v5,
							credentialsValidForLogin = false,
							redirectToLoginPage = true
						})
					end
				end
			end):catch(function(p4)
				TelemetryService:LogCounter(keystoreGetCredentialsTelemetryConfig, {
					customFields = { result = "error" }
				}, 1)

				callback4({
					credentials = v5,
					credentialsValidForLogin = false,
					redirectToLoginPage = not flag
				})
			end)
		end)
	end
end
