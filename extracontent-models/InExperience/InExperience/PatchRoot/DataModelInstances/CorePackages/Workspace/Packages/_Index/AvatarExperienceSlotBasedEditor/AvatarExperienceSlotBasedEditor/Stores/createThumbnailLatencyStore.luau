local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Signals = require(Parent.Signals)

local function createThumbnailLatencyStore() -- line: 40
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)
	local v6, v7 = Signals.createSignal(nil)
	local v8, v9 = Signals.createSignal({})
	local v10 = Signals.createComputed(function(p1) -- line: 45
		-- upvalues: v8 (copy)
		for _, v14 in v8(p1) do
			if v14 then
				return true
			end
		end

		return false
	end)
	local t1 = {}

	return {
		getStartTime = v4,
		getEndTime = v6,
		getThumbnailMap = v8,
		getAnyLoaded = v10,
		getIsLoaded = function(s1: string) -- line: 55
			-- upvalues: t1 (copy), Signals (copy), v8 (copy)
			local v16 = t1[s1]

			if v16 then
				return v16
			end

			local v17 = Signals.createComputed(function(p2) -- line: 60
				-- upvalues: v8 (copy), s1 (copy)
				return v8(p2)[s1] == true
			end)

			t1[s1] = v17

			return v17
		end,
		startTracking = function() -- line: 67
			-- upvalues: v5 (copy), v7 (copy), v9 (copy)
			v5(os.clock())
			v7(nil)
			v9({})
		end,
		appendThumbnail = function(s2: string) -- line: 76
			-- upvalues: v8 (copy), v9 (copy)
			local v19 = v8(false)

			if v19[s2] ~= nil then
				return
			end

			local v20 = table.clone(v19)

			v20[s2] = false
			v9(v20)
		end,
		setThumbnailLoaded = function(s3: string) -- line: 86
			-- upvalues: v8 (copy), v9 (copy)
			local v22 = v8(false)

			if v22[s3] == true then
				return
			end

			local v23 = table.clone(v22)

			v23[s3] = true
			v9(v23)
		end,
		endTracking = function() -- line: 96
			-- upvalues: v7 (copy)
			v7(os.clock())
		end
	}
end

return createThumbnailLatencyStore
