local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Object = require(scriptParentParentParent.LuauPolyfill).Object
local React = require(scriptParentParentParent.React)
local NavigationContext = require(scriptParent.NavigationContext)
local invariant = require(scriptParentParent.utils.invariant)

local function isComponent(p1) -- line: 11
	local v10 = type(p1)

	return v10 == "function" or v10 == "table"
end

return function(p2, t1: {[any]: any}?) -- line: 35
	-- upvalues: Object (copy), React (copy), NavigationContext (copy), invariant (copy)
	local v13 = type(p2)

	assert(v13 == "function" or v13 == "table", "withNavigation must be called with a Roact component (stateful or functional)")

	local v14 = Object.assign({
		forwardRef = true
	}, t1)

	return function(p3) -- line: 39
		-- upvalues: React (copy), NavigationContext (copy), invariant (copy), p2 (copy), Object (copy), v14 (copy)
		local navigation = p3.navigation

		return React.createElement(NavigationContext.Consumer, {
			render = function(p4) -- line: 42
				-- upvalues: navigation (copy), invariant (copy), React (copy), p2 (copy), Object (copy), p3 (copy), v14 (copy)
				local v18 = navigation or p4

				invariant(v18, "withNavigation and withNavigationFocus can only be used on a view hierarchy of a navigator. The wrapped component is unable to get access to navigation from props or context.")

				return React.createElement(p2, Object.assign(table.clone(p3), {
					navigation = v18,
					ref = if not v14.forwardRef then Object.None else p3.onRef
				}))
			end
		})
	end
end
