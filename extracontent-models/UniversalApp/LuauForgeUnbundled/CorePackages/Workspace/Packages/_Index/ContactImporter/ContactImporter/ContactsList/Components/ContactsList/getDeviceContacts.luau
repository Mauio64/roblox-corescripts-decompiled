local dash = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").Dash
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/LocalTypes")

local v5 = {}

local function fn(p2)
	return p2.byDeviceContactId or v5
end

local function fn2(p2)
	return dash.map(p2, function(p3)
		return dash.join(p3, {
			phoneNumber = tostring(p3.phoneNumbers[1]),
			phoneNumbers = dash.None
		})
	end)
end

local function fn3(p2)
	return dash.values(p2)
end

local function stripLeadingWhitespace(value)
	return string.gsub(value, "^%s*(.*)$", "%1")
end

local function fn4(list)
	table.sort(list, function(a, b): boolean
		if a.contactName and b.contactName then
			local contactName = string.upper(a.contactName)
			local v6 = string.gsub(contactName, "^%s*(.*)$", "%1")

			local contactName2 = string.upper(b.contactName)
			local v7 = string.gsub(contactName2, "^%s*(.*)$", "%1")

			if v6 and v7 and v6 ~= v7 then
				return v6 < v7
			end
		end

		return a.deviceContactId < b.deviceContactId
	end)

	return list
end

return function(p2)
	local v6 = p2 or v5
	return dash.pipe(fn, function(p3)
		local hasSentRequest = v6.hasSentRequest or v5

		return dash.map(p3, function(p4)
			return dash.join(p4, { hasSentRequest = hasSentRequest[p4.id] })
		end)
	end, fn2, function(p3)
		local values = {}

		dash.forEach(p3, function(p4)
			if not (v6.deviceContactToRobloxContact and v6.deviceContactToRobloxContact[p4.id]) then
				values[p4.id] = dash.join(p4, {
					deviceContactId = p4.id,
					isMatchedContact = false,
					id = dash.None
				})
			end
		end)

		return values
	end, fn3, fn4)(v6 or {})
end
