local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

local v = {
	new = function(...): nil
		return nil
	end
}

local v2 = {
	new = function(...): nil
		return nil
	end
}

local React = require(parent2.React)

local StyleSheet = require(parent.StyleSheet.StyleSheet)

local _ = { OS = "roblox" }

local v3 = nil

local extended = React.Component:extend("ScrollViewStickyHeader")
function extended:init(props)
	warn("ScrollViewStickyHeader not fully implemented")
	self.props = props
	self.state = {
		measured = false,
		layoutY = 0,
		layoutHeight = 0,
		nextHeaderLayoutY = self.props.nextHeaderLayoutY,
		translateY = nil
	}

	self._translateY = nil
	self._shouldRecreateTranslateY = true
	self._haveReceivedInitialZeroTranslateY = true

	self._debounceTimeout = 64

	function self.setNextHeaderY(_, nextHeaderLayoutY: number)
		self._shouldRecreateTranslateY = true
		self.setState({ nextHeaderLayoutY = nextHeaderLayoutY })
	end

	function self._onLayout(_, p)
		local y = p.nativeEvent.layout.y
		local height = p.nativeEvent.layout.height

		if y ~= self.state.layoutY or height ~= self.state.layoutHeight or self.state.measured ~= true then
			self._shouldRecreateTranslateY = true
		end

		self:setState({ measured = true, layoutY = y, layoutHeight = height })
		self.props:onLayout(p)
		local only = React.Children.only(self.props.children)

		if only.props.onLayout then
			only.props:onLayout(p)
		end
	end

	function self._setComponentRef(_, ref)
		self._ref = ref
	end
end

function extended:componentWillUnmount()
	if self._translateY ~= nil and self._animatedValueListenerId ~= nil then
		self._translateY:removeListener(self._animatedValueListenerId)
	end

	if Boolean.toJSBoolean(self._timer) then
		clearTimeout(self._timer)
	end
end

function extended:UNSAFE_componentWillReceiveProps(data)
	if
		data.scrollViewHeight ~= self.props.scrollViewHeight
		or data.scrollAnimatedValue ~= self.props.scrollAnimatedValue
		or data.inverted ~= self.props.inverted
	then
		self._shouldRecreateTranslateY = true
	end
end

function extended:updateTranslateListener(object, flag: boolean, p)
	if self._translateY ~= nil and self._animatedValueListenerId ~= nil then
		self._translateY:removeListener(self._animatedValueListenerId)
	end

	local translateY

	if Boolean.toJSBoolean(p) then
		translateY = v.new(object, p)
	else
		translateY = object
	end

	self.translateY = translateY

	self._shouldRecreateTranslateY = false

	if not flag then
		return
	end

	if not self._animatedValueListener then
		function self._animatedValueListener(p2)
			local translateY2 = p2.value

			if translateY2 == 0 and not self._haveReceivedInitialZeroTranslateY then
				self._haveReceivedInitialZeroTranslateY = true
				return
			end

			if Boolean.toJSBoolean(self._timer) then
				clearTimeout(self._timer)
			end

			self._timer = setTimeout(function()
				if translateY2 ~= self.state.translateY then
					self:setState({ translateY = translateY2 })
				end
			end, self._debounceTimeout)
		end
	end

	if self.state.translateY ~= 0 and self.state.translateY ~= nil then
		self._haveReceivedInitialZeroTranslateY = false
	end

	self._animatedValueListenerId = object:addListener(self._animatedValueListener)
end

function extended:render()
	local v4 = self._ref
		and self._ref._internalInstanceHandle
		and self._ref._internalInstanceHandle.stateNode
		and Boolean.toJSBoolean(self._ref._internalInstanceHandle.stateNode.canonical)

	if self._shouldRecreateTranslateY then
		local inverted = self.props.inverted
		local scrollViewHeight = self.props.scrollViewHeight

		local measured = self.state.measured
		local layoutHeight = self.state.layoutHeight
		local layoutY = self.state.layoutY
		local nextHeaderLayoutY = self.state.nextHeaderLayoutY
		local inputRange = { -1, 0 }
		local outputRange = { 0, 0 }

		if measured then
			if inverted then
				if scrollViewHeight ~= nil then
					local v5 = layoutY + layoutHeight - scrollViewHeight

					if v5 > 0 then
						table.insert(inputRange, v5)
						table.insert(outputRange, 0)
						table.insert(inputRange, v5 + 1)
						table.insert(outputRange, 1)

						local v6 = (nextHeaderLayoutY or 0) - layoutHeight - scrollViewHeight

						if v5 < v6 then
							table.insert(inputRange, v6)
							table.insert(inputRange, v6 + 1)
							table.insert(outputRange, v6 - v5)
							table.insert(outputRange, v6 - v5)
						end
					end
				end
			else
				table.insert(inputRange, layoutY)
				table.insert(outputRange, 0)

				local v5 = (nextHeaderLayoutY or 0) - layoutHeight

				if layoutY <= v5 then
					table.insert(inputRange, v5)
					table.insert(inputRange, v5 + 1)
					table.insert(outputRange, v5 - layoutY)
					table.insert(outputRange, v5 - layoutY)
				else
					table.insert(inputRange, layoutY + 1)
					table.insert(outputRange, 1)
				end
			end
		end

		local interpolated = self.props.scrollAnimatedValue:interpolate({
			inputRange = inputRange,
			outputRange = outputRange
		})
		local v5

		if self.props.hiddenOnScroll then
			v5 = v2.new(self.props.scrollAnimatedValue:interpolate({
				extrapolateLeft = "clamp",
				inputRange = { layoutY, layoutY + 1 },
				outputRange = { 0, 1 }
			}):interpolate({
				inputRange = { 0, 1 },
				outputRange = { 0, -1 }
			}), -self.state.layoutHeight, 0)
		end

		self:updateTranslateListener(interpolated, v4, v5)
	end

	local only = React.Children.only(self.props.children)

	local passthroughAnimatedPropExplicitValues = v4 and self.state.translateY ~= nil and {
		style = {
			transform = {
				{ translateY = self.state.translateY }
			}
		}
	} or nil

	return React.createElement("AnimatedView", {
		collapsable = false,
		nativeID = self.props.nativeID,
		onLayout = self._onLayout,
		ref = self._setComponentRef,
		style = {
			only.props.style,
			v3.header,
			{
				transform = {
					{ translateY = self._translateY }
				}
			}
		},
		passthroughAnimatedPropExplicitValues = passthroughAnimatedPropExplicitValues
	}, React.cloneElement(only, { style = v3.fill, onLayout = nil }))
end

v3 = StyleSheet.create({
	header = { zIndex = 10, position = "relative" },
	fill = { flex = 1 }
})

return extended
