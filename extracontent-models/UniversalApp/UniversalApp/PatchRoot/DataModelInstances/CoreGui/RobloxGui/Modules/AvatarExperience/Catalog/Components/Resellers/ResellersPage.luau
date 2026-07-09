local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local useRequest = require(Modules.AvatarExperience.Common.Hooks.useRequest)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local CenteredModalView = require(Modules.AvatarExperience.Common.Components.CenteredModalView)
local FitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateResellersInputBindingsToRoactGamepad = AvatarExperienceFlags.FFlagAXMigrateResellersInputBindingsToRoactGamepad
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local CloseFocusedScreen = require(Modules.AvatarExperience.Common.Thunks.CloseFocusedScreen)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AssetResellerCard = require(Modules.AvatarExperience.Catalog.Components.Resellers.AssetResellerCard)
local CollectibleResellerCard = require(Modules.AvatarExperience.Catalog.Components.Resellers.CollectibleResellerCard)
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local FetchAssetResellers = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetResellers)
local FetchCollectibResellersInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibResellersInstances)
local SetResellerCursor = require(Modules.AvatarExperience.Catalog.Actions.SetResellerCursor)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local UIBlox = require(CorePackages.Packages.UIBlox)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local GridMetrics = UIBlox.App.Grid.GridMetrics
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local FFlagUpdateNoInternetConnectionText = AvatarExperienceFlags.FFlagUpdateNoInternetConnectionText
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAXFixScrollAwayTopBarOverlap = require(Modules.AvatarExperience.Flags.FFlagAXFixScrollAwayTopBarOverlap)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useResellersPageFocusNavigationBindings(p1, p2: ((...any) -> ...any)?) -- line: 98
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v68 = ReactFocusNavigation.useEventMap(t1, p1)
	local v69 = React.useMemo(function() -- line: 100
		-- upvalues: FocusNavigationEventNameEnum (copy), p2 (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = if not p2 then nil else {
				handler = InputHandlers.onRelease(function(p3) -- line: 104
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v69, v68)
end

local v62 = React.PureComponent:extend("ResellersPage")

function v62.init(p4) -- line: 117
	-- upvalues: React (copy), withStyle (copy), FitFrameVertical (copy), AssetResellerCard (copy), CollectibleResellerCard (copy), withLocalization (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy), CatalogConstants (copy)
	p4.nextPageCursor = nil
	p4.gridViewRef = React.createRef()
	p4.topBarRef = React.createRef()

	function p4.renderCard(p5, _, p7) -- line: 123
		-- upvalues: withStyle (copy), React (copy), FitFrameVertical (copy), AssetResellerCard (copy), p4 (copy)
		return withStyle(function(p8) -- line: 124
			-- upvalues: React (copy), FitFrameVertical (copy), p7 (copy), AssetResellerCard (copy), p4 (copy), p5 (copy)
			local Theme = p8.Theme

			return React.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				LayoutOrder = p7
			}, {
				AssetResellerCard = React.createElement(AssetResellerCard, {
					LayoutOrder = 1,
					horizontalPadding = 24,
					itemId = p4.props.itemId,
					itemType = p4.props.itemType,
					productId = p4.props.productId,
					userAssetId = p5
				}),
				Divider = React.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 2,
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency,
					Size = UDim2.new(1, -24, 0, 1)
				})
			})
		end)
	end
	function p4.renderCollectibleCard(p9, _, p11) -- line: 156
		-- upvalues: p4 (copy), withStyle (copy), React (copy), CollectibleResellerCard (copy)
		local collectibleItemId = p4.props.collectibleItemId

		return withStyle(function(p12) -- line: 158
			-- upvalues: React (copy), p11 (copy), CollectibleResellerCard (copy), p4 (copy), collectibleItemId (copy), p9 (copy)
			local Theme = p12.Theme

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p11,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8)
				}),
				CollectibleResellerCard = React.createElement(CollectibleResellerCard, {
					LayoutOrder = 1,
					horizontalPadding = 24,
					itemId = p4.props.itemId,
					collectibleItemId = collectibleItemId,
					collectibleInstanceId = p9,
					itemType = p4.props.itemType
				}),
				Divider = React.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 2,
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				})
			})
		end)
	end
	function p4.renderLoadMoreButton(p13, p14) -- line: 192
		-- upvalues: withLocalization (copy), React (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy)
		return withLocalization({
			loadMore = "Feature.Catalog.Action.LoadMore"
		})(function(p15) -- line: 195
			-- upvalues: React (copy), p13 (copy), Button (copy), p14 (copy), StandardButtonSize (copy), ButtonType (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p13,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				LoadMoreButton = React.createElement(Button, {
					onActivated = p14,
					text = p15.loadMore,
					standardSize = StandardButtonSize.Regular,
					buttonType = ButtonType.Secondary
				})
			})
		end)
	end
	function p4.makeRenderItem(p16) -- line: 217
		-- upvalues: CatalogConstants (copy), p4 (copy)
		return function(p17, _, p19) -- line: 218
			-- upvalues: CatalogConstants (copy), p4 (copy), p16 (copy)
			if p17 == CatalogConstants.FinalRowRenderLoadMoreButton then
				return p4.renderLoadMoreButton(p19, p16)
			end

			if p4.props.collectibleResellersInstancesIds then
				return p4.renderCollectibleCard(p17, nil, p19)
			end

			return p4.renderCard(p17, nil, p19)
		end
	end
	function p4.goBack() -- line: 232
		-- upvalues: p4 (copy)
		local navigation = p4.props.navigation

		p4.props.closeFocusedScreen(navigation)
	end
