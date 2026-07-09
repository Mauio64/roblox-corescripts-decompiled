local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local MessageBusService = game:GetService("MessageBusService")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local AppPage = require(Modules.LuaApp.AppPage)
local LoginSingleSignOn = require(Modules.LuaApp.Thunks.Authentication.LoginSingleSignOn)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local AppLoginCounterNames = require(Modules.LuaApp.Analytics.Events.AppLoginCounterNames)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local Logger = require(Modules.LuaApp.Components.Authentication.Logger)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local Promise = require(Modules.LuaApp.Promise)
local SetLoginResult = require(Modules.LuaApp.Actions.Authentication.SetLoginResult)
local FFlagRemoveUnusedLoginResultRoduxSlice = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRemoveUnusedLoginResultRoduxSlice
local LoginErrorCodeSSO = require(Modules.LuaApp.Enum.LoginErrorCodeSSO)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useEarlyIsFocused = require(CorePackages.Workspace.Packages.Navigation).useEarlyIsFocused
local FFlagSSOLoggingProtocolEnabled = require(script.Parent.Flags.FFlagSSOLoggingProtocolEnabled)
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local EngineFeature = game:GetEngineFeature("PreauthPassToLuaFeature")

local function handleLoginResult(p1, p2, p3, p4, p5) -- line: 45
	-- upvalues: FFlagRemoveUnusedLoginResultRoduxSlice (copy), EngineFeature (copy), SetLoginResult (copy), reportEphemeralCounter (copy), AppLoginCounterNames (copy), FFlagSSOLoggingProtocolEnabled (copy), LaunchApp (copy), LaunchContext (copy), LoggingProtocol (copy)
	if not FFlagRemoveUnusedLoginResultRoduxSlice then
		if EngineFeature then
			if p1 then
				p3(SetLoginResult(p1))
			end
		else
			p3(SetLoginResult(p1))
		end
	end

	reportEphemeralCounter(AppLoginCounterNames.Success, 1)

	if FFlagSSOLoggingProtocolEnabled then
		p3(LaunchApp(p2, nil, p4, p5, LaunchContext.Login, LoggingProtocol.default))

		return
	end

	p3(LaunchApp(p2, nil, p4, p5))
