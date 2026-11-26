local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local focusable = RoactGamepad.Focusable

local verticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local withStyle = UIBlox.Style.withStyle

local ListEntry = require("@game/CoreGui/RobloxGui/Modules/AvatarEditorPrompts/Components/ItemsList/ListEntry")

local extended = Roact.PureComponent:extend("ItemsBulletList")

extended.validateProps = t.strictInterface({
	items = t.array(t.string),
	maxHeight = t.number,
	onScrollableUpdated = t.callback,
	forwardRef = t.table
})

function extended:init()
	self:setState({ canvasSizeY = 0 })

	self.scrollViewRef = Roact.createRef()

	local binding, v5 = Roact.createBinding(false)
	self.topGradientVisibleBinding = binding
	self.updateTopGradientVisibleBinding = v5
	local binding2, v6 = Roact.createBinding(false)
	self.bottomGradientVisibleBinding = binding2
	self.updateBottomGradientVisibleBinding = v6

	function self.checkIsScrollable()
		local v7 = self.state.canvasSizeY > self.props.maxHeight

		self.props.onScrollableUpdated(v7)
	end

	function self.onContentSizeChanged(p2)
		if self.state.canvasSizeY ~= p2.AbsoluteContentSize.Y then
			self:setState({ canvasSizeY = p2.AbsoluteContentSize.Y })
		end
	end

	local forwardRef = self.props.forwardRef

	function self.firstEntryPositionChanged(p2)
		local value = forwardRef:getValue()

		if not value then
			return
		end

		if p2.AbsolutePosition.Y + 5 < value.AbsolutePosition.Y then
			self.updateTopGradientVisibleBinding(true)
		else
			self.updateTopGradientVisibleBinding(false)
		end
	end

	function self.lastEntryPositionChanged(p2)
		local value = forwardRef:getValue()

		if not value then
			return
		end

		local v7 = p2.AbsolutePosition.Y + p2.AbsoluteSize.Y

		if value.AbsolutePosition.Y + value.AbsoluteSize.Y < v7 - 5 then
			self.updateBottomGradientVisibleBinding(true)
		else
			self.updateBottomGradientVisibleBinding(false)
		end
	end
end

function extended:createBulletList()
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = self.onContentSizeChanged
		})
	}

	for k, item in self.props.items do
		local v5 = nil

		if k == 1 then
			v5 = self.firstEntryPositionChanged
		elseif k == #self.props.items then
			v5 = self.lastEntryPositionChanged
		end

		children[k] = Roact.createElement(ListEntry, {
			text = item,
			layoutOrder = k,
			positionChangedCallback = v5
		})
	end

	return children
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme

	local bulletList = self:createBulletList()

	local v5 = math.min(self.state.canvasSizeY, self.props.maxHeight)

	local forwardRef = self.props.forwardRef

	return Roact.createElement(focusable.Frame, {
		defaultChild = self.scrollViewRef,
		restorePreviousChildFocus = true,
		Size = UDim2.new(1, 0, 0, v5),
		BackgroundTransparency = 1,
		[Roact.Ref] = forwardRef
	}, {
		TopGradient = Roact.createElement("Frame", {
			Visible = self.topGradientVisibleBinding,
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ScrollView = Roact.createElement(
			verticalScrollViewWithMargin,
			{
				size = UDim2.fromScale(1, 1),
				canvasSizeY = UDim.new(0, self.state.canvasSizeY),
				isGamepadFocusable = true,
				[Roact.Ref] = self.scrollViewRef
			},
			bulletList
		),
		BottomGradient = Roact.createElement("Frame", {
			Visible = self.bottomGradientVisibleBinding,
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 2
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

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended.didMount(p2)
	p2.checkIsScrollable()
end

function extended.didUpdate(data, p2, p3)
	local v5 = data.props.maxHeight ~= p2.maxHeight
	local v6 = data.state.canvasSizeY ~= p3.canvasSizeY

	if v5 or v6 then
		data.checkIsScrollable()
	end
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
