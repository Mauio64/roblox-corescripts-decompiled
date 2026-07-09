local Parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(Parent.UIBlox)
local t = require(Parent.t)
local Roact = require(Parent.Roact)
local GetTextSize = require(Parent.Style).GetTextSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle
local ActionBar = UIBlox.App.Button.ActionBar
local FFlagUIBloxEnableActionBarButtonOverride = require(Parent.SharedFlags).UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local v14 = game:DefineFastFlag("LuaAppFixUnifiedPlayButtonStickyActionBar", false) and FFlagUIBloxEnableActionBarButtonOverride
local v15 = getIconSize(IconSize.Large)
local v16 = Roact.PureComponent:extend("StickyActionBar")

v16.validateProps = t.strictInterface({
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
v16.defaultProps = {
	actionBarProps = nil,
	actionBarWidth = 380,
	infoProps = nil,
	layoutOrder = 1,
	width = nil
}

function v16.init(p1) -- line: 77
	-- upvalues: GetTextSize (copy)
	p1.state = {
		containerWidth = nil
	}

	function p1.onContainerSizeChange(p2) -- line: 81
		-- upvalues: p1 (copy)
		p1:setState(function(_, _) -- line: 82
			-- upvalues: p2 (copy)
			return {
				containerWidth = p2.AbsoluteSize.X
			}
		end)
	end

	local function v18(n1: number, p5, p6, p7) -- line: 104
		-- upvalues: p1 (copy)
		if p7 or not p6 then
			return {
				left = 24,
				right = 24,
				horizontalAlignment = Enum.HorizontalAlignment.Left
			}
		end

		local v35 = (n1 - p5) / 2
		local v36 = not (n1 < 1280) and 80 or 24
		local XOffset = UDim2.fromOffset(p1.props.actionBarWidth, 48).X.Offset
		local v38 = math.max(XOffset + v36, v35)

		return {
			right = 24,
			left = v38 - XOffset
		}
	end

	function p1.getLayoutConfig(p8, p9, p10, p11, p12, p13, p14) -- line: 135
		-- upvalues: p1 (copy), GetTextSize (copy), v18 (copy)
		local v52 = not not p1.props.infoProps and not not p1.props.infoProps.enableInfoAtStart
		local BaseSize = p14.Font.BaseSize
		local v54 = p13.RelativeSize * BaseSize
		local vector2 = Vector2.new(10000, 10000)
		local v56 = GetTextSize(p12, v54, p13.Font, vector2).X + p11 + (not (p11 > 0) and 0 or 12)
		local t1 = {
			layoutOrder = v52 and {
				infoSection = 1,
				actionBarSection = 2
			} or {
				infoSection = 2,
				actionBarSection = 1
			},
			infoHorizontalAlignment = Enum.HorizontalAlignment.Left
		}
		local infoSectionWidth

		if p10 and p10.infoSectionWidth then
			infoSectionWidth = p10.infoSectionWidth
		else
			local XOffset = UDim2.fromOffset(p1.props.actionBarWidth, 48).X.Offset

			infoSectionWidth = p9 and p8 - 80 - XOffset or p8 - 80
		end

		t1.infoSectionWidth = infoSectionWidth
		t1.infoSectionPadding = v18(p8, v56, p9, v52)
		t1.actionBarSectionSize = UDim2.fromOffset(p1.props.actionBarWidth, 48)
		t1.actionBarSectionMarginOverride = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0
		}

		return t1
	end
end
function v16.render(p15) -- line: 176
	-- upvalues: withStyle (copy), v15 (copy), Roact (copy), ActionBar (copy), v14 (copy), ImageSetLabel (copy), StyledTextLabel (copy)
	local v20 = p15.props.actionBarProps ~= nil
	local v21 = p15.props.infoProps ~= nil
	local v22 = p15.props.width or p15.state.containerWidth

	assert(v20 or v21, "Either actionbar or info should be present!")

	return withStyle(function(p16) -- line: 181
		-- upvalues: v21 (copy), p15 (copy), v15 (copy), v22 (copy), v20 (copy), Roact (copy), ActionBar (copy), v14 (copy), ImageSetLabel (copy), StyledTextLabel (copy)
		local v61 = v21 and (not not p15.props.infoProps.icon and v15) or 0
		local v62 = v21 and p15.props.infoProps.title or ""
		local Header2 = p16.Font.Header2
		local v64 = p15.getLayoutConfig(v22 or 0, v20, p15.props.infoProps, v61, v62, Header2, p16)

		return p15:renderHorizontalLayout({
			layoutOrder = p15.props.layoutOrder,
			size = p15.props.width and UDim2.new(0, p15.props.width, 1, 0) or UDim2.fromScale(1, 1),
			onContainerSizeChange = p15.onContainerSizeChange,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			padding = {
				left = 56,
				right = 24
			}
		}, {
			ActionBarSection = v20 and p15:renderHorizontalLayout({
				layoutOrder = v64.layoutOrder.actionBarSection,
				size = v64.actionBarSectionSize,
				horizontalAlignment = Enum.HorizontalAlignment.Left
			}, {
				ActionBar = Roact.createElement(ActionBar, {
					enableButtonAtStart = true,
					button = p15.props.actionBarProps.button,
					buttonOverride = if not v14 then nil else p15.props.actionBarProps.buttonOverride,
					icons = p15.props.actionBarProps.icons,
					marginOverride = v64.actionBarSectionMarginOverride
				})
			}) or nil,
			InfoSection = v21 and (v22 ~= nil and p15:renderHorizontalLayout({
				internalSpacing = 12,
				layoutOrder = v64.layoutOrder.infoSection,
				width = v64.infoSectionWidth,
				horizontalAlignment = v64.infoHorizontalAlignment,
				padding = v64.infoSectionPadding
			}, {
				Icon = p15.props.infoProps.icon and Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v61, 0, v61),
					Position = UDim2.new(0, 0, 0, 0),
					Image = p15.props.infoProps.icon,
					ScaleType = Enum.ScaleType.Crop
				}, {
					RoundCorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}) or nil,
				Title = Roact.createElement(StyledTextLabel, {
					layoutOrder = 2,
					fluidSizing = false,
					textWrapped = true,
					size = UDim2.new(0, 0, 0, 48),
					automaticSize = Enum.AutomaticSize.X,
					text = v62,
					textXAlignment = Enum.TextXAlignment.Left,
					colorStyle = p16.Theme.TextEmphasis,
					fontStyle = Header2,
					textTruncate = Enum.TextTruncate.AtEnd
				})
			}))
		})
	end)
end
function v16.renderHorizontalLayout(_, p18, p19) -- line: 255
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		Size = p18.size and p18.size or UDim2.new(0, p18.width, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p18.layoutOrder,
		[Roact.Change.AbsoluteSize] = p18.onContainerSizeChange
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = p18.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, p18.internalSpacing or 0)
		}),
		Padding = if not p18.padding then nil else Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p18.padding.left or 0),
			PaddingRight = UDim.new(0, p18.padding.right or 0),
			PaddingTop = UDim.new(0, p18.padding.top or 0),
			PaddingBottom = UDim.new(0, p18.padding.bottom or 0)
		}),
		Elements = Roact.createFragment(p19)
	})
end

return v16
