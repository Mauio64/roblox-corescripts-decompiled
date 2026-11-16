local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local VerticalPagerContext = require(Moments.Components.VerticalPager.VerticalPagerContext)
require(Moments.Components.Feed.FeedTypes)
local GameGetPlayabilityStore = require(parent.DataHydration.GameGetPlayabilityStore)
local VideoUtils = require(parent.VideoUtils)
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPagerContext.useVerticalPager

local v = {
	data = Signals.createComputed(function(): nil
		return nil
	end),
	status = Signals.createComputed(function(): string
		return "Ready"
	end)
}

local function useEdpVideoEligibilityViewModel(p)
	local v2 = useVerticalPager()
	local gameGetPlayabilityStore = GameGetPlayabilityStore(false)
	local universeId = tostring(p.universeId or 0)
	local v3

	if p.universeId == nil then
		v3 = false
	else
		v3 = p.universeId > 0
	end

	local ref = React.useRef(false)

	local v4 = React.useMemo(function()
		if v3 then
			return (gameGetPlayabilityStore.getAndFetchPlayability(universeId))
		end

		return v
	end, { v3, gameGetPlayabilityStore, universeId })
	local v5 = useSignalState(v4.data)
	local v6 = useSignalState(v4.status)
	local videoEligibleForPlayability = isVideoEligibleForPlayability(v6 == "Ready", v5)

	local status = v3
		and v6 ~= "Failed"
		and (v6 == "Ready" and (videoEligibleForPlayability and "Eligible" or "Ineligible") or "Loading")
		or "Ineligible"

	React.useEffect(function()
		if status ~= "Ineligible" or ref.current then
			return
		end

		for k, v7 in v2.store.getItems(false) do
			if v7.kind == "moment" and v7.moment.momentId == p.momentId then
				ref.current = true
				v2.removeItem(k)
				break
			end
		end
	end, { v2, p.momentId, status })

	return { status = status }
end

return useEdpVideoEligibilityViewModel
