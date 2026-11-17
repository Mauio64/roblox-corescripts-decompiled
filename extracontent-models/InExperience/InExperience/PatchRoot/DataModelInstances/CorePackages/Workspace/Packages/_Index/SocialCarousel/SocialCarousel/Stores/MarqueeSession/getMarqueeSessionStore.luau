local createMarqueeSessionStore = require(script.Parent.createMarqueeSessionStore)

local marqueeSessionStores = {}
local GetMarqueeSessionStore = {}

function GetMarqueeSessionStore.getMarqueeSessionStore(p: string)
	local v = marqueeSessionStores[p]

	if v ~= nil then
		return v
	end

	local marqueeSessionStore = createMarqueeSessionStore()
	marqueeSessionStores[p] = marqueeSessionStore
	return marqueeSessionStore
end

function GetMarqueeSessionStore.resetMarqueeSessionStores()
	table.clear(marqueeSessionStores)
end

return GetMarqueeSessionStore
