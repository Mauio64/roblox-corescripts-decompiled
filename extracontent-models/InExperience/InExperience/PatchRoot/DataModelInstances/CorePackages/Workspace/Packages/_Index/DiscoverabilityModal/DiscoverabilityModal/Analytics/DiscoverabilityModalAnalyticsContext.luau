local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireAnalyticsEvent = dash.noop })
