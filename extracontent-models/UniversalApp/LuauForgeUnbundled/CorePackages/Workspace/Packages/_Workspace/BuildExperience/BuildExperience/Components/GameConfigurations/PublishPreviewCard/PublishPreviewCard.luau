local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local PublishExperienceTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishExperienceTitle")

local image = Foundation.Image
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local defineFastInt = game:DefineFastInt("BuildPublishPreviewCardMaxWidth", 560)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.499, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function getMediaUrl(data)
	if data.placeId == nil then
		return data.gameIcon or `rbxthumb://type=GameIcon&id={data.universeId}&w=150&h=150`
	end

	return `rbxthumb://type=GameThumbnail&id={data.placeId}&w=768&h=432`
end

local function PublishPreviewCard(props)
	local v5 = useTokens()
	local testId = props.testId or "publish-preview-card"
	local target = props.target
	local v6

	if target.placeId == nil then
		v6 = target.gameIcon or `rbxthumb://type=GameIcon&id={target.universeId}&w=150&h=150`
	else
		v6 = `rbxthumb://type=GameThumbnail&id={target.placeId}&w=768&h=432`
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-center size-full-0 auto-y padding-y-xsmall",
			testId = testId
		},
		{
			Card = React.createElement(view, {
				sizeConstraint = {
					MaxSize = Vector2.new(defineFastInt, 1e999)
				},
				tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
				testId = `{testId}-card`
			}, {
				Media = React.createElement(
					view,
					{
						LayoutOrder = 1,
						ClipsDescendants = true,
						tag = "size-full-full auto-y aspect-16-9 bg-surface-200"
					},
					{
						RoundedCornerImage = React.createElement(image, {
							Image = v6,
							ScaleType = Enum.ScaleType.Fit,
							ZIndex = 1,
							cornerRadius = UDim.new(0, v5.Radius.Medium),
							tag = "size-full",
							testId = `{testId}-media`
						}),
						SquareCornerImage = React.createElement(image, {
							Image = v6,
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
				Content = React.createElement(
					view,
					{ LayoutOrder = 2, tag = "col size-full-0 auto-y padding-large" },
					{
						Title = React.createElement(PublishExperienceTitle, {
							target = target,
							isCreatorVerified = props.isCreatorVerified,
							layoutOrder = 1,
							testId = `{testId}-title`
						})
					}
				)
			})
		}
	)
end

return PublishPreviewCard
