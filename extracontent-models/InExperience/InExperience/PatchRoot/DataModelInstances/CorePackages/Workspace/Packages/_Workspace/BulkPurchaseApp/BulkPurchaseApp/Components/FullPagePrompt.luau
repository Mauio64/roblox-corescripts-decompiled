local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useUiModeInfo = require(BulkPurchaseAppParent.RobloxAppHooks).useUiModeInfo
local UiMode = require(BulkPurchaseAppParent.RobloxAppEnums).UiMode
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useScreenSize = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local constants = require(BulkPurchaseApp.constants)
local Scrim = require(script.Parent.Scrim)
local Box = require(script.Parent.Box)

local function CloseButton(t1: {[any]: any}) -- line: 22
	-- upvalues: useDesignTokens (copy), useCursor (copy), React (copy), ImageSetLabel (copy), Images (copy)
	local v19 = useDesignTokens()
	local v20 = useCursor(UDim.new(0, v19.Radius.Medium), 0)

	return React.createElement("TextButton", {
		Size = UDim2.fromOffset(v19.Size.Size_900, v19.Size.Size_900),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.Activated] = t1.onActivated,
		Text = "",
		[React.Tag] = "data-testid=BulkPurchaseApp_FullPagePromptCloseButton",
		SelectionImageObject = v20,
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(v19.Size.Size_700, v19.Size.Size_700),
		Image = Images["icons/navigation/close"],
		ImageColor3 = v19.Color.Content.Emphasis.Color3,
		ImageTransparency = v19.Color.Content.Emphasis.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}))
end
local function v17(p1) -- line: 51
	return {
		background = p1.Color.Surface.Surface_0.Color3,
		padding = p1.Size.Size_600,
		cornerRadius = p1.Radius.Medium,
		headerFontStyle = p1.Typography.HeadingSmall,
		headerColorStyle = p1.Color.Content.Emphasis,
		headerMarginBottom = p1.Size.Size_800,
		headerHeight = p1.Size.Size_700
	}
end

return (React.forwardRef(function(t2: {[any]: any}, p2) -- line: 69
	-- upvalues: useScreenSize (copy), useDesignTokens (copy), v17 (copy), useUiModeInfo (copy), UiMode (copy), constants (copy), React (copy), Scrim (copy), Box (copy), StyledTextLabel (copy), CloseButton (copy)
	local v24 = useScreenSize()
	local v25 = useDesignTokens(v17)
	local v26 = useUiModeInfo()
	local v27 = if v26.uiMode ~= UiMode.TenFoot then constants.MAX_WIDTH else constants.MAX_WIDTH * constants.TEN_FOOT_MULTIPLIER
	local v28 = if v26.uiMode ~= UiMode.TenFoot then constants.MAX_HEIGHT else constants.MAX_HEIGHT * constants.TEN_FOOT_MULTIPLIER
	local v29 = v24.X < constants.MOBILE_BREAKPOINT and v24.X < v24.Y

	return React.createElement(Scrim, {
		ref = p2
	}, React.createElement(Box, {
		BorderSizePixel = 0,
		padding = {
			v25.padding,
			v25.padding,
			v25.padding,
			v25.padding
		},
		cornerRadius = UDim.new(0, v25.cornerRadius),
		Size = UDim2.new(not v29 and 0 or 1, if not v29 then math.min(v27, v24.X) else 0, 0, (math.min(v28, v24.Y))),
		BackgroundColor3 = v25.background,
		Position = UDim2.fromScale(0.5, not v29 and 0.5 or 1),
		AnchorPoint = Vector2.new(0.5, not v29 and 0.5 or 1)
	}, {
		Header = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v25.headerHeight)
		}, React.createElement(StyledTextLabel, {
			fontStyle = v25.headerFontStyle,
			colorStyle = v25.headerColorStyle,
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
			Size = UDim2.new(1, 0, 1, -v25.headerHeight - v25.headerMarginBottom),
			Position = UDim2.fromOffset(0, v25.headerHeight + v25.headerMarginBottom)
		}, t2.children)
	}))
end))
