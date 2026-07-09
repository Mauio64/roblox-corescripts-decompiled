local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Focusable = RoactGamepad.Focusable
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local withStyle = UIBlox.Style.withStyle
local BulletListEntry = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.BulletListEntry)
local v12 = Roact.PureComponent:extend("ItemsBulletList")

v12.validateProps = t.strictInterface({
	items = t.array(t.string),
	maxHeight = t.number,
	onScrollableUpdated = t.callback,
	forwardRef = t.table
})

function v12.init(p1) -- line: 34
	-- upvalues: Roact (copy)
	p1:setState({
		canvasSizeY = 0
	})
	p1.scrollViewRef = Roact.createRef()

	local v14, v15 = Roact.createBinding(false)

	p1.topGradientVisibleBinding = v14
	p1.updateTopGradientVisibleBinding = v15

	local v16, v17 = Roact.createBinding(false)

	p1.bottomGradientVisibleBinding = v16
	p1.updateBottomGradientVisibleBinding = v17

	function p1.checkIsScrollable() -- line: 44
		-- upvalues: p1 (copy)
		local v39 = p1.state.canvasSizeY > p1.props.maxHeight

		p1.props.onScrollableUpdated(v39)
	end
	function p1.onContentSizeChanged(p2) -- line: 50
		-- upvalues: p1 (copy)
		if p1.state.canvasSizeY ~= p2.AbsoluteContentSize.Y then
			p1:setState({
				canvasSizeY = p2.AbsoluteContentSize.Y
			})
		end
	end

	local forwardRef = p1.props.forwardRef

	function p1.firstEntryPositionChanged(p3) -- line: 60
		-- upvalues: forwardRef (copy), p1 (copy)
		local v42 = forwardRef:getValue()

		if not v42 then
			return
		end

		if p3.AbsolutePosition.Y + 5 < v42.AbsolutePosition.Y then
			p1.updateTopGradientVisibleBinding(true)

			return
		end

		p1.updateTopGradientVisibleBinding(false)
	end
	function p1.lastEntryPositionChanged(p4) -- line: 73
		-- upvalues: forwardRef (copy), p1 (copy)
		local v44 = forwardRef:getValue()

		if not v44 then
			return
		end

		local v45 = p4.AbsolutePosition.Y + p4.AbsoluteSize.Y

		if v44.AbsolutePosition.Y + v44.AbsoluteSize.Y < v45 - 5 then
			p1.updateBottomGradientVisibleBinding(true)

			return
		end

		p1.updateBottomGradientVisibleBinding(false)
	end
end
function v12.createBulletList(p5) -- line: 89
	-- upvalues: Roact (copy), BulletListEntry (copy)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = p5.onContentSizeChanged
		})
	}

	for v21, v22 in p5.props.items do
		local firstEntryPositionChanged = nil

		if v21 == 1 then
			firstEntryPositionChanged = p5.firstEntryPositionChanged
		elseif v21 == #p5.props.items then
			firstEntryPositionChanged = p5.lastEntryPositionChanged
		end

		t1[v21] = Roact.createElement(BulletListEntry, {
			text = v22,
			layoutOrder = v21,
			positionChangedCallback = firstEntryPositionChanged
		})
	end

	return t1
end
function v12.renderWithProviders(p6, p7) -- line: 120
	-- upvalues: Roact (copy), Focusable (copy), VerticalScrollViewWithMargin (copy)
	local Theme = p7.Theme
	local v27 = p6:createBulletList()
	local v28 = math.min(p6.state.canvasSizeY, p6.props.maxHeight)
	local forwardRef = p6.props.forwardRef

	return Roact.createElement(Focusable.Frame, {
		defaultChild = p6.scrollViewRef,
		restorePreviousChildFocus = true,
		Size = UDim2.new(1, 0, 0, v28),
		BackgroundTransparency = 1,
		[Roact.Ref] = forwardRef
	}, {
		TopGradient = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			Visible = p6.topGradientVisibleBinding,
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ScrollView = Roact.createElement(VerticalScrollViewWithMargin, {
			size = UDim2.fromScale(1, 1),
			canvasSizeY = UDim.new(0, p6.state.canvasSizeY),
			isGamepadFocusable = true,
			[Roact.Ref] = p6.scrollViewRef
		}, v27),
		BottomGradient = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			Visible = p6.bottomGradientVisibleBinding,
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		})
	})
end
function v12.render(p8) -- line: 185
	-- upvalues: withStyle (copy)
	return withStyle(function(p9) -- line: 186
		-- upvalues: p8 (copy)
		return p8:renderWithProviders(p9)
	end)
end
function v12.didMount(p10) -- line: 191
	p10.checkIsScrollable()
end
function v12.didUpdate(p11, p12, p13) -- line: 195
	local v35 = p11.props.maxHeight ~= p12.maxHeight
	local v36 = p11.state.canvasSizeY ~= p13.canvasSizeY

	if v35 or v36 then
		p11.checkIsScrollable()
	end
end

return Roact.forwardRef(function(p14, p15) -- line: 204
	-- upvalues: Roact (copy), v12 (copy), Cryo (copy)
	return Roact.createElement(v12, Cryo.Dictionary.join(p14, {
		forwardRef = p15
	}))
end)
