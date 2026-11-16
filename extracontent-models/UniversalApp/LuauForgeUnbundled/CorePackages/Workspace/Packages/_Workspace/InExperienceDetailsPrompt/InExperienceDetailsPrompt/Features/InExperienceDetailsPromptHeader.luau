local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local image = Foundation.Image
local radius = Foundation.Enums.Radius
local sheet = Foundation.Sheet
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local InExperienceDetailsPromptSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptSubtitle")
local useImageLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Hooks/useImageLoadingState")

local function InExperienceDetailsPromptHeader(props)
	local v5 = useTokens()
	local v6 = useScaledValue(200)
	local v7 = useScaledValue(150)
	local v8 = useImageLoadingState(props.imageUri)

	local createElement = React.createElement
	local header = sheet.Header
	local createElement2 = React.createElement

	local v14 = if v8 then React.createElement(image, {
		LayoutOrder = 1,
		Image = props.imageUri,
		Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200),
		cornerRadius = UDim.new(0, v5.Radius.Medium)
	}) else React.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200),
		radius = radius.Medium
	})

	local createElement3 = React.createElement

	local v18 = if props.name then React.createElement(text, {
		LayoutOrder = 1,
		Text = props.name,
		tag = "text-heading-small content-emphasis auto-xy text-truncate-end"
	}) else React.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v6, v5.Size.Size_600)
	})

	local v19 = if props.creator then React.createElement(InExperienceDetailsPromptSubtitle, {
		creator = props.creator,
		layoutOrder = 2
	}) else React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(v7, v5.Size.Size_500)
	})
	return createElement(header, nil, {
		Content = createElement2(
			view,
			{
				LayoutOrder = 1,
				tag = "row gap-small size-full-0 auto-y items-center padding-top-medium"
			},
			{
				GameIcon = v14,
				TextContainer = createElement3(
					view,
					{ LayoutOrder = 2, tag = "col gap-xxsmall fill auto-xy" },
					{ Title = v18, Subtitle = v19 }
				)
			}
		)
	})
end

return InExperienceDetailsPromptHeader
