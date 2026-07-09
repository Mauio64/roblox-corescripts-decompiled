local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local UIBlox = require(CorePackages.Packages.UIBlox)
local TextService = game:GetService("TextService")
local Images = UIBlox.App.ImageSet.Images

local function makeLoginViewTokenMapper(p1, p2) -- line: 14
	-- upvalues: TextService (copy), Images (copy), UiMode (copy)
	local v9 = TextService:GetTextSize("", p2.FontSize.FontSize_500, Enum.Font.BuilderSans, Vector2.new(1e999, 1e999)).Y + 11
	local t1 = {
		loginContentsPadding = 30,
		marginY = 40,
		textboxHeight = v9,
		textboxLabelPadding = 12,
		textboxPaddingX = 10,
		textboxPaddingY = 7,
		continueButtonHeight = 48,
		crossdeviceButtonHeight = 48,
		qrWidth = 128,
		thumbnailSize = 160,
		spacerSize = 12,
		boxPadding = 4,
		linkAccountPadding = p2.Size.Size_400,
		errorTextSize = p2.FontSize.FontSize_250,
		errorTextPadding = p2.Size.Size_200,
		disclaimerPadding = p2.Size.Size_600,
		textboxLabelHeight = p2.FontSize.FontSize_500,
		textboxTextSize = 16,
		lockPadding = 98,
		loginTextSize = p2.FontSize.FontSize_500,
		qrPadding = UDim.new(0, p2.Size.Size_400),
		dividerPadding = 0,
		dividerSize = 0,
		disclaimerIconSize = p2.Size.Size_700,
		disclaimerIconPadding = p2.Size.Size_400,
		disclaimerElementHeight = 84,
		linkIcon = Images["icons/navigation/externallink_medium"],
		qrErrorPadding = 280,
		dualLayoutPadding = 140,
		credentialPaddingRight = 100,
		xOffset = 166,
		textSmallSize = p2.FontSize.FontSize_400,
		forgotLinkHeight = 30,
		quickLinkCodeViewBottomPadding = p2.Size.Size_1200,
		quickLinkCodeViewTopPadding = p2.Size.Size_800,
		quickLinkCodeViewCodeBoxHorizontalPadding = p2.Size.Size_400,
		quickLinkCodeViewCodeBoxVertialPadding = p2.Size.Size_200,
		quickLinkCodeViewCodeTextSize = p2.Size.Size_600
	}

	if p1.uiMode == UiMode.TenFoot or p1.uiMode == UiMode.VR then
		t1.textboxHeight = p2.Size.Size_1200
		t1.textboxLabelPadding = p2.Size.Size_400
		t1.continueButtonHeight = p2.Size.Size_1200
		t1.textHeaderSize = p2.FontSize.FontSize_500
		t1.cdlDeviceCodeSize = if p1.uiMode ~= UiMode.VR then p2.FontSize.FontSize_500 else p2.FontSize.FontSize_2100
		t1.textBodySize = p2.FontSize.FontSize_500
		t1.loginContentsPadding = p2.Size.Size_800
		t1.qrWidth = 280
		t1.boxPadding = p2.Size.Size_400
		t1.textboxTextSize = p2.FontSize.FontSize_400
		t1.qrPadding = UDim.new(0, p2.Size.Size_800)
		t1.dividerPadding = p2.Size.Size_800
		t1.dividerSize = p2.Size.Size_300
		t1.dualLayoutPadding = p2.Size.Size_600
		t1.credentialPaddingRight = p2.Size.Size_1200
		t1.errorTextSize = p2.FontSize.FontSize_400
		t1.errorTextPadding = p2.Size.Size_200
	end

	return t1
end

return makeLoginViewTokenMapper
