local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local User = require(AuthCommon.Thunks.User)

local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default

local PreAuthDeepLinkMap = require(script.Parent.PreAuthDeepLinkMap)

local FFlagEnablePreAuthDeepLinkHandler = require(AuthCommon.Flags.FFlagEnablePreAuthDeepLinkHandler)

local function parseQueryParams(value: string)
	local queryParams = {}
	local _, v = string.find(value, "?")

	if not v then
		return queryParams
	end

	local v2 = string.sub(value, v + 1)

	for k in string.gmatch(v2, "[^&]+") do
		local v3, v4 = string.match(k, "([^=]+)=?(.*)")

		if v3 then
			queryParams[string.lower(v3)] = v4 or ""
		end
	end

	return queryParams
end

local function matchesPattern(regexPattern: string, value: string): boolean -- 2 equivalent calls inferred from this helper
	return string.match(value, regexPattern) ~= nil
end

local function userIsAuthenticated(): boolean -- 1 equivalent call inferred from this helper
	return User.fromLocalStorage().userId ~= -1
end

local function isPreauthDeeplink(value: string): boolean
	if not value or value == "" then
		return false
	end

	local v = string.lower(value)

	for _, preAuthDeepLink in ipairs(PreAuthDeepLinkMap) do
		if matchesPattern(preAuthDeepLink.regexPattern, v) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function firePreauthDeeplink(value: string, p)
	if not value or value == "" then
		return nil
	end

	local v = string.lower(value)
	local v2 = userIsAuthenticated() -- inferred equivalent call

	for _, preAuthDeepLink in ipairs(PreAuthDeepLinkMap) do
		if matchesPattern(preAuthDeepLink.regexPattern, v) then -- inferred equivalent call
			if preAuthDeepLink.preauthOnly and v2 then
				return nil
			end

			local v3 = parseQueryParams(value)
			return preAuthDeepLink.handler(v3, p)
		end
	end

	return nil
end

local function registerPatterns()
	for _, preAuthDeepLink in ipairs(PreAuthDeepLinkMap) do
		default:registerURL((preAuthDeepLink.regexPattern:gsub("%%", "\\")))
	end
end

if FFlagEnablePreAuthDeepLinkHandler then
	registerPatterns()
end

return { isPreauthDeeplink = isPreauthDeeplink, firePreauthDeeplink = firePreauthDeeplink }
