local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Cryo = require(Parent.Cryo)
local Signals = require(Parent.Signals)

local function createStaleInventoryGrantStore() -- line: 18
	-- upvalues: Signals (copy), Cryo (copy)
	local v5, v6 = Signals.createSignal({})

	return {
		getStaleSearchUuids = v5,
		isSearchUuidStale = function(s1: string) -- line: 21
			-- upvalues: v5 (copy)
			return v5(false)[s1] == true
		end,
		markSearchUuidStale = function(s2: string) -- line: 25
			-- upvalues: v5 (copy), v6 (copy), Cryo (copy)
			if v5(false)[s2] == true then
				return
			end

			v6(Cryo.Dictionary.join(v5(false), {
				[s2] = true
			}))
		end,
		clearSearchUuidStale = function(s3: string) -- line: 32
			-- upvalues: v5 (copy), v6 (copy), Cryo (copy)
			if v5(false)[s3] ~= true then
				return
			end

			v6(Cryo.Dictionary.join(v5(false), {
				[s3] = Cryo.None
			}))
		end
	}
end

return createStaleInventoryGrantStore
