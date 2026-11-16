local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local React = require(parent3.React)
local NavigationContext = require(parent.NavigationContext)
local invariant = require(parent2.utils.invariant)

local function isComponent(p): boolean -- 1 equivalent call inferred from this helper
	local typeName = type(p)
	return typeName == "function" or typeName == "table"
end

return function(p, p2)
	assert(isComponent(p), "withNavigation must be called with a Roact component (stateful or functional)") -- inferred equivalent call
	local v = Object.assign({ forwardRef = true }, p2)

	return function(p3)
		local navigation = p3.navigation
		return React.createElement(NavigationContext.Consumer, {
			render = function(p4)
				local navigation2 = navigation or p4
				invariant(
					navigation2,
					"withNavigation and withNavigationFocus can only be used on a view hierarchy of a navigator. The wrapped component is unable to get access to navigation from props or context."
				)

				local createElement = React.createElement

				local assign = Object.assign
				local clone = table.clone(p3)
				local ref

				if v.forwardRef then
					ref = p3.onRef
				else
					ref = Object.None
				end

				return createElement(p, assign(clone, { navigation = navigation2, ref = ref }))
			end
		})
	end
end
