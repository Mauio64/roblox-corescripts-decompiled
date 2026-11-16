local TextService = game:GetService("TextService")

local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

local FIntSocalCarouselMaxNewRequestsCount = require(SocialCarousel.Flags.FIntSocalCarouselMaxNewRequestsCount)

local function Tile(props)
	local tileRef = props.tileRef or React.useRef(nil)
	local v = useTokens()
	local state, setState = React.useState(false)
	local titleSmall = v.Typography.TitleSmall
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and props.isLoading

	local v2 = React.useMemo(function()
		if not props.title then
			return Vector2.new(0, 0)
		end

		if FoundationFontFaceMigration then
			return (GetTextSize(props.title, titleSmall.FontSize, titleSmall.Font, Vector2.new(500, 500), {
				addTemporaryPadding = false
			}))
		end

		return (TextService:GetTextSize(props.title, titleSmall.FontSize, titleSmall.Font, Vector2.new(500, 500)))
	end, { props.title })

	local v3 = React.useMemo(function()
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

	local uiSizeConstraint = React.useMemo(function()
		if not tileRef.current then
			return nil
		end

		local v4

		if v3 then
			v4 = tileRef.current.AbsoluteSize.X - 16
		else
			v4 = tileRef.current.AbsoluteSize.X
		end

		return (React.createElement("UISizeConstraint", { MaxSize = Vector2.new(v4, v2.Y) }))
	end, { v2 })

	local onStateChanged = React.useCallback(function(p)
		setState(p == Enums.ControlState.Hover or p == Enums.ControlState.Pressed)
	end, {})

	local subtitle = React.useMemo(function()
		if props.subtitle then
			return (React.createElement(Text, {
				tag = "size-full-0 auto-y clip text-truncate-end",
				fontStyle = v.Typography.LabelSmall,
				Text = props.subtitle,
				LayoutOrder = 3
			}))
		end

		return nil
	end, { props.subtitle })

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
	local v4 = {
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = tileRef,
		onStateChanged = onStateChanged,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}
	local onActivated

	if not isLoading then
		onActivated = props.onActivated
	end

	v4.onActivated = onActivated
	v4.stateLayer = { affordance = Enums.StateLayerAffordance.None }
	v4.selection = FFlagSocialCarouselUnselectableSkeleton and isLoading and {
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
		local v5 = {
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
			LayoutOrder = 1
		}
		local icon

		if props.icon then
			icon = React.createElement(Icon, { name = props.icon, size = IconSize.Large })
		end

		image = createElement3(Image, v5, { Icon = icon })
	end

	local createElement3 = React.createElement
	local titleIcon

	if not isLoading then
		titleIcon = v3
	end

	local title

	if props.title and not isLoading then
		title = React.createElement(
			Text,
			{
				tag = "auto-xy text-align-x-left clip text-truncate-end",
				fontStyle = v.Typography.TitleSmall,
				Text = props.title,
				LayoutOrder = 2
			},
			{ UISizeConstraint = uiSizeConstraint }
		)
	else
		local createElement4 = React.createElement
		local v5 = { Size = UDim2.new(1, 0, 0, 16), radius = 0, LayoutOrder = 2 }
		local radius

		if isLoading then
			radius = Radius.Small
		end

		v5.radius = radius
		title = createElement4(Skeleton, v5)
	end

	local v5 = {
		Image = image,
		TextContainer = createElement3(
			View,
			{
				tag = "size-full-0 row auto-y gap-xsmall align-x-center align-y-center",
				LayoutOrder = 2
			},
			{ TitleIcon = titleIcon, Title = title }
		),
		Subtitle = 0
	}

	if isLoading then
		subtitle = nil
	end

	v5.Subtitle = subtitle
	local v6 = {
		Content = createElement2(View, { tag = "size-full col align-x-center gap-small" }, v5),
		Badge = 0
	}

	if isLoading then
		badge = nil
	end

	v6.Badge = badge
	return createElement(View, v4, v6)
end

return Tile
