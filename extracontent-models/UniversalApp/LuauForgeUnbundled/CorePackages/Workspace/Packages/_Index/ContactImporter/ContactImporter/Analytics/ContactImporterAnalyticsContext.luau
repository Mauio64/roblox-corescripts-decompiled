local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireAnalyticsEvent = dash.noop })
