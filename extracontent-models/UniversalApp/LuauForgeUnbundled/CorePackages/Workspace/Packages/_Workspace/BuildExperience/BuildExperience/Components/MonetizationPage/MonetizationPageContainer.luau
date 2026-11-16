require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperProduct")
local DeveloperSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperSubscription")
local GamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePassConfig")
local GamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePermissions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/MonetizationOptions")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local createManageDevProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductStore")
local createManageMonetizationOptionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageMonetizationOptionsStore")
local MonetizationPageView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageView")
local getProductKindCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/getProductKindCapabilities")
local mapDeveloperProductsToMonetizationProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/mapDeveloperProductsToMonetizationProducts")
local mapMonetizationCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/mapMonetizationCatalog")
local useMonetizationPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/useMonetizationPageViewModel")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceMonetizationMultiKind = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationMultiKind")

local FFlagBuildExperienceMonetizationProductEditing = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationProductEditing")
local FFlagBuildExperienceMonetizationManageKinds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationManageKinds")

local FFlagBuildExperienceMonetizationKindRegionalPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationKindRegionalPricing")

local FFlagBuildExperienceDevProductModerationReadback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductModerationReadback")
local v5 = FFlagBuildExperienceManageDevProduct or FFlagBuildExperienceMonetizationNativeUI

local function normalizeSourceStatus(p2, p3): string
	if p3 or p2 == "Failed" then
		return "Failed"
	end

	if p2 == "Ready" then
		return "Ready"
	end

	return "NotReady"
end

local signal = Signals.createSignal(nil)
local signal2 = Signals.createSignal(nil)
local signal3 = Signals.createSignal(nil)
local signal4 = Signals.createSignal(nil)
local signal5 = Signals.createSignal(nil)
local signal6 = Signals.createSignal(nil)
local signal7 = Signals.createSignal(nil)
local signal8 = Signals.createSignal("Ready")
local signal9 = Signals.createSignal("NotReady")
local computed = Signals.createComputed(function()
	return createManageDevProductStore()
end)

local computed2 = Signals.createComputed(function()
	return createManageMonetizationOptionsStore()
end)

local function combineCatalogStatus(items)
	local v6 = "Ready"

	for k, item in items do
		if item.status == "Failed" then
			return "Failed"
		end

		if item.status ~= "Ready" then
			v6 = "NotReady"
		end
	end

	return v6
end

