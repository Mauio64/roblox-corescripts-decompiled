local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local React = require(CorePackages.Packages.React)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarViewport = require(ParentParent.Components.AvatarViewport)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local PopoverFocusRestorationContext = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions).PopoverFocusRestorationContext
local useViewBreakpoints = AvatarExperienceInspectAndBuy.Hooks.useViewBreakpoints
local ResponsivePanelLayout = AvatarExperienceInspectAndBuy.Components.ResponsivePanelLayout
local useResponsivePanelLayoutProps = AvatarExperienceInspectAndBuy.Hooks.useResponsivePanelLayoutProps
local applyTryOnItemToHumanoidDescription = AvatarExperienceInspectAndBuy.Utils.applyTryOnItemToHumanoidDescription
local useInspectAndBuyFocusNavigation = AvatarExperienceInspectAndBuy.Hooks.useInspectAndBuyFocusNavigation
local buildBulkPurchaseAnalyticsPayload = AvatarExperienceInspectAndBuy.Utils.buildBulkPurchaseAnalyticsPayload
local UpdateBulkPuchaseResults = require(ParentParent.Actions.UpdateBulkPuchaseResults)
local GetProductInfo = require(ParentParent.Thunks.GetProductInfo)
local GetFavoriteForAsset = require(ParentParent.Thunks.GetFavoriteForAsset)
local GetFavoriteForBundle = require(ParentParent.Thunks.GetFavoriteForBundle)
local CreateFavoriteForAsset = require(ParentParent.Thunks.CreateFavoriteForAsset)
local DeleteFavoriteForAsset = require(ParentParent.Thunks.DeleteFavoriteForAsset)
local CreateFavoriteForBundle = require(ParentParent.Thunks.CreateFavoriteForBundle)
local DeleteFavoriteForBundle = require(ParentParent.Thunks.DeleteFavoriteForBundle)
local PromptPurchase = require(ParentParent.Thunks.PromptPurchase)
local GetItemDetails = require(ParentParent.Thunks.GetItemDetails)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local OpenOverlay = require(ParentParent.Actions.OpenOverlay)
local Overlay = require(ParentParent.Enums.Overlay)
local Overlay2 = require(ParentParent.Components.Overlay)
local useUnifiedEventListenerInExperience = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventListener.useUnifiedEventListenerInExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local Constants = require(Modules.TopBar.Constants)
local tutils = require(CorePackages.Packages.tutils)
local v41 = game:DefineFastFlag("EnableAvatarViewportAutoRotation", false)
local v42 = game:DefineFastInt("AXViewportCameraFieldOfView", 68)
local FFlagAXEnableBatchItemDetailsFetchV2 = AvatarExperienceFlags.FFlagAXEnableBatchItemDetailsFetchV2
local FFlagAXEnableInspectAndBuyFocusNavigation = AvatarExperienceFlags.FFlagAXEnableInspectAndBuyFocusNavigation
local FFlagAXEnableIaBTimedOptionsBulkPurchase = AvatarExperienceFlags.FFlagAXEnableIaBTimedOptionsBulkPurchase
local FFlagAXFixIaBTimedOptionsPopoverFocus = AvatarExperienceFlags.FFlagAXFixIaBTimedOptionsPopoverFocus
local v47 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext
local v48 = if not v47 then nil else v47.Provider
local v49 = if not v47 then nil else v47.useItemSelectionStore

local function v50(p1) -- line: 85
	return p1.assets
end
local function v51(p2) -- line: 89
	return p2.collectibleResellableInstances
end
local function v52(p3) -- line: 93
	return p3.bundles
