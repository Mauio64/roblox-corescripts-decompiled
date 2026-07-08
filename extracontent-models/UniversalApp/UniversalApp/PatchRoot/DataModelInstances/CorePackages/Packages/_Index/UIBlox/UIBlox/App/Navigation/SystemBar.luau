local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Cryo = require(ParentParentParent.Cryo)
local StatusIndicator = require(ParentParentParent.Foundation).StatusIndicator
local withStyle = require(ParentParent.Core.Style.withStyle)
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local validateImageSetData = require(ParentParent.Core.ImageSet.Validator.validateImageSetData)
local BadgeVariant = require(ParentParent.App.Indicator.Enum.BadgeVariant)
local BadgeStates = require(ParentParent.App.Indicator.Enum.BadgeStates)
local IconSize = require(ParentParent.App.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.App.ImageSet.getIconSize)
local InteractableList = require(ParentParent.Core.Control.InteractableList)
local withAnimation = require(ParentParent.Core.Animation.withAnimation)
local migrateBadgeVariant = require(ParentParent.Utility.migrateBadgeVariant)
local Placement = require(script.Parent.Enum.Placement)
local t1 = {
	frequency = 3
}
local v20 = getIconSize(IconSize.Medium)
local v21 = v20 + 8
local v22 = (v21 - v20) / 2
local v23 = (v21 - v20) / 2
local v24 = v22 + 4
local v25 = v23 - 4
local v26 = 12 + (64 - v21) / 2
local v27 = 4 + (64 - v21)
local v28 = Roact.PureComponent:extend("SystemBar")

v28.validateProps = t.strictInterface({
	itemList = t.array(t.strictInterface({
		iconOn = t.optional(validateImageSetData),
		iconOff = t.optional(validateImageSetData),
		iconImageComponent = t.optional(t.union(t.table, t.callback)),
		iconComponent = t.optional(t.union(t.table, t.callback)),
		onActivated = t.callback,
		badgeValue = t.optional(t.union(t.integer, t.string, BadgeStates.isEnumValue)),
		itemSize = t.optional(t.UDim2),
		bottomAligned = t.optional(t.boolean)
	})),
	selection = t.optional(t.integer),
	placement = t.optional(Placement.isEnumValue),
	hidden = t.optional(t.boolean),
	onSafeAreaChanged = t.optional(t.callback),
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	layoutPaddingOffset = t.optional(t.UDim),
	firstItemPaddingOffset = t.optional(t.UDim),
	lastItemPaddingOffset = t.optional(t.UDim),
	[Roact.Children] = t.optional(t.any),
	roundCorners = t.optional(t.boolean),
	buttonStroke = t.optional(t.boolean),
	bgTransparency = t.optional(t.integer),
	sortOrder = t.optional(t.enum(Enum.SortOrder)),
	clipsDescendants = t.optional(t.boolean),
	experimentalTabSizePortraitY = t.optional(t.number)
})
v28.defaultProps = {
	clipsDescendants = true,
	experimentalTabSizePortraitY = 48,
	placement = Placement.Auto,
	layoutPaddingOffset = UDim.new(0, 0),
	firstItemPaddingOffset = UDim.new(0, 0),
	lastItemPaddingOffset = UDim.new(0, 0)
}

function v28.isPortrait(p1) -- line: 145
	-- upvalues: Placement (copy)
	if p1.props.placement == Placement.Left then
		return false
	end

	if p1.props.placement == Placement.Bottom then
		return true
	end

	return p1.state.portrait
