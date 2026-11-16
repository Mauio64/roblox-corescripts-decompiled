local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
require(parent.DataHydration)

local Foundation = require(parent.Foundation)
local Badge = Foundation.Badge
local Chip = Foundation.Chip
local Enums = Foundation.Enums
local BadgeVariant = Enums.BadgeVariant
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("LuaAppIedpSwitchChipToBadge", false)

local function InExperienceDetailsPromptContent(p)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		tag = "size-full-0 auto-y",
		ClipsDescendants = false,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v.Gap.Small)
		},
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = Visibility.None
		}
	}
	local ageRecommendation

	if p.ageRecommendation and p.ageRecommendation.displayNameWithHeaderShort then
		if defineFastFlag then
			ageRecommendation = React.createElement(Badge, {
				text = p.ageRecommendation.displayNameWithHeaderShort,
				LayoutOrder = 1,
				variant = BadgeVariant.Neutral
			})
		else
			ageRecommendation = React.createElement(Chip, {
				text = p.ageRecommendation.displayNameWithHeaderShort,
				LayoutOrder = 1,
				onActivated = function() end,
				Selectable = false
			})
		end
	end

	local rating

	if p.rating then
		if defineFastFlag then
			rating = React.createElement(Badge, {
				text = p.rating,
				LayoutOrder = 2,
				variant = BadgeVariant.Neutral,
				icon = {
					name = Enums.IconName.ThumbUp,
					variant = Enums.IconVariant.Filled,
					position = Enums.IconPosition.Left
				}
			})
		else
			rating = React.createElement(Chip, {
				text = p.rating,
				LayoutOrder = 2,
				leading = {
					iconName = Enums.IconName.ThumbUp,
					iconVariant = Enums.IconVariant.Filled
				},
				onActivated = function() end,
				Selectable = false
			})
		end
	end

	return createElement(ScrollView, v2, { AgeRecommendation = ageRecommendation, Rating = rating })
end

return InExperienceDetailsPromptContent
