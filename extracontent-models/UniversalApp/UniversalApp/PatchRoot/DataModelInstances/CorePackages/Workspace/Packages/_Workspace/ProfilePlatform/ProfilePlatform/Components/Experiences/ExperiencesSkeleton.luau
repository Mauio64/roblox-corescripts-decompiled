local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(ProfilePlatformParent.Foundation)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local View = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local t1 = {
	numColumns = 3
}

local function getTextSizeAdjustedSquareExperienceTileHeight(n1: number) -- line: 23
	return function(n2: number) -- line: 24
		-- upvalues: n1 (copy)
		return n2 + 80 + n1 * 3
	end
end
local function ExperiencesSkeleton(t2: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), TextKeys (copy), useTextSizeOffset (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), SquareCollectionGridView (copy), t1 (copy)
	local v17 = useLocalization({
		experiences = TextKeys.Experiences
	})
	local u18 = useTextSizeOffset()
	local v19 = React.useMemo(function() -- line: 36
		-- upvalues: u18 (ref)
		local v23 = u18

		return function(n3: number) -- line: 24
			-- upvalues: v23 (copy)
			return n3 + 80 + v23 * 3
		end
	end, { u18 })
	local v20 = React.useCallback(function(_, n4: number, p2) -- line: 40
		-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
		return React.createElement(View, {
			tag = "col gap-small radius-medium",
			LayoutOrder = n4,
			Size = p2
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.6),
				radius = EnumsRadius.Medium
			}),
			NameSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromScale(0.8, 0.18),
				radius = EnumsRadius.Medium
			}),
			ButtonSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.fromScale(0.6, 0.08),
				radius = EnumsRadius.Medium
			})
		}), "Skeleton_" .. n4
	end, {})
	local v21 = React.useMemo(function() -- line: 65
		-- upvalues: t2 (copy)
		local t3 = {}

		for i = 1, t2.numSkeletons do
			table.insert(t3, i)
		end

		return t3
	end, { t2.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = t2.layoutOrder,
		items = v21,
		renderItem = v20,
		getItemHeight = v19,
		title = v17.experiences,
		overrides = t1
	})
end

return ExperiencesSkeleton
