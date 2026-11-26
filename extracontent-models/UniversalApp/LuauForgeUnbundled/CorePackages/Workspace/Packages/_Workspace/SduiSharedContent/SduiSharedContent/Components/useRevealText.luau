local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local function getDelimiter(p2)
	if p2 == nil or p2 == "" then
		return " "
	end

	return p2
end

local function getRevealInterval(p2)
	if p2 == nil then
		return 0.05
	end

	return (math.max(p2, 0))
end

local function shouldRenderDelimiter(p2): boolean
	return not p2
end

local function getTagName(value, p2)
	return string.match(value, p2 and "^<%s*/%s*([%w]+)" or "^<%s*([%w]+)")
end

local function isSelfClosingTag(value, p2): boolean
	return p2 == "br" or string.match(value, "/%s*>$") ~= nil
end

local function removeLastMatchingTag(list, p2)
	for i = #list, 1, -1 do
		if list[i] == p2 then
			table.remove(list, i)
			break
		end
	end
end

local function buildBalancedText(list, list2)
	local balancedText = table.concat(list)

	for i = #list2, 1, -1 do
		balancedText ..= `</{list2[i]}>`
	end

	return balancedText
end

local function appendFrame(list, list2, list3)
	local v5 = table.concat(list2)

	for i = #list3, 1, -1 do
		v5 ..= `</{list3[i]}>`
	end

	if v5 ~= list[#list] then
		table.insert(list, v5)
	end
end

local function buildRevealTextFrames(text, delimiter, richText, removeDelimiter)
	if text == nil or text == "" then
		return { text or "" }
	end

	local v5 = (delimiter == nil or delimiter == "") and " " or delimiter

	local v6 = #text
	local count = #v5
	local v7 = 1
	local flag = false
	local v8 = {}
	local v9 = {}
	local result = {}

	while v7 <= v6 do
		local v10 = false

		if count > 0 and string.sub(text, v7, v7 + count - 1) == v5 then
			if flag then
				local v11 = table.concat(v8)

				for i = #v9, 1, -1 do
					v11 ..= `</{v9[i]}>`
				end

				if v11 ~= result[#result] then
					table.insert(result, v11)
				end

				flag = false
			end

			if not removeDelimiter then
				table.insert(v8, v5)
			end

			v7 += count
			v10 = true
		elseif richText and string.sub(text, v7, v7) == "<" then
			local v11 = string.find(text, ">", v7, true)

			if v11 then
				local v12 = string.sub(text, v7, v11)
				table.insert(v8, v12)

				local v13 = string.sub(v12, 1, 2) == "</"
				local v14 = string.match(v12, v13 and "^<%s*/%s*([%w]+)" or "^<%s*([%w]+)")

				if v14 then
					if v13 then
						removeLastMatchingTag(v9, v14)
					elseif v14 ~= "br" and string.match(v12, "/%s*>$") == nil then
						table.insert(v9, v14)
					end
				end

				v7 = v11 + 1
				v10 = true
			end
		end

		if v10 then
			continue
		end

		table.insert(v8, (string.sub(text, v7, v7)))

		v7 += 1
		flag = true
	end

	local v10 = table.concat(v8)

	for i = #v9, 1, -1 do
		v10 ..= `</{v9[i]}>`
	end

	if v10 ~= result[#result] then
		table.insert(result, v10)
	end

	return result
end

local function useRevealText(data)
	local text = data.text
	local delimiter = data.delimiter
	local removeDelimiter = data.removeDelimiter
	local richText = data.richText
	local revealInterval = data.revealInterval

	local v5 = React.useMemo(function()
		return buildRevealTextFrames(text, delimiter, richText, removeDelimiter)
	end, { text, delimiter, richText, removeDelimiter })
	local v6 = revealInterval == nil and 0.05 or math.max(revealInterval, 0)

	local useState = React.useState
	local v7 = if v6 == 0 then v5[#v5] else v5[1]
	local state, setState = useState(v7)

	React.useEffect(function()
		local thread = task.spawn(function()
			if v6 == 0 then
				setState(v5[#v5])
				return
			end

			setState(v5[1])

			for i = 2, #v5 do
				task.wait(v6)
				setState(v5[i])
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { v5, v6 })

	return state
end

return useRevealText
