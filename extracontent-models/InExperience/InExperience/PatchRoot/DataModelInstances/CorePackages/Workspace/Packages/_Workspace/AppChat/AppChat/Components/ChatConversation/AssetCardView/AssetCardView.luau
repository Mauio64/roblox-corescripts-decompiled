local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local Constants = require(AppChat.Constants)
local getGroupCornerRadii = require(AppChat.Components.ChatConversation.Grouping.getGroupCornerRadii)
local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)
local AssetCardTypes = require(script.Parent.AssetCardTypes)

local Status = AssetCardTypes.Status

local frozen = table.freeze({ Color3 = Color3.new(1, 1, 1), Transparency = 1 })

local function ErrorContent(p)
	local image = React.useMemo(function()
		return (loadFoundationCloudAsset("pictograms/alert"))
	end, {})

	local createElement = React.createElement

	local v = {
		Pictogram = React.createElement(Image, {
			tag = "size-1600 content-system-contrast",
			Image = image,
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1
		}),
		Text = 0
	}
	local text

	if p.text then
		text = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-system-contrast",
			Text = p.text,
			LayoutOrder = 2
		})
	end

	v.Text = text
	return createElement(
		View,
		{
			tag = "col align-x-center gap-small size-full-0 auto-y padding-xxlarge",
			testId = "AssetCardError"
		},
		v
	)
end

local function Media(props)
	local v = useTokens()
	local pictogramScale = props.isPictogram and (props.pictogramScale or 0.66) or 1

	local createElement = React.createElement
	local v2 = {
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
	local image

	if props.image then
		local createElement2 = React.createElement
		local v3 = {
			tag = "position-center-center anchor-center-center",
			testId = "AssetCardMediaImage",
			Size = UDim2.fromScale(pictogramScale, pictogramScale),
			ImageContent = props.image,
			ScaleType = 0,
			imageStyle = 0,
			cornerRadius = 0,
			ZIndex = 1
		}
		local scaleType

		if props.isPictogram then
			scaleType = Enum.ScaleType.Fit
		else
			scaleType = Enum.ScaleType.Crop
		end

		v3.ScaleType = scaleType
		local imageStyle

		if props.isImageLoading then
			imageStyle = frozen
		elseif props.isPictogram then
			imageStyle = v.Color.Content.Emphasis
		end

		v3.imageStyle = imageStyle

		v3.cornerRadius = props.cornerRadii
		image = createElement2(Image, v3)
	end

	local overlay

	if props.overlayIcon then
		overlay = React.createElement(
			View,
			{
				tag = "row align-x-center align-y-center position-center-center anchor-center-center size-1200-1200 radius-circle bg-over-media-0",
				testId = "AssetCardMediaOverlay",
				ZIndex = 3
			},
			{
				Icon = React.createElement(Icon, {
					name = props.overlayIcon,
					size = IconSize.Medium,
					style = v.Color.Content.Emphasis
				})
			}
		)
	end

	return createElement(View, v2, { Image = image, Overlay = overlay })
end

local function SkeletonRow(props)
	return React.createElement(
		View,
		{
			tag = `row align-y-center {props.heightTag}`,
			LayoutOrder = props.LayoutOrder
		},
		{
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(props.width, 1),
				radius = Radius.Small,
				testId = props.testId
			})
		}
	)
end

local function Title(props)
	local v = useTokens()
	local v2 = useTextSizeOffset()

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

	local titleMedium = v.Typography.TitleMedium
	local v3 = math.ceil((titleMedium.FontSize + v2) * titleMedium.LineHeight * props.maxLines)

	return React.createElement(Text, {
		tag = {
			["size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis"] = true,
			["text-wrap"] = props.maxLines > 1
		},
		testId = "AssetCardTitle",
		Text = props.text,
		sizeConstraint = props.maxLines > 1 and { MaxSize = Vector2.new(1e999, v3) } or nil,
		LayoutOrder = props.LayoutOrder
	})
end

local function Subtitle(props)
	if not props.isLoading and props.text == nil then
		return nil
	end

	local tag = {
		["row align-y-center gap-xsmall"] = true,
		["size-full-500"] = props.isLoading,
		["size-full-0 auto-y"] = not props.isLoading
	}

	local createElement = React.createElement
	local v = { tag = tag, testId = "AssetCardSubtitle", LayoutOrder = props.LayoutOrder }
	local icon

	if props.icon then
		icon = React.createElement(Icon, {
			name = props.icon,
			size = IconSize.Small,
			testId = "AssetCardSubtitleIcon",
			LayoutOrder = 1
		})
	end

	local text

	if props.isLoading then
		text = React.createElement(Skeleton, {
			Size = UDim2.fromScale(0.7, 1),
			radius = Radius.Small,
			testId = "AssetCardSubtitleSkeleton",
			LayoutOrder = 2
		})
	else
		text = React.createElement(Text, {
			tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			Text = props.text,
			LayoutOrder = 2
		})
	end

	return createElement(View, v, { Icon = icon, Text = text })
