local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Responsive")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Display")

local useTokens = Foundation.Hooks.useTokens
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusedTextBox = FocusNavigationUtils.useFocusedTextBox
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SignalsReact").useSignalState
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RobloxAppEnums").LoginStatus
local defineFastFlag = game:DefineFastFlag("DisallowStickyShortcutBarOnNotLoggedIn", false)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagUnifyShortcutBarUnifiedIXPExposure = SharedFlags.FFlagUnifyShortcutBarUnifiedIXPExposure

local fFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function selectUserLoggedIn(p2)
	return p2.AuthenticationStatus and p2.AuthenticationStatus.status == loginStatus.LOGGED_IN
end

local useAppShortcutBarHeight = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks").useAppShortcutBarHeight
local useIsStickyShortcutBarEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks").useIsStickyShortcutBarEnabled
local GetShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetShortcutBarStatusStore")
local appShortcut = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcut").AppShortcut
local useStickyShortcutBarExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useStickyShortcutBarExposureLogging")

function LUAUFORGE_MODULE_GLOBALS_bQo_AppStickyShortcutBar(props)
	local v5 = GetShortcutBarStatusStore(false)
	local v6 = useTokens()
	local v7 = useAppShortcutBarHeight()
	local v8 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v9 = useFocusedTextBox()
	local v10

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v10 = useIsStickyShortcutBarEnabled(props.currentPage)
	end

	local v11

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v11 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	end

	local v12 = fFlagEnableStickyShortcutBarOnAllPlatforms
		and {
			left = math.ceil(v11.left),
			top = math.ceil(v11.top),
			right = math.ceil(v11.right),
			bottom = math.ceil(v11.bottom)
		}
		or v11
	local v13

	if defineFastFlag then
		if fFlagUseSignalsForAuthenticationStatus then
			v13 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
		else
			v13 = useSelector(selectUserLoggedIn)
		end
	end

	local v14 = not props.items
		or #props.items == 0
		or #props.items == 1 and props.items[1].eventName == focusNavigationEventNameEnum.NavigateBack
		or v9
		or defineFastFlag and not v13

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v14 = not v10
	end

	React.useEffect(function()
		v5.setShortcutBarVisible(not v14)
	end, { v14 })

	if
		fFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled
		and not fFlagUnifyShortcutBarUnifiedIXPExposure
	then
		useStickyShortcutBarExposureLogging(not v14)
	end

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		local v15 = math.max(v7 - v12.bottom, 0)

		React.useEffect(function()
			v5.setShortcutBarReservedHeight(v14 and 0 or v15)
		end, { v14, v15, v5.setShortcutBarReservedHeight })

		React.useEffect(function()
			return function()
				v5.setShortcutBarReservedHeight(0)
			end
		end, { v5.setShortcutBarReservedHeight })
	end

	if v14 then
		return nil
	end

	local v15 = nil
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v6.Gap.Large)
		})
	}

	local items = if fFlagEnableStickyShortcutBarOnAllPlatforms then props.items or {} else props.items

	local v16 = if v8 then math.min(#items, 4) else #items
	local count = 0

	for k, item in items do
		if count < v16 and item.eventName ~= focusNavigationEventNameEnum.NavigateBack then
			count += 1

			local v17 = if v8 then v16 - count + 1 else count

			children["Item_" .. tostring(v17)] = React.createElement(appShortcut, {
				layoutOrder = v17,
				item = item
			})
		end

		if item.eventName == focusNavigationEventNameEnum.NavigateBack then
			v15 = React.createElement(appShortcut, { item = item })
		end
	end

	local v17 = fFlagEnableStickyShortcutBarOnAllPlatforms and not props.isLeftNavVisible
	local udim

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		udim = UDim2.new(1, v12.right + (not v17 and 0 or v12.left), 0, v7)
	else
		udim = UDim2.new(1, 0, 0, v7)
	end

	local v18 = if fFlagEnableStickyShortcutBarOnAllPlatforms then UDim2.new(0, not v17 and 0 or -v12.left, 1, v12.bottom) else UDim2.fromScale(0, 1)

	return React.createElement("ImageButton", {
		BackgroundColor3 = v6.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v6.Color.Surface.Surface_0.Transparency,
		BorderSizePixel = 0,
		Size = udim,
		AnchorPoint = Vector2.new(0, 1),
		Position = v18,
		Selectable = false,
		AutoButtonColor = false
	}, {
		Divider = React.createElement("Frame", {
			BackgroundColor3 = v6.Color.Stroke.Default.Color3,
			BackgroundTransparency = v6.Color.Stroke.Default.Transparency,
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
					MaxSize = Vector2.new(v6.Size.Size_3000 * 16, v7)
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v6.Size.Size_800),
					PaddingTop = UDim.new(0, v6.Padding.XSmall),
					PaddingRight = UDim.new(0, v6.Size.Size_800),
					PaddingBottom = UDim.new(0, v6.Padding.XSmall)
				}),
				BackShortcutFrame = React.createElement("Frame", {
					Size = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, { BackShortcut = v15 }),
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

return LUAUFORGE_MODULE_GLOBALS_bQo_AppStickyShortcutBar