local function useMixedCatalog(props, p2, p3, p4, data, p5)
	local v6 = SignalsReact.useSignalState(GamePassConfig.getGamePassConfigStore)
	local v7 = SignalsReact.useSignalState(DeveloperSubscription.getDeveloperSubscriptionStore)
	local v8 = SignalsReact.useSignalState(v6.getAccountResetGeneration)
	local v9 = SignalsReact.useSignalState(v7.getAccountResetGeneration)
	local v10 = React.useMemo(function()
		if props.products == nil and props.universeId ~= nil then
			return v6.fetchGamePasses(props.universeId)
		end

		return nil
	end, {
		v8,
		v6,
		props.products ~= nil,
		props.universeId or 0
	})

	local v11 = React.useMemo(function()
		if props.products == nil and props.universeId ~= nil then
			return v7.fetchSubscriptions(props.universeId)
		end

		return nil
	end, {
		props.products ~= nil,
		props.universeId or 0,
		v9,
		v7
	})

	local useSignalState = SignalsReact.useSignalState
	local v12 = if v10 == nil then signal2 else v10.data
	local v13 = useSignalState(v12)
	local useSignalState2 = SignalsReact.useSignalState
	local v14 = if v10 == nil then signal8 else v10.status
	local v15 = useSignalState2(v14)

	local useSignalState3 = SignalsReact.useSignalState
	local v16 = if v11 == nil then signal3 else v11.data
	local v17 = useSignalState3(v16)

	local useSignalState4 = SignalsReact.useSignalState
	local v18 = if v11 == nil then signal8 else v11.status
	local v19 = useSignalState4(v18)

	local v20 = not (p3 == nil) and p3.nextPageToken ~= nil
	local v21 = not (v13 == nil) and v13.isIncomplete == true
	local v22 = not (v17 == nil) and v17.isIncomplete == true
	local v23 = (v20 or p4 == "Failed") and "Failed" or p4 == "Ready" and "Ready" or "NotReady"
	local v24 = (v21 or v15 == "Failed") and "Failed" or v15 == "Ready" and "Ready" or "NotReady"
	local v25 = (v22 or v19 == "Failed") and "Failed" or v19 == "Ready" and "Ready" or "NotReady"

	local v26 = React.useMemo(function()
		if props.products ~= nil then
			return {}
		end

		return {
			{
				kind = "GamePass",
				label = data.gamePassSection,
				status = v24,
				hasCachedProducts = v13 ~= nil and #v13.gamePasses > 0,
				isIncomplete = v21
			},
			{
				kind = "DeveloperProduct",
				label = data.productSection,
				status = v23,
				hasCachedProducts = p3 ~= nil and #p3.developerProducts > 0,
				isIncomplete = v20
			},
			{
				kind = "Subscription",
				label = data.subscriptionSection,
				status = v25,
				hasCachedProducts = v17 ~= nil and #v17.developerSubscriptions > 0,
				isIncomplete = v22
			}
		}
	end, {
		v23,
		v24,
		p3 == nil and 0 or #p3.developerProducts,
		v13 == nil and 0 or #v13.gamePasses,
		v17 == nil and 0 or #v17.developerSubscriptions,
		v20,
		v21,
		v22,
		data.gamePassSection,
		data.productSection,
		data.subscriptionSection,
		props.products ~= nil,
		v25
	})

	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if ref2.current ~= props.universeId then
			ref2.current = props.universeId
			table.clear(ref.current)
		end

		for k, v27 in v26 do
			if v27.status == "NotReady" then
				ref.current[v27.kind] = nil
			elseif ref.current[v27.kind] ~= v27.status then
				ref.current[v27.kind] = v27.status
				sendBuildExperienceEvent(
					v27.status == "Ready" and "MONETIZATION_CATALOG_LOAD_SUCCESS" or "MONETIZATION_CATALOG_LOAD_FAILURE",
					{
						universeId = props.universeId,
						placeId = props.placeId,
						conversationId = props.sessionId
					},
					{
						catalogKind = tostring(v27.kind),
						hasCachedProducts = tostring(v27.hasCachedProducts),
						isIncomplete = tostring(v27.isIncomplete)
					}
				)
			end
		end
	end, { v26, props.placeId, props.sessionId, props.universeId })
	local v27 = React.useCallback(function()
		if props.products == nil and props.universeId ~= nil then
			p2.fetchProducts(props.universeId)
			v6.fetchGamePasses(props.universeId)
			v7.fetchSubscriptions(props.universeId)
		end
	end, { p2, v6, props.products, props.universeId, v7 })

	local v28 = React.useCallback(function(p6)
		if props.products ~= nil or props.universeId == nil then
			return
		end

		if p6 == "DeveloperProduct" then
			p2.fetchProducts(props.universeId)
		elseif p6 == "GamePass" then
			v6.fetchGamePasses(props.universeId)
		elseif p6 == "Subscription" then
			v7.fetchSubscriptions(props.universeId)
		end
	end, { p2, v6, props.products, props.universeId, v7 })

	local v29 = React.useCallback(function(p6, p7, p8)
		local universeId = props.universeId
		local v30 = getProductKindCapabilities(p6)

		if universeId == nil or v30 == nil then
			return Promise.reject("This product cannot be changed from here")
		end

		if p6 == "GamePass" then
			local v31 = tonumber(p7)

			if v31 == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p8.isForSale == nil then
				local function write()
					return v6.update(universeId, v31, {
						isManagedPricingEnabled = p8.isManagedPricingEnabled
					})
				end

				if p8.isManagedPricingEnabled == true then
					return (p5.ensureManagedPricingAccepted(universeId):andThen(write))
				end

				return (v6.update(universeId, v31, {
					isManagedPricingEnabled = p8.isManagedPricingEnabled
				}))
			elseif p8.isForSale then
				return (v6.activate(universeId, v31))
			else
				return (v6.deactivate(universeId, v31))
			end
		else
			if p8.isForSale == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p8.isForSale then
				return (v7.activate(universeId, p7))
			end

			return (v7.deactivate(universeId, p7, false))
		end
	end, {
		v6,
		p5,
		props.universeId or 0,
		v7
	})
	local v30

	if FFlagBuildExperienceMonetizationManageKinds then
		v30 = React.useCallback(function(p6, p7, data2)
			local universeId = props.universeId

			if universeId == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p6 == "GamePass" then
				local v31 = tonumber(p7)

				if v31 == nil then
					return Promise.reject("This product cannot be changed from here")
				end

				return v6.update(
					universeId,
					v31,
					{
						name = data2.name,
						description = data2.description,
						priceInRobux = data2.priceInRobux
					},
					{ acceptModeratedText = true }
				)
			elseif p6 == "Subscription" then
				return v7.update(universeId, p7, { description = data2.description }, {
					acceptModeratedText = true
				}):andThen(function(data3)
					return {
						name = data3.name,
						description = data3.description,
						priceInformation = data3.currencyType == DeveloperSubscription.CurrencyType.Robux and {
							defaultPriceInRobux = data3.priceInRobux
						} or nil
					}
				end)
			else
				return Promise.reject("This product cannot be changed from here")
			end
		end, { v6, props.universeId or 0, v7 })
	end

	local v31 = nil
	local v32

	if FFlagBuildExperienceMonetizationManageKinds then
		v32 = React.useCallback(function(p6, p7, p8)
			return v29(p6, p7, { isForSale = p8 })
		end, { v29 })
	end

	if FFlagBuildExperienceMonetizationKindRegionalPricing then
		v31 = React.useCallback(function(p6, p7, p8)
			return v29(p6, p7, { isManagedPricingEnabled = p8 })
		end, { v29 })
	end

	local v33 = {
		gamePassCatalog = v13,
		subscriptionCatalog = v17,
		catalogSources = v26,
		status = 0,
		onRetryAll = 0,
		onRetrySource = 0,
		onUpdateSaleStatus = 0,
		onUpdateManagedPricing = 0,
		onUpdateProductDetails = 0
	}
	local v34 = "Ready"

	for k, v36 in v26 do
		if v36.status == "Failed" then
			v34 = "Failed"
			break
		elseif v36.status ~= "Ready" then
			v34 = "NotReady"
		end
	end

	v33.status = v34
	v33.onRetryAll = v27
	v33.onRetrySource = v28
	v33.onUpdateSaleStatus = v32
	v33.onUpdateManagedPricing = v31
	v33.onUpdateProductDetails = v30
	return v33
