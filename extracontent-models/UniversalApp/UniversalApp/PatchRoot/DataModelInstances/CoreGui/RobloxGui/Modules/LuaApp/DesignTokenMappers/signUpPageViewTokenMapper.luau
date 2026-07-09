local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

local function makeLoginViewTokenMapper(p1, p2) -- line: 10
	-- upvalues: UiMode (copy)
	local t1 = {
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

	if p1.uiMode == UiMode.TenFoot or p1.uiMode == UiMode.VR then
		t1.marginTop = p2.Size.Size_1200
		t1.textboxHeight = p2.Size.Size_1200
		t1.textHeaderSize = p2.FontSize.FontSize_1000
		t1.textCaptionHeaderSize = p2.FontSize.FontSize_500
		t1.textBodySize = p2.FontSize.FontSize_400
		t1.textSmallSize = p2.FontSize.FontSize_250
		t1.signUpContentsPadding = p2.Size.Size_600
		t1.boxPadding = p2.Size.Size_400
		t1.buttonHeight = p2.Size.Size_1200
		t1.buttonTextSize = p2.FontSize.FontSize_500
		t1.contentPadding = p2.Size.Size_600
		t1.headerPadding = p2.Size.Size_400
		t1.dropdownHeight = p2.Size.Size_1200
		t1.dropdownHorizontalPadding = p2.Size.Size_600
		t1.dropdownVerticalPadding = p2.Size.Size_400
		t1.dateDropdownWidth = p2.Size.Size_2600
	end

	return t1
end

return makeLoginViewTokenMapper
