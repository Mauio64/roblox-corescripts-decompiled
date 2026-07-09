local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local withStyle = UIBlox.Style.withStyle
local Utils = require(Modules.AvatarExperience.Common.Utils)
local v13 = Roact.PureComponent:extend("PillBar")

v13.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.number),
	[Roact.Children] = t.optional(t.table),
	height = t.optional(t.number),
	forwardRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table)
})

function v13.init(p1) -- line: 40
	-- upvalues: Roact (copy), Utils (copy)
	p1.gradientFrameRef = Roact.createRef()
	p1.scrollingFrameRef = Roact.createRef()
	p1.categoryButtonRefs = {}

	local v16, v17 = Roact.createBinding(false)

	p1.showLeftGradientBinding = v16
	p1.updateShowLeftGradient = v17

	local v18, v19 = Roact.createBinding(false)

	p1.showRightGradientBinding = v18
	p1.updateShowRightGradient = v19

	function p1.checkShowGradient(p2) -- line: 48
		-- upvalues: Utils (copy), p1 (copy)
		local v27, v28, v29 = Utils.shouldShowGradientForScrollingFrame(p2)
		local v30 = v27 and v28
		local v31 = v27 and v29

		p1.updateShowLeftGradient(v30)
		p1.updateShowRightGradient(v31)
	end
	function p1.onNavFrameSizeChanged(p3) -- line: 58
		-- upvalues: p1 (copy)
		if p1.scrollingFrameRef.current then
			p1.scrollingFrameRef.current.CanvasSize = UDim2.new(0, p3.AbsoluteSize.X, 1, 0)
		end
	end
end

local function renderGradient(p4, p5) -- line: 65
	-- upvalues: Roact (copy)
	return Roact.createElement("UIGradient", {
		Rotation = p5,
		Color = ColorSequence.new(p4.BackgroundDefault.Color),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.666, 1),
			NumberSequenceKeypoint.new(1, 1)
		})
	})
end

function v13.render(p6) -- line: 77
	-- upvalues: withStyle (copy), Roact (copy), Focusable (copy), renderGradient (copy), FitFrameHorizontal (copy), RoactFitComponents (copy)
	local layoutOrder = p6.props.layoutOrder

	return withStyle(function(p7) -- line: 80
		-- upvalues: p6 (copy), Roact (copy), Focusable (copy), layoutOrder (copy), renderGradient (copy), FitFrameHorizontal (copy), RoactFitComponents (copy)
		local Theme = p7.Theme
		local forwardRef = p6.props.forwardRef
		local height = p6.props.height
		local v37 = if not height then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 0, height)

		return Roact.createElement(Focusable.Frame, {
			Size = v37,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			[Roact.Ref] = forwardRef,
			NextSelectionUp = p6.props.NextSelectionUp,
			NextSelectionDown = p6.props.NextSelectionDown
		}, {
			Left = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 50, 1, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Visible = p6.showLeftGradientBinding
			}, {
				Gradient = renderGradient(Theme, 0)
			}),
			Right = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 50, 1, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				Visible = p6.showRightGradientBinding
			}, {
				Gradient = renderGradient(Theme, 180)
			}),
			ScrollingList = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				ZIndex = 1,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ScrollingDirection = Enum.ScrollingDirection.X,
				[Roact.Change.AbsoluteSize] = p6.checkShowGradient,
				[Roact.Change.CanvasSize] = p6.checkShowGradient,
				[Roact.Change.CanvasPosition] = p6.checkShowGradient,
				[Roact.Ref] = p6.scrollingFrameRef
			}, {
				SubNavFrame = Roact.createElement(FitFrameHorizontal, {
					height = UDim.new(1, 0),
					contentPadding = UDim.new(0, 15),
					margin = RoactFitComponents.Rect.rectangle(15, 0),
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					BackgroundTransparency = 1,
					[Roact.Change.AbsoluteSize] = p6.onNavFrameSizeChanged
				}, p6.props[Roact.Children])
			})
		})
	end)
end

return Roact.forwardRef(function(p8, p9) -- line: 150
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
