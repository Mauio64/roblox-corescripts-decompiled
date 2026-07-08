local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local Cryo = require(DataHydrationParent.Cryo)
local Requests = require(DataHydration.Profile.Requests)

require(DataHydration.Profile.Enums.ProfileCTAEnums)
game:DefineFastInt("ProfileCTAStoreProcessDelaySec", 1)

local function createProfileCTAStore() -- line: 40
	-- upvalues: createDataCache (copy), createDataResolver (copy), Cryo (copy), Requests (copy)
	local v8 = createDataCache()
	local v9 = createDataResolver({
		requestBatchSize = 25,
		cache = v8,
		queueProcessDelaySec = game:GetFastInt("ProfileCTAStoreProcessDelaySec"),
		fetchFn = function(t1: {[any]: any}) -- line: 47
			-- upvalues: Cryo (copy), Requests (copy)
			local v11 = Cryo.Dictionary.keys(t1)

			return Requests.GetUserProfileCTA(v11):andThen(function(p1) -- line: 50
				-- upvalues: v11 (copy)
				local t2 = {}

				if p1.responseBody and p1.responseBody.profiles then
					for _, v23 in v11 do
						local str = tostring(v23)
						local v25 = p1.responseBody.profiles[str]

						t2[str] = v25 and (not not v25.components and v25.components.Actions) or {}
					end
				end

				return t2
			end):catch(function(_) -- line: 64
				return {}
			end)
		end
	})

	return {
		getCTA = function(s1: string, b1: boolean?) -- line: 70
			-- upvalues: v9 (copy)
			local v14 = nil

			if b1 ~= nil then
				local v15 = b1 == true

				function v14(_: {[any]: any}?) -- line: 74
					-- upvalues: v15 (copy)
					return v15
				end
			end

			return v9.getAndFetchItem(s1, v14)
		end,
		getBatchCTAs = function(t4: {[any]: any}, t5: {[any]: any}?) -- line: 81
			-- upvalues: v9 (copy)
			local v18 = nil

			if t5 then
				local n1 = 0

				function v18(_: {[any]: any}?) -- line: 88
					-- upvalues: n1 (ref), t4 (copy), t5 (copy)
					n1 += 1

					local v29 = t4[n1]

					if v29 then
						return t5[v29] == true
					end

					return false
				end
			end

			return v9.getAndFetchItems(t4, v18)
		end,
		clear = function() -- line: 100
			-- upvalues: v8 (copy), v9 (copy)
			v8.clear()
			v9.clear()
		end,
		dispose = function() -- line: 105
			-- upvalues: v9 (copy)
			v9.dispose()
		end
	}
end

return createProfileCTAStore
