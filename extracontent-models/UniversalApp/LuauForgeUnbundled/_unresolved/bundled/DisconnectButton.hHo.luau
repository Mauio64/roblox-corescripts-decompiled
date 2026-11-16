local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module = require("@luauforge/bundled/eda")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module2 = require("@luauforge/bundled/eeH")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module3 = require("@luauforge/bundled/hHd")

local module4 = require("@luauforge/bundled/hHb")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local consoleDisconnect = require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.ConsoleDisconnect
local module5 = require("@luauforge/bundled/fBP")

local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local function DisconnectButton()
	local disconnectTextFont = useDesignTokens().LuaApps.More.DisconnectTextFont

	local v5 = useDispatch()
	local v6 = useLocalization({ logout = "Application.Logout.Action.Logout" })

	local v7 = module2(module)
	local v8 = module2(appGuiService)
	local v9 = React.useCallback(function()
		pcall(function()
			default:logRobloxTelemetryCounter(telemetryConfigs.LogoutButtonClickedConfig, 1)
		end)

		v5(module3(function()
			v5(consoleDisconnect(v7, v8, module5))
		end, module4))
	end, { v5, v7, v8 })

	return React.createElement(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			DisconnectButton = React.createElement(button, {
				buttonType = buttonType.Secondary,
				size = UDim2.new(1, 0, 1, 0),
				text = v6.logout,
				fontStyle = disconnectTextFont,
				onActivated = v9
			})
		}
	)
end

return DisconnectButton
