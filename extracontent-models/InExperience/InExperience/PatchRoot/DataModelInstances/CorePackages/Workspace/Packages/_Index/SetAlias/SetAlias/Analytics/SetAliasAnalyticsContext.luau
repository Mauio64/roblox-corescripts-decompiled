local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local dash = dependencies.Dash
return dependencies.React.createContext({ fireAnalyticsEvent = dash.noop })
