local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local icon = Foundation.Icon
local button = Foundation.Button
local iconButton = Foundation.IconButton
local skeleton = Foundation.Skeleton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local getGroupCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/getGroupCornerRadii")
local loadFoundationCloudAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/loadFoundationCloudAsset")
local status = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardTypes").Status

local frozen = table.freeze({ Color3 = Color3.new(1, 1, 1), Transparency = 1 })

local function ErrorContent(p2)
	local v5 = React.useMemo(function()
		return (loadFoundationCloudAsset("pictograms/alert"))
	end, {})

	local createElement = React.createElement

	local v8 = {
		Pictogram = React.createElement(image, {
			tag = "size-1600 content-system-contrast",
			Image = v5,
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1
		}),
		Text = 0
	}

	local v9 = if p2.text then React.createElement(text, {
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-system-contrast",
		Text = p2.text,
		LayoutOrder = 2
	}) else nil
	v8.Text = v9
	return createElement(
		view,
		{
			tag = "col align-x-center gap-small size-full-0 auto-y padding-xxlarge",
			testId = "AssetCardError"
		},
		v8
	)
end

local function Media(props)
	local v5 = useTokens()
	local pictogramScale = props.isPictogram and (props.pictogramScale or 0.66) or 1

	local createElement = React.createElement
	local v7 = {
		tag = "bg-shift-200",
		testId = "AssetCardMedia",
		Size = UDim2.fromOffset(props.width, (math.round(props.width / props.aspectRatio))),
		cornerRadius = props.cornerRadii,
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		selection = { Selectable = props.isSelectable },
		cursor = { radius = props.cursorRadius },
		ref = props.mediaRef,
		LayoutOrder = props.LayoutOrder
	}
	local v9

	if props.image then
		local createElement2 = React.createElement
		local v11 = {
			tag = "position-center-center anchor-center-center",
			testId = "AssetCardMediaImage",
			Size = UDim2.fromScale(pictogramScale, pictogramScale),
			ImageContent = props.image,
			ScaleType = 0,
			imageStyle = 0,
			cornerRadius = 0,
			ZIndex = 1
		}
		local v12 = if props.isPictogram then Enum.ScaleType.Fit else Enum.ScaleType.Crop
		v11.ScaleType = v12
		local v13

		if props.isImageLoading then
			v13 = frozen
		elseif props.isPictogram then
			v13 = v5.Color.Content.Emphasis
		end

		v11.imageStyle = v13

		v11.cornerRadius = props.cornerRadii
		v9 = createElement2(image, v11)
	end

	local v10 = if props.overlayIcon then React.createElement(
		view,
		{
			tag = "row align-x-center align-y-center position-center-center anchor-center-center size-1200-1200 radius-circle bg-over-media-0",
			testId = "AssetCardMediaOverlay",
			ZIndex = 3
		},
		{
			Icon = React.createElement(icon, {
				name = props.overlayIcon,
				size = iconSize.Medium,
				style = v5.Color.Content.Emphasis
			})
		}
	) else nil
	return createElement(view, v7, { Image = v9, Overlay = v10 })
end

local function SkeletonRow(props)
	return React.createElement(
		view,
		{
			tag = `row align-y-center {props.heightTag}`,
			LayoutOrder = props.LayoutOrder
		},
		{
			Skeleton = React.createElement(skeleton, {
				Size = UDim2.fromScale(props.width, 1),
				radius = radius.Small,
				testId = props.testId
			})
		}
	)
end

local function Title(props)
	local v5 = useTokens()
	local v6 = useTextSizeOffset()

	if props.isLoading then
		return React.createElement(SkeletonRow, {
			heightTag = "size-full-500",
			width = 0.6,
			testId = "AssetCardTitleSkeleton",
			LayoutOrder = props.LayoutOrder
		})
	end

	if props.text == nil then
		return nil
	end

	local titleMedium = v5.Typography.TitleMedium
	local v7 = math.ceil((titleMedium.FontSize + v6) * titleMedium.LineHeight * props.maxLines)

	return React.createElement(text, {
		tag = {
			["size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis"] = true,
			["text-wrap"] = props.maxLines > 1
		},
		testId = "AssetCardTitle",
		Text = props.text,
		sizeConstraint = props.maxLines > 1 and { MaxSize = Vector2.new(1e999, v7) } or nil,
		LayoutOrder = props.LayoutOrder
	})
end

local function Subtitle(props)
	if not props.isLoading and props.text == nil then
		return nil
	end

	local v5 = {
		["row align-y-center gap-xsmall"] = true,
		["size-full-500"] = props.isLoading,
		["size-full-0 auto-y"] = not props.isLoading
	}

	local createElement = React.createElement
	local v7 = {
		tag = v5,
		testId = "AssetCardSubtitle",
		LayoutOrder = props.LayoutOrder
	}

	local v9 = if props.icon then React.createElement(icon, {
		name = props.icon,
		size = iconSize.Small,
		testId = "AssetCardSubtitleIcon",
		LayoutOrder = 1
	}) else nil

	local v10 = if props.isLoading then React.createElement(skeleton, {
		Size = UDim2.fromScale(0.7, 1),
		radius = radius.Small,
		testId = "AssetCardSubtitleSkeleton",
		LayoutOrder = 2
	}) else React.createElement(text, {
		tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default",
		Text = props.text,
		LayoutOrder = 2
	})
	return createElement(view, v7, { Icon = v9, Text = v10 })
end

