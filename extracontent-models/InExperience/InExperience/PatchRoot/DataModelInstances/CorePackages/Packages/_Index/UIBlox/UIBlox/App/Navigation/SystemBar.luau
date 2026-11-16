local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)

local StatusIndicator = Foundation.StatusIndicator
local withStyle = require(parent.Core.Style.withStyle)
local ControlState = require(parent.Core.Control.Enum.ControlState)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local validateImageSetData = require(parent.Core.ImageSet.Validator.validateImageSetData)
local BadgeVariant = require(parent.App.Indicator.Enum.BadgeVariant)
local BadgeStates = require(parent.App.Indicator.Enum.BadgeStates)
local IconSize = require(parent.App.ImageSet.Enum.IconSize)
local getIconSize = require(parent.App.ImageSet.getIconSize)

local InteractableList = require(parent.Core.Control.InteractableList)
local withAnimation = require(parent.Core.Animation.withAnimation)

local migrateBadgeVariant = require(parent.Utility.migrateBadgeVariant)

local Placement = require(script.Parent.Enum.Placement)

local v = { frequency = 3 }

local iconSize = getIconSize(IconSize.Medium)

local v2 = iconSize + 8

local v3 = (v2 - iconSize) / 2
local v4 = (v2 - iconSize) / 2
local v5 = v3 + 4
local v6 = v4 - 4

local v7 = 12 + (64 - v2) / 2
local v8 = 4 + (64 - v2)

local extended = Roact.PureComponent:extend("SystemBar")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	placement = Placement.Auto,
	layoutPaddingOffset = UDim.new(0, 0),
	firstItemPaddingOffset = UDim.new(0, 0),
	lastItemPaddingOffset = UDim.new(0, 0),
	clipsDescendants = true,
	experimentalTabSizePortraitY = 48
}

function extended:isPortrait()
	if self.props.placement == Placement.Left then
		return false
	end

	return self.props.placement == Placement.Bottom or self.state.portrait
end

function extended:renderItem(props, p, selected, layoutOrder)
	assert(
		props.iconOn ~= nil and props.iconOff ~= nil or props.iconImageComponent ~= nil or props.iconComponent ~= nil,
		"items must define either iconOn and iconOff or iconImageComponent or iconComponent"
	)

	local pressed = p == ControlState.Pressed
	local hovered = pressed or p == ControlState.Hover

	if props.iconComponent then
		local placement

		if self:isPortrait() then
			placement = Placement.Bottom
		else
			placement = Placement.Left
		end

		return Roact.createElement(props.iconComponent, {
			placement = placement,
			hovered = hovered,
			selected = selected,
			pressed = pressed,
			badgeValue = props.badgeValue
		}), { LayoutOrder = layoutOrder }
	else
		local v9

		if props.badgeValue then
			v9 = props.badgeValue == BadgeStates.isEmpty
				or (t.string(props.badgeValue) and true or props.badgeValue > 0)
		else
			v9 = false
		end

		local positionX = v3
		local positionY = v4

		if hovered then
			if self:isPortrait() then
				positionY = v6
			else
				positionX = v5
			end
		end

		return withAnimation({ positionX = positionX, positionY = positionY }, function(p2)
			return withStyle(function(p3)
				local theme = p3.Theme
				local createElement = Roact.createElement
				local iconImageComponent = props.iconImageComponent or ImageSetComponent.Label
				local v10 = {
					Position = UDim2.fromOffset(math.floor(p2.positionX + 0.5), (math.floor(p2.positionY + 0.5))),
					Size = UDim2.fromOffset(iconSize, iconSize),
					BackgroundTransparency = self.props.buttonStroke and 0.99 or 1,
					Image = selected and props.iconOn or props.iconOff,
					ImageColor3 = theme.IconDefault.Color,
					ImageTransparency = pressed and 0.5 or 0
				}

				local badge = v9

				if badge then
					local createElement2 = Roact.createElement
					local position

					if props.badgeValue == BadgeStates.isEmpty then
						position = UDim2.fromOffset(22, 2)
					else
						position = UDim2.fromOffset(18, -2)
					end

					badge = createElement2(StatusIndicator, {
						position = position,
						value = tonumber(props.badgeValue),
						variant = migrateBadgeVariant(BadgeVariant.Default),
						max = tonumber(props.badgeValue) and 99 or nil
					})
				end

				return createElement(iconImageComponent, v10, {
					Badge = badge,
					UICorner = self.props.roundCorners and Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0.15, 0)
					}) or nil,
					UIStroke = self.props.buttonStroke and Roact.createElement("UIStroke", {
						Color = Color3.new(0.4, 0.4, 0.4),
						Transparency = 0,
						Thickness = 1
					}) or nil
				})
			end)
		end, v), { LayoutOrder = layoutOrder }
	end
end

function extended:renderPortrait(p, p2)
	return withAnimation({
		offset = self.props.hidden and 0 or -self.props.experimentalTabSizePortraitY
	}, function(p3)
		return Roact.createElement("Frame", Cryo.Dictionary.join(p, {
			Position = UDim2.new(0, 0, 1, (math.floor(p3.offset + 0.5))),
			Size = UDim2.new(1, 0, 0, self.props.experimentalTabSizePortraitY),
			ZIndex = 99
		}), {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			InnerFrame = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				Cryo.Dictionary.join({
					Constraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(600, self.props.experimentalTabSizePortraitY)
					}),
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = self.props.layoutPaddingOffset + UDim.new(1 / #self.props.itemList, -v2),
						SortOrder = self.props.sortOrder
					}, {})
				}, p2)
			)
		})
	end, v)
