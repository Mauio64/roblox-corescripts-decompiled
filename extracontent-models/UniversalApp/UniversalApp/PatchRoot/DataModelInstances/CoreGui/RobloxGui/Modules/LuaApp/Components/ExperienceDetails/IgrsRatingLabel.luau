local CorePackages = game:GetService("CorePackages")
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local getIgrsImage = require(CorePackages.Workspace.Packages.DataHydration).Game.AgeRecommendationUtils.getIgrsImage
local EnumIgrsRating = DiscoveryTypes.EnumIgrsRating
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local function IgrsRatingLabel(t1: {[any]: any}) -- line: 29
	-- upvalues: useScaledValue (copy), useTokens (copy), getIgrsImage (copy), React (copy), View (copy), Foundation (copy), FoundationImage (copy), EnumIgrsRating (copy), FoundationText (copy)
	local v14 = useScaledValue(402)
	local v15 = useTokens()
	local v16 = getIgrsImage(t1.igrsRating)

	return React.createElement(View, {
		tag = "padding-medium gap-large radius-medium row align-y-center stroke-default size-full-0 auto-y",
		onActivated = t1.onActivated,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		LayoutOrder = t1.LayoutOrder
	}, {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v14, 1e999),
			MinSize = Vector2.new(0, v15.Size.Size_1700)
		}),
		RatingImage = if not v16 then nil else React.createElement(FoundationImage, {
			tag = "size-1700-1700",
			LayoutOrder = 1,
			Image = v16
		}, {
			AspectRatio = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = t1.igrsRating ~= EnumIgrsRating.IgrsUnrated and 1 or 0.8775804128660586,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		}),
		RatingText = React.createElement(FoundationText, {
			LayoutOrder = 2,
			Text = t1.igrsRatingDisplayMessage or "",
			tag = {
				["fill auto-y text-wrap text-align-x-left"] = true,
				["text-body-medium"] = t1.igrsRating ~= EnumIgrsRating.IgrsUnrated,
				["text-title-medium content-emphasis"] = t1.igrsRating == EnumIgrsRating.IgrsUnrated
			}
		})
	})
end

return IgrsRatingLabel
