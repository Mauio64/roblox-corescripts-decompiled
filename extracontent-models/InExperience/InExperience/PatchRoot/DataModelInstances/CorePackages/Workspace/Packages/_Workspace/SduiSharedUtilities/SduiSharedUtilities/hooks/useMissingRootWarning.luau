local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
local SduiPageAnalytics = require(SduiSharedUtilities.SduiPageAnalytics)
local SduiRetryPolicy = require(SduiSharedUtilities.SduiRetryPolicy)

local function useMissingRootWarning(p: string, current)
	local ref = React.useRef(current)
	ref.current = current
	local v = current ~= nil
	React.useEffect(function()
		if v then
			return
		end

		local thread = nil
		thread = task.delay(SduiRetryPolicy.getFetchTimeoutSec() + 2, function()
			thread = nil

			if ref.current == nil then
				local sduiApiStore = getSduiApiStore()
				SduiPageAnalytics.sendMissingRoot(p, sduiApiStore.getData(p).status(false), sduiApiStore.isInFlight(p))
			end
		end)
		return function()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { p, v })
end

return useMissingRootWarning
