local ParentParent = script.Parent.Parent
local matchAllRegex = require(script.Parent.matchAllRegex)
local Cryo = require(ParentParent.Cryo)
local RegExp = require(ParentParent.RegExp)
local StringTrim = require(ParentParent.StringUtilities).StringTrim
local Regex = require(script.Parent.Regex)

require(script.Parent.Types)

local Constants = require(script.Parent.Constants)
local t1 = {
	protocolStrict = false,
	subdomainStrict = true,
	pathPatterns = nil,
	trimPunctuation = false,
	protocolPatterns = { "https?" },
	subdomainPatterns = { "www" },
	domainsPatterns = { Constants.ANY_DOMAIN_PATTERN }
}
local t2 = {}

t2.__index = t2

function t2.new(p1) -- line: 66
	-- upvalues: Cryo (copy), t1 (copy), Regex (copy), Constants (copy), RegExp (copy), t2 (copy)
	local v11 = Cryo.Dictionary.union(t1, p1 or {})
	local v12 = Regex.oneOf(v11.protocolPatterns) .. Regex.COLON .. Regex.SLASH .. Regex.SLASH
	local v13 = Regex.oneOf({
		Regex.negativeLookbehind(Regex.ALPHANUMERIC),
		v12
	})
	local v14 = Regex.negativeLookahead(v12)
	local v15 = Regex.oneOf(v11.subdomainPatterns) .. Regex.DOT
	local v16 = Regex.oneOf(v11.domainsPatterns)
	local v17 = v11.pathPatterns == nil and "" or Regex.oneOf(v11.pathPatterns)
	local v18 = Regex.zeroOrMore({ Regex.SLASH .. Regex.oneOrMore(v14 .. Constants.PATH_CHAR) }) .. Regex.zeroOrOneOf(Regex.SLASH)
	local v19 = Regex.zeroOrOneOf(Regex.QUESTION .. Regex.zeroOrMore(v14 .. Constants.QUERY_CHAR))
	local v20 = Regex.zeroOrOneOf(Regex.HASH .. Regex.zeroOrMore(v14 .. Constants.FRAGMENT_CHAR))
	local v21 = Regex.oneOf({
		Regex.lookahead(v12),
		Regex.negativeLookahead(Regex.ALPHANUMERIC),
		Regex.STRING_END
	})
	local v22 = Regex.capture((if not v11.protocolStrict then v13 else v12)) .. Regex.capture((if not v11.subdomainStrict then Regex.zeroOrOneOf(v15) else Regex.oneOf(v15))) .. Regex.capture(v16) .. Regex.capture(Regex.capture(v17) .. v18) .. Regex.capture(v19) .. Regex.capture(v20) .. v21
	local t3 = {
		_urlPattern = RegExp(v22, "m"),
		_trimPunctuation = v11.trimPunctuation,
		match = t2.match
	}

	setmetatable(t3, t2)

	return t3
end
function t2.default() -- line: 108
	-- upvalues: t2 (copy), t1 (copy)
	return t2.new(t1)
end
function t2.match(t4: {[any]: any}, s1: string) -- line: 119
	-- upvalues: matchAllRegex (copy), StringTrim (copy)
	local t5 = {}
	local n1 = 0
	local ok, result = pcall(function() -- line: 122
		-- upvalues: matchAllRegex (copy), s1 (copy), t4 (copy), n1 (ref), StringTrim (copy), t5 (copy)
		for _, v31 in (matchAllRegex(s1:lower(), t4._urlPattern)) do
			local v32 = v31
			local v33 = n1 + v32.index
			local v34 = v33 + #v32.matchedText - 1

			n1 = v34

			if t4._trimPunctuation and not v32.matchedText:match("%b()$") then
				local v35 = StringTrim(v32.matchedText, "%?%.%!%,%;%:%(%)", {
					right = true
				})

				if v35 ~= v32.matchedText then
					v32 = matchAllRegex(v35, t4._urlPattern)[1]
				end

				v34 = v33 + #v35 - 1
			end

			local v36, v37, v38, v39, v40, v41, v42 = unpack(v32.capturedGroups)
			local v43 = s1:sub(v33, v34)
			local v44 = #v36 + 1 + #v37 + #v38
			local v45 = v44 + #v39
			local v46 = v45 + #v41
			local v47 = v43:sub(v44, v45 - 1)
			local v48 = v43:sub(v45, v46 - 1)
			local v49 = v43:sub(v46, v46 + #v42 - 1)

			table.insert(t5, {
				startIndex = v33,
				endIndex = v34,
				matchedPath = v40,
				url = {
					fullText = v43,
					protocol = StringTrim(v36, ":/", {
						right = true
					}),
					subdomain = StringTrim(v37, ".", {
						right = true
					}),
					domain = v38,
					path = v47,
					query = if v48 == "" then nil else StringTrim(v48, "?", {
						left = true
					}),
					fragment = if v49 == "" then nil else StringTrim(v49, "#", {
						left = true
					})
				}
			})
		end

		return t5
	end)

	if not ok then
		warn("UrlMatcher:match failed: " .. tostring(result))

		return {}
	end

	return result or {}
end

return t2
