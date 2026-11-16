local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local UIBloxConfig = require(parent3.UIBloxConfig)

local Roact = require(parent4.Roact)
local t = require(parent4.t)

local FitFrame = require(parent4.FitFrame)
local FitFrameVertical = FitFrame.FitFrameVertical

local ButtonStack = require(parent2.Button.ButtonStack)

local ModalTitle = require(parent.ModalTitle)
local ModalWindow = require(parent.ModalWindow)

local extended = Roact.PureComponent:extend("FullPageModal")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	[Roact.Children] = t.table,
	position = t.optional(t.UDim2),
	title = t.optional(t.string),
	marginSize = t.optional(t.number),
	buttonStackProps = t.optional(t.table),
	footerContent = t.optional(t.callback),
	onCloseClicked = t.optional(t.callback),
	distanceFromTop = t.optional(t.number)
})

extended.defaultProps = { marginSize = 24, distanceFromTop = 0 }

function extended:init()
	self.state = {
		buttonFrameSize = Vector2.new(0, 0),
		footerContentSize = Vector2.new(0, 0),
		titleContainerSize = Vector2.new(0, ModalTitle:GetHeight())
	}
	local ref

	if UIBloxConfig.didMountUpdateFullPageModal then
		ref = Roact.createRef()
	end

	self.buttonFrameRef = ref
	function self.changeButtonFrameSize(p)
		if self.state.buttonFrameSize ~= p.AbsoluteSize then
			self:setState({ buttonFrameSize = p.AbsoluteSize })
		end
	end

	local ref2

	if UIBloxConfig.didMountUpdateFullPageModal then
		ref2 = Roact.createRef()
	end

	self.footerContentRef = ref2
	function self.changeFooterContentSize(p)
		if self.state.footerContentSize ~= p.AbsoluteSize then
			self:setState({ footerContentSize = p.AbsoluteSize })
		end
	end

	function self.changeTitleContainerSize(p)
		if self.state.titleContainerSize ~= p.AbsoluteSize then
			self:setState({ titleContainerSize = p.AbsoluteSize })
		end
	end
end

if UIBloxConfig.didMountUpdateFullPageModal then
	function extended.didMount(object)
		if object.buttonFrameRef.current then
			object:setState({ buttonFrameSize = object.buttonFrameRef.current.AbsoluteSize })
		end

		if object.footerContentRef.current then
			object:setState({ footerContentSize = object.footerContentRef.current.AbsoluteSize })
		end
	end
end

function extended.render(props)
	local createElement = Roact.createElement
	local v = {
		isFullHeight = true,
		screenSize = props.props.screenSize,
		position = props.props.position,
		distanceFromTop = props.props.distanceFromTop
	}
	local v2 = {
		TitleContainer = Roact.createElement(ModalTitle, {
			title = props.props.title,
			onCloseClicked = props.props.onCloseClicked,
			onTitleSizeChanged = props.changeTitleContainerSize
		}),
		Content = 0
	}

	local createElement2 = Roact.createElement
	local v3 = {
		Size = UDim2.new(1, 0, 1, -props.state.titleContainerSize.Y),
		Position = UDim2.new(0, 0, 0, props.state.titleContainerSize.Y),
		BackgroundTransparency = 1
	}

	local v4 = {
		[1] = nil,
		[1] = nil,
		Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 24)
		}),
		MiddleContent = Roact.createElement("Frame", {
			Size = UDim2.new(
				1,
				-2 * props.props.marginSize,
				1,
				-(props.state.buttonFrameSize.Y + props.state.footerContentSize.Y)
			),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ZIndex = 2
		}, props.props[Roact.Children])
	}
	local buttons = props.props.buttonStackProps

	if buttons then
		local createElement3 = Roact.createElement
		local v5 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			LayoutOrder = 2,
			[Roact.Change.AbsoluteSize] = props.changeButtonFrameSize
		}
		local ref = Roact.Ref
		local v6

		if UIBloxConfig.didMountUpdateFullPageModal then
			v6 = props.buttonFrameRef
		end

		v5[ref] = v6
		buttons = createElement3(FitFrameVertical, v5, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			Roact.createElement(ButtonStack, props.props.buttonStackProps)
		})
	end

	v4.Buttons = buttons
	local bottomFrame

	if props.props.footerContent then
		local createElement3 = Roact.createElement
		local v5 = {
			Size = UDim2.new(1, -2 * props.props.marginSize, 0, 0),
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			[Roact.Change.AbsoluteSize] = props.changeFooterContentSize
		}
		local ref = Roact.Ref
		local v6

		if UIBloxConfig.didMountUpdateFullPageModal then
			v6 = props.footerContentRef
		end

		v5[ref] = v6
		bottomFrame = createElement3("Frame", v5, {
			ContentPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 24) }),
			ListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			FooterContent = props.props.footerContent()
		})
	end

	v4.BottomFrame = bottomFrame
	v2.Content = createElement2("Frame", v3, v4)
	return createElement(ModalWindow, v, v2)
end

return extended
