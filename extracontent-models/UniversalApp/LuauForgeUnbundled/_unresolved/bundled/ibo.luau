local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibj")
local icon = module2.Icon
local image = module2.Image
local skeleton = module2.Skeleton
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens
local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize
local radius = module2.Enums.Radius

local useAssetFetchStatus = require("@luauforge/bundled/ibp").Hooks.useAssetFetchStatus
local module3 = require("@luauforge/bundled/ibq")
local module4 = require("@luauforge/bundled/ibr")

local function ProfileChip(props, p2)
	local v5 = useTokens()

	local v6 = useAssetFetchStatus(props.thumbnail) == Enum.AssetFetchStatus.Success

	local v7 = if module4 then not (props.thumbnail == nil) and props.thumbnail ~= "" else v6

	local titleLarge = v5.Typography.TitleLarge

	local createElement = module.createElement
	local v9 = {
		tag = "row align-y-center gap-medium size-0-1000 auto-x padding-xsmall radius-medium",
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		ref = p2
	}

	local createElement2 = module.createElement
	local v11 = {
		tag = "size-1000-1000 radius-circle",
		backgroundStyle = v5.Inverse.Common.Shimmer,
		LayoutOrder = 1
	}

	local v13 = if not (props.isUserLoaded and v6) then module.createElement(skeleton, {
		radius = radius.Circle,
		ZIndex = 1,
		testId = module4 and "profile-chip-thumbnail-shimmer" or nil
	}) else nil

	local v14 = if v7 then module.createElement(image, {
		tag = "size-full radius-circle",
		Image = props.thumbnail,
		ZIndex = 2,
		testId = module4 and "profile-chip-thumbnail" or nil
	}) else nil
	local children = {
		AvatarThumbnail = createElement2(view, v11, {
			ThumbnailShimmer = v13,
			Thumbnail = v14
		}),
		TextStack = 0
	}

	local createElement3 = module.createElement

	local createElement4 = module.createElement

	local v21 = if not props.isUserLoaded then module.createElement(skeleton, {
		radius = radius.Small,
		Size = UDim2.fromOffset(v5.Size.Size_3000, v5.Size.Size_300)
	}) else nil

	local v22 = if props.isUserLoaded then module.createElement(text, {
		tag = "auto-xy content-inverse-emphasis",
		fontStyle = titleLarge,
		Text = props.name,
		LayoutOrder = 1
	}) else nil

	local v23 = if props.isUserLoaded and props.isVerified then module.createElement(module3, {
		size = iconSize.Large,
		LayoutOrder = 2
	}) else nil

	local v24 = if props.isUserLoaded and props.showSubscriberBadge then module.createElement(icon, {
		name = iconName.RobloxPlus,
		size = iconSize.Small,
		style = v5.Inverse.Content.Emphasis,
		LayoutOrder = 3
	}) else nil
	children.TextStack = createElement3(view, { tag = "auto-xy", LayoutOrder = 2 }, {
		DisplayNameRow = createElement4(
			view,
			{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 1 },
			{
				DisplayNameShimmer = v21,
				DisplayNameText = v22,
				VerifiedBadge = v23,
				SubscriberBadge = v24
			}
		)
	})
	return createElement(view, v9, children)
end

local forwardRef = module.forwardRef(ProfileChip)
return module.memo(forwardRef)
