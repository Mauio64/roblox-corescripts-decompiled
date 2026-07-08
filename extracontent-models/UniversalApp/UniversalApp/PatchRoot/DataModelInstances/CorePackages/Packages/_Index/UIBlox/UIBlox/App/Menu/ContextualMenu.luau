local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Otter = require(ParentParentParent.Otter)
local withStyle = require(ParentParent.Core.Style.withStyle)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local BaseMenu = require(script.Parent.BaseMenu)
local MenuDirection = require(script.Parent.MenuDirection)
local validateButtonProps = require(script.Parent.validateButtonProps)
local validateMotorOptionProps = require(script.Parent.validateMotorOptionProps)
local t1 = {
	frequency = 4,
	dampingRatio = 1
}
local t2 = {
	frequency = 2.6,
	dampingRatio = 1
}
local t3 = {
	open = {
		targetValue = 1,
		springParams = t1
	},
	close = {
		targetValue = 0,
		springParams = t2
	}
}
local v16 = Roact.PureComponent:extend("ContextualMenu")

v16.validateProps = t.strictInterface({
	buttonProps = validateButtonProps,
	zIndex = t.optional(t.integer),
	open = t.boolean,
	menuDirection = t.optional(MenuDirection.isEnumValue),
	openPositionY = t.UDim,
	closeBackgroundVisible = t.optional(t.boolean),
	screenSize = t.Vector2,
	stayOnActivated = t.optional(t.boolean),
	onDismiss = t.optional(t.callback),
	setFrameRef = t.optional(t.union(t.callback, t.table)),
	setFirstItemRef = t.optional(t.union(t.callback, t.table)),
	motorOverrideOptions = t.optional(t.strictInterface({
		motorCallback = t.callback,
		open = validateMotorOptionProps,
		close = validateMotorOptionProps
	})),
	horizontalAlignment = t.optional(t.enum(Enum.HorizontalAlignment)),
	openPositionX = t.optional(t.UDim),
	contextMenuWidthOverride = t.optional(t.UDim),
	anchorPointOverride = t.optional(t.Vector2),
	topElementRounded = t.optional(t.boolean),
	bottomElementRounded = t.optional(t.boolean),
	isElementBackgroundVisible = t.optional(t.boolean),
	isElementDividerVisible = t.optional(t.boolean),
	elementHeight = t.optional(t.number),
	borderCornerRadius = t.optional(t.integer),
	background = t.optional(validateColorInfo),
	enableTokenOverride = t.optional(t.boolean),
	renderHeader = t.optional(t.callback),
	headerHeight = t.optional(t.number),
	showDropShadow = t.optional(t.boolean),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v16.defaultProps = {
	zIndex = 2,
	closeBackgroundVisible = true,
	menuDirection = MenuDirection.Up,
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	openPositionX = UDim.new(0, 0)
}

function v16.init(p1) -- line: 118
	-- upvalues: Roact (copy), Otter (copy), t3 (copy)
	p1.wasDismissed = false

	local v18, v19 = Roact.createBinding(0)

	p1.positionPercentBinding = v18
	p1.positionPercentBindingUpdate = v19
	p1.motor = Otter.createSingleMotor(0)
	p1.motor:onStep(p1.positionPercentBindingUpdate)
	p1.motor:onComplete(function() -- line: 125
		-- upvalues: p1 (copy)
		if p1.wasDismissed then
			p1.wasDismissed = false

			if p1.props.onDismiss then
				p1.props.onDismiss()
			end
		end
	end)
	p1.motorType = Otter.spring
	p1.motorOptions = t3

	if p1.props.motorOverrideOptions then
		p1.motorType = p1.props.motorOverrideOptions.motorCallback
		p1.motorOptions = p1.props.motorOverrideOptions
	end

	p1.state = {
		absoluteSize = Vector2.new(0, 0),
		absolutePosition = Vector2.new(0, 0)
	}
	p1.visibleBinding = p1.positionPercentBinding:map(function(p2) -- line: 145
		return p2 ~= 0
	end)
end
function v16.render(p3) -- line: 150
	-- upvalues: withStyle (copy), MenuDirection (copy), GuiService (copy), Roact (copy), BaseMenu (copy)
	return withStyle(function(p4) -- line: 151
		-- upvalues: p3 (copy), MenuDirection (copy), GuiService (copy), Roact (copy), BaseMenu (copy)
		local n1 = 0.5
		local uDim = UDim.new(1, -24)
		local uDim2 = UDim.new(0, 0)
		local v31 = p3.state.absoluteSize.X > 640

		if v31 then
			uDim = UDim.new(0, 300)
			uDim2 = p3.props.openPositionX

			if p3.props.horizontalAlignment == Enum.HorizontalAlignment.Left then
				n1 = 0
			elseif p3.props.horizontalAlignment == Enum.HorizontalAlignment.Right then
				n1 = 1
			end
		end

		local n2 = 0

		if p3.props.menuDirection == MenuDirection.Up then
			n2 = 1
		end

		local OverlayTransparency = p4.Theme.Overlay.Transparency

		if not p3.props.closeBackgroundVisible then
			OverlayTransparency = 1
		end

		local v34 = p3.props.contextMenuWidthOverride or uDim
		local v35 = p3.props.anchorPointOverride or Vector2.new(n1, n2)
		local v36, _ = GuiService:GetGuiInset()
		local v38 = p3.state.absolutePosition + v36

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = p3.visibleBinding,
			ZIndex = p3.props.zIndex,
			[Roact.Change.AbsoluteSize] = function(p5) -- line: 192
				-- upvalues: p3 (copy)
				p3:setState({
					absoluteSize = p5.AbsoluteSize
				})
			end,
			[Roact.Change.AbsolutePosition] = function(p6) -- line: 198
				-- upvalues: p3 (copy)
				p3:setState({
					absolutePosition = p6.AbsolutePosition
				})
			end
		}, {
			Background = Roact.createElement("TextButton", {
				ZIndex = 1,
				Text = "",
				BorderSizePixel = 0,
				BackgroundColor3 = p4.Theme.Overlay.Color,
				BackgroundTransparency = OverlayTransparency,
				AutoButtonColor = false,
				Selectable = false,
				Position = UDim2.fromOffset(-v38.X, -v38.Y),
				Size = UDim2.fromOffset(p3.props.screenSize.X, p3.props.screenSize.Y),
				[Roact.Event.Activated] = function() -- line: 216
					-- upvalues: p3 (copy)
					if not p3.wasDismissed then
						p3.wasDismissed = true
						p3.motor:setGoal(p3.motorType(p3.motorOptions.close.targetValue, p3.motorOptions.close.springParams))
					end
				end
			}),
			PositionFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(uDim2.Scale, uDim2.Offset, p3.props.openPositionY.Scale, p3.props.openPositionY.Offset)
			}, {
				BaseMenu = Roact.createElement(BaseMenu, {
					buttonProps = p3.props.buttonProps,
					setFirstItemRef = p3.props.setFirstItemRef,
					setFrameRef = p3.props.setFrameRef,
					width = v34,
					position = p3.positionPercentBinding:map(function(p7) -- line: 243
						-- upvalues: v31 (copy), p3 (copy), MenuDirection (copy)
						local n3 = 0.5

						if v31 or p3.props.anchorPointOverride then
							if p3.props.horizontalAlignment == Enum.HorizontalAlignment.Left then
								n3 = 0
							elseif p3.props.horizontalAlignment == Enum.HorizontalAlignment.Right then
								n3 = 1
							end
						end

						if p3.props.menuDirection == MenuDirection.Down then
							return UDim2.fromScale(n3, p7 - 1)
						end

						return UDim2.fromScale(n3, 1 - p7)
					end),
					anchorPoint = v35,
					topElementRounded = p3.props.topElementRounded,
					bottomElementRounded = p3.props.bottomElementRounded,
					isElementBackgroundVisible = p3.props.isElementBackgroundVisible,
					isElementDividerVisible = p3.props.isElementDividerVisible,
					elementHeight = p3.props.elementHeight,
					borderCornerRadius = p3.props.borderCornerRadius,
					background = p3.props.background,
					enableTokenOverride = p3.props.enableTokenOverride,
					renderHeader = p3.props.renderHeader,
					headerHeight = p3.props.headerHeight,
					showDropShadow = p3.props.showDropShadow,
					isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled
				})
			})
		})
	end)
end
function v16.didMount(p8) -- line: 278
	if p8.props.open then
		p8.wasDismissed = false
		p8.motor:setGoal(p8.motorType(p8.motorOptions.open.targetValue, p8.motorOptions.open.springParams))
	end
end
function v16.didUpdate(p9, p10, _) -- line: 285
	if p9.props.open ~= p10.open then
		if p9.props.open then
			p9.wasDismissed = false
			p9.motor:setGoal(p9.motorType(p9.motorOptions.open.targetValue, p9.motorOptions.open.springParams))

			return
		end

		p9.motor:setGoal(p9.motorType(p9.motorOptions.close.targetValue, p9.motorOptions.close.springParams))
	end
end
function v16.willUnmount(p12) -- line: 298
	p12.motor:destroy()
end

return v16
