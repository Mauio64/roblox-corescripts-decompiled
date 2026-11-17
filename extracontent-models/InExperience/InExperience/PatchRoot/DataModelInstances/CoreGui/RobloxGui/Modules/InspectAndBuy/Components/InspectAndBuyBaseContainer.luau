local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local parent = script.Parent.Parent
local React = require(CorePackages.Packages.React)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarViewport = require(parent.Components.AvatarViewport)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local AvatarExperienceTimedOptions = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions)
local PopoverFocusRestorationContext = AvatarExperienceTimedOptions.PopoverFocusRestorationContext
local useViewBreakpoints = AvatarExperienceInspectAndBuy.Hooks.useViewBreakpoints
local ResponsivePanelLayout = AvatarExperienceInspectAndBuy.Components.ResponsivePanelLayout
local useResponsivePanelLayoutProps = AvatarExperienceInspectAndBuy.Hooks.useResponsivePanelLayoutProps
local applyTryOnItemToHumanoidDescription = AvatarExperienceInspectAndBuy.Utils.applyTryOnItemToHumanoidDescription
local useInspectAndBuyFocusNavigation = AvatarExperienceInspectAndBuy.Hooks.useInspectAndBuyFocusNavigation
local buildBulkPurchaseAnalyticsPayload = AvatarExperienceInspectAndBuy.Utils.buildBulkPurchaseAnalyticsPayload

local UpdateBulkPuchaseResults = require(parent.Actions.UpdateBulkPuchaseResults)
local GetProductInfo = require(parent.Thunks.GetProductInfo)
local GetFavoriteForAsset = require(parent.Thunks.GetFavoriteForAsset)
local GetFavoriteForBundle = require(parent.Thunks.GetFavoriteForBundle)
local CreateFavoriteForAsset = require(parent.Thunks.CreateFavoriteForAsset)
local DeleteFavoriteForAsset = require(parent.Thunks.DeleteFavoriteForAsset)
local CreateFavoriteForBundle = require(parent.Thunks.CreateFavoriteForBundle)
local DeleteFavoriteForBundle = require(parent.Thunks.DeleteFavoriteForBundle)
local PromptPurchase = require(parent.Thunks.PromptPurchase)
local GetItemDetails = require(parent.Thunks.GetItemDetails)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local OpenOverlay = require(parent.Actions.OpenOverlay)
local Overlay = require(parent.Enums.Overlay)
local Overlay2 = require(parent.Components.Overlay)

local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local useUnifiedEventListenerInExperience = AvatarExperienceAnalytics.useUnifiedEventListener.useUnifiedEventListenerInExperience

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarBackground = require(CorePackages.Workspace.Packages.DataHydration.AvatarBackground)

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local Constants = require(Modules.TopBar.Constants)
local tutils = require(CorePackages.Packages.tutils)

local defineFastFlag = game:DefineFastFlag("EnableAvatarViewportAutoRotation", false)

local defineFastInt = game:DefineFastInt("AXViewportCameraFieldOfView", 68)
local FFlagAXEnableBatchItemDetailsFetchV2 = AvatarExperienceFlags.FFlagAXEnableBatchItemDetailsFetchV2
local FFlagAXEnableInspectAndBuyFocusNavigation = AvatarExperienceFlags.FFlagAXEnableInspectAndBuyFocusNavigation
local FFlagAXInspectAndBuyAvatarBackground = AvatarExperienceFlags.FFlagAXInspectAndBuyAvatarBackground
local ItemSelectionStoreContext = AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext
local Provider = ItemSelectionStoreContext.Provider
local useItemSelectionStore = ItemSelectionStoreContext.useItemSelectionStore

local function fn(p)
	return p.assets
end

local function fn2(p)
	return p.collectibleResellableInstances
end

local function fn3(p)
	return p.bundles
end

