local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local GameDetailsContext = require(scriptParent.GameDetailsContext)
local React = require(scriptParentParentParent.React)

require(scriptParentParent.gameInviteModalType)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), GameDetailsContext (copy)
	return React.createElement(GameDetailsContext.Provider, {
		value = {
			gameDetails = t1.gameDetails or {},
			serverType = t1.serverType or "",
			promptMessage = t1.promptMessage or "",
			trigger = t1.trigger or "",
			isCoreScript = t1.isCoreScript or false
		}
	}, t1.children)
end
