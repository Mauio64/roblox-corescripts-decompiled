local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local GameGetGameInfoStore = require(parent.DataHydration.GameGetGameInfoStore)

local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus

local FFlagAppChatMomentShareCardLoadingSkeletons = require(AppChat.Flags.FFlagAppChatMomentShareCardLoadingSkeletons)

local computed = Signals.createComputed(function(): nil
	return nil
end)

local function useExperienceName(p: number?, flag: boolean)
	local v

	if p and p ~= 0 then
		v = tostring(p)
	end

	local v2

	if flag and v then
		v2 = GameGetGameInfoStore(false).getAndFetchGameInfo(v)
	end

	local useSignalState = SignalsReact.useSignalState
	local v3 = if v2 then v2.data else computed
	local v4 = useSignalState(v3)
	local v5

	if FFlagAppChatMomentShareCardLoadingSkeletons then
		local useSignalState2 = SignalsReact.useSignalState
		local v6 = if v2 then v2.status else computed
		v5 = useSignalState2(v6)
	end

	local name

	if v4 then
		name = v4.name
	end

	return {
		name = name,
		isLoading = v5 == DataStatus.NotReady
	}
end

return useExperienceName
