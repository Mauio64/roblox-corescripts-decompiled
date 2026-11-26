require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local fFlagUserListSurfacePresenceWins = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfacePresenceWins

local function composeCtaRow(data, data2, p2, data3)
	local v5 = data2 ~= nil and data2.showLoadingPlaceholder ~= false and data2.primaryCtaMinWidth ~= nil
	local v6 = data3.isLoading
		and v5
		and data2
		and { minWidth = data2.primaryCtaMinWidth, maxWidth = data2.primaryCtaMaxWidth }
		or nil

	local userPresenceType = if p2 then p2.userPresenceType else nil
	local renderRow = data.renderRow

	if not renderRow then
		return data.createRow({
			presence = userPresenceType,
			primaryCta = data3.primaryCta,
			secondaryCta = data3.secondaryCta,
			ctaLoading = v6
		})
	end

	local createRow = data.createRow
	return renderRow(function(p3)
		local clone = table.clone(p3)
		clone.presence = userPresenceType

		if fFlagUserListSurfacePresenceWins and p3.presence ~= nil then
			clone.presence = p3.presence
		end

		clone.primaryCta = data3.primaryCta
		clone.secondaryCta = data3.secondaryCta
		clone.ctaLoading = v6
		return createRow(clone)
	end, data.entity, data.index or 0)
end

return composeCtaRow
