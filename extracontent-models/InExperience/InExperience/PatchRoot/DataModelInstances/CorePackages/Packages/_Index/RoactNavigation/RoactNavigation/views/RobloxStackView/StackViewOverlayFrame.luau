local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local lerp = require(parent.utils.lerp)

local extended = React.Component:extend("StackViewOverlayFrame")

function extended:init()
	self._signalDisconnect = nil

	self._ref = React.createRef()
end

function extended:render()
	local navigationOptions = self.props.navigationOptions
	local initialTransitionValue = self.props.initialTransitionValue

	local backgroundTransparency = lerp(1, navigationOptions.overlayTransparency, initialTransitionValue)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = navigationOptions.overlayColor3,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		ref = self._ref
	})
end

function extended:didUpdate(p)
	local transitionChangedSignal = self.props.transitionChangedSignal

	if transitionChangedSignal ~= p.transitionChangedSignal then
		if self._signalDisconnect then
			self._signalDisconnect()
		end

		self._signalDisconnect = transitionChangedSignal(function(...)
			self:_transitionChanged(...)
		end)
	end
end

function extended:didMount()
	self._isMounted = true
	self._signalDisconnect = self.props.transitionChangedSignal(function(...)
		self:_transitionChanged(...)
	end)
end

function extended:willUnmount()
	self._isMounted = false

	if self._signalDisconnect then
		self._signalDisconnect()
		self._signalDisconnect = nil
	end
end

function extended:_transitionChanged(p)
	if not self._isMounted then
		return
	end

	if self._ref.current then
		local backgroundTransparency = lerp(1, self.props.navigationOptions.overlayTransparency, p)
		self._ref.current.BackgroundTransparency = backgroundTransparency
	end
end

return extended
