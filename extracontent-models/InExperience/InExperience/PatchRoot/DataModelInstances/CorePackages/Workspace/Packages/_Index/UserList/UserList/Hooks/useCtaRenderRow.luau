local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local ProfileCtaService = require(parent.ProfileCtaService)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local CtaRow = require(UserList.Cta.CtaRow)
local SurfaceJoinCtaRow = require(UserList.Cta.SurfaceJoinCtaRow)
local useCtaActionHandlers = require(script.Parent.useCtaActionHandlers)
local Constants = require(UserList.Common.Constants)
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListDefaultCtaWidths = SharedFlags.FFlagUserListDefaultCtaWidths
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListComposeRenderRowWithCta = SharedFlags2.FFlagUserListComposeRenderRowWithCta
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags3.FFlagUserListSurfaceExtensions

local ProfileCTAService = ProfileCtaService.ProfileCTAService

local v = {}

local function useCtaRenderRow(p, renderRow)
	React.useEffect(function()
		local v2 = ProfileCTAService.connectRealTimeUpdates()
		return function()
			v2.Disconnect()
		end
	end, {})

	local actionHandlers = useCtaActionHandlers(p)

	if not FFlagUserListComposeRenderRowWithCta then
		renderRow = nil
	end

	local ctaConfig = React.useMemo(function()
		if
			not FFlagUserListDefaultCtaWidths
			or not p
			or p.primaryCtaMinWidth ~= nil and p.primaryCtaMaxWidth ~= nil
		then
			return p
		end

		local clone = table.clone(p)
		clone.primaryCtaMinWidth = p.primaryCtaMinWidth or Constants.DEFAULT_PRIMARY_CTA_MIN_WIDTH
		clone.primaryCtaMaxWidth = p.primaryCtaMaxWidth or Constants.DEFAULT_PRIMARY_CTA_MAX_WIDTH
		return clone
	end, { p })

	return React.useMemo(function()
		local v2

		if FFlagUserListSurfaceExtensions and ctaConfig and ctaConfig.join then
			v2 = SurfaceJoinCtaRow
		else
			v2 = CtaRow
		end

		return function(createRow, entity, p2: number)
			if entity.type == Enums.EntityType.User then
				local createElement = React.createElement
				local v3 = {
					createRow = createRow,
					entity = entity,
					actionHandlers = actionHandlers,
					ctaConfig = ctaConfig,
					index = nil,
					renderRow = nil
				}

				if not (FFlagUserListCanonicalCtaAnalytics or FFlagUserListComposeRenderRowWithCta and renderRow) then
					p2 = nil
				end

				v3.index = p2

				v3.renderRow = renderRow
				return createElement(v2, v3)
			elseif renderRow then
				return renderRow(createRow, entity, p2)
			else
				return createRow(v)
			end
		end
	end, { actionHandlers, ctaConfig, renderRow })
end

return useCtaRenderRow
