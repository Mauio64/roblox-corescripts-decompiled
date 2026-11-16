local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local ButtonStack = require(parent2.Button.ButtonStack)
local CloseButtonIcon = require(script.Parent.Enum.CloseButtonIcon)

local FitFrame = require(parent3.FitFrame)
local FitFrameVertical = FitFrame.FitFrameVertical

local ModalTitle = require(parent.ModalTitle)
local ModalWindow = require(parent.ModalWindow)

local extended = Roact.PureComponent:extend("PartialPageModal")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	[Roact.Children] = t.table,
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	title = t.optional(t.string),
	titleBackgroundImageProps = t.optional(t.strictInterface({
		image = t.string,
		imageHeight = t.number,
		text = t.optional(t.string)
	})),
	bottomPadding = t.optional(t.number),
	marginSize = t.optional(t.number),
	buttonStackProps = t.optional(ButtonStack.validateProps),
	footerContent = t.optional(t.callback),
	closeButtonIcon = t.optional(CloseButtonIcon.isEnumValue),
	onCloseClicked = t.optional(t.callback),
	contentPadding = t.optional(t.UDim)
})

extended.defaultProps = { marginSize = 24, closeButtonIcon = CloseButtonIcon.Close }

function extended.render(p)
	local screenSize = p.props.screenSize
	local bottomPadding = p.props.bottomPadding or 24

	local bottom = not ModalWindow:isFullWidth(screenSize.X) and 24 or bottomPadding

	local createElement = Roact.createElement
	local v = {
		isFullHeight = false,
		screenSize = screenSize,
		position = p.props.position,
		anchorPoint = p.props.anchorPoint
	}
	local v2 = {
		TitleContainer = Roact.createElement(ModalTitle, {
			title = p.props.title,
			titleBackgroundImageProps = p.props.titleBackgroundImageProps,
			closeButtonIcon = p.props.closeButtonIcon,
			onCloseClicked = p.props.onCloseClicked
		}),
		Content = 0
	}

	local createElement2 = Roact.createElement
	local v3 = {
		Position = UDim2.new(0, 0, 0, ModalTitle.TITLE_HEIGHT),
		width = UDim.new(1, 0),
		margin = { top = 0, bottom = bottom, left = 0, right = 0 },
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		BackgroundTransparency = 1,
		contentPadding = p.props.contentPadding,
		LayoutOrder = 1
	}

	local v4 = {
		MiddlContent = Roact.createElement(FitFrameVertical, {
			width = UDim.new(1, -2 * p.props.marginSize),
			BackgroundTransparency = 1
		}, p.props[Roact.Children]),
		Buttons = p.props.buttonStackProps and Roact.createElement(
			FitFrameVertical,
			{ BackgroundTransparency = 1, width = UDim.new(1, 0), LayoutOrder = 2 },
			{
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Roact.createElement(ButtonStack, p.props.buttonStackProps)
			}
		),
		BottomFrame = 0
	}
	local bottomFrame

	if p.props.footerContent then
		bottomFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{ FooterContent = p.props.footerContent() }
		)
	end

	v4.BottomFrame = bottomFrame
	v2.Content = createElement2(FitFrameVertical, v3, v4)
	return createElement(ModalWindow, v, v2)
end

return extended
