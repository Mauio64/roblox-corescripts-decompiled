local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local Cryo = require(ParentParentParentParent.Cryo)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ButtonStack = require(ParentParent.Button.ButtonStack)
local FitFrameOnAxis = require(ParentParentParentParent.FitFrame).FitFrameOnAxis
local AlertType = require(scriptParent.Enum.AlertType)
local AlertTitle = require(scriptParent.AlertTitle)
local v16 = Roact.PureComponent:extend("Alert")

v16.validateProps = t.strictInterface({
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
v16.defaultProps = {
	maxWidth = 400,
	minWidth = 272,
	isRoactGamepadEnabled = true,
	anchorPoint = Vector2.new(0.5, 0.5),
	margin = {
		top = 0,
		bottom = 24,
		left = 24,
		right = 24
	},
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v16.init(p1) -- line: 79
	-- upvalues: Roact (copy)
	local v18, v19 = Roact.createBinding(Vector2.new(0, 0))

	p1.contentSize = v18
	p1.changeContentSize = v19
	p1.middleContentRef = Roact.createRef()
	p1.footerContentRef = Roact.createRef()
	p1.buttonStackRef = Roact.createRef()
end
function v16.didMount(p2) -- line: 87
	if p2.props.onMounted then
		p2.props.onMounted()
	end
end
function v16.render(p3) -- line: 93
	-- upvalues: withStyle (copy), AlertType (copy), Cryo (copy), Roact (copy), RoactGamepad (copy), ImageSetComponent (copy), Images (copy), FitFrameOnAxis (copy), AlertTitle (copy), ButtonStack (copy)
	local isMiddleContentFocusable = p3.props.isMiddleContentFocusable
	local isFooterContentFocusable = p3.props.isFooterContentFocusable
	local isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled
	local v25 = math.clamp(p3.props.screenSize.X - p3.props.margin.left - p3.props.margin.right, p3.props.minWidth, p3.props.maxWidth)

	return withStyle(function(p4) -- line: 104
		-- upvalues: p3 (copy), AlertType (copy), Cryo (copy), Roact (copy), isRoactGamepadEnabled (copy), isMiddleContentFocusable (copy), isFooterContentFocusable (copy), RoactGamepad (copy), ImageSetComponent (copy), Images (copy), FitFrameOnAxis (copy), v25 (copy), AlertTitle (copy), ButtonStack (copy)
		local Theme = p4.Theme
		local BackgroundUIDefaultColor = nil
		local BackgroundUIDefaultTransparency, n1

		if p3.props.alertType == AlertType.Interactive then
			BackgroundUIDefaultColor = Theme.BackgroundUIDefault.Color
			BackgroundUIDefaultTransparency = Theme.BackgroundUIDefault.Transparency
			n1 = 1
		else
			n1 = Theme.BackgroundUIContrast.Transparency
			BackgroundUIDefaultTransparency = 1
		end

		local buttonStackInfo = p3.props.buttonStackInfo

		if buttonStackInfo then
			buttonStackInfo = Cryo.Dictionary.join(buttonStackInfo, {
				[Roact.Ref] = if not isRoactGamepadEnabled then nil else p3.buttonStackRef,
				NextSelectionUp = if not isRoactGamepadEnabled then nil else isMiddleContentFocusable and p3.middleContentRef or nil,
				NextSelectionDown = if not isRoactGamepadEnabled then nil else isFooterContentFocusable and p3.footerContentRef or nil,
				isRoactGamepadEnabled = isRoactGamepadEnabled
			})
		end

		return Roact.createElement(if not isRoactGamepadEnabled then ImageSetComponent.Button else RoactGamepad.Focusable[ImageSetComponent.Button], {
			Position = p3.props.position,
			AnchorPoint = p3.props.anchorPoint,
			Size = p3.contentSize:map(function(p5) -- line: 138
				return UDim2.new(0, p5.X, 0, p5.Y)
			end),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = n1,
			BorderSizePixel = 0,
			Image = Images["component_assets/circle_17"],
			ImageColor3 = BackgroundUIDefaultColor,
			ImageTransparency = BackgroundUIDefaultTransparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false,
			[Roact.Ref] = if not isRoactGamepadEnabled then nil else p3.props.defaultChildRef,
			[Roact.Change.AbsoluteSize] = p3.props.onAbsoluteSizeChanged,
			defaultChild = if not isRoactGamepadEnabled then nil else p3.buttonStackRef
		}, {
			AlertContents = Roact.createElement(FitFrameOnAxis, {
				contentPadding = UDim.new(0, 24),
				margin = p3.props.margin,
				minimumSize = UDim2.new(0, v25, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[Roact.Change.AbsoluteSize] = function(p6) -- line: 164
					-- upvalues: p3 (copy)
					p3.changeContentSize(p6.AbsoluteSize)
				end
			}, {
				TitleContainer = Roact.createElement(AlertTitle, {
					layoutOrder = 1,
					margin = p3.props.margin,
					maxWidth = p3.props.maxWidth,
					minWidth = p3.props.minWidth,
					screenSize = p3.props.screenSize,
					title = p3.props.title,
					titleContent = p3.props.titleContent,
					onCloseClicked = p3.props.onCloseClicked
				}),
				MiddleContent = p3.props.middleContent and Roact.createElement(if not isRoactGamepadEnabled then FitFrameOnAxis else RoactGamepad.Focusable[FitFrameOnAxis], {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					minimumSize = UDim2.new(1, 0, 0, 0),
					[Roact.Ref] = if not isRoactGamepadEnabled then nil else p3.middleContentRef,
					NextSelectionDown = if not isRoactGamepadEnabled then nil else isMiddleContentFocusable and p3.buttonStackRef or nil
				}, {
					Content = p3.props.middleContent()
				}),
				Footer = Roact.createElement(FitFrameOnAxis, {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					contentPadding = UDim.new(0, 12),
					minimumSize = UDim2.new(1, 0, 0, 0)
				}, {
					Buttons = buttonStackInfo and Roact.createElement(ButtonStack, buttonStackInfo),
					FooterContent = p3.props.footerContent and Roact.createElement(if not isRoactGamepadEnabled then FitFrameOnAxis else RoactGamepad.Focusable[FitFrameOnAxis], {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						minimumSize = UDim2.new(1, 0, 0, 0),
						[Roact.Ref] = if not isRoactGamepadEnabled then nil else p3.footerContentRef,
						NextSelectionUp = if not isRoactGamepadEnabled then nil else isFooterContentFocusable and p3.buttonStackRef or nil
					}, {
						Content = p3.props.footerContent()
					})
				})
			}) or nil
		})
	end)
end

return v16
