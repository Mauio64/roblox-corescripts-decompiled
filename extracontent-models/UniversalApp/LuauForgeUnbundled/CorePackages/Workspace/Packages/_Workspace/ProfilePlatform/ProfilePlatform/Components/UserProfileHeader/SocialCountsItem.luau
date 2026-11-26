local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local interactable = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").Core.Control.Interactable
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function NOOP() end

local function SocialCountsItem(props)
	local v5 = useTokens()
	local v6 = not props.isDisabled and props.count ~= "0"

	local emphasis = v6 and v5.Color.Content.Emphasis or v5.Color.Content.Muted

	local createElement = React.createElement
	local v8 = {}
	v8.Size = UDim2.fromScale(0.25, 0)
	v8.BackgroundTransparency = 1
	v8.AutomaticSize = Enum.AutomaticSize.Y
	local activated = React.Event.Activated
	local v9 = if v6 then props.onActivated else NOOP
	v8[activated] = v9
	v8.onStateChanged = NOOP
	v8.LayoutOrder = props.layoutOrder
	v8.Active = v6
	return createElement(interactable, v8, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Count = React.createElement(text, {
			Text = props.count,
			tag = "text-align-y-bottom auto-xy",
			fontStyle = v5.Typography.HeadingSmall,
			textStyle = emphasis,
			LayoutOrder = 1
		}),
		Text = React.createElement(text, {
			Text = props.text,
			tag = "text-align-y-top auto-xy",
			fontStyle = v5.Typography.CaptionMedium,
			textStyle = emphasis,
			LayoutOrder = 2
		})
	})
end

return SocialCountsItem
