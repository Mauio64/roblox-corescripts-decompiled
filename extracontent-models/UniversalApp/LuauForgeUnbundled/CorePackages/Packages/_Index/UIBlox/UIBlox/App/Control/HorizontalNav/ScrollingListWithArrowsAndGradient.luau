local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/bundled/dMC")

local module3 = require("@luauforge/bundled/dwA")
local module4 = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/GradientFrame")
local module5 = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ArrowFrame")
local module6 = require("@luauforge/bundled/fuD")
local module7 = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/IntroScroll")
local module8 = require("@luauforge/deferred/gmh")

local extended = Roact.PureComponent:extend("ScrollingListWithArrowsAndGradient")

local module9 = require("@luauforge/deferred/gSE")

local module10 = require("@luauforge/deferred/gSx")

local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation

local fFlagAXEnableEditorCategoryDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableEditorCategoryDeepLink

local strictInterface = t.strictInterface
local v5 = {
	getScollingListContent = t.callback,
	listHeight = 0,
	scrollingFrameRef = 0,
	buttonRefs = 0,
	buttonWidth = 0,
	numButtons = 0,
	padOutsideEdges = 0,
	childWidgetIndex = 0,
	useIntroScroll = 0,
	buttonPadding = 0,
	filterButtonRef = 0,
	backgroundColor = 0,
	supportFilterButton = 0,
	hideFilterButton = 0,
	filterButtonWidth = 0,
	filterButtonGradientWidth = 0,
	onSizeChanged = 0,
	lastInputGroup = 0
}
local v6 = if module9() then t.optional(t.number) else t.number
v5.listHeight = v6
v5.scrollingFrameRef = t.table
v5.buttonRefs = t.optional(t.table)
v5.buttonWidth = t.optional(t.number)
v5.numButtons = t.optional(t.number)
v5.padOutsideEdges = t.optional(t.boolean)
v5.childWidgetIndex = t.optional(t.string)
v5.useIntroScroll = t.optional(t.boolean)
v5.buttonPadding = t.number
local v7 = if module2() then t.optional(t.table) else nil
v5.filterButtonRef = v7
local v8 = if module2() or fFlagAXMoveCatalogFilterToL1Navigation then t.optional(t.Color3) else nil
v5.backgroundColor = v8

local v9 = if fFlagAXMoveCatalogFilterToL1Navigation then t.optional(t.boolean) else nil
v5.supportFilterButton = v9
local v10 = if fFlagAXMoveCatalogFilterToL1Navigation then t.optional(t.boolean) else nil
v5.hideFilterButton = v10
local v11 = if fFlagAXMoveCatalogFilterToL1Navigation then t.optional(t.number) else nil
v5.filterButtonWidth = v11
local v12 = if fFlagAXMoveCatalogFilterToL1Navigation then t.optional(t.number) else nil
v5.filterButtonGradientWidth = v12
local v13 = if fFlagAXEnableEditorCategoryDeepLink then t.optional(t.callback) else nil
v5.onSizeChanged = v13

v5.lastInputGroup = t.string
extended.validateProps = strictInterface(v5)

function extended:init()
	self.gradientFrameRef = Roact.createRef()

	local binding, v14 = Roact.createBinding(false)
	self.arrowLeftVisible = binding
	self.updateArrowLeftVisible = v14
	local binding2, v15 = Roact.createBinding(false)
	self.arrowRightVisible = binding2
	self.updateArrowRightVisible = v15

	local binding3, v16 = Roact.createBinding(Vector2.new(0, 0))
	self.canvasPosition = binding3
	self.updateCanvasPosition = v16

	function self.onCanvasPositionChange(p2)
		self.checkShowGradient(p2)

		self.updateCanvasPosition(p2.CanvasPosition)
	end

	function self.checkShowGradient(p2)
		local value = self.gradientFrameRef:getValue()

		if not value then
			return
		end

		local shouldShowGradientForScrollingFrame, v17, v18 = module6.shouldShowGradientForScrollingFrame(p2)
		value.Visible = shouldShowGradientForScrollingFrame

		local left = value:FindFirstChild("Left")
		local right = value:FindFirstChild("Right")

		if left and right then
			left.Visible = v17
			right.Visible = v18
		end

		self.updateArrowLeftVisible(v17)
		self.updateArrowRightVisible(v18)
	end

	if fFlagAXEnableEditorCategoryDeepLink then
		function self.onAbsoluteSizeChange(p2)
			self.checkShowGradient(p2)

			if self.props.onSizeChanged then
				self.props.onSizeChanged(p2)
			end
		end
	end
