local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

require(parent.React)
require(parent.DataHydration)
require(UserList.Common.Types)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListComposeRenderRowWithCta = SharedFlags.FFlagUserListComposeRenderRowWithCta
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListSurfacePresenceWins = SharedFlags2.FFlagUserListSurfacePresenceWins

local function composeCtaRow(data, data2, p, data3)
	local v = data2 ~= nil and data2.showLoadingPlaceholder ~= false and data2.primaryCtaMinWidth ~= nil
	local ctaLoading = data3.isLoading
		and v
		and data2
		and { minWidth = data2.primaryCtaMinWidth, maxWidth = data2.primaryCtaMaxWidth }
		or nil
	local userPresenceType

	if p then
		userPresenceType = p.userPresenceType
	else
		userPresenceType = nil
	end

	local renderRow = data.renderRow

	if FFlagUserListComposeRenderRowWithCta and renderRow then
		local createRow = data.createRow
		return renderRow(function(p2)
			local clone = table.clone(p2)
			clone.presence = userPresenceType

			if FFlagUserListSurfacePresenceWins and p2.presence ~= nil then
				clone.presence = p2.presence
			end

			clone.primaryCta = data3.primaryCta
			clone.secondaryCta = data3.secondaryCta
			clone.ctaLoading = ctaLoading
			return createRow(clone)
		end, data.entity, data.index or 0)
	end

	return data.createRow({
		presence = userPresenceType,
		primaryCta = data3.primaryCta,
		secondaryCta = data3.secondaryCta,
		ctaLoading = ctaLoading
	})
end

return composeCtaRow
