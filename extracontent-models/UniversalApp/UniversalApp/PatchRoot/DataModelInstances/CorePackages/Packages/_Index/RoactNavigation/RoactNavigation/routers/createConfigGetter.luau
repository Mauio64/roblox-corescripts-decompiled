local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object

local getScreenForRouteName = require(parent.getScreenForRouteName)
local validateScreenOptions = require(parent.validateScreenOptions)
local invariant = require(parent2.utils.invariant)

local function applyConfig(callback, options, p)
	local navigationOptions = options or {}

	local typeName = type(callback)

	if typeName == "function" then
		return Object.assign(
			{},
			navigationOptions,
			callback(Object.assign(table.clone(p), { navigationOptions = navigationOptions }))
		)
	elseif typeName == "table" then
		return Object.assign(table.clone(navigationOptions), callback)
	end

	return navigationOptions
end

return function(p, p2)
	return function(navigation, options)
		local state = navigation.state

		invariant(type(state.routeName) == "string", "Cannot get config because the route does not have a routeName.")

		local screenForRouteName = getScreenForRouteName(p, state.routeName)
		local v = p[state.routeName]
		local navigationOptions

		if v ~= screenForRouteName then
			navigationOptions = v.navigationOptions
		end

		local v2 = {
			navigation = navigation,
			screenProps = options or {}
		}
		local v3 = applyConfig(
			navigationOptions,
			applyConfig(
				type(screenForRouteName) ~= "table" and {} or screenForRouteName.navigationOptions,
				applyConfig(p2, {}, v2),
				v2
			),
			v2
		)

		validateScreenOptions(v3, state)
		return v3
	end
end
