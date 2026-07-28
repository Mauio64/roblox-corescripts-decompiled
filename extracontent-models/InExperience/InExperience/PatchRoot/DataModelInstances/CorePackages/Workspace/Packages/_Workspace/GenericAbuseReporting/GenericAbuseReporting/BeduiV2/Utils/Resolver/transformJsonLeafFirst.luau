local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.BeduiV2.Types)

local FFlagAbuseReportDensifyResolvedArrays = require(GenericAbuseReporting.Flags.FFlagAbuseReportDensifyResolvedArrays)

local function transformJsonLeafFirst(p1, p2: ((...any) -> ...any)) -- line: 13
	-- upvalues: FFlagAbuseReportDensifyResolvedArrays (copy), transformJsonLeafFirst (copy)
	if type(p1) == "table" then
		local v6 = false

		for k, _ in pairs(p1) do
			if type(k) ~= "number" then
				v6 = false

				break
			end

			v6 = true
		end

		if v6 then
			local t1 = {}

			if FFlagAbuseReportDensifyResolvedArrays then
				for _, v in ipairs(p1) do
					local v12 = transformJsonLeafFirst(v, p2)

					if v12 ~= nil then
						table.insert(t1, v12)
					end
				end
			else
				for i, v in ipairs(p1) do
					t1[i] = transformJsonLeafFirst(v, p2)
				end
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
