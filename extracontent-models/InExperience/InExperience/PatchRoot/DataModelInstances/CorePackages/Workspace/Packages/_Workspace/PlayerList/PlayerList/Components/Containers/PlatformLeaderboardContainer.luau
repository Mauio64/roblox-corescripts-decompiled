local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local PlatformLeaderboardsClient = require(parent2.PlatformLeaderboardsClient)
local SharedFlags = require(parent2.SharedFlags)

local PlatformLeaderboardStoreContext = require(parent.Common.PlatformLeaderboardStoreContext)

local FFlagPlatformLeaderboardPersistStoreOnRemount = SharedFlags.FFlagPlatformLeaderboardPersistStoreOnRemount

local PlatformLeaderboardClientStore = PlatformLeaderboardsClient.PlatformLeaderboardClientStore

return React.memo(function(p)
	local v

	if FFlagPlatformLeaderboardPersistStoreOnRemount and p.store == nil then
		v = PlatformLeaderboardsClient.getPlatformLeaderboardClientStore()
	end

	local v2 = React.useMemo(function()
		if FFlagPlatformLeaderboardPersistStoreOnRemount or p.store ~= nil or not PlatformLeaderboardClientStore then
			return nil
		end

		return PlatformLeaderboardClientStore.new()
	end, {})

	React.useEffect(function()
		return function()
			if not FFlagPlatformLeaderboardPersistStoreOnRemount and v2 then
				v2:destroy()
			end
		end
	end, { v2 })

	local store = p.store or v or v2

	if store == nil then
		return p.children
	end

	return React.createElement(PlatformLeaderboardStoreContext.Provider, { value = store }, p.children)
end)
