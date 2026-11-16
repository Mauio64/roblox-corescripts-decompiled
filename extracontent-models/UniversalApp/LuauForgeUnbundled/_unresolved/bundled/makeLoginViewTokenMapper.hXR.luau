local CorePackages = game:GetService("CorePackages")
require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local UIBlox = require(CorePackages.Packages.UIBlox)

local TextService = game:GetService("TextService")

local images = UIBlox.App.ImageSet.Images

local function makeLoginViewTokenMapper(p2, p3)
	local loginViewTokenMapper = {
		loginContentsPadding = 30,
		marginY = 40,
		textboxHeight = TextService:GetTextSize(
			"",
			p3.FontSize.FontSize_500,
			Enum.Font.BuilderSans,
			Vector2.new(1e999, 1e999)
		).Y + 11,
		textboxLabelPadding = 12,
		textboxPaddingX = 10,
		textboxPaddingY = 7,
		continueButtonHeight = 48,
		crossdeviceButtonHeight = 48,
		qrWidth = 128,
		thumbnailSize = 160,
		spacerSize = 12,
		boxPadding = 4,
		linkAccountPadding = p3.Size.Size_400,
		errorTextSize = p3.FontSize.FontSize_250,
		errorTextPadding = p3.Size.Size_200,
		disclaimerPadding = p3.Size.Size_600,
		textboxLabelHeight = p3.FontSize.FontSize_500,
		textboxTextSize = 16,
		lockPadding = 98,
		loginTextSize = p3.FontSize.FontSize_500,
		qrPadding = UDim.new(0, p3.Size.Size_400),
		dividerPadding = 0,
		dividerSize = 0,
		disclaimerIconSize = p3.Size.Size_700,
		disclaimerIconPadding = p3.Size.Size_400,
		disclaimerElementHeight = 84,
		linkIcon = images["icons/navigation/externallink_medium"],
		qrErrorPadding = 280,
		dualLayoutPadding = 140,
		credentialPaddingRight = 100,
		xOffset = 166,
		textSmallSize = p3.FontSize.FontSize_400,
		forgotLinkHeight = 30,
		quickLinkCodeViewBottomPadding = p3.Size.Size_1200,
		quickLinkCodeViewTopPadding = p3.Size.Size_800,
		quickLinkCodeViewCodeBoxHorizontalPadding = p3.Size.Size_400,
		quickLinkCodeViewCodeBoxVertialPadding = p3.Size.Size_200,
		quickLinkCodeViewCodeTextSize = p3.Size.Size_600
	}

	if p2.uiMode ~= uiMode.TenFoot and p2.uiMode ~= uiMode.VR then
		return loginViewTokenMapper
	end

	loginViewTokenMapper.textboxHeight = p3.Size.Size_1200
	loginViewTokenMapper.textboxLabelPadding = p3.Size.Size_400
	loginViewTokenMapper.continueButtonHeight = p3.Size.Size_1200
	loginViewTokenMapper.textHeaderSize = p3.FontSize.FontSize_500
	local v5 = if p2.uiMode == uiMode.VR then p3.FontSize.FontSize_2100 else p3.FontSize.FontSize_500
	loginViewTokenMapper.cdlDeviceCodeSize = v5

	loginViewTokenMapper.textBodySize = p3.FontSize.FontSize_500
	loginViewTokenMapper.loginContentsPadding = p3.Size.Size_800
	loginViewTokenMapper.qrWidth = 280
	loginViewTokenMapper.boxPadding = p3.Size.Size_400
	loginViewTokenMapper.textboxTextSize = p3.FontSize.FontSize_400
	loginViewTokenMapper.qrPadding = UDim.new(0, p3.Size.Size_800)
	loginViewTokenMapper.dividerPadding = p3.Size.Size_800
	loginViewTokenMapper.dividerSize = p3.Size.Size_300
	loginViewTokenMapper.dualLayoutPadding = p3.Size.Size_600
	loginViewTokenMapper.credentialPaddingRight = p3.Size.Size_1200
	loginViewTokenMapper.errorTextSize = p3.FontSize.FontSize_400
	loginViewTokenMapper.errorTextPadding = p3.Size.Size_200

	return loginViewTokenMapper
end

return makeLoginViewTokenMapper
