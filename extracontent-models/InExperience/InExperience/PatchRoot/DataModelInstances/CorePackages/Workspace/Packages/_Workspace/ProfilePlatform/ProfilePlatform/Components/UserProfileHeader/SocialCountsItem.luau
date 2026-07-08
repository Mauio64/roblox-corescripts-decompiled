local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Interactable = require(Parent.UIBlox).Core.Control.Interactable
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function NOOP() -- line: 19
end
local function SocialCountsItem(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), Interactable (copy), NOOP (copy), FoundationText (copy)
	local v10 = useTokens()
	local v11 = not t1.isDisabled and t1.count ~= "0"
	local v12 = v11 and v10.Color.Content.Emphasis or v10.Color.Content.Muted

	return React.createElement(Interactable, {
		Size = UDim2.fromScale(0.25, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Event.Activated] = if not v11 then NOOP else t1.onActivated,
		onStateChanged = NOOP,
		LayoutOrder = t1.layoutOrder,
		Active = v11
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Count = React.createElement(FoundationText, {
			tag = "text-align-y-bottom auto-xy",
			LayoutOrder = 1,
			Text = t1.count,
			fontStyle = v10.Typography.HeadingSmall,
			textStyle = v12
		}),
		Text = React.createElement(FoundationText, {
			tag = "text-align-y-top auto-xy",
			LayoutOrder = 2,
			Text = t1.text,
			fontStyle = v10.Typography.CaptionMedium,
			textStyle = v12
		})
	})
end

return SocialCountsItem
