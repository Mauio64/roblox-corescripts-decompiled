local createMomentsSessionHeartbeat = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/createMomentsSessionHeartbeat")
local FIntMomentsUsageMinCreditedGapSec = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FIntMomentsUsageMinCreditedGapSec")

local function createMomentsUsageHeartbeat(p2, callback, callback2, p3, p4)
	local v5 = p4 or os.clock
	local v6 = nil

	local function send()
		v6 = v5()
		callback()
	end

	local function sendEdge()
		if v6 == nil then
			v6 = v5()
			callback()
		elseif FIntMomentsUsageMinCreditedGapSec <= v5() - v6 then
			v6 = v5()
			callback()
		end
	end

	local v7 = createMomentsSessionHeartbeat(p2, function(p5)
		v6 = v5()
		callback()
	end, p3)

	local v8 = false
	local v9 = true
	local v10 = false
	local isWatching = false
	local v11 = false

	local function reconcile()
		local v12 = v8 and v9
		local v13 = v12 and not v10
		local v14 = v13 ~= v11
		local v15 = v12 ~= isWatching
		v11 = v13
		isWatching = v12

		if v14 then
			if v13 then
				v7.start("watch_tab")
			else
				v7.stop()
			end

			if v6 == nil then
				v6 = v5()
				callback()
			elseif FIntMomentsUsageMinCreditedGapSec <= v5() - v6 then
				v6 = v5()
				callback()
			end
		end

		if v15 and callback2 ~= nil then
			callback2(v12)
		end
	end

	return {
		setTabFocused = function(p5)
			v8 = p5
			reconcile()
		end,
		setForegrounded = function(p5)
			v9 = p5
			reconcile()
		end,
		setSuspended = function(p5)
			v10 = p5
			reconcile()
		end,
		getIsWatching = function()
			return isWatching
		end,
		stop = function()
			v8 = false
			reconcile()
		end
	}
end

return createMomentsUsageHeartbeat
