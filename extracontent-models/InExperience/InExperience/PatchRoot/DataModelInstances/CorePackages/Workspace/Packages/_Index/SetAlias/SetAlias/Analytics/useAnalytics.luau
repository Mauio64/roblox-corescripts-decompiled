local parent = script.Parent.Parent
local SetAliasAnalyticsContext = require(script.Parent.SetAliasAnalyticsContext)
local dependencies = require(parent.dependencies)
local react = dependencies.React

return function()
	return react.useContext(SetAliasAnalyticsContext)
end
