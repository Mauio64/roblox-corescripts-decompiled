local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local ProfileCtaService = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/ProfileCtaService")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local CtaRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/CtaRow")
local SurfaceJoinCtaRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/SurfaceJoinCtaRow")
local useCtaActionHandlers = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useCtaActionHandlers")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants")
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")
local fFlagUserListDefaultCtaWidths = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListDefaultCtaWidths
local fFlagUserListComposeRenderRowWithCta = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListComposeRenderRowWithCta
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions

local profileCTAService = ProfileCtaService.ProfileCTAService

local v5 = {}

local function useCtaRenderRow(p2, renderRow)
	React.useEffect(function()
		local v6 = profileCTAService.connectRealTimeUpdates()
		return function()
			v6.Disconnect()
		end
	end, {})

	local v6 = useCtaActionHandlers(p2)

	if not fFlagUserListComposeRenderRowWithCta then
		renderRow = nil
	end

	local v7 = React.useMemo(function()
		if
			not fFlagUserListDefaultCtaWidths
			or not p2
			or p2.primaryCtaMinWidth ~= nil and p2.primaryCtaMaxWidth ~= nil
		then
			return p2
		end

		local clone = table.clone(p2)
		clone.primaryCtaMinWidth = p2.primaryCtaMinWidth or Constants.DEFAULT_PRIMARY_CTA_MIN_WIDTH
		clone.primaryCtaMaxWidth = p2.primaryCtaMaxWidth or Constants.DEFAULT_PRIMARY_CTA_MAX_WIDTH
		return clone
	end, { p2 })

	return React.useMemo(function()
		local v8 = if fFlagUserListSurfaceExtensions and v7 and v7.join then SurfaceJoinCtaRow else CtaRow

		return function(callback, p3, p4)
			if p3.type == Enums.EntityType.User then
				local createElement = React.createElement
				local v10 = {
					createRow = callback,
					entity = p3,
					actionHandlers = v6,
					ctaConfig = v7,
					index = nil,
					renderRow = nil
				}

				if not (FFlagUserListCanonicalCtaAnalytics or fFlagUserListComposeRenderRowWithCta and renderRow) then
					p4 = nil
				end

				v10.index = p4

				v10.renderRow = renderRow
				return createElement(v8, v10)
			elseif renderRow then
				return renderRow(callback, p3, p4)
			else
				return callback(v5)
			end
		end
	end, { v6, v7, renderRow })
end

return useCtaRenderRow
