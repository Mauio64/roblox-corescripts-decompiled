local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local VerticalPagerContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/VerticalPagerContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local GameGetPlayabilityStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/GameGetPlayabilityStore")
local isVideoEligibleForPlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/VideoUtils").isVideoEligibleForPlayability

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPagerContext.useVerticalPager

local v5 = {
	data = Signals.createComputed(function(): nil
		return nil
	end),
	status = Signals.createComputed(function(): string
		return "Ready"
	end)
}

local function useEdpVideoEligibilityViewModel(p2)
	local v6 = useVerticalPager()
	local v7 = GameGetPlayabilityStore(false)
	local universeId = tostring(p2.universeId or 0)
	local v8 = not (p2.universeId == nil) and p2.universeId > 0
	local ref = React.useRef(false)

	local v9 = React.useMemo(function()
		if v8 then
			return v7.getAndFetchPlayability(universeId)
		end

		return v5
	end, { v8, v7, universeId })
	local v10 = useSignalState(v9.data)
	local v11 = useSignalState(v9.status)
	local videoEligibleForPlayability = isVideoEligibleForPlayability(v11 == "Ready", v10)

	local v12 = v8
		and v11 ~= "Failed"
		and (v11 == "Ready" and (videoEligibleForPlayability and "Eligible" or "Ineligible") or "Loading")
		or "Ineligible"

	React.useEffect(function()
		if v12 ~= "Ineligible" or ref.current then
			return
		end

		for k, v13 in v6.store.getItems(false) do
			if v13.kind == "moment" and v13.moment.momentId == p2.momentId then
				ref.current = true
				v6.removeItem(k)
				break
			end
		end
	end, { v6, p2.momentId, v12 })

	return { status = v12 }
end

return useEdpVideoEligibilityViewModel
