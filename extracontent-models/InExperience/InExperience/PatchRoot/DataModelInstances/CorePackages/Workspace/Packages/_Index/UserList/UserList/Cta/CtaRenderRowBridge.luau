local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

require(parent.React)
require(UserList.Common.Types)

local useCtaRenderRow = require(UserList.Hooks.useCtaRenderRow)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListComposeRenderRowWithCta = SharedFlags.FFlagUserListComposeRenderRowWithCta

local function CtaRenderRowBridge(data)
	local ctaConfig = data.ctaConfig
	local v

	if FFlagUserListComposeRenderRowWithCta then
		v = data.renderRow
	end

	local v2 = useCtaRenderRow(ctaConfig, v)
	return data.render(v2)
end

return CtaRenderRowBridge
