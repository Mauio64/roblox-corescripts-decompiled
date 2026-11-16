local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local v = {}

local function defaultRelationship() -- 1 equivalent call inferred from this helper
	return { isBlocked = false, friendStatus = nil, isFollowing = false }
end

local function getOrCreate(p: number) -- 2 equivalent calls inferred from this helper
	if not v[p] then
		local signal, setter = createSignal(defaultRelationship()) -- inferred equivalent call
		v[p] = { getter = signal, setter = setter }
	end

	return v[p]
end

local PlayerRelationshipStore = {}

function PlayerRelationshipStore.getPlayerRelationshipReactive(p: number)
	return getOrCreate(p).getter -- inferred equivalent call
end

function PlayerRelationshipStore.patchPlayerRelationship(p: number, data)
	local v2 = getOrCreate(p) -- inferred equivalent call
	local getter = v2.getter(false)
	local isBlocked

	if data.isBlocked == nil then
		isBlocked = getter.isBlocked
	else
		isBlocked = data.isBlocked
	end

	local friendStatus

	if data.friendStatus == nil then
		friendStatus = getter.friendStatus
	else
		friendStatus = data.friendStatus
	end

	local isFollowing

	if data.isFollowing == nil then
		isFollowing = getter.isFollowing
	else
		isFollowing = data.isFollowing
	end

	v2.setter({ isBlocked = isBlocked, friendStatus = friendStatus, isFollowing = isFollowing })
end

function PlayerRelationshipStore.removePlayer(p: number)
	v[p] = nil
end

function PlayerRelationshipStore.cleanUp()
	v = {}
end

return PlayerRelationshipStore
