local function createBrickColorsFromIds(t1: {[any]: any}) -- line: 8
	local t2 = {}

	for _, v5 in t1 do
		local ok, result = pcall(BrickColor.new, v5)

		if ok and result then
			table.insert(t2, result)
		else
			warn(`createBrickColorsFromIds: Failed to create BrickColor with ID { v5 }`)
		end
	end

	return t2
end

return createBrickColorsFromIds
