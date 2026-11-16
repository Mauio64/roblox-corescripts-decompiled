local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Responsive = require(parent.Responsive)
local Display = require(parent.Display)

local useTokens = Foundation.Hooks.useTokens
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusedTextBox = FocusNavigationUtils.useFocusedTextBox
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus
local defineFastFlag = game:DefineFastFlag("DisallowStickyShortcutBarOnNotLoggedIn", false)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local FFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local FFlagUnifyShortcutBarUnifiedIXPExposure = SharedFlags.FFlagUnifyShortcutBarUnifiedIXPExposure

local Flags = require(AppShortcutBar.Flags)
local FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = Flags.FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function selectUserLoggedIn(p)
	return p.AuthenticationStatus and p.AuthenticationStatus.status == LoginStatus.LOGGED_IN
end

local Hooks = require(AppShortcutBar.Hooks)
local useAppShortcutBarHeight = Hooks.useAppShortcutBarHeight
local Hooks2 = require(AppShortcutBar.Hooks)
local useIsStickyShortcutBarEnabled = Hooks2.useIsStickyShortcutBarEnabled
local GetShortcutBarStatusStore = require(AppShortcutBar.Stores.GetShortcutBarStatusStore)
local AppShortcut = require(AppShortcutBar.Components.AppShortcut)
local appShortcut = AppShortcut.AppShortcut
local useStickyShortcutBarExposureLogging = require(AppShortcutBar.Hooks.useStickyShortcutBarExposureLogging)

function AppStickyShortcutBar(props)
	local shortcutBarStatusStore = GetShortcutBarStatusStore(false)
	local v = useTokens()
	local v2 = useAppShortcutBarHeight()
	local v3 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v4 = useFocusedTextBox()
	local v5

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		v5 = useIsStickyShortcutBarEnabled(props.currentPage)
	end

	local v6

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		v6 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	end

	local v7 = FFlagEnableStickyShortcutBarOnAllPlatforms
		and {
			left = math.ceil(v6.left),
			top = math.ceil(v6.top),
			right = math.ceil(v6.right),
			bottom = math.ceil(v6.bottom)
		}
		or v6
	local v8

	if defineFastFlag then
		if FFlagUseSignalsForAuthenticationStatus then
			v8 = useSignalState(getAuthenticationStatusStore(false).getStatus) == LoginStatus.LOGGED_IN
		else
			v8 = useSelector(selectUserLoggedIn)
		end
	end

	local v9 = not props.items
		or #props.items == 0
		or #props.items == 1 and props.items[1].eventName == FocusNavigationEventNameEnum.NavigateBack
		or v4
		or defineFastFlag and not v8

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		v9 = not v5
	end

	React.useEffect(function()
		shortcutBarStatusStore.setShortcutBarVisible(not v9)
	end, { v9 })

	if FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled and not FFlagUnifyShortcutBarUnifiedIXPExposure then
		useStickyShortcutBarExposureLogging(not v9)
	end

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		local v10 = math.max(v2 - v7.bottom, 0)

		React.useEffect(function()
			shortcutBarStatusStore.setShortcutBarReservedHeight(v9 and 0 or v10)
		end, { v9, v10, shortcutBarStatusStore.setShortcutBarReservedHeight })

		React.useEffect(function()
			return function()
				shortcutBarStatusStore.setShortcutBarReservedHeight(0)
			end
		end, { shortcutBarStatusStore.setShortcutBarReservedHeight })
	end

	if v9 then
		return nil
	end

	local backShortcut = nil
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Gap.Large)
		})
	}
	local items

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		items = props.items or {}
	else
		items = props.items
	end

	local v10

	if v3 then
		v10 = math.min(#items, 4)
	else
		v10 = #items
	end

	local count = 0

	for _, item in items do
		if count < v10 and item.eventName ~= FocusNavigationEventNameEnum.NavigateBack then
			count += 1
			local layoutOrder

			if v3 then
				layoutOrder = v10 - count + 1
			else
				layoutOrder = count
			end

			children["Item_" .. tostring(layoutOrder)] = React.createElement(appShortcut, {
				layoutOrder = layoutOrder,
				item = item
			})
		end

		if item.eventName == FocusNavigationEventNameEnum.NavigateBack then
			backShortcut = React.createElement(appShortcut, { item = item })
		end
	end

	local v11 = FFlagEnableStickyShortcutBarOnAllPlatforms and not props.isLeftNavVisible
	local udim

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		udim = UDim2.new(1, v7.right + (not v11 and 0 or v7.left), 0, v2)
	else
		udim = UDim2.new(1, 0, 0, v2)
	end

	local position

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		position = UDim2.new(0, not v11 and 0 or -v7.left, 1, v7.bottom)
	else
		position = UDim2.fromScale(0, 1)
	end

	return React.createElement("ImageButton", {
		BackgroundColor3 = v.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v.Color.Surface.Surface_0.Transparency,
		BorderSizePixel = 0,
		Size = udim,
		AnchorPoint = Vector2.new(0, 1),
		Position = position,
		Selectable = false,
		AutoButtonColor = false
	}, {
		Divider = React.createElement("Frame", {
			BackgroundColor3 = v.Color.Stroke.Default.Color3,
			BackgroundTransparency = v.Color.Stroke.Default.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1)
		}),
		ShortcutsFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0)
			},
			{
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v.Size.Size_3000 * 16, v2)
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v.Size.Size_800),
					PaddingTop = UDim.new(0, v.Padding.XSmall),
					PaddingRight = UDim.new(0, v.Size.Size_800),
					PaddingBottom = UDim.new(0, v.Padding.XSmall)
				}),
				BackShortcutFrame = React.createElement("Frame", {
					Size = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, { BackShortcut = backShortcut }),
				RightShortcutsFrame = React.createElement("Frame", {
					Size = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X
				}, children)
			}
		)
	})
end

return AppStickyShortcutBar
