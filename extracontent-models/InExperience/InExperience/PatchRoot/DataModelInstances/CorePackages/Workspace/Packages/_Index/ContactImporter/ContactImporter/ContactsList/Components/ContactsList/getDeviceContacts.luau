local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local dash = dependencies.Dash
require(ContactImporter.Common.LocalTypes)

local v = {}

local function fn(p)
	return p.byDeviceContactId or v
end

local function fn2(p)
	return dash.map(p, function(p2)
		return dash.join(p2, {
			phoneNumber = tostring(p2.phoneNumbers[1]),
			phoneNumbers = dash.None
		})
	end)
end

local function fn3(p)
	return dash.values(p)
end

local function stripLeadingWhitespace(contactName) -- 2 equivalent calls inferred from this helper
	return string.gsub(contactName, "^%s*(.*)$", "%1")
end

local function fn4(list)
	table.sort(list, function(a, b): boolean
		if a.contactName and b.contactName then
			local v2 = stripLeadingWhitespace(string.upper(a.contactName)) -- inferred equivalent call
			local v3 = stripLeadingWhitespace(string.upper(b.contactName)) -- inferred equivalent call

			if v2 and v3 and v2 ~= v3 then
				return v2 < v3
			end
		end

		return a.deviceContactId < b.deviceContactId
	end)

	return list
end

return function(p)
	local v2 = p or v
	return dash.pipe(fn, function(p2)
		local hasSentRequest = v2.hasSentRequest or v

		return dash.map(p2, function(p3)
			return dash.join(p3, { hasSentRequest = hasSentRequest[p3.id] })
		end)
	end, fn2, function(p2)
		local values = {}

		dash.forEach(p2, function(p3)
			if not (v2.deviceContactToRobloxContact and v2.deviceContactToRobloxContact[p3.id]) then
				values[p3.id] = dash.join(p3, {
					deviceContactId = p3.id,
					isMatchedContact = false,
					id = dash.None
				})
			end
		end)

		return values
	end, fn3, fn4)(v2 or {})
end
