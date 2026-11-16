local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactOtter")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox").Core.Style.useStyle

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local icon = Foundation.Icon
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local fFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo
local fFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryTypes")

local v5 = {
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

local function MediaGalleryExpandableView(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local v7 = if fFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then useTokens() else nil
	local defaultStyleProps = Constants.getDefaultStyleProps(v6)
	local joined2 = Cryo.Dictionary.join(defaultStyleProps, joined.styleProps or {})
	local borderRadius = joined2.borderRadius
	local gutter = joined2.gutter
	local contentGap = joined2.contentGap
	local titleFont = joined2.titleFont
	local titleTextColor = joined2.titleTextColor

	local v8, v9 = ReactOtter.useAnimatedBinding(0)

	local state, setState = React.useState(Vector2.zero)
	local v10 = React.useCallback(function(p3, p4, p5, p6)
		local v11 = gutter * (joined.numItemsShown - 1)
		local v12 = (p3.AbsoluteSize.X - v11) / joined.numItemsShown
		setState(Vector2.new(v12, v12 / joined.itemAspectRatio))
	end, { gutter, joined.itemAspectRatio, joined.numItemsShown })

	local v11 = React.useCallback(function(ancestor, p3, instance, instance2): nil
		if not ancestor then
			return nil
		end

		local v12 = not (instance2 == nil) and instance2:IsDescendantOf(ancestor)
		local v13 = not (instance == nil) and instance:IsDescendantOf(ancestor)

		local v14 = not v12 and v13

		if v12 and not v13 then
			v9(ReactOtter.spring(joined.expandableAreaHeightOffset, joined.animationConfig))
			joined.mediaGalleryGainFocused(true)
			return nil
		else
			if not v14 then
				return nil
			end

			local v15 = not (instance2 == nil)
				and instance2.AbsolutePosition.Y > instance.AbsolutePosition.Y

			if not v15 then
				v9(ReactOtter.spring(0, joined.animationConfig))
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

	local v12 = useCursor(borderRadius)
	local v13 = useSelectionCursor(cursorKind.Invisible)

	if not joined.showCursor then
		v12 = v13
	end

	local function fn()
		local children = {}

		for k, item in joined.items do
			local v14 = "Item" .. k
			local createElement = React.createElement
			local v16 = {
				LayoutOrder = k,
				Size = UDim2.fromOffset(state.X, state.Y),
				Image = item.imageId,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				SelectionImageObject = v12,
				[React.Event.Activated] = function()
					joined.onActivated(k)
				end,
				[React.Event.SelectionGained] = function()
					joined.onSelectionGained(k)
				end
			}
			local v17 = {
				Corner = React.createElement("UICorner", {
					CornerRadius = borderRadius
				}),
				PlayIcon = 0
			}

			local v18 = if fFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon and item.videoId then React.createElement(view, {
				tag = "auto-xy padding-medium radius-circle bg-over-media-100",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ZIndex = 2,
				selection = { Selectable = false }
			}, {
				Icon = React.createElement(icon, {
					name = "play-large",
					size = iconSize.Medium,
					style = v7.Color.Content.Emphasis
				})
			}) else nil
			v17.PlayIcon = v18
			children[v14] = createElement("ImageButton", v16, v17)
		end

		return children
	end

	local v16 = React.useMemo(fn, {
		state,
		joined.items,
		joined.onActivated,
		joined.onSelectionGained,
		v12,
		borderRadius,
		if fFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then v7 else nil
	})
	local v17

	if titleFont.RelativeSize then
		v17 = titleFont.RelativeSize * v6.Font.BaseSize
	else
		v17 = titleFont.FontSize
	end

	local createElement = React.createElement
	local v19 = {
		GroupTransparency = joined.groupTransparency,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = 0
	}

	local v20 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then joined.rootRef else nil
	v19.ref = v20
	return createElement("CanvasGroup", v19, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, contentGap)
		}),
		ExpandableArea = React.createElement("Frame", {
			Size = v8:map(function(p3)
				return UDim2.new(1, 0, 0, p3)
			end),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}),
		Title = React.createElement(styledTextLabel, {
			text = joined.titleText,
			fontStyle = titleFont,
			colorStyle = titleTextColor,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0, v17),
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
			[React.Change.AbsoluteSize] = v10,
			[React.Event.SelectionChanged] = v11
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, gutter)
			}),
			Items = React.createElement(React.Fragment, {}, v16)
		})
	})
end

return MediaGalleryExpandableView
