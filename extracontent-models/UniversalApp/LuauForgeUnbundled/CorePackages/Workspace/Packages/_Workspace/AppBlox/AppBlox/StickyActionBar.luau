local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style").GetTextSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local actionBar = UIBlox.App.Button.ActionBar

local fFlagUIBloxEnableActionBarButtonOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local v5 = game:DefineFastFlag("LuaAppFixUnifiedPlayButtonStickyActionBar", false)
	and fFlagUIBloxEnableActionBarButtonOverride

local iconSize2 = getIconSize(iconSize.Large)

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

	function self.onContainerSizeChange(p2)
		self:setState(function(p3, p4)
			return { containerWidth = p2.AbsoluteSize.X }
		end)
	end

	local function fn(p2, p3, p4, p5)
		if p5 or not p4 then
			return {
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				left = 24,
				right = 24
			}
		end

		local v6 = (p2 - p3) / 2

		local v7 = p2 < 1280 and 24 or 80
		local offset = UDim2.fromOffset(self.props.actionBarWidth, 48).X.Offset
		return {
			left = math.max(offset + v7, v6) - offset,
			right = 24
		}
	end

	function self.getLayoutConfig(p2, p3, p4, p5, p6, p7, p8)
		local v6 = self.props.infoProps and self.props.infoProps.enableInfoAtStart and true or false
		local baseSize = p8.Font.BaseSize
		local v7 = p7.RelativeSize * baseSize
		local vector2 = Vector2.new(10000, 10000)
		local v8 = getTextSize(p6, v7, p7.Font, vector2).X + p5 + (p5 > 0 and 12 or 0)
		local v9 = {
			layoutOrder = v6 and { infoSection = 1, actionBarSection = 2 } or {
				infoSection = 2,
				actionBarSection = 1
			},
			infoHorizontalAlignment = Enum.HorizontalAlignment.Left,
			infoSectionWidth = 0,
			infoSectionPadding = 0,
			actionBarSectionSize = 0,
			actionBarSectionMarginOverride = 0
		}
		local v10

		if p4 and p4.infoSectionWidth then
			v10 = p4.infoSectionWidth
		else
			local offset = UDim2.fromOffset(self.props.actionBarWidth, 48).X.Offset

			v10 = p3 and p2 - 80 - offset or p2 - 80
		end

		v9.infoSectionWidth = v10
		v9.infoSectionPadding = fn(p2, v8, p3, v6)
		v9.actionBarSectionSize = UDim2.fromOffset(self.props.actionBarWidth, 48)
		v9.actionBarSectionMarginOverride = { left = 0, right = 0, top = 0, bottom = 0 }
		return v9
	end
end

function extended:render()
	local v6 = self.props.actionBarProps ~= nil
	local v7 = self.props.infoProps ~= nil
	local width = self.props.width or self.state.containerWidth
	assert(v6 or v7, "Either actionbar or info should be present!")
	return withStyle(function(p2)
		local v8 = v7 and self.props.infoProps.icon and iconSize2 or 0
		local title = v7 and self.props.infoProps.title or ""
		local header2 = p2.Font.Header2
		local layoutConfig = self.getLayoutConfig(
			width or 0,
			v6,
			self.props.infoProps,
			v8,
			title,
			header2,
			p2
		)

		local v10 = {
			layoutOrder = self.props.layoutOrder,
			size = self.props.width and UDim2.new(0, self.props.width, 1, 0) or UDim2.fromScale(1, 1),
			onContainerSizeChange = self.onContainerSizeChange,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			padding = { left = 56, right = 24 }
		}
		local v12

		if v6 then
			local v14 = {
				layoutOrder = layoutConfig.layoutOrder.actionBarSection,
				size = layoutConfig.actionBarSectionSize,
				horizontalAlignment = Enum.HorizontalAlignment.Left
			}

			local createElement = Roact.createElement
			local v17 = {
				button = self.props.actionBarProps.button,
				buttonOverride = 0,
				icons = 0,
				marginOverride = 0,
				enableButtonAtStart = true
			}

			local v18 = if v5 then self.props.actionBarProps.buttonOverride else nil
			v17.buttonOverride = v18

			v17.icons = self.props.actionBarProps.icons
			v17.marginOverride = layoutConfig.actionBarSectionMarginOverride
			v12 = self:renderHorizontalLayout(v14, {
				ActionBar = createElement(actionBar, v17)
			}) or nil
		end

		local v13 = v7

		if v13 then
			if width == nil then
				v13 = false
			else
				v13 = self:renderHorizontalLayout({
					layoutOrder = layoutConfig.layoutOrder.infoSection,
					width = layoutConfig.infoSectionWidth,
					horizontalAlignment = layoutConfig.infoHorizontalAlignment,
					padding = layoutConfig.infoSectionPadding,
					internalSpacing = 12
				}, {
					Icon = self.props.infoProps.icon and Roact.createElement(imageSetLabel, {
						Size = UDim2.new(0, v8, 0, v8),
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
					Title = Roact.createElement(styledTextLabel, {
						layoutOrder = 2,
						size = UDim2.new(0, 0, 0, 48),
						automaticSize = Enum.AutomaticSize.X,
						text = title,
						fluidSizing = false,
						textWrapped = true,
						textXAlignment = Enum.TextXAlignment.Left,
						colorStyle = p2.Theme.TextEmphasis,
						fontStyle = header2,
						textTruncate = Enum.TextTruncate.AtEnd
					})
				})
			end
		end

		return self:renderHorizontalLayout(v10, {
			ActionBarSection = v12,
			InfoSection = v13
		})
	end)
end

function extended:renderHorizontalLayout(props, p3)
	local createElement = Roact.createElement
	local onContainerSizeChangesByAbsoluteSize = {
		Size = props.size and props.size or UDim2.new(0, props.width, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[Roact.Change.AbsoluteSize] = props.onContainerSizeChange
	}
	local v7 = {
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

	local v8 = if props.padding then Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, props.padding.left or 0),
		PaddingRight = UDim.new(0, props.padding.right or 0),
		PaddingTop = UDim.new(0, props.padding.top or 0),
		PaddingBottom = UDim.new(0, props.padding.bottom or 0)
	}) else nil
	v7.Padding = v8

	v7.Elements = Roact.createFragment(p3)
	return createElement("Frame", onContainerSizeChangesByAbsoluteSize, v7)
end

return extended
