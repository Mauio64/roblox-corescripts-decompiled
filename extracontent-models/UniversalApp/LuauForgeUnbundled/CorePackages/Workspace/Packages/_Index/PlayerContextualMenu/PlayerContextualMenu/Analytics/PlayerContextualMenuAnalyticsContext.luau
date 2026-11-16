local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Dash")

return React.createContext({ fireEvent = Dash.noop })
