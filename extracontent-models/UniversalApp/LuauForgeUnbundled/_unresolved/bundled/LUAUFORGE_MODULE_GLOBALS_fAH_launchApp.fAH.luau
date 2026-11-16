local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")

local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local getLocalUser = require("@luauforge/bundled/cgr").Thunks.GetLocalUser
local setLaunchContext = require("@luauforge/bundled/cyM").Actions.SetLaunchContext
local module2 = require("@luauforge/bundled/dHq")
local module3 = require("@luauforge/bundled/fAJ")
local module4 = require("@luauforge/bundled/fAL")
local module5 = require("@luauforge/bundled/fBn")
local module6 = require("@luauforge/bundled/dCp")
local module7 = require("@luauforge/bundled/dCo")
local module8 = require("@luauforge/bundled/fBo")
local module9 = require("@luauforge/bundled/fBp")
local module10 = require("@luauforge/bundled/fBq")
local module11 = require("@luauforge/bundled/fBr")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local postSignUpAttribution = require("@luauforge/bundled/fBs").PostSignUpAttribution

local getFFlagEnableAdConsentAttribution = require("@luauforge/bundled/bXh").getFFlagEnableAdConsentAttribution
local module12 = require("@luauforge/bundled/fBH")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module13 = require("@luauforge/bundled/fBJ")
local module14 = require("@luauforge/bundled/dwA")
local accountSwitcherConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.AccountSwitcherConstants
local module15 = require("@luauforge/bundled/fDw")

local getCredentialsAvailabilityStore = require("@game/CorePackages/Workspace/Packages/AuthCommon").Stores.GetCredentialsAvailabilityStore

local parseCredentialsProtocolIsAvailableResponse = require("@game/CorePackages/Workspace/Packages/AuthCommon").Utils.parseCredentialsProtocolIsAvailableResponse

local receivedUserCountryCode = require("@luauforge/bundled/dxT").ReceivedUserCountryCode

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local module17 = require("@luauforge/bundled/fDx")
local module18 = require("@luauforge/bundled/fDy")
local module19 = require("@luauforge/bundled/fDz")
local fFlagApplyLaunchContextForNewAccountSwitches = SharedFlags.FFlagApplyLaunchContextForNewAccountSwitches

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local fFlagUseIsAvailableCheckForIOSKeychainFetch = SharedFlags.FFlagUseIsAvailableCheckForIOSKeychainFetch
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local fFlagEdpGameLeavePromptsPassIsRecentInstall = SharedFlags.FFlagEdpGameLeavePromptsPassIsRecentInstall

local module20 = require("@luauforge/bundled/fCc")
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable

local module21 = require("@luauforge/bundled/fDA")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local module22 = require("@luauforge/bundled/fDD")
local module23 = require("@luauforge/bundled/fDF")
local keystoreConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.KeystoreConstants

local module24 = require("@luauforge/bundled/fsz")

local checkForAndFireValidCookieForNoCachedUserEvent = module24.RobloxTelemetry.CheckForAndFireValidCookieForNoCachedUserEvent
local telemetryConfigs = module24.TelemetryConfigs

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module25 = require("@luauforge/bundled/fDG")
local isPioneerLaunch = require("@luauforge/bundled/fDJ").isPioneerLaunch

