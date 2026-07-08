local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Object = require(scriptParentParentParent.LuauPolyfill).Object
local React = require(scriptParentParentParent.React)
local Events = require(scriptParentParent.Events)
local withNavigation = require(scriptParent.withNavigation)

local function isComponent(p1) -- line: 12
	local v10 = type(p1)

	return v10 == "function" or v10 == "table"
end

return function(p2) -- line: 17
	-- upvalues: React (copy), Events (copy), Object (copy), withNavigation (copy)
	local v12 = type(p2)

	assert(v12 == "function" or v12 == "table", "withNavigationFocus must be called with a Roact component (stateful or functional)")

	local v13 = React.Component:extend("NavigationFocusComponent")

	function v13.init(p3) -- line: 21
		p3.state = {
			isFocused = p3.props.navigation.isFocused()
		}
	end
	function v13.didMount(p4) -- line: 27
		-- upvalues: Events (copy)
		local navigation = p4.props.navigation

		p4.subscriptions = {
			navigation.addListener(Events.WillFocus, function() -- line: 31
				-- upvalues: p4 (copy)
				p4:setState({
					isFocused = true
				})
			end),
			navigation.addListener(Events.WillBlur, function() -- line: 37
				-- upvalues: p4 (copy)
				p4:setState({
					isFocused = false
				})
			end)
		}
	end
	function v13.willUnmount(p5) -- line: 46
		for _, v19 in p5.subscriptions do
			v19.remove()
		end
	end
	function v13.render(p6) -- line: 52
		-- upvalues: React (copy), p2 (copy), Object (copy)
		return React.createElement(p2, Object.assign(table.clone(p6.props), {
			isFocused = p6.state.isFocused
		}))
	end

	return withNavigation(v13, {
		forwardRef = false
	})
end
