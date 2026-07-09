local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)

require(InExperienceShopParent.GenericAbuseReporting.AbuseVector)

local shopOverflowConstants = require(InExperienceShop.Components.Shared.shopOverflowConstants)

return {
	useShopReportOverflow = function(t1: {[any]: any}) -- line: 31
		-- upvalues: React (copy), shopOverflowConstants (copy)
		local v6, v7 = React.useState(false)
		local v8, v9 = React.useState(nil)
		local v10 = React.useCallback(function() -- line: 36
			-- upvalues: v7 (copy)
			v7(function(p1) -- line: 37
				return not p1
			end)
		end, {})
		local v11 = React.useCallback(function() -- line: 42
			-- upvalues: v7 (copy)
			v7(false)
		end, {})
		local v12 = React.useCallback(function(p2) -- line: 46
			-- upvalues: v7 (copy), shopOverflowConstants (copy), t1 (copy), v9 (copy)
			v7(false)

			if tostring(p2) ~= shopOverflowConstants.REPORT_MENU_ITEM_ID then
				return
			end

			if not t1.isReportingEnabled then
				return
			end

			v9(t1.buildReportSession())
		end, {
			t1.isReportingEnabled,
			t1.buildReportSession
		})
		local v13 = React.useCallback(function() -- line: 60
			-- upvalues: v9 (copy)
			v9(nil)
		end, {})

		return {
			isOverflowMenuOpen = v6,
			reportSession = v8,
			isReportingEnabled = t1.isReportingEnabled,
			onOverflowActivated = v10,
			onOverflowMenuClosed = v11,
			onMenuItemActivated = v12,
			onReportClose = v13
		}
	end
}