local module26 = require("@luauforge/bundled/fFe")
local defineFastFlag = game:DefineFastFlag("DisableListenToSessionTerminalStatus", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppDeferLaunch", false)

local defineFastFlag3 = game:DefineFastFlag("LuaAppSetCachedUserInLaunchThread", false)

local module27 = require("@luauforge/bundled/fFf")
local status = module27.Status
local module28 = require("@luauforge/bundled/fFh")
local handleSessionCheckSuccess = module28.handleSessionCheckSuccess
local handleSessionCheckFailure = module28.handleSessionCheckFailure

local Promise = require(CorePackages.Packages.Promise)

local module29 = require("@luauforge/bundled/fCb")
local default2 = module29.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module29.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local fFlagEnableLoginV2Modalization = SharedFlags.FFlagEnableLoginV2Modalization
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dxT").GetCountryCodeStore else nil

local function initializeForCachedUser(p2, p3, p4, p5, object, p6, object2, p7, p8, p9, p10, p11)
	if not defineFastFlag3 then
		object:setToLocalPlayer()
	end

	local v5 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and ""
		or module5.getSignupActionRequired()

	local authenticatedTheme = module5.getAuthenticatedTheme()
	local v6 = v5 == "auth" and (module18() or module19())

	if fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
		MemStorageService:Fire(module11.ThemeUpdate, "dark")
	elseif authenticatedTheme ~= "" and not v6 then
		MemStorageService:Fire(module11.ThemeUpdate, authenticatedTheme)
	end

	RoactAppExperiment.initializeUserLayers(object.userId)

	local v7 = if defineFastFlag2 then task.defer else spawn
	v7(function()
		if defineFastFlag3 then
			object:setToLocalPlayer()
		end

		object2:dispatch(getLocalUser())

		if fFlagUseSignalsForCountryCode then
			getCountryCodeStore(false).setCountryCode(object.countryCode)
		else
			object2:dispatch(receivedUserCountryCode(object.countryCode))
		end

		if p9 and object.isUnder13 then
			object2:dispatch(module2({
				{ name = module6.UAppBlock }
			}))
		elseif v5 == "auth" then
			if module18() or module19() then
				object2:dispatch(module2({
					{ name = module6.AddAuthMethodPage }
				}))
			else
				module5.setSignupActionRequired("")
				module5.flush()
				object2:dispatch(module2({
					{ name = p6 }
				}))
			end
		else
			object2:dispatch(module2({
				{ name = p6 }
			}))
		end

		local function fn()
			return object2:dispatch(module4(p2, p3, p4, p5, p8, p10, p11))
		end

		object2:dispatch(module4(p2, p3, p4, p5, p8, p10, p11))

		module25(p2, object, p7, true, object2, p6, fn, p8, p9, true)
	end)
end

local function handleNavWithDataLoadAndSessionCheck(object, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14)
	spawn(function()
		object:dispatch(getLocalUser())

		if fFlagUseSignalsForCountryCode then
			getCountryCodeStore(false).setCountryCode(p2.countryCode)
		else
			object:dispatch(receivedUserCountryCode(p2.countryCode))
		end

		if p3 and p2.isUnder13 then
			object:dispatch(module2({
				{ name = module6.UAppBlock }
			}))
		elseif p4 == "auth" then
			if module18() or module19() then
				object:dispatch(module2({
					{ name = module6.AddAuthMethodPage }
				}))
			else
				module5.setSignupActionRequired("")
				module5.flush()
				object:dispatch(module2({
					{ name = p5 }
				}))
			end
		else
			object:dispatch(module2({
				{ name = p5 }
			}))
		end

		local function fn()
			return object:dispatch(module4(p6, p7, p8, p9, p10, p11, p12))
		end

		object:dispatch(module4(p6, p7, p8, p9, p10, p11, p12))

		module25(p6, p2, p14, p13, object, p5, fn, p10, p3, true)
	end)
end

local function initializeForCachedUserV2(p2, p3, p4, p5, object, p6, object2, p7, p8, p9, p10, p11)
	object:setToLocalPlayer()

	local v5 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and ""
		or module5.getSignupActionRequired()

	local authenticatedTheme = module5.getAuthenticatedTheme()
	local v6 = v5 == "auth" and (module18() or module19())
	local v7 = authenticatedTheme ~= "light" and authenticatedTheme ~= "dark" and "dark"
		or authenticatedTheme
	local v8 = (v6 or fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()) and "dark" or v7

	MemStorageService:Fire(module11.ThemeUpdate, v8)

	RoactAppExperiment.initializeUserLayers(object.userId)

	local function fn()
		return object2:dispatch(module4(p2, p3, p4, p5, p8, p10, p11))
	end

	if defineFastFlag then
		module27:listenToSessionStatusChange(function(data)
			local status2 = data.status

			if status2 == status.Success then
				object2:dispatch(getLocalUser())

				if fFlagUseSignalsForCountryCode then
					getCountryCodeStore(false).setCountryCode(object.countryCode)
				else
					object2:dispatch(receivedUserCountryCode(object.countryCode))
				end

				if p9 and object.isUnder13 then
					object2:dispatch(module2({
						{ name = module6.UAppBlock }
					}))
				elseif v5 == "auth" then
					if module18() or module19() then
						object2:dispatch(module2({
							{ name = module6.AddAuthMethodPage }
						}))
					else
						module5.setSignupActionRequired("")
						module5.flush()
						object2:dispatch(module2({
							{ name = p6 }
						}))
					end
				else
					object2:dispatch(module2({
						{ name = p6 }
					}))
				end

				object2:dispatch(module4(p2, p3, p4, p5, p8, p10, p11))

				handleSessionCheckSuccess(p2, object, p7, true, object2, p6, fn, p8, p9, true)
			elseif status2 == status.Failed then
				local httpStatusCode = data.httpStatusCode or data.errorStatus

				handleSessionCheckFailure(httpStatusCode, true, object2, p2, p7, object, p6, fn)
			else
				local v9 = object2
				local v10 = object
				local v11 = p9
				local v12 = v5
				local v13 = p6
				local v14 = p2
				local v15 = p3
				local v16 = p4
				local v17 = p5
				local v18 = p8
				local v19 = p10
				local v20 = p11

				local v21 = p7
				local v22 = true
				spawn(function()
					v9:dispatch(getLocalUser())

					if fFlagUseSignalsForCountryCode then
						getCountryCodeStore(false).setCountryCode(v10.countryCode)
					else
						v9:dispatch(receivedUserCountryCode(v10.countryCode))
					end

					if v11 and v10.isUnder13 then
						v9:dispatch(module2({
							{ name = module6.UAppBlock }
						}))
					elseif v12 == "auth" then
						if module18() or module19() then
							v9:dispatch(module2({
								{ name = module6.AddAuthMethodPage }
							}))
						else
							module5.setSignupActionRequired("")
							module5.flush()
							v9:dispatch(module2({
								{ name = v13 }
							}))
						end
					else
						v9:dispatch(module2({
							{ name = v13 }
						}))
					end

					local function fn2()
						return v9:dispatch(module4(v14, v15, v16, v17, v18, v19, v20))
					end

					v9:dispatch(module4(v14, v15, v16, v17, v18, v19, v20))

					module25(v14, v10, v21, v22, v9, v13, fn2, v18, v11, true)
				end)
			end
		end)
		return
	end

	module27:registerSessionStatusChange()
	module27:waitForSessionCheckTerminalStatus():andThen(function(p12)
		if p12 and p12.status == status.Success then
			object2:dispatch(getLocalUser())

			if fFlagUseSignalsForCountryCode then
				getCountryCodeStore(false).setCountryCode(object.countryCode)
			else
				object2:dispatch(receivedUserCountryCode(object.countryCode))
			end

			if p9 and object.isUnder13 then
				object2:dispatch(module2({
					{ name = module6.UAppBlock }
				}))
			elseif v5 == "auth" then
				if module18() or module19() then
					object2:dispatch(module2({
						{ name = module6.AddAuthMethodPage }
					}))
				else
					module5.setSignupActionRequired("")
					module5.flush()
					object2:dispatch(module2({
						{ name = p6 }
					}))
				end
			else
				object2:dispatch(module2({
					{ name = p6 }
				}))
			end

			object2:dispatch(module4(p2, p3, p4, p5, p8, p10, p11))

			handleSessionCheckSuccess(p2, object, p7, true, object2, p6, fn, p8, p9, true)
		elseif p12 and p12.status == status.Failed then
			handleSessionCheckFailure(p12.errorStatus, true, object2, p2, p7, object, p6, fn)
		end
	end, function(p12)
		local v9 = object2
		local v10 = object
		local v11 = p9
		local v12 = v5
		local v13 = p6
		local v14 = p2
		local v15 = p3
		local v16 = p4
		local v17 = p5
		local v18 = p8
		local v19 = p10
		local v20 = p11

		local v21 = p7
		local v22 = true
		spawn(function()
			v9:dispatch(getLocalUser())

			if fFlagUseSignalsForCountryCode then
				getCountryCodeStore(false).setCountryCode(v10.countryCode)
			else
				v9:dispatch(receivedUserCountryCode(v10.countryCode))
			end

			if v11 and v10.isUnder13 then
				v9:dispatch(module2({
					{ name = module6.UAppBlock }
				}))
			elseif v12 == "auth" then
				if module18() or module19() then
					v9:dispatch(module2({
						{ name = module6.AddAuthMethodPage }
					}))
				else
					module5.setSignupActionRequired("")
					module5.flush()
					v9:dispatch(module2({
						{ name = v13 }
					}))
				end
			else
				v9:dispatch(module2({
					{ name = v13 }
				}))
			end

			local function fn2()
				return v9:dispatch(module4(v14, v15, v16, v17, v18, v19, v20))
			end

			v9:dispatch(module4(v14, v15, v16, v17, v18, v19, v20))

			module25(v14, v10, v21, v22, v9, v13, fn2, v18, v11, true)
		end)
	end)
end

local function handleNoCachedUser(p2, p3, p4, p5, p6, p7, p8, object, p9, p10, p11, p12, p13, p14)
	local v5 = p14 or false

	if module7.LuaAppLoginUIEnabled() and p6 then
		module25(p2, p7, p8, false, object, p9, function()
			return object:dispatch(module4(p2, p3, p4, p5, p10, p12, p13))
		end, p10, p11, false)
	elseif module7.LuaAppLoginUIEnabled() then
		if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or module5.getSignupActionRequired()) == "auth" then
			object:dispatch(module2({
				{ name = module6.AddAuthMethodPage }
			}))
			return
		end

		if module17 then
			local accountSwitchStatus = module5.getAccountSwitchStatus()

			local v6 = accountSwitchStatus == accountSwitcherConstants.AccountSwitcherPendingLoginAfterLogoutAll

			local v7 = accountSwitchStatus == accountSwitcherConstants.AccountSwitcherPendingLoginV2AfterLogoutAll

			local v8 = accountSwitchStatus == accountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV1AfterLogoutAll

			local v9 = accountSwitchStatus == accountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV2AfterLogoutAll

			if v6 or v7 or v8 or v9 then
				local accountSwitchTargetUsername = module5.getAccountSwitchTargetUsername()
				module5.setAccountSwitchStatus("")
				module5.setAccountSwitchTargetUsername("")
				module5.flush()

				local v10 = {}

				if accountSwitchTargetUsername ~= "" then
					v10.forcedUsernameOverride = accountSwitchTargetUsername
				end

				if v8 or v9 then
					v10.retryPasskey = true
				end

				if v7 or v9 then
					if fFlagEnableLoginV2Modalization then
						object:dispatch(module2({
							{ name = module6.Landing, extraProps = {} },
							{ name = module6.LoginV2, extraProps = v10 }
						}))
					else
						object:dispatch(module2({
							{ name = module6.LoginV2, extraProps = v10 }
						}))
					end
				else
					object:dispatch(module2({
						{ name = module6.Login, extraProps = v10 }
					}))
				end

				return
			end
		end

		spawn(function()
			object:dispatch(checkForAndFireValidCookieForNoCachedUserEvent(p2, default, module15))
		end)

		if (module20 or getFFlagKeystoreAutoLoginAvailable()) and not v5 then
			local function handleResetOnNoAccountInfoFound(p15, p16, p17)
				module13(false, object, p2, p8, nil, p15, p16, p17)
			end

			local function getIosKeychainCredentials()
				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				local v6 = default2:isAvailable(
					default2.CredentialsTypes.iosKeychainPassword,
					getFIntLuaAppCredentialsProtocolAvailableTimeout()
				):andThen(function(p15)
					if p15 and p15.isAvailable then
						return default2:getCredentials(
							default2.CredentialsTypes.iosKeychainPassword,
							jsonEncode,
							keystoreConstants.KeystoreTimeout
						)
					end

					return Promise.resolve(nil)
				end)

				if fFlagUseIsAvailableCheckForIOSKeychainFetch then
					return v6()
				end

				return default2:getCredentials(
					default2.CredentialsTypes.iosKeychainPassword,
					jsonEncode,
					keystoreConstants.KeystoreTimeout
				)
			end

			local function getKeystoreCredentials()
				local jsonEncode = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				return (default2:isAvailable(
					default2.CredentialsTypes.keystore,
					getFIntLuaAppCredentialsProtocolAvailableTimeout()
				):andThen(function(p15)
					if p15 and p15.keystore and p15.keystore.isAvailable then
						return default2:getCredentials(
							default2.CredentialsTypes.keystore,
							jsonEncode,
							keystoreConstants.KeystoreTimeout
						)
					end

					return Promise.resolve(nil)
				end))
			end

			local function loginCallback(p15, p16)
				return function(object2)
					return object2:dispatch(module23(
						p15,
						p16.username,
						p16.password,
						nil,
						nil,
						nil,
						nil,
						nil,
						false
					))
				end
			end

			local v6

			if getFFlagKeystoreAutoLoginAvailable() then
				v6 = module21(p2, getKeystoreCredentials, loginCallback)(object)
			else
				v6 = module21(p2, getIosKeychainCredentials, loginCallback)(object)
			end

			v6:andThen(function(data)
				if data.loginResult then
					v5 = true
					module5.setAccountBlob(data.loginResult.accountBlob)
					module5.flush()
					LUAUFORGE_MODULE_GLOBALS_fAH_launchApp(p2, p3, p4, p5, nil, p10, p12, p13, v5)(object)
				else
					module13(
						false,
						object,
						p2,
						p8,
						nil,
						data.credentials,
						data.credentialsValidForLogin,
						data.redirectToLoginPage
					)
				end
			end):catch(function(data)
				module13(
					false,
					object,
					p2,
					p8,
					nil,
					data.credentials,
					data.credentialsValidForLogin,
					data.redirectToLoginPage
				)
			end)
		else
			module13(false, object, p2, p8, nil, nil, nil, false)
		end
	else
		module25(p2, p7, p8, false, object, p9, function()
			return object:dispatch(module4(p2, p3, p4, p5, p10, p12, p13))
		end, p10, p11, false)
	end
