local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")

local HttpRequestContext = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/HttpRequest/HttpRequestContext")
local DefaultHttpRequestInstance = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/HttpRequest/DefaultHttpRequestInstance")

local PlayerContextualMenuContainer = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/PlayerContextualMenuContainer")

local function PlayerContextualMenuEntrypoint(p2)
	return React.createElement(HttpRequestContext.Provider, {
		value = p2.httpRequest or DefaultHttpRequestInstance
	}, {
		app = React.createElement(PlayerContextualMenuContainer, p2)
	})
end

return PlayerContextualMenuEntrypoint
