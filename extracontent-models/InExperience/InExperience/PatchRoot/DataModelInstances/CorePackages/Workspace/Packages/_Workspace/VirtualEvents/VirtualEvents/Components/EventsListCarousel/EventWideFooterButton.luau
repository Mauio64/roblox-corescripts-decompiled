local parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local useDesignTokens = Style.useDesignTokens
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local GameTile = require(parent.GameTile)
local FooterCornerButtonStyle = GameTile.FooterCornerButtonStyle

return function(props)
	local v = useDesignTokens()
	local v2 = useTokens()

	local v3 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent"
	})

	local color3 = v.Color.ActionEmphasis.Background.Color3
	local color3_2 = v.Color.ActionEmphasis.Foreground.Color3
	local text = v3.joinEvent

	if props.buttonStyle == FooterCornerButtonStyle.Follow then
		color3 = v2.Color.ActionSubEmphasis.Background.Color3
		color3_2 = v2.Color.ActionSubEmphasis.Foreground.Color3
		text = v3.notifyMe
	elseif props.buttonStyle == FooterCornerButtonStyle.Following then
		color3_2 = v2.Color.ActionStandard.Foreground.Color3
		text = v3.unfollowEvent
	end

	local v4 = props.buttonStyle == FooterCornerButtonStyle.Following
	local v5 = props.disabled and 0.5 or 0

	local createElement = React.createElement
	local onActivatedsByActivated = {}
	onActivatedsByActivated.Size = UDim2.new(1, 0, 0, v.Size.Size_700)
	onActivatedsByActivated.Position = UDim2.new(0, 0, 1, 0)
	onActivatedsByActivated.AnchorPoint = Vector2.new(0, 1)
	onActivatedsByActivated.TextSize = v.Size.Size_350
	local font

	if not FoundationFontFaceMigration then
		font = v.Typography.HeadingSmall.Font
	end

	onActivatedsByActivated.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Typography.HeadingSmall.Font)
	end

	onActivatedsByActivated.FontFace = fontFace

	onActivatedsByActivated.BackgroundColor3 = color3
	onActivatedsByActivated.TextColor3 = color3_2
	onActivatedsByActivated.AutoButtonColor = false
	onActivatedsByActivated.Text = text
	onActivatedsByActivated.BackgroundTransparency = v4 and 1 or v5
	onActivatedsByActivated.TextTransparency = v5
	onActivatedsByActivated[React.Event.Activated] = props.onActivated
	local v6 = {
		EventButtonCorners = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v.Size.Size_200)
		}),
		OutlineFrame = 0
	}
	local outlineFrame

	if v4 then
		outlineFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundTransparency = 1
			},
			{
				OutlineCorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v.Size.Size_200 - 2)
				}),
				OutlineStroke = React.createElement("UIStroke", {
					Color = color3_2,
					Transparency = v5,
					Thickness = 1
				})
			}
		)
	end

	v6.OutlineFrame = outlineFrame
	return createElement("TextButton", onActivatedsByActivated, v6)
end
