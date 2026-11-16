local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local module = require("@luauforge/deferred/gnp")
local module2 = require("@luauforge/deferred/gnq")

local module3 = require("@luauforge/deferred/gnr")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module4 = require("@luauforge/bundled/eeH")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module5 = require("@luauforge/deferred/gmf")
local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/eda")
local module7 = require("@luauforge/bundled/fox")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local compositionTags = require("@luauforge/bundled/gns").CompositionTags
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local module9 = require("@luauforge/deferred/gfb")
local module10 = require("@luauforge/deferred/gko")

local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module11 = require("@luauforge/bundled/dME")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module12 = require("@luauforge/deferred/gnt")
local module13 = require("@luauforge/deferred/gnv")

local module14 = require("@luauforge/deferred/gnw")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module15 = require("@luauforge/deferred/gmV")

local module16 = require("@luauforge/bundled/fuO")

local module17 = require("@luauforge/bundled/fuQ")
local module18 = require("@luauforge/bundled/dSs")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module19 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module19.FocusNavigationEventNameEnum

local UIBlox = require(CorePackages.Packages.UIBlox)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local withStyle = UIBlox.Style.withStyle
local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local gridMetrics = UIBlox.App.Grid.GridMetrics
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local module21 = require("@luauforge/bundled/edh")
local fFlagUpdateNoInternetConnectionText = AvatarExperienceFlags.FFlagUpdateNoInternetConnectionText
local module22 = require("@luauforge/bundled/dHu")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local module23 = require("@luauforge/deferred/gnx")
local fFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useResellersPageFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = callback and {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			} or nil
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local extended = React.PureComponent:extend("ResellersPage")

function extended:init()
	self.nextPageCursor = nil

	self.gridViewRef = React.createRef()
	self.topBarRef = React.createRef()

	function self.renderCard(p2, p3, p4)
		return withStyle(function(p5)
			local theme = p5.Theme

			return React.createElement(fitFrameVertical, {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				BackgroundTransparency = 1,
				LayoutOrder = p4
			}, {
				AssetResellerCard = React.createElement(module12, {
					LayoutOrder = 1,
					itemId = self.props.itemId,
					itemType = self.props.itemType,
					productId = self.props.productId,
					userAssetId = p2,
					horizontalPadding = 24
				}),
				Divider = React.createElement("Frame", {
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, -24, 0, 1)
				})
			})
		end)
	end

	function self.renderCollectibleCard(p2, p3, p4)
		local collectibleItemId = self.props.collectibleItemId
		return withStyle(function(p5)
			local theme = p5.Theme

			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = p4,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0)
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 8)
					}),
					CollectibleResellerCard = React.createElement(module13, {
						LayoutOrder = 1,
						itemId = self.props.itemId,
						collectibleItemId = collectibleItemId,
						collectibleInstanceId = p2,
						itemType = self.props.itemType,
						horizontalPadding = 24
					}),
					Divider = React.createElement("Frame", {
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 1)
					})
				}
			)
		end)
	end

	function self.renderLoadMoreButton(p2, onActivated)
		return withLocalization({ loadMore = "Feature.Catalog.Action.LoadMore" })(function(p3)
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = p2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0)
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 8),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					LoadMoreButton = React.createElement(button, {
						onActivated = onActivated,
						text = p3.loadMore,
						standardSize = standardButtonSize.Regular,
						buttonType = buttonType.Secondary
					})
				}
			)
		end)
	end

	function self.makeRenderItem(p2)
		return function(p3, p4, p5)
			if p3 == module11.FinalRowRenderLoadMoreButton then
				return self.renderLoadMoreButton(p5, p2)
			end

			if self.props.collectibleResellersInstancesIds then
				return self.renderCollectibleCard(p3, nil, p5)
			end

			return self.renderCard(p3, nil, p5)
		end
	end

	function self.goBack()
		local navigation = self.props.navigation
		self.props.closeFocusedScreen(navigation)
	end
end

function extended.didMount(object)
	object.props.fetchInitialItems()

	local lastInputType = UserInputService:GetLastInputType()

	if lastInputType then
		object:setState({ lastInputType = lastInputType })
	end
end

function extended.willUpdate(p2, p3, p4)
	local v5 = p2.props.purchaseFetchingState == retrievalStatus.Fetching
	local v6 = p3.purchaseFetchingState == retrievalStatus.Done
		or p3.purchaseFetchingState == retrievalStatus.Failed

	if v5 and v6 then
		p2.props.fetchInitialItems()
	end
