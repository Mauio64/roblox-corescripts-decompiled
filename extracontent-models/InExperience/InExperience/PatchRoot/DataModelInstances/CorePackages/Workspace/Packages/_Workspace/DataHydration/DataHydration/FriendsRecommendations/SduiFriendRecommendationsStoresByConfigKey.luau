local createSduiFriendRecommendationsStore = require(script.Parent.createSduiFriendRecommendationsStore)

local v = {}
local SduiFriendRecommendationsStoresByConfigKey = {}

function SduiFriendRecommendationsStoresByConfigKey.get(value: string?)
	local v2 = value or "Home"
	local v3 = v[v2]

	if v3 == nil then
		v3 = createSduiFriendRecommendationsStore()
		v[v2] = v3
	end

	return v3
end

function SduiFriendRecommendationsStoresByConfigKey.dispose(p: string)
	local v2 = v[p]

	if v2 then
		v2.dispose()
		v[p] = nil
	end
end

return SduiFriendRecommendationsStoresByConfigKey
