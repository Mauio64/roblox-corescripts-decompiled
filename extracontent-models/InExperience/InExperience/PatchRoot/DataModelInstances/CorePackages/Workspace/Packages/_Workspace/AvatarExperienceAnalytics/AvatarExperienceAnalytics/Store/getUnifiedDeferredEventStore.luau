local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local function createUnifiedLoggingDeferredEventStore()
	local signal, v = createSignal(false)
	local v2 = {}

	return {
		isEntered = signal,
		enqueue = function(p, callback)
			local v3 = v2[p]

			if not v3 then
				v3 = {}
				v2[p] = v3
			end

			table.insert(v3, callback)
		end,
		takePending = function(p)
			if p == nil then
				local result = {}

				for _, v3 in v2 do
					for _, v4 in v3 do
						table.insert(result, v4)
					end
				end

				v2 = {}
				return result
			else
				local v3 = v2[p] or {}
				v2[p] = nil
				return v3
			end
		end,
		markEntered = function()
			v(true)
		end,
		reset = function()
			v(false)
			v2 = {}
		end
	}
end

return Signals.createComputed(createUnifiedLoggingDeferredEventStore)
