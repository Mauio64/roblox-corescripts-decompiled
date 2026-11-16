local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local View = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local overrides = { numColumns = 3 }

local function getTextSizeAdjustedSquareExperienceTileHeight(p: number) -- 1 equivalent call inferred from this helper
	return function(p2: number)
		return p2 + 80 + p * 3
	end
end

local function ExperiencesSkeleton(p)
	local v = useLocalization({ experiences = TextKeys.Experiences })

	local v2 = useTextSizeOffset()
	local getItemHeight = React.useMemo(function()
		return getTextSizeAdjustedSquareExperienceTileHeight(v2) -- inferred equivalent call
	end, { v2 })

	local renderItem = React.useCallback(function(_, layoutOrder: number, size)
		return
			React.createElement(View, {
				tag = "col gap-small radius-medium",
				LayoutOrder = layoutOrder,
				Size = size
			}, {
				ThumbnailSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0.6),
					radius = Radius.Medium
				}),
				NameSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromScale(0.8, 0.18),
					radius = Radius.Medium
				}),
				ButtonSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 3,
					Size = UDim2.fromScale(0.6, 0.08),
					radius = Radius.Medium
				})
			}),
			"Skeleton_" .. layoutOrder
	end, {})

	local items = React.useMemo(function()
		local result = {}

		for i = 1, p.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { p.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = p.layoutOrder,
		items = items,
		renderItem = renderItem,
		getItemHeight = getItemHeight,
		title = v.experiences,
		overrides = overrides
	})
end

return ExperiencesSkeleton
