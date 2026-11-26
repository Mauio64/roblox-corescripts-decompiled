local CorePackages = game:GetService("CorePackages")
require("@game/CorePackages/Workspace/Packages/Navigation")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock
local fFlagSignalsNavDeferProjection = SharedFlags.FFlagSignalsNavDeferProjection

local function createNavigationProjection(data, p2)
	local count = 0

	local function connectActionEvents(p3)
		local v5 = p3.addListener(RoactNavigation.Events.Action, function(p4)
			data.clearPending(p4.action)
		end)
		return function()
			v5.remove()
		end
	end

	local v5 = {
		onNavigationStateChange = function(p3, p4, p5)
			if p2.onCommitted then
				p2.onCommitted(p5)
			end

			if fFlagSignalsNavPendingLock then
				data.markPendingCommitted(p5)
			end

			if fFlagSignalsNavDeferProjection then
				local v6 = count
				task.defer(function()
					if v6 == count then
						data.update(p4)

						if fFlagSignalsNavPendingLock then
							data.clearPending(p5)
						end
					end
				end)
			else
				data.update(p4)

				if fFlagSignalsNavPendingLock then
					data.clearPending(p5)
				end
			end

			if p2.onStateChange then
				p2.onStateChange(p4)
			end
		end,
		externalDispatchConnector = function(p3)
			data.setDispatch(p3)
			return function()
				data.clearDispatch()
			end
		end,
		connectActionEvents = 0
	}

	if not fFlagSignalsNavPendingLock then
		connectActionEvents = nil
	end

	v5.connectActionEvents = connectActionEvents
	return {
		containerProps = v5,
		invalidate = function()
			count += 1
		end
	}
end

return createNavigationProjection
