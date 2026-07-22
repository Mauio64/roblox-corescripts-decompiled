local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local PublishExperienceTitle = require(script.Parent.PublishExperienceTitle)
local FoundationImage = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local v9 = game:DefineFastInt("BuildPublishPreviewCardMaxWidth", 560)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.499, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function getMediaUrl(p1) -- line: 33
	if p1.placeId ~= nil then
		return `rbxthumb://type=GameThumbnail&id={ p1.placeId }&w=768&h=432`
	end

	return p1.gameIcon or `rbxthumb://type=GameIcon&id={ p1.universeId }&w=150&h=150`
end
local function PublishPreviewCard(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), React (copy), View (copy), v9 (copy), FoundationImage (copy), numberSequence (copy), PublishExperienceTitle (copy)
	local v15 = useTokens()
	local v16 = t1.testId or "publish-preview-card"
	local target = t1.target
	local v18 = if target.placeId == nil then target.gameIcon or `rbxthumb://type=GameIcon&id={ target.universeId }&w=150&h=150` else `rbxthumb://type=GameThumbnail&id={ target.placeId }&w=768&h=432`

	return React.createElement(View, {
		tag = "col align-x-center size-full-0 auto-y padding-y-xsmall",
		LayoutOrder = t1.layoutOrder,
		testId = v16
	}, {
		Card = React.createElement(View, {
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
			sizeConstraint = {
				MaxSize = Vector2.new(v9, 1e999)
			},
			testId = `{ v16 }-card`
		}, {
			Media = React.createElement(View, {
				LayoutOrder = 1,
				ClipsDescendants = true,
				tag = "size-full-full auto-y aspect-16-9 bg-surface-200"
			}, {
				RoundedCornerImage = React.createElement(FoundationImage, {
					ZIndex = 1,
					tag = "size-full",
					Image = v18,
					ScaleType = Enum.ScaleType.Fit,
					cornerRadius = UDim.new(0, v15.Radius.Medium),
					testId = `{ v16 }-media`
				}),
				SquareCornerImage = React.createElement(FoundationImage, {
					ZIndex = 2,
					tag = "size-full",
					Image = v18,
					ScaleType = Enum.ScaleType.Fit,
					testId = `{ v16 }-media-bottom`
				}, {
					BottomHalfMask = React.createElement("UIGradient", {
						Rotation = 90,
						Transparency = numberSequence
					})
				})
			}),
			Content = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col size-full-0 auto-y padding-large"
			}, {
				Title = React.createElement(PublishExperienceTitle, {
					layoutOrder = 1,
					target = target,
					isCreatorVerified = t1.isCreatorVerified,
					testId = `{ v16 }-title`
				})
			})
		})
	})
end

return PublishPreviewCard
