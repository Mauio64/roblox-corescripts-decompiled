local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local function createThumbnailLatencyStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal({})

	local computeds = {}
	return {
		getStartTime = signal,
		getEndTime = signal2,
		getThumbnailMap = signal3,
		getAnyLoaded = Signals.createComputed(function(p2): boolean
			for k, v8 in signal3(p2) do
				if v8 then
					return true
				end
			end

			return false
		end),
		getIsLoaded = function(p2)
			local v8 = computeds[p2]

			if v8 then
				return v8
			end

			local computed2 = Signals.createComputed(function(p3): boolean
				return signal3(p3)[p2] == true
			end)

			computeds[p2] = computed2
			return computed2
		end,
		startTracking = function()
			v5(os.clock())
			v6(nil)
			v7({})
		end,
		appendThumbnail = function(p2)
			local v8 = signal3(false)

			if v8[p2] ~= nil then
				return
			end

			local clone = table.clone(v8)
			clone[p2] = false
			v7(clone)
		end,
		setThumbnailLoaded = function(p2)
			local v8 = signal3(false)

			if v8[p2] == true then
				return
			end

			local clone = table.clone(v8)
			clone[p2] = true
			v7(clone)
		end,
		endTracking = function()
			v6(os.clock())
		end
	}
end

return createThumbnailLatencyStore
