local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local GameDetailsContext = require(parent.GameDetailsContext)
local React = require(parent3.React)
require(parent2.gameInviteModalType)

return function(props)
	return React.createElement(GameDetailsContext.Provider, {
		value = {
			gameDetails = props.gameDetails or {},
			serverType = props.serverType or "",
			promptMessage = props.promptMessage or "",
			trigger = props.trigger or "",
			isCoreScript = props.isCoreScript or false
		}
	}, props.children)
end
