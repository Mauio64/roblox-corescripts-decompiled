local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParent.Core
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Otter = require(ParentParentParent.Otter)
local Button = require(Core.ImageSet.ImageSetComponent).Button
local withStyle = require(Core.Style.withStyle)
local NavigationDirection = require(script.Parent.NavigationDirection)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v12 = Roact.PureComponent:extend("ArrowNav")

v12.validateProps = t.intersection(t.strictInterface({
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
}), function(p1) -- line: 63
	if p1.defaultUseProps then
		if p1.defaultUseProps.buttonRefs ~= nil then
			if p1.defaultUseProps.buttonWidth ~= nil then
				return false, "Cannot set both buttonWidth and buttonRefs"
			end

			if p1.defaultUseProps.numButtons ~= nil then
				return false, "Cannot set both numButtons and buttonRefs"
			end
		end

		if p1.defaultUseProps.buttonWidth ~= nil and p1.defaultUseProps.numButtons == nil then
			return false, "If setting buttonWidth must also set numButtons"
		end

		if p1.defaultUseProps.buttonWidth == nil and p1.defaultUseProps.numButtons ~= nil then
			return false, "If setting numButtons must also set buttonWidth"
		end

		if p1.defaultUseProps.buttonRefs == nil and p1.defaultUseProps.buttonWidth == nil and p1.defaultUseProps.numButtons == nil then
			return false, "Must set either buttonRefs or (buttonWidth and numButtons)"
		end
	end

	return true
end)
v12.defaultProps = {
	Visible = true,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0)
}

function v12.init(p2) -- line: 97
	p2.holdConn = nil
	p2.timeOfInputBegan = 0

	function p2.handleInputBegan(_, p4) -- line: 101
		-- upvalues: p2 (copy)
		local navDirection = p2.props.navDirection

		if p2.props.onPressHoldInputBegan then
			p2.props.onPressHoldInputBegan(p4, navDirection)

			return
		end

		p2:onPressHoldInputBegan(p4, navDirection)
	end
	function p2.handleInputEnded(_, p6) -- line: 110
		-- upvalues: p2 (copy)
		local navDirection = p2.props.navDirection

		if p2.props.onPressHoldInputEnded then
			p2.props.onPressHoldInputEnded(p6, navDirection)

			return
		end

		p2:onPressHoldInputEnded(p6, navDirection)
	end
end
function v12.getGoal(p7, p8) -- line: 120
	-- upvalues: Otter (copy), t1 (copy)
	return Otter.spring(p7:getScrollToLocation(p8), t1)
end
function v12.didMount(p9) -- line: 124
	p9:setMotor(0)
end
function v12.setMotor(t2: {[any]: any}, n1: number) -- line: 128
	-- upvalues: Otter (copy)
	t2.motor = Otter.createSingleMotor(n1)
	t2.motor:onStep(function(p10) -- line: 130
		-- upvalues: t2 (copy)
		t2.props.defaultUseProps.updateCanvasPosition(Vector2.new(p10, 0))
	end)
	t2.motor:onComplete(function(p11) -- line: 133
		-- upvalues: t2 (copy)
		t2.props.defaultUseProps.updateCanvasPosition(Vector2.new(p11, 0))
	end)
end
function v12.render(p12) -- line: 138
	-- upvalues: withStyle (copy), Roact (copy), Button (copy)
	return withStyle(function(p13) -- line: 139
		-- upvalues: Roact (copy), Button (copy), p12 (copy)
		local Theme = p13.Theme

		return Roact.createElement(Button, {
			AnchorPoint = p12.props.AnchorPoint,
			Position = p12.props.Position,
			Image = p12.props.Image,
			Visible = p12.props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = Theme.IconEmphasis.Color,
			Size = UDim2.fromOffset(36, 36),
			[Roact.Event.InputBegan] = p12.handleInputBegan,
			[Roact.Event.InputEnded] = p12.handleInputEnded
		})
	end)
