local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local Signals = require(Parent.Signals)
local self = setmetatable({}, {
	__mode = "v"
})

local function ensureFieldSignal(t1: {[any]: any}, s1: string) -- line: 17
	-- upvalues: Signals (copy)
	local v8 = t1[s1]

	if v8 then
		return v8
	end

	local v9, v10 = Signals.createSignal(nil)
	local t2 = {
		get = v9,
		set = v10
	}

	t1[s1] = t2

	return t2
end
local function getSduiClientPageScope(s2: string) -- line: 40
	-- upvalues: self (copy), Signals (copy)
	local v13 = self[s2]

	if v13 then
		return v13
	end

	local t3 = {}
	local t4 = {
		get = function(s3: string) -- line: 49
			-- upvalues: t3 (copy), Signals (copy)
			local v17 = t3
			local v18 = v17[s3]

			if v18 then
			else
				local v19, v20 = Signals.createSignal(nil)

				v18 = {
					get = v19,
					set = v20
				}
				v17[s3] = v18
			end

			return v18.get(false)
		end,
		set = function(s4: string, p1) -- line: 52
			-- upvalues: t3 (copy), Signals (copy)
			local v23 = t3
			local v24 = v23[s4]

			if v24 then
			else
				local v25, v26 = Signals.createSignal(nil)

				v24 = {
					get = v25,
					set = v26
				}
				v23[s4] = v24
			end

			v24.set(p1)
		end,
		getSignal = function(s5: string) -- line: 55
			-- upvalues: t3 (copy), Signals (copy)
			local v28 = t3
			local v29 = v28[s5]

			if v29 then
			else
				local v30, v31 = Signals.createSignal(nil)

				v29 = {
					get = v30,
					set = v31
				}
				v28[s5] = v29
			end

			return v29.get
		end
	}

	self[s2] = t4

	return t4
end

return getSduiClientPageScope
