local function last(list, callback)
	for i = #list, 1, -1 do
		local item = list[i]

		if not callback or callback and callback(item, i) then
			return item
		end
	end

	return nil
end

return last