end
function v62.didMount(p20) -- line: 239
	-- upvalues: UserInputService (copy)
	p20.props.fetchInitialItems()

	local LastInputType = UserInputService:GetLastInputType()

	if LastInputType then
		p20:setState({
			lastInputType = LastInputType
		})
	end
end
function v62.willUpdate(p21, p22, _) -- line: 250
	-- upvalues: RetrievalStatus (copy)
	local v76 = p21.props.purchaseFetchingState == RetrievalStatus.Fetching
	local v77 = p22.purchaseFetchingState == RetrievalStatus.Done or p22.purchaseFetchingState == RetrievalStatus.Failed

	if v76 and v77 then
		p21.props.fetchInitialItems()
	end
end
function v62.willUnmount(p24) -- line: 261
	p24.props.clearResellerCursor()
end
function v62.renderOnLoaded(p25) -- line: 265
	-- upvalues: React (copy), TopBar (copy)
	return React.createElement(TopBar.PageContent, {}, {
		Content = p25:renderContent()
	})
end
function v62.renderContent(p26) -- line: 271
	-- upvalues: getSafeAreaSize (copy), Cryo (copy), CatalogConstants (copy), withStyle (copy), React (copy), AXRefreshScrollingFrameWithLoadMore (copy), FFlagAXFixScrollAwayTopBarOverlap (copy), Focusable (copy), DefaultMetricsGridView (copy), GridMetrics (copy), FFlagAXMigrateResellersInputBindingsToRoactGamepad (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), LoadingBarWithTheme (copy)
	local screenSize = p26.props.screenSize
	local globalGuiInset = p26.props.globalGuiInset
	local resellerUserAssetIds = p26.props.resellerUserAssetIds
	local hasMoreRows = p26.props.hasMoreRows
	local enableContinuousLoad = p26.props.enableContinuousLoad
	local collectibleResellersInstancesIds = p26.props.collectibleResellersInstancesIds

	if not resellerUserAssetIds and not collectibleResellersInstancesIds then
		return
	end

	local v87 = getSafeAreaSize(screenSize, globalGuiInset)
	local t2 = {
		minimumItemsPerRow = 1,
		minimumItemWidth = v87.X.Offset
	}
	local u89 = collectibleResellersInstancesIds or resellerUserAssetIds
	local v90 = hasMoreRows and #u89 == 0
	local v91 = p26.props.isFetchingMore or v90
	local v92 = not v91 and hasMoreRows
	local v93 = if not v92 or not enableContinuousLoad then nil else p26.props.loadMoreItems

	if v92 and not enableContinuousLoad then
		u89 = Cryo.List.join(u89, { CatalogConstants.FinalRowRenderLoadMoreButton })
	end

	return withStyle(function(p27) -- line: 302
		-- upvalues: React (copy), AXRefreshScrollingFrameWithLoadMore (copy), p26 (copy), hasMoreRows (copy), v93 (copy), FFlagAXFixScrollAwayTopBarOverlap (copy), Focusable (copy), DefaultMetricsGridView (copy), v87 (copy), GridMetrics (copy), t2 (copy), u89 (ref), FFlagAXMigrateResellersInputBindingsToRoactGamepad (copy), RoactGamepad (copy), v91 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), LoadingBarWithTheme (copy)
		return React.createElement(AXRefreshScrollingFrameWithLoadMore, {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			refresh = p26.props.fetchInitialItems,
			createEndOfScrollElement = not hasMoreRows,
			onThresholdReached = v93
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = if not FFlagAXFixScrollAwayTopBarOverlap then UDim.new(0, 24) else p26.props.pagePaddingTop
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ResellerGridView = React.createElement(Focusable[DefaultMetricsGridView], {
				maxHeight = 1e999,
				LayoutOrder = 1,
				defaultChildIndex = 1,
				renderItem = p26.makeRenderItem(p26.props.loadMoreItems),
				windowHeight = v87.Y.Offset,
				getItemHeight = function(_) -- line: 328
					return 100
				end,
				getItemMetrics = GridMetrics.makeCustomMetricsGetter(t2),
				itemPadding = Vector2.new(0, 12),
				items = u89,
				inputBindings = if not FFlagAXMigrateResellersInputBindingsToRoactGamepad then {
					NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p26.goBack)
				} else nil,
				ref = p26.gridViewRef,
				NextSelectionUp = p26.topBarRef
			}),
			LoadingBar = if not v91 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then p27.Tokens.Global.Size_700 else p27.Tokens.Size.Size_1400)
			}, {
				LoadingBar = React.createElement(LoadingBarWithTheme)
			})
		})
	end)
