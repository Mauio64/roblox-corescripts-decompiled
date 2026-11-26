local User = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/User")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/LinkingProtocol").LinkingProtocol.default

local PreAuthDeepLinkMap = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/EventReceivers/PreAuthDeepLinkMap")

local function parseQueryParams(value)
	local queryParams = {}
	local v5, v6 = string.find(value, "?")

	if not v6 then
		return queryParams
	end

	local v7 = string.sub(value, v6 + 1)

	for k in string.gmatch(v7, "[^&]+") do
		local v8, v9 = string.match(k, "([^=]+)=?(.*)")

		if v8 then
			queryParams[string.lower(v8)] = v9 or ""
		end
	end

	return queryParams
end

local function matchesPattern(p2, value): boolean
	return string.match(value, p2) ~= nil
end

local function userIsAuthenticated(): boolean
	return User.fromLocalStorage().userId ~= -1
end

local function isPreauthDeeplink(value): boolean
	if not value or value == "" then
		return false
	end

	local v5 = string.lower(value)

	for i, v6 in ipairs(PreAuthDeepLinkMap) do
		local regexPattern = v6.regexPattern

		if string.match(v5, regexPattern) ~= nil then
			return true
		end
	end

	return false
end

local function firePreauthDeeplink(value, p2)
	if not value or value == "" then
		return nil
	end

	local v5 = string.lower(value)
	local v6 = User.fromLocalStorage().userId ~= -1

	for i, v7 in ipairs(PreAuthDeepLinkMap) do
		local regexPattern = v7.regexPattern

		if string.match(v5, regexPattern) ~= nil then
			if v7.preauthOnly and v6 then
				return nil
			end

			local v8 = parseQueryParams(value)
			return v7.handler(v8, p2)
		end
	end

	return nil
end

local function registerPatterns()
	for i, v5 in ipairs(PreAuthDeepLinkMap) do
		default:registerURL((v5.regexPattern:gsub("%%", "\\")))
	end
end

if require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnablePreAuthDeepLinkHandler") then
	registerPatterns()
end

return {
	isPreauthDeeplink = isPreauthDeeplink,
	firePreauthDeeplink = firePreauthDeeplink
}
