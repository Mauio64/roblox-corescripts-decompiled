local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(Parent.React)
local Style = require(Parent.Style)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local useDesignTokens = Style.useDesignTokens
local useTokens = Foundation.Hooks.useTokens
local FooterCornerButtonStyle = require(Parent.GameTile).FooterCornerButtonStyle

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), useTokens (copy), useLocalization (copy), FooterCornerButtonStyle (copy), React (copy)
	local v10 = useDesignTokens()
	local v11 = useTokens()
	local v12 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent"
	})
	local BackgroundColor3 = v10.Color.ActionEmphasis.Background.Color3
	local ForegroundColor3 = v10.Color.ActionEmphasis.Foreground.Color3
	local joinEvent = v12.joinEvent

	if t1.buttonStyle == FooterCornerButtonStyle.Follow then
		BackgroundColor3 = v11.Color.ActionSubEmphasis.Background.Color3
		ForegroundColor3 = v11.Color.ActionSubEmphasis.Foreground.Color3
		joinEvent = v12.notifyMe
	elseif t1.buttonStyle == FooterCornerButtonStyle.Following then
		ForegroundColor3 = v11.Color.ActionStandard.Foreground.Color3
		joinEvent = v12.unfollowEvent
	end

	local v16 = t1.buttonStyle == FooterCornerButtonStyle.Following
	local v17 = not t1.disabled and 0 or 0.5

	return React.createElement("TextButton", {
		Size = UDim2.new(1, 0, 0, v10.Size.Size_700),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		TextSize = v10.Size.Size_350,
		Font = v10.Typography.HeadingSmall.Font,
		BackgroundColor3 = BackgroundColor3,
		TextColor3 = ForegroundColor3,
		AutoButtonColor = false,
		Text = joinEvent,
		BackgroundTransparency = if not v16 then v17 else 1,
		TextTransparency = v17,
		[React.Event.Activated] = t1.onActivated
	}, {
		EventButtonCorners = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v10.Size.Size_200)
		}),
		OutlineFrame = if not v16 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1)
		}, {
			OutlineCorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v10.Size.Size_200 - 2)
			}),
			OutlineStroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = ForegroundColor3,
				Transparency = v17
			})
		})
	})
end
