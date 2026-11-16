local function formatActorNames(list, p2)
	local count = #list

	if p2 == nil or not (count < p2) then
		p2 = count
	end

	if p2 <= 0 or count == 0 then
		return ""
	end

	if p2 == 1 then
		return list[1]
	end

	if p2 == 2 and count >= 2 then
		return `{list[1]} & {list[2]}`
	end

	local v5 = p2 - 1
	local v6 = v5 == 1 and "other" or "others"
	return `{list[1]} & {v5} {v6}`
end

return formatActorNames