end
local function InspectAndBuyBaseContainer(p4) -- line: 97
	-- upvalues: useViewBreakpoints (copy), Constants (copy), useTokens (copy), useDispatch (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v49 (copy), useSignalState (copy), useSelector (copy), v50 (copy), tutils (copy), v51 (copy), v52 (copy), React (copy), GuiService (copy), UpdateBulkPuchaseResults (copy), ItemTypeEnum (copy), buildBulkPurchaseAnalyticsPayload (copy), GetItemDetails (copy), GetFavoriteForAsset (copy), GetProductInfo (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), GetFavoriteForBundle (copy), DeleteFavoriteForAsset (copy), CreateFavoriteForAsset (copy), DeleteFavoriteForBundle (copy), CreateFavoriteForBundle (copy), OpenOverlay (copy), Overlay (copy), PromptPurchase (copy), applyTryOnItemToHumanoidDescription (copy), AvatarViewport (copy), v41 (copy), v42 (copy), useResponsivePanelLayoutProps (copy), useUnifiedEventListenerInExperience (copy), FFlagAXEnableInspectAndBuyFocusNavigation (copy), useInspectAndBuyFocusNavigation (copy), Foundation (copy), Theme (copy), ResponsivePanelLayout (copy), Overlay2 (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), PopoverFocusRestorationContext (copy)
	local v59 = useViewBreakpoints(Constants.TopBarHeight)
	local v60 = useTokens()
	local v61 = useDispatch()
	local v62 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v49()
	local v63 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSignalState(v62.getItemDataMap)
	local v64 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSelector(v50, tutils.deepEqual)
	local v65 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSelector(v51, tutils.deepEqual)
	local v66 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSelector(v52, tutils.deepEqual)
	local v67 = React.useCallback(function() -- line: 122
		-- upvalues: GuiService (copy)
		GuiService:CloseInspectMenu()
	end, {})
	local v68 = React.useCallback(function(_, _, p7) -- line: 130
		-- upvalues: v61 (copy), UpdateBulkPuchaseResults (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v63 (copy), ItemTypeEnum (copy), buildBulkPurchaseAnalyticsPayload (copy), v64 (copy), v66 (copy), v65 (copy), p4 (copy), GetItemDetails (copy)
		v61(UpdateBulkPuchaseResults(p7))

		for _, v81 in p7.Items do
			if v81.status == Enum.MarketplaceItemPurchaseStatus.Success then
				if FFlagAXEnableIaBTimedOptionsBulkPurchase and v63 then
					local v82 = v81.type == Enum.MarketplaceProductType.AvatarAsset
					local id = v81.id
					local v84 = if not v82 then Enum.AvatarItemType.Bundle else Enum.AvatarItemType.Asset
					local v85 = if not v82 then ItemTypeEnum.Bundle else ItemTypeEnum.Asset
					local v86 = v63[tostring(id)]
					local v87 = buildBulkPurchaseAnalyticsPayload({
						itemId = tostring(id),
						itemType = v85,
						assetsMap = v64,
						bundlesMap = v66,
						collectibleResellableInstances = v65,
						storedData = v86
					})

					if v87 then
						p4.analytics.reportPurchaseSuccessUnifiedEvent(v85, id, v87)
					end

					v61(GetItemDetails(id, v84))
				elseif v81.type == Enum.MarketplaceProductType.AvatarAsset then
					p4.analytics.reportPurchaseSuccess(ItemTypeEnum.Asset, v81.id)
					v61(GetItemDetails(v81.id, Enum.AvatarItemType.Asset))
				elseif v81.type == Enum.MarketplaceProductType.AvatarBundle then
					p4.analytics.reportPurchaseSuccess(ItemTypeEnum.Bundle, v81.id)
					v61(GetItemDetails(v81.id, Enum.AvatarItemType.Bundle))
				end
			end
		end
	end, {
		v61,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v64,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v66,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v65,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v63,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else p4.analytics.reportPurchaseSuccess,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else p4.analytics.reportPurchaseSuccessUnifiedEvent
	})
	local v69 = React.useCallback(function(p8) -- line: 187
		-- upvalues: ItemTypeEnum (copy), v61 (copy), GetFavoriteForAsset (copy), GetProductInfo (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), GetItemDetails (copy), GetFavoriteForBundle (copy)
		if p8.itemType == ItemTypeEnum.Asset then
			v61(GetFavoriteForAsset(p8.id))
			v61(GetProductInfo(p8.id))

			if FFlagAXEnableBatchItemDetailsFetchV2 then
				v61(GetItemDetails(p8.id, Enum.AvatarItemType.Asset))

				return
			end
		elseif p8.itemType == ItemTypeEnum.Bundle then
			v61(GetFavoriteForBundle(p8.id))
		end
	end, { v61 })
	local v70 = React.useCallback(function(p9, b1: boolean) -- line: 206
		-- upvalues: ItemTypeEnum (copy), v61 (copy), DeleteFavoriteForAsset (copy), CreateFavoriteForAsset (copy), DeleteFavoriteForBundle (copy), CreateFavoriteForBundle (copy)
		if p9.itemType == ItemTypeEnum.Asset then
			if b1 then
				v61(DeleteFavoriteForAsset(p9.id))

				return
			end

			v61(CreateFavoriteForAsset(p9.id))

			return
		end

		if p9.itemType == ItemTypeEnum.Bundle then
			if b1 then
				v61(DeleteFavoriteForBundle(p9.id))

				return
			end

			v61(CreateFavoriteForBundle(p9.id))
		end
	end, { v61 })
	local v71 = React.useCallback(function(p10) -- line: 222
		-- upvalues: v61 (copy), OpenOverlay (copy), Overlay (copy)
		v61(OpenOverlay(Overlay.AttributionTraversal, p10))
	end, { v61 })
	local v72 = React.useCallback(function(p11) -- line: 281
		-- upvalues: p4 (copy), applyTryOnItemToHumanoidDescription (copy), React (copy), AvatarViewport (copy), v41 (copy), v42 (copy)
		if p4.localPlayerModel and p4.localPlayerModel.Humanoid then
			local clone = p4.localPlayerModel.Humanoid.HumanoidDescription:Clone()

			applyTryOnItemToHumanoidDescription(p11, clone)

			return React.createElement(AvatarViewport, {
				visible = true,
				backgroundTransparency = 1,
				resetCameraAndAutoRotationOnModelChange = true,
				size = UDim2.new(1, 0, 1, 0),
				position = UDim2.new(0.5, 0, 0.5, 0),
				humanoidDescription = clone,
				model = p4.localPlayerModel,
				disableAutoRotation = not v41,
				offsetOptions = {
					defaultCameraOffset = CFrame.new(0, 0.5, -5),
					toolOffset = CFrame.new(0, 2, -8)
				},
				cameraFieldOfView = v42
			})
		end

		return nil
	end, { p4.localPlayerModel })
	local v73 = useResponsivePanelLayoutProps({
		onInspectMenuClosed = v67,
		onBulkPurchaseFinished = v68,
		onItemDetailsOpened = v69,
		onToggleFavorite = v70,
		openAttributionOverlay = v71,
		onPromptPurchase = function(p12, p13, p14, p15, p16, p17, p18) -- line: 259
			-- upvalues: v61 (copy), PromptPurchase (copy)
			v61(PromptPurchase(p12, p13, p14, p15, p16, p17, p18))
		end,
		renderTryOnViewport = v72,
		localPlayerModel = p4.localPlayerModel,
		analytics = p4.analytics
	})

	useUnifiedEventListenerInExperience()

	if FFlagAXEnableInspectAndBuyFocusNavigation then
		local v74 = useInspectAndBuyFocusNavigation()
		local v75 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ref = v74.setFocusRef,
			Size = UDim2.fromScale(1, 1),
			SelectionGroup = v74.focusNavigationProps.SelectionGroup,
			SelectionBehaviorDown = v74.focusNavigationProps.SelectionBehaviorDown,
			SelectionBehaviorLeft = v74.focusNavigationProps.SelectionBehaviorLeft,
			SelectionBehaviorRight = v74.focusNavigationProps.SelectionBehaviorRight,
			SelectionBehaviorUp = v74.focusNavigationProps.SelectionBehaviorUp
		}, {
			Content = React.createElement(Foundation.View, {
				Size = v59.OverlaySize,
				Position = v59.OverlayPosition,
				backgroundStyle = v60.Color.Common.Shadow,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.None
				},
				onActivated = function() -- line: 341
					-- upvalues: GuiService (copy)
					GuiService:CloseInspectMenu()
				end
			}, {
				ContainerView = React.createElement(Foundation.View, {
					ClipsDescendants = true,
					AnchorPoint = v59.ContainerAnchorPoint,
					Size = v59.ContainerSize,
					Position = v59.ContainerPosition,
					backgroundStyle = {
						Color3 = Theme.color("MenuContainer"),
						Transparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
					},
					stateLayer = {
						affordance = Foundation.Enums.StateLayerAffordance.None
					},
					onActivated = function() -- line: 357
					end
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = Theme.DefaultCornerRadius
					}),
					ResponsivePanelLayout = React.createElement(ResponsivePanelLayout, v73)
				}),
				Overlay = React.createElement(Overlay2)
			})
		})

		if FFlagAXFixIaBTimedOptionsPopoverFocus then
			return (React.createElement(PopoverFocusRestorationContext.Provider, {
				value = true
			}, {
				InspectAndBuyContent = v75
			}))
		end

		return v75
	end

	return (React.createElement(Foundation.View, {
		Size = v59.OverlaySize,
		Position = v59.OverlayPosition,
		backgroundStyle = v60.Color.Common.Shadow,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		onActivated = function() -- line: 388
			-- upvalues: GuiService (copy)
			GuiService:CloseInspectMenu()
		end
	}, {
		ContainerView = React.createElement(Foundation.View, {
			ClipsDescendants = true,
			AnchorPoint = v59.ContainerAnchorPoint,
			Size = v59.ContainerSize,
			Position = v59.ContainerPosition,
			backgroundStyle = {
				Color3 = Theme.color("MenuContainer"),
				Transparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
			},
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = function() -- line: 404
			end
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = Theme.DefaultCornerRadius
			}),
			ResponsivePanelLayout = React.createElement(ResponsivePanelLayout, v73)
		}),
		Overlay = React.createElement(Overlay2)
	}))
end
local function InspectAndBuyBaseContainerWithSignalsProvider(p19) -- line: 416
	-- upvalues: React (copy), v48 (copy), InspectAndBuyBaseContainer (copy)
	return React.createElement(v48, {}, {
		Inner = React.createElement(InspectAndBuyBaseContainer, p19)
	})
end

if FFlagAXEnableIaBTimedOptionsBulkPurchase then
	return InspectAndBuyBaseContainerWithSignalsProvider
end

return InspectAndBuyBaseContainer
