local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton

local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local withStyle = UIBlox.Style.withStyle
local EmptyState = UIBlox.App.Indicator.EmptyState

local ListSection = require(script.ListSection)

local parent = script.Parent.Parent
local GetAssetsDifference = require(parent.GetAssetsDifference)
local AddAnalyticsInfo = require(parent.Actions.AddAnalyticsInfo)

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local extended = Roact.PureComponent:extend("ItemsList")

extended.validateProps = t.strictInterface({
	humanoidDescription = t.optional(t.instanceOf("HumanoidDescription")),
	loadingFailed = t.boolean,
	retryLoadDescription = t.callback,
	itemListScrollableUpdated = t.optional(t.callback),
	addAnalyticsInfo = t.callback
})

function extended:init()
	self:setState({
		canvasSizeY = 0,
		loading = true,
		addedAssetNames = nil,
		removedAssetNames = nil
	})

	self.mounted = false

	self.frameRef = Roact.createRef()
	local binding, updateTopGradientVisibleBinding = Roact.createBinding(false)
	self.topGradientVisibleBinding = binding
	self.updateTopGradientVisibleBinding = updateTopGradientVisibleBinding
	local binding2, updateBottomGradientVisibleBinding = Roact.createBinding(false)
	self.bottomGradientVisibleBinding = binding2
	self.updateBottomGradientVisibleBinding = updateBottomGradientVisibleBinding

	self.addedSectionRef = Roact.createRef()
	self.removedSectionRef = Roact.createRef()
	self.noChangedAssetsRef = Roact.createRef()

	self.lastWasScrollable = nil
	function self.checkIsScrollable()
		local value = self.frameRef:getValue()

		if not (value and self.props.itemListScrollableUpdated) then
			return
		end

		local lastWasScrollable = self.state.canvasSizeY > value.AbsoluteSize.Y

		if lastWasScrollable ~= self.lastWasScrollable then
			self.lastWasScrollable = lastWasScrollable
			self.props.itemListScrollableUpdated(lastWasScrollable, value.AbsoluteSize.Y)
		end
	end

	function self.onContentSizeChanged(p)
		self:setState({ canvasSizeY = p.AbsoluteContentSize.Y })
	end

	function self.firstEntryPositionChanged(p)
		local value = self.frameRef:getValue()

		if not value then
			return
		end

		if p.AbsolutePosition.Y < value.AbsolutePosition.Y then
			self.updateTopGradientVisibleBinding(true)
		else
			self.updateTopGradientVisibleBinding(false)
		end
	end

	function self.lastEntryPositionChanged(p)
		local value = self.frameRef:getValue()

		if not value then
			return
		end

		if p.AbsolutePosition.Y + p.AbsoluteSize.Y > value.AbsolutePosition.Y + value.AbsoluteSize.Y then
			self.updateBottomGradientVisibleBinding(true)
		else
			self.updateBottomGradientVisibleBinding(false)
		end
	end

	function self.loadAssetNames()
		coroutine.wrap(function()
			GetAssetsDifference(self.props.humanoidDescription):andThen(function(data)
				if self.mounted then
					self.props.addAnalyticsInfo(data.addedAssetIds, data.removedAssetIds)

					self:setState({
						loading = false,
						addedAssetNames = data.addedNames,
						removedAssetNames = data.removedNames
					})
				end
			end, function(_)
				if self.mounted then
					self:setState({ loading = false })
				end
			end)
		end)()
	end

	function self.onRetryLoading()
		self:setState({ loading = true })

		if self.props.humanoidDescription then
			self.loadAssetNames()
		else
			self.props.retryLoadDescription()
		end
	end
end

