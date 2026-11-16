local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local RoactGamepad = require(parent4.RoactGamepad)
local Cryo = require(parent4.Cryo)

local Images = require(parent2.ImageSet.Images)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local withStyle = require(parent3.Core.Style.withStyle)

local ButtonStack = require(parent2.Button.ButtonStack)

local FitFrame = require(parent4.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local AlertType = require(parent.Enum.AlertType)
local AlertTitle = require(parent.AlertTitle)

local extended = Roact.PureComponent:extend("Alert")

extended.validateProps = t.strictInterface({
	alertType = AlertType.isEnumValue,
	maxWidth = t.optional(t.number),
	minWidth = t.optional(t.number),
	margin = t.optional(t.table),
	anchorPoint = t.optional(t.Vector2),
	onMounted = t.optional(t.callback),
	onAbsoluteSizeChanged = t.optional(t.callback),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	title = t.string,
	titleContent = t.optional(t.callback),
	middleContent = t.optional(t.callback),
	buttonStackInfo = t.optional(ButtonStack.validateProps),
	footerContent = t.optional(t.callback),
	onCloseClicked = t.optional(t.callback),
	defaultChildRef = t.optional(t.union(t.table, t.callback)),
	isMiddleContentFocusable = t.optional(t.boolean),
	isFooterContentFocusable = t.optional(t.boolean),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	margin = { top = 0, bottom = 24, left = 24, right = 24 },
	maxWidth = 400,
	minWidth = 272,
	position = UDim2.new(0.5, 0, 0.5, 0),
	isRoactGamepadEnabled = true
}

function extended:init()
	local binding, changeContentSize = Roact.createBinding(Vector2.new(0, 0))
	self.contentSize = binding
	self.changeContentSize = changeContentSize

	self.middleContentRef = Roact.createRef()
	self.footerContentRef = Roact.createRef()
	self.buttonStackRef = Roact.createRef()
end

function extended.didMount(p)
	if p.props.onMounted then
		p.props.onMounted()
	end
end

function extended.render(data)
	local isMiddleContentFocusable = data.props.isMiddleContentFocusable
	local isFooterContentFocusable = data.props.isFooterContentFocusable
	local isRoactGamepadEnabled = data.props.isRoactGamepadEnabled

	local v = math.clamp(
		data.props.screenSize.X - data.props.margin.left - data.props.margin.right,
		data.props.minWidth,
		data.props.maxWidth
	)

	return withStyle(function(p)
		local theme = p.Theme

		local color = nil
		local imageTransparency, backgroundTransparency

		if data.props.alertType == AlertType.Interactive then
			color = theme.BackgroundUIDefault.Color
			imageTransparency = theme.BackgroundUIDefault.Transparency
			backgroundTransparency = 1
		else
			backgroundTransparency = theme.BackgroundUIContrast.Transparency
			imageTransparency = 1
		end

		local buttonStackInfo = data.props.buttonStackInfo

		if buttonStackInfo then
			local join = Cryo.Dictionary.join
			local ref = Roact.Ref
			local v2

			if isRoactGamepadEnabled then
				v2 = data.buttonStackRef
			end

			local v3 = { [ref] = v2 }
			local nextSelectionUp

			if isRoactGamepadEnabled then
				nextSelectionUp = isMiddleContentFocusable and data.middleContentRef or nil
			end

			v3.NextSelectionUp = nextSelectionUp
			local nextSelectionDown

			if isRoactGamepadEnabled then
				nextSelectionDown = isFooterContentFocusable and data.footerContentRef or nil
			end

			v3.NextSelectionDown = nextSelectionDown

			v3.isRoactGamepadEnabled = isRoactGamepadEnabled
			buttonStackInfo = join(buttonStackInfo, v3)
		end

		local createElement = Roact.createElement
		local v2

		if isRoactGamepadEnabled then
			v2 = RoactGamepad.Focusable[ImageSetComponent.Button]
		else
			v2 = ImageSetComponent.Button
		end

		local v3 = {
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			Position = data.props.position,
			AnchorPoint = data.props.anchorPoint,
			Size = data.contentSize:map(function(p2)
				return UDim2.new(0, p2.X, 0, p2.Y)
			end),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			Image = Images["component_assets/circle_17"],
			ImageColor3 = color,
			ImageTransparency = imageTransparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false
		}

		local ref = Roact.Ref
		local v4

		if isRoactGamepadEnabled then
			v4 = data.props.defaultChildRef
		end

		v3[ref] = v4
		v3[Roact.Change.AbsoluteSize] = data.props.onAbsoluteSizeChanged
		local defaultChild

		if isRoactGamepadEnabled then
			defaultChild = data.buttonStackRef
		end

		v3.defaultChild = defaultChild

		local createElement2 = Roact.createElement
		local v5 = {
			contentPadding = UDim.new(0, 24),
			margin = data.props.margin,
			minimumSize = UDim2.new(0, v, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Change.AbsoluteSize] = function(p2)
				data.changeContentSize(p2.AbsoluteSize)
			end
		}
		local v6 = {
			TitleContainer = Roact.createElement(AlertTitle, {
				layoutOrder = 1,
				margin = data.props.margin,
				maxWidth = data.props.maxWidth,
				minWidth = data.props.minWidth,
				screenSize = data.props.screenSize,
				title = data.props.title,
				titleContent = data.props.titleContent,
				onCloseClicked = data.props.onCloseClicked
			}),
			MiddleContent = 0,
			Footer = 0
		}

		local middleContent = data.props.middleContent

		if middleContent then
			local createElement3 = Roact.createElement
			local v7

			if isRoactGamepadEnabled then
				v7 = RoactGamepad.Focusable[FitFrameOnAxis]
			else
				v7 = FitFrameOnAxis
			end

			local v8 = {
				["BackgroundTransparency"] = nil,
				["BackgroundTransparency"] = nil,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				minimumSize = UDim2.new(1, 0, 0, 0)
			}

			local ref2 = Roact.Ref
			local v9

			if isRoactGamepadEnabled then
				v9 = data.middleContentRef
			end

			v8[ref2] = v9
			local nextSelectionDown

			if isRoactGamepadEnabled then
				nextSelectionDown = isMiddleContentFocusable and data.buttonStackRef or nil
			end

			v8.NextSelectionDown = nextSelectionDown
			middleContent = createElement3(v7, v8, { Content = data.props.middleContent() })
		end

		v6.MiddleContent = middleContent

		local createElement3 = Roact.createElement
		local v7 = {
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, 12),
			LayoutOrder = 3,
			minimumSize = UDim2.new(1, 0, 0, 0)
		}
		local v8 = {
			Buttons = buttonStackInfo and Roact.createElement(ButtonStack, buttonStackInfo),
			FooterContent = 0
		}
		local footerContent = data.props.footerContent

		if footerContent then
			local createElement4 = Roact.createElement
			local v9

			if isRoactGamepadEnabled then
				v9 = RoactGamepad.Focusable[FitFrameOnAxis]
			else
				v9 = FitFrameOnAxis
			end

			local v10 = {
				["BackgroundTransparency"] = nil,
				["BackgroundTransparency"] = nil,
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				minimumSize = UDim2.new(1, 0, 0, 0)
			}

			local ref2 = Roact.Ref
			local v11

			if isRoactGamepadEnabled then
				v11 = data.footerContentRef
			end

			v10[ref2] = v11
			local nextSelectionUp

			if isRoactGamepadEnabled then
				nextSelectionUp = isFooterContentFocusable and data.buttonStackRef or nil
			end

			v10.NextSelectionUp = nextSelectionUp
			footerContent = createElement4(v9, v10, { Content = data.props.footerContent() })
		end

		v8.FooterContent = footerContent
		v6.Footer = createElement3(FitFrameOnAxis, v7, v8)
		return createElement(v2, v3, {
			AlertContents = createElement2(FitFrameOnAxis, v5, v6) or nil
		})
	end)
end

return extended
