local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")
local dash = dependencies.Dash
return dependencies.React.createContext({ fireAnalyticsEvent = dash.noop })
