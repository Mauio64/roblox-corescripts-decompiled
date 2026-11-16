local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local DialogSize = Foundation.Enums.DialogSize
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local FFlagAccountUpgradeOAuthDialogFitsContent = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthDialogFitsContent)

local function useFitHeights(flag: boolean)
	local v = Foundation.Hooks.useOverlay()
	local overlayHeight, v2 = React.useBinding(1e999)
	local headerHeight, setHeaderHeight = React.useBinding(0)
	local contentHeight, setContentHeight = React.useBinding(0)
	React.useEffect(function()
		if not flag or v == nil then
			return
		end

		local v3 = v
		local function updateOverlayHeight() -- 1 equivalent call inferred from this helper
			v2(v3.AbsoluteSize.Y)
		end

		updateOverlayHeight() -- inferred equivalent call
		local absoluteSizeChangedConnection = v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayHeight)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { flag, v })

	return {
		overlayHeight = overlayHeight,
		headerHeight = headerHeight,
		setHeaderHeight = setHeaderHeight,
		contentHeight = contentHeight,
		setContentHeight = setContentHeight
	}
end

local function AccountUpgradeDialog(props)
	local v = Foundation.Hooks.useTokens()
	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = props.isFocusable,
		isAutoFocusRoot = true
	})

	local testId = props.testId or "account-upgrade-dialog"
	local v2 = FFlagAccountUpgradeOAuthDialogFitsContent and props.fitsContent == true
	local v3

	if FFlagAccountUpgradeOAuthDialogFitsContent then
		v3 = useFitHeights(v2)
	end

	local v4 = nil

	if props.title and v2 then
		v4 = React.createElement(View, {
			tag = "size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v.Size.Size_500),
				right = UDim.new(0, v.Size.Size_400 + v.Size.Size_1000)
			},
			LayoutOrder = 1,
			testId = `{testId}--title`
		}, {
			Title = React.createElement(Text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		})
	elseif props.title then
		v4 = React.createElement(Dialog.Title, { text = props.title })
	end

	if props.subtitle then
		v4 = React.createElement(
			View,
			{
				tag = "col gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1,
				testId = `{testId}--header`
			},
			{
				Title = v4,
				Subtitle = React.createElement(Text, {
					Text = props.subtitle,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					LayoutOrder = 2,
					testId = `{testId}--subtitle`
				})
			}
		)
	end

	if props.onCloseActivated then
		local xLarge = v.Padding.XLarge
		local size_400 = v.Size.Size_400

		v4 = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1 }, {
			Title = v4,
			CloseButtonAnchor = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = -2147483648
				},
				{
					CloseButton = React.createElement(View, {
						tag = "row align-x-center align-y-center anchor-top-right clip",
						Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
						padding = UDim.new(0, v.Size.Size_200),
						cornerRadius = UDim.new(0, v.Radius.Medium),
						cursor = {
							radius = UDim.new(0, v.Radius.Medium),
							offset = v.Size.Size_150,
							borderWidth = v.Stroke.Thicker
						},
						onActivated = props.onCloseActivated,
						Position = UDim2.new(1, xLarge - size_400, 0, size_400),
						testId = `{testId}--close-button`
					}, {
						Icon = React.createElement(Icon, {
							name = IconName.X,
							size = IconSize.Large,
							style = v.Color.Content.Emphasis
						})
					})
				}
			)
		})
	end

	local content

	if v2 and v3 then
		local setHeaderHeight = v3.setHeaderHeight
		local setContentHeight = v3.setContentHeight

		v4 = v4 and React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = function(p)
				setHeaderHeight(p.AbsoluteSize.Y)
			end
		}, { Header = v4 })

		local mapped = React.joinBindings({ v3.overlayHeight, v3.headerHeight, v3.contentHeight }):map(function(list)
			local item = list[2]
			local v5 = v.Padding.XLarge * 3 + item + (not (item > 0) and 0 or v.Gap.XLarge)
			return UDim2.new(1, 0, 0, (math.min(math.ceil(list[3]), (math.max(0, list[1] - v5)))))
		end)

		content = React.createElement(
			View,
			{ tag = "size-full-0 auto-y", LayoutOrder = 2, testId = `{testId}--content` },
			{
				ScrollingFrame = React.createElement("ScrollingFrame", {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(),
					Size = mapped,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
					ScrollBarThickness = v.Size.Size_150,
					ScrollBarImageColor3 = v.Color.Shift.Shift_400.Color3,
					ScrollBarImageTransparency = v.Color.Shift.Shift_400.Transparency,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Selectable = false
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						SortOrder = Enum.SortOrder.LayoutOrder,
						[React.Change.AbsoluteContentSize] = function(p)
							setContentHeight(p.AbsoluteContentSize.Y)
						end
					}),
					Children = React.createElement(React.Fragment, nil, props.children)
				})
			}
		)
	else
		content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, props.children)
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v5 = {
		ref = ref,
		size = DialogSize.Medium,
		disablePortal = false,
		hasBackdrop = props.hasBackdrop,
		onClose = 0,
		testId = 0
	}
	local onClose

	if not props.onCloseActivated then
		onClose = props.onClose
	end

	v5.onClose = onClose
	v5.testId = testId
	return createElement(root, v5, { Title = v4, Content = content, Actions = props.actions })
end

return AccountUpgradeDialog
