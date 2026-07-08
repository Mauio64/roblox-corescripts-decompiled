local ParentParent = script.Parent.Parent
local invariant = require(ParentParent.utils.invariant)
local isValidScreenComponent = require(ParentParent.utils.isValidScreenComponent)

local function getScreenComponent(p1) -- line: 6
	if not p1 then
		return nil
	end

	if type(p1) == "table" and p1.screen then
		return p1.screen
	end

	return p1
end

return function(p2) -- line: 36
	-- upvalues: invariant (copy), isValidScreenComponent (copy)
	invariant(next(p2) ~= nil, "Please specify at least one route when configuring a navigator.")

	for v7, v8 in p2 do
		local v9 = if v8 then if type(v8) ~= "table" or not v8.screen then v8 else v8.screen else nil
		local v10 = type(v8) == "table"

		invariant(isValidScreenComponent(v9) or v10 and type(v8.getScreen) == "function", "The component for route '%s' must be a Roact component or table with 'getScreen'. For example:\n\nlocal MyScreen = require(script.Parent.MyScreen)\n...\n%s = MyScreen,\n}\n\nYou can also use a navigator:\n\nlocal MyNavigator = require(script.Parent.MyNavigator)\n...\n%s = MyNavigator,\n}", v7, v7, v7)

		if v10 then
			invariant(v8.screen == nil or v8.getScreen == nil, "Route '%s' should declare a screen or a getScreen, not both.", v7)
		end
	end

	return p2
end
