local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Object = require(scriptParentParentParent.LuauPolyfill).Object
local getScreenForRouteName = require(scriptParent.getScreenForRouteName)
local validateScreenOptions = require(scriptParent.validateScreenOptions)
local invariant = require(scriptParentParent.utils.invariant)

local function applyConfig(p1, p2, p3) -- line: 13
	-- upvalues: Object (copy)
	local v12 = p2 or {}
	local v13 = type(p1)

	if v13 == "function" then
		return Object.assign({}, v12, p1(Object.assign(table.clone(p3), {
			navigationOptions = v12
		})))
	end

	if v13 == "table" then
		return Object.assign(table.clone(v12), p1)
	end

	return v12
end

return function(p4, p5) -- line: 32
	-- upvalues: invariant (copy), getScreenForRouteName (copy), applyConfig (copy), validateScreenOptions (copy)
	return function(p6, p7) -- line: 33
		-- upvalues: invariant (copy), getScreenForRouteName (copy), p4 (copy), applyConfig (copy), p5 (copy), validateScreenOptions (copy)
		local v18 = p7 or {}
		local state = p6.state

		invariant(type(state.routeName) == "string", "Cannot get config because the route does not have a routeName.")

		local v20 = getScreenForRouteName(p4, state.routeName)
		local v21 = p4[state.routeName]
		local navigationOptions = nil

		if v21 ~= v20 then
			navigationOptions = v21.navigationOptions
		end

		local v23 = if type(v20) ~= "table" then {} else v20.navigationOptions
		local t1 = {
			navigation = p6,
			screenProps = v18
		}
		local v25 = applyConfig(p5, {}, t1)
		local v26 = applyConfig(v23, v25, t1)
		local v27 = applyConfig(navigationOptions, v26, t1)

		validateScreenOptions(v27, state)

		return v27
	end
end
