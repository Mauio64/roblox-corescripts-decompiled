local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local PlatformLeaderboardsClient = require(ParentParentParent.PlatformLeaderboardsClient)
local PlatformLeaderboardStoreContext = require(ParentParent.Common.PlatformLeaderboardStoreContext)
local PlatformLeaderboardClientStore = PlatformLeaderboardsClient.PlatformLeaderboardClientStore

return React.memo(function(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), PlatformLeaderboardClientStore (copy), PlatformLeaderboardStoreContext (copy)
	local v8 = React.useMemo(function() -- line: 18
		-- upvalues: t1 (copy), PlatformLeaderboardClientStore (copy)
		if t1.store ~= nil or not PlatformLeaderboardClientStore then
			return nil
		end

		return PlatformLeaderboardClientStore.new()
	end, {})

	React.useEffect(function() -- line: 26
		-- upvalues: v8 (copy)
		return function() -- line: 27
			-- upvalues: v8 (copy)
			if v8 then
				v8:destroy()
			end
		end
	end, { v8 })

	local v9 = t1.store or v8

	if v9 == nil then
		return t1.children
	end

	return React.createElement(PlatformLeaderboardStoreContext.Provider, {
		value = v9
	}, t1.children)
end)
