local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

function getMenuItemSizings()
	local v = useStyle()

	return {
		ItemPadding = v.Tokens.Size.Size_250,
		DropdownTextSize = v.Tokens.FontSize.FontSize_400,
		FontStyle = Constants.ReportMenuFontStyle,
		ButtonSize = Constants.ReportMenuButtonSizeConsole,
		ButtonInsideVerticalPadding = v.Tokens.Size.Size_100
	}
end

return getMenuItemSizings
