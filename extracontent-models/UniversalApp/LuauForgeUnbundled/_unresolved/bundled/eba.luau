local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/Dash")

return React.createContext({ fireEvent = Dash.noop })
