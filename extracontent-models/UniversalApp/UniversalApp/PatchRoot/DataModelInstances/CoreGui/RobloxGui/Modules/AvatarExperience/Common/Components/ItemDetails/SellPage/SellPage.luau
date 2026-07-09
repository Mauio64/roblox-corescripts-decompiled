local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local CenteredModalView = require(Modules.AvatarExperience.Common.Components.CenteredModalView)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local AvailableToSellList = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.AvailableToSellList)
local CurrentlySellingList = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.CurrentlySellingList)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local CloseFocusedScreen = require(Modules.AvatarExperience.Common.Thunks.CloseFocusedScreen)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local FetchSellPageData = require(Modules.AvatarExperience.Catalog.Thunks.FetchSellPageData)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local FFlagAXRemoveSellPageAndChildrenGamepadBindings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRemoveSellPageAndChildrenGamepadBindings
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local FFlagUpdateNoInternetConnectionText = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagUpdateNoInternetConnectionText
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v35 = Roact.PureComponent:extend("SellPage")

function v35.init(p1) -- line: 64
	-- upvalues: UserInputService (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Roact (copy), isGamepadInput (copy), logOnOverlayClosed (copy)
	p1.state = {
		isWearAfterPurchaseChecked = false,
		canvasSizeY = 0,
		lastInputType = UserInputService:GetLastInputType()
	}

	function p1.fetchSellPageData() -- line: 71
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local itemId = p1.props.itemId
		local localUserId = p1.props.localUserId

		return p1.props.fetchSellPageData(networking, itemId, localUserId)
	end
	function p1.onContentSizeChanged(p2) -- line: 78
		-- upvalues: p1 (copy)
		p1:setState({
			canvasSizeY = p2.AbsoluteContentSize.Y + 48
		})
	end

	p1.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p1.props.focusController or RoactGamepad.createFocusController() else nil
	p1.currentlySellingListRef = Roact.createRef()
	p1.availableToSellListRef = Roact.createRef()
	p1.topBarRef = Roact.createRef()
	p1.emptyStateRef = Roact.createRef()

	function p1.onOverlayClosed() -- line: 93
		-- upvalues: isGamepadInput (copy), p1 (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
		local v62 = isGamepadInput(p1.state.lastInputType)

		logOnOverlayClosed("SellPage", v62)

		if not FFlagAXMigrateAXToGlobalAutofocus and v62 then
			p1.focusController.captureFocus()
		end
	end
	function p1.goBack() -- line: 101
		-- upvalues: p1 (copy)
		local navigation = p1.props.navigation

		p1.props.closeFocusedScreen(navigation)
	end
end
function v35.didMount(p3) -- line: 108
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), isGamepadInput (copy)
	p3.fetchSellPageData()

	if not FFlagAXMigrateAXToGlobalAutofocus and isGamepadInput(p3.state.lastInputType) then
		p3.focusController.captureFocus()
	end
end

if not FFlagAXMigrateAXToGlobalAutofocus then
	function v35.didUpdate(p4, p5) -- line: 119
		-- upvalues: isGamepadInput (copy), RetrievalStatus (copy)
		local fetchingStatus = p4.props.fetchingStatus

		if isGamepadInput(p4.state.lastInputType) and (p5.currentlySellingListData and p4.props.currentlySellingListData and p5.availableItemsToSell and p4.props.availableItemsToSell and fetchingStatus == RetrievalStatus.Done and #p5.currentlySellingListData ~= #p4.props.currentlySellingListData) then
			if #p4.props.currentlySellingListData == 0 then
				p4.focusController.moveFocusTo(p4.availableToSellListRef)

				return
			end

			p4.focusController.moveFocusTo(p4.currentlySellingListRef)
		end
	end
end

function v35.renderOnLoaded(p6, _) -- line: 142
	-- upvalues: Roact (copy), TopBar (copy)
	return Roact.createElement(TopBar.PageContent, {
		ZIndex = 2
	}, {
		ScrollingView = p6:renderScrollingView()
	})
end
function v35.renderScrollingView(p8) -- line: 150
	-- upvalues: Roact (copy), VerticalScrollViewWithMargin (copy), CurrentlySellingList (copy), AvailableToSellList (copy)
	local itemId = p8.props.itemId
	local itemType = p8.props.itemType

	return Roact.createElement(VerticalScrollViewWithMargin, {
		size = UDim2.fromScale(1, 1),
		canvasSizeY = UDim.new(0, p8.state.canvasSizeY)
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = p8.onContentSizeChanged
		}),
		PagePadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		CurrentlySellingList = Roact.createElement(CurrentlySellingList, {
			itemId = itemId,
			LayoutOrder = 2,
			[Roact.Ref] = p8.currentlySellingListRef,
			NextSelectionUp = p8.topBarRef,
			NextSelectionDown = if p8.props.availableItemsToSell == nil or not (#p8.props.availableItemsToSell > 0) then nil else p8.availableToSellListRef,
			onOverlayClosed = p8.onOverlayClosed
		}),
		AvailableToSellList = Roact.createElement(AvailableToSellList, {
			itemId = itemId,
			itemType = itemType,
			LayoutOrder = 3,
			[Roact.Ref] = p8.availableToSellListRef,
			NextSelectionUp = if p8.props.currentlySellingListData == nil or not (#p8.props.currentlySellingListData > 0) then p8.topBarRef else p8.currentlySellingListRef,
			onOverlayClosed = p8.onOverlayClosed
		})
	})
end
function v35.renderOnFailed(p9, p10) -- line: 197
	-- upvalues: Roact (copy), EmptyState (copy)
	return Roact.createElement(EmptyState, {
		onActivated = p9.fetchSellPageData,
		text = p10.failedMessage,
		[Roact.Ref] = p9.emptyStateRef,
		NextSelectionUp = p9.topBarRef
	})
end
function v35.render(p11) -- line: 206
	-- upvalues: Roact (copy), CenteredModalView (copy)
	return Roact.createElement(CenteredModalView, {}, {
		Content = p11:renderContents()
	})
end
function v35.renderContents(p12) -- line: 212
	-- upvalues: withStyle (copy), withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), RetrievalStatus (copy), Roact (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), ExternalEventConnection (copy), UserInputService (copy)
	local globalGuiInset = p12.props.globalGuiInset
	local fetchingStatus = p12.props.fetchingStatus

	return withStyle(function(p13) -- line: 216
		-- upvalues: withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), fetchingStatus (copy), RetrievalStatus (copy), p12 (copy), Roact (copy), Focusable (copy), globalGuiInset (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), ExternalEventConnection (copy), UserInputService (copy)
		return withLocalization({
			title = "Feature.Catalog.Heading.SellItem",
			failedMessage = not FFlagUpdateNoInternetConnectionText and "Feature.EmptyStatePage.Message.NoInternet" or "Feature.DisplayName.ErrorMessage.SomethingWentWrong"
		})(function(p14) -- line: 222
			-- upvalues: p13 (copy), fetchingStatus (copy), RetrievalStatus (copy), p12 (copy), Roact (copy), Focusable (copy), globalGuiInset (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXRemoveSellPageAndChildrenGamepadBindings (copy), RoactGamepad (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), ExternalEventConnection (copy), UserInputService (copy)
			local Theme = p13.Theme
			local currentlySellingListRef = nil

			if fetchingStatus == RetrievalStatus.Done then
				if p12.props.currentlySellingListData ~= nil and #p12.props.currentlySellingListData > 0 then
					currentlySellingListRef = p12.currentlySellingListRef
				elseif p12.props.availableItemsToSell ~= nil and #p12.props.availableItemsToSell > 0 then
					currentlySellingListRef = p12.availableToSellListRef
				elseif fetchingStatus == RetrievalStatus.Failed then
					currentlySellingListRef = p12.emptyStateRef
				end
			end

			return Roact.createElement(Focusable.Frame, {
				BorderSizePixel = 0,
				restorePreviousChildFocus = true,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, globalGuiInset.left, 0, globalGuiInset.top),
				Size = UDim2.fromScale(1, 1),
				defaultChild = currentlySellingListRef,
				focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p12.focusController else nil,
				inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXRemoveSellPageAndChildrenGamepadBindings then {
					NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p12.goBack)
				} else nil
			}, {
				TopBar = Roact.createElement(TopBar.Container, {
					ZIndex = 2,
					titleText = p14.title,
					[Roact.Ref] = p12.topBarRef,
					NextSelectionDown = currentlySellingListRef,
					leftItem = TopBar.BackButton
				}),
				GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
					focusController = p12.focusController
				}) else nil,
				LoadingStateContainer = Roact.createElement(LoadingStateContainer, {
					dataStatus = RetrievalStatus2.fromRawValue(fetchingStatus),
					renderOnLoaded = function() -- line: 266
						-- upvalues: p12 (copy), p13 (copy)
						return p12:renderOnLoaded(p13)
					end,
					renderOnFailed = function() -- line: 269
						-- upvalues: p12 (copy), p14 (copy)
						return p12:renderOnFailed(p14)
					end
				}),
				LastInputChangedListener = Roact.createElement(ExternalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = function(p15) -- line: 275
						-- upvalues: p12 (copy)
						p12:setState({
							lastInputType = p15
						})
					end
				})
			})
		end)
	end)