end

function extended.didUpdate(p2)
	local value = p2.props.scrollingFrameRef:getValue()

	if value then
		p2.checkShowGradient(value)
	end
end

function extended.render(props)
	local listHeight = props.props.listHeight
	local v14 = props.props.lastInputGroup == module3.InputType.MouseAndKeyboard
	local childWidgetIndex = props.props.childWidgetIndex
	local useIntroScroll = props.props.useIntroScroll
	local filterButtonWidth = props.props.filterButtonWidth
	local filterButtonGradientWidth = props.props.filterButtonGradientWidth

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v16 = {
		ClipsDescendants = false,
		["Size"] = UDim2.new(1, 0, 1, 0),
		Selectable = false,
		CanvasSize = nil,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasPosition = props.canvasPosition,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ZIndex = 2
	}

	local absoluteSize = Roact.Change.AbsoluteSize
	local v17 = if fFlagAXEnableEditorCategoryDeepLink then props.onAbsoluteSizeChange else props.checkShowGradient
	v16[absoluteSize] = v17

	v16[Roact.Change.CanvasSize] = props.checkShowGradient
	v16[Roact.Change.CanvasPosition] = props.onCanvasPositionChange

	v16[Roact.Ref] = props.props.scrollingFrameRef
	local children = {
		ScrollingList = createElement("ScrollingFrame", v16, props.props.getScollingListContent()),
		GradientFrame = 0,
		ArrowFrame = 0,
		IntroScroll = 0,
		FilterButton = 0
	}

	local createElement2 = Roact.createElement

	if module9() then
		listHeight = nil
	end

	children.GradientFrame = createElement2(module4, {
		height = listHeight,
		frameRef = props.gradientFrameRef,
		ZIndex = 3
	})

	if v14 then
		local createElement3 = Roact.createElement
		local v21 = {
			isVisibleLeft = props.arrowLeftVisible,
			isVisibleRight = props.arrowRightVisible,
			supportFilterButton = 0,
			isFilterButtonVisible = 0,
			filterButtonWidth = 0,
			defaultUseProps = 0,
			ZIndex = 0
		}

		local v22 = if fFlagAXMoveCatalogFilterToL1Navigation then props.props.supportFilterButton else nil
		v21.supportFilterButton = v22

		local v23 = if fFlagAXMoveCatalogFilterToL1Navigation and props.props.supportFilterButton then not props.props.hideFilterButton else nil
		v21.isFilterButtonVisible = v23

		local v24 = if props.props.supportFilterButton then filterButtonWidth else nil
		v21.filterButtonWidth = v24
		v21.defaultUseProps = {
			scrollingFrameRef = props.props.scrollingFrameRef,
			buttonRefs = props.props.buttonRefs,
			buttonWidth = props.props.buttonWidth,
			padOutsideEdges = props.props.padOutsideEdges,
			numButtons = props.props.numButtons,
			buttonPadding = props.props.buttonPadding,
			updateCanvasPosition = props.updateCanvasPosition
		}

		v21.ZIndex = fFlagAXMoveCatalogFilterToL1Navigation and props.props.supportFilterButton and 5 or 4
		v14 = createElement3(module5, v21)
	end

	children.ArrowFrame = v14

	local v20 = if useIntroScroll then Roact.createElement(module7, {
		childWidgetIndex = childWidgetIndex,
		scrollingFrameRef = props.props.scrollingFrameRef,
		updateCanvasPosition = props.updateCanvasPosition
	}) or nil else nil
	children.IntroScroll = v20

	children.FilterButton = fFlagAXMoveCatalogFilterToL1Navigation
		and props.props.supportFilterButton
		and not props.props.hideFilterButton
		and Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, filterButtonWidth, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 4
		}, {
			GradientFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -filterButtonGradientWidth, 0.5, 0),
				Size = UDim2.new(0, filterButtonGradientWidth, 1, 0),
				BackgroundColor3 = props.props.backgroundColor,
				BackgroundTransparency = 0,
				BorderSizePixel = 0
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.9, 0),
						NumberSequenceKeypoint.new(1, 0)
					}),
					Rotation = 0
				})
			}),
			InnerFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, filterButtonWidth, 1, 0),
				BackgroundColor3 = props.props.backgroundColor,
				BackgroundTransparency = 0,
				BorderSizePixel = 0
			}, {
				FilterButton = Roact.createElement(module10, {
					buttonRef = props.props.filterButtonRef
				})
			})
		})
	return createFragment(children)
end

return (module8(extended))
