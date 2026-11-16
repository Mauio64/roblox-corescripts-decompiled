local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local peekView = require("@luauforge/bundled/dzD").PeekView
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useProperty = require("@luauforge/bundled/frw").useProperty

local focusable = RoactGamepad.Focusable

local module = require("@luauforge/deferred/gnI")
local module2 = require("@luauforge/deferred/gnJ")
local module3 = require("@luauforge/deferred/gnK")

local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/deferred/gfX")

local module6 = require("@luauforge/deferred/gnM")
local module7 = require("@luauforge/deferred/gfW")

local module8 = require("@luauforge/deferred/ggb")
local module9 = require("@luauforge/deferred/gmf")
require("@luauforge/bundled/dMc")

local module10 = require("@luauforge/bundled/dMx")
local module11 = require("@luauforge/bundled/dRQ")

local module12 = require("@luauforge/bundled/fTi")
local module13 = require("@luauforge/bundled/eeH")
local module14 = require("@luauforge/bundled/eda")
local module15 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module15.FocusNavigationEventNameEnum

local module16 = require("@luauforge/deferred/gks")

local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local useStyle = UIBlox.Core.Style.useStyle

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useSellItemPeekViewFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local function isConfirmButtonDisabled(p2, value): boolean
	if not p2 then
		return true
	end

	local v5 = tonumber(p2)
	return not v5 or v5 < (value or 0)
end

local function getWhitespaceOffsetForPeekView(p2, p3, p4, p5)
	local v5 = not (p2 == nil or p3 == nil) and p4 ~= nil

	if not v5 then
		return -1
	end

	local v6 = math.clamp(p5 == nil and 0.8 or p5, 0, 1)
	return p2.Y * v6 - 25 - 20 - p3.Y - 30 - p4.Y - 30 - 30
end

local function getItemSubTypeName(p2, p3)
	if not p3 then
		return nil
	end

	if p2 == module10.ItemType.Bundle then
		return module10.BundleTypeIdStringToNameForBackend[p3] or module10.BundleTypeIdStringToName[p3]
	end

	if p2 == module10.ItemType.Asset then
		return module10.AssetTypeIdStringToName[p3]
	end

	return nil
end

