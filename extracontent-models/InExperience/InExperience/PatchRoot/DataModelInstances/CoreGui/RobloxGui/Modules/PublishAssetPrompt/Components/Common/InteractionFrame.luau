local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local function splitInputType(p) -- 2 equivalent calls inferred from this helper
	local v = p.UserInputType == Enum.UserInputType.Touch
	local v2 = p.UserInputType == Enum.UserInputType.MouseButton1
	local selected = p.UserInputType == Enum.UserInputType.MouseButton2

	return v, v2 or selected, v2, selected
end

local extended = Roact.PureComponent:extend("InteractionFrame")

extended.defaultProps = { Visible = true }

extended.validateProps = t.interface({
	panByPixels = t.callback,
	rotateByPixels = t.callback,
	setAngularVelocityByPixels = t.callback,
	zoomToPoint = t.callback,
	doubleTap = t.optional(t.callback),
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	Visible = t.optional(t.boolean),
	ZIndex = t.optional(t.number)
})

function extended:disconnectEvents()
	self.inputChangedConnection:Disconnect()
	self.inputEndedConnection:Disconnect()
	self.renderSteppedConnection:Disconnect()
	self.inputChangedConnection = nil
	self.inputEndedConnection = nil
	self.renderSteppedConnection = nil
end

function extended:getActiveInput(p)
	local v = p.UserInputType == Enum.UserInputType.Touch
	local v2 = p.UserInputType == Enum.UserInputType.MouseButton1
	local v3 = p.UserInputType == Enum.UserInputType.MouseButton2

	local v4 = p.UserInputType == Enum.UserInputType.MouseMovement or v2 or v3

	if not (v4 or v) then
		return
	end

	local v5 = nil

	if v4 then
		return self.activeMouseInput
	end

	if v then
		return self.activeTouchInputs[p]
	end

	return v5
end

function extended:removeActivePointerInput(p, p2)
	if p2 then
		if
			UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		then
			return
		end

		self.activeMouseInput = nil
	else
		self.activeTouchInputs[p] = nil
		self.numActiveTouchInputs -= 1
	end

	self.numActiveInputs -= 1

	if self.numActiveInputs == 0 then
		self:disconnectEvents()
	end
end

function extended:handleDoubleTap(p, lastPrimaryPointerInputBeganTime)
	if self.lastPrimaryPointerInputBeganPosition then
		local v = self.lastPrimaryPointerInputBeganPosition - p.Position
		local v2 = lastPrimaryPointerInputBeganTime - self.lastPrimaryPointerInputBeganTime

		if self.props.doubleTap and v.Magnitude < 30 and v2 < 0.25 then
			self.props.doubleTap()
		end
	end

	self.lastPrimaryPointerInputBeganPosition = p.Position
	self.lastPrimaryPointerInputBeganTime = lastPrimaryPointerInputBeganTime
end

function extended:addActivePointerInput(p, p2, lastTime)
	if self:getActiveInput(p) then
		return
	end

	local activeMouseInput = { lastPosition = p.Position, lastTime = lastTime }

	if p2 then
		self.activeMouseInput = activeMouseInput
	else
		self.activeTouchInputs[p] = Cryo.Dictionary.join(activeMouseInput, {
			lastDeltaTime = 0,
			lastDeltaPosition = Vector3.new(0, 0, 0)
		})

		self.numActiveTouchInputs += 1
	end

	self.numActiveInputs += 1

	if self.numActiveInputs == 1 then
		self.props.setAngularVelocityByPixels(0)
		self.inputChangedConnection = UserInputService.InputChanged:Connect(self.onInputChanged)
		self.inputEndedConnection = UserInputService.InputEnded:Connect(self.onInputEnded)
		self.renderSteppedConnection = RunService.RenderStepped:Connect(self.setInputNotChanged)
	end
end

