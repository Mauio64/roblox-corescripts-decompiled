local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")

local module2 = require("@luauforge/bundled/ehL")
local useFocusNavigableSurfaceRegistryConnection = module2.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum

local module3 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module4 = require("@luauforge/bundled/gJS")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useStyle = UIBlox.Core.Style.useStyle

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectGlobalGuiInset(p2)
	return p2.GlobalGuiInset
end

local function selectStatusBarHeight(p2)
	return p2.TopBar.statusBarHeight
end

local function NavOverlayScreenContainer(props)
	local theme = useStyle().Theme

	local v6 = useSelector(selectGlobalGuiInset)
	local v7 = useSelector(module4)
	local v8 = useSelector(selectStatusBarHeight)
	local udim

	if v7 then
		udim = UDim2.fromScale(1, 1)
	else
		local fromScale = UDim2.fromScale
		local v9 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module3.LandscapeNavWidth
		udim = fromScale(v9, 1)
	end

	local state, setState = React.useState(nil)
	useFocusNavigableSurfaceRegistryConnection(state, focusNavigableSurfaceIdentifierEnum.Auxiliary)

	local v9 = React.useCallback(function(current)
		setState(current)

		if props.forwardRef then
			if typeof(props.forwardRef) == "function" then
				props.forwardRef(current)
			else
				props.forwardRef.current = current
			end
		end
	end, { props.forwardRef })

	local backgroundDefault = theme.BackgroundDefault

	local v10 = v6.bottom > 0
	local v11 = -(44 + v8)

	local v12 = {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 44),
		Size = UDim2.new(1, 0, 1, v11),
		ClipsDescendants = true,
		AutoButtonColor = false,
		LayoutOrder = 3
	}

	local headerBarProps = props.headerBarProps

	local createElement = React.createElement
	local view = Foundation.View

	local v15 = if headerBarProps.renderLeft then React.createElement(Foundation.View, {
		tag = "auto-xy",
		LayoutOrder = 1,
		flexItem = { FlexMode = Enum.UIFlexMode.None }
	}, { Content = headerBarProps.renderLeft() }) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v16 = {
		tag = "fill size-full-0 auto-xy clip",
		LayoutOrder = 2,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill }
	}

	local createElement3 = React.createElement
	local text = Foundation.Text
	local v18 = {
		tag = "size-full-0 auto-y text-heading-small content-emphasis",
		Text = headerBarProps.title,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = 0
	}
	local v19 = if v7 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
	v18.TextXAlignment = v19
	local v14 = {
		Left = v15,
		TitleRegion = createElement2(view2, v16, { Title = createElement3(text, v18) }),
		Right = 0
	}

	local v20 = if headerBarProps.renderRight then React.createElement(Foundation.View, {
		tag = "auto-xy",
		LayoutOrder = 3,
		flexItem = { FlexMode = Enum.UIFlexMode.None }
	}, { Content = headerBarProps.renderRight() }) else nil
	v14.Right = v20
	local element = createElement(
		view,
		{
			tag = "row align-y-center size-full padding-x-small",
			BackgroundTransparency = 1
		},
		v14
	)

	local createElement4 = React.createElement
	local onDismissesByActivated = {
		["BackgroundColor3"] = nil,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false,
		ref = v9,
		[React.Event.Activated] = props.onDismiss
	}
	local v22 = if not props.onDismiss then false else nil
	onDismissesByActivated.Selectable = v22

	local createElement5 = React.createElement
	local v25 = {
		BackgroundTransparency = 1,
		Size = udim,
		Position = UDim2.fromOffset(0, 0)
	}
	local v26 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		StatusBarBackground = React.createElement("TextButton", {
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = not v7 and 1 or backgroundDefault.Transparency,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v8),
			Text = "",
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Selectable = false
		}),
		HeaderBarBackground = React.createElement("TextButton", {
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = backgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 44),
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = 2,
			Selectable = false
		}, { ManualHeader = element }),
		ContentsFrame = React.createElement("ImageButton", v12, props.children),
		BottomInsetBackground = 0
	}

	local v27 = if v10 then React.createElement("TextButton", {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, v6.bottom),
		Text = "",
		ZIndex = 3,
		AutoButtonColor = false,
		LayoutOrder = 4,
		Selectable = false
	}) else nil
	v26.BottomInsetBackground = v27
	return createElement4("TextButton", onDismissesByActivated, {
		WidthFrame = createElement5("Frame", v25, v26)
	})
end

return NavOverlayScreenContainer
