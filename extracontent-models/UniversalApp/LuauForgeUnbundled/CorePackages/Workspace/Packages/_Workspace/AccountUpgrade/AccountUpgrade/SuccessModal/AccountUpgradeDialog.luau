local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local dialog = Foundation.Dialog
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local FFlagAccountUpgradeOAuthDialogFitsContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthDialogFitsContent")

local function useFitHeights(p2)
	local v5 = Foundation.Hooks.useOverlay()
	local v6, v7 = React.useBinding(1e999)
	local v8, v9 = React.useBinding(0)
	local v10, v11 = React.useBinding(0)
	React.useEffect(function()
		if not p2 or v5 == nil then
			return
		end

		local v12 = v5
		local function updateOverlayHeight()
			v7(v12.AbsoluteSize.Y)
		end

		v7(v12.AbsoluteSize.Y)

		local absoluteSizeChangedConnection = v12:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayHeight)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { p2, v5 })

	return {
		overlayHeight = v6,
		headerHeight = v8,
		setHeaderHeight = v9,
		contentHeight = v10,
		setContentHeight = v11
	}
end

local function AccountUpgradeDialog(props)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = props.isFocusable,
		isAutoFocusRoot = true
	})

	local testId = props.testId or "account-upgrade-dialog"
	local v7 = FFlagAccountUpgradeOAuthDialogFitsContent and props.fitsContent == true
	local v8 = if FFlagAccountUpgradeOAuthDialogFitsContent then useFitHeights(v7) else nil

	local v9 = nil

	if props.title and v7 then
		v9 = React.createElement(view, {
			tag = "size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v5.Size.Size_500),
				right = UDim.new(0, v5.Size.Size_400 + v5.Size.Size_1000)
			},
			LayoutOrder = 1,
			testId = `{testId}--title`
		}, {
			Title = React.createElement(text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		})
	elseif props.title then
		v9 = React.createElement(dialog.Title, { text = props.title })
	end

	if props.subtitle then
		v9 = React.createElement(
			view,
			{
				tag = "col gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1,
				testId = `{testId}--header`
			},
			{
				Title = v9,
				Subtitle = React.createElement(text, {
					Text = props.subtitle,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					LayoutOrder = 2,
					testId = `{testId}--subtitle`
				})
			}
		)
	end

	if props.onCloseActivated then
		local xLarge = v5.Padding.XLarge
		local size_400 = v5.Size.Size_400

		v9 = React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = v9,
			CloseButtonAnchor = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = -2147483648
				},
				{
					CloseButton = React.createElement(view, {
						tag = "row align-x-center align-y-center anchor-top-right clip",
						Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
						padding = UDim.new(0, v5.Size.Size_200),
						cornerRadius = UDim.new(0, v5.Radius.Medium),
						cursor = {
							radius = UDim.new(0, v5.Radius.Medium),
							offset = v5.Size.Size_150,
							borderWidth = v5.Stroke.Thicker
						},
						onActivated = props.onCloseActivated,
						Position = UDim2.new(1, xLarge - size_400, 0, size_400),
						testId = `{testId}--close-button`
					}, {
						Icon = React.createElement(icon, {
							name = iconName.X,
							size = iconSize.Large,
							style = v5.Color.Content.Emphasis
						})
					})
				}
			)
		})
	end

	local v10

	if v7 and v8 then
		local setHeaderHeight = v8.setHeaderHeight
		local setContentHeight = v8.setContentHeight

		v9 = v9 and React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = function(p2)
				setHeaderHeight(p2.AbsoluteSize.Y)
			end
		}, { Header = v9 })

		local mapped = React.joinBindings({ v8.overlayHeight, v8.headerHeight, v8.contentHeight }):map(function(list)
			local item = list[2]
			local v11 = v5.Padding.XLarge * 3 + item + (not (item > 0) and 0 or v5.Gap.XLarge)
			return UDim2.new(1, 0, 0, (math.min(math.ceil(list[3]), (math.max(0, list[1] - v11)))))
		end)

		v10 = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				LayoutOrder = 2,
				testId = `{testId}--content`
			},
			{
				ScrollingFrame = React.createElement("ScrollingFrame", {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(),
					Size = mapped,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
					ScrollBarThickness = v5.Size.Size_150,
					ScrollBarImageColor3 = v5.Color.Shift.Shift_400.Color3,
					ScrollBarImageTransparency = v5.Color.Shift.Shift_400.Transparency,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Selectable = false
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						SortOrder = Enum.SortOrder.LayoutOrder,
						[React.Change.AbsoluteContentSize] = function(p2)
							setContentHeight(p2.AbsoluteContentSize.Y)
						end
					}),
					Children = React.createElement(React.Fragment, nil, props.children)
				})
			}
		)
	else
		v10 = React.createElement(dialog.Content, { LayoutOrder = 2 }, props.children)
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v11 = {
		ref = v6,
		size = dialogSize.Medium,
		disablePortal = false,
		hasBackdrop = props.hasBackdrop,
		onClose = 0,
		testId = 0
	}
	local v12 = if not props.onCloseActivated then props.onClose else nil
	v11.onClose = v12
	v11.testId = testId
	return createElement(root, v11, {
		Title = v9,
		Content = v10,
		Actions = props.actions
	})
end

return AccountUpgradeDialog