end
local function v32(p6, p7, p8, p9, p10, p11) -- line: 63
	-- upvalues: EngineFeature (copy), MessageBusService (copy), Logger (copy), handleLoginResult (copy), Promise (copy), LoginSingleSignOn (copy), default (copy), TelemetryConfigs (copy), LoginErrorCodeSSO (copy)
	if EngineFeature then
		MessageBusService:MakeRequest("Account", "consumePreauthStatus", {}, function(t1: {[any]: any}) -- line: 65
			-- upvalues: Logger (copy), handleLoginResult (copy), p7 (copy), p6 (copy), p8 (copy), p9 (copy), Promise (copy), LoginSingleSignOn (copy), default (copy), TelemetryConfigs (copy), LoginErrorCodeSSO (copy), p10 (copy), p11 (copy)
			if t1 and t1.success then
				Logger:error("Detected preauth successful, skipping Lua SSO.")
				handleLoginResult(nil, p7, p6, p8, p9)

				return Promise.resolve()
			end

			return p6(LoginSingleSignOn(p7)):andThen(function(p12) -- line: 72
				-- upvalues: handleLoginResult (copy), p7 (copy), p6 (copy), p8 (copy), p9 (copy), default (copy), TelemetryConfigs (copy), Promise (copy)
				if p12 then
					handleLoginResult(p12, p7, p6, p8, p9)
					spawn(function() -- line: 76
						-- upvalues: default (copy), TelemetryConfigs (copy)
						default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
							status = "success"
						})
					end)
				end

				return Promise.resolve()
			end, function(p13) -- line: 87
				-- upvalues: Logger (copy), LoginErrorCodeSSO (copy), default (copy), TelemetryConfigs (copy), p10 (copy), Promise (copy), p11 (copy)
				local errorCode = p13.errorCode

				Logger:warning(string.format("Single sign on failed error: %s", (tostring(errorCode))))

				if errorCode and (errorCode == LoginErrorCodeSSO.NoAccountConnected or errorCode == LoginErrorCodeSSO.NoAccountConnectedXbox) then
					pcall(function() -- line: 98
						-- upvalues: default (copy), TelemetryConfigs (copy)
						default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
							status = "noAccountFailure"
						})
					end)
					p10()

					return Promise.resolve()
				end

				pcall(function() -- line: 112
					-- upvalues: default (copy), TelemetryConfigs (copy)
					default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
						status = "otherFailure"
					})
				end)
				p11()

				return Promise.reject(p13)
			end)
		end, {})

		return Promise.resolve()
	end

	return p6(LoginSingleSignOn(p7)):andThen(function(p14) -- line: 128
		-- upvalues: default (copy), TelemetryConfigs (copy), handleLoginResult (copy), p7 (copy), p6 (copy), p8 (copy), p9 (copy), Promise (copy)
		if p14 then
			pcall(function() -- line: 130
				-- upvalues: default (copy), TelemetryConfigs (copy)
				default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
					status = "success"
				})
			end)
			handleLoginResult(p14, p7, p6, p8, p9)
		end

		return Promise.resolve()
	end, function(p15) -- line: 143
		-- upvalues: Logger (copy), LoginErrorCodeSSO (copy), default (copy), TelemetryConfigs (copy), p10 (copy), Promise (copy), p11 (copy)
		local errorCode = p15.errorCode

		Logger:warning(string.format("Single sign on failed error: %s", (tostring(errorCode))))

		if errorCode and (errorCode == LoginErrorCodeSSO.NoAccountConnected or LoginErrorCodeSSO.NoAccountConnectedXbox) then
			pcall(function() -- line: 151
				-- upvalues: default (copy), TelemetryConfigs (copy)
				default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
					status = "noAccountFailure"
				})
			end)
			p10()

			return Promise.resolve()
		end

		pcall(function() -- line: 165
			-- upvalues: default (copy), TelemetryConfigs (copy)
			default:logRobloxTelemetryCounter(TelemetryConfigs.ConsoleSSOAttemptedTelemetryConfig, 1, {
				status = "otherFailure"
			})
		end)
		p11()

		return Promise.reject(p15)
	end)
end
local function v33(p16) -- line: 181
	return p16
end
local function SingleSignOnContainer(_: {[any]: any}) -- line: 185
	-- upvalues: useNavigation (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), useAppPolicy (copy), v33 (copy), React (copy), AppPage (copy), useEarlyIsFocused (copy), default (copy), v32 (copy), Promise (copy), Loading (copy), IconSize (copy)
	local v48 = useNavigation()
	local v49 = useDispatch()
	local v50 = useRoactService(RoactNetworking)
	local v51 = useRoactService(RoactAnalytics)
	local v52 = useAppPolicy(v33)
	local v53 = React.useCallback(function() -- line: 192
		-- upvalues: v48 (copy), AppPage (copy)
		return v48.replace(AppPage.Landing)
	end, { v48 })
	local v54 = React.useCallback(function() -- line: 196
		-- upvalues: v48 (copy), AppPage (copy)
		return v48.navigate(AppPage.SingleSignOnError)
	end, { v48 })
	local v55 = useEarlyIsFocused()

	React.useEffect(function() -- line: 202
		-- upvalues: default (copy)
		default:logEventOnce("single_sign_on_container_page_did_mount")
	end, {})
	React.useEffect(function() -- line: 206
		-- upvalues: v55 (copy), v32 (copy), v49 (copy), v50 (copy), v51 (copy), v52 (copy), v53 (copy), v54 (copy), Promise (copy)
		if v55 then
			v32(v49, v50, v51, v52, v53, v54):andThen(function(_) -- line: 208
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end, function(_) -- line: 210
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end)
		end
	end, { v55 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		LoadingBar = React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		})
	})
end

return SingleSignOnContainer
