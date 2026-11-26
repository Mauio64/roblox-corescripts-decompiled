local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/VerifiedBadges/VerifiedBadge")
local fFlagUnifyVerifiedBadgeComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagUnifyVerifiedBadgeComponent

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local icon = Foundation.Icon
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

local function getGameIconUrl(p2)
	return p2.gameIcon or `rbxthumb://type=GameIcon&id={p2.universeId}&w=150&h=150`
end

local function PublishExperienceTitle(props)
	local testId = props.testId or "publish-experience-title"
	local target = props.target
	local creatorName = target.creatorName or ""

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		testId = testId
	}
	local v7 = {
		GameIcon = React.createElement(image, {
			LayoutOrder = 1,
			Image = target.gameIcon or `rbxthumb://type=GameIcon&id={target.universeId}&w=150&h=150`,
			ScaleType = Enum.ScaleType.Crop,
			tag = "size-1200-1200 radius-medium clip bg-surface-200",
			testId = `{testId}-game-icon`
		}),
		Details = 0
	}

	local createElement2 = React.createElement

	local v10 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = target.experienceName,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		CreatorRow = 0
	}

	local createElement3 = React.createElement

	local v13 = {
		CreatorName = React.createElement(text, {
			LayoutOrder = 1,
			Text = creatorName,
			tag = {
				["text-body-medium text-align-x-left content-default"] = true,
				["shrink auto-xy text-wrap"] = fFlagUnifyVerifiedBadgeComponent,
				["fill auto-y text-wrap"] = not fFlagUnifyVerifiedBadgeComponent
			}
		}),
		VerifiedBadge = 0
	}
	local v14

	if props.isCreatorVerified == true then
		if fFlagUnifyVerifiedBadgeComponent then
			v14 = React.createElement(module3, {
				LayoutOrder = 2,
				testId = `{testId}-verified-badge`
			})
		else
			v14 = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "size-400-400",
					testId = `{testId}-verified-badge`
				},
				{
					Backplate = React.createElement(icon, {
						name = iconName.VerifiedBackplate,
						size = iconSize.Small,
						tag = "content-system-emphasis",
						ZIndex = 1
					}),
					Check = React.createElement(icon, {
						name = iconName.VerifiedCheck,
						size = iconSize.Small,
						variant = iconVariant.Regular,
						ZIndex = 2
					})
				}
			)
		end
	end

	v13.VerifiedBadge = v14
	v10.CreatorRow = createElement3(
		view,
		{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
		v13
	)
	v7.Details = createElement2(view, {
		LayoutOrder = 2,
		tag = "col fill size-full-0 auto-y"
	}, v10)
	return createElement(view, v6, v7)
end

return PublishExperienceTitle
