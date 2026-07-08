local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local Utils = require(script.Parent.Utils)
local t2 = {
	collectDelimiterRun = function(t1: {[any]: any}, p1, n1: number) -- line: 19
		-- upvalues: Utils (copy)
		local length = p1.length
		local v8 = n1 + 1

		while v8 <= #t1 do
			local v9 = Utils.getDelimiterInfo(t1[v8].name)

			if not v9 or v9.char ~= p1.char then
				break
			end

			length += v9.length
			v8 += 1
		end

		local prevChar = nil
		local nextChar = nil
		local v12 = t1[n1]

		if v12 and v12.context then
			prevChar = v12.context.prevChar
		end

		local v13 = t1[v8 - 1]

		if v13 and v13.context then
			nextChar = v13.context.nextChar
		end

		return {
			char = p1.char,
			prevChar = prevChar,
			nextChar = nextChar,
			length = length,
			startIdx = n1,
			endIdx = v8 - 1
		}
	end
}

function t2.processEmphasisRun(t3: {[any]: any}, n2: number, n3: number) -- line: 61
	-- upvalues: Utils (copy), t2 (copy)
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local n4 = 1
	local g32 = nil
	local v33 = nil

	while n2 <= n3 do
		local v21 = t3[n2]
		local v22 = Utils.getDelimiterInfo(v21.name)

		if not v22 then
			t4[n4] = v21

			if Utils.causesLineBreak(v21) then
				table.insert(t6, n2)
			end

			n4 += 1
			n2 += 1
		else
			local v23 = t2.collectDelimiterRun(t3, v22, n2)
			local v24 = Utils.canOpenEmphasis(v23)
			local v25 = Utils.canCloseEmphasis(v23)

			table.insert(t5, {
				char = v23.char,
				runLength = v23.length,
				origRunLength = v23.length,
				canOpen = v24,
				canClose = v25,
				startIdx = n4,
				tokenStart = v23.startIdx
			})
			t4[n4] = {
				name = "DELIMITER_RUN",
				text = "",
				delimiterIndex = #t5,
				offset = t3[v23.startIdx].offset
			}
			n4 += 1
			n2 = v23.endIdx + 1
		end
	end

	local v26 = false

	for i = n3 + 1, #t3 do
		if Utils.causesLineBreak(t3[i]) then
			v26 = true

			break
		end
	end

	local t7 = {}

	for v29, v30 in t5 do
		if v30.canClose and v30.runLength > 0 then
			local v31 = #t7

			while true do
				while true do
					while true do
						if not (v31 >= 1) then
							g32 = true
						end

						if g32 then
							break
						end

						v33 = t5[t7[v31]]

						if v33.char == "`" and v30.char ~= "`" and v33.canOpen then
							g32 = true
						end

						if g32 then
							break
						end

						if v33.char == v30.char and v33.canOpen and v33.runLength > 0 then
							break
						end

						v31 -= 1
					end

					if g32 then
						break
					end

					if g32 then
						break
					end

					if Utils.canDelimitersMatch(v33, v30) then
						break
					end

					v31 -= 1
				end

				if g32 then
					break
				end

				if g32 then
					break
				end

				local v34 = math.min(2, v33.runLength, v30.runLength)

				Utils.addDelimiterMatch(v33, {
					isOpener = true,
					with = v30,
					length = v34
				})
				Utils.addDelimiterMatch(v30, {
					isOpener = false,
					with = v33,
					length = v34
				})
				v33.runLength = v33.runLength - v34
				v30.runLength = v30.runLength - v34

				for _ = #t7, v31 + 1, -1 do
					table.remove(t7)
				end

				if v33.runLength == 0 then
					table.remove(t7, v31)
				end

				if v30.runLength == 0 then
					break
				end

				v31 = #t7
			end
		end

		g32 = false

		if v30.canOpen and v30.runLength > 0 then
			table.insert(t7, v29)
		end
	end

	local t8 = {}

	for v37, v38 in t4 do
		if v38.name == "DELIMITER_RUN" then
			local v39 = t5[v38.delimiterIndex]

			if v39.char == "`" and v39.runLength > 0 and v38.delimiterIndex == #t5 and not v26 and v37 < #t4 then
				local v40 = false

				for i = #t6, 1, -1 do
					local v42 = t6[i]

					if v42 > v39.tokenStart then
						v40 = true

						break
					end

					if v42 <= v39.tokenStart then
						break
					end
				end

				if not v40 then
					table.insert(t8, {
						name = "EMPHASIS_START",
						text = "INLINE_CODE",
						offset = t3[v39.tokenStart].offset
					})

					continue
				end
			end

			local matches = v39.matches

			if not matches or #matches == 0 then
				table.insert(t8, {
					name = "TEXT",
					text = string.rep(v39.char, v39.origRunLength),
					offset = v38.offset
				})
			elseif matches[1].isOpener then
				local n5 = 0

				for _, v46 in matches do
					n5 += v46.length
				end

				local v47 = v39.origRunLength - n5

				if v47 > 0 then
					table.insert(t8, {
						name = "TEXT",
						text = string.rep(v39.char, v47),
						offset = v38.offset
					})
				end

				for _, v49 in matches do
					local length = v49.length

					while length > 0 do
						local v51 = math.min(length, 2)
						local v52 = Utils.getTokenNameFromCharAndLength(v39.char, v51)

						table.insert(t8, {
							name = "EMPHASIS_START",
							text = v52,
							offset = v38.offset
						})
						length -= v51
					end
				end
			else
				local t9 = {}

				for _, v55 in matches do
					local length = v55.length

					while length > 0 do
						local v57 = math.min(length, 2)

						table.insert(t9, {
							name = "EMPHASIS_END",
							text = "",
							offset = v38.offset
						})
						length -= v57
					end
				end

				for i = #t9, 1, -1 do
					table.insert(t8, t9[i])
				end

				local n6 = 0

				for _, v61 in matches do
					n6 += v61.length
				end

				local v62 = v39.origRunLength - n6

				if v62 > 0 then
					table.insert(t8, {
						name = "TEXT",
						text = string.rep(v39.char, v62),
						offset = v38.offset
					})
				end
			end

			continue
		end

		table.insert(t8, v38)
	end

	return t8
end

return t2
