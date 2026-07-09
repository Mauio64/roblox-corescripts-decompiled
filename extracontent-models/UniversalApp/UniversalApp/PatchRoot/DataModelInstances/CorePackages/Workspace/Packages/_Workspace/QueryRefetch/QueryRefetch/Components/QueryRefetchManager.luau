local QueryRefetch = script:FindFirstAncestor("QueryRefetch")
local QueryRefetchParent = QueryRefetch.Parent
local React = require(QueryRefetchParent.React)
local usePlatformNameQueryRefetch = require(QueryRefetch.Hooks.usePlatformNameQueryRefetch)
local NotificationService = game:GetService("NotificationService")
local RobloxEventReceiver = require(QueryRefetchParent.RobloxEventReceiver).RobloxEventReceiver

local function QueryRefetchManager() -- line: 10
	-- upvalues: React (copy), RobloxEventReceiver (copy), NotificationService (copy), usePlatformNameQueryRefetch (copy)
	local v8 = React.useMemo(function() -- line: 11
		-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
		return RobloxEventReceiver.new(NotificationService)
	end, {})

	usePlatformNameQueryRefetch(v8)

	return nil
end

return QueryRefetchManager
