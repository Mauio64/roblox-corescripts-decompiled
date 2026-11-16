require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local function makeLoginViewTokenMapper(p2, p3)
	local loginViewTokenMapper = {
		marginTop = 0,
		textboxHeight = 36,
		textboxLabelPadding = 12,
		textboxPaddingX = 10,
		textboxPaddingY = 7,
		continueButtonHeight = 48,
		crossdeviceButtonHeight = 48,
		qrWidth = 128,
		thumbnailSize = 160,
		spacerSize = 12,
		boxPadding = 4,
		buttonHeight = 36,
		buttonTextSize = 16,
		contentPadding = 5,
		headerPadding = 1,
		dropdownHeight = 72,
		dropdownHorizontalPadding = 36,
		dropdownVerticalPadding = 24,
		dateDropdownWidth = 156
	}

	if p2.uiMode ~= uiMode.TenFoot and p2.uiMode ~= uiMode.VR then
		return loginViewTokenMapper
	end

	loginViewTokenMapper.marginTop = p3.Size.Size_1200
	loginViewTokenMapper.textboxHeight = p3.Size.Size_1200
	loginViewTokenMapper.textHeaderSize = p3.FontSize.FontSize_1000
	loginViewTokenMapper.textCaptionHeaderSize = p3.FontSize.FontSize_500
	loginViewTokenMapper.textBodySize = p3.FontSize.FontSize_400
	loginViewTokenMapper.textSmallSize = p3.FontSize.FontSize_250
	loginViewTokenMapper.signUpContentsPadding = p3.Size.Size_600
	loginViewTokenMapper.boxPadding = p3.Size.Size_400
	loginViewTokenMapper.buttonHeight = p3.Size.Size_1200
	loginViewTokenMapper.buttonTextSize = p3.FontSize.FontSize_500
	loginViewTokenMapper.contentPadding = p3.Size.Size_600
	loginViewTokenMapper.headerPadding = p3.Size.Size_400
	loginViewTokenMapper.dropdownHeight = p3.Size.Size_1200
	loginViewTokenMapper.dropdownHorizontalPadding = p3.Size.Size_600
	loginViewTokenMapper.dropdownVerticalPadding = p3.Size.Size_400
	loginViewTokenMapper.dateDropdownWidth = p3.Size.Size_2600

	return loginViewTokenMapper
end

return makeLoginViewTokenMapper
