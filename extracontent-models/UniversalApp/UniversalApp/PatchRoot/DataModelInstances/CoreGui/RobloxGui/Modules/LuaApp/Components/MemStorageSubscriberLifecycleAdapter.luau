local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

return function(p1) -- line: 4
	-- upvalues: Roact (copy)
	local receiverComponents = p1.receiverComponents
	local t1 = {}

	for i, v in ipairs(receiverComponents) do
		t1[i] = Roact.createElement(v, {})
	end

	return Roact.createElement("Folder", {}, t1)
end
