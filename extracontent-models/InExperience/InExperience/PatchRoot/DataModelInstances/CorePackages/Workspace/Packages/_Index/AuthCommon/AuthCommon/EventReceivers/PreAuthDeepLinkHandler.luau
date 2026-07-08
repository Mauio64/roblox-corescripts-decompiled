local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local User = require(AuthCommon.Thunks.User)
local default = require(AuthCommonParent.LinkingProtocol).LinkingProtocol.default
local PreAuthDeepLinkMap = require(script.Parent.PreAuthDeepLinkMap)

local function parseQueryParams(s1: string) -- line: 50
	local t1 = {}
	local _, stop = string.find(s1, "?")

	if not stop then
		return t1
	end

	local v14 = string.sub(s1, stop + 1)

	for match in string.gmatch(v14, "[^&]+") do
		local v16, v17 = string.match(match, "([^=]+)=?(.*)")

		if v16 then
			t1[string.lower(v16)] = v17 or ""
		end
	end

	return t1
end
local function matchesPattern(s2: string, s3: string) -- line: 70
	return string.match(s3, s2) ~= nil
end
local function userIsAuthenticated() -- line: 74
	-- upvalues: User (copy)
	return User.fromLocalStorage().userId ~= -1
end
local function registerPatterns() -- line: 117
	-- upvalues: PreAuthDeepLinkMap (copy), default (copy)
	for _, v in ipairs(PreAuthDeepLinkMap) do
		local v35 = v.regexPattern:gsub("%%", "\\")

		default:registerURL(v35)
	end
end

if require(AuthCommon.Flags.FFlagEnablePreAuthDeepLinkHandler) then
	registerPatterns()
end

return {
	isPreauthDeeplink = function(s4: string) -- line: 78
		-- upvalues: PreAuthDeepLinkMap (copy)
		if not s4 or s4 == "" then
			return false
		end

		local v21 = string.lower(s4)

		for _, v in ipairs(PreAuthDeepLinkMap) do
			local regexPattern = v.regexPattern

			if string.match(v21, regexPattern) ~= nil then
				return true
			end
		end

		return false
	end,
	firePreauthDeeplink = function(s5: string, t2: {[any]: any}) -- line: 94
		-- upvalues: User (copy), PreAuthDeepLinkMap (copy), parseQueryParams (copy)
		if not s5 or s5 == "" then
			return nil
		end

		local v27 = string.lower(s5)
		local v28 = User.fromLocalStorage().userId ~= -1

		for _, v in ipairs(PreAuthDeepLinkMap) do
			local regexPattern = v.regexPattern

			if string.match(v27, regexPattern) ~= nil then
				if v.preauthOnly and v28 then
					return nil
				end

				local v32 = parseQueryParams(s5)

				return v.handler(v32, t2)
			end
		end

		return nil
	end
}
