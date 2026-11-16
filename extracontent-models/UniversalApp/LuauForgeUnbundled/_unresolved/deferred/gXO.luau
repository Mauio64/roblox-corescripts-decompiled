local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local fillBehavior = Foundation.Enums.FillBehavior
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function FormDropdown(props, p2)
	local v5 = useTokens()
	local v6 = useLocalization({ apply = "CommonUI.Messages.Action.Apply" })
	local udim

	if props.dropdownPosition then
		udim = UDim2.fromOffset(props.dropdownPosition.X, props.dropdownPosition.Y)
	else
		udim = UDim2.fromScale(0.5, 0.5)
	end

	local vector2 = if props.dropdownPosition then Vector2.new() else Vector2.new(0.5, 0.5)

	local v7 = React.useCallback(function(data)
		local v8 = not props.dropdownPosition and 0 or props.dropdownPosition.Y
		local v9 = math.max(
			data.scrimSize.Y - v8 - data.headerHeight - data.bottomBarHeight - v5.Gap.Medium,
			0
		)
		return UDim2.fromOffset(data.contentSize.X, (math.min(data.contentSize.Y, v9)))
	end, { props.dropdownPosition })

	local v8, v9 = React.useBinding(Vector2.new())
	local v10, v11 = React.useBinding(Vector2.new())
	local v12, v13 = React.useBinding(0)
	local v14, v15 = React.useBinding(0)
	local mapped = React.joinBindings({
		scrimSize = v8,
		contentSize = v10,
		bottomBarHeight = v14,
		headerHeight = v12
	}):map(v7)

	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = v5.Color.Common.Scrim,
		stateLayer = { affordance = stateLayerAffordance.None },
		onActivated = props.onClose,
		onAbsoluteSizeChanged = function(p3)
			v9(p3.AbsoluteSize)
		end
	}, {
		Dropdown = React.createElement(Foundation.View, {
			tag = "bg-surface-100 radius-medium auto-xy col",
			Position = udim,
			AnchorPoint = vector2,
			onActivated = function() end,
			stateLayer = { affordance = stateLayerAffordance.None },
			selection = { Selectable = false },
			selectionGroup = true,
			ref = p2
		}, {
			HeaderContainer = React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 padding-xlarge",
				LayoutOrder = 1,
				onAbsoluteSizeChanged = function(p3)
					v13(p3.AbsoluteSize.Y)
				end
			}, {
				Header = props.headerText and React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large",
					Text = props.headerText
				}),
				CloseButton = props.onClose and React.createElement(Foundation.IconButton, {
					icon = "icons/navigation/close",
					size = Foundation.Enums.IconSize.Small,
					onActivated = props.onClose,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					LayoutOrder = 2
				})
			}),
			ScrollView = React.createElement(Foundation.ScrollView, {
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
				},
				Size = mapped,
				selection = { Selectable = false },
				LayoutOrder = 2
			}, {
				ChildrenContainer = React.createElement(Foundation.View, {
					tag = "auto-xy padding-x-xlarge",
					onAbsoluteSizeChanged = function(p3)
						v11(Vector2.new(math.max(300, p3.AbsoluteSize.X), p3.AbsoluteSize.Y))
					end
				}, props.children)
			}),
			ButtonContainer = props.onApply and React.createElement(Foundation.View, {
				tag = "auto-y padding-xlarge",
				onAbsoluteSizeChanged = function(p3)
					v15(p3.AbsoluteSize.Y)
				end,
				Size = v10:map(function(p3)
					return UDim2.fromOffset(p3.X, 0)
				end),
				LayoutOrder = 3
			}, {
				ApplyButton = React.createElement(Foundation.Button, {
					text = v6.apply,
					fillBehavior = fillBehavior.Fill,
					variant = buttonVariant.Emphasis,
					isDisabled = not props.canApply,
					onActivated = props.onApply
				})
			})
		})
	})
end

return React.forwardRef(FormDropdown)
