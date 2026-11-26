local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Otter = require(CorePackages.Packages.Otter)
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/dPN")

local v5 = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("ArrowNav")

extended.validateProps = t.intersection(t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Image = t.table,
	Visible = t.optional(t.union(t.boolean, t.table)),
	navDirection = t.optional(t.string),
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
}), function(p2)
	if not p2.defaultUseProps then
		return true
	end

	if p2.defaultUseProps.buttonRefs ~= nil then
		if p2.defaultUseProps.buttonWidth ~= nil then
			return false, "Cannot set both buttonWidth and buttonRefs"
		end

		if p2.defaultUseProps.numButtons ~= nil then
			return false, "Cannot set both numButtons and buttonRefs"
		end
	end

	if p2.defaultUseProps.buttonWidth ~= nil and p2.defaultUseProps.numButtons == nil then
		return false, "If setting buttonWidth must also set numButtons"
	end

	if p2.defaultUseProps.buttonWidth == nil and p2.defaultUseProps.numButtons ~= nil then
		return false, "If setting numButtons must also set buttonWidth"
	end

	if
		p2.defaultUseProps.buttonRefs == nil
		and p2.defaultUseProps.buttonWidth == nil
		and p2.defaultUseProps.numButtons == nil
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

	function self.handleInputBegan(p2, p3)
		(self.props.onPressHoldInputBegan or self.onPressHoldInputBegan)(p3, self.props.navDirection)
	end

	function self.handleInputEnded(p2, p3)
		(self.props.onPressHoldInputEnded or self.onPressHoldInputEnded)(p3, self.props.navDirection)
	end

	function self.getNewCanvasPosition(p2)
		return self.props.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(p2, 0)
	end

	function self.disconnectHoldConn()
		if self.holdConn == nil then
			return
		end

		self.holdConn:Disconnect()
		self.holdConn = nil
	end

	function self.onPressHoldInputBegan(p2, p3)
		if p2.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		self.timeOfInputBegan = tick()
		self.disconnectHoldConn()
		self.holdConn = RunService.RenderStepped:connect(function(p4)
			local v6 = tick() - self.timeOfInputBegan
			local v7 = p3 == module.NavigationDirection.IS_LEFT and -1 or 1
			local newCanvasPosition = self.getNewCanvasPosition(v7 * 500 * p4 * v6 ^ 2)
			self.props.defaultUseProps.updateCanvasPosition(newCanvasPosition)
		end)
	end

	function self.onPressHoldInputEnded(p2, p3)
		if p2.UserInputState ~= Enum.UserInputState.End then
			return
		end

		local current = self.props.defaultUseProps.scrollingFrameRef.current

		if tick() - self.timeOfInputBegan <= 0.5 then
			if self.motor then
				self.motor:destroy()
			end

			self:setMotor(current.CanvasPosition.X)
			self.motor:setGoal(self:getGoal(p3))
		else
			self.motor:setGoal(Otter.instant(current.CanvasPosition.X))
		end

		self.disconnectHoldConn()
	end
end

function extended:getGoal(p2)
	return Otter.spring(self:getScrollToLocation(p2), v5)
end

function extended:didMount()
	self:setMotor(0)
end

function extended:setMotor(p2)
	self.motor = Otter.createSingleMotor(p2)
	self.motor:onStep(function(p3)
		self.props.defaultUseProps.updateCanvasPosition(Vector2.new(p3, 0))
	end)
	self.motor:onComplete(function(p3)
		self.props.defaultUseProps.updateCanvasPosition(Vector2.new(p3, 0))
	end)
end

function extended.render(data)
	return withStyle(function(p2)
		local theme = p2.Theme
		return Roact.createElement(imageSetButton, {
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
	self.disconnectHoldConn()

	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

function extended:getScrollToLocation(p3)
	local current = self.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = self.props.defaultUseProps.buttonPadding
	local offsets = {}
	local buttonRefs = self.props.defaultUseProps.buttonRefs
	local buttonWidth = self.props.defaultUseProps.buttonWidth
	local numButtons = self.props.defaultUseProps.numButtons
	local padOutsideEdges = self.props.defaultUseProps.padOutsideEdges

	if buttonWidth and numButtons then
		offsets = table.create(numButtons, buttonWidth)
	else
		for k, buttonRef in buttonRefs do
			table.insert(offsets, buttonRef.current and buttonRef.current.Size.X.Offset or 0)
		end
	end

	local scrollToLocation = 0

	if p3 == module.NavigationDirection.IS_LEFT then
		local v6 = current.CanvasPosition.X - current.AbsoluteSize.X * 0.4

		for k, v7 in offsets do
			if scrollToLocation + v7 + buttonPadding < v6 then
				scrollToLocation = scrollToLocation + v7 + buttonPadding
			else
				return scrollToLocation
			end
		end

		return scrollToLocation
	else
		local v6 = current.CanvasPosition.X + current.AbsoluteSize.X * 0.4

		scrollToLocation = -current.AbsoluteSize.X

		if padOutsideEdges then
			scrollToLocation += buttonPadding
		end

		for k, v7 in offsets do
			if v6 < scrollToLocation then
				return scrollToLocation
			end

			scrollToLocation = scrollToLocation + v7 + buttonPadding
		end

		return scrollToLocation
	end
end

return extended
