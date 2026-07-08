local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Types)

local function transformJsonLeafFirst(p1, p2: ((...any) -> ...any)) -- line: 12
	-- upvalues: transformJsonLeafFirst (copy)
	if type(p1) == "table" then
		local v5 = false
		local n1 = 0

		for k, _ in pairs(p1) do
			if type(k) ~= "number" then
				v5 = false

				break
			end

			v5 = true
			n1 = math.max(n1, k)
		end

		if v5 then
			local t1 = {}

			for i, v in ipairs(p1) do
				t1[i] = transformJsonLeafFirst(v, p2)
			end

			return p2(t1)
		end

		local t2 = {}

		for k, v in pairs(p1) do
			t2[k] = transformJsonLeafFirst(v, p2)
		end

		return p2(t2)
	end

	return p2(p1)
end

return transformJsonLeafFirst
