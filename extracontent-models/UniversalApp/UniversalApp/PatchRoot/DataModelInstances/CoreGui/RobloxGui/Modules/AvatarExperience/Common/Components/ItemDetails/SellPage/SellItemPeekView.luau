local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local Modules = CoreGui.RobloxGui.Modules
local Focusable = RoactGamepad.Focusable
local SellItemInfo = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.SellItemInfo)
local SellItemSetPrice = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.SellItemSetPrice)
local SellItemOverview = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.SellItemOverview)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local GetMarketplaceFee = require(Modules.AvatarExperience.Catalog.Thunks.GetMarketplaceFee)
local GetCollectibleMarketplaceResaleParameters = require(Modules.AvatarExperience.Catalog.Thunks.GetCollectibleMarketplaceResaleParameters)
local RemoveAvailableToSellAsset = require(Modules.AvatarExperience.Catalog.Thunks.RemoveAvailableToSellAsset)
local UpdateCollectibleInstanceResaleState = require(Modules.AvatarExperience.Catalog.Thunks.UpdateCollectibleInstanceResaleState)
local CenteredModalView = require(Modules.AvatarExperience.Common.Components.CenteredModalView)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local useStyle = UIBlox.Core.Style.useStyle
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useSellItemPeekViewFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 90
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v54 = ReactFocusNavigation.useEventMap(t1, p1)
	local v55 = React.useMemo(function() -- line: 92
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 95
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v55, v54)
end
local function isConfirmButtonDisabled(s1: string, n1: number) -- line: 105
	if s1 then
		local num = tonumber(s1)

		return not num or num < (n1 or 0)
	end

	return true
end
local function getWhitespaceOffsetForPeekView(p4, p5, p6, n2: number) -- line: 119
	if p4 == nil or (p5 == nil or p6 == nil) then
		return -1
	end

	local v63 = math.clamp(n2 == nil and 0.8 or n2, 0, 1)

	return p4.Y * v63 - 25 - 20 - p5.Y - 30 - p6.Y - 30 - 30
end
local function getItemSubTypeName(s2: string, s3: string?) -- line: 145
	-- upvalues: Constants (copy)
	if not s3 then
		return nil
	end

	if s2 == Constants.ItemType.Bundle then
		return Constants.BundleTypeIdStringToNameForBackend[s3] or Constants.BundleTypeIdStringToName[s3]
	end

	if s2 == Constants.ItemType.Asset then
		return Constants.AssetTypeIdStringToName[s3]
	end

	return nil
