local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Otter = require(parent2.Otter)

local withStyle = require(parent.Core.Style.withStyle)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)

local BaseMenu = require(script.Parent.BaseMenu)
local MenuDirection = require(script.Parent.MenuDirection)
local validateButtonProps = require(script.Parent.validateButtonProps)
local validateMotorOptionProps = require(script.Parent.validateMotorOptionProps)

local motorOptions = {
	open = {
		targetValue = 1,
		springParams = { frequency = 4, dampingRatio = 1 }
	},
	close = {
		targetValue = 0,
		springParams = { frequency = 2.6, dampingRatio = 1 }
	}
}

local extended = Roact.PureComponent:extend("ContextualMenu")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	menuDirection = MenuDirection.Up,
	zIndex = 2,
	closeBackgroundVisible = true,
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	openPositionX = UDim.new(0, 0)
}

function extended:init()
	self.wasDismissed = false

	local binding, positionPercentBindingUpdate = Roact.createBinding(0)
	self.positionPercentBinding = binding
	self.positionPercentBindingUpdate = positionPercentBindingUpdate

	self.motor = Otter.createSingleMotor(0)
	self.motor:onStep(self.positionPercentBindingUpdate)
	self.motor:onComplete(function()
		if self.wasDismissed then
			self.wasDismissed = false

			if self.props.onDismiss then
				self.props.onDismiss()
			end
		end
	end)
	self.motorType = Otter.spring
	self.motorOptions = motorOptions

	if self.props.motorOverrideOptions then
		self.motorType = self.props.motorOverrideOptions.motorCallback
		self.motorOptions = self.props.motorOverrideOptions
	end

	self.state = { absoluteSize = Vector2.new(0, 0), absolutePosition = Vector2.new(0, 0) }

	self.visibleBinding = self.positionPercentBinding:map(function(p): boolean
		return p ~= 0
	end)
end

function extended:render()
	return withStyle(function(p)
		local v = 0.5
		local udim = UDim.new(1, -24)
		local v2 = UDim.new(0, 0)
		local v3 = self.state.absoluteSize.X > 640

		if v3 then
			udim = UDim.new(0, 300)
			v2 = self.props.openPositionX

			if self.props.horizontalAlignment == Enum.HorizontalAlignment.Left then
				v = 0
			elseif self.props.horizontalAlignment == Enum.HorizontalAlignment.Right then
				v = 1
			end
		end

		local v4 = self.props.menuDirection == MenuDirection.Up and 1 or 0

		local transparency = p.Theme.Overlay.Transparency
		local backgroundTransparency = not self.props.closeBackgroundVisible and 1 or transparency

		local contextMenuWidthOverride = self.props.contextMenuWidthOverride or udim
		local anchorPointOverride = self.props.anchorPointOverride or Vector2.new(v, v4)

		local guiInset, _ = GuiService:GetGuiInset()
		local v5 = self.state.absolutePosition + guiInset

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = self.visibleBinding,
			ZIndex = self.props.zIndex,
			[Roact.Change.AbsoluteSize] = function(p2)
				self:setState({ absoluteSize = p2.AbsoluteSize })
			end,
			[Roact.Change.AbsolutePosition] = function(p2)
				self:setState({ absolutePosition = p2.AbsolutePosition })
			end
		}, {
			Background = Roact.createElement("TextButton", {
				ZIndex = 1,
				Text = "",
				BorderSizePixel = 0,
				BackgroundColor3 = p.Theme.Overlay.Color,
				BackgroundTransparency = backgroundTransparency,
				AutoButtonColor = false,
				Selectable = false,
				Position = UDim2.fromOffset(-v5.X, -v5.Y),
				Size = UDim2.fromOffset(self.props.screenSize.X, self.props.screenSize.Y),
				[Roact.Event.Activated] = function()
					if not self.wasDismissed then
						self.wasDismissed = true
						self.motor:setGoal(self.motorType(
							self.motorOptions.close.targetValue,
							self.motorOptions.close.springParams
						))
					end
				end
			}),
			PositionFrame = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.new(
						v2.Scale,
						v2.Offset,
						self.props.openPositionY.Scale,
						self.props.openPositionY.Offset
					),
					ZIndex = 2
				},
				{
					BaseMenu = Roact.createElement(BaseMenu, {
						buttonProps = self.props.buttonProps,
						setFirstItemRef = self.props.setFirstItemRef,
						setFrameRef = self.props.setFrameRef,
						width = contextMenuWidthOverride,
						position = self.positionPercentBinding:map(function(p2)
							local v6 = 0.5

							if v3 or self.props.anchorPointOverride then
								v6 = self.props.horizontalAlignment == Enum.HorizontalAlignment.Left and 0
									or self.props.horizontalAlignment == Enum.HorizontalAlignment.Right and 1
									or v6
							end

							if self.props.menuDirection == MenuDirection.Down then
								return UDim2.fromScale(v6, p2 - 1)
							end

							return UDim2.fromScale(v6, 1 - p2)
						end),
						anchorPoint = anchorPointOverride,
						topElementRounded = self.props.topElementRounded,
						bottomElementRounded = self.props.bottomElementRounded,
						isElementBackgroundVisible = self.props.isElementBackgroundVisible,
						isElementDividerVisible = self.props.isElementDividerVisible,
						elementHeight = self.props.elementHeight,
						borderCornerRadius = self.props.borderCornerRadius,
						background = self.props.background,
						enableTokenOverride = self.props.enableTokenOverride,
						renderHeader = self.props.renderHeader,
						headerHeight = self.props.headerHeight,
						showDropShadow = self.props.showDropShadow,
						isRoactGamepadEnabled = self.props.isRoactGamepadEnabled
					})
				}
			)
		})
	end)
end

function extended:didMount()
	if self.props.open then
		self.wasDismissed = false
		self.motor:setGoal(self.motorType(self.motorOptions.open.targetValue, self.motorOptions.open.springParams))
	end
end

function extended:didUpdate(p, _)
	if self.props.open ~= p.open then
		if self.props.open then
			self.wasDismissed = false
			self.motor:setGoal(self.motorType(self.motorOptions.open.targetValue, self.motorOptions.open.springParams))
		else
			self.motor:setGoal(self.motorType(self.motorOptions.close.targetValue, self.motorOptions.close.springParams))
		end
	end
end

function extended.willUnmount(p)
	p.motor:destroy()
end

return extended
