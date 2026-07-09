local ParentParent = script.Parent.Parent
local getIsPlaceholder = require(ParentParent.Utils.getIsPlaceholder)

return function(t1: {[any]: any}) -- line: 7
	-- upvalues: getIsPlaceholder (copy)
	local t2 = {}

	if t1.current then
		for _, child in pairs(t1.current:GetChildren()) do
			local childName = child.Name
			local v8 = getIsPlaceholder(childName)

			if string.match(childName, "[a-f0-9]+-[a-f0-9]+-[a-f0-9]+-[a-f0-9]+-[a-f0-9]+") or v8 then
				table.insert(t2, child)
			end
		end
	end

	return t2
end
