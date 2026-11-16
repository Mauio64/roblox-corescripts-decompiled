local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local invariant = require(parent.utils.invariant)

local extended = React.Component:extend("StackViewCard")

function extended:init()
	local index = self.props.navigation.state.index

	self._isMounted = false
	self._positionLastValue = index

	self._ref = React.createRef()
end

function extended:render()
	local forceHidden = self.props.forceHidden
	local cardColor3 = self.props.cardColor3
	local initialPosition = self.props.initialPosition
	local renderScene = self.props.renderScene
	local scene = self.props.scene

	invariant(type(renderScene) == "function", "renderScene must be a function")

	return React.createElement("Frame", {
		Position = initialPosition,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = cardColor3,
		BackgroundTransparency = cardColor3 == nil and 1 or nil,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Visible = not forceHidden,
		ref = self._ref
	}, { Content = renderScene(scene) })
end

function extended:didMount()
	self._isMounted = true

	self._positionDisconnector = self.props.position:onStep(function(...)
		self:_onPositionStep(...)
	end)
end

function extended:willUnmount()
	self._isMounted = false

	if self._positionDisconnector then
		self._positionDisconnector()
		self._positionDisconnector = nil
	end
end

function extended:didUpdate(p)
	local position = self.props.position
	local positionStep = self.props.positionStep

	if position ~= p.position then
		self._positionDisconnector()
		self._positionDisconnector = position:onStep(function(...)
			self:_onPositionStep(...)
		end)
	end

	if positionStep ~= p.positionStep then
		self:_onPositionStep(self._positionLastValue)
	end
end

function extended:_onPositionStep(positionLastValue)
	if not self._isMounted then
		return
	end

	local positionStep = self.props.positionStep

	if positionStep then
		positionStep(self._ref, positionLastValue)
	end

	self._positionLastValue = positionLastValue
end

return extended
