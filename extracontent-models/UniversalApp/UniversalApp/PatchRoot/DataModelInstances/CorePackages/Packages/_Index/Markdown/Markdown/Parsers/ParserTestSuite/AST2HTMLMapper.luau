local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local t1 = {}
local t2 = {}

local function sanitize(s1: string) -- line: 8
	return s1:gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub(" *\n *", "\n")
end
local function urlEncode(s2: string) -- line: 21
	return string.gsub(s2, "([^%w_%%%-%.%*%?%(%)#~/:=])", function(p1) -- line: 22
		return string.format("%%%02X", string.byte(p1))
	end)
end
local function map(p2) -- line: 27
	-- upvalues: t2 (ref)
	local v27 = t2[p2.name]

	if v27 then
		return v27(p2)
	end

	error(`No handler found for node { p2.name }`)
end
local function processChildren(t3: {[any]: any}) -- line: 36
	-- upvalues: t2 (ref)
	if not t3 then
		return ""
	end

	local s3 = ""

	for _, v31 in t3 do
		local v32 = t2[v31.name]
		local v33

		if v32 then
			v33 = v32(v31)
		else
			error(`No handler found for node { v31.name }`)
			v33 = nil
		end

		s3 ..= v33
	end

	return s3
end
local function handleRoot(p3) -- line: 48
	-- upvalues: t2 (ref)
	local children = p3.children

	if not children then
		return ""
	end

	local s4 = ""

	for _, v38 in children do
		local v39 = t2[v38.name]
		local v40

		if v39 then
			v40 = v39(v38)
		else
			error(`No handler found for node { v38.name }`)
			v40 = nil
		end

		s4 ..= v40
	end

	return s4
end
local function handleHeading(p4) -- line: 52
	-- upvalues: t2 (ref)
	local v42 = not p4.attributes and 1 or p4.attributes.depth
	local children = p4.children
	local s5

	if not children then
		s5 = ""
	else
		s5 = ""

		for _, v46 in children do
			local v47 = t2[v46.name]
			local v48

			if v47 then
				v48 = v47(v46)
			else
				error(`No handler found for node { v46.name }`)
				v48 = nil
			end

			s5 ..= v48
		end
	end

	return `<h{ v42 }>{ s5 }</h{ v42 }>\n`
end
local function handleParagraph(p5) -- line: 57
	-- upvalues: t2 (ref)
	local children = p5.children
	local s6

	if not children then
		s6 = ""
	else
		s6 = ""

		for _, v53 in children do
			local v54 = t2[v53.name]
			local v55

			if v54 then
				v55 = v54(v53)
			else
				error(`No handler found for node { v53.name }`)
				v55 = nil
			end

			s6 ..= v55
		end
	end

	return `<p>{ s6:gsub("^ +", ""):gsub(" +$", "") }</p>\n`
end
local function handleThematicBreak() -- line: 61
	return "<hr />\n"
end
local function handleBlockquote(p6) -- line: 65
	-- upvalues: t2 (ref)
	local children = p6.children
	local s7

	if not children then
		s7 = ""
	else
		s7 = ""

		for _, v60 in children do
			local v61 = t2[v60.name]
			local v62

			if v61 then
				v62 = v61(v60)
			else
				error(`No handler found for node { v60.name }`)
				v62 = nil
			end

			s7 ..= v62
		end
	end

	return `<blockquote>\n{ s7 }</blockquote>\n`
end
local function handleCodeBlock(p7) -- line: 69
	local t4 = {}

	if p7.attributes and (p7.attributes.language and p7.attributes.language ~= "") then
		table.insert(t4, "language-" .. p7.attributes.language)
	end

	local t5 = {}

	if #t4 > 0 then
		table.insert(t5, `class="{ table.concat(t4, " ") }"`)
	end

	return `<pre><code{ not (#t5 > 0) and "" or ` { table.concat(t5, " ") }` }>{ p7.text }</code></pre>\n`
end
local function handleList(p8) -- line: 81
	-- upvalues: t2 (ref)
	local v67 = not p8.attributes and "ul" or (not p8.attributes.ordered and "ul" or "ol")
	local children = p8.children
	local s8

	if not children then
		s8 = ""
	else
		s8 = ""

		for _, v71 in children do
			local v72 = t2[v71.name]
			local v73

			if v72 then
				v73 = v72(v71)
			else
				error(`No handler found for node { v71.name }`)
				v73 = nil
			end

			s8 ..= v73
		end
	end

	return `<{ v67 }>\n{ s8 }</{ v67 }>\n`
end
local function handleListItem(p9) -- line: 86
	-- upvalues: t2 (ref)
	local children = p9.children
	local s9

	if not children then
		s9 = ""
	else
		s9 = ""

		for _, v78 in children do
			local v79 = t2[v78.name]
			local v80

			if v79 then
				v80 = v79(v78)
			else
				error(`No handler found for node { v78.name }`)
				v80 = nil
			end

			s9 ..= v80
		end
	end

	return `<li>{ s9 }</li>\n`
