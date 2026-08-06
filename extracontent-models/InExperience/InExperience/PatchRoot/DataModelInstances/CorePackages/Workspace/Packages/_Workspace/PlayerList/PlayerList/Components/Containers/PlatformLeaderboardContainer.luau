local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local PlatformLeaderboardsClient = require(ParentParentParent.PlatformLeaderboardsClient)
local SharedFlags = require(ParentParentParent.SharedFlags)
local PlatformLeaderboardStoreContext = require(ParentParent.Common.PlatformLeaderboardStoreContext)
local FFlagPlatformLeaderboardPersistStoreOnRemount = SharedFlags.FFlagPlatformLeaderboardPersistStoreOnRemount
local PlatformLeaderboardClientStore = PlatformLeaderboardsClient.PlatformLeaderboardClientStore

return React.memo(function(t1: {[any]: any}) -- line: 19
	-- upvalues: FFlagPlatformLeaderboardPersistStoreOnRemount (copy), PlatformLeaderboardsClient (copy), React (copy), PlatformLeaderboardClientStore (copy), PlatformLeaderboardStoreContext (copy)
	local v10 = nil

	if FFlagPlatformLeaderboardPersistStoreOnRemount and t1.store == nil then
		v10 = PlatformLeaderboardsClient.getPlatformLeaderboardClientStore()
	end

	local v11 = React.useMemo(function() -- line: 26
		-- upvalues: FFlagPlatformLeaderboardPersistStoreOnRemount (copy), t1 (copy), PlatformLeaderboardClientStore (copy)
		if FFlagPlatformLeaderboardPersistStoreOnRemount or (t1.store ~= nil or not PlatformLeaderboardClientStore) then
			return nil
		end

		return PlatformLeaderboardClientStore.new()
	end, {})

	React.useEffect(function() -- line: 34
		-- upvalues: FFlagPlatformLeaderboardPersistStoreOnRemount (copy), v11 (copy)
		return function() -- line: 35
			-- upvalues: FFlagPlatformLeaderboardPersistStoreOnRemount (copy), v11 (copy)
			if not FFlagPlatformLeaderboardPersistStoreOnRemount and v11 then
				v11:destroy()
			end
		end
	end, { v11 })

	local v12 = t1.store or (v10 or v11)

	if v12 == nil then
		return t1.children
	end

	return React.createElement(PlatformLeaderboardStoreContext.Provider, {
		value = v12
	}, t1.children)
end)
