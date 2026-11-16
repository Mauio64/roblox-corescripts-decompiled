local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local UnibarList = require(InExperienceSideSheet.Components.UnibarList)

local useExperienceDetails = require(InExperienceSideSheet.Hooks.useExperienceDetails)
local useExperienceIcon = require(InExperienceSideSheet.Hooks.useExperienceIcon)

local function ExperienceDetailsRow(p)
	local v = useTokens()

	local text, v2, v3 = useExperienceDetails()
	local image = useExperienceIcon()

	local v4 = v.Padding.XXSmall * 2
	local v5 = v.Typography.TitleMedium.LineHeight * v.Typography.TitleMedium.FontSize - v4
	local v6 = v.Typography.BodyMedium.LineHeight * v.Typography.BodyMedium.FontSize - v4
	local experienceNameSkeleton

	if not (text or not v3) then
		experienceNameSkeleton = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "size-full-0 auto-y padding-y-xxsmall" },
			{
				Skeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, v5),
					radius = Radius.Small,
					testId = "experience-name-placeholder"
				})
			}
		)
	end

	local name

	if v2 then
		name = v2.name
	end

	local v7

	if v2 then
		v7 = v2.hasVerifiedBadge == true
	else
		v7 = false
	end

	local creatorRow

	if name == nil or name == "" then
		if v3 then
			creatorRow = React.createElement(View, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y padding-y-xxsmall"
			}, {
				Skeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, v6),
					radius = Radius.Small,
					testId = "experience-publisher-placeholder"
				})
			})
		end
	else
		local createElement = React.createElement

		local v8 = {
			CreatorName = React.createElement(Text, {
				LayoutOrder = 1,
				Text = name,
				tag = "shrink auto-xy text-body-medium text-align-x-left text-truncate-end content-default"
			}),
			VerifiedBadge = 0
		}
		local verifiedBadge

		if v7 then
			verifiedBadge = React.createElement(VerifiedBadge, {
				LayoutOrder = 2,
				testId = "experience-creator-verified-badge"
			})
		end

		v8.VerifiedBadge = verifiedBadge
		creatorRow = createElement(
			View,
			{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
			v8
		)
	end

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y padding-y-large",
			LayoutOrder = p.layoutOrder
		},
		{
			Leading = React.createElement(
				View,
				{ tag = "row align-y-center fill gap-medium auto-y", LayoutOrder = 1 },
				{
					ExperienceIconContainer = React.createElement(View, {
						tag = "size-1000",
						LayoutOrder = 1
					}, {
						ExperienceIcon = image and React.createElement(Image, {
							Image = image,
							tag = "size-full radius-small"
						}),
						ExperienceIconSkeleton = not image and React.createElement(Skeleton, {
							Size = UDim2.fromScale(1, 1),
							radius = Radius.Small
						})
					}),
					ExperienceNameContainer = React.createElement(
						View,
						{ tag = "col fill gap-none auto-y", LayoutOrder = 2 },
						{
							ExperienceName = text and React.createElement(Text, {
								LayoutOrder = 1,
								Text = text,
								tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-split content-emphasis"
							}),
							ExperienceNameSkeleton = experienceNameSkeleton,
							CreatorRow = creatorRow
						}
					)
				}
			),
			UnibarList = React.createElement(UnibarList, { layoutOrder = 3 })
		}
	)
end

return React.memo(ExperienceDetailsRow)
