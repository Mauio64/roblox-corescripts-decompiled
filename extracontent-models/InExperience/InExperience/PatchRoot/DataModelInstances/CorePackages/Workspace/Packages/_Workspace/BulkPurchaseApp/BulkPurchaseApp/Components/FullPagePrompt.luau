local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize
local constants = require(BulkPurchaseApp.constants)
local useCloseOnEscapeEffect = require(BulkPurchaseApp.Hooks.useCloseOnEscapeEffect)
local FFlagBulkPurchaseCloseOnEscape = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseCloseOnEscape)

local Scrim = require(script.Parent.Scrim)
local Box = require(script.Parent.Box)

local function CloseButton(p)
	local v = useDesignTokens()
	local selectionImageObject = useCursor(UDim.new(0, v.Radius.Medium), 0)

	return React.createElement("TextButton", {
		Size = UDim2.fromOffset(v.Size.Size_900, v.Size.Size_900),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.Activated] = p.onActivated,
		Text = "",
		[React.Tag] = "data-testid=BulkPurchaseApp_FullPagePromptCloseButton",
		SelectionImageObject = selectionImageObject,
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, React.createElement(ImageSetLabel, {
		Size = UDim2.fromOffset(v.Size.Size_700, v.Size.Size_700),
		BackgroundTransparency = 1,
		Image = Images["icons/navigation/close"],
		ImageColor3 = v.Color.Content.Emphasis.Color3,
		ImageTransparency = v.Color.Content.Emphasis.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}))
end

local function fn(data)
	return {
		background = data.Color.Surface.Surface_0.Color3,
		padding = data.Size.Size_600,
		cornerRadius = data.Radius.Medium,
		headerFontStyle = data.Typography.HeadingSmall,
		headerColorStyle = data.Color.Content.Emphasis,
		headerMarginBottom = data.Size.Size_800,
		headerHeight = data.Size.Size_700
	}
end

return (React.forwardRef(function(props, ref)
	if FFlagBulkPurchaseCloseOnEscape then
		useCloseOnEscapeEffect("BulkPurchaseCloseFullPagePrompt", props.onClose)
	end

	local v = useScreenSize()
	local v2 = useDesignTokens(fn)
	local v3 = useUiModeInfo()
	local v4

	if v3.uiMode == UiMode.TenFoot then
		v4 = constants.MAX_WIDTH * constants.TEN_FOOT_MULTIPLIER
	else
		v4 = constants.MAX_WIDTH
	end

	local v5

	if v3.uiMode == UiMode.TenFoot then
		v5 = constants.MAX_HEIGHT * constants.TEN_FOOT_MULTIPLIER
	else
		v5 = constants.MAX_HEIGHT
	end

	local v6

	if v.X < constants.MOBILE_BREAKPOINT then
		v6 = v.X < v.Y
	else
		v6 = false
	end

	return React.createElement(Scrim, { ref = ref }, React.createElement(Box, {
		padding = { v2.padding, v2.padding, v2.padding, v2.padding },
		cornerRadius = UDim.new(0, v2.cornerRadius),
		Size = UDim2.new(v6 and 1 or 0, v6 and 0 or math.min(v4, v.X), 0, (math.min(v5, v.Y))),
		BackgroundColor3 = v2.background,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, v6 and 1 or 0.5),
		AnchorPoint = Vector2.new(0.5, v6 and 1 or 0.5)
	}, {
		Header = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v2.headerHeight)
			},
			React.createElement(StyledTextLabel, {
				fontStyle = v2.headerFontStyle,
				colorStyle = v2.headerColorStyle,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				text = props.title,
				size = UDim2.new(1, 0, 1, 0)
			}),
			React.createElement(CloseButton, { onActivated = props.onClose })
		),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -v2.headerHeight - v2.headerMarginBottom),
			Position = UDim2.fromOffset(0, v2.headerHeight + v2.headerMarginBottom)
		}, props.children)
	}))
end))
