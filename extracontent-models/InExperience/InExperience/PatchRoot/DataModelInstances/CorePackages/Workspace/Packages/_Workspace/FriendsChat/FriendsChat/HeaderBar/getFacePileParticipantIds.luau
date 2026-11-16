local function getFacePileParticipantIds(list, p: number)
	if #list <= 1 then
		return { p }
	end

	local result = {}

	for _, item in list do
		if item ~= p then
			table.insert(result, item)
		end
	end

	if #result == 0 then
		return { p }
	end

	return result
end

return getFacePileParticipantIds
