local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module2 = require("@luauforge/deferred/gQK")

local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed

local module3 = require("@luauforge/deferred/gSd")

local module4 = require("@luauforge/deferred/gSg")
local module5 = require("@luauforge/bundled/dPU")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module6 = require("@luauforge/deferred/gRz")

local module7 = require("@luauforge/deferred/gJH")
local module8 = require("@luauforge/bundled/fvR")
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module9 = require("@luauforge/deferred/fCG")
local module10 = require("@luauforge/bundled/dAB")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local verticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local fFlagUpdateNoInternetConnectionText = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagUpdateNoInternetConnectionText

local extended = Roact.PureComponent:extend("SellPage")

function extended:init()
	self.state = {
		isWearAfterPurchaseChecked = false,
		canvasSizeY = 0,
		lastInputType = UserInputService:GetLastInputType()
	}

	function self.fetchSellPageData()
		local networking = self.props.networking
		local itemId = self.props.itemId
		local localUserId = self.props.localUserId
		return self.props.fetchSellPageData(networking, itemId, localUserId)
	end

	function self.onContentSizeChanged(p2)
		self:setState({
			canvasSizeY = p2.AbsoluteContentSize.Y + 48
		})
	end

	self.currentlySellingListRef = Roact.createRef()
	self.availableToSellListRef = Roact.createRef()
	self.topBarRef = Roact.createRef()
	self.emptyStateRef = Roact.createRef()

	function self.onOverlayClosed()
		logOnOverlayClosed("SellPage", (isGamepadInput(self.state.lastInputType)))
	end
end

function extended.didMount(p2)
	p2.fetchSellPageData()
end

function extended:renderOnLoaded(p2)
	return Roact.createElement(module8.PageContent, { ZIndex = 2 }, {
		ScrollingView = self:renderScrollingView()
	})
end

function extended:renderScrollingView()
	local itemId = self.props.itemId
	local itemType = self.props.itemType

	local createElement = Roact.createElement
	local v6 = {
		size = UDim2.fromScale(1, 1),
		canvasSizeY = UDim.new(0, self.state.canvasSizeY)
	}
	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Roact.Change.AbsoluteContentSize] = self.onContentSizeChanged
		}),
		PagePadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		CurrentlySellingList = 0,
		AvailableToSellList = 0
	}

	local createElement3 = Roact.createElement
	local currentlySellingListRefsByRef = {
		["itemId"] = nil,
		itemId = itemId,
		LayoutOrder = 2,
		[Roact.Ref] = self.currentlySellingListRef,
		NextSelectionUp = self.topBarRef
	}
	local v8 = if self.props.availableItemsToSell ~= nil and #self.props.availableItemsToSell > 0 then self.availableToSellListRef else nil
	currentlySellingListRefsByRef.NextSelectionDown = v8

	currentlySellingListRefsByRef.onOverlayClosed = self.onOverlayClosed
	children.CurrentlySellingList = createElement3(module4, currentlySellingListRefsByRef)

	local createElement4 = Roact.createElement
	local availableToSellListRefsByRef = {
		["itemId"] = nil,
		itemId = itemId,
		itemType = itemType,
		LayoutOrder = 3,
		[Roact.Ref] = self.availableToSellListRef
	}
	local v10 = if self.props.currentlySellingListData == nil or not (#self.props.currentlySellingListData > 0) then self.topBarRef else self.currentlySellingListRef
	availableToSellListRefsByRef.NextSelectionUp = v10

	availableToSellListRefsByRef.onOverlayClosed = self.onOverlayClosed
	children.AvailableToSellList = createElement4(module3, availableToSellListRefsByRef)
	return createElement(verticalScrollViewWithMargin, v6, children)
end

function extended.renderOnFailed(props, p2)
	return Roact.createElement(emptyState, {
		onActivated = props.fetchSellPageData,
		text = p2.failedMessage,
		[Roact.Ref] = props.emptyStateRef,
		NextSelectionUp = props.topBarRef
	})
end

function extended:render()
	return Roact.createElement(module2, {}, { Content = self:renderContents() })
end

function extended:renderContents()
	local globalGuiInset = self.props.globalGuiInset
	local fetchingStatus = self.props.fetchingStatus

	return withStyle(function(p2)
		return withLocalization({
			title = "Feature.Catalog.Heading.SellItem",
			failedMessage = fFlagUpdateNoInternetConnectionText and "Feature.DisplayName.ErrorMessage.SomethingWentWrong" or "Feature.EmptyStatePage.Message.NoInternet"
		})(function(p3)
			local theme = p2.Theme

			local v5 = nil

			if fetchingStatus == module10.Done then
				if
					self.props.currentlySellingListData == nil
					or not (#self.props.currentlySellingListData > 0)
				then
					if
						self.props.availableItemsToSell == nil
						or not (#self.props.availableItemsToSell > 0)
					then
						if fetchingStatus == module10.Failed then
							v5 = self.emptyStateRef
						end
					else
						v5 = self.availableToSellListRef
					end
				else
					v5 = self.currentlySellingListRef
				end
			end

			return Roact.createElement(focusable.Frame, {
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Position = UDim2.new(0, globalGuiInset.left, 0, globalGuiInset.top),
				Size = UDim2.fromScale(1, 1),
				defaultChild = v5,
				restorePreviousChildFocus = true
			}, {
				TopBar = Roact.createElement(module8.Container, {
					ZIndex = 2,
					tag = compositionTags.ContentRegion.Header,
					sideMarginOverride = 0,
					titleText = p3.title,
					[Roact.Ref] = self.topBarRef,
					NextSelectionDown = v5,
					leftItem = module8.BackButton
				}),
				LoadingStateContainer = Roact.createElement(loadingStateContainer, {
					dataStatus = retrievalStatus.fromRawValue(fetchingStatus),
					renderOnLoaded = function()
						return self:renderOnLoaded(p2)
					end,
					renderOnFailed = function()
						return self:renderOnFailed(p3)
					end
				}),
				LastInputChangedListener = Roact.createElement(externalEventConnection, {
					event = UserInputService.LastInputTypeChanged,
					callback = function(p4)
						self:setState({ lastInputType = p4 })
					end
				})
			})
		end)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	local localUserId = data.LocalUserId
	local itemId = p2.itemId
	return {
		fetchingStatus = performFetch.GetStatus(data, module5.GetSellPageDataKey .. tostring(itemId)),
		globalGuiInset = data.GlobalGuiInset,
		localUserId = localUserId,
		currentlySellingListData = data.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[itemId],
		availableItemsToSell = data.AvatarExperience.Catalog.Sell.AvailableToSellAssets[itemId]
	}
end, function(callback)
	return {
		fetchSellPageData = function(p2, p3, p4)
			callback(module9(p2, p3, p4))
		end
	}
end)(extended)

return (module7((module6((roactServices.connect({ networking = module })(v5))))))
