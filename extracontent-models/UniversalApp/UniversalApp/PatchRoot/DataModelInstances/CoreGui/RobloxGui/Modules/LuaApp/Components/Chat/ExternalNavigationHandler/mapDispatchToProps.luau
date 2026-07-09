local CorePackages = game:GetService("CorePackages")
local CompleteExternalNavigationIntoChat = require(CorePackages.Workspace.Packages.AppChat.CompleteExternalNavigationIntoChat)

return function(p1) -- line: 4
	-- upvalues: CompleteExternalNavigationIntoChat (copy)
	return {
		completeExternalNavigation = function(p2) -- line: 6
			-- upvalues: p1 (copy), CompleteExternalNavigationIntoChat (copy)
			p1(CompleteExternalNavigationIntoChat(p2))
		end
	}
end
