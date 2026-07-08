local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local lerp = require(ParentParent.utils.lerp)
local v5 = React.Component:extend("StackViewOverlayFrame")

function v5.init(p1) -- line: 10
	-- upvalues: React (copy)
	p1._signalDisconnect = nil
	p1._ref = React.createRef()
end
function v5.render(p2) -- line: 16
	-- upvalues: lerp (copy), React (copy)
	local navigationOptions = p2.props.navigationOptions
	local initialTransitionValue = p2.props.initialTransitionValue
	local v10 = lerp(1, navigationOptions.overlayTransparency, initialTransitionValue)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = navigationOptions.overlayColor3,
		BackgroundTransparency = v10,
		ref = p2._ref
	})
end
function v5.didUpdate(p3, p4) -- line: 31
	local transitionChangedSignal = p3.props.transitionChangedSignal

	if transitionChangedSignal ~= p4.transitionChangedSignal then
		if p3._signalDisconnect then
			p3._signalDisconnect()
		end

		p3._signalDisconnect = transitionChangedSignal(function(...) -- line: 39
			-- upvalues: p3 (copy)
			p3:_transitionChanged(...)
		end)
	end
end
function v5.didMount(p5) -- line: 45
	p5._isMounted = true
	p5._signalDisconnect = p5.props.transitionChangedSignal(function(...) -- line: 47
		-- upvalues: p5 (copy)
		p5:_transitionChanged(...)
	end)
end
function v5.willUnmount(p6) -- line: 52
	p6._isMounted = false

	if p6._signalDisconnect then
		p6._signalDisconnect()
		p6._signalDisconnect = nil
	end
end
function v5._transitionChanged(p7, p8) -- line: 60
	-- upvalues: lerp (copy)
	if not p7._isMounted then
		return
	end

	if p7._ref.current then
		local navigationOptions = p7.props.navigationOptions
		local v19 = lerp(1, navigationOptions.overlayTransparency, p8)

		p7._ref.current.BackgroundTransparency = v19
	end
end

return v5
