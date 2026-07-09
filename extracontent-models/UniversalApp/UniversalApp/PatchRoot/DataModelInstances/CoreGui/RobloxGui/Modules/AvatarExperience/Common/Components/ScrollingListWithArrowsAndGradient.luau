local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local Constants = require(Modules.LuaApp.Constants)
local GradientFrame = require(Modules.AvatarExperience.Common.Components.NavBar.GradientFrame)
local ArrowFrame = require(Modules.AvatarExperience.Common.Components.NavBar.ArrowFrame)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local IntroScroll = require(Modules.AvatarExperience.Common.Components.NavBar.IntroScroll)
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local v14 = Roact.PureComponent:extend("ScrollingListWithArrowsAndGradient")
local GetFFlagAXEnableAutomaticSizeGradientFrame = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableAutomaticSizeGradientFrame)
local FilterButton = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButton)
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXEnableEditorCategoryDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableEditorCategoryDeepLink

v14.validateProps = t.strictInterface({
	getScollingListContent = t.callback,
	listHeight = if not GetFFlagAXEnableAutomaticSizeGradientFrame() then t.number else t.optional(t.number),
	scrollingFrameRef = t.table,
	buttonRefs = t.optional(t.table),
	buttonWidth = t.optional(t.number),
	numButtons = t.optional(t.number),
	padOutsideEdges = t.optional(t.boolean),
	childWidgetIndex = t.optional(t.string),
	useIntroScroll = t.optional(t.boolean),
	buttonPadding = t.number,
	filterButtonRef = if not GetFFlagAXEnableCategoryPills() then nil else t.optional(t.table),
	backgroundColor = if not GetFFlagAXEnableCategoryPills() and not FFlagAXMoveCatalogFilterToL1Navigation then nil else t.optional(t.Color3),
	supportFilterButton = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t.optional(t.boolean),
	hideFilterButton = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t.optional(t.boolean),
	filterButtonWidth = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t.optional(t.number),
	filterButtonGradientWidth = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t.optional(t.number),
	onSizeChanged = if not FFlagAXEnableEditorCategoryDeepLink then nil else t.optional(t.callback),
	lastInputGroup = t.string
})

function v14.init(p1) -- line: 64
	-- upvalues: Roact (copy), Utils (copy), FFlagAXEnableEditorCategoryDeepLink (copy)
	p1.gradientFrameRef = Roact.createRef()

	local v20, v21 = Roact.createBinding(false)

	p1.arrowLeftVisible = v20
	p1.updateArrowLeftVisible = v21

	local v22, v23 = Roact.createBinding(false)

	p1.arrowRightVisible = v22
	p1.updateArrowRightVisible = v23

	local v24, v25 = Roact.createBinding(Vector2.new(0, 0))

	p1.canvasPosition = v24
	p1.updateCanvasPosition = v25

	function p1.onCanvasPositionChange(p2) -- line: 72
		-- upvalues: p1 (copy)
		p1.checkShowGradient(p2)
		p1.updateCanvasPosition(p2.CanvasPosition)
	end
	function p1.checkShowGradient(p3) -- line: 79
		-- upvalues: p1 (copy), Utils (copy)
		local v37 = p1.gradientFrameRef:getValue()

		if not v37 then
			return
		end

		local v38, v39, v40 = Utils.shouldShowGradientForScrollingFrame(p3)

		v37.Visible = v38

		local Left = v37:FindFirstChild("Left")
		local Right = v37:FindFirstChild("Right")

		if Left and Right then
			Left.Visible = v39
			Right.Visible = v40
		end

		p1.updateArrowLeftVisible(v39)
		p1.updateArrowRightVisible(v40)
	end

	if FFlagAXEnableEditorCategoryDeepLink then
		function p1.onAbsoluteSizeChange(p4) -- line: 101
			-- upvalues: p1 (copy)
			p1.checkShowGradient(p4)

			if p1.props.onSizeChanged then
				p1.props.onSizeChanged(p4)
			end
		end
	end