local function GameStat(props)
	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = props.LayoutOrder
		},
		{
			Icon = React.createElement(icon, {
				name = props.icon,
				size = iconSize.Small,
				LayoutOrder = 1
			}),
			Text = React.createElement(text, {
				tag = "auto-xy text-body-small content-default",
				Text = props.text,
				LayoutOrder = 2
			})
		}
	)
end

local function GameStats(props)
	if props.isLoading then
		return React.createElement(SkeletonRow, {
			heightTag = "size-full-400",
			width = 0.4,
			testId = "AssetCardGameStatsSkeleton",
			LayoutOrder = props.LayoutOrder
		})
	end

	if props.rating == nil and props.playerCount == nil then
		return nil
	end

	local createElement = React.createElement
	local v6 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		testId = "AssetCardGameStats",
		LayoutOrder = props.LayoutOrder
	}

	local v8 = if props.rating then React.createElement(GameStat, {
		icon = iconName.ThumbUp,
		text = props.rating,
		LayoutOrder = 1
	}) else nil

	local v9 = if props.playerCount then React.createElement(GameStat, {
		icon = iconName.PersonPlay,
		text = props.playerCount,
		LayoutOrder = 2
	}) else nil
	return createElement(view, v6, { Rating = v8, PlayerCount = v9 })
end

local function ActionButton(props)
	if props.label then
		return React.createElement(button, {
			text = props.label,
			icon = props.icon,
			variant = props.variant or buttonVariant.Standard,
			size = inputSize.Small,
			onActivated = props.onActivated,
			Selectable = props.isSelectable,
			testId = "AssetCardAction",
			LayoutOrder = props.LayoutOrder
		})
	end

	if props.icon == nil then
		return nil
	end

	return React.createElement(iconButton, {
		icon = props.icon,
		isCircular = true,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		onActivated = props.onActivated,
		Selectable = props.isSelectable,
		testId = "AssetCardAction",
		LayoutOrder = props.LayoutOrder
	})
end

local function AssetCardView(props)
	local v5 = useTokens()
	local v6 = useScaledValue(Constants.AssetCard.WIDTH)
	local size_500 = v5.Size.Size_500
	local udim = UDim.new(0, size_500)
	local media = props.media
	local footer = props.footer
	local v7 = props.status == status.Ready
	local v8 = props.status == status.Error
	local isSelectable = v7 and media.isSelectable

	local v9 = getGroupCornerRadii(props.groupShape, size_500)

	local v10 = footer
		and {
			topLeft = v9.topLeft,
			topRight = v9.topRight,
			bottomLeft = 0,
			bottomRight = 0
		}
		or v9

	local createElement = React.createElement
	local v12 = {
		tag = "col auto-y",
		testId = "AssetCardView",
		Size = UDim2.fromOffset(v6, 0),
		backgroundStyle = v5.Color.Shift.Shift_400,
		cornerRadius = v9,
		LayoutOrder = props.LayoutOrder
	}

	local v14 = if v8 then React.createElement(ErrorContent, {
		text = props.errorText
	}) else nil
	local v15

	if not v8 then
		local createElement2 = React.createElement
		local v18 = if v7 then media.image else nil
		local v17 = {
			image = v18,
			isImageLoading = media.isLoading == true,
			aspectRatio = media.aspectRatio,
			isPictogram = media.isPictogram == true,
			pictogramScale = media.pictogramScale,
			overlayIcon = media.overlayIcon,
			onActivated = media.onActivated,
			isDisabled = not v7,
			isSelectable = isSelectable,
			width = v6,
			cornerRadii = v10,
			cursorRadius = udim,
			mediaRef = 0,
			LayoutOrder = 1
		}

		local v19 = if isSelectable then props.mediaRef else nil
		v17.mediaRef = v19
		v15 = createElement2(Media, v17)
	end

	local v16

	if not (v8 or not footer) then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v21 = {
			tag = "col fill gap-xsmall auto-y",
			testId = "AssetCardFooterText",
			onActivated = footer.onActivated,
			isDisabled = not v7,
			selection = { Selectable = false },
			cursor = { radius = udim },
			LayoutOrder = 1
		}

		local v22 = {
			Title = React.createElement(Title, {
				text = footer.titleText,
				maxLines = footer.titleMaxLines or 1,
				isLoading = footer.isTitleLoading == true,
				LayoutOrder = 1
			}),
			Subtitle = React.createElement(Subtitle, {
				text = footer.subtitleText,
				icon = footer.subtitleIcon,
				isLoading = footer.isSubtitleLoading == true,
				LayoutOrder = 2
			}),
			GameStats = 0
		}

		local createElement4 = React.createElement
		local v25 = if footer.gameStats then footer.gameStats.rating else nil
		local v26 = if footer.gameStats then footer.gameStats.playerCount else nil
		v22.GameStats = createElement4(GameStats, {
			rating = v25,
			playerCount = v26,
			isLoading = footer.isGameStatsLoading == true,
			LayoutOrder = 3
		})
		local v19 = { TextColumn = createElement3(view, v21, v22), Action = 0 }

		local v27 = if v7 and footer.action then React.createElement(ActionButton, {
			label = footer.action.label,
			variant = footer.action.variant,
			icon = footer.action.icon,
			onActivated = footer.action.onActivated,
			isSelectable = footer.action.isSelectable,
			LayoutOrder = 2
		}) else nil
		v19.Action = v27
		v16 = createElement2(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium",
				testId = "AssetCardFooter",
				LayoutOrder = 2
			},
			v19
		)
	end

	return createElement(view, v12, { Error = v14, Media = v15, Footer = v16 })
end

return React.memo(AssetCardView)
