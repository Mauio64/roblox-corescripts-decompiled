local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local useLayoutValues = require(CorePackages.Workspace.Packages.PlayerList).Common.useLayoutValues
local Connection = script.Parent.Parent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local DropDownButton = require(script.Parent.DropDownButton)
local t1 = {
	dampingRatio = 1,
	frequency = 4
}
local t2 = {
	dampingRatio = 1,
	frequency = 4
}
local v12 = Roact.PureComponent:extend("DropDownAnimator")

v12.validateProps = t.strictInterface({
	text = t.string,
	icon = t.union(t.string, t.table),
	lastButton = t.boolean,
	layoutOrder = t.integer,
	onActivated = t.callback,
	forceShowOptions = t.boolean,
	selectedPlayer = t.optional(t.instanceIsA("Player")),
	onDecline = t.optional(t.callback),
	onDismiss = t.optional(t.callback),
	contentVisible = t.boolean,
	layoutValues = t.optional(t.table),
	onAnimationComplete = t.optional(t.callback),
	forwardRef = t.optional(t.callback)
})

function v12.init(p1) -- line: 46
	-- upvalues: Roact (copy), Otter (copy), t1 (copy)
	p1.state = {
		lastButtonProps = nil,
		onDeclineCalled = nil,
		onActivatedCalled = nil,
		overlayPercentage = 0
	}

	local v14, v15 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p1.currentButtonPosition = v14
	p1.updateCurrentButtonPosition = v15

	local v16, v17 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p1.lastButtonPosition = v16
	p1.updateLastButtonPosition = v17
	p1.positionMotor = Otter.createSingleMotor(0)
	p1.positionMotor:onStep(function(p2) -- line: 58
		-- upvalues: p1 (copy)
		p1.updateCurrentButtonPosition(UDim2.new(p2, 0, 0, 0))

		if p1.animatingRight then
			p1.updateLastButtonPosition(UDim2.new(p2 + 1, 0, 0, 0))

			return
		end

		p1.updateLastButtonPosition(UDim2.new(p2 - 1, 0, 0, 0))
	end)
	p1.positionMotor:onComplete(function(p3) -- line: 66
		-- upvalues: p1 (copy), Roact (copy)
		if p3 == 0 then
			p1:setState({
				lastButtonProps = Roact.None,
				onDeclineCalled = Roact.None,
				onActivatedCalled = Roact.None
			})
		end
	end)
	p1.overlayMotor = Otter.createSingleMotor(0)
	p1.overlayMotor:onStep(function(p4) -- line: 77
		-- upvalues: p1 (copy)
		p1:setState({
			overlayPercentage = p4
		})
	end)
	p1.overlayMotor:onComplete(function(p5) -- line: 82
		-- upvalues: p1 (copy), Otter (copy), t1 (copy)
		if p5 == 1 then
			p1.positionMotor:setGoal(Otter.spring(0, t1))
		end
	end)
end
function v12.getButtonProps(p6, p7, p8) -- line: 89
	local t3 = {
		text = p7.text,
		icon = p7.icon,
		lastButton = p7.lastButton,
		forceShowOptions = p7.forceShowOptions,
		onDismiss = p7.onDismiss
	}

	if p6.state.lastButtonProps ~= nil then
		if p8 then
			t3.animatingAccept = p6.state.onActivatedCalled
			t3.animatingDecline = p6.state.onDeclineCalled
			t3.animatingPercentage = p6.state.overlayPercentage

			return t3
		end
	else
		if p7.onActivated and (p7.onDecline or p6.props.forceShowOptions) then
			function t3.onActivated() -- line: 106
				-- upvalues: p6 (copy), p7 (copy)
				p6:setState({
					onActivatedCalled = true,
					onDeclineCalled = false
				})
				p7.onActivated()
			end
		elseif p7.onActivated then
			t3.onActivated = p7.onActivated
		end

		if p7.onDecline then
			function t3.onDecline() -- line: 117
				-- upvalues: p6 (copy), p7 (copy)
				p6:setState({
					onActivatedCalled = false,
					onDeclineCalled = true
				})
				p7.onDecline()
			end
		end
	end

	return t3
end
function v12.render(p9) -- line: 130
	-- upvalues: WithLayoutValues (copy), Roact (copy), DropDownButton (copy)
	return WithLayoutValues(function(_) -- line: 131
		-- upvalues: p9 (copy), Roact (copy), DropDownButton (copy)
		local layoutValues = p9.props.layoutValues
		local t4 = {
			CurrentButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = p9.currentButtonPosition
			}, {
				DropDownButton = Roact.createElement(DropDownButton, p9:getButtonProps(p9.props))
			})
		}

		if p9.state.lastButtonProps then
			t4.LastButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = p9.lastButtonPosition
			}, {
				DropDownButton = Roact.createElement(DropDownButton, p9:getButtonProps(p9.state.lastButtonProps, true))
			})
		end

		return Roact.createElement("Frame", {
			Visible = p9.props.contentVisible,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, layoutValues.DropDownButtonSizeY),
			BackgroundTransparency = 1,
			LayoutOrder = p9.props.layoutOrder,
			[Roact.Ref] = p9.props.forwardRef
		}, t4)
	end)
end
function v12.didUpdate(p11, p12, p13) -- line: 167
	-- upvalues: Otter (copy), t2 (copy), Roact (copy)
	local v26 = p11.props.text ~= p12.text
	local v27 = p12.onDecline ~= nil or p11.props.forceShowOptions
	local v28 = p11.state.onDeclineCalled or p11.state.onActivatedCalled
	local v29 = p11.state.lastButtonProps == nil and p13.lastButtonProps ~= nil

	if v26 and (v27 and v28) then
		if p11.state.onActivatedCalled and not p11.props.forceShowOptions then
			p11.animatingRight = true
			p11.positionMotor:setGoal(Otter.instant(-1))
		else
			p11.animatingRight = false
			p11.positionMotor:setGoal(Otter.instant(1))
		end

		p11.overlayMotor:setGoal(Otter.instant(0))
		p11.positionMotor:step(0)
		p11.overlayMotor:step(0)
		p11:setState({
			lastButtonProps = p12
		})
		p11.overlayMotor:setGoal(Otter.spring(1, t2))
	end

	if v29 and p11.props.onAnimationComplete then
		p11.props.onAnimationComplete()
	end

	if p11.props.selectedPlayer ~= p12.selectedPlayer then
		p11.positionMotor:setGoal(Otter.instant(0))
		p11.overlayMotor:setGoal(Otter.instant(0))
		p11.positionMotor:step(0)
		p11.overlayMotor:step(0)
		p11:setState({
			lastButtonProps = Roact.None
		})
	end
end
function v12.willUnmount(p14) -- line: 209
	p14.positionMotor:destroy()
	p14.positionMotor = nil
	p14.overlayMotor:destroy()
	p14.overlayMotor = nil
end

return function(p15) -- line: 216
	-- upvalues: useLayoutValues (copy), Roact (copy), v12 (copy), Cryo (copy)
	local v32 = useLayoutValues()

	return Roact.createElement(v12, Cryo.Dictionary.join(p15, {
		layoutValues = v32
	}))
end