end
local function handleStyledText(p10) -- line: 90
	-- upvalues: t2 (ref)
	local v82 = if not p10.attributes then nil else p10.attributes.style

	if v82 == "BOLD" or v82 == "ITALIC" then
		local children = p10.children
		local s10

		if not children then
			s10 = ""
		else
			s10 = ""

			for _, v86 in children do
				local v87 = t2[v86.name]
				local v88

				if v87 then
					v88 = v87(v86)
				else
					error(`No handler found for node { v86.name }`)
					v88 = nil
				end

				s10 ..= v88
			end
		end

		return `<em>{ s10 }</em>`
	end

	if v82 == "BOLD_2" or v82 == "ITALIC_2" then
		local children = p10.children
		local s11

		if not children then
			s11 = ""
		else
			s11 = ""

			for _, v92 in children do
				local v93 = t2[v92.name]
				local v94

				if v93 then
					v94 = v93(v92)
				else
					error(`No handler found for node { v92.name }`)
					v94 = nil
				end

				s11 ..= v94
			end
		end

		return `<strong>{ s11 }</strong>`
	end

	if v82 == "STRIKE" then
		local children = p10.children
		local s12

		if not children then
			s12 = ""
		else
			s12 = ""

			for _, v98 in children do
				local v99 = t2[v98.name]
				local v100

				if v99 then
					v100 = v99(v98)
				else
					error(`No handler found for node { v98.name }`)
					v100 = nil
				end

				s12 ..= v100
			end
		end

		return `<u>{ s12 }</u>`
	end

	if v82 == "INLINE_CODE" then
		local children = p10.children
		local s13

		if not children then
			s13 = ""
		else
			s13 = ""

			for _, v104 in children do
				local v105 = t2[v104.name]
				local v106

				if v105 then
					v106 = v105(v104)
				else
					error(`No handler found for node { v104.name }`)
					v106 = nil
				end

				s13 ..= v106
			end
		end

		return `<code>{ s13 }</code>`
	end

	if v82 == nil then
		local children = p10.children

		if not children then
			return ""
		end

		local s14 = ""

		for _, v110 in children do
			local v111 = t2[v110.name]
			local v112

			if v111 then
				v112 = v111(v110)
			else
				error(`No handler found for node { v110.name }`)
				v112 = nil
			end

			s14 ..= v112
		end

		return s14
	end

	error(`Unknown text style { v82 }`)
end
local function handleText(p11) -- line: 107
	-- upvalues: sanitize (copy)
	return sanitize(p11.text or "")
end
local function handleLink(p12) -- line: 111
	-- upvalues: t2 (ref), sanitize (copy)
	local v115 = p12.attributes and p12.attributes.url or (p12.url or "")
	local v116 = p12.attributes and p12.attributes.title or nil
	local children = p12.children
	local s15

	if not children then
		s15 = ""
	else
		s15 = ""

		for _, v120 in children do
			local v121 = t2[v120.name]
			local v122

			if v121 then
				v122 = v121(v120)
			else
				error(`No handler found for node { v120.name }`)
				v122 = nil
			end

			s15 ..= v122
		end
	end

	if s15 == "" and p12.text then
		s15 = sanitize(p12.text)
	end

	return `<a href="{ string.gsub(v115, "([^%w_%%%-%.%*%?%(%)#~/:=])", function(p13) -- line: 22
		return string.format("%%%02X", string.byte(p13))
	end) }"{ not v116 and "" or ` title="{ sanitize(v116) }"` }>{ s15 }</a>`
end
local function handleTag(p14) -- line: 123
	-- upvalues: t2 (ref)
	local text = p14.text

	if not text or text == "" then
		error("TAG node must have a text value")
	end

	local s16 = ""

	if p14.attributes then
		for v126, v127 in p14.attributes do
			s16 = `{ s16 } { v126 }="{ v127 }"`
		end
	end

	if p14.children and #p14.children > 0 then
		local children = p14.children
		local s17

		if not children then
			s17 = ""
		else
			s17 = ""

			for _, v131 in children do
				local v132 = t2[v131.name]
				local v133

				if v132 then
					v133 = v132(v131)
				else
					error(`No handler found for node { v131.name }`)
					v133 = nil
				end

				s17 ..= v133
			end
		end

		return `<{ text }{ s16 }>{ s17 }</{ text }>`
	end

	return `<{ text }{ s16 } />`
end
local function handleLineBreak() -- line: 141
	return "<br />"
end
local function handleBreak() -- line: 145
	return "<br />\n"
end
local function handleImage(p15) -- line: 149
	-- upvalues: sanitize (copy)
	local v135 = p15.attributes and p15.attributes.url or (p15.url or "")
	local v136 = p15.text or ""

	return `<img src="{ string.gsub(v135, "([^%w_%%%-%.%*%?%(%)#~/:=])", function(p16) -- line: 22
		return string.format("%%%02X", string.byte(p16))
	end) }" alt="{ sanitize(v136) }" />`
end
local function emptyHandler(p17) -- line: 155
	-- upvalues: t2 (ref)
	local children = p17.children

	if not children then
		return ""
	end

	local s18 = ""

	for _, v141 in children do
		local v142 = t2[v141.name]
		local v143

		if v142 then
			v143 = v142(v141)
		else
			error(`No handler found for node { v141.name }`)
			v143 = nil
		end

		s18 ..= v143
	end

	return s18
end

t2 = {
	ROOT = handleRoot,
	HEADING = handleHeading,
	PARAGRAPH = handleParagraph,
	TEXT = handleText,
	STYLED_TEXT = handleStyledText,
	DIVIDER = handleThematicBreak,
	QUOTE = handleBlockquote,
	CODE_BLOCK = handleCodeBlock,
	LIST = handleList,
	LIST_ITEM = handleListItem,
	LINK = handleLink,
	TAG = handleTag,
	LINE_BREAK = handleLineBreak,
	BREAK = handleBreak,
	IMAGE = handleImage,
	TABLE_HEADER = emptyHandler,
	TABLE_ROW = emptyHandler,
	ACTION = emptyHandler
}

function t1.map(p18) -- line: 181
	-- upvalues: map (copy)
	return map(p18)
end

return t1
