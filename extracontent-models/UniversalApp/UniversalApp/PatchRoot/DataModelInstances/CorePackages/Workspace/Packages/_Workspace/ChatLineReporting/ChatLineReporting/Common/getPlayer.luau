local function getPlayer(p1, s1: string) -- line: 11
	for _, v in pairs(p1) do
		if s1 == v.userId then
			return v
		end
	end

	return nil
end

return getPlayer
