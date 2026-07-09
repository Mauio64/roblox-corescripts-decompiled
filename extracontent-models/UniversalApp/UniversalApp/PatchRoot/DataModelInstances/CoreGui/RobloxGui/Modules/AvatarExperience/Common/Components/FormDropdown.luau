local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function FormDropdown(t1: {[any]: any}, p1) -- line: 28
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), Foundation (copy), StateLayerAffordance (copy), FillBehavior (copy), ButtonVariant (copy)
	local v12 = useTokens()
	local v13 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply"
	})
	local v14 = if not t1.dropdownPosition then UDim2.fromScale(0.5, 0.5) else UDim2.fromOffset(t1.dropdownPosition.X, t1.dropdownPosition.Y)
	local v15 = if not t1.dropdownPosition then Vector2.new(0.5, 0.5) else Vector2.new()
	local v16 = React.useCallback(function(t2: {[any]: any}) -- line: 38
		-- upvalues: t1 (copy), v12 (copy)
		local v27 = not t1.dropdownPosition and 0 or t1.dropdownPosition.Y
		local v28 = math.max(t2.scrimSize.Y - v27 - t2.headerHeight - t2.bottomBarHeight - v12.Gap.Medium, 0)

		return UDim2.fromOffset(t2.contentSize.X, (math.min(t2.contentSize.Y, v28)))
	end, { t1.dropdownPosition })
	local v17, v18 = React.useBinding(Vector2.new())
	local v19, v20 = React.useBinding(Vector2.new())
	local v21, v22 = React.useBinding(0)
	local v23, v24 = React.useBinding(0)
	local v25 = React.joinBindings({
		scrimSize = v17,
		contentSize = v19,
		bottomBarHeight = v23,
		headerHeight = v21
	}):map(v16)

	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = v12.Color.Common.Scrim,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onActivated = t1.onClose,
		onAbsoluteSizeChanged = function(p2) -- line: 69
			-- upvalues: v18 (copy)
			v18(p2.AbsoluteSize)
		end
	}, {
		Dropdown = React.createElement(Foundation.View, {
			tag = "bg-surface-100 radius-medium auto-xy col",
			selectionGroup = true,
			Position = v14,
			AnchorPoint = v15,
			onActivated = function() -- line: 77
			end,
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			selection = {
				Selectable = false
			},
			ref = p1
		}, {
			HeaderContainer = React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 padding-xlarge",
				LayoutOrder = 1,
				onAbsoluteSizeChanged = function(p3) -- line: 90
					-- upvalues: v22 (copy)
					v22(p3.AbsoluteSize.Y)
				end
			}, {
				Header = t1.headerText and React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large",
					Text = t1.headerText
				}),
				CloseButton = t1.onClose and React.createElement(Foundation.IconButton, {
					icon = "icons/navigation/close",
					LayoutOrder = 2,
					size = Foundation.Enums.IconSize.Small,
					onActivated = t1.onClose,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5)
				})
			}),
			ScrollView = React.createElement(Foundation.ScrollView, {
				LayoutOrder = 2,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
				},
				Size = v25,
				selection = {
					Selectable = false
				}
			}, {
				ChildrenContainer = React.createElement(Foundation.View, {
					tag = "auto-xy padding-x-xlarge",
					onAbsoluteSizeChanged = function(p4) -- line: 124
						-- upvalues: v20 (copy)
						v20(Vector2.new(math.max(300, p4.AbsoluteSize.X), p4.AbsoluteSize.Y))
					end
				}, t1.children)
			}),
			ButtonContainer = t1.onApply and React.createElement(Foundation.View, {
				tag = "auto-y padding-xlarge",
				LayoutOrder = 3,
				onAbsoluteSizeChanged = function(p5) -- line: 134
					-- upvalues: v24 (copy)
					v24(p5.AbsoluteSize.Y)
				end,
				Size = v19:map(function(vector2: Vector2) -- line: 137
					return UDim2.fromOffset(vector2.X, 0)
				end)
			}, {
				ApplyButton = React.createElement(Foundation.Button, {
					text = v13.apply,
					fillBehavior = FillBehavior.Fill,
					variant = ButtonVariant.Emphasis,
					isDisabled = not t1.canApply,
					onActivated = t1.onApply
				})
			})
		})
	})
end

return React.forwardRef(FormDropdown)
