local UserSearchEntry = require(script.Parent.UserSearchEntry)

local function getFormattedUserSearchEntries(t1: {[any]: any}) -- line: 3
	-- upvalues: UserSearchEntry (copy)
	local t2 = {}

	if not t1 then
		return {}
	end

	for _, v6 in t1 do
		UserSearchEntry.fromOmniJsonData(v6):match(function(p1) -- line: 13
			-- upvalues: t2 (copy)
			table.insert(t2, p1)
		end):matchError(function(s1: string) -- line: 16
			warn("Failure in parsing UserSearchEntry: " .. s1)
		end)
	end

	return t2
end

return getFormattedUserSearchEntries