end

local function getProductLocalizationKeys()
	local productLocalizationKeys = {
		priceUnavailable = LocalizationStrings.MONETIZATION_PRICE_UNAVAILABLE,
		productType = LocalizationStrings.AGENT_DEV_PRODUCT_TITLE,
		productSection = 0,
		gamePassType = 0,
		gamePassSection = 0,
		subscriptionType = 0,
		subscriptionSection = 0,
		onSale = 0,
		offSale = 0
	}

	local v6 = if FFlagBuildExperienceMonetizationMultiKind then LocalizationStrings.MONETIZATION_DEVELOPER_PRODUCTS else nil
	productLocalizationKeys.productSection = v6

	local v7 = if FFlagBuildExperienceMonetizationMultiKind then LocalizationStrings.MONETIZATION_GAME_PASS else nil
	productLocalizationKeys.gamePassType = v7

	local v8 = if FFlagBuildExperienceMonetizationMultiKind then LocalizationStrings.MONETIZATION_PASSES else nil
	productLocalizationKeys.gamePassSection = v8

	local v9 = if FFlagBuildExperienceMonetizationMultiKind then LocalizationStrings.AGENT_SUBSCRIPTION_TITLE else nil
	productLocalizationKeys.subscriptionType = v9

	local v10 = if FFlagBuildExperienceMonetizationMultiKind then LocalizationStrings.MONETIZATION_SUBSCRIPTIONS else nil
	productLocalizationKeys.subscriptionSection = v10

	productLocalizationKeys.onSale = LocalizationStrings.MONETIZATION_ON_SALE
	productLocalizationKeys.offSale = LocalizationStrings.MONETIZATION_OFF_SALE
	return productLocalizationKeys
end

local function useResultState(p2, p3)
	local useSignalState = SignalsReact.useSignalState

	if p2 ~= nil then
		p3 = p2.data
	end

	local v6 = useSignalState(p3)
	local useSignalState2 = SignalsReact.useSignalState
	local v7 = if p2 == nil then signal9 else p2.status
	return v6, (useSignalState2(v7))
end