local function useAvatarBackgroundImageUrl(playerId: number?)
	return useSignalState((React.useMemo(function()
		local v

		if playerId == nil then
			v = nil
		else
			v = AvatarBackground.getAvatarBackgroundStore(false).getAndFetchAvatarBackground(playerId)
		end

		return Signals.createComputed(function(p)
			local v2 = v and v.data(p)
			local assetId = v2 and v2.assetId

			if assetId then
				return (AvatarBackground.getAvatarBackgroundImageUrl(assetId))
			end

			return nil
		end)
	end, { playerId })))
end

local function InspectAndBuyBaseContainer(props)
	local v = useViewBreakpoints(Constants.TopBarHeight)
	local v2 = useTokens()
	local v3 = useDispatch()

	local v4 = useSignalState(useItemSelectionStore().getItemDataMap)

	local assetsMap = useSelector(fn, tutils.deepEqual)
	local collectibleResellableInstances = useSelector(fn2, tutils.deepEqual)
	local bundlesMap = useSelector(fn3, tutils.deepEqual)
	local avatarBackgroundImageUrl

	if FFlagAXInspectAndBuyAvatarBackground then
		avatarBackgroundImageUrl = useAvatarBackgroundImageUrl(props.playerId)
	end

	local function onPromptPurchase(p, p2, p3, p4, p5, p6, p7)
		v3(PromptPurchase(p, p2, p3, p4, p5, p6, p7))
	end

	local v5 = useResponsivePanelLayoutProps({
		onInspectMenuClosed = React.useCallback(function()
			GuiService:CloseInspectMenu()
		end, {}),
		onBulkPurchaseFinished = React.useCallback(function(_, _, p)
			v3(UpdateBulkPuchaseResults(p))

			for _, item in p.Items do
				if item.status ~= Enum.MarketplaceItemPurchaseStatus.Success then
					continue
				end

				local v5 = item.type == Enum.MarketplaceProductType.AvatarAsset
				local id = item.id
				local v6

				if v5 then
					v6 = Enum.AvatarItemType.Asset
				else
					v6 = Enum.AvatarItemType.Bundle
				end

				local itemType

				if v5 then
					itemType = ItemTypeEnum.Asset
				else
					itemType = ItemTypeEnum.Bundle
				end

				local storedData = v4[tostring(id)]
				local bulkPurchaseAnalyticsPayload = buildBulkPurchaseAnalyticsPayload({
					itemId = tostring(id),
					itemType = itemType,
					assetsMap = assetsMap,
					bundlesMap = bundlesMap,
					collectibleResellableInstances = collectibleResellableInstances,
					storedData = storedData
				})

				if bulkPurchaseAnalyticsPayload then
					props.analytics.reportPurchaseSuccessUnifiedEvent(itemType, id, bulkPurchaseAnalyticsPayload)
				end

				v3(GetItemDetails(id, v6))
			end
		end, {
			v3,
			assetsMap,
			bundlesMap,
			collectibleResellableInstances,
			v4,
			props.analytics.reportPurchaseSuccessUnifiedEvent
		}),
		onItemDetailsOpened = React.useCallback(function(p)
			if p.itemType == ItemTypeEnum.Asset then
				v3(GetFavoriteForAsset(p.id))
				v3(GetProductInfo(p.id))

				if FFlagAXEnableBatchItemDetailsFetchV2 then
					v3(GetItemDetails(p.id, Enum.AvatarItemType.Asset))
				end
			elseif p.itemType == ItemTypeEnum.Bundle then
				v3(GetFavoriteForBundle(p.id))
			end
		end, { v3 }),
		onToggleFavorite = React.useCallback(function(p, flag: boolean)
			if p.itemType == ItemTypeEnum.Asset then
				if flag then
					v3(DeleteFavoriteForAsset(p.id))
				else
					v3(CreateFavoriteForAsset(p.id))
				end
			elseif p.itemType == ItemTypeEnum.Bundle then
				if flag then
					v3(DeleteFavoriteForBundle(p.id))
				else
					v3(CreateFavoriteForBundle(p.id))
				end
			end
		end, { v3 }),
		openAttributionOverlay = React.useCallback(function(p)
			v3(OpenOverlay(Overlay.AttributionTraversal, p))
		end, { v3 }),
		onPromptPurchase = onPromptPurchase,
		renderTryOnViewport = React.useCallback(function(p)
			if props.localPlayerModel and props.localPlayerModel.Humanoid then
				local clone = props.localPlayerModel.Humanoid.HumanoidDescription:Clone()
				applyTryOnItemToHumanoidDescription(p, clone)
				return React.createElement(AvatarViewport, {
					size = UDim2.new(1, 0, 1, 0),
					position = UDim2.new(0.5, 0, 0.5, 0),
					humanoidDescription = clone,
					model = props.localPlayerModel,
					visible = true,
					backgroundTransparency = 1,
					disableAutoRotation = not defineFastFlag,
					offsetOptions = {
						defaultCameraOffset = CFrame.new(0, 0.5, -5),
						toolOffset = CFrame.new(0, 2, -8)
					},
					cameraFieldOfView = defineFastInt,
					resetCameraAndAutoRotationOnModelChange = true
				})
			end

			return nil
		end, { props.localPlayerModel }),
		localPlayerModel = props.localPlayerModel,
		analytics = props.analytics,
		avatarBackgroundImageUrl = avatarBackgroundImageUrl
	})

	useUnifiedEventListenerInExperience()

	if not FFlagAXEnableInspectAndBuyFocusNavigation then
		return (React.createElement(Foundation.View, {
			Size = v.OverlaySize,
			Position = v.OverlayPosition,
			backgroundStyle = v2.Color.Common.Shadow,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = function()
				GuiService:CloseInspectMenu()
			end
		}, {
			ContainerView = React.createElement(Foundation.View, {
				AnchorPoint = v.ContainerAnchorPoint,
				ClipsDescendants = true,
				Size = v.ContainerSize,
				Position = v.ContainerPosition,
				backgroundStyle = {
					Color3 = Theme.color("MenuContainer"),
					Transparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
				},
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				onActivated = function() end
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = Theme.DefaultCornerRadius
				}),
				ResponsivePanelLayout = React.createElement(ResponsivePanelLayout, v5)
			}),
			Overlay = React.createElement(Overlay2)
		}))
	end

	local v6 = useInspectAndBuyFocusNavigation()

	local element = React.createElement("Frame", {
		ref = v6.setFocusRef,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionGroup = v6.focusNavigationProps.SelectionGroup,
		SelectionBehaviorDown = v6.focusNavigationProps.SelectionBehaviorDown,
		SelectionBehaviorLeft = v6.focusNavigationProps.SelectionBehaviorLeft,
		SelectionBehaviorRight = v6.focusNavigationProps.SelectionBehaviorRight,
		SelectionBehaviorUp = v6.focusNavigationProps.SelectionBehaviorUp
	}, {
		Content = React.createElement(Foundation.View, {
			Size = v.OverlaySize,
			Position = v.OverlayPosition,
			backgroundStyle = v2.Color.Common.Shadow,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = function()
				GuiService:CloseInspectMenu()
			end
		}, {
			ContainerView = React.createElement(Foundation.View, {
				AnchorPoint = v.ContainerAnchorPoint,
				ClipsDescendants = true,
				Size = v.ContainerSize,
				Position = v.ContainerPosition,
				backgroundStyle = {
					Color3 = Theme.color("MenuContainer"),
					Transparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
				},
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				onActivated = function() end
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = Theme.DefaultCornerRadius
				}),
				ResponsivePanelLayout = React.createElement(ResponsivePanelLayout, v5)
			}),
			Overlay = React.createElement(Overlay2)
		})
	})

	return (React.createElement(PopoverFocusRestorationContext.Provider, { value = true }, {
		InspectAndBuyContent = element
	}))
end

local function InspectAndBuyBaseContainerWithSignalsProvider(p)
	return React.createElement(Provider, {}, {
		Inner = React.createElement(InspectAndBuyBaseContainer, p)
	})
end

return InspectAndBuyBaseContainerWithSignalsProvider
