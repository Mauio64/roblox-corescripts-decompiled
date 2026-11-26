local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireEvent = dash.noop })
