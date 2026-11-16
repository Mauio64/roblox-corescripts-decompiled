local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

local IXPService = game:GetService("IXPService")

local parent = InGameAssetReporting.Parent
local SharedFlags = require(parent.SharedFlags)

local FStringReportMenuIXPLayer = SharedFlags.FStringReportMenuIXPLayer
local FFlagHighlightModePreciseSelectionEnabled = SharedFlags.FFlagHighlightModePreciseSelectionEnabled
local FStringHighlightModePreciseSelectionIXPField = SharedFlags.FStringHighlightModePreciseSelectionIXPField
local FStringHighlightModePreciseSelectionForceVariant = SharedFlags.FStringHighlightModePreciseSelectionForceVariant

local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)

local function getHighlightModeVariant()
	if not FFlagHighlightModePreciseSelectionEnabled then
		return Constants.HighlightModeVariants.Default
	end

	if FStringHighlightModePreciseSelectionForceVariant ~= "" then
		return FStringHighlightModePreciseSelectionForceVariant
	end

	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(FStringReportMenuIXPLayer)
	end)

	if success and result and result[FStringHighlightModePreciseSelectionIXPField] ~= nil then
		return result[FStringHighlightModePreciseSelectionIXPField]
	end

	return Constants.HighlightModeVariants.Default
end

return getHighlightModeVariant
