local CompleteExternalNavigationIntoChat = require(script.Parent.Parent.Parent.Actions.CompleteExternalNavigationIntoChat)

return function(p1) -- line: 3
	-- upvalues: CompleteExternalNavigationIntoChat (copy)
	return {
		completeExternalNavigation = function(p2) -- line: 5
			-- upvalues: p1 (copy), CompleteExternalNavigationIntoChat (copy)
			p1(CompleteExternalNavigationIntoChat(p2))
		end
	}
end
