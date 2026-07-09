local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local IconName = require(Parent.Foundation).Enums.IconName

return {
	REPORT_ICON = "icons/actions/feedback",
	REPORT_MENU_ITEM_ID = "report",
	OVERFLOW_ICON = IconName.ThreeDotsHorizontal
}
