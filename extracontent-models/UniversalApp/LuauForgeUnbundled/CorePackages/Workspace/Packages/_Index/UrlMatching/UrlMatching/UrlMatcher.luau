local matchAllRegex = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/matchAllRegex")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/Cryo")
local RegExp = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/RegExp")

local stringTrim = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/StringUtilities").StringTrim

local Regex = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Regex")
require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Constants")

local v5 = {
	protocolPatterns = { "https?" },
	protocolStrict = false,
	subdomainPatterns = { "www" },
	subdomainStrict = true,
	domainsPatterns = { Constants.ANY_DOMAIN_PATTERN },
	pathPatterns = nil,
	trimPunctuation = false
}

local class = {}
class.__index = class

function class.new(options)
	local union = Cryo.Dictionary.union(v5, options or {})

	local v6 = Regex.oneOf(union.protocolPatterns) .. Regex.COLON .. Regex.SLASH .. Regex.SLASH
	local v7 = Regex.oneOf({ Regex.negativeLookbehind(Regex.ALPHANUMERIC), v6 })
	local negativeLookahead = Regex.negativeLookahead(v6)

	local v8 = Regex.oneOf(union.subdomainPatterns) .. Regex.DOT
	local one = Regex.oneOf(union.domainsPatterns)

	local v9 = union.pathPatterns == nil and "" or Regex.oneOf(union.pathPatterns)
	local v10 = Regex.zeroOrMore({ Regex.SLASH .. Regex.oneOrMore(negativeLookahead .. Constants.PATH_CHAR) }) .. Regex.zeroOrOneOf(Regex.SLASH)

	local zeroOrOne = Regex.zeroOrOneOf(Regex.QUESTION .. Regex.zeroOrMore(negativeLookahead .. Constants.QUERY_CHAR))
	local zeroOrOne2 = Regex.zeroOrOneOf(Regex.HASH .. Regex.zeroOrMore(negativeLookahead .. Constants.FRAGMENT_CHAR))

	local one2 = Regex.oneOf({
		Regex.lookahead(v6),
		Regex.negativeLookahead(Regex.ALPHANUMERIC),
		Regex.STRING_END
	})

	local capture = Regex.capture

	if union.protocolStrict then
		v7 = v6
	end

	local v11 = capture(v7)
	local capture2 = Regex.capture
	local v12 = if union.subdomainStrict then Regex.oneOf(v8) else Regex.zeroOrOneOf(v8)
	local v14 = {
		_urlPattern = RegExp(
			v11 .. capture2(v12) .. Regex.capture(one) .. Regex.capture(Regex.capture(v9) .. v10) .. Regex.capture(zeroOrOne) .. Regex.capture(zeroOrOne2) .. one2,
			"m"
		),
		_trimPunctuation = union.trimPunctuation,
		match = class.match
	}

	setmetatable(v14, class)
	return v14
end

function class.default()
	return class.new(v5)
end

function class:match(value)
	local v6 = {}
	local v7 = 0
	local success, result = pcall(function()
		local v8 = matchAllRegex(value:lower(), self._urlPattern)

		for k, v9 in v8 do
			local v10 = v7 + v9.index
			local v11 = v10 + #v9.matchedText - 1
			v7 = v11

			if self._trimPunctuation and not v9.matchedText:match("%b()$") then
				local v12 = stringTrim(v9.matchedText, "%?%.%!%,%;%:%(%)", {
					right = true
				})

				if v12 ~= v9.matchedText then
					v9 = matchAllRegex(v12, self._urlPattern)[1]
				end

				v11 = v10 + #v12 - 1
			end

			local v12, v13, v14, v15, v16, v17, v18 = unpack(v9.capturedGroups)
			local v19 = value:sub(v10, v11)
			local v20 = #v12 + 1 + #v13 + #v14
			local v21 = v20 + #v15
			local v22 = v21 + #v17
			local v23 = v19:sub(v20, v21 - 1)
			local v24 = v19:sub(v21, v22 - 1)
			local v25 = v19:sub(v22, v22 + #v18 - 1)

			local v28 = {
				fullText = v19,
				protocol = stringTrim(v12, ":/", { right = true }),
				subdomain = stringTrim(v13, ".", { right = true }),
				domain = v14,
				path = v23,
				query = 0,
				fragment = 0
			}

			local v29 = if v24 ~= "" then stringTrim(v24, "?", { left = true }) else nil
			v28.query = v29
			local v30 = if v25 ~= "" then stringTrim(v25, "#", { left = true }) else nil
			v28.fragment = v30
			table.insert(v6, {
				startIndex = v10,
				endIndex = v11,
				matchedPath = v16,
				url = v28
			})
		end

		return v6
	end)

	if success then
		return result or {}
	end

	warn("UrlMatcher:match failed: " .. tostring(result))
	return {}
end

return class
