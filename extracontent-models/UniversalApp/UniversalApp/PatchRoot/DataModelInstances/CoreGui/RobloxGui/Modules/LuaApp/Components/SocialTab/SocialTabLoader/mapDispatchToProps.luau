local CorePackages = game:GetService("CorePackages")
local ReceivedCanShowUserAlias = require(CorePackages.Workspace.Packages.AppChat.RoduxAliases).Actions.ReceivedCanShowUserAlias

return function(p1) -- line: 6
	-- upvalues: ReceivedCanShowUserAlias (copy)
	return {
		receivedCanShowUserAlias = function(p2) -- line: 8
			-- upvalues: p1 (copy), ReceivedCanShowUserAlias (copy)
			p1(ReceivedCanShowUserAlias(p2))
		end
	}
end
