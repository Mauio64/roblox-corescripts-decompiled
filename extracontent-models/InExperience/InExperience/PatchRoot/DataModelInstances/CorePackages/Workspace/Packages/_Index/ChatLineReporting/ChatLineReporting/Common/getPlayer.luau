local function getPlayer(items, p: string)
	for _, item in pairs(items) do
		if item.userId == p then
			return item
		end
	end

	return nil
end

return getPlayer
