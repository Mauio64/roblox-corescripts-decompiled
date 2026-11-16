local parent = script:FindFirstAncestor("GamePlayButton").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase
local RobloxSubscriptionSignals = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
require(parent.PlayabilityRodux)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local FIntEarlyAccessPollIntervalSeconds = require(script.Parent.FIntEarlyAccessPollIntervalSeconds)
local FIntEarlyAccessMaxPollAttempts = require(script.Parent.FIntEarlyAccessMaxPollAttempts)

local defineFastString = game:DefineFastString("R20UniverseAccessTime", "")

local function resolveUnlockTimestamp(value: string, p: number)
	local v = string.sub(value, 1, 1) == "+"

	if v then
		value = string.sub(value, 2)
	end

	local v2 = tonumber(value)

	if v2 == nil or v2 == 0 then
		return nil
	end

	if v then
		return p + v2
	end

	return v2
end

local function useGameJoinEarlyAccess(p, p2)
	local v = useAppPolicy(function(p3): boolean
		return not p3.getDisableBlackbirdEntrypoints()
	end)
	local v2

	if p2 == nil then
		v2 = false
	else
		v2 = p2.playabilityStatus == PlayabilityStatusEnum.PlusSubscriptionRequired
	end

	local v3 = RobloxSubscriptionSignals.get()
	local v4 = SignalsReact.useSignalState(v3.getGainedRobloxSubscriptionThisSession)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = DateTime.now().UnixTimestamp
	end

	local unlockTimestamp

	if v2 then
		local v5 = defineFastString
		local current = ref.current
		local v6 = string.sub(v5, 1, 1) == "+"

		if v6 then
			v5 = string.sub(v5, 2)
		end

		unlockTimestamp = tonumber(v5)

		if unlockTimestamp == nil or unlockTimestamp == 0 then
			unlockTimestamp = nil
		elseif v6 then
			unlockTimestamp = current + unlockTimestamp
		end
	else
		unlockTimestamp = nil
	end

	local state, setState = React.useState(0)
	React.useEffect(function()
		setState(0)

		if unlockTimestamp == nil then
			return
		end

		local flag = false
		local thread = nil
		local count = 0
		local function poll()
			if flag then
				return
			end

			count += 1
			setState(count)

			if count < FIntEarlyAccessMaxPollAttempts then
				thread = task.delay(FIntEarlyAccessPollIntervalSeconds, poll)
			else
				thread = nil
			end
		end

		local v5 = math.max(unlockTimestamp - DateTime.now().UnixTimestamp, 0)
		thread = task.delay(v5, poll)

		return function()
			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { unlockTimestamp })

	local openUpsell = React.useCallback(function()
		local v5

		if p then
			v5 = tonumber(p)
		end

		initiateRobloxSubscriptionPurchase(nil, nil, v5, SurfaceName.GameJoinEarlyAccessUpsell, SurfaceContext.InApp)
	end, { p })

	return {
		isPendingUnlock = v2 and state > 0,
		unlockRefetchTick = state,
		unlockTimestamp = unlockTimestamp,
		showPlusUpsell = v2 and v,
		openUpsell = openUpsell,
		gainedSubscription = v2 and v4
	}
end

return useGameJoinEarlyAccess
