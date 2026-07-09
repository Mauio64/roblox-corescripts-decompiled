local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local OpenCentralOverlayForConfirmSignOut = require(Modules.LuaApp.Thunks.OpenCentralOverlayForConfirmSignOut)
local DeprecatedDarkTheme = require(Modules.LuaApp.Themes.DeprecatedDarkTheme)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ConsoleDisconnect = require(CorePackages.Workspace.Packages.AuthCommon).Thunks.ConsoleDisconnect
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default

local function DisconnectButton() -- line: 31
	-- upvalues: useDesignTokens (copy), useDispatch (copy), useLocalization (copy), useRoactService (copy), RoactNetworking (copy), AppGuiService (copy), React (copy), default (copy), TelemetryConfigs (copy), OpenCentralOverlayForConfirmSignOut (copy), ConsoleDisconnect (copy), Logout (copy), DeprecatedDarkTheme (copy), Button (copy), ButtonType (copy)
	local DisconnectTextFont = useDesignTokens().LuaApps.More.DisconnectTextFont
	local v21 = useDispatch()
	local v22 = useLocalization({
		logout = "Application.Logout.Action.Logout"
	})
	local v23 = useRoactService(RoactNetworking)
	local v24 = useRoactService(AppGuiService)
	local v25 = React.useCallback(function() -- line: 41
		-- upvalues: default (copy), TelemetryConfigs (copy), v21 (copy), OpenCentralOverlayForConfirmSignOut (copy), ConsoleDisconnect (copy), v23 (copy), v24 (copy), Logout (copy), DeprecatedDarkTheme (copy)
		pcall(function() -- line: 42
			-- upvalues: default (copy), TelemetryConfigs (copy)
			default:logRobloxTelemetryCounter(TelemetryConfigs.LogoutButtonClickedConfig, 1)
		end)
		v21(OpenCentralOverlayForConfirmSignOut(function() -- line: 46
			-- upvalues: v21 (copy), ConsoleDisconnect (copy), v23 (copy), v24 (copy), Logout (copy)
			v21(ConsoleDisconnect(v23, v24, Logout))
		end, DeprecatedDarkTheme))
	end, {
		v21,
		v23,
		v24
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		DisconnectButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			size = UDim2.new(1, 0, 1, 0),
			text = v22.logout,
			fontStyle = DisconnectTextFont,
			onActivated = v25
		})
	})
end

return DisconnectButton
