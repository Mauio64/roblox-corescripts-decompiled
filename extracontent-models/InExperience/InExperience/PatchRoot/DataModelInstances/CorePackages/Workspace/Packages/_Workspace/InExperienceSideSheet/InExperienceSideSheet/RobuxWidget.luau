local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)

require(parent.Chrome)
local Foundation = require(parent.Foundation)
local View = Foundation.View

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RobuxPill = require(parent.RobuxPill)
local robuxPill = RobuxPill.RobuxPill

local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local useRobuxBalance = require(InExperienceSideSheet.Hooks.useRobuxBalance)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local function RobuxWidget(props)
	local robuxBalance = useRobuxBalance()

	local v = useLocalization({ buyRobux = "IAPExperience.RobuxUpsell.Action.BuyRobux" })

	local onBuyActivated = React.useCallback(function()
		props.onBuyActivated()
		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.RobuxWidget)
	end, { props.onBuyActivated })
	local ref

	if FFlagSideSheetFocusNav then
		ref = React.useCallback(function(p)
			if p and props.firstIntegrationToFocusCallback then
				props.firstIntegrationToFocusCallback(p)
			end
		end, { props.firstIntegrationToFocusCallback })
	end

	local createElement = React.createElement
	local v2 = {
		tag = "size-full-0 auto-y padding-bottom-medium",
		LayoutOrder = props.layoutOrder or 1
	}

	local createElement2 = React.createElement
	local v3 = {
		layoutOrder = 1,
		robuxBalance = robuxBalance,
		buyButtonText = v.buyRobux,
		onBuyActivated = onBuyActivated,
		isCompact = true,
		ref = 0
	}

	if not FFlagSideSheetFocusNav then
		ref = nil
	end

	v3.ref = ref
	return createElement(View, v2, { RobuxPill = createElement2(robuxPill, v3) })
end

return React.memo(RobuxWidget)