end
function v14.didUpdate(p5) -- line: 110
	local v27 = p5.props.scrollingFrameRef:getValue()

	if v27 then
		p5.checkShowGradient(v27)
	end
end
function v14.render(p6) -- line: 117
	-- upvalues: Constants (copy), Roact (copy), FFlagAXEnableEditorCategoryDeepLink (copy), GradientFrame (copy), GetFFlagAXEnableAutomaticSizeGradientFrame (copy), ArrowFrame (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), IntroScroll (copy), FilterButton (copy)
	local listHeight = p6.props.listHeight
	local v30 = p6.props.lastInputGroup == Constants.InputType.MouseAndKeyboard
	local childWidgetIndex = p6.props.childWidgetIndex
	local useIntroScroll = p6.props.useIntroScroll
	local filterButtonWidth = p6.props.filterButtonWidth
	local filterButtonGradientWidth = p6.props.filterButtonGradientWidth

	return Roact.createFragment({
		ScrollingList = Roact.createElement("ScrollingFrame", {
			ClipsDescendants = false,
			Size = UDim2.new(1, 0, 1, 0),
			Selectable = false,
			CanvasSize = nil,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasPosition = p6.canvasPosition,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ZIndex = 2,
			[Roact.Change.AbsoluteSize] = if not FFlagAXEnableEditorCategoryDeepLink then p6.checkShowGradient else p6.onAbsoluteSizeChange,
			[Roact.Change.CanvasSize] = p6.checkShowGradient,
			[Roact.Change.CanvasPosition] = p6.onCanvasPositionChange,
			[Roact.Ref] = p6.props.scrollingFrameRef
		}, p6.props.getScollingListContent()),
		GradientFrame = Roact.createElement(GradientFrame, {
			ZIndex = 3,
			height = if not GetFFlagAXEnableAutomaticSizeGradientFrame() then listHeight else nil,
			frameRef = p6.gradientFrameRef
		}),
		ArrowFrame = v30 and Roact.createElement(ArrowFrame, {
			isVisibleLeft = p6.arrowLeftVisible,
			isVisibleRight = p6.arrowRightVisible,
			supportFilterButton = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else p6.props.supportFilterButton,
			isFilterButtonVisible = if not FFlagAXMoveCatalogFilterToL1Navigation or not p6.props.supportFilterButton then nil else not p6.props.hideFilterButton,
			filterButtonWidth = if not p6.props.supportFilterButton then nil else filterButtonWidth,
			defaultUseProps = {
				scrollingFrameRef = p6.props.scrollingFrameRef,
				buttonRefs = p6.props.buttonRefs,
				buttonWidth = p6.props.buttonWidth,
				padOutsideEdges = p6.props.padOutsideEdges,
				numButtons = p6.props.numButtons,
				buttonPadding = p6.props.buttonPadding,
				updateCanvasPosition = p6.updateCanvasPosition
			},
			ZIndex = (not FFlagAXMoveCatalogFilterToL1Navigation or not p6.props.supportFilterButton) and 4 or 5
		}),
		IntroScroll = useIntroScroll and Roact.createElement(IntroScroll, {
			childWidgetIndex = childWidgetIndex,
			scrollingFrameRef = p6.props.scrollingFrameRef,
			updateCanvasPosition = p6.updateCanvasPosition
		}) or nil,
		FilterButton = FFlagAXMoveCatalogFilterToL1Navigation and (p6.props.supportFilterButton and (not p6.props.hideFilterButton and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 4,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, filterButtonWidth, 1, 0)
		}, {
			GradientFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -filterButtonGradientWidth, 0.5, 0),
				Size = UDim2.new(0, filterButtonGradientWidth, 1, 0),
				BackgroundColor3 = p6.props.backgroundColor
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.9, 0),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			}),
			InnerFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, filterButtonWidth, 1, 0),
				BackgroundColor3 = p6.props.backgroundColor
			}, {
				FilterButton = Roact.createElement(FilterButton, {
					buttonRef = p6.props.filterButtonRef
				})
			})
		})))
	})
end

return (withLastInputGroup(v14))
