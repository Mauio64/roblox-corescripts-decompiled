local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local parent = InExperienceDetailsPrompt.Parent
local React = require(parent.React)
require(parent.DataHydration)

local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local Radius = Foundation.Enums.Radius
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local InExperienceDetailsPromptSubtitle = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptSubtitle)
local useImageLoadingState = require(InExperienceDetailsPrompt.Hooks.useImageLoadingState)

local function InExperienceDetailsPromptHeader(props)
	local v = useTokens()
	local v2 = useScaledValue(200)
	local v3 = useScaledValue(150)
	local v4 = useImageLoadingState(props.imageUri)

	local createElement = React.createElement
	local header = Sheet.Header
	local createElement2 = React.createElement
	local gameIcon

	if v4 then
		gameIcon = React.createElement(Image, {
			LayoutOrder = 1,
			Image = props.imageUri,
			Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200),
			cornerRadius = UDim.new(0, v.Radius.Medium)
		})
	else
		gameIcon = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200),
			radius = Radius.Medium
		})
	end

	local createElement3 = React.createElement
	local title

	if props.name then
		title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.name,
			tag = "text-heading-small content-emphasis auto-xy text-truncate-end"
		})
	else
		title = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v2, v.Size.Size_600)
		})
	end

	local subtitle

	if props.creator then
		subtitle = React.createElement(InExperienceDetailsPromptSubtitle, {
			creator = props.creator,
			layoutOrder = 2
		})
	else
		subtitle = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(v3, v.Size.Size_500)
		})
	end

	return createElement(header, nil, {
		Content = createElement2(
			View,
			{
				LayoutOrder = 1,
				tag = "row gap-small size-full-0 auto-y items-center padding-top-medium"
			},
			{
				GameIcon = gameIcon,
				TextContainer = createElement3(View, {
					LayoutOrder = 2,
					tag = "col gap-xxsmall fill auto-xy"
				}, {
					Title = title,
					Subtitle = subtitle
				})
			}
		)
	})
end

return InExperienceDetailsPromptHeader
