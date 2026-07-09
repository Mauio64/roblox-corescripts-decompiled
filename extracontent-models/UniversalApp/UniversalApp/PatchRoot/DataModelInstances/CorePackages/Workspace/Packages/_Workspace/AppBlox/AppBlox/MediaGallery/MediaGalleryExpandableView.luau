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
	onActivated = function() -- line: 29
	end,
	onSelectionGained = function() -- line: 30
	end,
	exitFullscreen = function() -- line: 31
	end
}

local function MediaGalleryExpandableView(t2: {[any]: any}) -- line: 67
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), Constants (copy), ReactOtter (copy), React (copy), useCursor (copy), useSelectionCursor (copy), CursorKind (copy), StyledTextLabel (copy)
	local v15 = Cryo.Dictionary.join(t1, t2)
	local v16 = useStyle()
	local v17 = Constants.getDefaultStyleProps(v16)
	local v18 = Cryo.Dictionary.join(v17, v15.styleProps or {})
	local borderRadius = v18.borderRadius
	local gutter = v18.gutter
	local contentGap = v18.contentGap
	local titleFont = v18.titleFont
	local titleTextColor = v18.titleTextColor
	local v24, v25 = ReactOtter.useAnimatedBinding(0)
	local v26, v27 = React.useState(Vector2.zero)
	local v28 = React.useCallback(function(p1, _: boolean, _, _) -- line: 83
		-- upvalues: gutter (copy), v15 (copy), v27 (copy)
		local v39 = gutter * (v15.numItemsShown - 1)
		local v40 = (p1.AbsoluteSize.X - v39) / v15.numItemsShown

		v27(Vector2.new(v40, v40 / v15.itemAspectRatio))
	end, {
		gutter,
		v15.itemAspectRatio,
		v15.numItemsShown
	})
	local v29 = React.useCallback(function(p4, _: boolean, p5, p6) -- line: 97
		-- upvalues: v25 (copy), ReactOtter (copy), v15 (copy)
		if not p4 then
			return nil
		end

		local v45 = p6 ~= nil and p6:IsDescendantOf(p4)
		local v46 = p5 ~= nil and p5:IsDescendantOf(p4)
		local v47 = v45 and not v46
		local v48 = not v45 and v46

		if v47 then
			v25(ReactOtter.spring(v15.expandableAreaHeightOffset, v15.animationConfig))
			v15.mediaGalleryGainFocused(true)

			return nil
		end

		if v48 then
			if p6 == nil or not (p6.AbsolutePosition.Y > p5.AbsolutePosition.Y) then
				v25(ReactOtter.spring(0, v15.animationConfig))
			end

			v15.exitFullscreen()
			v15.mediaGalleryGainFocused(false)

			return nil
		end

		return nil
	end, {
		v15.expandableAreaHeightOffset,
		v15.animationConfig,
		v15.exitFullscreen,
		v15.mediaGalleryGainFocused
	})
	local v30 = useCursor(borderRadius)
	local v31 = useSelectionCursor(CursorKind.Invisible)
	local v32 = if not v15.showCursor then v31 else v30
	local v33 = React.useMemo(function() -- line: 148
		-- upvalues: v15 (copy), React (copy), v26 (copy), v32 (copy), borderRadius (copy)
		local t3 = {}

		for v50, v51 in v15.items do
			t3["Item" .. v50] = React.createElement("ImageButton", {
				LayoutOrder = v50,
				Size = UDim2.fromOffset(v26.X, v26.Y),
				Image = v51.imageId,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				SelectionImageObject = v32,
				[React.Event.Activated] = function() -- line: 159
					-- upvalues: v15 (copy), v50 (copy)
					v15.onActivated(v50)
				end,
				[React.Event.SelectionGained] = function() -- line: 162
					-- upvalues: v15 (copy), v50 (copy)
					v15.onSelectionGained(v50)
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = borderRadius
				})
			})
		end

		return t3
	end, {
		v26,
		v15.items,
		v15.onActivated,
		v15.onSelectionGained,
		v32,
		borderRadius
	})
	local v34 = if not titleFont.RelativeSize then titleFont.FontSize else titleFont.RelativeSize * v16.Font.BaseSize

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		GroupTransparency = v15.groupTransparency,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, contentGap)
		}),
		ExpandableArea = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = v24:map(function(p7) -- line: 199
				return UDim2.new(1, 0, 0, p7)
			end)
		}),
		Title = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			text = v15.titleText,
			fontStyle = titleFont,
			colorStyle = titleTextColor,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0, v34)
		}),
		MediaGallery = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, v26.Y),
			BackgroundTransparency = 1,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false,
			LayoutOrder = 3,
			[React.Change.AbsoluteSize] = v28,
			[React.Event.SelectionChanged] = v29
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, gutter)
			}),
			Items = React.createElement(React.Fragment, {}, v33)
		})
	})
end

return MediaGalleryExpandableView
