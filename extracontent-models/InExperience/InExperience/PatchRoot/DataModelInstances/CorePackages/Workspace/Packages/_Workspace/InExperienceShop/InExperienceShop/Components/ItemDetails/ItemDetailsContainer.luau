local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local View = require(InExperienceShopParent.Foundation).View
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local ItemDetailsView = require(script.Parent.ItemDetailsView)
local useItemDetailsViewModel = require(script.Parent.useItemDetailsViewModel)
local v8 = if not SharedFlags.FFlagEnableReportingFlowForExperienceShop then nil else require(InExperienceShop.Components.ShopAbuseReportOverlay)

local function ItemDetailsContainer(p1) -- line: 16
	-- upvalues: useItemDetailsViewModel (copy), React (copy), View (copy), ItemDetailsView (copy), v8 (copy)
	local v11 = useItemDetailsViewModel(p1)
	local reportSession = v11.reportSession

	return React.createElement(View, {
		tag = "size-full"
	}, {
		Details = React.createElement(ItemDetailsView, v11),
		ReportOverlay = if not reportSession or (not v11.onReportClose or not v8) then nil else React.createElement(v8, {
			abuseVector = reportSession.abuseVector,
			targetId = reportSession.targetId,
			onClose = v11.onReportClose
		})
	})
end

return ItemDetailsContainer
