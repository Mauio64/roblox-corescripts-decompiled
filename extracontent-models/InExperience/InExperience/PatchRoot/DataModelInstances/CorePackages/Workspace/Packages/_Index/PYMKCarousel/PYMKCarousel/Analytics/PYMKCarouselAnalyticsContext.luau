local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireEvent = dash.noop })
