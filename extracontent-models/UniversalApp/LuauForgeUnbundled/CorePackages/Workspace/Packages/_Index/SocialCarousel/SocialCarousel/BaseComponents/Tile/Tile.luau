local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Style").GetTextSize
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
local FFlagSocialCarouselXSmallTileText = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXSmallTileText")
local FFlagSocialCarouselXXSmallTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXXSmallTiles")
local useXSmallTileTypography = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useXSmallTileTypography")

local FIntSocalCarouselMaxNewRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FIntSocalCarouselMaxNewRequestsCount")

local function Tile(props)
	local tileRef = props.tileRef or React.useRef(nil)
	local v5 = useTokens()
	local v6, v7, v8, v9

	if FFlagSocialCarouselXXSmallTiles then
		local v10
		v6, v10 = React.useBinding(0)

		v7 = React.useCallback(function(p2)
			v10(p2.AbsoluteSize.X * (props.iconScale or 0))
		end, { props.iconScale })
		local v11
		v8, v11 = React.useBinding(0)

		v9 = React.useCallback(function(p2)
			v11(p2.AbsoluteSize.X)
		end, {})
	else
		v8 = nil
	end

	local state, setState = React.useState(false)
	local v10 = if FFlagSocialCarouselXSmallTileText then useXSmallTileTypography() else nil
	local v11 = if v10 then v10.title else v5.Typography.TitleSmall
	local v12 = if v10 then v10.label else v5.Typography.LabelSmall
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and props.isLoading

	local function fn()
		if props.title then
			return getTextSize(props.title, v11.FontSize, v11.Font, Vector2.new(500, 500), {
				addTemporaryPadding = false
			})
		end

		return Vector2.new(0, 0)
	end

	local v14 = if FFlagSocialCarouselXSmallTileText or FFlagSocialCarouselXXSmallTiles then v11 else nil
	local v15 = React.useMemo(fn, { props.title, v14 })

	local v16 = React.useMemo(function()
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

	local useMemo2 = React.useMemo
	local function fn2()
		if FFlagSocialCarouselXXSmallTiles and v8 then
			return React.createElement("UISizeConstraint", {
				MaxSize = v8:map(function(p2)
					local v17 = p2 - (v16 and 16 or 0) + 2 * (props.titleOverhang or 0)
					return Vector2.new(math.max(0, v17), v15.Y)
				end)
			})
		end

		if not tileRef.current then
			return nil
		end

		local v17 = if v16 then tileRef.current.AbsoluteSize.X - 16 else tileRef.current.AbsoluteSize.X
		return React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v17, v15.Y)
		})
	end

	local titleOverhang = if FFlagSocialCarouselXXSmallTiles then props.titleOverhang else nil
	local v18 = if FFlagSocialCarouselXXSmallTiles then v8 else nil
	local v20 = useMemo2(fn2, {
		v15,
		titleOverhang,
		v18,
		if FFlagSocialCarouselXXSmallTiles then v16 else nil
	})

	local v21 = React.useCallback(function(p2)
		setState(p2 == enums.ControlState.Hover or p2 == enums.ControlState.Pressed)
	end, {})

	local function fn3()
		if props.subtitle then
			return React.createElement(text, {
				tag = "size-full-0 auto-y clip text-truncate-end",
				fontStyle = v12,
				Text = props.subtitle,
				LayoutOrder = 3
			})
		end

		return nil
	end

	local v24 = React.useMemo(fn3, { props.subtitle, if FFlagSocialCarouselXSmallTileText then v12 else nil })

	local v25 = React.useMemo(function()
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
	local v27 = {
		testId = props.testId,
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = tileRef,
		onAbsoluteSizeChanged = v9,
		onStateChanged = v21,
		onActivated = 0,
		stateLayer = 0,
		selection = 0
	}

	local v28 = if not isLoading then props.onActivated else nil
	v27.onActivated = v28
	v27.stateLayer = { affordance = enums.StateLayerAffordance.None }
	v27.selection = FFlagSocialCarouselUnselectableSkeleton and isLoading and { Selectable = false }
		or not isLoading and props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = props.selectable == nil or props.selectable
		}
		or nil

	local createElement2 = React.createElement
	local v33

	if isLoading then
		v33 = React.createElement(view, {
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
		local v35 = {
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
			LayoutOrder = 1,
			onAbsoluteSizeChanged = 0
		}

		if not (FFlagSocialCarouselXXSmallTiles and props.iconScale) then
			v7 = nil
		end

		v35.onAbsoluteSizeChanged = v7
		local v37

		if props.icon then
			local createElement4 = React.createElement
			local v39 = { name = props.icon, size = 0, variant = 0 }

			if not (FFlagSocialCarouselXXSmallTiles and props.iconScale) then
				v6 = iconSize.Large
			end

			v39.size = v6

			local v40 = if FFlagSocialCarouselXXSmallTiles then props.iconVariant else nil
			v39.variant = v40
			v37 = createElement4(icon, v39)
		end

		v33 = createElement3(image, v35, { Icon = v37 })
	end

	local createElement3 = React.createElement

	local v36 = {
		TitleIcon = if not isLoading then v16 else nil,
		Title = 0
	}
	local v38

	if props.title and not isLoading then
		v38 = React.createElement(
			text,
			{
				tag = "auto-xy text-align-x-left clip text-truncate-end",
				fontStyle = v11,
				Text = props.title,
				LayoutOrder = 2
			},
			{ UISizeConstraint = v20 }
		)
	else
		local createElement4 = React.createElement
		local v40 = { Size = UDim2.new(1, 0, 0, 16), radius = 0, LayoutOrder = 2 }
		local v41 = if isLoading then radius.Small else nil
		v40.radius = v41
		v38 = createElement4(skeleton, v40)
	end

	v36.Title = v38
	local v32 = {
		Image = v33,
		TextContainer = createElement3(
			view,
			{
				tag = "size-full-0 row auto-y gap-xsmall align-x-center align-y-center",
				LayoutOrder = 2
			},
			v36
		),
		Subtitle = 0
	}

	if isLoading then
		v24 = nil
	end

	v32.Subtitle = v24
	local v29 = {
		Content = createElement2(view, {
			tag = "size-full col align-x-center gap-small"
		}, v32),
		Badge = 0
	}

	if isLoading then
		v25 = nil
	end

	v29.Badge = v25
	return createElement(view, v27, v29)
end

return Tile
