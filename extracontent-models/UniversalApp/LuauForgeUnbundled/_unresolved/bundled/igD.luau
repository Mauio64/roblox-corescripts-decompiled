local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

return function(p2)
	local receiverComponents = p2.receiverComponents

	local children = {}

	for i, receiverComponent in ipairs(receiverComponents) do
		children[i] = Roact.createElement(receiverComponent, {})
	end

	return Roact.createElement("Folder", {}, children)
end
