local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Style")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local useDesignTokens = Style.useDesignTokens
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local footerCornerButtonStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GameTile").FooterCornerButtonStyle

return function(props)
	local v5 = useDesignTokens()
	local v6 = useTokens()

	local v7 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent"
	})

	local color3 = v5.Color.ActionEmphasis.Background.Color3
	local color3_2 = v5.Color.ActionEmphasis.Foreground.Color3
	local v8 = v7.joinEvent

	if props.buttonStyle == footerCornerButtonStyle.Follow then
		color3 = v6.Color.ActionSubEmphasis.Background.Color3
		color3_2 = v6.Color.ActionSubEmphasis.Foreground.Color3
		v8 = v7.notifyMe
	elseif props.buttonStyle == footerCornerButtonStyle.Following then
		color3_2 = v6.Color.ActionStandard.Foreground.Color3
		v8 = v7.unfollowEvent
	end

	local v9 = props.buttonStyle == footerCornerButtonStyle.Following
	local v10 = props.disabled and 0.5 or 0

	local createElement = React.createElement
	local onActivatedsByActivated = {
		Size = UDim2.new(1, 0, 0, v5.Size.Size_700),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		TextSize = v5.Size.Size_350,
		FontFace = normalizeFontFace(v6.Typography.HeadingSmall.Font),
		BackgroundColor3 = color3,
		TextColor3 = color3_2,
		AutoButtonColor = false,
		Text = v8,
		BackgroundTransparency = v9 and 1 or v10,
		TextTransparency = v10,
		[React.Event.Activated] = props.onActivated
	}
	local v12 = {
		EventButtonCorners = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Size.Size_200)
		}),
		OutlineFrame = 0
	}

	local v13 = if v9 then React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1
		},
		{
			OutlineCorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v5.Size.Size_200 - 2)
			}),
			OutlineStroke = React.createElement("UIStroke", {
				Color = color3_2,
				Transparency = v10,
				Thickness = 1
			})
		}
	) else nil
	v12.OutlineFrame = v13
	return createElement("TextButton", onActivatedsByActivated, v12)
end