end
function v62.renderOnFailed(p29, p30) -- line: 369
	-- upvalues: React (copy), EmptyState (copy)
	return React.createElement(EmptyState, {
		onActivated = p29.props.fetchInitialItems,
		text = p30.failedMessage
	})
end
function v62.render(p31) -- line: 376
	-- upvalues: React (copy), CenteredModalView (copy), FFlagAXMigrateResellersInputBindingsToRoactGamepad (copy)
	return React.createElement(CenteredModalView, {
		forwardRef = if not FFlagAXMigrateResellersInputBindingsToRoactGamepad then nil else p31.props.focusNavigationRef
	}, {
		Content = p31:renderContents()
	})
end
function v62.renderContents(p32) -- line: 384
	-- upvalues: Cryo (copy), RetrievalStatus (copy), withStyle (copy), withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), React (copy), Focusable (copy), TopBar (copy), ExternalEventConnection (copy), UserInputService (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy)
	local globalGuiInset = p32.props.globalGuiInset
	local fetchingStatus = p32.props.fetchingStatus
	local v100 = p32.props.resellerUserAssetIds and not Cryo.isEmpty(p32.props.resellerUserAssetIds) or p32.props.collectibleResellersInstancesIds and not Cryo.isEmpty(p32.props.collectibleResellersInstancesIds)

	if fetchingStatus == RetrievalStatus.Fetching and v100 then
		fetchingStatus = RetrievalStatus.Done
	end

	return withStyle(function(p33) -- line: 398
		-- upvalues: withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), React (copy), Focusable (copy), globalGuiInset (copy), TopBar (copy), p32 (copy), fetchingStatus (ref), RetrievalStatus (copy), ExternalEventConnection (copy), UserInputService (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy)
		return withLocalization({
			title = "Feature.Catalog.Heading.Sellers",
			failedMessage = not FFlagUpdateNoInternetConnectionText and "Feature.EmptyStatePage.Message.NoInternet" or "Feature.DisplayName.ErrorMessage.SomethingWentWrong"
		})(function(p34) -- line: 404
			-- upvalues: p33 (copy), React (copy), Focusable (copy), globalGuiInset (copy), TopBar (copy), p32 (copy), fetchingStatus (ref), RetrievalStatus (copy), ExternalEventConnection (copy), UserInputService (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy)
			local Theme = p33.Theme

			return React.createElement(Focusable.Frame, {
				BorderSizePixel = 0,
				Active = true,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(0, 0, 0, globalGuiInset.top)
			}, {
				TopBar = React.createElement(TopBar.Container, {
					ZIndex = 2,
					titleText = p34.title,
					ref = p32.topBarRef,
					NextSelectionDown = fetchingStatus == RetrievalStatus.Done and p32.gridViewRef or nil,
					leftItem = TopBar.BackButton
				}),
				LastInputTypeChangedConnection = React.createElement(ExternalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = function(p35) -- line: 424
						-- upvalues: p32 (copy)
						if p35 then
							p32:setState({
								lastInputType = p35
							})
						end
					end
				}),
				LoadingStateContainer = React.createElement(LoadingStateContainer, {
					dataStatus = RetrievalStatus2.fromRawValue(fetchingStatus),
					renderOnLoaded = function() -- line: 435
						-- upvalues: p32 (copy)
						return p32:renderOnLoaded()
					end,
					renderOnFailed = function() -- line: 438
						-- upvalues: p32 (copy), p34 (copy)
						return p32:renderOnFailed(p34)
					end
				})
			})
		end)
	end)
