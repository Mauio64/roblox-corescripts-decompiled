local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local createMomentsSessionHeartbeat = require(script.Parent.createMomentsSessionHeartbeat)
local FIntMomentsUsageMinCreditedGapSec = require(MomentsCommon.Flags.FIntMomentsUsageMinCreditedGapSec)

local function createMomentsUsageHeartbeat(p: number, callback, callback2, p2, callback3)
	local v = callback3 or os.clock
	local v2 = nil

	local function send() -- 3 equivalent calls inferred from this helper
		v2 = v()
		callback()
	end

	local function sendEdge() -- 1 equivalent call inferred from this helper
		if v2 == nil then
			send() -- inferred equivalent call
		elseif FIntMomentsUsageMinCreditedGapSec <= v() - v2 then
			send() -- inferred equivalent call
		end
	end

	local momentsSessionHeartbeat = createMomentsSessionHeartbeat(p, function(_: string)
		send() -- inferred equivalent call
	end, p2)

	local v3 = false
	local v4 = true
	local v5 = false
	local isWatching = false
	local v6 = false

	local function reconcile()
		local v7 = v3 and v4
		local v8 = v7 and not v5
		local v9 = v8 ~= v6
		local v10 = v7 ~= isWatching
		v6 = v8
		isWatching = v7

		if v9 then
			if v8 then
				momentsSessionHeartbeat.start("watch_tab")
			else
				momentsSessionHeartbeat.stop()
			end

			sendEdge() -- inferred equivalent call
		end

		if v10 and callback2 ~= nil then
			callback2(v7)
		end
	end

	return {
		setTabFocused = function(flag: boolean)
			v3 = flag
			reconcile()
		end,
		setForegrounded = function(flag: boolean)
			v4 = flag
			reconcile()
		end,
		setSuspended = function(flag: boolean)
			v5 = flag
			reconcile()
		end,
		getIsWatching = function()
			return isWatching
		end,
		stop = function()
			v3 = false
			reconcile()
		end
	}
end

return createMomentsUsageHeartbeat