end

local v36 = RoactRodux.connect(function(p16, p17) -- line: 286
	-- upvalues: PerformFetch (copy), CatalogConstants (copy)
	local LocalUserId = p16.LocalUserId
	local itemId = p17.itemId

	return {
		fetchingStatus = PerformFetch.GetStatus(p16, CatalogConstants.GetSellPageDataKey .. tostring(itemId)),
		globalGuiInset = p16.GlobalGuiInset,
		localUserId = LocalUserId,
		currentlySellingListData = p16.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[itemId],
		availableItemsToSell = p16.AvatarExperience.Catalog.Sell.AvailableToSellAssets[itemId]
	}
end, function(p18) -- line: 296
	-- upvalues: FetchSellPageData (copy), CloseFocusedScreen (copy)
	return {
		fetchSellPageData = function(p19, p20, p21) -- line: 298
			-- upvalues: p18 (copy), FetchSellPageData (copy)
			p18(FetchSellPageData(p19, p20, p21))
		end,
		closeFocusedScreen = function(p22) -- line: 301
			-- upvalues: p18 (copy), CloseFocusedScreen (copy)
			p18(CloseFocusedScreen(p22))
		end
	}
end)(v35)

return (withMappedNavigationParams((withStackVisibilityWrapper((RoactServices.connect({
	networking = RoactNetworking
})(v36))))))