end
function v28.renderItem(p2, p3, p4, p5, p6) -- line: 155
	-- upvalues: ControlState (copy), Placement (copy), Roact (copy), BadgeStates (copy), t (copy), v22 (copy), v23 (copy), v25 (copy), v24 (copy), withAnimation (copy), withStyle (copy), ImageSetComponent (copy), v20 (copy), v20 (copy), StatusIndicator (copy), migrateBadgeVariant (copy), BadgeVariant (copy), t1 (copy)
	assert(p3.iconOn ~= nil and p3.iconOff ~= nil or (p3.iconImageComponent ~= nil or p3.iconComponent ~= nil), "items must define either iconOn and iconOff or iconImageComponent or iconComponent")

	local v35 = p4 == ControlState.Pressed
	local v36 = v35 or p4 == ControlState.Hover

	if p3.iconComponent then
		local v37 = if not p2:isPortrait() then Placement.Left else Placement.Bottom

		return Roact.createElement(p3.iconComponent, {
			placement = v37,
			hovered = v36,
			selected = p5,
			pressed = v35,
			badgeValue = p3.badgeValue
		}), {
			LayoutOrder = p6
		}
	end

	local u38 = not not p3.badgeValue and (p3.badgeValue == BadgeStates.isEmpty or (not not t.string(p3.badgeValue) or p3.badgeValue > 0))
	local v39 = v22
	local v40 = v23

	if v36 then
		if p2:isPortrait() then
			v40 = v25
		else
			v39 = v24
		end
	end

	return withAnimation({
		positionX = v39,
		positionY = v40
	}, function(p7) -- line: 208
		-- upvalues: withStyle (copy), Roact (copy), p3 (copy), ImageSetComponent (copy), v20 (copy), v20 (copy), p2 (copy), p5 (copy), v35 (copy), u38 (ref), StatusIndicator (copy), BadgeStates (copy), migrateBadgeVariant (copy), BadgeVariant (copy)
		return withStyle(function(p8) -- line: 209
			-- upvalues: Roact (copy), p3 (copy), ImageSetComponent (copy), p7 (copy), v20 (copy), v20 (copy), p2 (copy), p5 (copy), v35 (copy), u38 (ref), StatusIndicator (copy), BadgeStates (copy), migrateBadgeVariant (copy), BadgeVariant (copy)
			local Theme = p8.Theme

			return Roact.createElement(p3.iconImageComponent or ImageSetComponent.Label, {
				Position = UDim2.fromOffset(math.floor(p7.positionX + 0.5), (math.floor(p7.positionY + 0.5))),
				Size = UDim2.fromOffset(v20, v20),
				BackgroundTransparency = not p2.props.buttonStroke and 1 or 0.99,
				Image = p5 and p3.iconOn or p3.iconOff,
				ImageColor3 = Theme.IconDefault.Color,
				ImageTransparency = not v35 and 0 or 0.5
			}, {
				Badge = u38 and Roact.createElement(StatusIndicator, {
					position = if p3.badgeValue ~= BadgeStates.isEmpty then UDim2.fromOffset(18, -2) else UDim2.fromOffset(22, 2),
					value = tonumber(p3.badgeValue),
					variant = migrateBadgeVariant(BadgeVariant.Default),
					max = if not tonumber(p3.badgeValue) then nil else 99
				}),
				UICorner = p2.props.roundCorners and Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.15, 0)
				}) or nil,
				UIStroke = p2.props.buttonStroke and Roact.createElement("UIStroke", {
					Transparency = 0,
					Thickness = 1,
					Color = Color3.new(0.4, 0.4, 0.4)
				}) or nil
			})
		end)
	end, t1), {
		LayoutOrder = p6
	}
end
function v28.renderPortrait(p9, p10, p11) -- line: 244
	-- upvalues: withAnimation (copy), Roact (copy), Cryo (copy), v21 (copy), t1 (copy)
	return withAnimation({
		offset = if not p9.props.hidden then -p9.props.experimentalTabSizePortraitY else 0
	}, function(p12) -- line: 247
		-- upvalues: Roact (copy), Cryo (copy), p10 (copy), p9 (copy), v21 (copy), p11 (copy)
		return Roact.createElement("Frame", Cryo.Dictionary.join(p10, {
			ZIndex = 99,
			Position = UDim2.new(0, 0, 1, (math.floor(p12.offset + 0.5))),
			Size = UDim2.new(1, 0, 0, p9.props.experimentalTabSizePortraitY)
		}), {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			InnerFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, Cryo.Dictionary.join({
				Constraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(600, p9.props.experimentalTabSizePortraitY)
				}),
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = p9.props.layoutPaddingOffset + UDim.new(1 / #p9.props.itemList, -v21),
					SortOrder = p9.props.sortOrder
				}, {})
			}, p11))
		})
	end, t1)
end
function v28.renderLandscape(p13, p14, p15, p16) -- line: 283
	-- upvalues: withAnimation (copy), Roact (copy), Cryo (copy), v26 (copy), v27 (copy), t1 (copy)
	return withAnimation({
		offset = not p13.props.hidden and 0 or -64
	}, function(p17) -- line: 286
		-- upvalues: Roact (copy), Cryo (copy), p14 (copy), p16 (copy), p13 (copy), v26 (copy), v27 (copy), p15 (copy)
		return Roact.createElement("Frame", Cryo.Dictionary.join(p14, {
			ZIndex = 99,
			Position = UDim2.new(0, math.floor(p17.offset + 0.5), 0, 0),
			Size = UDim2.new(0, 64, 1, 0),
			BackgroundTransparency = if not p16 then nil else 1
		}), Cryo.Dictionary.join({
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = if p16 then nil else p13.props.firstItemPaddingOffset + UDim.new(0, v26),
				PaddingBottom = if not p16 then nil else p13.props.lastItemPaddingOffset + UDim.new(0, v27)
			}),
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = if not p16 then nil else Enum.VerticalAlignment.Bottom,
				Padding = p13.props.layoutPaddingOffset + UDim.new(0, v27),
				SortOrder = p13.props.sortOrder
			})
		}, p15))
	end, t1)
