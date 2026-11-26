local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/cBc")
local getIgrsImage = require("@luauforge/bundled/dSY").Game.AgeRecommendationUtils.getIgrsImage
local enumIgrsRating = module.EnumIgrsRating
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local image = Foundation.Image
local view = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local function IgrsRatingLabel(props)
	local v5 = useScaledValue(402)
	local v6 = useTokens()
	local igrsImage = getIgrsImage(props.igrsRating)

	local createElement = React.createElement
	local v8 = {
		tag = "padding-medium gap-large radius-medium row align-y-center stroke-default size-full-0 auto-y",
		onActivated = props.onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		LayoutOrder = props.LayoutOrder
	}
	local v9 = {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v5, 1e999),
			MinSize = Vector2.new(0, v6.Size.Size_1700)
		}),
		RatingImage = 0,
		RatingText = 0
	}

	local v10 = if igrsImage then React.createElement(
		image,
		{ Image = igrsImage, tag = "size-1700-1700", LayoutOrder = 1 },
		{
			AspectRatio = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = props.igrsRating == enumIgrsRating.IgrsUnrated and 0.8775804128660586 or 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		}
	) else nil
	v9.RatingImage = v10

	v9.RatingText = React.createElement(text, {
		Text = props.igrsRatingDisplayMessage or "",
		tag = {
			["fill auto-y text-wrap text-align-x-left"] = true,
			["text-body-medium"] = props.igrsRating ~= enumIgrsRating.IgrsUnrated,
			["text-title-medium content-emphasis"] = props.igrsRating == enumIgrsRating.IgrsUnrated
		},
		LayoutOrder = 2
	})
	return createElement(view, v8, v9)
end

return IgrsRatingLabel