end

local v63 = RoactRodux.connect(function(p36, p37) -- line: 447
	-- upvalues: ItemData (copy), PerformFetch (copy), CatalogConstants (copy)
	local itemId = p37.itemId
	local itemType = p37.itemType
	local v105 = ItemData(p36.AvatarExperience.Common, itemId, itemType)
	local v106 = v105 and (v105.product and v105.product.id)
	local v107 = v105 and v105.resellerUserAssetIds
	local collectibleItemId = p37.collectibleItemId
	local v109 = nil

	if collectibleItemId ~= nil then
		local CollectiblesResellersInstances = p36.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances

		v109 = CollectiblesResellersInstances and (CollectiblesResellersInstances[collectibleItemId] and CollectiblesResellersInstances[collectibleItemId].InstanceIdsList)
	end

	return {
		globalGuiInset = p36.GlobalGuiInset,
		hasMoreRows = p36.AvatarExperience.Catalog.ResellerCursor.hasMoreRows,
		fetchingStatus = PerformFetch.GetStatus(p36, CatalogConstants.GetResellersKey .. tostring(collectibleItemId or itemId)),
		productId = v106,
		purchaseFetchingState = PerformFetch.GetStatus(p36, CatalogConstants.PurchaseProductKey .. tostring(v106)),
		resellerCursor = p36.AvatarExperience.Catalog.ResellerCursor.nextPageCursor,
		resellerUserAssetIds = v107,
		screenSize = p36.ScreenSize,
		collectibleResellersInstancesIds = v109
	}
end, function(p38) -- line: 485
	-- upvalues: SetResellerCursor (copy), CloseFocusedScreen (copy)
	return {
		clearResellerCursor = function() -- line: 487
			-- upvalues: p38 (copy), SetResellerCursor (copy)
			return p38(SetResellerCursor(nil))
		end,
		closeFocusedScreen = function(p39) -- line: 490
			-- upvalues: p38 (copy), CloseFocusedScreen (copy)
			p38(CloseFocusedScreen(p39))
		end
	}
end)(v62)
local v64 = RoactServices.connect({
	networking = RoactNetworking
})(v63)
local u65 = withMappedNavigationParams((withStackVisibilityWrapper((RoactAppPolicy.connect(function(p40, _) -- line: 500
	return {
		enableContinuousLoad = p40.getEnableContinuousLoad()
	}
end)(v64)))))

