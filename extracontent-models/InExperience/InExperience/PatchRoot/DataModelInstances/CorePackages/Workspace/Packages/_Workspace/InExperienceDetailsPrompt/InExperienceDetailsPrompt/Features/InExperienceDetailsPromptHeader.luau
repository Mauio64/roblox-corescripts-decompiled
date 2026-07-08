local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local InExperienceDetailsPromptParent = InExperienceDetailsPrompt.Parent
local React = require(InExperienceDetailsPromptParent.React)

require(InExperienceDetailsPromptParent.DataHydration)

local Foundation = require(InExperienceDetailsPromptParent.Foundation)
local FoundationImage = Foundation.Image
local EnumsRadius = Foundation.Enums.Radius
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local InExperienceDetailsPromptSubtitle = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptSubtitle)
local useImageLoadingState = require(InExperienceDetailsPrompt.Hooks.useImageLoadingState)

local function InExperienceDetailsPromptHeader(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), useScaledValue (copy), useImageLoadingState (copy), React (copy), Sheet (copy), View (copy), FoundationImage (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy), InExperienceDetailsPromptSubtitle (copy)
	local v17 = useTokens()
	local v18 = useScaledValue(200)
	local v19 = useScaledValue(150)
	local v20 = useImageLoadingState(t1.imageUri)

	return React.createElement(Sheet.Header, nil, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small size-full-0 auto-y items-center padding-top-medium"
		}, {
			GameIcon = if not v20 then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v17.Size.Size_1200, v17.Size.Size_1200),
				radius = EnumsRadius.Medium
			}) else React.createElement(FoundationImage, {
				LayoutOrder = 1,
				Image = t1.imageUri,
				Size = UDim2.fromOffset(v17.Size.Size_1200, v17.Size.Size_1200),
				cornerRadius = UDim.new(0, v17.Radius.Medium)
			}),
			TextContainer = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col gap-xxsmall fill auto-xy"
			}, {
				Title = if not t1.name then React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v18, v17.Size.Size_600)
				}) else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "text-heading-small content-emphasis auto-xy text-truncate-end",
					Text = t1.name
				}),
				Subtitle = if not t1.creator then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v19, v17.Size.Size_500)
				}) else React.createElement(InExperienceDetailsPromptSubtitle, {
					layoutOrder = 2,
					creator = t1.creator
				})
			})
		})
	})
end

return InExperienceDetailsPromptHeader
