local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Dash = dependencies.Dash

return dependencies.React.createContext({
	fireAnalyticsEvent = Dash.noop
})
