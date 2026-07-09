local Parent = script:FindFirstAncestor("GameDetail").Parent
local Signals = require(Parent.Signals)
local AgeCheckUpsellDismissedData = require(script.Parent.AgeCheckUpsellDismissedData)
local t1 = {}

local function getOrCreate(s1: string) -- line: 15
	-- upvalues: t1 (copy), Signals (copy)
	local v7 = t1[s1]

	if not v7 then
		local v8, v9 = Signals.createSignal(false)

		v7 = {
			get = v8,
			set = v9
		}
		t1[s1] = v7
	end

	return v7
end

return {
	getIsAgeCheckUpsellRendered = function(p1, s2: string?) -- line: 32
		-- upvalues: AgeCheckUpsellDismissedData (copy), t1 (copy), Signals (copy)
		if s2 == nil or s2 == "" then
			return false
		end

		if AgeCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed(p1) then
			return false
		end

		local v17 = t1[s2]

		if not v17 then
			local v18, v19 = Signals.createSignal(false)

			v17 = {
				get = v18,
				set = v19
			}
			t1[s2] = v17
		end

		return v17.get(p1)
	end,
	setAgeCheckUpsellRendered = function(s3: string, b1: boolean) -- line: 25
		-- upvalues: t1 (copy), Signals (copy)
		if s3 == nil or s3 == "" then
			return
		end

		local v12 = t1[s3]

		if not v12 then
			local v13, v14 = Signals.createSignal(false)

			v12 = {
				get = v13,
				set = v14
			}
			t1[s3] = v12
		end

		v12.set(b1)
	end
}
