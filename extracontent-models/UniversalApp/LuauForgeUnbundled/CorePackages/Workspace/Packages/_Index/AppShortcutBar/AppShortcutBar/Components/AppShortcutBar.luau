local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Responsive")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/UIBlox")
local useFocusedTextBox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils").useFocusedTextBox
local shortcutBar = UIBlox.App.Navigation.ShortcutBar
local defineFastFlag = game:DefineFastFlag("DisableAppShortcutBarAndroidTV", false)

local fFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
local fFlagUnifyShortcutBarUnifiedIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags").FFlagUnifyShortcutBarUnifiedIXPExposure
local useStickyShortcutBarExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useStickyShortcutBarExposureLogging")

function LUAUFORGE_MODULE_GLOBALS_bQe_AppShortcutBar(props)
	local v5 = if props.Position then props.Position else UDim2.fromScale(0.5, 0)
	local v6 = if props.AnchorPoint then props.AnchorPoint else Vector2.new(0.5, 0)
	local v7 = useFocusedTextBox()
	local v8 = Responsive.useLastInput()
	local state, setState = React.useState(v8 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(
		UserInputService:GetLastInputType(),
		Enum.KeyCode.Thumbstick1
	))

	if defineFastFlag then
		React.useEffect(function()
			local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function()
				setState(v8 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(
					UserInputService:GetLastInputType(),
					Enum.KeyCode.Thumbstick1
				))
			end)
			return function()
				lastInputTypeChangedConnection:Disconnect()
			end
		end, { v8 })
	end

	local v9 = #props.items > 0 and (not v7 and (not defineFastFlag or state))

	local v10 = not Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v11 = not Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)

	local v12 = v9 and v10 and v11

	if
		fFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
		and not fFlagUnifyShortcutBarUnifiedIXPExposure
	then
		useStickyShortcutBarExposureLogging(v12)
	end

	local createElement = React.createElement

	local v14 = {
		Position = UDim2.fromScale(0, 0),
		Size = 0,
		BackgroundTransparency = 1
	}
	local v15 = if props.Size then props.Size else UDim2.fromScale(1, 1)
	v14.Size = v15

	local v16 = if v12 then React.createElement(shortcutBar, {
		items = props.items,
		position = v5,
		anchorPoint = v6
	}) else nil
	return createElement("Frame", v14, v16)
end

return LUAUFORGE_MODULE_GLOBALS_bQe_AppShortcutBar
