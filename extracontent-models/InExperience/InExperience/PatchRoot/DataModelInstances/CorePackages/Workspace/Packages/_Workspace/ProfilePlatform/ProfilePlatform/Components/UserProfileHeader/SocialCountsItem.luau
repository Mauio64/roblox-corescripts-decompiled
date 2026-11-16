local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function NOOP() end

local function SocialCountsItem(props)
	local v = useTokens()
	local active = not props.isDisabled and props.count ~= "0"

	local emphasis = active and v.Color.Content.Emphasis or v.Color.Content.Muted

	local createElement = React.createElement
	local v2 = {}
	v2.Size = UDim2.fromScale(0.25, 0)
	v2.BackgroundTransparency = 1
	v2.AutomaticSize = Enum.AutomaticSize.Y
	local activated = React.Event.Activated
	local v3 = if active then props.onActivated else NOOP
	v2[activated] = v3
	v2.onStateChanged = NOOP
	v2.LayoutOrder = props.layoutOrder
	v2.Active = active
	return createElement(Interactable, v2, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Count = React.createElement(Text, {
			Text = props.count,
			tag = "text-align-y-bottom auto-xy",
			fontStyle = v.Typography.HeadingSmall,
			textStyle = emphasis,
			LayoutOrder = 1
		}),
		Text = React.createElement(Text, {
			Text = props.text,
			tag = "text-align-y-top auto-xy",
			fontStyle = v.Typography.CaptionMedium,
			textStyle = emphasis,
			LayoutOrder = 2
		})
	})
end

return SocialCountsItem
