local v5 = {
	{ 9, 13 },
	{ 32, 32 },
	{ 133, 133 },
	{ 160, 160 },
	{ 5760, 5760 },
	{ 8192, 8202 },
	{ 8232, 8233 },
	{ 8239, 8239 },
	{ 8287, 8287 },
	{ 12288, 12288 }
}

local v6 = {
	{ 65, 90, 32 },
	{ 192, 214, 32 },
	{ 216, 222, 32 },
	{ 902, 902, 38 },
	{ 904, 906, 37 },
	{ 908, 908, 64 },
	{ 910, 911, 63 },
	{ 913, 929, 32 },
	{ 931, 939, 32 },
	{ 962, 962, 1 },
	{ 1024, 1039, 80 },
	{ 1040, 1071, 32 },
	{ 1168, 1168, 1 }
}

local v7 = {
	{ 34, 34 },
	{ 39, 41 },
	{ 42, 42 },
	{ 60, 60 },
	{ 62, 62 },
	{ 91, 91 },
	{ 93, 93 },
	{ 95, 95 },
	{ 96, 96 },
	{ 123, 123 },
	{ 124, 124 },
	{ 125, 125 },
	{ 126, 126 },
	{ 8216, 8217 },
	{ 8220, 8221 }
}

local v8 = {
	{ 0, 8 },
	{ 14, 31 },
	{ 127, 132 },
	{ 134, 159 },
	{ 173, 173 },
	{ 1536, 1541 },
	{ 1564, 1564 },
	{ 1757, 1757 },
	{ 1807, 1807 },
	{ 6158, 6158 },
	{ 8203, 8207 },
	{ 8234, 8238 },
	{ 8288, 8292 },
	{ 8294, 8303 },
	{ 65279, 65279 },
	{ 65529, 65531 }
}

local v9 = {
	{ 48, 57 },
	{ 97, 122 },
	{ 192, 214 },
	{ 216, 246 },
	{ 248, 591 },
	{ 880, 884 },
	{ 886, 887 },
	{ 890, 893 },
	{ 895, 895 },
	{ 902, 902 },
	{ 904, 906 },
	{ 908, 908 },
	{ 910, 929 },
	{ 931, 1013 },
	{ 1015, 1023 },
	{ 1024, 1153 },
	{ 1162, 1327 },
	{ 1568, 1610 },
	{ 1632, 1641 },
	{ 1646, 1647 },
	{ 1649, 1747 },
	{ 1749, 1749 },
	{ 1765, 1766 },
	{ 1774, 1788 },
	{ 1791, 1791 },
	{ 1872, 1919 },
	{ 2208, 2249 },
	{ 3585, 3632 },
	{ 3634, 3635 },
	{ 3648, 3654 },
	{ 3664, 3673 },
	{ 4352, 4607 },
	{ 7680, 7935 },
	{ 12353, 12438 },
	{ 12445, 12447 },
	{ 12449, 12538 },
	{ 12540, 12543 },
	{ 12593, 12686 },
	{ 12784, 12799 },
	{ 13312, 19903 },
	{ 19968, 40959 },
	{ 44032, 55203 },
	{ 63744, 64109 },
	{ 64112, 64217 },
	{ 65382, 65470 },
	{ 65474, 65479 },
	{ 65482, 65487 },
	{ 65490, 65495 },
	{ 65498, 65500 },
	{ 1328, 1423 },
	{ 1488, 1522 },
	{ 2304, 3455 },
	{ 3712, 3839 },
	{ 4096, 4255 },
	{ 4256, 4351 },
	{ 4608, 4991 },
	{ 6016, 6143 },
	{ 131072, 173791 },
	{ 173824, 177983 },
	{ 177984, 178207 },
	{ 178208, 183983 },
	{ 183984, 191471 },
	{ 196608, 201551 },
	{ 201552, 205743 }
}

local function inRanges(p2, items): boolean
	for k, item in items do
		if item[1] <= p2 and p2 <= item[2] then
			return true
		end
	end

	return false
end

