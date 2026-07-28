local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local AppShortcutBarParent = AppShortcutBar.Parent
local React = require(AppShortcutBarParent.React)
local Foundation = require(AppShortcutBarParent.Foundation)
local FocusNavigationUtils = require(AppShortcutBarParent.FocusNavigationUtils)
local Responsive = require(AppShortcutBarParent.Responsive)
local useTokens = Foundation.Hooks.useTokens
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusedTextBox = FocusNavigationUtils.useFocusedTextBox
local useSelector = require(AppShortcutBarParent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(AppShortcutBarParent.SignalsReact).useSignalState
local LoginStatus = require(AppShortcutBarParent.RobloxAppEnums).LoginStatus
local v13 = game:DefineFastFlag("DisallowStickyShortcutBarOnNotLoggedIn", false)
local FFlagUseSignalsForAuthenticationStatus = require(AppShortcutBarParent.SharedFlags).FFlagUseSignalsForAuthenticationStatus
local v15 = if not FFlagUseSignalsForAuthenticationStatus then nil else require(AppShortcutBarParent.AuthenticationStatus).GetAuthenticationStatusStore

local function selectUserLoggedIn(p1) -- line: 24
	-- upvalues: LoginStatus (copy)
	return p1.AuthenticationStatus and p1.AuthenticationStatus.status == LoginStatus.LOGGED_IN
end

local useAppShortcutBarHeight = require(AppShortcutBar.Hooks).useAppShortcutBarHeight
local GetShortcutBarStatusStore = require(AppShortcutBar.Stores.GetShortcutBarStatusStore)
local AppShortcut = require(AppShortcutBar.Components.AppShortcut).AppShortcut

function AppStickyShortcutBar(p2) -- line: 34
	-- upvalues: GetShortcutBarStatusStore (copy), useTokens (copy), useAppShortcutBarHeight (copy), Responsive (copy), useFocusedTextBox (copy), v13 (copy), FFlagUseSignalsForAuthenticationStatus (copy), useSignalState (copy), v15 (copy), LoginStatus (copy), useSelector (copy), selectUserLoggedIn (copy), FocusNavigationEventNameEnum (copy), React (copy), AppShortcut (copy)
	local v22 = GetShortcutBarStatusStore(false)
	local v23 = useTokens()
	local v24 = useAppShortcutBarHeight()
	local v25 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v26 = useFocusedTextBox()
	local v27 = nil

	if v13 then
		v27 = if not FFlagUseSignalsForAuthenticationStatus then useSelector(selectUserLoggedIn) else useSignalState(v15(false).getStatus) == LoginStatus.LOGGED_IN
	end

	local v28 = not p2.items or (#p2.items == 0 or (#p2.items == 1 and p2.items[1].eventName == FocusNavigationEventNameEnum.NavigateBack or (v26 or v13 and not v27)))

	React.useEffect(function() -- line: 56
		-- upvalues: v22 (copy), v28 (copy)
		v22.setShortcutBarVisible(not v28)
	end, { v28 })

	if v28 then
		return nil
	end

	local v29 = nil
	local t1 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v23.Gap.Large)
		})
	}
	local v31 = if not v25 then #p2.items else math.min(#p2.items, 4)
	local n1 = 0

	for _, v34 in p2.items do
		if n1 < v31 and v34.eventName ~= FocusNavigationEventNameEnum.NavigateBack then
			n1 += 1

			local v35 = if not v25 then n1 else v31 - n1 + 1

			t1["Item_" .. tostring(v35)] = React.createElement(AppShortcut, {
				layoutOrder = v35,
				item = v34
			})
		end

		if v34.eventName == FocusNavigationEventNameEnum.NavigateBack then
			v29 = React.createElement(AppShortcut, {
				item = v34
			})
		end
	end

	return React.createElement("ImageButton", {
		BorderSizePixel = 0,
		Selectable = false,
		AutoButtonColor = false,
		BackgroundColor3 = v23.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v23.Color.Surface.Surface_0.Transparency,
		Size = UDim2.new(1, 0, 0, v24),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1)
	}, {
		Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v23.Color.Stroke.Default.Color3,
			BackgroundTransparency = v23.Color.Stroke.Default.Transparency,
			Size = UDim2.new(1, 0, 0, 1)
		}),
		ShortcutsFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0)
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v23.Size.Size_3000 * 16, v24)
			}),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v23.Size.Size_800),
				PaddingTop = UDim.new(0, v23.Padding.XSmall),
				PaddingRight = UDim.new(0, v23.Size.Size_800),
				PaddingBottom = UDim.new(0, v23.Padding.XSmall)
			}),
			BackShortcutFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				BackShortcut = v29
			}),
			RightShortcutsFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.X
			}, t1)
		})
	})
end

return AppStickyShortcutBar
