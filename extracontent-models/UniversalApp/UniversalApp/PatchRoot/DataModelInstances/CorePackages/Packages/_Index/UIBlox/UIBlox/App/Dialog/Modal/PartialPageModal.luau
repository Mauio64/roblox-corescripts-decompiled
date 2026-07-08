local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local Roact = require(ParentParent2.Roact)
local t = require(ParentParent2.t)
local ButtonStack = require(ParentParent.Button.ButtonStack)
local CloseButtonIcon = require(script.Parent.Enum.CloseButtonIcon)
local FitFrameVertical = require(ParentParent2.FitFrame).FitFrameVertical
local ModalTitle = require(scriptParent.ModalTitle)
local ModalWindow = require(scriptParent.ModalWindow)
local v11 = Roact.PureComponent:extend("PartialPageModal")

v11.validateProps = t.strictInterface({
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
v11.defaultProps = {
	marginSize = 24,
	closeButtonIcon = CloseButtonIcon.Close
}

function v11.render(p1) -- line: 66
	-- upvalues: ModalWindow (copy), Roact (copy), ModalTitle (copy), FitFrameVertical (copy), ButtonStack (copy)
	local screenSize = p1.props.screenSize
	local v14 = p1.props.bottomPadding or 24

	if not ModalWindow:isFullWidth(screenSize.X) then
		v14 = 24
	end

	return Roact.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = screenSize,
		position = p1.props.position,
		anchorPoint = p1.props.anchorPoint
	}, {
		TitleContainer = Roact.createElement(ModalTitle, {
			title = p1.props.title,
			titleBackgroundImageProps = p1.props.titleBackgroundImageProps,
			closeButtonIcon = p1.props.closeButtonIcon,
			onCloseClicked = p1.props.onCloseClicked
		}),
		Content = Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Position = UDim2.new(0, 0, 0, ModalTitle.TITLE_HEIGHT),
			width = UDim.new(1, 0),
			margin = {
				top = 0,
				left = 0,
				right = 0,
				bottom = v14
			},
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			contentPadding = p1.props.contentPadding
		}, {
			MiddlContent = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, -2 * p1.props.marginSize)
			}, p1.props[Roact.Children]),
			Buttons = p1.props.buttonStackProps and Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				width = UDim.new(1, 0)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Roact.createElement(ButtonStack, p1.props.buttonStackProps)
			}),
			BottomFrame = if not p1.props.footerContent then nil else Roact.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				FooterContent = p1.props.footerContent()
			})
		})
	})
end

return v11
