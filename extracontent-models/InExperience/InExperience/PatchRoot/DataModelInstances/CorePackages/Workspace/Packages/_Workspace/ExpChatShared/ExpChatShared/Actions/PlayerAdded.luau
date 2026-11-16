local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(p, username: string, displayName: string, hasVerifiedBadge: boolean?)
		return {
			userId = tostring(p),
			username = username,
			displayName = displayName,
			hasVerifiedBadge = hasVerifiedBadge
		}
	end
)
