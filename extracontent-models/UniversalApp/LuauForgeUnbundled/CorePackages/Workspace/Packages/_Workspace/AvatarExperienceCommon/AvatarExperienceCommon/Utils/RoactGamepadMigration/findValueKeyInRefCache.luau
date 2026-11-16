local function findValueKeyInRefCache(p2, items)
	for k, item in items do
		if item.current == p2 then
			return k
		end
	end

	return nil
end

return findValueKeyInRefCache
