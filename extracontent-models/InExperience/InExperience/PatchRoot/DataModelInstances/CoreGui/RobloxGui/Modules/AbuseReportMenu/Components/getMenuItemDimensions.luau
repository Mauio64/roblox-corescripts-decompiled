local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

function getMenuItemDimensions(p)
	local v = useStyle()

	if p < Constants.SmallLayoutThreshold then
		return {
			LeftWidth = Constants.LeftContainerWidthSmall,
			RightWidth = Constants.RightContainerWidthSmall,
			TextSize = Constants.FieldLabelSizeSmall
		}
	end

	return {
		LeftWidth = v.Tokens.Size.Size_2000 * 3,
		RightWidth = v.Tokens.Size.Size_2000 * 4,
		TextSize = v.Tokens.FontSize.FontSize_400
	}
end

return getMenuItemDimensions
