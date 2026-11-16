local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(parent.React)
local Dash = require(parent.Dash)

return React.createContext({ fireEvent = Dash.noop })
