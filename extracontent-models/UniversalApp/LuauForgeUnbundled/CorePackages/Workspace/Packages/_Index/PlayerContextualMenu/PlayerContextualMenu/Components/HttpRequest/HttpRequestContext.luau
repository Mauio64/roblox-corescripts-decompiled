local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")

local DefaultHttpRequestInstance = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/HttpRequest/DefaultHttpRequestInstance")

return React.createContext(DefaultHttpRequestInstance)
