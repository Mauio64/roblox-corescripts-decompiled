local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local IXPService = game:GetService("IXPService")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local SharedFlags = require(InGameAssetReportingParent.SharedFlags)
local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled
local FStringHighlightModePreciseSelectionIXPField = SharedFlags.FStringHighlightModePreciseSelectionIXPField
local FStringHighlightModePreciseSelectionForceVariant = SharedFlags.FStringHighlightModePreciseSelectionForceVariant
local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)

local function getHighlightModeVariant() -- line: 15
	-- upvalues: FFlagHighlightModePreciseSelectionEnabled (copy), Constants (copy), FStringHighlightModePreciseSelectionForceVariant (copy), IXPService (copy), FStringReportMenuIXPLayer (copy), FStringHighlightModePreciseSelectionIXPField (copy)
	if not FFlagHighlightModePreciseSelectionEnabled then
		return Constants.HighlightModeVariants.Default
	end

	if FStringHighlightModePreciseSelectionForceVariant ~= "" then
		return FStringHighlightModePreciseSelectionForceVariant
	end

	local ok, result = pcall(function() -- line: 24
		-- upvalues: IXPService (copy), FStringReportMenuIXPLayer (copy)
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if not ok or not result or result[FStringHighlightModePreciseSelectionIXPField] == nil then
		return Constants.HighlightModeVariants.Default
	end

	return result[FStringHighlightModePreciseSelectionIXPField]
end

return getHighlightModeVariant
