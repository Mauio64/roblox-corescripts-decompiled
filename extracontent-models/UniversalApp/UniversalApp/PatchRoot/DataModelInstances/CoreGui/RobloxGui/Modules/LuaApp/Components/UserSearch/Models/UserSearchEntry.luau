local CorePackages = game:GetService("CorePackages")
local Result = require(CorePackages.Packages.Result)
local t1 = {
	new = function() -- line: 22
		return {}
	end
}

function t1.fromOmniJsonData(t2: {[any]: any}) -- line: 27
	-- upvalues: Result (copy), t1 (copy)
	if type(t2) ~= "table" then
		return Result.error("UserSearchEntry.fromOmniJsonData expects userSearchEntryJson to be a table")
	end

	if t2.previousUsernames and type(t2.previousUsernames) ~= "table" then
		return Result.error("UserSearchEntry.entries expects entry.previousUsernames to be a table or null")
	end

	if type(t2.contentId) ~= "number" then
		return Result.error("UserSearchEntry.entries expects entry.contentId to be a number")
	end

	if type(t2.username) ~= "string" then
		return Result.error("UserSearchEntry.entries expects entry.username to be a string")
	end

	if type(t2.displayName) ~= "string" then
		return Result.error("UserSearchEntry.entries expects entry.displayName to be a string")
	end

	if t2.contentType ~= "User" then
		return Result.error("UserSearchEntry.entries expects entry.contentType to be 'User'")
	end

	local v5 = t1.new()

	v5.previousUsernames = t2.previousUsernames or {}
	v5.id = tostring(t2.contentId)
	v5.name = t2.username
	v5.displayName = t2.displayName

	return Result.success(v5)
end
function t1.mock(s1: string?) -- line: 62
	-- upvalues: t1 (copy)
	local v7 = t1.new()

	v7.previousUsernames = {
		"tester001",
		"tester002"
	}
	v7.id = s1 or "123456"
	v7.name = "tester003"
	v7.displayName = "tester003"

	return v7
end

return t1
