local function findValueKeyInRefCache(p, items)
	for k, item in items do
		if item.current == p then
			return k
		end
	end

	return nil
end

return findValueKeyInRefCache
