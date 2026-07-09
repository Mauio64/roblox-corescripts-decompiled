local ParentParent = script.Parent.Parent

require(ParentParent.Types)

return function(t1: {[any]: any}) -- line: 5
	local t2 = {}
	local t3 = {}

	for _, v in pairs(t1) do
		local str = tostring(v.experienceContext.experienceId)

		if not t3[str] then
			table.insert(t2, str)
			t3[str] = true
		end
	end

	return t2
end