function extended:createEntriesList()
	local entriesList = {}

	if #self.state.addedAssetNames > 0 then
		local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.Adding")

		local createElement = Roact.createElement
		local v = RoactGamepad.Focusable[ListSection]
		local addedSectionRefsByRef = {
			headerText = formatByKey,
			items = self.state.addedAssetNames,
			layoutOrder = 1,
			isFirstSection = true,
			isLastSection = #self.state.removedAssetNames == 0,
			NextSelectionDown = self.removedSectionRef,
			[Roact.Ref] = self.addedSectionRef
		}
		table.insert(entriesList, createElement(v, addedSectionRefsByRef))

		if #self.state.removedAssetNames > 0 then
			table.insert(
				entriesList,
				Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 20),
					LayoutOrder = 2
				})
			)
		end
	end

	if #self.state.removedAssetNames > 0 then
		local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.Removing")

		local createElement = Roact.createElement
		local v = RoactGamepad.Focusable[ListSection]
		local removedSectionRefsByRef = {
			headerText = formatByKey,
			items = self.state.removedAssetNames,
			layoutOrder = 3,
			isFirstSection = #self.state.addedAssetNames == 0,
			isLastSection = true,
			NextSelectionUp = self.addedSectionRef,
			[Roact.Ref] = self.removedSectionRef
		}
		table.insert(entriesList, createElement(v, removedSectionRefsByRef))
	end

	local v

	if #self.state.addedAssetNames == 0 then
		v = #self.state.removedAssetNames == 0
	else
		v = false
	end

	if not v then
		return entriesList
	end

	local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.NoChangedAssets")

	local createElement = Roact.createElement
	local v2 = RoactGamepad.Focusable[ListSection]
	local noChangedAssetsRefsByRef = {
		headerText = formatByKey,
		items = {},
		layoutOrder = 1,
		isFirstSection = true,
		isLastSection = true,
		[Roact.Ref] = self.noChangedAssetsRef
	}
	table.insert(entriesList, createElement(v2, noChangedAssetsRefsByRef))

	return entriesList
end

function extended:renderItemsList()
	return withStyle(function(p)
		local theme = p.Theme

		local entriesList = self:createEntriesList()
		entriesList.Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = self.onContentSizeChanged
		})

		return Roact.createElement(
			RoactGamepad.Focusable.Frame,
			{
				defaultChild = self.addedSectionRef,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[Roact.Ref] = self.frameRef
			},
			{
				TopGradient = Roact.createElement("Frame", {
					Visible = self.topGradientVisibleBinding,
					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.fromScale(0, 0),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					UIGradient = Roact.createElement("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, theme.BackgroundUIDefault.Color),
							ColorSequenceKeypoint.new(1, theme.BackgroundUIDefault.Color)
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1)
						})
					})
				}),
				ScrollView = Roact.createElement(
					VerticalScrollViewWithMargin,
					{
						size = UDim2.fromScale(1, 1),
						canvasSizeY = UDim.new(0, self.state.canvasSizeY)
					},
					entriesList
				),
				BottomGradient = Roact.createElement("Frame", {
					Visible = self.bottomGradientVisibleBinding,
					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					UIGradient = Roact.createElement("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, theme.BackgroundUIDefault.Color),
							ColorSequenceKeypoint.new(1, theme.BackgroundUIDefault.Color)
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(1, 0)
						})
					})
				})
			}
		)
	end)
end

function extended:renderLoading()
	return Roact.createElement(Skeleton, {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

function extended:renderFailed()
	return Roact.createElement(EmptyState, {
		text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.ItemsListLoadingFailed"),
		size = UDim2.fromScale(1, 1),
		onActivated = self.onRetryLoading
	})
end

function extended:render()
	if self.state.loading and not self.props.loadingFailed then
		return self:renderLoading()
	end

	if self.state.addedAssetNames then
		return self:renderItemsList()
	end

	return self:renderFailed()
end

function extended:didMount()
	self.mounted = true

	if self.props.humanoidDescription then
		self.loadAssetNames()
	end

	self.checkIsScrollable()
end

function extended.didUpdate(object, p, _)
	object.checkIsScrollable()

	if p.humanoidDescription ~= object.props.humanoidDescription then
		object:setState({
			loading = true,
			addedAssetNames = Roact.None,
			removedAssetNames = Roact.None
		})

		object.loadAssetNames()
	end
end

function extended:willUnmount()
	self.mounted = false
end

local function mapDispatchToProps(callback)
	return {
		addAnalyticsInfo = function(p)
			return callback(AddAnalyticsInfo(p))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
