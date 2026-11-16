local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local Utils = require(script.Parent.Utils)

local EmphasisParser = {}

function EmphasisParser.collectDelimiterRun(list, p, startIdx: number)
	local length = p.length
	local v = startIdx + 1

	while v <= #list do
		local delimiterInfo = Utils.getDelimiterInfo(list[v].name)

		if not delimiterInfo or delimiterInfo.char ~= p.char then
			break
		end

		length += delimiterInfo.length
		v += 1
	end

	local nextChar = nil

	local item = list[startIdx]
	local prevChar

	if item and item.context then
		prevChar = item.context.prevChar
	end

	local item2 = list[v - 1]

	if item2 and item2.context then
		nextChar = item2.context.nextChar
	end

	return {
		char = p.char,
		prevChar = prevChar,
		nextChar = nextChar,
		length = length,
		startIdx = startIdx,
		endIdx = v - 1
	}
end

function EmphasisParser.processEmphasisRun(list, p: number, p2: number)
	local startIdx = 1
	local v = {}
	local v2 = {}

	local v3 = {}

	while p <= p2 do
		local item = list[p]
		local delimiterInfo = Utils.getDelimiterInfo(item.name)

		if delimiterInfo then
			local delimiterRun = EmphasisParser.collectDelimiterRun(list, delimiterInfo, p)

			local canOpenEmphasis = Utils.canOpenEmphasis(delimiterRun)
			local canCloseEmphasis = Utils.canCloseEmphasis(delimiterRun)

			table.insert(v, {
				char = delimiterRun.char,
				runLength = delimiterRun.length,
				origRunLength = delimiterRun.length,
				canOpen = canOpenEmphasis,
				canClose = canCloseEmphasis,
				startIdx = startIdx,
				tokenStart = delimiterRun.startIdx
			})

			v2[startIdx] = {
				name = "DELIMITER_RUN",
				text = "",
				delimiterIndex = #v,
				offset = list[delimiterRun.startIdx].offset
			}

			startIdx += 1
			p = delimiterRun.endIdx + 1
		else
			v2[startIdx] = item

			if Utils.causesLineBreak(item) then
				table.insert(v3, p)
			end

			startIdx += 1
			p += 1
		end
	end

	local v4 = false

	for i = p2 + 1, #list do
		if Utils.causesLineBreak(list[i]) then
			v4 = true
			break
		end
	end

	local v5 = {}

	for k, with in v do
		if with.canClose and with.runLength > 0 then
			local v6 = #v5

			while v6 >= 1 do
				local with2 = v[v5[v6]]

				if with2.char == "`" and with.char ~= "`" and with2.canOpen then
					break
				end

				if with2.char == with.char and with2.canOpen and with2.runLength > 0 then
					if Utils.canDelimitersMatch(with2, with) then
						local length = math.min(2, with2.runLength, with.runLength)

						Utils.addDelimiterMatch(with2, {
							with = with,
							length = length,
							isOpener = true
						})

						Utils.addDelimiterMatch(with, {
							with = with2,
							length = length,
							isOpener = false
						})

						with2.runLength -= length
						with.runLength -= length

						for _ = #v5, v6 + 1, -1 do
							table.remove(v5)
						end

						if with2.runLength == 0 then
							table.remove(v5, v6)
						end

						if with.runLength == 0 then
							break
						end

						v6 = #v5
					else
						v6 -= 1
					end
				else
					v6 -= 1
				end
			end
		end

		if with.canOpen and with.runLength > 0 then
			table.insert(v5, k)
		end
	end

	local result = {}

	for k, v6 in v2 do
		if v6.name == "DELIMITER_RUN" then
			local v7 = v[v6.delimiterIndex]

			if v7.char == "`" and v7.runLength > 0 and v6.delimiterIndex == #v and not v4 and k < #v2 then
				local v8 = false

				for i = #v3, 1, -1 do
					local v9 = v3[i]

					if v7.tokenStart < v9 then
						v8 = true
						break
					elseif v9 <= v7.tokenStart then
						break
					end
				end

				if not v8 then
					table.insert(result, {
						name = "EMPHASIS_START",
						text = "INLINE_CODE",
						offset = list[v7.tokenStart].offset
					})
					continue
				end
			end

			local matches = v7.matches

			if matches and #matches ~= 0 then
				if matches[1].isOpener then
					local total = 0

					for _, match in matches do
						total += match.length
					end

					local v8 = v7.origRunLength - total

					if v8 > 0 then
						table.insert(result, {
							name = "TEXT",
							text = string.rep(v7.char, v8),
							offset = v6.offset
						})
					end

					for _, match in matches do
						local length = match.length

						while length > 0 do
							local v9 = math.min(length, 2)
							table.insert(result, {
								name = "EMPHASIS_START",
								text = Utils.getTokenNameFromCharAndLength(v7.char, v9),
								offset = v6.offset
							})

							length -= v9
						end
					end
				else
					local v8 = {}

					for _, match in matches do
						local length = match.length

						while length > 0 do
							local v9 = math.min(length, 2)

							table.insert(v8, {
								name = "EMPHASIS_END",
								text = "",
								offset = v6.offset
							})

							length -= v9
						end
					end

					for i = #v8, 1, -1 do
						table.insert(result, v8[i])
					end

					local total = 0

					for _, match in matches do
						total += match.length
					end

					local v9 = v7.origRunLength - total

					if v9 > 0 then
						table.insert(result, {
							name = "TEXT",
							text = string.rep(v7.char, v9),
							offset = v6.offset
						})
					end
				end
			else
				table.insert(result, {
					name = "TEXT",
					text = string.rep(v7.char, v7.origRunLength),
					offset = v6.offset
				})
			end
		else
			table.insert(result, v6)
		end
	end

	return result
end

return EmphasisParser
