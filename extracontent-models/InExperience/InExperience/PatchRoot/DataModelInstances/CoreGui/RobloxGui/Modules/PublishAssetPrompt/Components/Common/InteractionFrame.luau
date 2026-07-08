local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local function splitInputType(p1) -- line: 15
	local v10 = p1.UserInputType == Enum.UserInputType.Touch
	local v11 = p1.UserInputType == Enum.UserInputType.MouseButton1
	local v12 = p1.UserInputType == Enum.UserInputType.MouseButton2

	return v10, v11 or v12, v11, v12
end

local v8 = Roact.PureComponent:extend("InteractionFrame")

v8.defaultProps = {
	Visible = true
}
v8.validateProps = t.interface({
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

function v8.disconnectEvents(p2) -- line: 43
	p2.inputChangedConnection:Disconnect()
	p2.inputEndedConnection:Disconnect()
	p2.renderSteppedConnection:Disconnect()
	p2.inputChangedConnection = nil
	p2.inputEndedConnection = nil
	p2.renderSteppedConnection = nil
end
function v8.getActiveInput(p3, p4) -- line: 52
	local v16 = p4.UserInputType == Enum.UserInputType.Touch
	local v17 = p4.UserInputType == Enum.UserInputType.MouseButton1
	local v18 = p4.UserInputType == Enum.UserInputType.MouseButton2
	local v19 = v17 or v18
	local v20 = p4.UserInputType == Enum.UserInputType.MouseMovement or v19

	if not v20 and not v16 then
		return
	end

	local v21 = nil

	if v20 then
		return p3.activeMouseInput
	end

	if v16 then
		v21 = p3.activeTouchInputs[p4]
	end

	return v21
end
function v8.removeActivePointerInput(p5, p6, p7) -- line: 71
	-- upvalues: UserInputService (copy)
	if p7 then
		if not not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
			return
		end

		p5.activeMouseInput = nil
	else
		p5.activeTouchInputs[p6] = nil
		p5.numActiveTouchInputs = p5.numActiveTouchInputs - 1
	end

	p5.numActiveInputs = p5.numActiveInputs - 1

	if p5.numActiveInputs == 0 then
		p5:disconnectEvents()
	end
end
function v8.handleDoubleTap(p8, p9, p10) -- line: 94
	if p8.lastPrimaryPointerInputBeganPosition then
		local v28 = p8.lastPrimaryPointerInputBeganPosition - p9.Position
		local v29 = p10 - p8.lastPrimaryPointerInputBeganTime

		if p8.props.doubleTap and v28.Magnitude < 30 and v29 < 0.25 then
			p8.props.doubleTap()
		end
	end

	p8.lastPrimaryPointerInputBeganPosition = p9.Position
	p8.lastPrimaryPointerInputBeganTime = p10
end
function v8.addActivePointerInput(p11, p12, p13, p14) -- line: 112
	-- upvalues: Cryo (copy), UserInputService (copy), RunService (copy)
	if p11:getActiveInput(p12) then
		return
	end

	local t1 = {
		lastPosition = p12.Position,
		lastTime = p14
	}

	if p13 then
		p11.activeMouseInput = t1
	else
		p11.activeTouchInputs[p12] = Cryo.Dictionary.join(t1, {
			lastDeltaTime = 0,
			lastDeltaPosition = Vector3.new(0, 0, 0)
		})
		p11.numActiveTouchInputs = p11.numActiveTouchInputs + 1
	end

	p11.numActiveInputs = p11.numActiveInputs + 1

	if p11.numActiveInputs == 1 then
		p11.props.setAngularVelocityByPixels(0)
		p11.inputChangedConnection = UserInputService.InputChanged:Connect(p11.onInputChanged)
		p11.inputEndedConnection = UserInputService.InputEnded:Connect(p11.onInputEnded)
		p11.renderSteppedConnection = RunService.RenderStepped:Connect(p11.setInputNotChanged)
	end
end
function v8.init(p15) -- line: 141
	-- upvalues: UserInputService (copy)
	p15.inputChangedConnection = nil
	p15.inputEndedConnection = nil
	p15.lastPinchDistance = 1
	p15.lastPanTime = 0
	p15.lastPrimaryPointerInputBeganTime = 0
	p15.lastPrimaryPointerInputBeganPosition = nil
	p15.activeTouchInputs = {}
	p15.numActiveTouchInputs = 0
	p15.activeMouseInput = nil
	p15.numActiveInputs = 0

	function p15.handleScroll(_, p17) -- line: 156
		-- upvalues: p15 (copy), UserInputService (copy)
		if p17.UserInputType == Enum.UserInputType.MouseWheel then
			local v44 = -p17.Position.Z

			p15.props.zoomToPoint(v44, UserInputService:GetMouseLocation())
		end
	end
	function p15.setInputNotChanged(_) -- line: 163
		-- upvalues: p15 (copy)
		for _, v47 in p15.activeTouchInputs do
			v47.changedThisFrame = false
		end
	end
	function p15.onInputChanged(p19, _) -- line: 169
		-- upvalues: p15 (copy), UserInputService (copy)
		local v50 = p19.UserInputType == Enum.UserInputType.MouseMovement
		local v51 = p19.UserInputType == Enum.UserInputType.Touch

		if not v50 and not v51 then
			return
		end

		local v52 = p15:getActiveInput(p19)

		if not v52 then
			return
		end

		local timestamp = tick()
		local v54 = timestamp - v52.lastTime
		local v55 = p19.Position - v52.lastPosition
		local v56 = Vector2.new(v55.X, v55.Y) * Vector2.new(-1, 1)
		local v57 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local v58 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		local v59 = timestamp - p15.lastPanTime > 0.1

		if (v50 and v57 or v51 and p15.numActiveTouchInputs == 1) and v59 then
			p15.props.rotateByPixels(-v56)
		end

		if v50 and v58 or v51 and p15.numActiveTouchInputs == 2 then
			local v60 = v56 / p15.numActiveInputs

			p15.props.panByPixels(v60)
			p15.lastPanTime = timestamp
		end

		v52.lastPosition = p19.Position
		v52.lastTime = timestamp

		if v51 then
			if v52.changedThisFrame then
				v52.lastDeltaPosition = v55 + v52.lastDeltaPosition
				v52.lastDeltaTime = v54 + v52.lastDeltaTime

				return
			end

			v52.lastDeltaPosition = v55
			v52.lastDeltaTime = v54
			v52.changedThisFrame = true
		end
	end
	function p15.onInputEnded(p21, _) -- line: 221
		-- upvalues: p15 (copy)
		local v63 = p21.UserInputType == Enum.UserInputType.Touch
		local v64 = p21.UserInputType == Enum.UserInputType.MouseButton1
		local v65 = p21.UserInputType == Enum.UserInputType.MouseButton2
		local v66 = v64 or v65

		if not v63 and not v66 then
			return
		end

		local v67 = p15:getActiveInput(p21)

		if not v67 then
			return
		end

		local timestamp = tick()
		local v69 = timestamp - p15.lastPanTime
		local v70 = v63 and v67.changedThisFrame
		local v71 = p15.numActiveInputs == 1 and v69 > 0.1

		if (v70 or v64) and v71 then
			local v72, v73

			if v64 then
				v72 = p21.Position - v67.lastPosition
				v73 = timestamp - v67.lastTime
			else
				v72 = v67.lastDeltaPosition
				v73 = v67.lastDeltaTime
			end

			p15.props.setAngularVelocityByPixels(v72.X / v73)
		end

		p15:removeActivePointerInput(p21, v66)
	end
	function p15.onInputBegan(p23, p24) -- line: 259
		-- upvalues: p15 (copy)
		p15.handleScroll(p23, p24)

		local v76 = p24.UserInputType == Enum.UserInputType.Touch
		local v77 = p24.UserInputType == Enum.UserInputType.MouseButton1
		local v78 = p24.UserInputType == Enum.UserInputType.MouseButton2
		local v79 = v77 or v78

		if not v76 and not v79 then
			return
		end

		local v80 = v76 or v77
		local timestamp = tick()

		if v80 then
			p15:handleDoubleTap(p24, timestamp)
		end

		p15:addActivePointerInput(p24, v79, timestamp)
	end
	function p15.onTouchPinch(_, p26, _, _, p29) -- line: 279
		-- upvalues: p15 (copy)
		if p26[2] == nil then
			return
		end

		if p29 == Enum.UserInputState.Begin then
			p15.lastPinchDistance = (p26[1] - p26[2]).Magnitude

			return
		end

		local Magnitude = (p26[1] - p26[2]).Magnitude
		local v88 = Magnitude - p15.lastPinchDistance

		p15.lastPinchDistance = Magnitude
		p15.props.zoomToPoint(v88 * -0.05, (p26[1] + p26[2]) / 2)
	end
end
function v8.willUnmount(p30) -- line: 296
	if p30.inputChangedConnection then
		p30:disconnectEvents()
	end
end
function v8.render(p31) -- line: 302
	-- upvalues: Roact (copy)
	local propsVisible = p31.props.Visible
	local v39 = p31.props.Size or UDim2.new(1, 0, 1, 0)
	local propsPosition = p31.props.Position
	local propsZIndex = p31.props.ZIndex

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v39,
		Position = propsPosition,
		ZIndex = propsZIndex,
		Visible = propsVisible,
		Active = true,
		[Roact.Event.InputBegan] = p31.onInputBegan,
		[Roact.Event.InputChanged] = p31.handleScroll,
		[Roact.Event.TouchPinch] = p31.onTouchPinch
	}, p31.props[Roact.Children])
end

return v8