local function fold(p2)
	if p2 >= 65281 and p2 <= 65374 then
		p2 -= 65248
	end

	for k, v10 in v6 do
		if v10[1] <= p2 and p2 <= v10[2] then
			return p2 + v10[3]
		end
	end

	return p2
end

local function codepointsOf(p2)
	local result = {}

	for k, v10 in utf8.codes(p2) do
		table.insert(result, v10)
	end

	return result
end

local function fromCodepoints(list)
	local v10 = table.create(#list)

	for k, item in list do
		v10[k] = utf8.char(item)
	end

	return table.concat(v10)
end

local function collapseWhitespace(items)
	local result = {}
	local v10 = false

	for k, item in items do
		local flag = true
		local flag2

		for k2, v11 in v5 do
			if v11[1] <= item and item <= v11[2] then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			v10 = #result > 0
		else
			if v10 then
				table.insert(result, 32)
				v10 = false
			end

			table.insert(result, item)
		end
	end

	return result
end

local function sameCodepoints(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	for k, item in list do
		if item ~= list2[k] then
			return false
		end
	end

	return true
end

local function trimDecorativeBoundaries(list)
	local count = #list
	local v10 = 1

	while v10 <= count do
		local item = list[v10]
		local flag = true
		local v11

		for k, v12 in v7 do
			if v12[1] <= item and item <= v12[2] then
				v11 = true
				flag = false
				break
			end
		end

		if flag then
			v11 = false
		end

		if not v11 then
			break
		end

		v10 += 1
	end

	while v10 <= count do
		local item = list[count]
		local flag = true
		local v11

		for k, v12 in v7 do
			if v12[1] <= item and item <= v12[2] then
				v11 = true
				flag = false
				break
			end
		end

		if flag then
			v11 = false
		end

		if not v11 then
			break
		end

		count -= 1
	end

	return collapseWhitespace(table.move(list, v10, count, 1, {}))
end

return {
	specVersion = "marketplace-query-v2",
	normalizeQueryWhitespace = function(p2)
		if p2 == nil or utf8.len(p2) == nil then
			return nil
		end

		local v12 = {}

		for k, v13 in utf8.codes(p2) do
			table.insert(v12, v13)
		end

		return fromCodepoints(collapseWhitespace(v12))
	end,
	canonicalizeMarketplaceQuery = function(p2)
		if p2 == nil or utf8.len(p2) == nil then
			return nil
		end

		local v10 = {}
		local v11 = false

		for k, v12 in utf8.codes(p2) do
			local v13 = fold(v12)
			local flag = true
			local flag2

			for k2, v15 in v5 do
				if v15[1] <= v13 and v13 <= v15[2] then
					flag2 = true
					flag = false
					break
				end
			end

			if flag then
				flag2 = false
			end

			if flag2 then
				v11 = #v10 > 0
			else
				local flag3 = true
				local v16

				for k2, v17 in v8 do
					if v17[1] <= v13 and v13 <= v17[2] then
						v16 = true
						flag3 = false
						break
					end
				end

				if flag3 then
					v16 = false
				end

				if not v16 then
					if v11 then
						table.insert(v10, 32)
						v11 = false
					end

					table.insert(v10, v13)
				end
			end
		end

		local v12 = trimDecorativeBoundaries(v10)

		while true do
			local flag

			if #v12 == #v10 then
				local flag2 = true

				for k, v14 in v12 do
					if v14 ~= v10[k] then
						flag = false
						flag2 = false
						break
					end
				end

				if flag2 then
					flag = true
				end
			else
				flag = false
			end

			if flag then
				break
			end

			v10 = v12
			v12 = trimDecorativeBoundaries(v12)
		end

		for k, v13 in v10 do
			local flag = true
			local flag2

			for k2, v14 in v9 do
				if v14[1] <= v13 and v13 <= v14[2] then
					flag2 = true
					flag = false
					break
				end
			end

			if flag then
				flag2 = false
			end

			if flag2 then
				return fromCodepoints(v10)
			end
		end

		return nil
	end
}
