local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GameGetGameInfoStore = require(parent.DataHydration.GameGetGameInfoStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos

local useSignalState = SignalsReact.useSignalState

local v = { name = nil, creatorName = nil, isCreatorVerified = false, rootPlaceId = nil }
local computed = Signals.createComputed(function(): nil
	return nil
end)

return function(p: number?)
	local v2

	if p and p ~= 0 then
		v2 = tostring(p)
	end

	local v3

	if v2 then
		v3 = GameGetGameInfoStore(false).getAndFetchGameInfo(v2).data
	else
		v3 = computed
	end

	local v4 = useSignalState(v3)

	if v4 == nil then
		return v
	end

	local creator = v4.creator
	local v5 = { name = v4.name, creatorName = 0, isCreatorVerified = 0, rootPlaceId = 0 }
	local creatorName

	if creator then
		creatorName = creator.name
	end

	v5.creatorName = creatorName
	local isCreatorVerified

	if creator then
		isCreatorVerified = creator.hasVerifiedBadge == true
	else
		isCreatorVerified = false
	end

	v5.isCreatorVerified = isCreatorVerified
	local rootPlaceId

	if FFlagMomentsServeEDPVideos then
		rootPlaceId = tonumber(v4.rootPlaceId)
	end

	v5.rootPlaceId = rootPlaceId
	return v5
end