end
function v28.renderBackground(p18, p19, p20) -- line: 316
	-- upvalues: Cryo (copy), Roact (copy)
	if p18:isPortrait() then
		return p18:renderPortrait(p19, p20)
	end

	local v51 = Cryo.List.filter(p20, function(_, p22) -- line: 320
		-- upvalues: p18 (copy)
		return not p18.props.itemList[p22].bottomAligned
	end)
	local v52 = Cryo.List.filter(p20, function(_, p24) -- line: 323
		-- upvalues: p18 (copy)
		return p18.props.itemList[p24].bottomAligned
	end)
	local v53 = p18:renderLandscape(p19, v51)

	if #v52 > 0 then
		v53 = Roact.createFragment({
			NavBar = v53,
			BottomAlignedNavBar = p18:renderLandscape(p19, v52, true)
		})
	end

	return v53
end
function v28.renderSafeArea(p25) -- line: 337
	-- upvalues: Roact (copy)
	local uDim2, uDim2_2

	if p25.props.hidden then
		uDim2 = UDim2.new(0, 0, 0, 0)
		uDim2_2 = UDim2.new(1, 0, 1, 0)
	elseif p25:isPortrait() then
		uDim2 = UDim2.new(0, 0, 0, 0)
		uDim2_2 = UDim2.new(1, 0, 1, -p25.props.experimentalTabSizePortraitY)
	else
		uDim2 = UDim2.new(0, 64, 0, 0)
		uDim2_2 = UDim2.new(1, -64, 1, 0)
	end

	return Roact.createElement("Frame", {
		Position = uDim2,
		Size = uDim2_2,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = p25.onSafeAreaEvent,
		[Roact.Change.AbsolutePosition] = p25.onSafeAreaEvent
	}, p25.props[Roact.Children])
end
function v28.renderList(p26, p27, p28) -- line: 358
	-- upvalues: withStyle (copy), Cryo (copy), Roact (copy)
	return withStyle(function(p29) -- line: 359
		-- upvalues: Cryo (copy), p27 (copy), p28 (copy), Roact (copy), p26 (copy)
		local Theme = p29.Theme
		local v73 = Cryo.List.map(p27, function(_, p31) -- line: 361
			-- upvalues: p28 (copy)
			return p28(p31)
		end)

		return Roact.createElement("Frame", {
			Position = p26.props.position or UDim2.new(0, 0, 0, 0),
			Size = p26.props.size or UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			ClipsDescendants = p26.props.clipsDescendants,
			LayoutOrder = p26.props.layoutOrder,
			BackgroundTransparency = p26.props.bgTransparency or 1,
			[Roact.Change.AbsoluteSize] = function(p32) -- line: 371
				-- upvalues: p26 (copy)
				if p26.state.portrait and p32.AbsoluteSize.X > p32.AbsoluteSize.Y then
					p26:setState({
						portrait = false
					})

					return
				end

				if not p26.state.portrait and p32.AbsoluteSize.X < p32.AbsoluteSize.Y then
					p26:setState({
						portrait = true
					})
				end
			end
		}, {
			NavBar = p26:renderBackground({
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.NavigationBar.Color,
				BackgroundTransparency = if not p26.props.roundCorners then Theme.NavigationBar.Transparency else 1
			}, v73),
			SafeArea = p26:renderSafeArea()
		}, {
			UICorner = p26.props.roundCorners and Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.15, 0) or nil
			}) or nil
		})
	end)
end
function v28.init(p33) -- line: 397
	p33:setState({
		portrait = true
	})

	function p33.onSelectionChanged(p34) -- line: 401
		-- upvalues: p33 (copy)
		if #p34 > 0 then
			local v75 = p33.props.itemList[p34[1]]

			if v75 and v75.onActivated then
				v75.onActivated()
			end
		end
	end
	function p33.onSafeAreaEvent(p35) -- line: 409
		-- upvalues: p33 (copy)
		if p33.props.onSafeAreaChanged then
			p33.props.onSafeAreaChanged({
				Position = p35.Position,
				AbsolutePosition = p35.AbsolutePosition,
				Size = p35.Size,
				AbsoluteSize = p35.AbsoluteSize
			})
		end
	end
end
function v28.render(p36) -- line: 421
	-- upvalues: Roact (copy), InteractableList (copy), v21 (copy), v21 (copy)
	local itemList = p36.props.itemList
	local selection = p36.props.selection

	if selection then
		selection = if itemList[selection] ~= nil then { selection } else nil
	end

	return Roact.createElement(InteractableList, {
		itemList = itemList,
		selection = selection,
		itemSize = UDim2.fromOffset(v21, v21),
		renderList = function(...) -- line: 437
			-- upvalues: p36 (copy)
			return p36:renderList(...)
		end,
		renderItem = function(...) -- line: 440
			-- upvalues: p36 (copy)
			return p36:renderItem(...)
		end,
		sortOrder = p36.props.sortOrder,
		onSelectionChanged = p36.onSelectionChanged
	})
end

return v28