end

function LUAUFORGE_MODULE_GLOBALS_fAH_launchApp(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	return function(object)
		p10 = p10 or false
		local v5 = module3(p2)
		local v6 = Models.fromLocalStorage()
		local v7

		if fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
			v7 = module6.PioneerPostAuth
		else
			v7 = module6.Home
		end

		object:dispatch(setLaunchContext(p6))

		default2:isAvailable(
			default2.CredentialsTypes.all,
			getFIntLuaAppCredentialsProtocolAvailableTimeout()
		):andThen(function(p11)
			local credentialsAvailabilityStore = getCredentialsAvailabilityStore(false)
			local v8 = parseCredentialsProtocolIsAvailableResponse(p11)

			credentialsAvailabilityStore.setFido2Available(v8.fido2Available)
			credentialsAvailabilityStore.setFido2SupportsDeviceBoundOnly(v8.fido2SupportsDeviceBoundOnly)

			credentialsAvailabilityStore.setPasswordsAvailable(v8.passwordsAvailable)
			credentialsAvailabilityStore.setV2InterfaceSupported(v8.v2InterfaceSupported)
		end):catch(function(p11)
			logger:warning("Error prefetching CredentialsProtocol:isAvailable")
		end)

		pcall(function()
			default:logRobloxTelemetryCounter(telemetryConfigs.LaunchAppThunkInitiatedConfig, 1, {
				launchContext = p6,
				hasCachedUser = tostring(v6 and v6.userId and v6.userId ~= -1 and true or false)
			})
		end)

		if module9.getWebLogin() == module10.NotFromWeb then
			postSignUpAttribution.attributeV2(p2, p6)

			if getFFlagEnableAdConsentAttribution() then
				module12(p6, v6.countryCode)
			end

			if v6.userId == -1 then
				logger:info(string.format("[%f] LaunchApp::handleNoCachedUser()", tick()))
				local v8 = p6 ~= module8.Startup

				if module17 then
					local accountSwitchStatus = module5.getAccountSwitchStatus()

					if
						(fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues or fFlagApplyLaunchContextForNewAccountSwitches)
						and accountSwitchStatus == accountSwitcherConstants.AccountSwitcherSwitchedStatus
						or accountSwitchStatus == accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus
						or accountSwitchStatus == accountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus
					then
						module5.setAccountSwitchStatus("")
						module5.setAccountSwitchTargetUsername("")
						v8 = true
					elseif
						not fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
						and accountSwitchStatus == module14.Auth.AccountSwitcherSwitchedStatus
					then
						module5.setAccountSwitchStatus("")
						module5.setAccountSwitchTargetUsername("")
						v8 = true
					end

					if module5.getSignupActionRequired() == "auth" then
						v8 = false
					end
				end

				handleNoCachedUser(p2, p3, p4, p5, v8, v6, v5, object, v7, p7, false, p8, p9, p10)
			else
				logger:info(string.format("[%f] LaunchApp::initializeForCachedUser()", tick()))

				if fFlagEdpGameLeavePromptsPassIsRecentInstall then
					task.defer(module22, v6.userId)
				end

				if module26() and p6 == module8.Startup then
					initializeForCachedUserV2(p2, p3, p4, p5, v6, v7, object, v5, p7, false, p8, p9)
				else
					initializeForCachedUser(p2, p3, p4, p5, v6, v7, object, v5, p7, false, p8, p9)
				end
			end
		else
			logger:info(string.format("[%f] LaunchApp::handleNoCachedUser(), WebLogin", tick()))

			Models.clearLocalStorage()
			module5.flush()
			v6 = Models.fromLocalStorage()

			handleNoCachedUser(
				p2,
				p3,
				p4,
				p5,
				module9.getWebLogin() == module10.FromWebBanner or module9.getWebLogin() == module10.FromWebPlayGame or module9.getWebLogin() == module10.FromCommandLine,
				v6,
				v5,
				object,
				v7,
				p7,
				false,
				p8,
				p9,
				p10
			)
		end
	end
end

return LUAUFORGE_MODULE_GLOBALS_fAH_launchApp
