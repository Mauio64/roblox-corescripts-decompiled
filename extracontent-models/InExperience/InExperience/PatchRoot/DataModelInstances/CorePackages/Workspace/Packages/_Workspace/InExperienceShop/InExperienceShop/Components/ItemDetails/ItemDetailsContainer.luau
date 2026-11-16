local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local SharedFlags = require(parent.SharedFlags)

local ItemDetailsView = require(script.Parent.ItemDetailsView)
local useItemDetailsViewModel = require(script.Parent.useItemDetailsViewModel)
local ShopAbuseReportOverlay

if SharedFlags.FFlagEnableReportingFlowForExperienceShop then
	ShopAbuseReportOverlay = require(InExperienceShop.Components.ShopAbuseReportOverlay)
else
	ShopAbuseReportOverlay = nil
end

local function ItemDetailsContainer(p)
	local v = useItemDetailsViewModel(p)
	local reportSession = v.reportSession

	local createElement = React.createElement

	local v2 = {
		Details = React.createElement(ItemDetailsView, v),
		ReportOverlay = 0
	}
	local reportOverlay

	if reportSession and v.onReportClose and ShopAbuseReportOverlay then
		reportOverlay = React.createElement(ShopAbuseReportOverlay, {
			abuseVector = reportSession.abuseVector,
			targetId = reportSession.targetId,
			onClose = v.onReportClose
		})
	end

	v2.ReportOverlay = reportOverlay
	return createElement(View, { tag = "size-full" }, v2)
end

return ItemDetailsContainer
