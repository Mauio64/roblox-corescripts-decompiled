local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local EventIngestService = game:GetService("EventIngestService")
local React = require(CorePackages.Packages.React)
local InputUi = require(CorePackages.Workspace.Packages.InputUi)
local GamepadDisconnectedModal = InputUi.Gamepad.GamepadDisconnectedModal
local useGamepadDisconnectOverlayEffect = InputUi.Gamepad.useGamepadDisconnectOverlayEffect
local InGameMenuConstants = require(CoreGui.RobloxGui.Modules.InGameMenuConstants)
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local eventIngest = Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

local function CoreScriptsGamepadDisconnectListener()
	local state, setState = React.useState(false)
	local v = React.useCallback(function()
		setState(false)
	end, { setState })
	useGamepadDisconnectOverlayEffect(React.useCallback(function()
		setState(true)
	end, { setState }), v, eventIngest, "InExperience")

	if state then
		return React.createElement(
			"ScreenGui",
			{
				DisplayOrder = InGameMenuConstants.DisplayOrder.HeadsetDisconnectedDialog,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			},
			{
				GamepadDisconnectedModal = React.createElement(GamepadDisconnectedModal)
			}
		)
	end

	return nil
end

return CoreScriptsGamepadDisconnectListener
