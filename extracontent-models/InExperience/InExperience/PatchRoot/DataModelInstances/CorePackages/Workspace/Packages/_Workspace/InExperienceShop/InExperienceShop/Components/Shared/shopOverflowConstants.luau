local parent = script:FindFirstAncestor("InExperienceShop").Parent

local Foundation = require(parent.Foundation)
return {
	OVERFLOW_ICON = Foundation.Enums.IconName.ThreeDotsHorizontal,
	REPORT_ICON = "icons/actions/feedback",
	REPORT_MENU_ITEM_ID = "report"
}
