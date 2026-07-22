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
local IconVariant = Foundation.Enums.IconVariant

local function getGameIconUrl(p1) -- line: 29
	return p1.gameIcon or `rbxthumb://type=GameIcon&id={ p1.universeId }&w=150&h=150`
end
local function PublishExperienceTitle(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), View (copy), FoundationImage (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy)
	local v16 = t1.testId or "publish-experience-title"
	local target = t1.target
	local v18 = target.creatorName or ""

	return React.createElement(View, {
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		testId = v16
	}, {
		GameIcon = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			tag = "size-1200-1200 radius-medium clip bg-surface-200",
			Image = target.gameIcon or `rbxthumb://type=GameIcon&id={ target.universeId }&w=150&h=150`,
			ScaleType = Enum.ScaleType.Crop,
			testId = `{ v16 }-game-icon`
		}),
		Details = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col fill size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				Text = target.experienceName
			}),
			CreatorRow = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			}, {
				CreatorName = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = v18
				}),
				VerifiedBadge = if t1.isCreatorVerified ~= true then nil else React.createElement(View, {
					LayoutOrder = 2,
					tag = "size-400-400",
					testId = `{ v16 }-verified-badge`
				}, {
					Backplate = React.createElement(Icon, {
						tag = "content-system-emphasis",
						ZIndex = 1,
						name = IconName.VerifiedBackplate,
						size = IconSize.Small
					}),
					Check = React.createElement(Icon, {
						ZIndex = 2,
						name = IconName.VerifiedCheck,
						size = IconSize.Small,
						variant = IconVariant.Regular
					})
				})
			})
		})
	})
end

return PublishExperienceTitle
