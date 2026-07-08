local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local withStyle = UIBlox.Style.withStyle
local EmptyState = UIBlox.App.Indicator.EmptyState
local ListSection = require(script.ListSection)
local ParentParent = script.Parent.Parent
local GetAssetsDifference = require(ParentParent.GetAssetsDifference)
local AddAnalyticsInfo = require(ParentParent.Actions.AddAnalyticsInfo)

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v17 = Roact.PureComponent:extend("ItemsList")

v17.validateProps = t.strictInterface({
	humanoidDescription = t.optional(t.instanceOf("HumanoidDescription")),
	loadingFailed = t.boolean,
	retryLoadDescription = t.callback,
	itemListScrollableUpdated = t.optional(t.callback),
	addAnalyticsInfo = t.callback
})

function v17.init(p1) -- line: 42
	-- upvalues: Roact (copy), GetAssetsDifference (copy)
	p1:setState({
		canvasSizeY = 0,
		loading = true,
		addedAssetNames = nil,
		removedAssetNames = nil
	})
	p1.mounted = false
	p1.frameRef = Roact.createRef()

	local v20, v21 = Roact.createBinding(false)

	p1.topGradientVisibleBinding = v20
	p1.updateTopGradientVisibleBinding = v21

	local v22, v23 = Roact.createBinding(false)

	p1.bottomGradientVisibleBinding = v22
	p1.updateBottomGradientVisibleBinding = v23
	p1.addedSectionRef = Roact.createRef()
	p1.removedSectionRef = Roact.createRef()
	p1.noChangedAssetsRef = Roact.createRef()
	p1.lastWasScrollable = nil

	function p1.checkIsScrollable() -- line: 61
		-- upvalues: p1 (copy)
		local v39 = p1.frameRef:getValue()

		if not v39 then
			return
		end

		if not p1.props.itemListScrollableUpdated then
			return
		end

		local v40 = p1.state.canvasSizeY > v39.AbsoluteSize.Y

		if v40 ~= p1.lastWasScrollable then
			p1.lastWasScrollable = v40
			p1.props.itemListScrollableUpdated(v40, v39.AbsoluteSize.Y)
		end
	end
	function p1.onContentSizeChanged(p2) -- line: 79
		-- upvalues: p1 (copy)
		p1:setState({
			canvasSizeY = p2.AbsoluteContentSize.Y
		})
	end
	function p1.firstEntryPositionChanged(p3) -- line: 85
		-- upvalues: p1 (copy)
		local v43 = p1.frameRef:getValue()

		if not v43 then
			return
		end

		if p3.AbsolutePosition.Y < v43.AbsolutePosition.Y then
			p1.updateTopGradientVisibleBinding(true)

			return
		end

		p1.updateTopGradientVisibleBinding(false)
	end
	function p1.lastEntryPositionChanged(p4) -- line: 98
		-- upvalues: p1 (copy)
		local v45 = p1.frameRef:getValue()

		if not v45 then
			return
		end

		if p4.AbsolutePosition.Y + p4.AbsoluteSize.Y > v45.AbsolutePosition.Y + v45.AbsoluteSize.Y then
			p1.updateBottomGradientVisibleBinding(true)

			return
		end

		p1.updateBottomGradientVisibleBinding(false)
	end
	function p1.loadAssetNames() -- line: 113
		-- upvalues: GetAssetsDifference (copy), p1 (copy)
		coroutine.wrap(function() -- line: 114
			-- upvalues: GetAssetsDifference (copy), p1 (copy)
			GetAssetsDifference(p1.props.humanoidDescription):andThen(function(p5) -- line: 115
				-- upvalues: p1 (copy)
				if p1.mounted then
					p1.props.addAnalyticsInfo(p5.addedAssetIds, p5.removedAssetIds)
					p1:setState({
						loading = false,
						addedAssetNames = p5.addedNames,
						removedAssetNames = p5.removedNames
					})
				end
			end, function(_) -- line: 125
				-- upvalues: p1 (copy)
				if p1.mounted then
					p1:setState({
						loading = false
					})
				end
			end)
		end)()
	end
	function p1.onRetryLoading() -- line: 135
		-- upvalues: p1 (copy)
		p1:setState({
			loading = true
		})

		if p1.props.humanoidDescription then
			p1.loadAssetNames()

			return
		end

		p1.props.retryLoadDescription()
	end