local function SellItemPeekView(p2)
	local v5 = module12({
		sellItemText = "Feature.Catalog.Heading.SellItem",
		sellButtonText = "Feature.Catalog.Action.Sell",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})

	local v6 = useStyle()
	local theme = v6.Theme

	local v7 = useDispatch()
	local v8 = module13(module14)
	local v9 = useNavigation()

	local params = v9.state.params

	local state, setState = React.useState("")

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local v10 = useProperty(ref, "AbsoluteSize") or nil
	local v11 = useProperty(ref2, "AbsoluteSize") or nil
	local v12 = useProperty(ref3, "AbsoluteSize") or nil

	local peekViewFillPercentage = v9.state.params.peekViewFillPercentage
	local v13 = not (v10 == nil or v11 == nil) and v12 ~= nil
	local v14

	if v13 then
		local v15 = math.clamp(peekViewFillPercentage == nil and 0.8 or peekViewFillPercentage, 0, 1)
		v14 = v10.Y * v15 - 25 - 20 - v11.Y - 30 - v12.Y - 30 - 30
	else
		v14 = -1
	end

	local collectibleItemId = v9.state.params.collectibleItemId
	local v15 = useSelector(function(p3)
		return itemData(p3.AvatarExperience.Common, params.itemId, params.itemType)
	end, getUseSelectorDeepEquals())
	local itemSubType = module11.GetItemSubType(params.itemType, v15)
	local itemType = params.itemType
	local v16

	if itemSubType then
		if itemType == module10.ItemType.Bundle then
			v16 = module10.BundleTypeIdStringToNameForBackend[itemSubType]
				or module10.BundleTypeIdStringToName[itemSubType]
		elseif itemType == module10.ItemType.Asset then
			v16 = module10.AssetTypeIdStringToName[itemSubType]
		else
			v16 = nil
		end
	else
		v16 = nil
	end

	local v17 = useSelector(function(p3)
		local itemId = v9.state.params.itemId
		local itemType2 = v9.state.params.itemType
		local userAssetId = v9.state.params.userAssetId
		local v18 = itemData(p3.AvatarExperience.Common, itemId, itemType2)
		local averagePrice = v18 and v18.averagePrice

		local userAsset = p3.AvatarExperience.Catalog.UserAssets[userAssetId]

		local v20 = if userAsset ~= nil then userAsset.serialNumber else nil
		return { id = itemId, averagePrice = averagePrice, serialNumber = v20 }
	end, getUseSelectorDeepEquals())

	local v18 = useSelector(function(p3)
		if not collectibleItemId then
			return p3.AvatarExperience.Catalog.MarketplaceFee
		end

		local collectiblesMarketplaceResaleParameter = p3.AvatarExperience.Common.Collectibles.CollectiblesMarketplaceResaleParameters[collectibleItemId]

		if collectiblesMarketplaceResaleParameter == nil then
			return {}
		end

		return {
			taxRate = collectiblesMarketplaceResaleParameter.resalePercentageFee / 100,
			minimumFee = collectiblesMarketplaceResaleParameter.minimumFee
		}
	end, getUseSelectorDeepEquals())

	local v19 = useSelector(function(p3)
		local userAssetId = v9.state.params.userAssetId
		return performFetch.GetStatus(p3, module4.RemoveAvailableToSellAssetKey .. tostring(userAssetId))
	end, getUseSelectorDeepEquals())

	local v20 = useSelector(function(p3)
		return performFetch.GetStatus(p3, module4.GetMarketplaceFeeKey)
	end, getUseSelectorDeepEquals())

	local v21 = useSelector(function(p3)
		local v22 = module4.GetCollectibleMarketplaceResaleParametersKey .. tostring(collectibleItemId)
		return performFetch.GetStatus(p3, v22)
	end, getUseSelectorDeepEquals())

	local v22 = useSelector(function(p3)
		local collectiblesMarketplaceResaleParameter = p3.AvatarExperience.Common.Collectibles.CollectiblesMarketplaceResaleParameters[collectibleItemId]
		return collectiblesMarketplaceResaleParameter
			and collectiblesMarketplaceResaleParameter.priceFloor
			or 0
	end, getUseSelectorDeepEquals())

	React.useEffect(function()
		if collectibleItemId and (v21 == retrievalStatus.NotStarted or v21 == retrievalStatus.Failed) then
			v7(module6(v8, collectibleItemId, v16))
		elseif v20 == retrievalStatus.NotStarted or v20 == retrievalStatus.Failed then
			v7(module5(v8))
		end
	end, { v20, v21, collectibleItemId, v16 })

	local v23 = React.useCallback(function()
		v9.goBack()
		local onPeekViewClosed = v9.state.params.onPeekViewClosed

		if onPeekViewClosed then
			onPeekViewClosed()
		end
	end, { v9 })

	local v24 = React.useCallback(function(p3, p4)
		if p3 == peekViewState.Closed then
			v23()
		end
	end, { v23 })

	local v25 = useSellItemPeekViewFocusNavigationBindings(nil, v23)

	local v26 = React.useCallback(function()
		local v27 = state
		local v28 = v22
		local v29

		if v27 then
			local v30 = tonumber(v27)
			v29 = not v30 or v30 < (v28 or 0)
		else
			v29 = true
		end

		if v29 then
			return
		end

		local id = v17.id
		local userAssetId = v9.state.params.userAssetId
		local v30 = tonumber(state)

		if collectibleItemId then
			v7(module8(v8, collectibleItemId, userAssetId, true, v30))
		else
			v7(module7(v8, id, userAssetId, v30))
		end

		v23()
	end, { v23, state, v17, v9, v8, collectibleItemId, v22 })

	local v27 = React.useCallback(function()
		local font = v6.Font
		local header1 = font.Header1
		local v28 = header1.RelativeSize * font.BaseSize

		local createElement = React.createElement
		local v30 = {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1
		}

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 30)
			}),
			SellItemHeader = 0,
			ItemInfoContent = 0,
			SetPriceContent = 0,
			OverviewContent = 0
		}

		local createElement2 = React.createElement
		local v32 = {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v5.sellItemText,
			Font = 0,
			FontFace = 0,
			Size = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1
		}
		local v33 = if not foundationFontFaceMigration then header1.Font else nil
		v32.Font = v33

		local v34 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.HeadingSmall.Font) else nil
		v32.FontFace = v34

		v32.Size = UDim2.fromScale(1, 0)
		v32.TextSize = v28
		v32.TextXAlignment = Enum.TextXAlignment.Left
		v32.TextYAlignment = Enum.TextYAlignment.Top
		v32.TextColor3 = theme.TextEmphasis.Color
		v32.TextTransparency = theme.TextEmphasis.Transparency
		children.SellItemHeader = createElement2("TextLabel", v32)

		children.ItemInfoContent = React.createElement(module, {
			layoutOrder = 2,
			itemIdPriceSerialNumber = v17
		})

		local createElement3 = React.createElement
		local v36 = {
			layoutOrder = 3,
			priceFloor = v22,
			priceInRobux = state,
			setPriceInRobux = setState,
			ref = 0,
			NextSelectionDown = 0
		}

		local v37 = if module16() then ref4 else nil
		v36.ref = v37
		local v38 = if module16() then ref3 else nil
		v36.NextSelectionDown = v38
		children.SetPriceContent = createElement3(module2, v36)

		children.OverviewContent = React.createElement(module3, {
			layoutOrder = 4,
			marketplaceFee = v18,
			priceInRobux = state
		})
		return createElement("Frame", v30, children)
	end, { v6, theme, v5, v17, state, setState, v18 })

	local v28 = React.useCallback(function()
		if v20 ~= retrievalStatus.Fetching then
			v7(module5(v8))
		end
	end, { v20, v8 })

	local v29 = React.useCallback(function()
		if v21 ~= retrievalStatus.Fetching then
			v7(module6(v8, collectibleItemId, v16))
		end
	end, { v21, v8, collectibleItemId, v16 })

	local v32 = {
		props = { onActivated = v23, text = v5.cancelButtonText },
		isDefaultChild = true
	}

	local v33 = {
		buttonType = buttonType.PrimarySystem,
		props = 0,
		isDefaultChild = false
	}
	local v35

	if state then
		local v36 = tonumber(state)
		v35 = not v36 or v36 < (v22 or 0)
	else
		v35 = true
	end

	v33.props = {
		isDisabled = v35,
		isLoading = v19 == retrievalStatus.Fetching or v20 == retrievalStatus.Fetching or v21 == retrievalStatus.Fetching,
		onActivated = v26,
		text = v5.sellButtonText
	}
	local v30 = {
		buttons = { v32, v33 }
	}

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v39 = not module16() and "Frame" or focusable.Frame
	local v40 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		defaultChild = 0,
		ref = 0
	}

	local v41 = if module16() then ref4 else nil
	v40.defaultChild = v41
	v40.ref = ref

	local createElement3 = React.createElement
	local v44 = {
		mountAsFullView = true,
		isScrollingEnabled = false,
		showDraggerInClosedState = false,
		peekHeaderClose = true,
		viewStateChanged = v24,
		canDragFullViewToBrief = false,
		thumbstickScrollEnabled = false,
		backgroundColor3 = theme.BackgroundDefault.Color,
		backgroundTransparency = theme.BackgroundUIDefault.Transparency,
		shouldCaptureFocus = false
	}

	local createElement4 = React.createElement
	local v47 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ref = v25
	}

	local children = {
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
		ItemInfoContentFrame = 0,
		WhiteSpaceFrame = 0,
		Footer = 0
	}

	local createElement5 = React.createElement
	local v49 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ref = ref2
	}

	local createElement6 = React.createElement

	local v53 = if collectibleItemId then retrievalStatus2.fromRawValue(v21) else retrievalStatus2.fromRawValue(v20)

	if collectibleItemId then
		v28 = v29
	end

	children.ItemInfoContentFrame = createElement5("Frame", v49, {
		Content = createElement6(loadingStateContainer, {
			dataStatus = v53,
			onRetry = v28,
			renderOnLoaded = v27
		})
	})

	children.WhiteSpaceFrame = v14 >= 0
		and React.createElement("Frame", {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, v14),
			BackgroundTransparency = 1
		})

	local createElement7 = React.createElement
	local frame = focusable.Frame
	local v55 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ref = ref3,
		NextSelectionUp = 0
	}

	local v56 = if module16() then ref4 else nil
	v55.NextSelectionUp = v56
	children.Footer = createElement7(frame, v55, {
		Buttons = v30 and React.createElement(buttonStack, v30)
	})
	return createElement(module9, { backgroundTransparency = 1 }, {
		FullSizeFrame = createElement2(v39, v40, {
			PeekView = createElement3(peekView, v44, {
				ContentContainer = createElement4("Frame", v47, children)
			})
		})
	})
end

return SellItemPeekView
