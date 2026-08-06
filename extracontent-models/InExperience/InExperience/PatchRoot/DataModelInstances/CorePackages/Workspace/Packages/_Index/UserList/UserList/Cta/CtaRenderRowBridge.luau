local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent

require(UserListParent.React)
require(UserList.Common.Types)

local useCtaRenderRow = require(UserList.Hooks.useCtaRenderRow)

local function CtaRenderRowBridge(t1: {[any]: any}) -- line: 21
	-- upvalues: useCtaRenderRow (copy)
	local v6 = useCtaRenderRow(t1.ctaConfig)

	return t1.render(v6)
end

return CtaRenderRowBridge
