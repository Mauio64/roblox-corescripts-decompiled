local dependencies = require(script.Parent.Parent.Parent.dependencies)
local roact = dependencies.Roact
local roactNavigation = dependencies.RoactNavigation

local v = {
	state = { params = {}, routeName = "", key = "" },
	dispatch = function() end,
	goBack = function() end,
	addListener = function() end,
	isFocused = function() end,
	setParams = function() end,
	getParam = function() end
}

return function(element)
	return roact.createElement(roactNavigation.Provider, { value = v }, { Element = element })
end
