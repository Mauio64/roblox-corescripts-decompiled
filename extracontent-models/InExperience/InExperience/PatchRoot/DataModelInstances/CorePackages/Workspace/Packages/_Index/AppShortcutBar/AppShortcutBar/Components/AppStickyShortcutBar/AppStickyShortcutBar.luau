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
local LoginStatus = require(AppShortcutBarParent.RobloxAppEnums).LoginStatus
local v12 = game:DefineFastFlag("DisallowStickyShortcutBarOnNotLoggedIn", false)

local function selectUserLoggedIn(p1) -- line: 16
	-- upvalues: LoginStatus (copy)
	return p1.AuthenticationStatus and p1.AuthenticationStatus.status == LoginStatus.LOGGED_IN
end

local useAppShortcutBarHeight = require(AppShortcutBar.Hooks).useAppShortcutBarHeight
local GetShortcutBarStatusStore = require(AppShortcutBar.Stores.GetShortcutBarStatusStore)
local AppShortcut = require(AppShortcutBar.Components.AppShortcut).AppShortcut

function AppStickyShortcutBar(p2) -- line: 26
	-- upvalues: GetShortcutBarStatusStore (copy), useTokens (copy), useAppShortcutBarHeight (copy), Responsive (copy), useFocusedTextBox (copy), v12 (copy), useSelector (copy), selectUserLoggedIn (copy), FocusNavigationEventNameEnum (copy), React (copy), AppShortcut (copy)
	local v19 = GetShortcutBarStatusStore(false)
	local v20 = useTokens()
	local v21 = useAppShortcutBarHeight()
	local v22 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v23 = useFocusedTextBox()
	local v24 = nil

	if v12 then
		v24 = useSelector(selectUserLoggedIn)
	end

	local v25 = not p2.items or (#p2.items == 0 or (#p2.items == 1 and p2.items[1].eventName == FocusNavigationEventNameEnum.NavigateBack or (v23 or v12 and not v24)))

	React.useEffect(function() -- line: 45
		-- upvalues: v19 (copy), v25 (copy)
		v19.setShortcutBarVisible(not v25)
	end, { v25 })

	if v25 then
		return nil
	end

	local v26 = nil
	local t1 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v20.Gap.Large)
		})
	}
	local v28 = if not v22 then #p2.items else math.min(#p2.items, 4)
	local n1 = 0

	for _, v31 in p2.items do
		if n1 < v28 and v31.eventName ~= FocusNavigationEventNameEnum.NavigateBack then
			n1 += 1

			local v32 = if not v22 then n1 else v28 - n1 + 1

			t1["Item_" .. tostring(v32)] = React.createElement(AppShortcut, {
				layoutOrder = v32,
				item = v31
			})
		end

		if v31.eventName == FocusNavigationEventNameEnum.NavigateBack then
			v26 = React.createElement(AppShortcut, {
				item = v31
			})
		end
	end

	return React.createElement("ImageButton", {
		BorderSizePixel = 0,
		Selectable = false,
		AutoButtonColor = false,
		BackgroundColor3 = v20.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v20.Color.Surface.Surface_0.Transparency,
		Size = UDim2.new(1, 0, 0, v21),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1)
	}, {
		Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v20.Color.Stroke.Default.Color3,
			BackgroundTransparency = v20.Color.Stroke.Default.Transparency,
			Size = UDim2.new(1, 0, 0, 1)
		}),
		ShortcutsFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0)
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v20.Size.Size_3000 * 16, v21)
			}),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v20.Size.Size_800),
				PaddingTop = UDim.new(0, v20.Padding.XSmall),
				PaddingRight = UDim.new(0, v20.Size.Size_800),
				PaddingBottom = UDim.new(0, v20.Padding.XSmall)
			}),
			BackShortcutFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				BackShortcut = v26
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
