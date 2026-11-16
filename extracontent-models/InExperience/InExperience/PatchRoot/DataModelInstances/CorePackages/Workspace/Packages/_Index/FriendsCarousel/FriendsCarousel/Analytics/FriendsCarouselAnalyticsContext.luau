local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireEvent = dash.noop })
