local function createBrickColorsFromIds(items)
	local brickColorsFromIds = {}

	for _, item in items do
		local success, result = pcall(BrickColor.new, item)

		if success and result then
			table.insert(brickColorsFromIds, result)
		else
			warn(`createBrickColorsFromIds: Failed to create BrickColor with ID {item}`)
		end
	end

	return brickColorsFromIds
end

return createBrickColorsFromIds