end
local function SellItemPeekView(_: {[any]: any}) -- line: 169
	-- upvalues: useLocalization (copy), useStyle (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useNavigation (copy), React (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useProperty (copy), useSelector (copy), ItemData (copy), getUseSelectorDeepEquals (copy), CatalogUtils (copy), Constants (copy), PerformFetch (copy), CatalogConstants (copy), RetrievalStatus (copy), GetCollectibleMarketplaceResaleParameters (copy), GetMarketplaceFee (copy), PeekViewState (copy), FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation (copy), useSellItemPeekViewFocusNavigationBindings (copy), UpdateCollectibleInstanceResaleState (copy), RemoveAvailableToSellAsset (copy), SellItemInfo (copy), SellItemSetPrice (copy), GetFFlagL2ControllerSupport (copy), SellItemOverview (copy), ButtonType (copy), CenteredModalView (copy), Focusable (copy), NavigationUtils (copy), GamepadFocusHandlerForPage (copy), PeekView (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), ButtonStack (copy)
	local v67 = useLocalization({
		sellItemText = "Feature.Catalog.Heading.SellItem",
		sellButtonText = "Feature.Catalog.Action.Sell",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})
	local v68 = useStyle()
	local Theme = v68.Theme
	local v70 = useDispatch()
	local v71 = useRoactService(RoactNetworking)
	local v72 = useNavigation()
	local params = v72.state.params
	local v74, v75 = React.useState("")
	local v76 = React.useRef(nil)
	local v77 = React.useRef(nil)
	local v78 = React.useRef(nil)
	local v79 = React.useRef(nil)
	local v80 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v81 = useProperty(v76, "AbsoluteSize") or nil
	local v82 = useProperty(v77, "AbsoluteSize") or nil
	local v83 = useProperty(v78, "AbsoluteSize") or nil
	local peekViewFillPercentage = v72.state.params.peekViewFillPercentage
	local n3

	if v81 == nil or (v82 == nil or v83 == nil) then
		n3 = -1
	else
		local v86 = math.clamp(peekViewFillPercentage == nil and 0.8 or peekViewFillPercentage, 0, 1)

		n3 = v81.Y * v86 - 25 - 20 - v82.Y - 30 - v83.Y - 30 - 30
	end

	local collectibleItemId = v72.state.params.collectibleItemId
	local v88 = useSelector(function(p7) -- line: 206
		-- upvalues: ItemData (copy), params (copy)
		return ItemData(p7.AvatarExperience.Common, params.itemId, params.itemType)
	end, getUseSelectorDeepEquals())
	local v89 = CatalogUtils.GetItemSubType(params.itemType, v88)
	local itemType = params.itemType
	local v91 = if v89 then if itemType ~= Constants.ItemType.Bundle then if itemType ~= Constants.ItemType.Asset then nil else Constants.AssetTypeIdStringToName[v89] else Constants.BundleTypeIdStringToNameForBackend[v89] or Constants.BundleTypeIdStringToName[v89] else nil
	local v92 = useSelector(function(p8) -- line: 212
		-- upvalues: v72 (copy), ItemData (copy)
		local itemId = v72.state.params.itemId
		local itemType2 = v72.state.params.itemType
		local userAssetId = v72.state.params.userAssetId
		local v117 = ItemData(p8.AvatarExperience.Common, itemId, itemType2)
		local v118 = v117 and v117.averagePrice
		local v119 = p8.AvatarExperience.Catalog.UserAssets[userAssetId]

		return {
			id = itemId,
			averagePrice = v118,
			serialNumber = if v119 == nil then nil else v119.serialNumber
		}
	end, getUseSelectorDeepEquals())
	local v93 = useSelector(function(p9) -- line: 229
		-- upvalues: collectibleItemId (copy), collectibleItemId (copy)
		if collectibleItemId then
			local v121 = p9.AvatarExperience.Common.Collectibles.CollectiblesMarketplaceResaleParameters[collectibleItemId]

			if v121 ~= nil then
				return {
					taxRate = v121.resalePercentageFee / 100,
					minimumFee = v121.minimumFee
				}
			end

			return {}
		end

		return p9.AvatarExperience.Catalog.MarketplaceFee
	end, getUseSelectorDeepEquals())
	local v94 = useSelector(function(p10) -- line: 245
		-- upvalues: v72 (copy), PerformFetch (copy), CatalogConstants (copy)
		local userAssetId = v72.state.params.userAssetId

		return PerformFetch.GetStatus(p10, CatalogConstants.RemoveAvailableToSellAssetKey .. tostring(userAssetId))
	end, getUseSelectorDeepEquals())
	local v95 = useSelector(function(p11) -- line: 250
		-- upvalues: PerformFetch (copy), CatalogConstants (copy)
		return PerformFetch.GetStatus(p11, CatalogConstants.GetMarketplaceFeeKey)
	end, getUseSelectorDeepEquals())
	local v96 = useSelector(function(p12) -- line: 254
		-- upvalues: CatalogConstants (copy), collectibleItemId (copy), PerformFetch (copy)
		local v126 = CatalogConstants.GetCollectibleMarketplaceResaleParametersKey .. tostring(collectibleItemId)

		return PerformFetch.GetStatus(p12, v126)
	end, getUseSelectorDeepEquals())
	local v97 = useSelector(function(p13) -- line: 259
		-- upvalues: collectibleItemId (copy)
		local v128 = p13.AvatarExperience.Common.Collectibles.CollectiblesMarketplaceResaleParameters[collectibleItemId]

		return v128 and v128.priceFloor or 0
	end, getUseSelectorDeepEquals())

	React.useEffect(function() -- line: 266
		-- upvalues: collectibleItemId (copy), v96 (copy), RetrievalStatus (copy), v70 (copy), GetCollectibleMarketplaceResaleParameters (copy), v71 (copy), collectibleItemId (copy), v91 (copy), v95 (copy), GetMarketplaceFee (copy)
		if collectibleItemId and (v96 == RetrievalStatus.NotStarted or v96 == RetrievalStatus.Failed) then
			v70(GetCollectibleMarketplaceResaleParameters(v71, collectibleItemId, v91))

			return
		end

		if v95 == RetrievalStatus.NotStarted or v95 == RetrievalStatus.Failed then
			v70(GetMarketplaceFee(v71))
		end
	end, {
		v95,
		v96,
		collectibleItemId,
		v91
	})

	local v98 = React.useCallback(function() -- line: 288
		-- upvalues: v72 (copy)
		v72.goBack()

		local onPeekViewClosed = v72.state.params.onPeekViewClosed

		if onPeekViewClosed then
			onPeekViewClosed()
		end
	end, { v72 })
	local v99 = React.useCallback(function(p14, _) -- line: 296
		-- upvalues: PeekViewState (copy), v98 (copy)
		if p14 == PeekViewState.Closed then
			v98()
		end
	end, { v98 })
	local v100 = if not FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation then nil else useSellItemPeekViewFocusNavigationBindings(nil, v98)
	local v101 = React.useCallback(function() -- line: 308
		-- upvalues: v74 (copy), v97 (copy), v92 (copy), v72 (copy), collectibleItemId (copy), v70 (copy), UpdateCollectibleInstanceResaleState (copy), v71 (copy), collectibleItemId (copy), RemoveAvailableToSellAsset (copy), v98 (copy)
		local v132 = v74
		local v133 = v97
		local v135

		if v132 then
			local num = tonumber(v132)

			v135 = not num or num < (v133 or 0)
		else
			v135 = true
		end

		if v135 then
			return
		end

		local id = v92.id
		local userAssetId = v72.state.params.userAssetId
		local num = tonumber(v74)

		if collectibleItemId then
			v70(UpdateCollectibleInstanceResaleState(v71, collectibleItemId, userAssetId, true, num))
		else
			v70(RemoveAvailableToSellAsset(v71, id, userAssetId, num))
		end

		v98()
	end, {
		v98,
		v74,
		v92,
		v72,
		v71,
		collectibleItemId,
		v97
	})
	local v102 = React.useCallback(function() -- line: 346
		-- upvalues: v68 (copy), React (copy), v67 (copy), Theme (copy), SellItemInfo (copy), v92 (copy), SellItemSetPrice (copy), v97 (copy), v74 (copy), v75 (copy), GetFFlagL2ControllerSupport (copy), v79 (copy), v78 (copy), SellItemOverview (copy), v93 (copy)
		local Font = v68.Font
		local Header1 = Font.Header1
		local v141 = Header1.RelativeSize * Font.BaseSize

		return React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 30)
			}),
			SellItemHeader = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v67.sellItemText,
				Font = Header1.Font,
				Size = UDim2.fromScale(1, 0),
				TextSize = v141,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency
			}),
			ItemInfoContent = React.createElement(SellItemInfo, {
				layoutOrder = 2,
				itemIdPriceSerialNumber = v92
			}),
			SetPriceContent = React.createElement(SellItemSetPrice, {
				layoutOrder = 3,
				priceFloor = v97,
				priceInRobux = v74,
				setPriceInRobux = v75,
				ref = if not GetFFlagL2ControllerSupport() then nil else v79,
				NextSelectionDown = if not GetFFlagL2ControllerSupport() then nil else v78
			}),
			OverviewContent = React.createElement(SellItemOverview, {
				layoutOrder = 4,
				marketplaceFee = v93,
				priceInRobux = v74
			})
		})
	end, {
		v68,
		Theme,
		v67,
		v92,
		v74,
		v75,
		v93
	})
	local v103 = React.useCallback(function() -- line: 404
		-- upvalues: v95 (copy), RetrievalStatus (copy), v70 (copy), GetMarketplaceFee (copy), v71 (copy)
		if v95 ~= RetrievalStatus.Fetching then
			v70(GetMarketplaceFee(v71))
		end
	end, {
		v95,
		v71
	})
	local v104 = React.useCallback(function() -- line: 410
		-- upvalues: v96 (copy), RetrievalStatus (copy), v70 (copy), GetCollectibleMarketplaceResaleParameters (copy), v71 (copy), collectibleItemId (copy), v91 (copy)
		if v96 ~= RetrievalStatus.Fetching then
			v70(GetCollectibleMarketplaceResaleParameters(v71, collectibleItemId, v91))
		end
	end, {
		v96,
		v71,
		collectibleItemId,
		v91
	})
	local t3 = {}
	local t4 = {}
	local t5 = {
		isDefaultChild = true,
		props = {
			onActivated = v98,
			text = v67.cancelButtonText
		}
	}
	local t6 = {
		isDefaultChild = false,
		buttonType = ButtonType.PrimarySystem
	}
	local t7 = {}
	local v111

	if v74 then
		local num = tonumber(v74)

		v111 = not num or num < (v97 or 0)
	else
		v111 = true
	end

	t7.isDisabled = v111
	t7.isLoading = v94 == RetrievalStatus.Fetching or (v95 == RetrievalStatus.Fetching or v96 == RetrievalStatus.Fetching)
	t7.onActivated = v101
	t7.text = v67.sellButtonText
	t6.props = t7
	t4[1] = t5
	t4[2] = t6
	t3.buttons = t4

	return React.createElement(CenteredModalView, {
		backgroundTransparency = 1
	}, {
		FullSizeFrame = React.createElement(not GetFFlagL2ControllerSupport() and "Frame" or Focusable.Frame, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then if not GetFFlagL2ControllerSupport() then nil else v80 else nil,
			defaultChild = if not GetFFlagL2ControllerSupport() then nil else v79,
			inputBindings = if FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation or not GetFFlagL2ControllerSupport() then nil else {
				NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 465
					-- upvalues: NavigationUtils (copy), v72 (copy)
					NavigationUtils.closeFocusedScreen(v72)
				end)
			},
			ref = v76
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then GetFFlagL2ControllerSupport() and React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v80
			}) else nil,
			PeekView = React.createElement(PeekView, {
				mountAsFullView = true,
				isScrollingEnabled = false,
				showDraggerInClosedState = false,
				peekHeaderClose = true,
				canDragFullViewToBrief = false,
				thumbstickScrollEnabled = false,
				viewStateChanged = v99,
				backgroundColor3 = Theme.BackgroundDefault.Color,
				backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
				shouldCaptureFocus = not FFlagAXMigrateAXToGlobalAutofocus and nil
			}, {
				ContentContainer = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					ref = if not FFlagAXMigrateItemOwnershipSellPagesInputBindingsToFocusNavigation then nil else v100
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 30)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20),
						PaddingTop = UDim.new(0, 20),
						PaddingBottom = UDim.new(0, 30)
					}),
					ItemInfoContentFrame = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0),
						ref = v77
					}, {
						Content = React.createElement(LoadingStateContainer, {
							dataStatus = if not collectibleItemId then RetrievalStatus2.fromRawValue(v95) else RetrievalStatus2.fromRawValue(v96),
							onRetry = if not collectibleItemId then v103 else v104,
							renderOnLoaded = v102
						})
					}),
					WhiteSpaceFrame = n3 >= 0 and React.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, n3)
					}),
					Footer = React.createElement(Focusable.Frame, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0),
						ref = v78,
						NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else v79
					}, {
						Buttons = t3 and React.createElement(ButtonStack, t3)
					})
				})
			})
		})
	})
end

return SellItemPeekView
