local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")

local HttpRequestContext = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/HttpRequest/HttpRequestContext")

return function()
	return React.useContext(HttpRequestContext)
end
