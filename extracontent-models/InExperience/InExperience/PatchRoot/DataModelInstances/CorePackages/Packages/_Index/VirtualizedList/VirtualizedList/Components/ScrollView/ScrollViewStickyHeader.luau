local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local t1 = {
	new = function(...) -- line: 29
		return nil
	end
}
local t2 = {
	new = function(...) -- line: 35
		return nil
	end
}
local React = require(ParentParentParent.React)
local StyleSheet = require(ParentParent.StyleSheet.StyleSheet)
local _ = {
	OS = "roblox"
}
local u12 = nil
local v13 = React.Component:extend("ScrollViewStickyHeader")

function v13.init(p1, p2) -- line: 108
	-- upvalues: React (copy)
	warn("ScrollViewStickyHeader not fully implemented")
	p1.props = p2
	p1.state = {
		measured = false,
		layoutY = 0,
		layoutHeight = 0,
		translateY = nil,
		nextHeaderLayoutY = p1.props.nextHeaderLayoutY
	}
	p1._translateY = nil
	p1._shouldRecreateTranslateY = true
	p1._haveReceivedInitialZeroTranslateY = true
	p1._debounceTimeout = 64

	function p1.setNextHeaderY(_, n1: number) -- line: 130
		-- upvalues: p1 (copy)
		p1._shouldRecreateTranslateY = true
		p1.setState({
			nextHeaderLayoutY = n1
		})
	end
	function p1._onLayout(_, p5) -- line: 135
		-- upvalues: p1 (copy), React (copy)
		local y = p5.nativeEvent.layout.y
		local height = p5.nativeEvent.layout.height

		if y ~= p1.state.layoutY or (height ~= p1.state.layoutHeight or p1.state.measured ~= true) then
			p1._shouldRecreateTranslateY = true
		end

		p1:setState({
			measured = true,
			layoutY = y,
			layoutHeight = height
		})
		p1.props:onLayout(p5)

		local v44 = React.Children.only(p1.props.children)

		if v44.props.onLayout then
			v44.props:onLayout(p5)
		end
	end
	function p1._setComponentRef(_, p7) -- line: 154
		-- upvalues: p1 (copy)
		p1._ref = p7
	end
end
function v13.componentWillUnmount(p8) -- line: 159
	-- upvalues: Boolean (copy), clearTimeout (copy)
	if p8._translateY ~= nil and p8._animatedValueListenerId ~= nil then
		p8._translateY:removeListener(p8._animatedValueListenerId)
	end

	if Boolean.toJSBoolean(p8._timer) then
		clearTimeout(p8._timer)
	end
end
function v13.UNSAFE_componentWillReceiveProps(p9, p10) -- line: 168
	if p10.scrollViewHeight ~= p9.props.scrollViewHeight or (p10.scrollAnimatedValue ~= p9.props.scrollAnimatedValue or p10.inverted ~= p9.props.inverted) then
		p9._shouldRecreateTranslateY = true
	end
end
function v13.updateTranslateListener(t3: {[any]: any}, p11, b1: boolean, p12) -- line: 178
	-- upvalues: Boolean (copy), t1 (copy), clearTimeout (copy), setTimeout (copy)
	if t3._translateY ~= nil and t3._animatedValueListenerId ~= nil then
		t3._translateY:removeListener(t3._animatedValueListenerId)
	end

	t3.translateY = if not Boolean.toJSBoolean(p12) then p11 else t1.new(p11, p12)
	t3._shouldRecreateTranslateY = false

	if not b1 then
		return
	end

	if not t3._animatedValueListener then
		function t3._animatedValueListener(p13) -- line: 209
			-- upvalues: t3 (copy), Boolean (copy), clearTimeout (copy), setTimeout (copy)
			local value = p13.value

			if value == 0 and not t3._haveReceivedInitialZeroTranslateY then
				t3._haveReceivedInitialZeroTranslateY = true

				return
			end

			if Boolean.toJSBoolean(t3._timer) then
				clearTimeout(t3._timer)
			end

			t3._timer = setTimeout(function() -- line: 220
				-- upvalues: value (copy), t3 (copy)
				if value ~= t3.state.translateY then
					t3:setState({
						translateY = value
					})
				end
			end, t3._debounceTimeout)
		end
	end

	if t3.state.translateY ~= 0 and t3.state.translateY ~= nil then
		t3._haveReceivedInitialZeroTranslateY = false
	end

	t3._animatedValueListenerId = p11:addListener(t3._animatedValueListener)
