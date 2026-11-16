local parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local UIBlox = require(parent.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local UIBlox2 = require(parent.UIBlox)
local useStyle = UIBlox2.Core.Style.useStyle

local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo
local FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon

local Constants = require(script.Parent.Constants)
require(script.Parent.MediaGalleryTypes)

local v = {
	titleText = "Media",
	numItemsShown = 4,
	itemAspectRatio = 16 / 9,
	animationConfig = {
		dampingRatio = 1,
		frequency = 20 / 3
	},
	onActivated = function() end,
	onSelectionGained = function() end,
	exitFullscreen = function() end
}

local function MediaGalleryExpandableView(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local v3

	if FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then
		v3 = useTokens()
	else
		v3 = nil
	end

	local defaultStyleProps = Constants.getDefaultStyleProps(v2)
	local joined2 = Cryo.Dictionary.join(defaultStyleProps, joined.styleProps or {})
	local borderRadius = joined2.borderRadius
	local gutter = joined2.gutter
	local contentGap = joined2.contentGap
	local titleFont = joined2.titleFont
	local titleTextColor = joined2.titleTextColor

	local v4, v5 = ReactOtter.useAnimatedBinding(0)

	local state, setState = React.useState(Vector2.zero)
	local v6 = React.useCallback(function(p2, _: boolean, _, _)
		local v6 = gutter * (joined.numItemsShown - 1)
		local v7 = (p2.AbsoluteSize.X - v6) / joined.numItemsShown
		setState(Vector2.new(v7, v7 / joined.itemAspectRatio))
	end, { gutter, joined.itemAspectRatio, joined.numItemsShown })

	local v7 = React.useCallback(function(ancestor, _: boolean, instance, instance2): nil
		if not ancestor then
			return nil
		end

		local v7

		if instance2 == nil then
			v7 = false
		else
			v7 = instance2:IsDescendantOf(ancestor)
		end

		local v8

		if instance == nil then
			v8 = false
		else
			v8 = instance:IsDescendantOf(ancestor)
		end

		local v9 = not v7 and v8

		if v7 and not v8 then
			v5(ReactOtter.spring(joined.expandableAreaHeightOffset, joined.animationConfig))
			joined.mediaGalleryGainFocused(true)
			return nil
		else
			if not v9 then
				return nil
			end

			local v10

			if instance2 == nil then
				v10 = false
			else
				v10 = instance2.AbsolutePosition.Y > instance.AbsolutePosition.Y
			end

			if not v10 then
				v5(ReactOtter.spring(0, joined.animationConfig))
			end

			joined.exitFullscreen()
			joined.mediaGalleryGainFocused(false)
			return nil
		end
	end, {
		joined.expandableAreaHeightOffset,
		joined.animationConfig,
		joined.exitFullscreen,
		joined.mediaGalleryGainFocused
	})

	local selectionImageObject = useCursor(borderRadius)
	local v8 = useSelectionCursor(CursorKind.Invisible)

	if not joined.showCursor then
		selectionImageObject = v8
	end

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for k, item in joined.items do
			local v9 = "Item" .. k
			local createElement = React.createElement
			local v10 = {
				LayoutOrder = k,
				Size = UDim2.fromOffset(state.X, state.Y),
				Image = item.imageId,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				SelectionImageObject = selectionImageObject,
				[React.Event.Activated] = function()
					joined.onActivated(k)
				end,
				[React.Event.SelectionGained] = function()
					joined.onSelectionGained(k)
				end
			}
			local v11 = {
				Corner = React.createElement("UICorner", { CornerRadius = borderRadius }),
				PlayIcon = 0
			}
			local playIcon

			if FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon and item.videoId then
				playIcon = React.createElement(View, {
					tag = "auto-xy padding-medium radius-circle bg-over-media-100",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ZIndex = 2,
					selection = { Selectable = false }
				}, {
					Icon = React.createElement(Icon, {
						name = "play-large",
						size = IconSize.Medium,
						style = v3.Color.Content.Emphasis
					})
				})
			end

			v11.PlayIcon = playIcon
			children[v9] = createElement("ImageButton", v10, v11)
		end

		return children
	end

	local items = joined.items
	local onActivated = joined.onActivated
	local onSelectionGained = joined.onSelectionGained
	local v9

	if FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then
		v9 = v3
	end

	local v10 = useMemo(fn, {
		state,
		items,
		onActivated,
		onSelectionGained,
		selectionImageObject,
		borderRadius,
		v9
	})
	local v11

	if titleFont.RelativeSize then
		v11 = titleFont.RelativeSize * v2.Font.BaseSize
	else
		v11 = titleFont.FontSize
	end

	local createElement = React.createElement
	local v12 = {
		GroupTransparency = joined.groupTransparency,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = 0
	}
	local ref

	if FFlagLuaAppEdpConsoleMediaGalleryVideo then
		ref = joined.rootRef
	end

	v12.ref = ref
	return createElement("CanvasGroup", v12, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, contentGap)
		}),
		ExpandableArea = React.createElement("Frame", {
			Size = v4:map(function(p2)
				return UDim2.new(1, 0, 0, p2)
			end),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}),
		Title = React.createElement(StyledTextLabel, {
			text = joined.titleText,
			fontStyle = titleFont,
			colorStyle = titleTextColor,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0, v11),
			layoutOrder = 2
		}),
		MediaGallery = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, state.Y),
			BackgroundTransparency = 1,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false,
			LayoutOrder = 3,
			[React.Change.AbsoluteSize] = v6,
			[React.Event.SelectionChanged] = v7
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, gutter)
			}),
			Items = React.createElement(React.Fragment, {}, v10)
		})
	})
end

return MediaGalleryExpandableView
