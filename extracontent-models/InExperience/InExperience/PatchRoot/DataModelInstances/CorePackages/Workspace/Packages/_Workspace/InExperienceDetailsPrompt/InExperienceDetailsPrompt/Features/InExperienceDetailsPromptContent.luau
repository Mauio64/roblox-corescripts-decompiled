local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)

require(Parent.DataHydration)

local Foundation = require(Parent.Foundation)
local Badge = Foundation.Badge
local Chip = Foundation.Chip
local Enums = Foundation.Enums
local BadgeVariant = Enums.BadgeVariant
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens
local v11 = game:DefineFastFlag("LuaAppIedpSwitchChipToBadge", false)

local function InExperienceDetailsPromptContent(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), React (copy), ScrollView (copy), Visibility (copy), v11 (copy), Badge (copy), BadgeVariant (copy), Chip (copy), Enums (copy)
	local v14 = useTokens()

	return React.createElement(ScrollView, {
		tag = "size-full-0 auto-y",
		ClipsDescendants = false,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v14.Gap.Small)
		},
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = Visibility.None
		}
	}, {
		AgeRecommendation = if not t1.ageRecommendation or not t1.ageRecommendation.displayNameWithHeaderShort then nil else if not v11 then React.createElement(Chip, {
			LayoutOrder = 1,
			Selectable = false,
			text = t1.ageRecommendation.displayNameWithHeaderShort,
			onActivated = function() -- line: 49
			end
		}) else React.createElement(Badge, {
			LayoutOrder = 1,
			text = t1.ageRecommendation.displayNameWithHeaderShort,
			variant = BadgeVariant.Neutral
		}),
		Rating = if not t1.rating then nil else if not v11 then React.createElement(Chip, {
			LayoutOrder = 2,
			Selectable = false,
			text = t1.rating,
			leading = {
				iconName = Enums.IconName.ThumbUp,
				iconVariant = Enums.IconVariant.Filled
			},
			onActivated = function() -- line: 72
			end
		}) else React.createElement(Badge, {
			LayoutOrder = 2,
			text = t1.rating,
			variant = BadgeVariant.Neutral,
			icon = {
				name = Enums.IconName.ThumbUp,
				variant = Enums.IconVariant.Filled,
				position = Enums.IconPosition.Left
			}
		})
	})
end

return InExperienceDetailsPromptContent