end
function v13.render(p14) -- line: 233
	-- upvalues: Boolean (copy), t2 (copy), React (copy), u12 (ref)
	local v24 = p14._ref and (p14._ref._internalInstanceHandle and (p14._ref._internalInstanceHandle.stateNode and Boolean.toJSBoolean(p14._ref._internalInstanceHandle.stateNode.canonical)))

	if p14._shouldRecreateTranslateY then
		local inverted = p14.props.inverted
		local scrollViewHeight = p14.props.scrollViewHeight
		local measured = p14.state.measured
		local layoutHeight = p14.state.layoutHeight
		local layoutY = p14.state.layoutY
		local nextHeaderLayoutY = p14.state.nextHeaderLayoutY
		local t4 = {
			-1,
			0
		}
		local t5 = {
			0,
			0
		}

		if measured then
			if inverted then
				if scrollViewHeight ~= nil then
					local v33 = layoutY + layoutHeight - scrollViewHeight

					if v33 > 0 then
						table.insert(t4, v33)
						table.insert(t5, 0)
						table.insert(t4, v33 + 1)
						table.insert(t5, 1)

						local v34 = (nextHeaderLayoutY or 0) - layoutHeight - scrollViewHeight

						if v33 < v34 then
							table.insert(t4, v34)
							table.insert(t4, v34 + 1)
							table.insert(t5, v34 - v33)
							table.insert(t5, v34 - v33)
						end
					end
				end
			else
				table.insert(t4, layoutY)
				table.insert(t5, 0)

				local v35 = (nextHeaderLayoutY or 0) - layoutHeight

				if layoutY <= v35 then
					table.insert(t4, v35)
					table.insert(t4, v35 + 1)
					table.insert(t5, v35 - layoutY)
					table.insert(t5, v35 - layoutY)
				else
					table.insert(t4, layoutY + 1)
					table.insert(t5, 1)
				end
			end
		end

		p14:updateTranslateListener(p14.props.scrollAnimatedValue:interpolate({
			inputRange = t4,
			outputRange = t5
		}), v24, if not p14.props.hiddenOnScroll then nil else t2.new(p14.props.scrollAnimatedValue:interpolate({
			extrapolateLeft = "clamp",
			inputRange = {
				layoutY,
				layoutY + 1
			},
			outputRange = {
				0,
				1
			}
		}):interpolate({
			inputRange = {
				0,
				1
			},
			outputRange = {
				0,
				-1
			}
		}), -p14.state.layoutHeight, 0))
	end

	local v36 = React.Children.only(p14.props.children)
	local v37 = if not v24 or p14.state.translateY == nil then nil else {
		style = {
			transform = {{
				translateY = p14.state.translateY
			}}
		}
	}

	return React.createElement("AnimatedView", {
		collapsable = false,
		nativeID = p14.props.nativeID,
		onLayout = p14._onLayout,
		ref = p14._setComponentRef,
		style = {
			v36.props.style,
			u12.header,
			{
				transform = {{
					translateY = p14._translateY
				}}
			}
		},
		passthroughAnimatedPropExplicitValues = v37
	}, React.cloneElement(v36, {
		onLayout = nil,
		style = u12.fill
	}))
end

u12 = StyleSheet.create({
	header = {
		zIndex = 10,
		position = "relative"
	},
	fill = {
		flex = 1
	}
})

return v13
