local parent = script.Parent.Parent
local invariant = require(parent.utils.invariant)
local isValidScreenComponent = require(parent.utils.isValidScreenComponent)

local function getScreenComponent(item) -- 1 equivalent call inferred from this helper
	if not item then
		return nil
	end

	if type(item) == "table" and item.screen then
		return item.screen
	end

	return item
end

return function(items)
	invariant(next(items) ~= nil, "Please specify at least one route when configuring a navigator.")

	for k, item in items do
		local screenComponent = getScreenComponent(item) -- inferred equivalent call
		local v = type(item) == "table"
		invariant(
			isValidScreenComponent(screenComponent) or v and type(item.getScreen) == "function",
			"The component for route '%s' must be a Roact component or table with 'getScreen'. For example:\n\nlocal MyScreen = require(script.Parent.MyScreen)\n...\n%s = MyScreen,\n}\n\nYou can also use a navigator:\n\nlocal MyNavigator = require(script.Parent.MyNavigator)\n...\n%s = MyNavigator,\n}",
			k,
			k,
			k
		)

		if v then
			invariant(
				item.screen == nil or item.getScreen == nil,
				"Route '%s' should declare a screen or a getScreen, not both.",
				k
			)
		end
	end

	return items
end
