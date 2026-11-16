local function find(list, p)
	for i = 1, #list do
		if list[i] == p then
			return i
		end
	end

	return nil
end

return find
