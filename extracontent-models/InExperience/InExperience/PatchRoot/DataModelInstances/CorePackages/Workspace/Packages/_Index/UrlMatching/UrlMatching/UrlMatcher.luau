local parent = script.Parent.Parent

local matchAllRegex = require(script.Parent.matchAllRegex)
local Cryo = require(parent.Cryo)
local RegExp = require(parent.RegExp)

local StringUtilities = require(parent.StringUtilities)
local StringTrim = StringUtilities.StringTrim

local Regex = require(script.Parent.Regex)
require(script.Parent.Types)
local Constants = require(script.Parent.Constants)

local v = {
	protocolPatterns = { "https?" },
	protocolStrict = false,
	subdomainPatterns = { "www" },
	subdomainStrict = true,
	domainsPatterns = { Constants.ANY_DOMAIN_PATTERN },
	pathPatterns = nil,
	trimPunctuation = false
}

local UrlMatcher = {}
UrlMatcher.__index = UrlMatcher

function UrlMatcher.new(options)
	local union = Cryo.Dictionary.union(v, options or {})

	local v2 = Regex.oneOf(union.protocolPatterns) .. Regex.COLON .. Regex.SLASH .. Regex.SLASH
	local v3 = Regex.oneOf({ Regex.negativeLookbehind(Regex.ALPHANUMERIC), v2 })
	local negativeLookahead = Regex.negativeLookahead(v2)

	local v4 = Regex.oneOf(union.subdomainPatterns) .. Regex.DOT
	local one = Regex.oneOf(union.domainsPatterns)

	local v5 = union.pathPatterns == nil and "" or Regex.oneOf(union.pathPatterns)
	local v6 = Regex.zeroOrMore({ Regex.SLASH .. Regex.oneOrMore(negativeLookahead .. Constants.PATH_CHAR) }) .. Regex.zeroOrOneOf(Regex.SLASH)

	local zeroOrOne = Regex.zeroOrOneOf(Regex.QUESTION .. Regex.zeroOrMore(negativeLookahead .. Constants.QUERY_CHAR))
	local zeroOrOne2 = Regex.zeroOrOneOf(Regex.HASH .. Regex.zeroOrMore(negativeLookahead .. Constants.FRAGMENT_CHAR))

	local one2 = Regex.oneOf({ Regex.lookahead(v2), Regex.negativeLookahead(Regex.ALPHANUMERIC), Regex.STRING_END })

	local capture = Regex.capture

	if union.protocolStrict then
		v3 = v2
	end

	local v7 = capture(v3)
	local capture2 = Regex.capture
	local v8

	if union.subdomainStrict then
		v8 = Regex.oneOf(v4)
	else
		v8 = Regex.zeroOrOneOf(v4)
	end

	local v9 = {
		_urlPattern = RegExp(
			v7 .. capture2(v8) .. Regex.capture(one) .. Regex.capture(Regex.capture(v5) .. v6) .. Regex.capture(zeroOrOne) .. Regex.capture(zeroOrOne2) .. one2,
			"m"
		),
		_trimPunctuation = union.trimPunctuation,
		match = UrlMatcher.match
	}

	setmetatable(v9, UrlMatcher)
	return v9
end

function UrlMatcher.default()
	return UrlMatcher.new(v)
end

function UrlMatcher:match(value: string)
	local v2 = {}
	local v3 = 0
	local success, result = pcall(function()
		local v4 = matchAllRegex(value:lower(), self._urlPattern)

		for _, v5 in v4 do
			local startIndex = v3 + v5.index
			local endIndex = startIndex + #v5.matchedText - 1
			v3 = endIndex

			if self._trimPunctuation and not v5.matchedText:match("%b()$") then
				local stringTrim = StringTrim(v5.matchedText, "%?%.%!%,%;%:%(%)", { right = true })

				if stringTrim ~= v5.matchedText then
					v5 = matchAllRegex(stringTrim, self._urlPattern)[1]
				end

				endIndex = startIndex + #stringTrim - 1
			end

			local v6, v7, domain, v8, matchedPath, v9, v10 = unpack(v5.capturedGroups)
			local fullText = value:sub(startIndex, endIndex)
			local v11 = #v6 + 1 + #v7 + #domain
			local v12 = v11 + #v8
			local v13 = v12 + #v9
			local path = fullText:sub(v11, v12 - 1)
			local v14 = fullText:sub(v12, v13 - 1)
			local v15 = fullText:sub(v13, v13 + #v10 - 1)

			local url = {
				fullText = fullText,
				protocol = StringTrim(v6, ":/", { right = true }),
				subdomain = StringTrim(v7, ".", { right = true }),
				domain = domain,
				path = path,
				query = 0,
				fragment = 0
			}
			local query

			if v14 ~= "" then
				query = StringTrim(v14, "?", { left = true })
			end

			url.query = query
			local fragment

			if v15 ~= "" then
				fragment = StringTrim(v15, "#", { left = true })
			end

			url.fragment = fragment
			table.insert(v2, {
				startIndex = startIndex,
				endIndex = endIndex,
				matchedPath = matchedPath,
				url = url
			})
		end

		return v2
	end)

	if success then
		return result or {}
	end

	warn("UrlMatcher:match failed: " .. tostring(result))
	return {}
end

return UrlMatcher
