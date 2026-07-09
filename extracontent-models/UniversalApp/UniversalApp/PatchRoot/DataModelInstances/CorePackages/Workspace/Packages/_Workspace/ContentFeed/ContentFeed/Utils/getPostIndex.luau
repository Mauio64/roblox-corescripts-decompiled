local ParentParent = script.Parent.Parent

require(ParentParent.Types)

return function(t1: {[any]: any}, s1: string) -- line: 5
	local n1 = 1

	for _, v in pairs(t1) do
		if s1 == v.postId then
			return n1
		end

		n1 += 1
	end

	return nil
end