end
function v17.createEntriesList(p7) -- line: 148
	-- upvalues: RobloxTranslator (copy), Roact (copy), RoactGamepad (copy), ListSection (copy)
	local t1 = {}

	if #p7.state.addedAssetNames > 0 then
		local v26 = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.Adding")

		table.insert(t1, Roact.createElement(RoactGamepad.Focusable[ListSection], {
			headerText = v26,
			items = p7.state.addedAssetNames,
			layoutOrder = 1,
			isFirstSection = true,
			isLastSection = #p7.state.removedAssetNames == 0,
			NextSelectionDown = p7.removedSectionRef,
			[Roact.Ref] = p7.addedSectionRef
		}))

		if #p7.state.removedAssetNames > 0 then
			table.insert(t1, Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 20)
			}))
		end
	end

	if #p7.state.removedAssetNames > 0 then
		local v27 = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.Removing")

		table.insert(t1, Roact.createElement(RoactGamepad.Focusable[ListSection], {
			headerText = v27,
			items = p7.state.removedAssetNames,
			layoutOrder = 3,
			isFirstSection = #p7.state.addedAssetNames == 0,
			isLastSection = true,
			NextSelectionUp = p7.addedSectionRef,
			[Roact.Ref] = p7.removedSectionRef
		}))
	end

	if #p7.state.addedAssetNames == 0 and #p7.state.removedAssetNames == 0 then
		local v28 = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.NoChangedAssets")

		table.insert(t1, Roact.createElement(RoactGamepad.Focusable[ListSection], {
			headerText = v28,
			items = {},
			layoutOrder = 1,
			isFirstSection = true,
			isLastSection = true,
			[Roact.Ref] = p7.noChangedAssetsRef
		}))
	end

	return t1
end
function v17.renderItemsList(p8) -- line: 217
	-- upvalues: withStyle (copy), Roact (copy), RoactGamepad (copy), VerticalScrollViewWithMargin (copy)
	return withStyle(function(p9) -- line: 218
		-- upvalues: p8 (copy), Roact (copy), RoactGamepad (copy), VerticalScrollViewWithMargin (copy)
		local Theme = p9.Theme
		local v48 = p8:createEntriesList()

		v48.Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = p8.onContentSizeChanged
		})

		return Roact.createElement(RoactGamepad.Focusable.Frame, {
			defaultChild = p8.addedSectionRef,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[Roact.Ref] = p8.frameRef
		}, {
			TopGradient = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				Visible = p8.topGradientVisibleBinding,
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.fromScale(0, 0),
				BackgroundColor3 = Color3.new(1, 1, 1)
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Theme.BackgroundUIDefault.Color),
						ColorSequenceKeypoint.new(1, Theme.BackgroundUIDefault.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			ScrollView = Roact.createElement(VerticalScrollViewWithMargin, {
				size = UDim2.fromScale(1, 1),
				canvasSizeY = UDim.new(0, p8.state.canvasSizeY)
			}, v48),
			BottomGradient = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				Visible = p8.bottomGradientVisibleBinding,
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.new(1, 1, 1)
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Theme.BackgroundUIDefault.Color),
						ColorSequenceKeypoint.new(1, Theme.BackgroundUIDefault.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		})
	end)
end
function v17.renderLoading(_) -- line: 294
	-- upvalues: Roact (copy), Skeleton (copy)
	return Roact.createElement(Skeleton, {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end
function v17.renderFailed(p11) -- line: 302
	-- upvalues: Roact (copy), EmptyState (copy), RobloxTranslator (copy)
	return Roact.createElement(EmptyState, {
		text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.ItemsListLoadingFailed"),
		size = UDim2.fromScale(1, 1),
		onActivated = p11.onRetryLoading
	})
end
function v17.render(p12) -- line: 310
	if p12.state.loading and not p12.props.loadingFailed then
		return p12:renderLoading()
	end

	if p12.state.addedAssetNames then
		return p12:renderItemsList()
	end

	return p12:renderFailed()
end
function v17.didMount(p13) -- line: 322
	p13.mounted = true

	if p13.props.humanoidDescription then
		p13.loadAssetNames()
	end

	p13.checkIsScrollable()
end
function v17.didUpdate(p14, p15, _) -- line: 331
	-- upvalues: Roact (copy)
	p14.checkIsScrollable()

	if p15.humanoidDescription ~= p14.props.humanoidDescription then
		p14:setState({
			loading = true,
			addedAssetNames = Roact.None,
			removedAssetNames = Roact.None
		})
		p14.loadAssetNames()
	end
end
function v17.willUnmount(p17) -- line: 345
	p17.mounted = false
end

local function mapDispatchToProps(p18) -- line: 349
	-- upvalues: AddAnalyticsInfo (copy)
	return {
		addAnalyticsInfo = function(p19) -- line: 351
			-- upvalues: p18 (copy), AddAnalyticsInfo (copy)
			return p18(AddAnalyticsInfo(p19))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v17)
