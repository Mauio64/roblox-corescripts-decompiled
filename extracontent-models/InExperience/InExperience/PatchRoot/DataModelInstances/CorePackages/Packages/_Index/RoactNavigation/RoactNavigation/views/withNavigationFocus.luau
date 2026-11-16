local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local React = require(parent3.React)
local Events = require(parent2.Events)
local withNavigation = require(parent.withNavigation)

local function isComponent(p): boolean -- 1 equivalent call inferred from this helper
	local typeName = type(p)
	return typeName == "function" or typeName == "table"
end

return function(p)
	assert(isComponent(p), "withNavigationFocus must be called with a Roact component (stateful or functional)") -- inferred equivalent call
	local extended = React.Component:extend("NavigationFocusComponent")

	function extended:init()
		self.state = {
			isFocused = self.props.navigation.isFocused()
		}
	end

	function extended:didMount()
		local navigation = self.props.navigation

		self.subscriptions = {
			navigation.addListener(Events.WillFocus, function()
				self:setState({ isFocused = true })
			end),
			navigation.addListener(Events.WillBlur, function()
				self:setState({ isFocused = false })
			end)
		}
	end

	function extended.willUnmount(p2)
		for _, subscription in p2.subscriptions do
			subscription.remove()
		end
	end

	function extended.render(p2)
		return React.createElement(p, Object.assign(table.clone(p2.props), {
			isFocused = p2.state.isFocused
		}))
	end

	return withNavigation(extended, { forwardRef = false })
end
