local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle

function getMenuItemSizings() -- line: 10
	-- upvalues: useStyle (copy), Constants (copy)
	local v5 = useStyle()

	return {
		ItemPadding = v5.Tokens.Size.Size_250,
		DropdownTextSize = v5.Tokens.FontSize.FontSize_400,
		FontStyle = Constants.ReportMenuFontStyle,
		ButtonSize = Constants.ReportMenuButtonSizeConsole,
		ButtonInsideVerticalPadding = v5.Tokens.Size.Size_100
	}
end

return getMenuItemSizings
