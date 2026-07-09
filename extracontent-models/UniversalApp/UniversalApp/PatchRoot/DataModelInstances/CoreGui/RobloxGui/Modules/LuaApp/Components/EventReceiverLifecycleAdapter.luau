local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

return function(p1) -- line: 4
	-- upvalues: Roact (copy)
	local receiverComponents = p1.receiverComponents
	local RobloxEventReceiver = p1.RobloxEventReceiver
	local t1 = {}

	for v7, v8 in receiverComponents do
		t1[v7] = Roact.createElement(v8, {
			RobloxEventReceiver = RobloxEventReceiver
		})
	end

	return Roact.createElement("Folder", {}, t1)
end
