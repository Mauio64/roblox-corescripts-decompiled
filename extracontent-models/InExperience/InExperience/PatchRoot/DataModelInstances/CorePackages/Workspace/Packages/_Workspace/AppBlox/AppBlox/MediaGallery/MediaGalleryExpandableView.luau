local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local UIBlox = require(Parent.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useStyle = require(Parent.UIBlox).Core.Style.useStyle
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo
local FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon
local Constants = require(script.Parent.Constants)

require(script.Parent.MediaGalleryTypes)

local t1 = {
	titleText = "Media",
	numItemsShown = 4,
	itemAspectRatio = 1.7777777777777777,
	animationConfig = {
		dampingRatio = 1,
		frequency = 6.666666666666667
	},
	onActivated = function() -- line: 39
	end,
	onSelectionGained = function() -- line: 40
	end,
	exitFullscreen = function() -- line: 41
	end
}

local function MediaGalleryExpandableView(t2: {[any]: any}) -- line: 79
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon (copy), useTokens (copy), Constants (copy), ReactOtter (copy), React (copy), useCursor (copy), useSelectionCursor (copy), CursorKind (copy), View (copy), Icon (copy), IconSize (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), StyledTextLabel (copy)
	local v23 = Cryo.Dictionary.join(t1, t2)
	local v24 = useStyle()
	local v25 = if not FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then nil else useTokens()
	local v26 = Constants.getDefaultStyleProps(v24)
	local v27 = Cryo.Dictionary.join(v26, v23.styleProps or {})
	local borderRadius = v27.borderRadius
	local gutter = v27.gutter
	local contentGap = v27.contentGap
	local titleFont = v27.titleFont
	local titleTextColor = v27.titleTextColor
	local v33, v34 = ReactOtter.useAnimatedBinding(0)
	local v35, v36 = React.useState(Vector2.zero)
	local v37 = React.useCallback(function(p1, _: boolean, _, _) -- line: 96
		-- upvalues: gutter (copy), v23 (copy), v36 (copy)
		local v48 = gutter * (v23.numItemsShown - 1)
		local v49 = (p1.AbsoluteSize.X - v48) / v23.numItemsShown

		v36(Vector2.new(v49, v49 / v23.itemAspectRatio))
	end, {
		gutter,
		v23.itemAspectRatio,
		v23.numItemsShown
	})
	local v38 = React.useCallback(function(p4, _: boolean, p5, p6) -- line: 110
		-- upvalues: v34 (copy), ReactOtter (copy), v23 (copy)
		if not p4 then
			return nil
		end

		local v54 = p6 ~= nil and p6:IsDescendantOf(p4)
		local v55 = p5 ~= nil and p5:IsDescendantOf(p4)
		local v56 = v54 and not v55
		local v57 = not v54 and v55

		if v56 then
			v34(ReactOtter.spring(v23.expandableAreaHeightOffset, v23.animationConfig))
			v23.mediaGalleryGainFocused(true)

			return nil
		end

		if v57 then
			if p6 == nil or not (p6.AbsolutePosition.Y > p5.AbsolutePosition.Y) then
				v34(ReactOtter.spring(0, v23.animationConfig))
			end

			v23.exitFullscreen()
			v23.mediaGalleryGainFocused(false)

			return nil
		end

		return nil
	end, {
		v23.expandableAreaHeightOffset,
		v23.animationConfig,
		v23.exitFullscreen,
		v23.mediaGalleryGainFocused
	})
	local v39 = useCursor(borderRadius)
	local v40 = useSelectionCursor(CursorKind.Invisible)
	local v41 = if not v23.showCursor then v40 else v39
	local v42 = React.useMemo(function() -- line: 161
		-- upvalues: v23 (copy), React (copy), v35 (copy), v41 (copy), borderRadius (copy), FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon (copy), View (copy), Icon (copy), IconSize (copy), v25 (copy)
		local t3 = {}

		for v59, v60 in v23.items do
			t3["Item" .. v59] = React.createElement("ImageButton", {
				LayoutOrder = v59,
				Size = UDim2.fromOffset(v35.X, v35.Y),
				Image = v60.imageId,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				SelectionImageObject = v41,
				[React.Event.Activated] = function() -- line: 172
					-- upvalues: v23 (copy), v59 (copy)
					v23.onActivated(v59)
				end,
				[React.Event.SelectionGained] = function() -- line: 175
					-- upvalues: v23 (copy), v59 (copy)
					v23.onSelectionGained(v59)
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = borderRadius
				}),
				PlayIcon = if not FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon or not v60.videoId then nil else React.createElement(View, {
					tag = "auto-xy padding-medium radius-circle bg-over-media-100",
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					selection = {
						Selectable = false
					}
				}, {
					Icon = React.createElement(Icon, {
						name = "play-large",
						size = IconSize.Medium,
						style = v25.Color.Content.Emphasis
					})
				})
			})
		end

		return t3
	end, {
		v35,
		v23.items,
		v23.onActivated,
		v23.onSelectionGained,
		v41,
		borderRadius,
		if not FFlagLuaAppEdpConsoleMediaGalleryVideoPlayIcon then nil else v25
	})
	local v43 = if not titleFont.RelativeSize then titleFont.FontSize else titleFont.RelativeSize * v24.Font.BaseSize

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = v23.groupTransparency,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = if not FFlagLuaAppEdpConsoleMediaGalleryVideo then nil else v23.rootRef
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, contentGap)
		}),
		ExpandableArea = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = v33:map(function(p7) -- line: 229
				return UDim2.new(1, 0, 0, p7)
			end)
		}),
		Title = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			text = v23.titleText,
			fontStyle = titleFont,
			colorStyle = titleTextColor,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0, v43)
		}),
		MediaGallery = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, v35.Y),
			BackgroundTransparency = 1,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false,
			LayoutOrder = 3,
			[React.Change.AbsoluteSize] = v37,
			[React.Event.SelectionChanged] = v38
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, gutter)
			}),
			Items = React.createElement(React.Fragment, {}, v42)
		})
	})
end

return MediaGalleryExpandableView
