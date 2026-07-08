local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useUiModeInfo = require(BulkPurchaseAppParent.RobloxAppHooks).useUiModeInfo
local UiMode = require(BulkPurchaseAppParent.RobloxAppEnums).UiMode
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useScreenSize = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local constants = require(BulkPurchaseApp.constants)
local Scrim = require(script.Parent.Scrim)
local Box = require(script.Parent.Box)

local function CloseButton(t1: {[any]: any}) -- line: 24
	-- upvalues: useDesignTokens (copy), useCursor (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), ImageSetLabel (copy), Images (copy)
	local v20 = useDesignTokens()
	local v21 = useCursor(UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v20.Semantic.Radius.Medium else v20.Radius.Medium), 0)

	return React.createElement("TextButton", {
		Size = UDim2.fromOffset(if not FFlagRenameDeprecatedUIBloxTokens then v20.Global.Size_450 else v20.Size.Size_900, if not FFlagRenameDeprecatedUIBloxTokens then v20.Global.Size_450 else v20.Size.Size_900),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.Activated] = t1.onActivated,
		Text = "",
		[React.Tag] = "data-testid=BulkPurchaseApp_FullPagePromptCloseButton",
		SelectionImageObject = v21,
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(if not FFlagRenameDeprecatedUIBloxTokens then v20.Global.Size_350 else v20.Size.Size_700, if not FFlagRenameDeprecatedUIBloxTokens then v20.Global.Size_350 else v20.Size.Size_700),
		Image = Images["icons/navigation/close"],
		ImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v20.Semantic.Color.Text.Emphasis else v20.Color.Content.Emphasis)).Color3,
		ImageTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v20.Semantic.Color.Text.Emphasis else v20.Color.Content.Emphasis)).Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}))
end
local function v18(p1) -- line: 73
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		background = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Color3,
		padding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_300 else p1.Size.Size_600,
		cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Medium else p1.Radius.Medium,
		headerFontStyle = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Header else p1.Typography.HeadingSmall,
		headerColorStyle = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis,
		headerMarginBottom = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_400 else p1.Size.Size_800,
		headerHeight = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_350 else p1.Size.Size_700
	}
end

return (React.forwardRef(function(t2: {[any]: any}, p2) -- line: 101
	-- upvalues: useScreenSize (copy), useDesignTokens (copy), v18 (copy), useUiModeInfo (copy), UiMode (copy), constants (copy), React (copy), Scrim (copy), Box (copy), StyledTextLabel (copy), CloseButton (copy)
	local v25 = useScreenSize()
	local v26 = useDesignTokens(v18)
	local v27 = useUiModeInfo()
	local v28 = if v27.uiMode ~= UiMode.TenFoot then constants.MAX_WIDTH else constants.MAX_WIDTH * constants.TEN_FOOT_MULTIPLIER
	local v29 = if v27.uiMode ~= UiMode.TenFoot then constants.MAX_HEIGHT else constants.MAX_HEIGHT * constants.TEN_FOOT_MULTIPLIER
	local v30 = v25.X < constants.MOBILE_BREAKPOINT and v25.X < v25.Y

	return React.createElement(Scrim, {
		ref = p2
	}, React.createElement(Box, {
		BorderSizePixel = 0,
		padding = {
			v26.padding,
			v26.padding,
			v26.padding,
			v26.padding
		},
		cornerRadius = UDim.new(0, v26.cornerRadius),
		Size = UDim2.new(not v30 and 0 or 1, if not v30 then math.min(v28, v25.X) else 0, 0, (math.min(v29, v25.Y))),
		BackgroundColor3 = v26.background,
		Position = UDim2.fromScale(0.5, not v30 and 0.5 or 1),
		AnchorPoint = Vector2.new(0.5, not v30 and 0.5 or 1)
	}, {
		Header = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v26.headerHeight)
		}, React.createElement(StyledTextLabel, {
			fontStyle = v26.headerFontStyle,
			colorStyle = v26.headerColorStyle,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			text = t2.title,
			size = UDim2.new(1, 0, 1, 0)
		}), React.createElement(CloseButton, {
			onActivated = t2.onClose
		})),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -v26.headerHeight - v26.headerMarginBottom),
			Position = UDim2.fromOffset(0, v26.headerHeight + v26.headerMarginBottom)
		}, t2.children)
	}))
end))
