local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Roact = dependencies.Roact
local Dash = dependencies.Dash

return Roact.createContext({
	fireAnalyticsEvent = Dash.noop
})
