local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies")
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireAnalyticsEvent = dash.noop })