function extended:init()
	self.inputChangedConnection = nil
	self.inputEndedConnection = nil

	self.lastPinchDistance = 1
	self.lastPanTime = 0
	self.lastPrimaryPointerInputBeganTime = 0
	self.lastPrimaryPointerInputBeganPosition = nil

	self.activeTouchInputs = {}
	self.numActiveTouchInputs = 0
	self.activeMouseInput = nil

	self.numActiveInputs = 0

	function self.handleScroll(_, p)
		if p.UserInputType == Enum.UserInputType.MouseWheel then
			local v = -p.Position.Z
			self.props.zoomToPoint(v, UserInputService:GetMouseLocation())
		end
	end

	function self.setInputNotChanged(_)
		for _, activeTouchInput in self.activeTouchInputs do
			activeTouchInput.changedThisFrame = false
		end
	end

	function self.onInputChanged(p, _)
		local v = p.UserInputType == Enum.UserInputType.MouseMovement
		local v2 = p.UserInputType == Enum.UserInputType.Touch

		if not (v or v2) then
			return
		end

		local activeInput = self:getActiveInput(p)

		if not activeInput then
			return
		end

		local now = tick()
		local lastDeltaTime = now - activeInput.lastTime
		local lastDeltaPosition = p.Position - activeInput.lastPosition
		local v3 = Vector2.new(lastDeltaPosition.X, lastDeltaPosition.Y) * Vector2.new(-1, 1)

		local isMouseButtonPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local isMouseButtonPressed2 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

		local v4 = now - self.lastPanTime > 0.1

		if (v and isMouseButtonPressed or v2 and self.numActiveTouchInputs == 1) and v4 then
			self.props.rotateByPixels(-v3)
		end

		if v and isMouseButtonPressed2 or v2 and self.numActiveTouchInputs == 2 then
			local v5 = v3 / self.numActiveInputs
			self.props.panByPixels(v5)
			self.lastPanTime = now
		end

		activeInput.lastPosition = p.Position
		activeInput.lastTime = now

		if v2 then
			if activeInput.changedThisFrame then
				activeInput.lastDeltaPosition = lastDeltaPosition + activeInput.lastDeltaPosition
				activeInput.lastDeltaTime = lastDeltaTime + activeInput.lastDeltaTime
			else
				activeInput.lastDeltaPosition = lastDeltaPosition
				activeInput.lastDeltaTime = lastDeltaTime
				activeInput.changedThisFrame = true
			end
		end
	end

	function self.onInputEnded(p, _)
		local v, v2, v3 = splitInputType(p) -- inferred equivalent call

		if not (v or v2) then
			return
		end

		local activeInput = self:getActiveInput(p)

		if not activeInput then
			return
		end

		local now = tick()
		local v4 = now - self.lastPanTime
		local changedThisFrame = v and activeInput.changedThisFrame
		local v5

		if self.numActiveInputs == 1 then
			v5 = v4 > 0.1
		else
			v5 = false
		end

		if (changedThisFrame or v3) and v5 then
			local v6, v7

			if v3 then
				v6 = p.Position - activeInput.lastPosition
				v7 = now - activeInput.lastTime
			else
				v6 = activeInput.lastDeltaPosition
				v7 = activeInput.lastDeltaTime
			end

			self.props.setAngularVelocityByPixels(v6.X / v7)
		end

		self:removeActivePointerInput(p, v2)
	end

	function self.onInputBegan(p, p2)
		self.handleScroll(p, p2)
		local v, v2, v3 = splitInputType(p2) -- inferred equivalent call

		if not (v or v2) then
			return
		end

		local now = tick()

		if v or v3 then
			self:handleDoubleTap(p2, now)
		end

		self:addActivePointerInput(p2, v2, now)
	end

	function self.onTouchPinch(_, list, _, _, p)
		if list[2] == nil then
			return
		end

		if p == Enum.UserInputState.Begin then
			self.lastPinchDistance = (list[1] - list[2]).Magnitude
			return
		end

		local magnitude = (list[1] - list[2]).Magnitude
		local v = magnitude - self.lastPinchDistance
		self.lastPinchDistance = magnitude
		self.props.zoomToPoint(v * -0.05, (list[1] + list[2]) / 2)
	end
end

function extended:willUnmount()
	if self.inputChangedConnection then
		self:disconnectEvents()
	end
end

function extended.render(props)
	local visible = props.props.Visible

	local size = props.props.Size or UDim2.new(1, 0, 1, 0)
	local position = props.props.Position
	local zIndex = props.props.ZIndex

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		Position = position,
		ZIndex = zIndex,
		Visible = visible,
		Active = true,
		[Roact.Event.InputBegan] = props.onInputBegan,
		[Roact.Event.InputChanged] = props.handleScroll,
		[Roact.Event.TouchPinch] = props.onTouchPinch
	}, props.props[Roact.Children])
end

return extended
