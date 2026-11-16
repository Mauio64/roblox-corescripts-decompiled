local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)

local function getDelimiter(p: string?) -- 1 equivalent call inferred from this helper
	return if p == nil or p == "" then " " else p
end

local function getRevealInterval(revealInterval: number?) -- 1 equivalent call inferred from this helper
	if revealInterval == nil then
		return 0.05
	end

	return (math.max(revealInterval, 0))
end

local function shouldRenderDelimiter(flag: boolean?): boolean
	return not flag
end

local function getTagName(value: string, flag: boolean) -- 1 equivalent call inferred from this helper
	return string.match(value, flag and "^<%s*/%s*([%w]+)" or "^<%s*([%w]+)")
end

local function isSelfClosingTag(value: string, p: string?): boolean
	return p == "br" or string.match(value, "/%s*>$") ~= nil
end

local function removeLastMatchingTag(tagNames, tagName: string)
	for i = #tagNames, 1, -1 do
		if tagNames[i] == tagName then
			table.remove(tagNames, i)
			break
		end
	end
end

local function buildBalancedText(list, list2) -- 1 equivalent call inferred from this helper
	local balancedText = table.concat(list)

	for i = #list2, 1, -1 do
		balancedText ..= `</{list2[i]}>`
	end

	return balancedText
end

local function appendFrame(balancedTexts, list, tagNames) -- 2 equivalent calls inferred from this helper
	local balancedText = buildBalancedText(list, tagNames) -- inferred equivalent call

	if balancedText ~= balancedTexts[#balancedTexts] then
		table.insert(balancedTexts, balancedText)
	end
end

local function buildRevealTextFrames(text: string?, delimiter: string?, richText: boolean?, removeDelimiter: boolean?)
	if text == nil or text == "" then
		return { text or "" }
	end

	local delimiter2 = getDelimiter(delimiter) -- inferred equivalent call
	local v = #text
	local count = #delimiter2
	local v2 = 1
	local flag = false
	local v3 = {}
	local tagNames = {}
	local v4 = {}

	while v2 <= v do
		local v5 = false

		if count > 0 and string.sub(text, v2, v2 + count - 1) == delimiter2 then
			if flag then
				appendFrame(v4, v3, tagNames) -- inferred equivalent call
				flag = false
			end

			if not removeDelimiter then
				table.insert(v3, delimiter2)
			end

			v2 += count
			v5 = true
		elseif richText and string.sub(text, v2, v2) == "<" then
			local v6 = string.find(text, ">", v2, true)

			if v6 then
				local v7 = string.sub(text, v2, v6)
				table.insert(v3, v7)

				local v8 = string.sub(v7, 1, 2) == "</"
				local tagName = getTagName(v7, v8) -- inferred equivalent call

				if tagName then
					if v8 then
						removeLastMatchingTag(tagNames, tagName)
					elseif tagName ~= "br" and string.match(v7, "/%s*>$") == nil then
						table.insert(tagNames, tagName)
					end
				end

				v2 = v6 + 1
				v5 = true
			end
		end

		if v5 then
			continue
		end

		table.insert(v3, (string.sub(text, v2, v2)))

		v2 += 1
		flag = true
	end

	appendFrame(v4, v3, tagNames) -- inferred equivalent call
	return v4
end

local function useRevealText(data)
	local text = data.text
	local delimiter = data.delimiter
	local removeDelimiter = data.removeDelimiter
	local richText = data.richText
	local revealInterval = data.revealInterval

	local v = React.useMemo(function()
		return buildRevealTextFrames(text, delimiter, richText, removeDelimiter)
	end, { text, delimiter, richText, removeDelimiter })
	local revealInterval2 = getRevealInterval(revealInterval) -- inferred equivalent call
	local useState = React.useState
	local v2

	if revealInterval2 == 0 then
		v2 = v[#v]
	else
		v2 = v[1]
	end

	local state, setState = useState(v2)

	React.useEffect(function()
		local thread = task.spawn(function()
			if revealInterval2 == 0 then
				setState(v[#v])
				return
			end

			setState(v[1])

			for i = 2, #v do
				task.wait(revealInterval2)
				setState(v[i])
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { v, revealInterval2 })

	return state
end

return useRevealText
