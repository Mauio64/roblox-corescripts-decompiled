local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")
local SduiPageAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageAnalytics")
local SduiRetryPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiRetryPolicy")

local function useMissingRootWarning(p2, current)
	local ref = React.useRef(current)
	ref.current = current
	local v5 = current ~= nil
	React.useEffect(function()
		if v5 then
			return
		end

		local thread = nil
		thread = task.delay(SduiRetryPolicy.getFetchTimeoutSec() + 2, function()
			thread = nil

			if ref.current == nil then
				local v6 = getSduiApiStore()
				SduiPageAnalytics.sendMissingRoot(p2, v6.getData(p2).status(false), v6.isInFlight(p2))
			end
		end)
		return function()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { p2, v5 })
end

return useMissingRootWarning
