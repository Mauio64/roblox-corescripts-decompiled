local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local React = require(parent.React)

local Enums = Foundation.Enums
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Radius = Foundation.Enums.Radius

local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local FFlagSocialCarouselUnselectableSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselUnselectableSkeleton)

local FFlagSocialCarouselRemoveStrokeForAddFriends = require(SocialCarousel.Flags.FFlagSocialCarouselRemoveStrokeForAddFriends)
local FFlagSocialCarouselXSmallTileText = require(SocialCarousel.Flags.FFlagSocialCarouselXSmallTileText)
local FFlagSocialCarouselXXSmallTiles = require(SocialCarousel.Flags.FFlagSocialCarouselXXSmallTiles)
local useXSmallTileTypography = require(SocialCarousel.Hooks.useXSmallTileTypography)

local FIntSocalCarouselMaxNewRequestsCount = require(SocialCarousel.Flags.FIntSocalCarouselMaxNewRequestsCount)

local function Tile(props)
	local tileRef = props.tileRef or React.useRef(nil)
	local v = useTokens()
	local size, onAbsoluteSizeChanged, v2, onAbsoluteSizeChanged2

	if FFlagSocialCarouselXXSmallTiles then
		local v3
		size, v3 = React.useBinding(0)

		onAbsoluteSizeChanged = React.useCallback(function(p)
			v3(p.AbsoluteSize.X * (props.iconScale or 0))
		end, { props.iconScale })
		local v4
		v2, v4 = React.useBinding(0)

		onAbsoluteSizeChanged2 = React.useCallback(function(p)
			v4(p.AbsoluteSize.X)
		end, {})
	else
		v2 = nil
	end

	local state, setState = React.useState(false)
	local v3

	if FFlagSocialCarouselXSmallTileText then
		v3 = useXSmallTileTypography()
	end

	local fontStyle

	if v3 then
		fontStyle = v3.title
	else
		fontStyle = v.Typography.TitleSmall
	end

	local fontStyle2

	if v3 then
		fontStyle2 = v3.label
	else
		fontStyle2 = v.Typography.LabelSmall
	end

	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and props.isLoading

	local useMemo = React.useMemo
	local function fn()
		if props.title then
			return GetTextSize(props.title, fontStyle.FontSize, fontStyle.Font, Vector2.new(500, 500), {
				addTemporaryPadding = false
			})
		end

		return Vector2.new(0, 0)
	end

	local title = props.title
	local v4

	if FFlagSocialCarouselXSmallTileText or FFlagSocialCarouselXXSmallTiles then
		v4 = fontStyle
	end

	local v5 = useMemo(fn, { title, v4 })

	local v6 = React.useMemo(function()
		if not (props.presenceIconEnabled or props.titleIcon) then
			return nil
		end

		if props.presenceIconEnabled then
			return (React.createElement(View, {
				tag = "size-300-300 bg-system-success radius-circle",
				LayoutOrder = 1
			}))
		end

		if props.titleIcon then
			return (React.createElement(Image, {
				Image = props.titleIcon,
				tag = "size-300-300 radius-circle",
				LayoutOrder = 1
			}))
		end

		return nil
	end, { props.titleIcon, props.presenceIconEnabled })

	local useMemo2 = React.useMemo
	local function fn2()
		if FFlagSocialCarouselXXSmallTiles and v2 then
			return React.createElement("UISizeConstraint", {
				MaxSize = v2:map(function(p: number)
					local v7 = p - (v6 and 16 or 0) + 2 * (props.titleOverhang or 0)
					return Vector2.new(math.max(0, v7), v5.Y)
				end)
			})
		end

		if not tileRef.current then
			return nil
		end

		local v7

		if v6 then
			v7 = tileRef.current.AbsoluteSize.X - 16
		else
			v7 = tileRef.current.AbsoluteSize.X
		end

		return (React.createElement("UISizeConstraint", { MaxSize = Vector2.new(v7, v5.Y) }))
	end

	local titleOverhang

	if FFlagSocialCarouselXXSmallTiles then
		titleOverhang = props.titleOverhang
	end

	local v7

	if FFlagSocialCarouselXXSmallTiles then
		v7 = v2
	end

	local v8

	if FFlagSocialCarouselXXSmallTiles then
		v8 = v6
	end

	local uiSizeConstraint = useMemo2(fn2, { v5, titleOverhang, v7, v8 })

	local onStateChanged = React.useCallback(function(p)
		setState(p == Enums.ControlState.Hover or p == Enums.ControlState.Pressed)
	end, {})

	local useMemo3 = React.useMemo
	local function fn3()
		if props.subtitle then
			return (React.createElement(Text, {
				tag = "size-full-0 auto-y clip text-truncate-end",
				fontStyle = fontStyle2,
				Text = props.subtitle,
				LayoutOrder = 3
			}))
		end

		return nil
	end

	local subtitle = props.subtitle
	local v9

	if FFlagSocialCarouselXSmallTileText then
		v9 = fontStyle2
	end

	local subtitle2 = useMemo3(fn3, { subtitle, v9 })

	local badge = React.useMemo(function()
		if props.badge then
			return (React.createElement(StatusIndicator, {
				Position = UDim2.new(0.9, 0, 0.1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				variant = StatusIndicatorVariant.Emphasis,
				value = tonumber(props.badge),
				max = FIntSocalCarouselMaxNewRequestsCount
			}))
		end

		return nil
	end, { props.badge })

	local createElement = React.createElement
	local v10 = {
		testId = props.testId,
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = tileRef,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged2,
		onStateChanged = onStateChanged,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}
	local onActivated

	if not isLoading then
		onActivated = props.onActivated
	end

	v10.onActivated = onActivated
	v10.stateLayer = { affordance = Enums.StateLayerAffordance.None }
	v10.selection = FFlagSocialCarouselUnselectableSkeleton and isLoading and {
			Selectable = false
		}
		or not isLoading and props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = props.selectable == nil or props.selectable
		}
		or nil

	local createElement2 = React.createElement
	local image

	if isLoading then
		image = React.createElement(View, { tag = "size-full aspect-1-1", LayoutOrder = 1 }, {
			AvatarSkeleton = React.createElement(Skeleton, {
				tag = "size-full",
				radius = Radius.Circle
			})
		})
	else
		local createElement3 = React.createElement
		local v11 = {
			Image = props.image,
			tag = {
				["size-full"] = true,
				["aspect-1-1"] = true,
				["bg-shift-300"] = not (state or props.altBackground),
				["bg-system-neutral"] = not state and props.altBackground,
				["radius-circle"] = true,
				["bg-shift-400"] = state and not props.altBackground,
				["bg-system-contrast"] = state and props.altBackground,
				["align-x-center"] = true,
				["align-y-center"] = true,
				row = true
			},
			stroke = not FFlagSocialCarouselRemoveStrokeForAddFriends and {
				Color = v.Color.Stroke.Emphasis.Color3,
				Transparency = v.Color.Stroke.Emphasis.Transparency,
				Thickness = v.Stroke.Thick,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			} or nil,
			LayoutOrder = 1,
			onAbsoluteSizeChanged = 0
		}

		if not (FFlagSocialCarouselXXSmallTiles and props.iconScale) then
			onAbsoluteSizeChanged = nil
		end

		v11.onAbsoluteSizeChanged = onAbsoluteSizeChanged
		local icon

		if props.icon then
			local createElement4 = React.createElement
			local v12 = { name = props.icon, size = 0, variant = 0 }

			if not (FFlagSocialCarouselXXSmallTiles and props.iconScale) then
				size = IconSize.Large
			end

			v12.size = size
			local variant

			if FFlagSocialCarouselXXSmallTiles then
				variant = props.iconVariant
			end

			v12.variant = variant
			icon = createElement4(Icon, v12)
		end

		image = createElement3(Image, v11, { Icon = icon })
	end

	local createElement3 = React.createElement
	local titleIcon

	if not isLoading then
		titleIcon = v6
	end

	local title2

	if props.title and not isLoading then
		title2 = React.createElement(
			Text,
			{
				tag = "auto-xy text-align-x-left clip text-truncate-end",
				fontStyle = fontStyle,
				Text = props.title,
				LayoutOrder = 2
			},
			{ UISizeConstraint = uiSizeConstraint }
		)
	else
		local createElement4 = React.createElement
		local v11 = { Size = UDim2.new(1, 0, 0, 16), radius = 0, LayoutOrder = 2 }
		local radius

		if isLoading then
			radius = Radius.Small
		end

		v11.radius = radius
		title2 = createElement4(Skeleton, v11)
	end

	local v11 = {
		Image = image,
		TextContainer = createElement3(
			View,
			{
				tag = "size-full-0 row auto-y gap-xsmall align-x-center align-y-center",
				LayoutOrder = 2
			},
			{ TitleIcon = titleIcon, Title = title2 }
		),
		Subtitle = 0
	}

	if isLoading then
		subtitle2 = nil
	end

	v11.Subtitle = subtitle2
	local v12 = {
		Content = createElement2(View, { tag = "size-full col align-x-center gap-small" }, v11),
		Badge = 0
	}

	if isLoading then
		badge = nil
	end

	v12.Badge = badge
	return createElement(View, v10, v12)
end

return Tile
