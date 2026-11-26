local module = require("@luauforge/deferred/eil")
local module2 = require("@luauforge/deferred/eiU")

local function AddFriendsLoadingState(p2)
	return module.createElement(
		module2.View,
		{
			tag = "size-full-0 auto-y col align-x-center align-y-center padding-large",
			LayoutOrder = p2.LayoutOrder
		},
		{
			Spinner = module.createElement(module2.Loading)
		}
	)
end

return AddFriendsLoadingState