end
function v12.willUnmount(p14) -- line: 155
	p14:disconnectHoldConn()

	if p14.motor then
		p14.motor:destroy()
		p14.motor = nil
	end
end
function v12.getNewCanvasPosition(t3: {[any]: any}, n2: number) -- line: 163
	return t3.props.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(n2, 0)
end
function v12.disconnectHoldConn(p15) -- line: 168
	if p15.holdConn == nil then
		return
	end

	p15.holdConn:Disconnect()
	p15.holdConn = nil
end
function v12.onPressHoldInputBegan(p16, p17, p18) -- line: 176
	-- upvalues: RunService (copy), NavigationDirection (copy)
	if p17.UserInputState ~= Enum.UserInputState.Begin then
		return
	end

	p16.timeOfInputBegan = tick()
	p16:disconnectHoldConn()
	p16.holdConn = RunService.RenderStepped:connect(function(p19) -- line: 182
		-- upvalues: p16 (copy), NavigationDirection (copy), p18 (copy)
		local v70 = tick() - p16.timeOfInputBegan
		local v71 = NavigationDirection.IsLeft ~= p18 and 1 or -1
		local v72 = p16:getNewCanvasPosition(v71 * 500 * p19 * v70 ^ 2)

		p16.props.defaultUseProps.updateCanvasPosition(v72)
	end)
end
function v12.onPressHoldInputEnded(p20, p21, p22) -- line: 191
	-- upvalues: Otter (copy)
	if p21.UserInputState ~= Enum.UserInputState.End then
		return
	end

	local current = p20.props.defaultUseProps.scrollingFrameRef.current

	if tick() - p20.timeOfInputBegan <= 0.5 then
		if p20.motor then
			p20.motor:destroy()
		end

		p20:setMotor(current.CanvasPosition.X)
		p20.motor:setGoal(p20:getGoal(p22))
	else
		p20.motor:setGoal(Otter.instant(current.CanvasPosition.X))
	end

	p20:disconnectHoldConn()
end
function v12.getScrollToLocation(p23, p24) -- line: 209
	-- upvalues: NavigationDirection (copy)
	local v34 = p23:getButtonSizes()

	if p24 == NavigationDirection.IsLeft then
		return p23:getScrollToLeftLocation(v34)
	end

	return p23:getScrollToRightLocation(v34)
end
function v12.getButtonSizes(p25) -- line: 219
	local buttonRefs = p25.props.defaultUseProps.buttonRefs
	local buttonWidth = p25.props.defaultUseProps.buttonWidth
	local numButtons = p25.props.defaultUseProps.numButtons

	if buttonWidth and numButtons then
		return table.create(numButtons, buttonWidth)
	end

	local t4 = {}

	for _, v in ipairs(buttonRefs) do
		table.insert(t4, v.current and v.current.AbsoluteSize.X or 0)
	end

	return t4
end
function v12.getScrollToLeftLocation(p26, p27) -- line: 236
	local current = p26.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = p26.props.defaultUseProps.buttonPadding
	local v46 = current.CanvasPosition.X - current.AbsoluteSize.X * 0.4
	local n3 = 0

	for _, v in ipairs(p27) do
		if v46 <= n3 + v + buttonPadding then
			return n3
		end

		n3 += v + buttonPadding
	end

	return n3
end
function v12.getScrollToRightLocation(p28, p29) -- line: 253
	local current = p28.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = p28.props.defaultUseProps.buttonPadding
	local padOutsideEdges = p28.props.defaultUseProps.padOutsideEdges
	local v55 = current.CanvasPosition.X + current.AbsoluteSize.X * 0.4
	local v56 = -current.AbsoluteSize.X

	if padOutsideEdges then
		v56 += buttonPadding
	end

	for _, v in ipairs(p29) do
		if v55 < v56 then
			return v56
		end

		v56 += v + buttonPadding
	end

	return v56
end

return v12
