local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local ParentContainerContext = require(script.Parent.ParentContainerContext)

local function ParentContainerProvider(p1) -- line: 11
	-- upvalues: React (copy), ParentContainerContext (copy)
	return React.createElement(ParentContainerContext.Provider, {
		value = {
			getParentContainer = p1.getParentContainer,
			visibilitySignal = p1.visibilitySignal,
			getShouldSetAppChatVisible = p1.getShouldSetAppChatVisible,
			entryPoint = p1.entryPoint,
			hideParentContainer = p1.hideParentContainer,
			showParentContainer = p1.showParentContainer,
			updateCurrentSquadId = p1.updateCurrentSquadId
		}
	}, p1.children)
end

return ParentContainerProvider
