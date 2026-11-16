local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Signals")
local createSignal = Signals.createSignal

local function createUnifiedLoggingDeferredEventStore()
	local signal, v5 = createSignal(false)
	local v6 = {}

	return {
		isEntered = signal,
		enqueue = function(p2, p3)
			local v7 = v6[p2]

			if not v7 then
				v7 = {}
				v6[p2] = v7
			end

			table.insert(v7, p3)
		end,
		takePending = function(p2)
			if p2 == nil then
				local result = {}

				for k, v7 in v6 do
					for k2, v8 in v7 do
						table.insert(result, v8)
					end
				end

				v6 = {}
				return result
			else
				local v7 = v6[p2] or {}
				v6[p2] = nil
				return v7
			end
		end,
		markEntered = function()
			v5(true)
		end,
		reset = function()
			v5(false)
			v6 = {}
		end
	}
end

return Signals.createComputed(createUnifiedLoggingDeferredEventStore)
