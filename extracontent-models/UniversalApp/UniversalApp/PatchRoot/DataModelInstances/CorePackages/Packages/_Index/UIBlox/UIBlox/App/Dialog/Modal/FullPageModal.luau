local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local UIBloxConfig = require(ParentParentParent.UIBloxConfig)
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local FitFrameVertical = require(ParentParentParentParent.FitFrame).FitFrameVertical
local ButtonStack = require(ParentParent.Button.ButtonStack)
local ModalTitle = require(scriptParent.ModalTitle)
local ModalWindow = require(scriptParent.ModalWindow)
local v12 = Roact.PureComponent:extend("FullPageModal")

v12.validateProps = t.strictInterface({
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
v12.defaultProps = {
	marginSize = 24,
	distanceFromTop = 0
}

function v12.init(p1) -- line: 55
	-- upvalues: ModalTitle (copy), UIBloxConfig (copy), Roact (copy)
	p1.state = {
		buttonFrameSize = Vector2.new(0, 0),
		footerContentSize = Vector2.new(0, 0),
		titleContainerSize = Vector2.new(0, ModalTitle:GetHeight())
	}
	p1.buttonFrameRef = if not UIBloxConfig.didMountUpdateFullPageModal then nil else Roact.createRef()

	function p1.changeButtonFrameSize(p2) -- line: 63
		-- upvalues: p1 (copy)
		if p1.state.buttonFrameSize ~= p2.AbsoluteSize then
			p1:setState({
				buttonFrameSize = p2.AbsoluteSize
			})
		end
	end

	p1.footerContentRef = if not UIBloxConfig.didMountUpdateFullPageModal then nil else Roact.createRef()

	function p1.changeFooterContentSize(p3) -- line: 72
		-- upvalues: p1 (copy)
		if p1.state.footerContentSize ~= p3.AbsoluteSize then
			p1:setState({
				footerContentSize = p3.AbsoluteSize
			})
		end
	end
	function p1.changeTitleContainerSize(p4) -- line: 80
		-- upvalues: p1 (copy)
		if p1.state.titleContainerSize ~= p4.AbsoluteSize then
			p1:setState({
				titleContainerSize = p4.AbsoluteSize
			})
		end
	end
end

if UIBloxConfig.didMountUpdateFullPageModal then
	function v12.didMount(p5) -- line: 90
		if p5.buttonFrameRef.current then
			p5:setState({
				buttonFrameSize = p5.buttonFrameRef.current.AbsoluteSize
			})
		end

		if p5.footerContentRef.current then
			p5:setState({
				footerContentSize = p5.footerContentRef.current.AbsoluteSize
			})
		end
	end
end

function v12.render(p6) -- line: 104
	-- upvalues: Roact (copy), ModalWindow (copy), ModalTitle (copy), FitFrameVertical (copy), UIBloxConfig (copy), ButtonStack (copy)
	return Roact.createElement(ModalWindow, {
		isFullHeight = true,
		screenSize = p6.props.screenSize,
		position = p6.props.position,
		distanceFromTop = p6.props.distanceFromTop
	}, {
		TitleContainer = Roact.createElement(ModalTitle, {
			title = p6.props.title,
			onCloseClicked = p6.props.onCloseClicked,
			onTitleSizeChanged = p6.changeTitleContainerSize
		}),
		Content = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -p6.state.titleContainerSize.Y),
			Position = UDim2.new(0, 0, 0, p6.state.titleContainerSize.Y)
		}, {
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
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ZIndex = 2,
				Size = UDim2.new(1, -2 * p6.props.marginSize, 1, -(p6.state.buttonFrameSize.Y + p6.state.footerContentSize.Y))
			}, p6.props[Roact.Children]),
			Buttons = p6.props.buttonStackProps and Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				LayoutOrder = 2,
				[Roact.Change.AbsoluteSize] = p6.changeButtonFrameSize,
				[Roact.Ref] = if not UIBloxConfig.didMountUpdateFullPageModal then nil else p6.buttonFrameRef
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Roact.createElement(ButtonStack, p6.props.buttonStackProps)
			}),
			BottomFrame = if not p6.props.footerContent then nil else Roact.createElement("Frame", {
				Size = UDim2.new(1, -2 * p6.props.marginSize, 0, 0),
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				[Roact.Change.AbsoluteSize] = p6.changeFooterContentSize,
				[Roact.Ref] = if not UIBloxConfig.didMountUpdateFullPageModal then nil else p6.footerContentRef
			}, {
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				FooterContent = p6.props.footerContent()
			})
		})
	})
end

return v12
