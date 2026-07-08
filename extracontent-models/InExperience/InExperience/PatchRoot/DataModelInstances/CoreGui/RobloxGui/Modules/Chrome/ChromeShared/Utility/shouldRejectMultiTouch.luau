return function(p1, p2) -- line: 3
	if p1 == nil or p2 == nil then
		return false
	end

	return p1.UserInputType == Enum.UserInputType.Touch and p2 ~= p1
end