end

local function GameStat(props)
	return React.createElement(
		View,
		{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = props.LayoutOrder },
		{
			Icon = React.createElement(Icon, {
				name = props.icon,
				size = IconSize.Small,
				LayoutOrder = 1
			}),
			Text = React.createElement(Text, {
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
	local v = {
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		testId = "AssetCardGameStats",
		LayoutOrder = props.LayoutOrder
	}
	local rating

	if props.rating then
		rating = React.createElement(GameStat, {
			icon = IconName.ThumbUp,
			text = props.rating,
			LayoutOrder = 1
		})
	end

	local playerCount

	if props.playerCount then
		playerCount = React.createElement(GameStat, {
			icon = IconName.PersonPlay,
			text = props.playerCount,
			LayoutOrder = 2
		})
	end

	return createElement(View, v, { Rating = rating, PlayerCount = playerCount })
end

local function ActionButton(props)
	if props.label then
		return React.createElement(Button, {
			text = props.label,
			icon = props.icon,
			variant = props.variant or ButtonVariant.Standard,
			size = InputSize.Small,
			onActivated = props.onActivated,
			Selectable = props.isSelectable,
			testId = "AssetCardAction",
			LayoutOrder = props.LayoutOrder
		})
	end

	if props.icon == nil then
		return nil
	end

	return React.createElement(IconButton, {
		icon = props.icon,
		isCircular = true,
		variant = ButtonVariant.Emphasis,
		size = InputSize.Medium,
		onActivated = props.onActivated,
		Selectable = props.isSelectable,
		testId = "AssetCardAction",
		LayoutOrder = props.LayoutOrder
	})
end

local function AssetCardView(props)
	local v = useTokens()
	local width = useScaledValue(Constants.AssetCard.WIDTH)
	local size_500 = v.Size.Size_500
	local udim = UDim.new(0, size_500)
	local media = props.media
	local footer = props.footer
	local v2 = props.status == Status.Ready
	local v3 = props.status == Status.Error
	local isSelectable = v2 and media.isSelectable

	local groupCornerRadii = getGroupCornerRadii(props.groupShape, size_500)

	local cornerRadii = footer
		and {
			topLeft = groupCornerRadii.topLeft,
			topRight = groupCornerRadii.topRight,
			bottomLeft = 0,
			bottomRight = 0
		}
		or groupCornerRadii

	local createElement = React.createElement
	local v4 = {
		tag = "col auto-y",
		testId = "AssetCardView",
		Size = UDim2.fromOffset(width, 0),
		backgroundStyle = v.Color.Shift.Shift_400,
		cornerRadius = groupCornerRadii,
		LayoutOrder = props.LayoutOrder
	}
	local err

	if v3 then
		err = React.createElement(ErrorContent, { text = props.errorText })
	end

	local media2

	if not v3 then
		local createElement2 = React.createElement
		local image

		if v2 then
			image = media.image
		end

		local v5 = {
			image = image,
			isImageLoading = media.isLoading == true,
			aspectRatio = media.aspectRatio,
			isPictogram = media.isPictogram == true,
			pictogramScale = media.pictogramScale,
			overlayIcon = media.overlayIcon,
			onActivated = media.onActivated,
			isDisabled = not v2,
			isSelectable = isSelectable,
			width = width,
			cornerRadii = cornerRadii,
			cursorRadius = udim,
			mediaRef = 0,
			LayoutOrder = 1
		}
		local mediaRef

		if isSelectable then
			mediaRef = props.mediaRef
		end

		v5.mediaRef = mediaRef
		media2 = createElement2(Media, v5)
	end

	local footer2

	if not (v3 or not footer) then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v5 = {
			tag = "col fill gap-xsmall auto-y",
			testId = "AssetCardFooterText",
			onActivated = footer.onActivated,
			isDisabled = not v2,
			selection = { Selectable = false },
			cursor = { radius = udim },
			LayoutOrder = 1
		}

		local v6 = {
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
		local rating

		if footer.gameStats then
			rating = footer.gameStats.rating
		end

		local playerCount

		if footer.gameStats then
			playerCount = footer.gameStats.playerCount
		end

		v6.GameStats = createElement4(GameStats, {
			rating = rating,
			playerCount = playerCount,
			isLoading = footer.isGameStatsLoading == true,
			LayoutOrder = 3
		})
		local v7 = { TextColumn = createElement3(View, v5, v6), Action = 0 }
		local action

		if v2 and footer.action then
			action = React.createElement(ActionButton, {
				label = footer.action.label,
				variant = footer.action.variant,
				icon = footer.action.icon,
				onActivated = footer.action.onActivated,
				isSelectable = footer.action.isSelectable,
				LayoutOrder = 2
			})
		end

		v7.Action = action
		footer2 = createElement2(
			View,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium",
				testId = "AssetCardFooter",
				LayoutOrder = 2
			},
			v7
		)
	end

	return createElement(View, v4, { Error = err, Media = media2, Footer = footer2 })
end

return React.memo(AssetCardView)
