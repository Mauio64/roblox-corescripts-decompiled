local InlineRichText = script:FindFirstAncestor("InlineRichText")

require(InlineRichText.Types)

local TokenName = require(InlineRichText.Enums.TokenName)
local parseXmlAttributes = require(InlineRichText.Parser.parseXmlAttributes)
local escapeRichFormatting = require(InlineRichText.Utils.escapeRichFormatting)
local _ = {
	Open = "OPEN",
	Close = "CLOSE",
	OpenClose = "OPEN_CLOSE"
}
local t1 = {
	{
		name = "OPEN_CLOSE",
		pattern = "^<([%w-]+)%s?([^>]*)/>"
	},
	{
		name = "OPEN",
		pattern = "^<([%w-]+)%s?([^>]*)>"
	},
	{
		name = "CLOSE",
		pattern = "^</([%w-]+)%s?([^>]*)>"
	}
}
local t5 = {
	OPEN = function(t2: {[any]: any}, s1: string, s2: string) -- line: 32
		-- upvalues: parseXmlAttributes (copy), TokenName (copy)
		local v12 = parseXmlAttributes(s2)

		table.insert(t2, {
			name = TokenName.Open,
			text = s1,
			attributes = v12
		})
	end,
	CLOSE = function(t3: {[any]: any}, s3: string) -- line: 40
		-- upvalues: TokenName (copy)
		table.insert(t3, {
			name = TokenName.Close,
			text = s3,
			attributes = {}
		})
	end,
	OPEN_CLOSE = function(t4: {[any]: any}, s4: string, s5: string) -- line: 47
		-- upvalues: parseXmlAttributes (copy), TokenName (copy)
		local v18 = parseXmlAttributes(s5)

		table.insert(t4, {
			name = TokenName.Open,
			text = s4,
			attributes = v18
		})
		table.insert(t4, {
			name = TokenName.Close,
			text = s4,
			attributes = {}
		})
	end
}

local function tokenize(s6: string) -- line: 62
	-- upvalues: t1 (copy), TokenName (copy), escapeRichFormatting (copy), t5 (copy)
	local n1 = 0
	local n2 = 0
	local t6 = {}
	local v23 = string.gsub(s6, "\n+", " ")

	for match in string.gmatch(v23, "()<") do
		if not (match < n1) then
			n1 = match

			local v25 = false

			for _, v27 in t1 do
				local name = v27.name
				local pattern = v27.pattern
				local start, stop = string.find(v23, pattern, n1)

				if not start or not stop then
					continue
				end

				local t7 = { string.match(v23, pattern, n1) }
				local v33 = t7[1]
				local v34 = t7[2] or ""

				if v33 then
					if n1 ~= n2 then
						table.insert(t6, {
							name = TokenName.Text,
							text = escapeRichFormatting((string.sub(v23, n2, n1 - 1))),
							attributes = {}
						})
					end

					if v33 == "br" then
						if name == "OPEN" or name == "OPEN_CLOSE" then
							table.insert(t6, {
								text = "",
								name = TokenName.Break,
								attributes = {}
							})
						end
					else
						t5[name](t6, v33, v34)
					end

					n1 += stop - start + 1
					n2 = n1
					v25 = true

					break
				end
			end

			if not v25 then
				n1 += 1
			end
		end
	end

	local v35 = #v23 + 1

	if v35 ~= n2 then
		table.insert(t6, {
			name = TokenName.Text,
			text = escapeRichFormatting((string.sub(v23, n2, v35 - 1))),
			attributes = {}
		})
	end

	if t6[1] and t6[1].name == TokenName.Text and t6[1].text == "" then
		table.remove(t6, 1)
	end

	return t6
end

return tokenize
