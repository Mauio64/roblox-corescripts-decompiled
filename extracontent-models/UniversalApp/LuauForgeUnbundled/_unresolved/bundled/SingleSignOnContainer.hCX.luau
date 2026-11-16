local CorePackages = game:GetService("CorePackages")
local MessageBusService = game:GetService("MessageBusService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/hCY")
local module3 = require("@luauforge/bundled/fAH")
local module4 = require("@luauforge/bundled/fDL")
local module5 = require("@luauforge/bundled/hDc")
local module6 = require("@luauforge/bundled/fBo")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/TextChannelWindow/TextChannelWindow/Logger")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module9 = require("@luauforge/bundled/ecV")

local module10 = require("@luauforge/bundled/hDa")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local loginErrorCodes = AuthCommon.Enums.LoginErrorCodes
local openAccountIneligibleLoginModal = AuthCommon.Thunks.OpenAccountIneligibleLoginModal
local module12 = require("@luauforge/bundled/eda")
local module13 = require("@luauforge/bundled/dYT")

local module14 = require("@luauforge/bundled/eeH")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused

local module16 = require("@luauforge/bundled/hDd")

local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs

local defineFastFlag = game:DefineFastFlag("HandleNoLinkedAccountSSOError", false)

local fFlagEnableAccountIneligibleLoginModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAccountIneligibleLoginModal

local engineFeature = game:GetEngineFeature("PreauthPassToLuaFeature")

local function isNoLinkedAccountError(p2)
	return p2 == module10.NoAccountConnected
		or p2 == module10.NoAccountConnectedXbox
		or defineFastFlag and p2 == module10.NoLinkedAccount
end

local function openAccountIneligibleLoginModal2(callback, callback2)
	callback(openAccountIneligibleLoginModal(function()
		callback2()
	end, false))
end

local function handleLoginResult(p2, p3, callback, p4, p5)
	module4(module5.Success, 1)

	if module16 then
		callback(module3(p3, nil, p4, p5, module6.Login, LoggingProtocol.default))
	else
		callback(module3(p3, nil, p4, p5))
	end
end

local function fn(dispatch, networking, analytics, appPolicy, toLandingPage, toError, messageBusService, isPreauthPassToLuaEnabled)
	if not isPreauthPassToLuaEnabled then
		return dispatch(module2(networking)):andThen(function(p2)
			if p2 then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "success" }
					)
				end)

				handleLoginResult(p2, networking, dispatch, analytics, appPolicy)
			end

			return module9.resolve()
		end, function(p2)
			local errorCode = p2.errorCode

			Logger:warning(string.format("Single sign on failed error: %s", (tostring(errorCode))))

			if
				fFlagEnableAccountIneligibleLoginModal
				and errorCode == loginErrorCodes.PioneerAccountIneligible
			then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "otherFailure" }
					)
				end)
				local v5 = toLandingPage
				dispatch(openAccountIneligibleLoginModal(function()
					v5()
				end, false))

				return module9.resolve()
			elseif errorCode == module10.ReauthenticationRequired then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "reauthenticationRequired" }
					)
				end)

				toLandingPage()
				return module9.resolve()
			elseif
				defineFastFlag
				and (errorCode == module10.NoAccountConnected or errorCode == module10.NoAccountConnectedXbox or defineFastFlag and errorCode == module10.NoLinkedAccount)
				or not defineFastFlag
				and errorCode
				and (errorCode == module10.NoAccountConnected or module10.NoAccountConnectedXbox)
			then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "noAccountFailure" }
					)
				end)

				toLandingPage()
				return module9.resolve()
			else
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "otherFailure" }
					)
				end)

				toError()
				return module9.reject(p2)
			end
		end)
	end

	messageBusService:MakeRequest("Account", "consumePreauthStatus", {}, function(p2)
		if p2 and p2.success then
			Logger:error("Detected preauth successful, skipping Lua SSO.")
			handleLoginResult(nil, networking, dispatch, analytics, appPolicy)
			return module9.resolve()
		end

		return dispatch(module2(networking)):andThen(function(p3)
			if p3 then
				handleLoginResult(p3, networking, dispatch, analytics, appPolicy)

				spawn(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "success" }
					)
				end)
			end

			return module9.resolve()
		end, function(p3)
			local errorCode = p3.errorCode

			Logger:warning(string.format("Single sign on failed error: %s", (tostring(errorCode))))

			if
				fFlagEnableAccountIneligibleLoginModal
				and errorCode == loginErrorCodes.PioneerAccountIneligible
			then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "otherFailure" }
					)
				end)
				local v5 = toLandingPage
				dispatch(openAccountIneligibleLoginModal(function()
					v5()
				end, false))

				return module9.resolve()
			elseif errorCode == module10.ReauthenticationRequired then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "reauthenticationRequired" }
					)
				end)

				toLandingPage()
				return module9.resolve()
			elseif
				errorCode == module10.NoAccountConnected
				or errorCode == module10.NoAccountConnectedXbox
				or defineFastFlag and errorCode == module10.NoLinkedAccount
			then
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "noAccountFailure" }
					)
				end)

				toLandingPage()
				return module9.resolve()
			else
				pcall(function()
					default:logRobloxTelemetryCounter(
						telemetryConfigs.ConsoleSSOAttemptedTelemetryConfig,
						1,
						{ status = "otherFailure" }
					)
				end)

				toError()
				return module9.reject(p3)
			end
		end)
	end, {})
	return module9.resolve()
end

local function fn2(p2)
	return p2
end

local function SingleSignOnContainer(p2)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = module14(module12)
	local v8 = module14(module13)
	local v9 = useAppPolicy(fn2)
	local messageBusService = p2.messageBusService or MessageBusService
	local v10 = engineFeature

	if p2.preauthPassToLuaEnabled ~= nil then
		v10 = p2.preauthPassToLuaEnabled
	end

	local v11 = React.useCallback(function()
		return v5.replace(module.Landing)
	end, { v5 })

	local v12 = React.useCallback(function()
		return v5.navigate(module.SingleSignOnError)
	end, { v5 })

	local ref = React.useRef({
		dispatch = v6,
		networking = v7,
		analytics = v8,
		appPolicy = v9,
		toLandingPage = v11,
		toError = v12,
		messageBusService = messageBusService,
		isPreauthPassToLuaEnabled = v10
	})

	ref.current = {
		dispatch = v6,
		networking = v7,
		analytics = v8,
		appPolicy = v9,
		toLandingPage = v11,
		toError = v12,
		messageBusService = messageBusService,
		isPreauthPassToLuaEnabled = v10
	}

	local v13 = useEarlyIsFocused()

	React.useEffect(function()
		default:logEventOnce("single_sign_on_container_page_did_mount")
	end, {})

	React.useEffect(function()
		if v13 then
			local current = ref.current
			fn(
				current.dispatch,
				current.networking,
				current.analytics,
				current.appPolicy,
				current.toLandingPage,
				current.toError,
				current.messageBusService,
				current.isPreauthPassToLuaEnabled
			):andThen(
				function(p3)
					return module9.resolve()
				end,
				function(p3)
					return module9.resolve()
				end
			)
		end
	end, { v13 })

	return React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 1 },
		{
			LoadingBar = React.createElement(loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = iconSize.Large
			})
		}
	)
end

return SingleSignOnContainer
