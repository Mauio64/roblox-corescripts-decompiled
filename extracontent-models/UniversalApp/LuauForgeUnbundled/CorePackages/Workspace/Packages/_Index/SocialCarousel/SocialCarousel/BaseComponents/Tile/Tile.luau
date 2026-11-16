local TextService = game:GetService("TextService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

local enums = Foundation.Enums
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local radius = Foundation.Enums.Radius

local FFlagSocialCarouselShowLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowLoadingSkeleton")
local FFlagSocialCarouselUnselectableSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselUnselectableSkeleton")

local FFlagSocialCarouselRemoveStrokeForAddFriends = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselRemoveStrokeForAddFriends")

local FIntSocalCarouselMaxNewRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FIntSocalCarouselMaxNewRequestsCount")

local function Tile(props)
	local tileRef = props.tileRef or React.useRef(nil)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local titleSmall = v5.Typography.TitleSmall
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and props.isLoading

	local v6 = React.useMemo(function()
		if not props.title then
			return Vector2.new(0, 0)
		end

		if foundationFontFaceMigration then
			return (getTextSize(props.title, titleSmall.FontSize, titleSmall.Font, Vector2.new(500, 500), {
				addTemporaryPadding = false
			}))
		end

		return (TextService:GetTextSize(
			props.title,
			titleSmall.FontSize,
			titleSmall.Font,
			Vector2.new(500, 500)
		))
	end, { props.title })

	local v7 = React.useMemo(function()
		if not (props.presenceIconEnabled or props.titleIcon) then
			return nil
		end

		if props.presenceIconEnabled then
			return React.createElement(view, {
				tag = "size-300-300 bg-system-success radius-circle",
				LayoutOrder = 1
			})
		end

		if props.titleIcon then
			return React.createElement(image, {
				Image = props.titleIcon,
				tag = "size-300-300 radius-circle",
				LayoutOrder = 1
			})
		end

		return nil
	end, { props.titleIcon, props.presenceIconEnabled })

	local v8 = React.useMemo(function()
		if not tileRef.current then
			return nil
		end

		local v9 = if v7 then tileRef.current.AbsoluteSize.X - 16 else tileRef.current.AbsoluteSize.X
		return React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v9, v6.Y)
		})
	end, { v6 })

	local v9 = React.useCallback(function(p2)
		setState(p2 == enums.ControlState.Hover or p2 == enums.ControlState.Pressed)
	end, {})

	local v10 = React.useMemo(function()
		if props.subtitle then
			return React.createElement(text, {
				tag = "size-full-0 auto-y clip text-truncate-end",
				fontStyle = v5.Typography.LabelSmall,
				Text = props.subtitle,
				LayoutOrder = 3
			})
		end

		return nil
	end, { props.subtitle })

	local v11 = React.useMemo(function()
		if props.badge then
			return React.createElement(statusIndicator, {
				Position = UDim2.new(0.9, 0, 0.1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				variant = statusIndicatorVariant.Emphasis,
				value = tonumber(props.badge),
				max = FIntSocalCarouselMaxNewRequestsCount
			})
		end

		return nil
	end, { props.badge })

	local createElement = React.createElement
	local v13 = {
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = tileRef,
		onStateChanged = v9,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}

	local v14 = if not isLoading then props.onActivated else nil
	v13.onActivated = v14
	v13.stateLayer = { affordance = enums.StateLayerAffordance.None }
	v13.selection = FFlagSocialCarouselUnselectableSkeleton and isLoading and { Selectable = false }
		or not isLoading and props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = props.selectable == nil or props.selectable
		}
		or nil

	local createElement2 = React.createElement
	local v19

	if isLoading then
		v19 = React.createElement(view, {
			tag = "size-full aspect-1-1",
			LayoutOrder = 1
		}, {
			AvatarSkeleton = React.createElement(skeleton, {
				tag = "size-full",
				radius = radius.Circle
			})
		})
	else
		local createElement3 = React.createElement
		local v21 = {
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
				Color = v5.Color.Stroke.Emphasis.Color3,
				Transparency = v5.Color.Stroke.Emphasis.Transparency,
				Thickness = v5.Stroke.Thick,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			} or nil,
			LayoutOrder = 1
		}

		local v23 = if props.icon then React.createElement(icon, {
			name = props.icon,
			size = iconSize.Large
		}) else nil
		v19 = createElement3(image, v21, { Icon = v23 })
	end

	local createElement3 = React.createElement

	local v22 = {
		TitleIcon = if not isLoading then v7 else nil,
		Title = 0
	}
	local v24

	if props.title and not isLoading then
		v24 = React.createElement(
			text,
			{
				tag = "auto-xy text-align-x-left clip text-truncate-end",
				fontStyle = v5.Typography.TitleSmall,
				Text = props.title,
				LayoutOrder = 2
			},
			{ UISizeConstraint = v8 }
		)
	else
		local createElement4 = React.createElement
		local v26 = { Size = UDim2.new(1, 0, 0, 16), radius = 0, LayoutOrder = 2 }
		local v27 = if isLoading then radius.Small else nil
		v26.radius = v27
		v24 = createElement4(skeleton, v26)
	end

	v22.Title = v24
	local v18 = {
		Image = v19,
		TextContainer = createElement3(
			view,
			{
				tag = "size-full-0 row auto-y gap-xsmall align-x-center align-y-center",
				LayoutOrder = 2
			},
			v22
		),
		Subtitle = 0
	}

	if isLoading then
		v10 = nil
	end

	v18.Subtitle = v10
	local v15 = {
		Content = createElement2(view, {
			tag = "size-full col align-x-center gap-small"
		}, v18),
		Badge = 0
	}

	if isLoading then
		v11 = nil
	end

	v15.Badge = v11
	return createElement(view, v13, v15)
end

return Tile
