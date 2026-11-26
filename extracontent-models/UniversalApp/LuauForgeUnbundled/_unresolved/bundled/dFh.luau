local CorePackages = game:GetService("CorePackages")

local Result = require(CorePackages.Packages.Result)

local fFlagUserSearchUsePreviousUsernameMatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUserSearchUsePreviousUsernameMatch

local v5 = {}

function v5.new()
	return {}
end

function v5.fromOmniJsonData(data)
	if type(data) ~= "table" then
		return Result.error("UserSearchEntry.fromOmniJsonData expects userSearchEntryJson to be a table")
	end

	if
		not fFlagUserSearchUsePreviousUsernameMatch
		and data.previousUsernames
		and type(data.previousUsernames) ~= "table"
	then
		return Result.error("UserSearchEntry.entries expects entry.previousUsernames to be a table or null")
	end

	if type(data.contentId) ~= "number" then
		return Result.error("UserSearchEntry.entries expects entry.contentId to be a number")
	end

	if type(data.username) ~= "string" then
		return Result.error("UserSearchEntry.entries expects entry.username to be a string")
	end

	if type(data.displayName) ~= "string" then
		return Result.error("UserSearchEntry.entries expects entry.displayName to be a string")
	end

	if data.contentType ~= "User" then
		return Result.error("UserSearchEntry.entries expects entry.contentType to be 'User'")
	end

	local v6 = v5.new()

	v6.previousUsernames = not fFlagUserSearchUsePreviousUsernameMatch and (data.previousUsernames or {})
		or nil

	if fFlagUserSearchUsePreviousUsernameMatch and data.isPreviousUsernameMatch ~= nil then
		v6.isPreviousUsernameMatch = data.isPreviousUsernameMatch
	end

	v6.id = tostring(data.contentId)
	v6.name = data.username
	v6.displayName = data.displayName

	return Result.success(v6)
end

function v5.mock(value)
	local v6 = v5.new()

	v6.previousUsernames = not fFlagUserSearchUsePreviousUsernameMatch and { "tester001", "tester002" }
		or nil
	v6.id = value or "123456"
	v6.name = "tester003"
	v6.displayName = "tester003"

	return v6
end

return v5