end

function extended:renderLandscape(p, p2, p3)
	return withAnimation({
		offset = self.props.hidden and -64 or 0
	}, function(p4)
		local createElement = Roact.createElement

		local joined = Cryo.Dictionary.join(p, {
			Position = UDim2.new(0, math.floor(p4.offset + 0.5), 0, 0),
			Size = UDim2.new(0, 64, 1, 0),
			ZIndex = 99,
			BackgroundTransparency = p3 and 1 or nil
		})

		local join = Cryo.Dictionary.join
		local createElement2 = Roact.createElement
		local paddingTop

		if not p3 then
			paddingTop = self.props.firstItemPaddingOffset + UDim.new(0, v7)
		end

		local paddingBottom

		if p3 then
			paddingBottom = self.props.lastItemPaddingOffset + UDim.new(0, v8)
		end

		local children = {
			Padding = createElement2("UIPadding", {
				PaddingTop = paddingTop,
				PaddingBottom = paddingBottom
			}),
			Layout = 0
		}

		local createElement3 = Roact.createElement
		local v9 = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = 0,
			Padding = 0,
			SortOrder = 0
		}
		local verticalAlignment

		if p3 then
			verticalAlignment = Enum.VerticalAlignment.Bottom
		end

		v9.VerticalAlignment = verticalAlignment
		v9.Padding = self.props.layoutPaddingOffset + UDim.new(0, v8)
		v9.SortOrder = self.props.sortOrder
		children.Layout = createElement3("UIListLayout", v9)
		return createElement("Frame", joined, join(children, p2))
	end, v)
end

function extended:renderBackground(p, p2)
	if self:isPortrait() then
		return self:renderPortrait(p, p2)
	end

	local filtered = Cryo.List.filter(p2, function(_, p3): boolean
		return not self.props.itemList[p3].bottomAligned
	end)

	local filtered2 = Cryo.List.filter(p2, function(_, p3)
		return self.props.itemList[p3].bottomAligned
	end)

	local navBar = self:renderLandscape(p, filtered)

	if #filtered2 > 0 then
		return (Roact.createFragment({
			NavBar = navBar,
			BottomAlignedNavBar = self:renderLandscape(p, filtered2, true)
		}))
	end

	return navBar
end

function extended:renderSafeArea()
	local udim, udim2

	if self.props.hidden then
		udim = UDim2.new(0, 0, 0, 0)
		udim2 = UDim2.new(1, 0, 1, 0)
	elseif self:isPortrait() then
		udim = UDim2.new(0, 0, 0, 0)
		udim2 = UDim2.new(1, 0, 1, -self.props.experimentalTabSizePortraitY)
	else
		udim = UDim2.new(0, 64, 0, 0)
		udim2 = UDim2.new(1, -64, 1, 0)
	end

	return Roact.createElement("Frame", {
		Position = udim,
		Size = udim2,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onSafeAreaEvent,
		[Roact.Change.AbsolutePosition] = self.onSafeAreaEvent
	}, self.props[Roact.Children])
end

function extended:renderList(p, callback)
	return withStyle(function(p2)
		local theme = p2.Theme
		local mapped = Cryo.List.map(p, function(_, p3)
			return callback(p3)
		end)

		return Roact.createElement("Frame", {
			Position = self.props.position or UDim2.new(0, 0, 0, 0),
			Size = self.props.size or UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			ClipsDescendants = self.props.clipsDescendants,
			LayoutOrder = self.props.layoutOrder,
			BackgroundTransparency = self.props.bgTransparency or 1,
			[Roact.Change.AbsoluteSize] = function(p3)
				if self.state.portrait and p3.AbsoluteSize.X > p3.AbsoluteSize.Y then
					self:setState({ portrait = false })
				elseif not self.state.portrait and p3.AbsoluteSize.X < p3.AbsoluteSize.Y then
					self:setState({ portrait = true })
				end
			end
		}, {
			NavBar = self:renderBackground({
				BackgroundColor3 = theme.NavigationBar.Color,
				BackgroundTransparency = self.props.roundCorners and 1 or theme.NavigationBar.Transparency,
				BorderSizePixel = 0
			}, mapped),
			SafeArea = self:renderSafeArea()
		}, {
			UICorner = self.props.roundCorners and Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.15, 0) or nil
			}) or nil
		})
	end)
end

function extended:init()
	self:setState({ portrait = true })

	function self.onSelectionChanged(list)
		if #list > 0 then
			local item = self.props.itemList[list[1]]

			if item and item.onActivated then
				item.onActivated()
			end
		end
	end
	function self.onSafeAreaEvent(data)
		if self.props.onSafeAreaChanged then
			self.props.onSafeAreaChanged({
				Position = data.Position,
				AbsolutePosition = data.AbsolutePosition,
				Size = data.Size,
				AbsoluteSize = data.AbsoluteSize
			})
		end
	end
end

function extended:render()
	local itemList = self.props.itemList
	local selection = self.props.selection

	local selection2 = selection and (itemList[selection] ~= nil and { selection } or nil)

	return Roact.createElement(InteractableList, {
		itemList = itemList,
		selection = selection2,
		itemSize = UDim2.fromOffset(v2, v2),
		renderList = function(...)
			return self:renderList(...)
		end,
		renderItem = function(...)
			return self:renderItem(...)
		end,
		sortOrder = self.props.sortOrder,
		onSelectionChanged = self.onSelectionChanged
	})
end

return extended
