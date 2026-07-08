local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle

function getMenuItemDimensions(p1) -- line: 9
	-- upvalues: useStyle (copy), Constants (copy)
	local v6 = useStyle()

	if p1 < Constants.SmallLayoutThreshold then
		return {
			LeftWidth = Constants.LeftContainerWidthSmall,
			RightWidth = Constants.RightContainerWidthSmall,
			TextSize = Constants.FieldLabelSizeSmall
		}
	end

	return {
		LeftWidth = v6.Tokens.Size.Size_2000 * 3,
		RightWidth = v6.Tokens.Size.Size_2000 * 4,
		TextSize = v6.Tokens.FontSize.FontSize_400
	}
end

return getMenuItemDimensions
