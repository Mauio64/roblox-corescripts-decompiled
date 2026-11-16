local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SignalsReact")
local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxSubscriptionPurchaseApp")
local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase
local robloxSubscriptionSignals = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum

local FIntEarlyAccessPollIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/FIntEarlyAccessPollIntervalSeconds")
local FIntEarlyAccessMaxPollAttempts = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/FIntEarlyAccessMaxPollAttempts")

local defineFastString = game:DefineFastString("R20UniverseAccessTime", "")

local function resolveUnlockTimestamp(value, p2)
	local v5 = string.sub(value, 1, 1) == "+"

	if v5 then
		value = string.sub(value, 2)
	end

	local v6 = tonumber(value)

	if v6 == nil or v6 == 0 then
		return nil
	end

	if v5 then
		return p2 + v6
	end

	return v6
end

local function useGameJoinEarlyAccess(p2, p3)
	local v5 = useAppPolicy(function(p4): boolean
		return not p4.getDisableBlackbirdEntrypoints()
	end)

	local v6 = not (p3 == nil) and p3.playabilityStatus == playabilityStatusEnum.PlusSubscriptionRequired

	local v7 = robloxSubscriptionSignals.get()
	local v8 = SignalsReact.useSignalState(v7.getGainedRobloxSubscriptionThisSession)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = DateTime.now().UnixTimestamp
	end

	local v9

	if v6 then
		local v10 = defineFastString
		local current = ref.current
		local v11 = string.sub(v10, 1, 1) == "+"

		if v11 then
			v10 = string.sub(v10, 2)
		end

		v9 = tonumber(v10)

		if v9 == nil or v9 == 0 then
			v9 = nil
		elseif v11 then
			v9 = current + v9
		end
	else
		v9 = nil
	end

	local state, setState = React.useState(0)
	React.useEffect(function()
		setState(0)

		if v9 == nil then
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
			thread = if count < FIntEarlyAccessMaxPollAttempts then task.delay(FIntEarlyAccessPollIntervalSeconds, poll) else nil
		end

		local v10 = math.max(v9 - DateTime.now().UnixTimestamp, 0)
		thread = task.delay(v10, poll)

		return function()
			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { v9 })

	local v10 = React.useCallback(function()
		local v14 = if p2 then tonumber(p2) else nil
		initiateRobloxSubscriptionPurchase(
			nil,
			nil,
			v14,
			surfaceName.GameJoinEarlyAccessUpsell,
			surfaceContext.InApp
		)
	end, { p2 })

	return {
		isPendingUnlock = v6 and state > 0,
		unlockRefetchTick = state,
		unlockTimestamp = v9,
		showPlusUpsell = v6 and v5,
		openUpsell = v10,
		gainedSubscription = v6 and v8
	}
end

return useGameJoinEarlyAccess
