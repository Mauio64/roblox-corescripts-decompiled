local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local v12 = game:DefineFastInt("BuildPublishPreviewCardMaxWidth", 560)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.499, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function getGameIconUrl(p1) -- line: 37
	return p1.gameIcon or `rbxthumb://type=GameIcon&id={ p1.universeId }&w=150&h=150`
end
local function getMediaUrl(p2) -- line: 41
	if p2.placeId ~= nil then
		return `rbxthumb://type=GameThumbnail&id={ p2.placeId }&w=768&h=432`
	end

	return p2.gameIcon or `rbxthumb://type=GameIcon&id={ p2.universeId }&w=150&h=150`
end
local function PublishPreviewCard(t1: {[any]: any}) -- line: 49
	-- upvalues: useTokens (copy), React (copy), View (copy), v12 (copy), FoundationImage (copy), numberSequence (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v20 = useTokens()
	local v21 = t1.testId or "publish-preview-card"
	local target = t1.target
	local v23 = if target.placeId == nil then target.gameIcon or `rbxthumb://type=GameIcon&id={ target.universeId }&w=150&h=150` else `rbxthumb://type=GameThumbnail&id={ target.placeId }&w=768&h=432`
	local v24 = target.gameIcon or `rbxthumb://type=GameIcon&id={ target.universeId }&w=150&h=150`
	local v25 = target.creatorName or ""
	local v26 = t1.isCreatorVerified == true

	return React.createElement(View, {
		tag = "col align-x-center size-full-0 auto-y padding-y-xsmall",
		LayoutOrder = t1.layoutOrder,
		testId = v21
	}, {
		Card = React.createElement(View, {
			tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large clip bg-surface-100",
			sizeConstraint = {
				MaxSize = Vector2.new(v12, 1e999)
			},
			testId = `{ v21 }-card`
		}, {
			Media = React.createElement(View, {
				LayoutOrder = 1,
				ClipsDescendants = true,
				tag = "size-full-full auto-y aspect-16-9 bg-surface-200"
			}, {
				RoundedCornerImage = React.createElement(FoundationImage, {
					ZIndex = 1,
					tag = "size-full",
					Image = v23,
					ScaleType = Enum.ScaleType.Fit,
					cornerRadius = UDim.new(0, v20.Radius.Medium),
					testId = `{ v21 }-media`
				}),
				SquareCornerImage = React.createElement(FoundationImage, {
					ZIndex = 2,
					tag = "size-full",
					Image = v23,
					ScaleType = Enum.ScaleType.Fit,
					testId = `{ v21 }-media-bottom`
				}, {
					BottomHalfMask = React.createElement("UIGradient", {
						Rotation = 90,
						Transparency = numberSequence
					})
				})
			}),
			Content = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-large"
			}, {
				GameIcon = React.createElement(FoundationImage, {
					LayoutOrder = 1,
					tag = "radius-medium clip bg-surface-200",
					Image = v24,
					ScaleType = Enum.ScaleType.Crop,
					Size = UDim2.fromOffset(48, 48),
					testId = `{ v21 }-game-icon`
				}),
				Details = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col fill size-full-0 auto-y"
				}, {
					Title = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
						Text = target.experienceName
					}),
					CreatorRow = React.createElement(View, {
						LayoutOrder = 2,
						tag = "row align-y-center gap-xsmall size-full-0 auto-y"
					}, {
						CreatorName = React.createElement(FoundationText, {
							LayoutOrder = 1,
							tag = "auto-xy text-body-medium text-align-x-left text-truncate-end content-default",
							Text = v25
						}),
						VerifiedBadge = if not v26 then nil else React.createElement(View, {
							LayoutOrder = 2,
							Size = UDim2.fromOffset(16, 16),
							testId = `{ v21 }-verified-badge`
						}, {
							Backplate = React.createElement(Icon, {
								ZIndex = 1,
								name = IconName.VerifiedBackplate,
								size = IconSize.Small,
								style = v20.Color.System.Emphasis
							}),
							Check = React.createElement(Icon, {
								ZIndex = 2,
								name = IconName.VerifiedCheck,
								size = IconSize.Small,
								style = {
									Transparency = 0,
									Color3 = Color3.fromRGB(255, 255, 255)
								}
							})
						})
					})
				})
			})
		})
	})
end

return PublishPreviewCard
