local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local UnibarList = require(InExperienceSideSheet.Components.UnibarList)
local useExperienceIcon = require(InExperienceSideSheet.Hooks.useExperienceIcon)
local useExperienceName = require(InExperienceSideSheet.Hooks.useExperienceName)

local function ExperienceDetailsRow(t1: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), useExperienceName (copy), useExperienceIcon (copy), React (copy), View (copy), FoundationImage (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy), UnibarList (copy)
	local v16 = useTokens()
	local v17 = useExperienceName()
	local v18 = useExperienceIcon()

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-1400 padding-right-xlarge",
		LayoutOrder = t1.layoutOrder
	}, {
		ExperienceIconContainer = React.createElement(View, {
			tag = "size-600",
			LayoutOrder = 1
		}, {
			ExperienceIcon = v18 and React.createElement(FoundationImage, {
				tag = "size-full radius-small",
				Image = v18
			}),
			ExperienceIconSkeleton = not v18 and React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Small
			})
		}),
		ExperienceNameContainer = React.createElement(View, {
			tag = "fill auto-y",
			LayoutOrder = 2
		}, {
			ExperienceName = v17 and React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-split content-emphasis",
				Text = v17
			}),
			ExperienceNameSkeleton = not v17 and React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v16.Size.Size_500),
				radius = EnumsRadius.Small
			})
		}),
		UnibarList = React.createElement(UnibarList, {
			layoutOrder = 3
		})
	})
end

return React.memo(ExperienceDetailsRow)