return function(p42) -- line: 509
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), React (copy), FetchCollectibResellersInstances (copy), CatalogConstants (copy), FetchAssetResellers (copy), useRequest (copy), RequestStatusEnum (copy), FFlagAXMigrateResellersInputBindingsToRoactGamepad (copy), CloseFocusedScreen (copy), useResellersPageFocusNavigationBindings (copy), FFlagAXFixScrollAwayTopBarOverlap (copy), TopBar (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), u65 (ref), Cryo (copy)
	local v115 = useDispatch()
	local v116 = useRoactService(RoactNetworking)
	local v117 = useSelector(function(p43) -- line: 512
		return p43.AvatarExperience.Catalog.ResellerCursor.nextPageCursor
	end)
	local collectibleItemId = p42.navigation.state.params.collectibleItemId
	local itemId = p42.navigation.state.params.itemId
	local v120 = React.useCallback(function() -- line: 519
		-- upvalues: collectibleItemId (copy), v115 (copy), FetchCollectibResellersInstances (copy), v116 (copy), v117 (copy), CatalogConstants (copy), FetchAssetResellers (copy), itemId (copy)
		if collectibleItemId then
			return v115(FetchCollectibResellersInstances(v116, collectibleItemId, v117, CatalogConstants.MaxResellersPerPage))
		end

		return v115(FetchAssetResellers(v116, itemId, v117, CatalogConstants.MaxResellersPerPage, false))
	end, {
		collectibleItemId,
		v117,
		itemId
	})
	local v121 = React.useCallback(function() -- line: 540
		-- upvalues: collectibleItemId (copy), v115 (copy), FetchCollectibResellersInstances (copy), v116 (copy), CatalogConstants (copy), FetchAssetResellers (copy), itemId (copy)
		if collectibleItemId then
			return v115(FetchCollectibResellersInstances(v116, collectibleItemId, nil, CatalogConstants.MaxResellersPerPage))
		end

		return v115(FetchAssetResellers(v116, itemId, nil, CatalogConstants.MaxResellersPerPage, true))
	end, {
		collectibleItemId,
		itemId
	})
	local v122, v123 = useRequest(v120)
	local v124, v125 = useRequest(v121)
	local v126 = v122.status == RequestStatusEnum.Pending or v124.status == RequestStatusEnum.Pending
	local v127 = if not FFlagAXMigrateResellersInputBindingsToRoactGamepad then nil else React.useCallback(function() -- line: 564
		-- upvalues: v115 (copy), CloseFocusedScreen (copy), p42 (copy)
		v115(CloseFocusedScreen(p42.navigation))
	end, {
		p42.navigation,
		v115
	})
	local v128 = if not FFlagAXMigrateResellersInputBindingsToRoactGamepad then nil else useResellersPageFocusNavigationBindings(nil, v127)
	local v129 = nil

	if FFlagAXFixScrollAwayTopBarOverlap then
		local v130 = useSelector(TopBar.selectTopBarHeight)

		v129 = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim.new(0, 24) else UDim.new(0, 24 + v130)
	end

	return React.createElement(u65, Cryo.Dictionary.join(p42, {
		loadMoreItems = v123,
		fetchInitialItems = v125,
		isFetchingMore = v126,
		focusNavigationRef = v128,
		pagePaddingTop = if not FFlagAXFixScrollAwayTopBarOverlap then nil else v129
	}))
end
