local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)

local t = require(parent.t)
local Roact = require(parent.Roact)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local ActionBar = UIBlox.App.Button.ActionBar

local SharedFlags = require(parent.SharedFlags)
local FFlagUIBloxEnableActionBarButtonOverride = SharedFlags.UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local v = game:DefineFastFlag("LuaAppFixUnifiedPlayButtonStickyActionBar", false)
	and FFlagUIBloxEnableActionBarButtonOverride

local iconSize = getIconSize(IconSize.Large)

local extended = Roact.PureComponent:extend("StickyActionBar")

extended.validateProps = t.strictInterface({
	actionBarProps = t.optional(t.table),
	actionBarWidth = t.optional(t.number),
	infoProps = t.optional(t.strictInterface({
		title = t.string,
		icon = t.optional(validateImage),
		enableInfoAtStart = t.optional(t.boolean),
		infoSectionWidth = t.optional(t.integer)
	})),
	width = t.optional(t.integer),
	layoutOrder = t.optional(t.integer)
})

extended.defaultProps = {
	actionBarProps = nil,
	actionBarWidth = 380,
	infoProps = nil,
	layoutOrder = 1,
	width = nil
}

function extended:init()
	self.state = { containerWidth = nil }

	function self.onContainerSizeChange(p)
		self:setState(function(_, _)
			return { containerWidth = p.AbsoluteSize.X }
		end)
	end

	local function fn() -- 3 equivalent calls inferred from this helper
		return UDim2.fromOffset(self.props.actionBarWidth, 48)
	end

	local function fn2(p: number, p2, p3, p4)
		if p4 or not p3 then
			return { horizontalAlignment = Enum.HorizontalAlignment.Left, left = 24, right = 24 }
		end

		local v2 = (p - p2) / 2

		local v3 = p < 1280 and 24 or 80

		local offset = fn().X.Offset -- inferred equivalent call
		return {
			left = math.max(offset + v3, v2) - offset,
			right = 24
		}
	end

	local function fn3(p: number, p2, p3) -- 1 equivalent call inferred from this helper
		if p3 and p3.infoSectionWidth then
			return p3.infoSectionWidth
		end

		local offset = fn().X.Offset -- inferred equivalent call

		return p2 and p - 80 - offset or p - 80
	end

	local function fn4(p, p2, p3) -- 1 equivalent call inferred from this helper
		local baseSize = p3.Font.BaseSize
		local v2 = p2.RelativeSize * baseSize
		local vector2 = Vector2.new(10000, 10000)
		return GetTextSize(p, v2, p2.Font, vector2).X
	end

	function self.getLayoutConfig(p, p2, p3, p4, p5, p6, p7)
		local v2 = self.props.infoProps and self.props.infoProps.enableInfoAtStart and true or false
		local v3 = fn4(p5, p6, p7) + p4 + (p4 > 0 and 12 or 0) -- inferred equivalent call
		return {
			layoutOrder = v2 and { infoSection = 1, actionBarSection = 2 } or {
				infoSection = 2,
				actionBarSection = 1
			},
			infoHorizontalAlignment = Enum.HorizontalAlignment.Left,
			infoSectionWidth = fn3(p, p2, p3), -- inferred equivalent call
			infoSectionPadding = fn2(p, v3, p2, v2),
			actionBarSectionSize = fn(), -- inferred equivalent call
			actionBarSectionMarginOverride = { left = 0, right = 0, top = 0, bottom = 0 }
		}
	end
end

function extended:render()
	local v2 = self.props.actionBarProps ~= nil
	local v3 = self.props.infoProps ~= nil
	local width = self.props.width or self.state.containerWidth
	assert(v2 or v3, "Either actionbar or info should be present!")
	return withStyle(function(p)
		local v4 = v3 and self.props.infoProps.icon and iconSize or 0
		local title = v3 and self.props.infoProps.title or ""
		local header2 = p.Font.Header2
		local layoutConfig = self.getLayoutConfig(width or 0, v2, self.props.infoProps, v4, title, header2, p)

		local v5 = {
			layoutOrder = self.props.layoutOrder,
			size = self.props.width and UDim2.new(0, self.props.width, 1, 0) or UDim2.fromScale(1, 1),
			onContainerSizeChange = self.onContainerSizeChange,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			padding = { left = 56, right = 24 }
		}
		local actionBarSection

		if v2 then
			local v6 = {
				layoutOrder = layoutConfig.layoutOrder.actionBarSection,
				size = layoutConfig.actionBarSectionSize,
				horizontalAlignment = Enum.HorizontalAlignment.Left
			}

			local createElement = Roact.createElement
			local v7 = {
				button = self.props.actionBarProps.button,
				buttonOverride = 0,
				icons = 0,
				marginOverride = 0,
				enableButtonAtStart = true
			}
			local buttonOverride

			if v then
				buttonOverride = self.props.actionBarProps.buttonOverride
			end

			v7.buttonOverride = buttonOverride

			v7.icons = self.props.actionBarProps.icons
			v7.marginOverride = layoutConfig.actionBarSectionMarginOverride
			actionBarSection = self:renderHorizontalLayout(v6, {
				ActionBar = createElement(ActionBar, v7)
			}) or nil
		end

		local infoSection = v3

		if infoSection then
			if width == nil then
				infoSection = false
			else
				infoSection = self:renderHorizontalLayout({
					layoutOrder = layoutConfig.layoutOrder.infoSection,
					width = layoutConfig.infoSectionWidth,
					horizontalAlignment = layoutConfig.infoHorizontalAlignment,
					padding = layoutConfig.infoSectionPadding,
					internalSpacing = 12
				}, {
					Icon = self.props.infoProps.icon and Roact.createElement(ImageSetLabel, {
						Size = UDim2.new(0, v4, 0, v4),
						LayoutOrder = 1,
						Position = UDim2.new(0, 0, 0, 0),
						Image = self.props.infoProps.icon,
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Crop
					}, {
						RoundCorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					}) or nil,
					Title = Roact.createElement(StyledTextLabel, {
						layoutOrder = 2,
						size = UDim2.new(0, 0, 0, 48),
						automaticSize = Enum.AutomaticSize.X,
						text = title,
						fluidSizing = false,
						textWrapped = true,
						textXAlignment = Enum.TextXAlignment.Left,
						colorStyle = p.Theme.TextEmphasis,
						fontStyle = header2,
						textTruncate = Enum.TextTruncate.AtEnd
					})
				})
			end
		end

		return self:renderHorizontalLayout(v5, {
			ActionBarSection = actionBarSection,
			InfoSection = infoSection
		})
	end)
end

function extended:renderHorizontalLayout(props, p)
	local createElement = Roact.createElement
	local onContainerSizeChangesByAbsoluteSize = {
		Size = props.size and props.size or UDim2.new(0, props.width, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[Roact.Change.AbsoluteSize] = props.onContainerSizeChange
	}
	local v2 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = props.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, props.internalSpacing or 0)
		}),
		Padding = 0,
		Elements = 0
	}
	local padding

	if props.padding then
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, props.padding.left or 0),
			PaddingRight = UDim.new(0, props.padding.right or 0),
			PaddingTop = UDim.new(0, props.padding.top or 0),
			PaddingBottom = UDim.new(0, props.padding.bottom or 0)
		})
	end

	v2.Padding = padding

	v2.Elements = Roact.createFragment(p)
	return createElement("Frame", onContainerSizeChangesByAbsoluteSize, v2)
end

return extended
