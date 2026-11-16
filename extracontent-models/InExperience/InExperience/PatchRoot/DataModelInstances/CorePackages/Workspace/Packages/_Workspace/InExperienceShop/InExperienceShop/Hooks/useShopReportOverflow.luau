local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)

require(parent.GenericAbuseReporting.AbuseVector)

local shopOverflowConstants = require(InExperienceShop.Components.Shared.shopOverflowConstants)

return {
	useShopReportOverflow = function(p)
		local state, setState = React.useState(false)

		local state2, setState2 = React.useState(nil)

		local onOverflowActivated = React.useCallback(function()
			setState(function(p2): boolean
				return not p2
			end)
		end, {})

		local onOverflowMenuClosed = React.useCallback(function()
			setState(false)
		end, {})

		local onMenuItemActivated = React.useCallback(function(p2)
			setState(false)

			if not (tostring(p2) == shopOverflowConstants.REPORT_MENU_ITEM_ID and p.isReportingEnabled) then
				return
			end

			setState2(p.buildReportSession())
		end, { p.isReportingEnabled, p.buildReportSession })

		local onReportClose = React.useCallback(function()
			setState2(nil)
		end, {})

		return {
			isOverflowMenuOpen = state,
			reportSession = state2,
			isReportingEnabled = p.isReportingEnabled,
			onOverflowActivated = onOverflowActivated,
			onOverflowMenuClosed = onOverflowMenuClosed,
			onMenuItemActivated = onMenuItemActivated,
			onReportClose = onReportClose
		}
	end
}
