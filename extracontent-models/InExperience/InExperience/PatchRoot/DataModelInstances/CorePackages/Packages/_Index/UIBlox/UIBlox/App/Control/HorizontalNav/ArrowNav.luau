local RunService = game:GetService("RunService")

local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local core = parent.Core

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Otter = require(parent2.Otter)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Button = ImageSetComponent.Button
local withStyle = require(core.Style.withStyle)
local NavigationDirection = require(script.Parent.NavigationDirection)

local v = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("ArrowNav")

extended.validateProps = t.intersection(t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Image = t.table,
	Visible = t.optional(t.union(t.boolean, t.table)),
	navDirection = t.optional(t.userdata),
	onPressHoldInputBegan = t.optional(t.callback),
	onPressHoldInputEnded = t.optional(t.callback),
	defaultUseProps = t.optional(t.strictInterface({
		scrollingFrameRef = t.table,
		buttonRefs = t.optional(t.table),
		buttonWidth = t.optional(t.number),
		numButtons = t.optional(t.number),
		padOutsideEdges = t.optional(t.boolean),
		buttonPadding = t.number,
		updateCanvasPosition = t.callback
	}))
}), function(p)
	if not p.defaultUseProps then
		return true
	end

	if p.defaultUseProps.buttonRefs ~= nil then
		if p.defaultUseProps.buttonWidth ~= nil then
			return false, "Cannot set both buttonWidth and buttonRefs"
		end

		if p.defaultUseProps.numButtons ~= nil then
			return false, "Cannot set both numButtons and buttonRefs"
		end
	end

	if p.defaultUseProps.buttonWidth ~= nil and p.defaultUseProps.numButtons == nil then
		return false, "If setting buttonWidth must also set numButtons"
	end

	if p.defaultUseProps.buttonWidth == nil and p.defaultUseProps.numButtons ~= nil then
		return false, "If setting numButtons must also set buttonWidth"
	end

	if
		p.defaultUseProps.buttonRefs == nil
		and p.defaultUseProps.buttonWidth == nil
		and p.defaultUseProps.numButtons == nil
	then
		return false, "Must set either buttonRefs or (buttonWidth and numButtons)"
	end

	return true
end)

extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	Visible = true
}

function extended:init()
	self.holdConn = nil
	self.timeOfInputBegan = 0

	function self.handleInputBegan(_, p)
		local navDirection = self.props.navDirection

		if self.props.onPressHoldInputBegan then
			self.props.onPressHoldInputBegan(p, navDirection)
		else
			self:onPressHoldInputBegan(p, navDirection)
		end
	end

	function self.handleInputEnded(_, p)
		local navDirection = self.props.navDirection

		if self.props.onPressHoldInputEnded then
			self.props.onPressHoldInputEnded(p, navDirection)
		else
			self:onPressHoldInputEnded(p, navDirection)
		end
	end
end

function extended:getGoal(p)
	return Otter.spring(self:getScrollToLocation(p), v)
end

function extended:didMount()
	self:setMotor(0)
end

function extended:setMotor(p: number)
	self.motor = Otter.createSingleMotor(p)
	self.motor:onStep(function(p2)
		self.props.defaultUseProps.updateCanvasPosition(Vector2.new(p2, 0))
	end)
	self.motor:onComplete(function(p2)
		self.props.defaultUseProps.updateCanvasPosition(Vector2.new(p2, 0))
	end)
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme
		return Roact.createElement(Button, {
			AnchorPoint = data.props.AnchorPoint,
			Position = data.props.Position,
			Image = data.props.Image,
			Visible = data.props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = theme.IconEmphasis.Color,
			Size = UDim2.fromOffset(36, 36),
			[Roact.Event.InputBegan] = data.handleInputBegan,
			[Roact.Event.InputEnded] = data.handleInputEnded
		})
	end)
end

function extended:willUnmount()
	self:disconnectHoldConn()

	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

function extended:getNewCanvasPosition(p: number)
	return self.props.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(p, 0)
end

function extended:disconnectHoldConn()
	if self.holdConn == nil then
		return
	end

	self.holdConn:Disconnect()
	self.holdConn = nil
end

function extended:onPressHoldInputBegan(p, p2)
	if p.UserInputState ~= Enum.UserInputState.Begin then
		return
	end

	self.timeOfInputBegan = tick()
	self:disconnectHoldConn()
	self.holdConn = RunService.RenderStepped:connect(function(p3)
		local v2 = tick() - self.timeOfInputBegan
		local newCanvasPosition = self:getNewCanvasPosition((p2 == NavigationDirection.IsLeft and -1 or 1) * 500 * p3 * v2 ^ 2)
		self.props.defaultUseProps.updateCanvasPosition(newCanvasPosition)
	end)
end

function extended:onPressHoldInputEnded(p, p2)
	if p.UserInputState ~= Enum.UserInputState.End then
		return
	end

	local current = self.props.defaultUseProps.scrollingFrameRef.current

	if tick() - self.timeOfInputBegan <= 0.5 then
		if self.motor then
			self.motor:destroy()
		end

		self:setMotor(current.CanvasPosition.X)
		self.motor:setGoal(self:getGoal(p2))
	else
		self.motor:setGoal(Otter.instant(current.CanvasPosition.X))
	end

	self:disconnectHoldConn()
end

function extended:getScrollToLocation(p)
	local buttonSizes = self:getButtonSizes()

	if p == NavigationDirection.IsLeft then
		return self:getScrollToLeftLocation(buttonSizes)
	end

	return self:getScrollToRightLocation(buttonSizes)
end

function extended:getButtonSizes()
	local buttonRefs = self.props.defaultUseProps.buttonRefs
	local buttonWidth = self.props.defaultUseProps.buttonWidth
	local numButtons = self.props.defaultUseProps.numButtons

	if buttonWidth and numButtons then
		return table.create(numButtons, buttonWidth)
	end

	local result = {}

	for _, buttonRef in ipairs(buttonRefs) do
		table.insert(result, buttonRef.current and buttonRef.current.AbsoluteSize.X or 0)
	end

	return result
end

function extended:getScrollToLeftLocation(list)
	local current = self.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = self.props.defaultUseProps.buttonPadding

	local v2 = current.CanvasPosition.X - current.AbsoluteSize.X * 0.4
	local scrollToLeftLocation = 0

	for _, item in ipairs(list) do
		if v2 <= scrollToLeftLocation + item + buttonPadding then
			return scrollToLeftLocation
		end

		scrollToLeftLocation += item + buttonPadding
	end

	return scrollToLeftLocation
end

function extended:getScrollToRightLocation(list)
	local current = self.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = self.props.defaultUseProps.buttonPadding
	local padOutsideEdges = self.props.defaultUseProps.padOutsideEdges

	local v2 = current.CanvasPosition.X + current.AbsoluteSize.X * 0.4

	local scrollToRightLocation = -current.AbsoluteSize.X

	if padOutsideEdges then
		scrollToRightLocation += buttonPadding
	end

	for _, item in ipairs(list) do
		if v2 < scrollToRightLocation then
			return scrollToRightLocation
		end

		scrollToRightLocation += item + buttonPadding
	end

	return scrollToRightLocation
end

return extended
