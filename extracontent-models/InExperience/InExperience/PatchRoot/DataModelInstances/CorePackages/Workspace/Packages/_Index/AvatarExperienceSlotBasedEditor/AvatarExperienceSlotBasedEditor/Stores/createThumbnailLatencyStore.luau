local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local Signals = require(parent.Signals)

local function createThumbnailLatencyStore()
	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(nil)
	local signal3, v3 = Signals.createSignal({})

	local computeds = {}
	return {
		getStartTime = signal,
		getEndTime = signal2,
		getThumbnailMap = signal3,
		getAnyLoaded = Signals.createComputed(function(p): boolean
			for _, v4 in signal3(p) do
				if v4 then
					return true
				end
			end

			return false
		end),
		getIsLoaded = function(p: string)
			local v4 = computeds[p]

			if v4 then
				return v4
			end

			local computed = Signals.createComputed(function(p2): boolean
				return signal3(p2)[p] == true
			end)

			computeds[p] = computed
			return computed
		end,
		startTracking = function()
			v(os.clock())
			v2(nil)
			v3({})
		end,
		appendThumbnail = function(p: string)
			local v4 = signal3(false)

			if v4[p] ~= nil then
				return
			end

			local clone = table.clone(v4)
			clone[p] = false
			v3(clone)
		end,
		setThumbnailLoaded = function(p: string)
			local v4 = signal3(false)

			if v4[p] == true then
				return
			end

			local clone = table.clone(v4)
			clone[p] = true
			v3(clone)
		end,
		endTracking = function()
			v2(os.clock())
		end
	}
end

return createThumbnailLatencyStore
