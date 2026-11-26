local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local badge = Foundation.Badge
local chip = Foundation.Chip
local enums = Foundation.Enums
local badgeVariant = enums.BadgeVariant
local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("LuaAppIedpSwitchChipToBadge", false)

local function InExperienceDetailsPromptContent(p2)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		tag = "size-full-0 auto-y",
		ClipsDescendants = false,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v5.Gap.Small)
		},
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = visibility.None
		}
	}
	local v9

	if p2.ageRecommendation and p2.ageRecommendation.displayNameWithHeaderShort then
		if defineFastFlag then
			v9 = React.createElement(badge, {
				text = p2.ageRecommendation.displayNameWithHeaderShort,
				LayoutOrder = 1,
				variant = badgeVariant.Neutral
			})
		else
			v9 = React.createElement(chip, {
				text = p2.ageRecommendation.displayNameWithHeaderShort,
				LayoutOrder = 1,
				onActivated = function() end,
				Selectable = false
			})
		end
	end

	local v10

	if p2.rating then
		if defineFastFlag then
			v10 = React.createElement(badge, {
				text = p2.rating,
				LayoutOrder = 2,
				variant = badgeVariant.Neutral,
				icon = {
					name = enums.IconName.ThumbUp,
					variant = enums.IconVariant.Filled,
					position = enums.IconPosition.Left
				}
			})
		else
			v10 = React.createElement(chip, {
				text = p2.rating,
				LayoutOrder = 2,
				leading = {
					iconName = enums.IconName.ThumbUp,
					iconVariant = enums.IconVariant.Filled
				},
				onActivated = function() end,
				Selectable = false
			})
		end
	end

	return createElement(scrollView, v7, { AgeRecommendation = v9, Rating = v10 })
end

return InExperienceDetailsPromptContent