end

function extended.willUnmount(p2)
	p2.props.clearResellerCursor()
end

function extended:renderOnLoaded()
	return React.createElement(module7.PageContent, {}, {
		Content = self:renderContent()
	})
end

function extended.renderContent(data)
	local screenSize = data.props.screenSize
	local globalGuiInset = data.props.globalGuiInset
	local resellerUserAssetIds = data.props.resellerUserAssetIds
	local hasMoreRows = data.props.hasMoreRows
	local enableContinuousLoad = data.props.enableContinuousLoad

	local collectibleResellersInstancesIds = data.props.collectibleResellersInstancesIds

	if not (resellerUserAssetIds or collectibleResellersInstancesIds) then
		return
	end

	local safeAreaSize = getSafeAreaSize(screenSize, globalGuiInset)

	local v5 = { minimumItemsPerRow = 1, minimumItemWidth = safeAreaSize.X.Offset }

	local joined = collectibleResellersInstancesIds or resellerUserAssetIds

	local v6 = hasMoreRows and #joined == 0
	local isFetchingMore = data.props.isFetchingMore or v6
	local v7 = not isFetchingMore and hasMoreRows
	local loadMoreItems = if v7 and enableContinuousLoad then data.props.loadMoreItems else nil

	if v7 and not enableContinuousLoad then
		joined = Cryo.List.join(joined, { module11.FinalRowRenderLoadMoreButton })
	end

	return withStyle(function(p2)
		local createElement = React.createElement
		local v9 = {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			refresh = data.props.fetchInitialItems,
			createEndOfScrollElement = not hasMoreRows,
			scrollPerformanceIntervalName = 0,
			onThresholdReached = 0
		}

		local v10 = if fFlagAXScrollTelemetryIntegration2 then module2.Resellers else nil
		v9.scrollPerformanceIntervalName = v10

		v9.onThresholdReached = loadMoreItems

		local createElement2 = React.createElement

		local v13 = if module23 then data.props.pagePaddingTop else UDim.new(0, 24)
		local children = {
			UIPadding = createElement2("UIPadding", { PaddingTop = v13 }),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ResellerGridView = React.createElement(focusable[defaultMetricsGridView], {
				renderItem = data.makeRenderItem(data.props.loadMoreItems),
				windowHeight = safeAreaSize.Y.Offset,
				getItemHeight = function(p3): number
					return 100
				end,
				getItemMetrics = gridMetrics.makeCustomMetricsGetter(v5),
				itemPadding = Vector2.new(0, 12),
				items = joined,
				maxHeight = 1e999,
				LayoutOrder = 1,
				defaultChildIndex = 1,
				ref = data.gridViewRef,
				NextSelectionUp = data.topBarRef
			}),
			LoadingBar = 0
		}

		local v14 = if isFetchingMore then React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, p2.Tokens.Size.Size_1400),
				LayoutOrder = 2
			},
			{ LoadingBar = React.createElement(module21) }
		) else nil
		children.LoadingBar = v14
		return createElement(module14, v9, children)
	end)
end

function extended.renderOnFailed(p2, p3)
	return React.createElement(emptyState, {
		onActivated = p2.props.fetchInitialItems,
		text = p3.failedMessage
	})
end

function extended:render()
	return React.createElement(module5, { forwardRef = self.props.focusNavigationRef }, {
		Content = self:renderContents()
	})
end

function extended:renderContents()
	local globalGuiInset = self.props.globalGuiInset
	local v5 = self.props.fetchingStatus

	local v6 = self.props.resellerUserAssetIds and not Cryo.isEmpty(self.props.resellerUserAssetIds)
		or self.props.collectibleResellersInstancesIds
		and not Cryo.isEmpty(self.props.collectibleResellersInstancesIds)

	if v5 == retrievalStatus.Fetching and v6 then
		v5 = retrievalStatus.Done
	end

	return withStyle(function(p2)
		return withLocalization({
			title = "Feature.Catalog.Heading.Sellers",
			failedMessage = fFlagUpdateNoInternetConnectionText and "Feature.DisplayName.ErrorMessage.SomethingWentWrong" or "Feature.EmptyStatePage.Message.NoInternet"
		})(function(p3)
			local theme = p2.Theme
			return React.createElement(focusable.Frame, {
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(0, 0, 0, globalGuiInset.top),
				Active = true
			}, {
				TopBar = React.createElement(module7.Container, {
					ZIndex = 2,
					tag = compositionTags.ContentRegion.Header,
					sideMarginOverride = 0,
					titleText = p3.title,
					ref = self.topBarRef,
					NextSelectionDown = v5 == retrievalStatus.Done and self.gridViewRef or nil,
					leftItem = module7.BackButton
				}),
				LastInputTypeChangedConnection = React.createElement(externalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = function(p4)
						if p4 then
							self:setState({ lastInputType = p4 })
						end
					end
				}),
				LoadingStateContainer = React.createElement(loadingStateContainer, {
					dataStatus = retrievalStatus2.fromRawValue(v5),
					renderOnLoaded = function()
						return self:renderOnLoaded()
					end,
					renderOnFailed = function()
						return self:renderOnFailed(p3)
					end
				})
			})
		end)
	end)
