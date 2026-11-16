local UserInputService = game:GetService("UserInputService")

local appShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = appShortcutBar.Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local UIBlox = require(parent.UIBlox)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useFocusedTextBox = FocusNavigationUtils.useFocusedTextBox
local ShortcutBar = UIBlox.App.Navigation.ShortcutBar
local defineFastFlag = game:DefineFastFlag("DisableAppShortcutBarAndroidTV", false)

local Flags = require(appShortcutBar.Flags)
local FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = Flags.FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
local SharedFlags = require(parent.SharedFlags)
local FFlagUnifyShortcutBarUnifiedIXPExposure = SharedFlags.FFlagUnifyShortcutBarUnifiedIXPExposure
local useStickyShortcutBarExposureLogging = require(appShortcutBar.Hooks.useStickyShortcutBarExposureLogging)

function AppShortcutBar(props)
	local position

	if props.Position then
		position = props.Position
	else
		position = UDim2.fromScale(0.5, 0)
	end

	local anchorPoint

	if props.AnchorPoint then
		anchorPoint = props.AnchorPoint
	else
		anchorPoint = Vector2.new(0.5, 0)
	end

	local v = useFocusedTextBox()
	local v2 = Responsive.useLastInput()
	local state, setState = React.useState(v2 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(
		UserInputService:GetLastInputType(),
		Enum.KeyCode.Thumbstick1
	))

	if defineFastFlag then
		React.useEffect(function()
			local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function()
				setState(v2 ~= Responsive.Input.Directional or UserInputService:GamepadSupports(
					UserInputService:GetLastInputType(),
					Enum.KeyCode.Thumbstick1
				))
			end)
			return function()
				lastInputTypeChangedConnection:Disconnect()
			end
		end, { v2 })
	end

	local v3

	if #props.items > 0 then
		v3 = not v and (not defineFastFlag or state)
	else
		v3 = false
	end

	local v4 = not Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v5 = not Responsive.useBreakpointYOrSmaller(Responsive.Keys.XSmall)

	local v6 = v3 and v4 and v5

	if FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled and not FFlagUnifyShortcutBarUnifiedIXPExposure then
		useStickyShortcutBarExposureLogging(v6)
	end

	local createElement = React.createElement

	local v7 = { Position = UDim2.fromScale(0, 0), Size = 0, BackgroundTransparency = 1 }
	local size

	if props.Size then
		size = props.Size
	else
		size = UDim2.fromScale(1, 1)
	end

	v7.Size = size
	local v8

	if v6 then
		v8 = React.createElement(ShortcutBar, {
			items = props.items,
			position = position,
			anchorPoint = anchorPoint
		})
	end

	return createElement("Frame", v7, v8)
end

return AppShortcutBar
