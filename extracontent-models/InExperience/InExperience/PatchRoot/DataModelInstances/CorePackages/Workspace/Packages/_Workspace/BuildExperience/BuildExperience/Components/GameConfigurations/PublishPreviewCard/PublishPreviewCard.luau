local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
local PublishExperienceTitle = require(script.Parent.PublishExperienceTitle)

local Image = Foundation.Image
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local defineFastInt = game:DefineFastInt("BuildPublishPreviewCardMaxWidth", 560)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.499, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function getMediaUrl(target) -- 1 equivalent call inferred from this helper
	if target.placeId == nil then
		return target.gameIcon or `rbxthumb://type=GameIcon&id={target.universeId}&w=150&h=150`
	end

	return `rbxthumb://type=GameThumbnail&id={target.placeId}&w=768&h=432`
end

local function PublishPreviewCard(props)
	local v = useTokens()
	local testId = props.testId or "publish-preview-card"
	local target = props.target
	local mediaUrl = getMediaUrl(target) -- inferred equivalent call
	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-center size-full-0 auto-y padding-y-xsmall",
			testId = testId
		},
		{
			Card = React.createElement(View, {
				sizeConstraint = {
					MaxSize = Vector2.new(defineFastInt, 1e999)
				},
				tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
				testId = `{testId}-card`
			}, {
				Media = React.createElement(
					View,
					{
						LayoutOrder = 1,
						ClipsDescendants = true,
						tag = "size-full-full auto-y aspect-16-9 bg-surface-200"
					},
					{
						RoundedCornerImage = React.createElement(Image, {
							Image = mediaUrl,
							ScaleType = Enum.ScaleType.Fit,
							ZIndex = 1,
							cornerRadius = UDim.new(0, v.Radius.Medium),
							tag = "size-full",
							testId = `{testId}-media`
						}),
						SquareCornerImage = React.createElement(Image, {
							Image = mediaUrl,
							ScaleType = Enum.ScaleType.Fit,
							ZIndex = 2,
							tag = "size-full",
							testId = `{testId}-media-bottom`
						}, {
							BottomHalfMask = React.createElement("UIGradient", {
								Rotation = 90,
								Transparency = numberSequence
							})
						})
					}
				),
				Content = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col size-full-0 auto-y padding-large"
				}, {
					Title = React.createElement(PublishExperienceTitle, {
						target = target,
						isCreatorVerified = props.isCreatorVerified,
						layoutOrder = 1,
						testId = `{testId}-title`
					})
				})
			})
		}
	)
end

return PublishPreviewCard
