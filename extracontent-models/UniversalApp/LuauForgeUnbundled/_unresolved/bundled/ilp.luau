local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

return function(p2)
	local receiverComponents = p2.receiverComponents
	local robloxEventReceiver = p2.RobloxEventReceiver

	local children = {}

	for k, receiverComponent in receiverComponents do
		children[k] = Roact.createElement(receiverComponent, {
			RobloxEventReceiver = robloxEventReceiver
		})
	end

	return Roact.createElement("Folder", {}, children)
end