local function MonetizationPageContainer(props)
	local v6 = React.useContext(Localization.LocalizationRoactContext)
	local v7 = Localization.Hooks.useLocalization(getProductLocalizationKeys())

	local v8 = computed()
	local v9, v10

	if FFlagBuildExperienceMonetizationNativeUI then
		v9 = computed2()

		v10 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	else
		v10 = nil
		v9 = nil
	end

	local v11

	if FFlagBuildExperienceMonetizationNativeUI then
		v11 = React.useMemo(function()
			if v10 == nil or props.universeId == nil then
				return nil
			end

			return v10.getAndFetchSummary(props.universeId)
		end, { props.universeId, v10 })
	end

	local v12, v13

	if FFlagBuildExperienceMonetizationNativeUI then
		local v14 = signal4
		local useSignalState = SignalsReact.useSignalState

		if v11 ~= nil then
			v14 = v11.data
		end

		v12 = useSignalState(v14)
		local useSignalState2 = SignalsReact.useSignalState
		local v15 = if v11 == nil then signal9 else v11.status
		v13 = useSignalState2(v15)
	else
		v12 = nil
		v13 = "NotReady"
	end

	local v14

	if FFlagBuildExperienceMonetizationNativeUI then
		v14 = React.useMemo(function()
			if props.universeId == nil then
				return nil
			end

			if FFlagBuildCheckGamePermissions then
				local fetchUniversePermissions = GamePermissions.getGamePermissionsStore().getAndFetchUniversePermissions(props.universeId)
				return {
					data = Signals.createComputed(function(p2)
						local data = fetchUniversePermissions.data(p2)

						if data == nil then
							return nil
						end

						return { canMonetize = data.canMonetize }
					end),
					status = fetchUniversePermissions.status
				}
			end

			if v9 == nil or v12 == nil then
				return nil
			end

			return v9.getAndFetchPermission(props.universeId, v12.creatorType, v12.creatorTargetId)
		end, { v9, props.universeId, v12 })
	end

	local v15, v16

	if FFlagBuildExperienceMonetizationNativeUI then
		local v17 = signal5
		local useSignalState = SignalsReact.useSignalState

		if v14 ~= nil then
			v17 = v14.data
		end

		v15 = useSignalState(v17)
		local useSignalState2 = SignalsReact.useSignalState
		local v18 = if v14 == nil then signal9 else v14.status
		v16 = useSignalState2(v18)

		if not FFlagBuildCheckGamePermissions and v13 == "Failed" then
			v16 = "Failed"
		end
	else
		v16 = "NotReady"
	end

	local v17

	if FFlagBuildExperienceMonetizationNativeUI then
		v17 = React.useMemo(function()
			if v9 == nil or props.universeId == nil then
				return nil
			end

			return v9.getAndFetchManagedPricing(props.universeId)
		end, { v9, props.universeId })
	end

	local v18

	if FFlagBuildExperienceMonetizationNativeUI then
		v18 = React.useMemo(function()
			if v9 == nil or props.universeId == nil then
				return nil
			end

			return v9.getAndFetchShops(props.universeId)
		end, { v9, props.universeId })
	end

	local v19, v20, v21, v22

	if FFlagBuildExperienceMonetizationNativeUI then
		local v23 = signal6
		local useSignalState = SignalsReact.useSignalState

		if v17 ~= nil then
			v23 = v17.data
		end

		v19 = useSignalState(v23)
		local useSignalState2 = SignalsReact.useSignalState
		local v24 = if v17 == nil then signal9 else v17.status
		v20 = useSignalState2(v24)

		local v25 = signal7
		local useSignalState3 = SignalsReact.useSignalState

		if v18 ~= nil then
			v25 = v18.data
		end

		v21 = useSignalState3(v25)
		local useSignalState4 = SignalsReact.useSignalState
		local v26 = if v18 == nil then signal9 else v18.status
		v22 = useSignalState4(v26)
	else
		v20 = "NotReady"
		v22 = "NotReady"
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local ref = React.useRef({})

		local ref2 = React.useRef(nil)

		React.useEffect(function()
			if props.universeId == nil then
				return
			end

			if ref2.current ~= props.universeId then
				ref2.current = props.universeId
				table.clear(ref.current)
			end

			local function reportStatus(p2, p3)
				if p3 ~= "NotReady" and ref.current[p2] ~= p3 then
					ref.current[p2] = p3
					sendBuildExperienceEvent(
						p3 == "Ready" and "MONETIZATION_OPTIONS_LOAD_SUCCESS" or "MONETIZATION_OPTIONS_LOAD_FAILURE",
						{
							universeId = props.universeId,
							placeId = props.placeId,
							conversationId = props.sessionId
						},
						{ resource = p2 }
					)
				end
			end
			reportStatus("permission", v16)
			reportStatus("managed_pricing", v20)
			reportStatus("shops", v22)
		end, { v20, v16, props.placeId, props.sessionId, props.universeId, v22 })
	end

	local v23

	if FFlagBuildExperienceMonetizationMultiKind then
		v23 = v16 == "Ready" and v15 ~= nil and v15.canMonetize == true
	else
		v23 = not FFlagBuildExperienceMonetizationNativeUI or v16 ~= "Ready" or v15 == nil or v15.canMonetize == true
	end

	local v24 = not FFlagBuildExperienceMonetizationMultiKind and 0 or SignalsReact.useSignalState(v8.getAccountResetGeneration)
	local v25

	if FFlagBuildExperienceMonetizationMultiKind then
		v25 = {
			v24,
			v8,
			props.products ~= nil,
			props.universeId or 0
		}
	else
		v25 = { v8, props.products ~= nil, props.universeId or 0 }
	end

	local v26 = React.useMemo(function()
		if props.products ~= nil or props.universeId == nil then
			return nil
		end

		if v5 then
			return (v8.fetchProducts(props.universeId))
		end

		return (v8.getAndFetchProducts(props.universeId))
	end, v25)

	local useSignalState = SignalsReact.useSignalState
	local v27 = if v26 == nil then signal else v26.data
	local v28 = useSignalState(v27)

	local useSignalState2 = SignalsReact.useSignalState
	local v29 = if v26 == nil then signal8 else v26.status
	local v30 = useSignalState2(v29)
	local v31

	if FFlagBuildExperienceMonetizationMultiKind then
		v31 = useMixedCatalog(
			props,
			v8,
			v28,
			v30,
			{
				productSection = v7.productSection,
				gamePassSection = v7.gamePassSection,
				subscriptionSection = v7.subscriptionSection
			},
			v9
		)
	end

	local gamePassCatalog = if v31 ~= nil then v31.gamePassCatalog else nil
	local subscriptionCatalog = if v31 ~= nil then v31.subscriptionCatalog else nil
	local v32 = React.useMemo(function()
		if props.products ~= nil then
			return props.products
		end

		local function fn(p2)
			return v6:Format(LocalizationStrings.MONETIZATION_DEFAULT_PRODUCT_NAME, {
				PRODUCT_ID = p2
			})
		end

		if FFlagBuildExperienceMonetizationMultiKind then
			return mapMonetizationCatalog(
				{
					developerProducts = v28,
					gamePasses = gamePassCatalog,
					subscriptions = subscriptionCatalog
				},
				{
					formatDefaultProductName = fn,
					priceUnavailable = v7.priceUnavailable,
					developerProductType = v7.productType,
					gamePassType = v7.gamePassType,
					subscriptionType = v7.subscriptionType,
					onSale = v7.onSale,
					offSale = v7.offSale
				}
			)
		end

		return mapDeveloperProductsToMonetizationProducts(v28, {
			formatDefaultProductName = fn,
			priceUnavailable = v7.priceUnavailable,
			productType = v7.productType,
			onSale = v7.onSale,
			offSale = v7.offSale
		})
	end, { v28, v7, v6, props.products, gamePassCatalog, subscriptionCatalog })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if FFlagBuildExperienceMonetizationMultiKind or v26 == nil then
			return
		end

		if v30 == "NotReady" then
			ref.current = nil
			return
		end

		if ref.current == v30 then
			return
		end

		ref.current = v30
		sendBuildExperienceEvent(
			v30 == "Ready" and "MONETIZATION_CATALOG_LOAD_SUCCESS" or "MONETIZATION_CATALOG_LOAD_FAILURE",
			{
				universeId = props.universeId,
				placeId = props.placeId,
				conversationId = props.sessionId
			}
		)
	end, { v26, v30, props.placeId, props.sessionId, props.universeId })

	local v33 = React.useCallback(function()
		if props.products == nil and props.universeId ~= nil then
			v8.fetchProducts(props.universeId)
		end
	end, { v8, props.products, props.universeId })

	if v31 ~= nil then
		v33 = v31.onRetryAll
	end

	local onRetrySource = if v31 ~= nil then v31.onRetrySource else nil
	local v34 = React.useCallback(function(p2, p3)
		local function fn()
			return v8.update(props.universeId, p2, { isManagedPricingEnabled = p3 })
		end

		if FFlagBuildExperienceMonetizationNativeUI and p3 then
			return v9.ensureManagedPricingAccepted(props.universeId):andThen(fn)
		end

		return fn()
	end, { v8, v9, props.universeId })
	local v35 = React.useCallback(function(p2, p3)
		return v8.update(props.universeId, p2, { isForSale = p3 })
	end, { v8, props.universeId })
	local v36 = React.useCallback(function(p2, p3)
		return v8.update(props.universeId, p2, p3, FFlagBuildExperienceDevProductModerationReadback)
	end, { v8, props.universeId })
	local v37, v38, v39, v40

	if FFlagBuildExperienceMonetizationNativeUI then
		v37 = React.useCallback(function()
			return v9.acceptManagedPricing(props.universeId)
		end, { v9, props.universeId })

		v38 = React.useCallback(function(p2, p3)
			local function refreshProducts()
				return v8.list(props.universeId):catch(function(): nil
					return nil
				end)
			end

			return v9.updateDeveloperProductsManagedPricing(props.universeId, p2, p3):andThen(function(p4)
				return v8.list(props.universeId):catch(function(): nil
					return nil
				end):andThen(function()
					return p4
				end)
			end, function(p4)
				return v8.list(props.universeId):catch(function(): nil
					return nil
				end):andThen(function()
					return Promise.reject(p4)
				end)
			end)
		end, { v8, v9, props.universeId })

		v39 = React.useCallback(function(p2)
			return v9.setShopGlobalIcon(props.universeId, p2)
		end, { v9, props.universeId })

		v40 = React.useCallback(function()
			local v41 = v9
			v41.fetchManagedPricing(props.universeId)
			v41.fetchShops(props.universeId)

			if FFlagBuildCheckGamePermissions then
				GamePermissions.getGamePermissionsStore().fetchUniversePermissions(props.universeId)
			elseif v12 == nil or v13 == "Failed" then
				v10.fetchSummary(props.universeId)
			else
				v41.fetchPermission(props.universeId, v12.creatorType, v12.creatorTargetId)
			end
		end, { v9, props.universeId, v12, v13, v10 })
	end

	local clone = table.clone(props)
	clone.products = v32

	if FFlagBuildCheckGamePermissions then
		clone.canEditOnBuild = useGamePermissions({ universeId = props.universeId }).canEditOnBuild
	end

	clone.showOptions = FFlagBuildExperienceMonetizationNativeUI and (props.showOptions == true or props.universeId ~= nil)

	if FFlagBuildExperienceMonetizationNativeUI and props.universeId ~= nil then
		local v41 = if v19 ~= nil then v19.status else nil
		clone.managedPricingStatus = v41
		local v42 = if v21 ~= nil then v21.shops else nil
		clone.shops = v42
		local v43 = if v15 ~= nil then v15.canMonetize else nil
		clone.permissionCanMonetize = v43
		clone.managedPricingLoadStatus = v20
		clone.shopsLoadStatus = v22
		clone.permissionLoadStatus = v16
		clone.onAcceptManagedPricing = v37
		clone.onUpdateManagedPricing = v38
		clone.onSetShopButton = v39
		clone.onRetryOptions = v40
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		local v41 = if props.products == nil then v31.catalogSources else nil
		clone.catalogSources = v41
		clone.onRetryCatalogSource = onRetrySource
		clone.catalogStatus = v31.status
	elseif v30 == "Ready" then
		clone.catalogStatus = "Ready"
	elseif v30 == "Failed" then
		clone.catalogStatus = "Failed"
	else
		clone.catalogStatus = "NotReady"
	end

	clone.onRetryCatalog = v33

	if props.universeId == nil or not v23 then
		v34 = nil
	end

	clone.onUpdateProductManagedPricing = v34

	if FFlagBuildExperienceMonetizationProductEditing and props.universeId ~= nil and v23 then
		clone.onUpdateProductSaleStatus = v35
		clone.onUpdateProduct = v36

		if FFlagBuildExperienceMonetizationManageKinds then
			clone.onUpdateProductKindSaleStatus = v31.onUpdateSaleStatus
			clone.onUpdateProductKind = v31.onUpdateProductDetails
		end

		if FFlagBuildExperienceMonetizationKindRegionalPricing then
			clone.onUpdateProductKindManagedPricing = v31.onUpdateManagedPricing
		end
	end

	local v41 = useMonetizationPageViewModel(clone)
	return React.createElement(MonetizationPageView, v41)
end

return MonetizationPageContainer
