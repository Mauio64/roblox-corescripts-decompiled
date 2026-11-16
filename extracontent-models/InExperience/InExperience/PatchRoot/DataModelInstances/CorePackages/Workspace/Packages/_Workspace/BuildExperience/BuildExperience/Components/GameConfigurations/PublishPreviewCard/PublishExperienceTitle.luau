local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)
local SharedFlags = require(parent.SharedFlags)
local FFlagUnifyVerifiedBadgeComponent = SharedFlags.FFlagUnifyVerifiedBadgeComponent

require(BuildExperience.Chat.chatTypes)

local Icon = Foundation.Icon
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

local function getGameIconUrl(target) -- 1 equivalent call inferred from this helper
	return target.gameIcon or `rbxthumb://type=GameIcon&id={target.universeId}&w=150&h=150`
end

local function PublishExperienceTitle(props)
	local testId = props.testId or "publish-experience-title"
	local target = props.target
	local creatorName = target.creatorName or ""

	local createElement = React.createElement
	local v = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		testId = testId
	}

	local v2 = {
		GameIcon = React.createElement(Image, {
			LayoutOrder = 1,
			Image = getGameIconUrl(target), -- inferred equivalent call
			ScaleType = Enum.ScaleType.Crop,
			tag = "size-1200-1200 radius-medium clip bg-surface-200",
			testId = `{testId}-game-icon`
		}),
		Details = 0
	}

	local createElement2 = React.createElement

	local v3 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = target.experienceName,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		CreatorRow = 0
	}

	local createElement3 = React.createElement

	local v4 = {
		CreatorName = React.createElement(Text, {
			LayoutOrder = 1,
			Text = creatorName,
			tag = {
				["text-body-medium text-align-x-left content-default"] = true,
				["shrink auto-xy text-wrap"] = FFlagUnifyVerifiedBadgeComponent,
				["fill auto-y text-wrap"] = not FFlagUnifyVerifiedBadgeComponent
			}
		}),
		VerifiedBadge = 0
	}
	local verifiedBadge

	if props.isCreatorVerified == true then
		if FFlagUnifyVerifiedBadgeComponent then
			verifiedBadge = React.createElement(VerifiedBadge, {
				LayoutOrder = 2,
				testId = `{testId}-verified-badge`
			})
		else
			verifiedBadge = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "size-400-400", testId = `{testId}-verified-badge` },
				{
					Backplate = React.createElement(Icon, {
						name = IconName.VerifiedBackplate,
						size = IconSize.Small,
						tag = "content-system-emphasis",
						ZIndex = 1
					}),
					Check = React.createElement(Icon, {
						name = IconName.VerifiedCheck,
						size = IconSize.Small,
						variant = IconVariant.Regular,
						ZIndex = 2
					})
				}
			)
		end
	end

	v4.VerifiedBadge = verifiedBadge
	v3.CreatorRow = createElement3(
		View,
		{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
		v4
	)
	v2.Details = createElement2(View, { LayoutOrder = 2, tag = "col fill size-full-0 auto-y" }, v3)
	return createElement(View, v, v2)
end

return PublishExperienceTitle
