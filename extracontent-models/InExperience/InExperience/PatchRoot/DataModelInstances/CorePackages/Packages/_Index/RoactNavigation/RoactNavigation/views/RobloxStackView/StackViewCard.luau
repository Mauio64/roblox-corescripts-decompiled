local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local invariant = require(ParentParent.utils.invariant)
local v5 = React.Component:extend("StackViewCard")

function v5.init(p1) -- line: 29
	-- upvalues: React (copy)
	local index = p1.props.navigation.state.index

	p1._isMounted = false
	p1._positionLastValue = index
	p1._ref = React.createRef()
end
function v5.render(p2) -- line: 38
	-- upvalues: invariant (copy), React (copy)
	local forceHidden = p2.props.forceHidden
	local cardColor3 = p2.props.cardColor3
	local initialPosition = p2.props.initialPosition
	local renderScene = p2.props.renderScene
	local scene = p2.props.scene

	invariant(type(renderScene) == "function", "renderScene must be a function")

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Position = initialPosition,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = cardColor3,
		BackgroundTransparency = if cardColor3 ~= nil then nil else 1,
		Visible = not forceHidden,
		ref = p2._ref
	}, {
		Content = renderScene(scene)
	})
end
function v5.didMount(p3) -- line: 61
	p3._isMounted = true
	p3._positionDisconnector = p3.props.position:onStep(function(...) -- line: 65
		-- upvalues: p3 (copy)
		p3:_onPositionStep(...)
	end)
end
function v5.willUnmount(p4) -- line: 70
	p4._isMounted = false

	if p4._positionDisconnector then
		p4._positionDisconnector()
		p4._positionDisconnector = nil
	end
end
function v5.didUpdate(p5, p6) -- line: 79
	local position = p5.props.position
	local positionStep = p5.props.positionStep

	if position ~= p6.position then
		p5._positionDisconnector()
		p5._positionDisconnector = position:onStep(function(...) -- line: 85
			-- upvalues: p5 (copy)
			p5:_onPositionStep(...)
		end)
	end

	if positionStep ~= p6.positionStep then
		p5:_onPositionStep(p5._positionLastValue)
	end
end
function v5._onPositionStep(p7, p8) -- line: 97
	if not p7._isMounted then
		return
	end

	local positionStep = p7.props.positionStep

	if positionStep then
		positionStep(p7._ref, p8)
	end

	p7._positionLastValue = p8
end

return v5