end

local v5 = RoactRodux.connect(function(data, data2)
	local itemId = data2.itemId
	local itemType = data2.itemType

	local v6 = itemData(data.AvatarExperience.Common, itemId, itemType)
	local id = v6 and v6.product and v6.product.id
	local resellerUserAssetIds = v6 and v6.resellerUserAssetIds

	local collectibleItemId = data2.collectibleItemId
	local instanceIdsList

	if collectibleItemId ~= nil then
		local collectiblesResellersInstances = data.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances

		instanceIdsList = collectiblesResellersInstances
			and collectiblesResellersInstances[collectibleItemId]
			and collectiblesResellersInstances[collectibleItemId].InstanceIdsList
	end

	return {
		globalGuiInset = data.GlobalGuiInset,
		hasMoreRows = data.AvatarExperience.Catalog.ResellerCursor.hasMoreRows,
		fetchingStatus = performFetch.GetStatus(
			data,
			module11.GetResellersKey .. tostring(collectibleItemId or itemId)
		),
		productId = id,
		purchaseFetchingState = performFetch.GetStatus(data, module11.PurchaseProductKey .. tostring(id)),
		resellerCursor = data.AvatarExperience.Catalog.ResellerCursor.nextPageCursor,
		resellerUserAssetIds = resellerUserAssetIds,
		screenSize = data.ScreenSize,
		collectibleResellersInstancesIds = instanceIdsList
	}
end, function(callback)
	return {
		clearResellerCursor = function()
			return callback(module18(nil))
		end,
		closeFocusedScreen = function(p2)
			callback(module10(p2))
		end
	}
end)(extended)

local v6 = roactServices.connect({ networking = module6 })(v5)

local v7 = module9((module15((roactAppPolicy.connect(function(p2, p3)
	return { enableContinuousLoad = p2.getEnableContinuousLoad() }
end)(v6)))))

return function(p2)
	local v8 = useDispatch()
	local v9 = module4(module6)
	local v10 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.ResellerCursor.nextPageCursor
	end)

	local collectibleItemId = p2.navigation.state.params.collectibleItemId
	local itemId = p2.navigation.state.params.itemId

	local v11 = React.useCallback(function()
		if collectibleItemId then
			return v8(module17(v9, collectibleItemId, v10, module11.MaxResellersPerPage))
		end

		return v8(module16(v9, itemId, v10, module11.MaxResellersPerPage, false))
	end, { collectibleItemId, v10, itemId })

	local v12 = React.useCallback(function()
		if collectibleItemId then
			return v8(module17(v9, collectibleItemId, nil, module11.MaxResellersPerPage))
		end

		return v8(module16(v9, itemId, nil, module11.MaxResellersPerPage, true))
	end, { collectibleItemId, itemId })

	local v13, v14 = module3(v11)
	local v15, v16 = module3(v12)
	local v17 = v13.status == module.Pending or v15.status == module.Pending

	local v18 = useResellersPageFocusNavigationBindings(nil, React.useCallback(function()
		v8(module10(p2.navigation))
	end, { p2.navigation, v8 }))
	local udim

	if module23 then
		local v19 = useSelector(module7.selectTopBarHeight)

		if fFlagAppIaScrollAway and module22.getScrollAwayEnabled() then
			udim = UDim.new(0, 24 + v19)
		else
			udim = UDim.new(0, 24)
		end
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not module23 then
		udim = nil
	end

	return createElement(v7, join(p2, {
		loadMoreItems = v14,
		fetchInitialItems = v16,
		isFetchingMore = v17,
		focusNavigationRef = v18,
		pagePaddingTop = udim
	}))
end
