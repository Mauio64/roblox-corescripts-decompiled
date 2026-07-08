local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local EventIngestService = game:GetService("EventIngestService")
local React = require(CorePackages.Packages.React)
local InputUi = require(CorePackages.Workspace.Packages.InputUi)
local GamepadDisconnectedModal = InputUi.Gamepad.GamepadDisconnectedModal
local useGamepadDisconnectOverlayEffect = InputUi.Gamepad.useGamepadDisconnectOverlayEffect
local InGameMenuConstants = require(CoreGui.RobloxGui.Modules.InGameMenuConstants)
local v9 = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)

local function CoreScriptsGamepadDisconnectListener() -- line: 14
	-- upvalues: React (copy), useGamepadDisconnectOverlayEffect (copy), v9 (copy), InGameMenuConstants (copy), GamepadDisconnectedModal (copy)
	local v11, v12 = React.useState(false)
	local v13 = React.useCallback(function() -- line: 16
		-- upvalues: v12 (copy)
		v12(false)
	end, { v12 })
	local v14 = React.useCallback(function() -- line: 19
		-- upvalues: v12 (copy)
		v12(true)
	end, { v12 })

	useGamepadDisconnectOverlayEffect(v14, v13, v9, "InExperience")

	if v11 then
		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			DisplayOrder = InGameMenuConstants.DisplayOrder.HeadsetDisconnectedDialog,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			GamepadDisconnectedModal = React.createElement(GamepadDisconnectedModal)
		})
	end

	return nil
end

return CoreScriptsGamepadDisconnectListener
