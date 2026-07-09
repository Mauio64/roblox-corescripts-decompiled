local ContactImporter = script:FindFirstAncestor("ContactImporter")
local Dash = require(ContactImporter.dependencies).Dash

require(ContactImporter.Common.LocalTypes)

local t1 = {}

local function v4(p1) -- line: 8
	-- upvalues: t1 (copy)
	return p1.byDeviceContactId or t1
end
local function v5(p2) -- line: 24
	-- upvalues: Dash (copy)
	return Dash.map(p2, function(p3) -- line: 25
		-- upvalues: Dash (copy)
		return Dash.join(p3, {
			phoneNumber = tostring(p3.phoneNumbers[1]),
			phoneNumbers = Dash.None
		})
	end)
end
local function v6(p4) -- line: 53
	-- upvalues: Dash (copy)
	return Dash.values(p4)
end
local function stripLeadingWhitespace(p5) -- line: 57
	return string.gsub(p5, "^%s*(.*)$", "%1")
end
local function v8(t2: {[any]: any}) -- line: 61
	table.sort(t2, function(p6, p7) -- line: 62
		if p6.contactName and p7.contactName then
			local v25 = string.upper(p6.contactName)
			local v26 = string.gsub(v25, "^%s*(.*)$", "%1")
			local v27 = string.upper(p7.contactName)
			local v28 = string.gsub(v27, "^%s*(.*)$", "%1")

			if v26 and v28 and v26 ~= v28 then
				return v26 < v28
			end
		end

		return p6.deviceContactId < p7.deviceContactId
	end)

	return t2
end

return function(p8) -- line: 75
	-- upvalues: t1 (copy), Dash (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy)
	local v17 = p8 or t1

	return Dash.pipe(v4, function(p9) -- line: 13
		-- upvalues: v17 (copy), t1 (copy), Dash (copy)
		local v30 = v17.hasSentRequest or t1

		return Dash.map(p9, function(p10) -- line: 16
			-- upvalues: Dash (copy), v30 (copy)
			return Dash.join(p10, {
				hasSentRequest = v30[p10.id]
			})
		end)
	end, v5, function(p11) -- line: 34
		-- upvalues: Dash (copy), v17 (copy)
		local t3 = {}

		Dash.forEach(p11, function(p12) -- line: 37
			-- upvalues: v17 (copy), t3 (copy), Dash (copy)
			if not v17.deviceContactToRobloxContact or not v17.deviceContactToRobloxContact[p12.id] then
				t3[p12.id] = Dash.join(p12, {
					isMatchedContact = false,
					deviceContactId = p12.id,
					id = Dash.None
				})
			end
		end)

		return t3
	end, v6, v8)(v17 or {})
end
