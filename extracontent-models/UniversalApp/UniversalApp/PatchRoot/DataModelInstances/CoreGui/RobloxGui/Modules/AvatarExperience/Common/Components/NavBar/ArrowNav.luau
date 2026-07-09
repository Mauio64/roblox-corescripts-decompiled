local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Otter = require(CorePackages.Packages.Otter)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.AvatarExperience.Common.Constants)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v13 = Roact.PureComponent:extend("ArrowNav")

v13.validateProps = t.intersection(t.strictInterface({
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
}), function(p1) -- line: 53
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
v13.defaultProps = {
	Visible = true,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0)
}

function v13.init(p2) -- line: 87
	-- upvalues: RunService (copy), Constants (copy), Otter (copy)
	p2.holdConn = nil
	p2.timeOfInputBegan = 0

	function p2.handleInputBegan(_, p4) -- line: 91
		-- upvalues: p2 (copy);
		(p2.props.onPressHoldInputBegan or p2.onPressHoldInputBegan)(p4, p2.props.navDirection)
	end
	function p2.handleInputEnded(_, p6) -- line: 96
		-- upvalues: p2 (copy);
		(p2.props.onPressHoldInputEnded or p2.onPressHoldInputEnded)(p6, p2.props.navDirection)
	end
	function p2.getNewCanvasPosition(n1: number) -- line: 101
		-- upvalues: p2 (copy)
		return p2.props.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(n1, 0)
	end
	function p2.disconnectHoldConn() -- line: 106
		-- upvalues: p2 (copy)
		if p2.holdConn == nil then
			return
		end

		p2.holdConn:Disconnect()
		p2.holdConn = nil
	end
	function p2.onPressHoldInputBegan(p7, p8) -- line: 114
		-- upvalues: p2 (copy), RunService (copy), Constants (copy)
		if p7.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		p2.timeOfInputBegan = tick()
		p2.disconnectHoldConn()
		p2.holdConn = RunService.RenderStepped:connect(function(p9) -- line: 120
			-- upvalues: p2 (copy), Constants (copy), p8 (copy)
			local v56 = tick() - p2.timeOfInputBegan
			local v57 = Constants.NavigationDirection.IS_LEFT ~= p8 and 1 or -1
			local v58 = p2.getNewCanvasPosition(v57 * 500 * p9 * v56 ^ 2)

			p2.props.defaultUseProps.updateCanvasPosition(v58)
		end)
	end
	function p2.onPressHoldInputEnded(p10, p11) -- line: 129
		-- upvalues: p2 (copy), Otter (copy)
		if p10.UserInputState ~= Enum.UserInputState.End then
			return
		end

		local current = p2.props.defaultUseProps.scrollingFrameRef.current

		if tick() - p2.timeOfInputBegan <= 0.5 then
			if p2.motor then
				p2.motor:destroy()
			end

			p2:setMotor(current.CanvasPosition.X)
			p2.motor:setGoal(p2:getGoal(p11))
		else
			p2.motor:setGoal(Otter.instant(current.CanvasPosition.X))
		end

		p2.disconnectHoldConn()
	end
end
function v13.getGoal(p12, p13) -- line: 148
	-- upvalues: Otter (copy), t1 (copy)
	return Otter.spring(p12:getScrollToLocation(p13), t1)
end
function v13.didMount(p14) -- line: 152
	p14:setMotor(0)
end
function v13.setMotor(t2: {[any]: any}, n2: number) -- line: 156
	-- upvalues: Otter (copy)
	t2.motor = Otter.createSingleMotor(n2)
	t2.motor:onStep(function(p15) -- line: 158
		-- upvalues: t2 (copy)
		t2.props.defaultUseProps.updateCanvasPosition(Vector2.new(p15, 0))
	end)
	t2.motor:onComplete(function(p16) -- line: 161
		-- upvalues: t2 (copy)
		t2.props.defaultUseProps.updateCanvasPosition(Vector2.new(p16, 0))
	end)
end
function v13.render(p17) -- line: 166
	-- upvalues: withStyle (copy), Roact (copy), ImageSetButton (copy)
	return withStyle(function(p18) -- line: 167
		-- upvalues: Roact (copy), ImageSetButton (copy), p17 (copy)
		local Theme = p18.Theme

		return Roact.createElement(ImageSetButton, {
			AnchorPoint = p17.props.AnchorPoint,
			Position = p17.props.Position,
			Image = p17.props.Image,
			Visible = p17.props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = Theme.IconEmphasis.Color,
			Size = UDim2.fromOffset(36, 36),
			[Roact.Event.InputBegan] = p17.handleInputBegan,
			[Roact.Event.InputEnded] = p17.handleInputEnded
		})
	end)
end
function v13.willUnmount(p19) -- line: 183
	p19.disconnectHoldConn()

	if p19.motor then
		p19.motor:destroy()
		p19.motor = nil
	end
end
function v13.getScrollToLocation(p20, p21) -- line: 191
	-- upvalues: Constants (copy)
	local current = p20.props.defaultUseProps.scrollingFrameRef.current
	local buttonPadding = p20.props.defaultUseProps.buttonPadding
	local t3 = {}
	local buttonRefs = p20.props.defaultUseProps.buttonRefs
	local buttonWidth = p20.props.defaultUseProps.buttonWidth
	local numButtons = p20.props.defaultUseProps.numButtons
	local padOutsideEdges = p20.props.defaultUseProps.padOutsideEdges

	if buttonWidth and numButtons then
		t3 = table.create(numButtons, buttonWidth)
	else
		for _, v33 in buttonRefs do
			table.insert(t3, v33.current and v33.current.Size.X.Offset or 0)
		end
	end

	local n3 = 0

	if p21 == Constants.NavigationDirection.IS_LEFT then
		local v35 = current.CanvasPosition.X - current.AbsoluteSize.X * 0.4

		for _, v37 in t3 do
			if not (v35 > n3 + v37 + buttonPadding) then
				return n3
			end

			n3 = n3 + v37 + buttonPadding
		end

		return n3
	end

	local v38 = current.CanvasPosition.X + current.AbsoluteSize.X * 0.4

	n3 = -current.AbsoluteSize.X

	if padOutsideEdges then
		n3 += buttonPadding
	end

	for _, v40 in t3 do
		if v38 < n3 then
			return n3
		end

		n3 = n3 + v40 + buttonPadding
	end

	return n3
end

return v13
