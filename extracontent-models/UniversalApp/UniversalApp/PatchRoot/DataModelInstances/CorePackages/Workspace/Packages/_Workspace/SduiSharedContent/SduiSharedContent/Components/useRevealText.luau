local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)

local function getDelimiter(s1: string?) -- line: 17
	if s1 == nil or s1 == "" then
		return " "
	end

	return s1
end
local function getRevealInterval(n1: number?) -- line: 24
	if n1 == nil then
		return 0.05
	end

	return (math.max(n1, 0))
end
local function shouldRenderDelimiter(b1: boolean?) -- line: 31
	return not b1
end
local function getTagName(s2: string, b2: boolean) -- line: 35
	local v18 = not b2 and "^<%s*([%w]+)" or "^<%s*/%s*([%w]+)"

	return string.match(s2, v18)
end
local function isSelfClosingTag(s3: string, s4: string?) -- line: 40
	return s4 == "br" or string.match(s3, "/%s*>$") ~= nil
end
local function removeLastMatchingTag(t1: {[any]: any}, s5: string) -- line: 44
	for i = #t1, 1, -1 do
		if s5 == t1[i] then
			table.remove(t1, i)

			return
		end
	end
end
local function buildBalancedText(t2: {[any]: any}, t3: {[any]: any}) -- line: 53
	local v26 = table.concat(t2)

	for i = #t3, 1, -1 do
		v26 ..= ("</%*>"):format(t3[i])
	end

	return v26
end
local function appendFrame(t4: {[any]: any}, t5: {[any]: any}, t6: {[any]: any}) -- line: 61
	local v31 = table.concat(t5)

	for i = #t6, 1, -1 do
		v31 ..= ("</%*>"):format(t6[i])
	end

	if v31 ~= t4[#t4] then
		table.insert(t4, v31)
	end
end
local function buildRevealTextFrames(s6: string?, s7: string?, b3: boolean?, b4: boolean?) -- line: 68
	-- upvalues: removeLastMatchingTag (copy)
	if s6 == nil or s6 == "" then
		return { s6 or "" }
	end

	local v37 = if s7 ~= nil and s7 ~= "" then s7 else " "
	local t7 = {}
	local t8 = {}
	local t9 = {}
	local v41 = false
	local n2 = 1
	local v43 = #s6
	local v44 = #v37

	while n2 <= v43 do
		local v45 = false

		if v44 > 0 and v37 == string.sub(s6, n2, n2 + v44 - 1) then
			if v41 then
				local v46 = table.concat(t8)

				for i = #t9, 1, -1 do
					v46 ..= ("</%*>"):format(t9[i])
				end

				if v46 ~= t7[#t7] then
					table.insert(t7, v46)
				end

				v41 = false
			end

			if not b4 then
				table.insert(t8, v37)
			end

			n2 += v44
			v45 = true
		elseif b3 and string.sub(s6, n2, n2) == "<" then
			local v48 = string.find(s6, ">", n2, true)

			if v48 then
				local v49 = string.sub(s6, n2, v48)

				table.insert(t8, v49)

				local v50 = string.sub(v49, 1, 2) == "</"
				local v51 = not v50 and "^<%s*([%w]+)" or "^<%s*/%s*([%w]+)"
				local match = string.match(v49, v51)

				if match then
					if v50 then
						removeLastMatchingTag(t9, match)
					elseif match ~= "br" and string.match(v49, "/%s*>$") == nil then
						table.insert(t9, match)
					end
				end

				n2 = v48 + 1
				v45 = true
			end
		end

		if not v45 then
			table.insert(t8, (string.sub(s6, n2, n2)))
			v41 = true
			n2 += 1
		end
	end

	local v53 = table.concat(t8)

	for i = #t9, 1, -1 do
		v53 ..= ("</%*>"):format(t9[i])
	end

	if v53 ~= t7[#t7] then
		table.insert(t7, v53)
	end

	return t7
end
local function useRevealText(t10: {[any]: any}) -- line: 133
	-- upvalues: React (copy), buildRevealTextFrames (copy)
	local text = t10.text
	local delimiter = t10.delimiter
	local removeDelimiter = t10.removeDelimiter
	local richText = t10.richText
	local revealInterval = t10.revealInterval
	local v61 = React.useMemo(function() -- line: 140
		-- upvalues: buildRevealTextFrames (copy), text (copy), delimiter (copy), richText (copy), removeDelimiter (copy)
		return (buildRevealTextFrames(text, delimiter, richText, removeDelimiter))
	end, {
		text,
		delimiter,
		richText,
		removeDelimiter
	})
	local v62 = if revealInterval ~= nil then math.max(revealInterval, 0) else 0.05
	local v63, v64 = React.useState(if v62 ~= 0 then v61[1] else v61[#v61])

	React.useEffect(function() -- line: 147
		-- upvalues: v62 (copy), v64 (copy), v61 (copy)
		local thread = task.spawn(function() -- line: 148
			-- upvalues: v62 (copy), v64 (copy), v61 (copy)
			if v62 == 0 then
				v64(v61[#v61])

				return
			end

			v64(v61[1])

			for i = 2, #v61 do
				task.wait(v62)
				v64(v61[i])
			end
		end)

		return function() -- line: 162
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v61,
		v62
	})

	return v63
end

return useRevealText
