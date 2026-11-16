local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.DeveloperProduct)
local DeveloperSubscription = require(parent.DataHydration.DeveloperSubscription)
local GamePassConfig = require(parent.DataHydration.GamePassConfig)
local GamePermissions = require(parent.DataHydration.GamePermissions)
require(parent.DataHydration.MonetizationOptions)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local Localization = require(parent.Localization)
local Promise = require(parent.Promise)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local createManageDevProductStore = require(BuildExperience.Chat.createManageDevProductStore)
local createManageMonetizationOptionsStore = require(BuildExperience.Chat.createManageMonetizationOptionsStore)
local MonetizationPageView = require(script.Parent.MonetizationPageView)
local getProductKindCapabilities = require(script.Parent.getProductKindCapabilities)
local mapDeveloperProductsToMonetizationProducts = require(script.Parent.mapDeveloperProductsToMonetizationProducts)
local mapMonetizationCatalog = require(script.Parent.mapMonetizationCatalog)
local useMonetizationPageViewModel = require(script.Parent.useMonetizationPageViewModel)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceMonetizationMultiKind = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationMultiKind)

local FFlagBuildExperienceMonetizationProductEditing = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationProductEditing)
local FFlagBuildExperienceMonetizationManageKinds = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationManageKinds)

local FFlagBuildExperienceMonetizationKindRegionalPricing = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationKindRegionalPricing)

local FFlagBuildExperienceDevProductModerationReadback = require(BuildExperience.Flags.FFlagBuildExperienceDevProductModerationReadback)
local v = FFlagBuildExperienceManageDevProduct or FFlagBuildExperienceMonetizationNativeUI

local function normalizeSourceStatus(p: string, flag: boolean): string
	if flag or p == "Failed" then
		return "Failed"
	end

	return if p == "Ready" then "Ready" else "NotReady"
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

local function combineCatalogStatus(items) -- 1 equivalent call inferred from this helper
	local v2 = "Ready"

	for _, item in items do
		if item.status == "Failed" then
			return "Failed"
		end

		if item.status ~= "Ready" then
			v2 = "NotReady"
		end
	end

	return v2
end

local function useMixedCatalog(props, p, p2, p3, data, p4)
	local v2 = SignalsReact.useSignalState(GamePassConfig.getGamePassConfigStore)
	local v3 = SignalsReact.useSignalState(DeveloperSubscription.getDeveloperSubscriptionStore)
	local v4 = SignalsReact.useSignalState(v2.getAccountResetGeneration)
	local v5 = SignalsReact.useSignalState(v3.getAccountResetGeneration)
	local v6 = React.useMemo(function()
		if props.products == nil and props.universeId ~= nil then
			return v2.fetchGamePasses(props.universeId)
		end

		return nil
	end, {
		v4,
		v2,
		props.products ~= nil,
		props.universeId or 0
	})

	local v7 = React.useMemo(function()
		if props.products == nil and props.universeId ~= nil then
			return v3.fetchSubscriptions(props.universeId)
		end

		return nil
	end, {
		props.products ~= nil,
		props.universeId or 0,
		v5,
		v3
	})

	local useSignalState = SignalsReact.useSignalState
	local v8 = if v6 == nil then signal2 else v6.data
	local gamePassCatalog = useSignalState(v8)
	local useSignalState2 = SignalsReact.useSignalState
	local v9 = if v6 == nil then signal8 else v6.status
	local v10 = useSignalState2(v9)

	local useSignalState3 = SignalsReact.useSignalState
	local v11 = if v7 == nil then signal3 else v7.data
	local subscriptionCatalog = useSignalState3(v11)

	local useSignalState4 = SignalsReact.useSignalState
	local v12 = if v7 == nil then signal8 else v7.status
	local v13 = useSignalState4(v12)
	local isIncomplete

	if p2 == nil then
		isIncomplete = false
	else
		isIncomplete = p2.nextPageToken ~= nil
	end

	local isIncomplete2

	if gamePassCatalog == nil then
		isIncomplete2 = false
	else
		isIncomplete2 = gamePassCatalog.isIncomplete == true
	end

	local isIncomplete3

	if subscriptionCatalog == nil then
		isIncomplete3 = false
	else
		isIncomplete3 = subscriptionCatalog.isIncomplete == true
	end

	local status = (isIncomplete or p3 == "Failed") and "Failed" or p3 == "Ready" and "Ready" or "NotReady"
	local status2 = (isIncomplete2 or v10 == "Failed") and "Failed" or v10 == "Ready" and "Ready" or "NotReady"
	local status3 = (isIncomplete3 or v13 == "Failed") and "Failed" or v13 == "Ready" and "Ready" or "NotReady"

	local catalogSources = React.useMemo(function()
		if props.products ~= nil then
			return {}
		end

		return {
			{
				kind = "GamePass",
				label = data.gamePassSection,
				status = status2,
				hasCachedProducts = gamePassCatalog ~= nil and #gamePassCatalog.gamePasses > 0,
				isIncomplete = isIncomplete2
			},
			{
				kind = "DeveloperProduct",
				label = data.productSection,
				status = status,
				hasCachedProducts = p2 ~= nil and #p2.developerProducts > 0,
				isIncomplete = isIncomplete
			},
			{
				kind = "Subscription",
				label = data.subscriptionSection,
				status = status3,
				hasCachedProducts = subscriptionCatalog ~= nil and #subscriptionCatalog.developerSubscriptions > 0,
				isIncomplete = isIncomplete3
			}
		}
	end, {
		status,
		status2,
		p2 == nil and 0 or #p2.developerProducts,
		gamePassCatalog == nil and 0 or #gamePassCatalog.gamePasses,
		subscriptionCatalog == nil and 0 or #subscriptionCatalog.developerSubscriptions,
		isIncomplete,
		isIncomplete2,
		isIncomplete3,
		data.gamePassSection,
		data.productSection,
		data.subscriptionSection,
		props.products ~= nil,
		status3
	})

	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if ref2.current ~= props.universeId then
			ref2.current = props.universeId
			table.clear(ref.current)
		end

		for _, v14 in catalogSources do
			if v14.status == "NotReady" then
				ref.current[v14.kind] = nil
			elseif ref.current[v14.kind] ~= v14.status then
				ref.current[v14.kind] = v14.status
				sendBuildExperienceEvent(
					v14.status == "Ready" and "MONETIZATION_CATALOG_LOAD_SUCCESS" or "MONETIZATION_CATALOG_LOAD_FAILURE",
					{
						universeId = props.universeId,
						placeId = props.placeId,
						conversationId = props.sessionId
					},
					{
						catalogKind = tostring(v14.kind),
						hasCachedProducts = tostring(v14.hasCachedProducts),
						isIncomplete = tostring(v14.isIncomplete)
					}
				)
			end
		end
	end, { catalogSources, props.placeId, props.sessionId, props.universeId })
	local onRetryAll = React.useCallback(function()
		if props.products == nil and props.universeId ~= nil then
			p.fetchProducts(props.universeId)
			v2.fetchGamePasses(props.universeId)
			v3.fetchSubscriptions(props.universeId)
		end
	end, { p, v2, props.products, props.universeId, v3 })

	local onRetrySource = React.useCallback(function(p5)
		if props.products ~= nil or props.universeId == nil then
			return
		end

		if p5 == "DeveloperProduct" then
			p.fetchProducts(props.universeId)
		elseif p5 == "GamePass" then
			v2.fetchGamePasses(props.universeId)
		elseif p5 == "Subscription" then
			v3.fetchSubscriptions(props.universeId)
		end
	end, { p, v2, props.products, props.universeId, v3 })

	local v14 = React.useCallback(function(p5, p6: string, p7)
		local universeId = props.universeId
		local productKindCapabilities = getProductKindCapabilities(p5)

		if universeId == nil or productKindCapabilities == nil then
			return Promise.reject("This product cannot be changed from here")
		end

		if p5 == "GamePass" then
			local v14 = tonumber(p6)

			if v14 == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p7.isForSale == nil then
				local function write() -- 1 equivalent call inferred from this helper
					return v2.update(universeId, v14, {
						isManagedPricingEnabled = p7.isManagedPricingEnabled
					})
				end

				if p7.isManagedPricingEnabled == true then
					return (p4.ensureManagedPricingAccepted(universeId):andThen(write))
				end

				return (write()) -- inferred equivalent call
			elseif p7.isForSale then
				return (v2.activate(universeId, v14))
			else
				return (v2.deactivate(universeId, v14))
			end
		else
			if p7.isForSale == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p7.isForSale then
				return (v3.activate(universeId, p6))
			end

			return (v3.deactivate(universeId, p6, false))
		end
	end, {
		v2,
		p4,
		props.universeId or 0,
		v3
	})
	local onUpdateProductDetails

	if FFlagBuildExperienceMonetizationManageKinds then
		onUpdateProductDetails = React.useCallback(function(p5, p6: string, data2)
			local universeId = props.universeId

			if universeId == nil then
				return Promise.reject("This product cannot be changed from here")
			end

			if p5 == "GamePass" then
				local v15 = tonumber(p6)

				if v15 == nil then
					return Promise.reject("This product cannot be changed from here")
				end

				return v2.update(
					universeId,
					v15,
					{
						name = data2.name,
						description = data2.description,
						priceInRobux = data2.priceInRobux
					},
					{ acceptModeratedText = true }
				)
			elseif p5 == "Subscription" then
				return v3.update(universeId, p6, { description = data2.description }, {
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
		end, { v2, props.universeId or 0, v3 })
	end

	local onUpdateManagedPricing = nil
	local onUpdateSaleStatus

	if FFlagBuildExperienceMonetizationManageKinds then
		onUpdateSaleStatus = React.useCallback(function(p5, p6: string, isForSale: boolean)
			return v14(p5, p6, { isForSale = isForSale })
		end, { v14 })
	end

	if FFlagBuildExperienceMonetizationKindRegionalPricing then
		onUpdateManagedPricing = React.useCallback(function(p5, p6: string, isManagedPricingEnabled: boolean)
			return v14(p5, p6, { isManagedPricingEnabled = isManagedPricingEnabled })
		end, { v14 })
	end

	return {
		gamePassCatalog = gamePassCatalog,
		subscriptionCatalog = subscriptionCatalog,
		catalogSources = catalogSources,
		status = combineCatalogStatus(catalogSources), -- inferred equivalent call
		onRetryAll = onRetryAll,
		onRetrySource = onRetrySource,
		onUpdateSaleStatus = onUpdateSaleStatus,
		onUpdateManagedPricing = onUpdateManagedPricing,
		onUpdateProductDetails = onUpdateProductDetails
	}
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
	local productSection

	if FFlagBuildExperienceMonetizationMultiKind then
		productSection = LocalizationStrings.MONETIZATION_DEVELOPER_PRODUCTS
	end

	productLocalizationKeys.productSection = productSection
	local gamePassType

	if FFlagBuildExperienceMonetizationMultiKind then
		gamePassType = LocalizationStrings.MONETIZATION_GAME_PASS
	end

	productLocalizationKeys.gamePassType = gamePassType
	local gamePassSection

	if FFlagBuildExperienceMonetizationMultiKind then
		gamePassSection = LocalizationStrings.MONETIZATION_PASSES
	end

	productLocalizationKeys.gamePassSection = gamePassSection
	local subscriptionType

	if FFlagBuildExperienceMonetizationMultiKind then
		subscriptionType = LocalizationStrings.AGENT_SUBSCRIPTION_TITLE
	end

	productLocalizationKeys.subscriptionType = subscriptionType
	local subscriptionSection

	if FFlagBuildExperienceMonetizationMultiKind then
		subscriptionSection = LocalizationStrings.MONETIZATION_SUBSCRIPTIONS
	end

	productLocalizationKeys.subscriptionSection = subscriptionSection

	productLocalizationKeys.onSale = LocalizationStrings.MONETIZATION_ON_SALE
	productLocalizationKeys.offSale = LocalizationStrings.MONETIZATION_OFF_SALE
	return productLocalizationKeys
end

local function useResultState(p, callback)
	local useSignalState = SignalsReact.useSignalState

	if p ~= nil then
		callback = p.data
	end

	local v2 = useSignalState(callback)
	local useSignalState2 = SignalsReact.useSignalState
	local v3 = if p == nil then signal9 else p.status
	return v2, (useSignalState2(v3))
end

local function MonetizationPageContainer(props)
	local v2 = React.useContext(Localization.LocalizationRoactContext)
	local v3 = Localization.Hooks.useLocalization(getProductLocalizationKeys())

	local v4 = computed()
	local v5, v6

	if FFlagBuildExperienceMonetizationNativeUI then
		v5 = computed2()

		v6 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	else
		v6 = nil
		v5 = nil
	end

	local v7

	if FFlagBuildExperienceMonetizationNativeUI then
		v7 = React.useMemo(function()
			if v6 == nil or props.universeId == nil then
				return nil
			end

			return v6.getAndFetchSummary(props.universeId)
		end, { props.universeId, v6 })
	end

	local v8, v9

	if FFlagBuildExperienceMonetizationNativeUI then
		local v10 = signal4
		local useSignalState = SignalsReact.useSignalState

		if v7 ~= nil then
			v10 = v7.data
		end

		v8 = useSignalState(v10)
		local useSignalState2 = SignalsReact.useSignalState
		local v11 = if v7 == nil then signal9 else v7.status
		v9 = useSignalState2(v11)
	else
		v8 = nil
		v9 = "NotReady"
	end

	local v10

	if FFlagBuildExperienceMonetizationNativeUI then
		v10 = React.useMemo(function()
			if props.universeId == nil then
				return nil
			end

			if FFlagBuildCheckGamePermissions then
				local fetchUniversePermissions = GamePermissions.getGamePermissionsStore().getAndFetchUniversePermissions(props.universeId)
				return {
					data = Signals.createComputed(function(p)
						local data = fetchUniversePermissions.data(p)

						if data == nil then
							return nil
						end

						return { canMonetize = data.canMonetize }
					end),
					status = fetchUniversePermissions.status
				}
			end

			if v5 == nil or v8 == nil then
				return nil
			end

			return v5.getAndFetchPermission(props.universeId, v8.creatorType, v8.creatorTargetId)
		end, { v5, props.universeId, v8 })
	end

	local v11, permissionLoadStatus

	if FFlagBuildExperienceMonetizationNativeUI then
		local v12 = signal5
		local useSignalState = SignalsReact.useSignalState

		if v10 ~= nil then
			v12 = v10.data
		end

		v11 = useSignalState(v12)
		local useSignalState2 = SignalsReact.useSignalState
		local v13 = if v10 == nil then signal9 else v10.status
		permissionLoadStatus = useSignalState2(v13)

		if not FFlagBuildCheckGamePermissions and v9 == "Failed" then
			permissionLoadStatus = "Failed"
		end
	else
		permissionLoadStatus = "NotReady"
	end

	local v12

	if FFlagBuildExperienceMonetizationNativeUI then
		v12 = React.useMemo(function()
			if v5 == nil or props.universeId == nil then
				return nil
			end

			return v5.getAndFetchManagedPricing(props.universeId)
		end, { v5, props.universeId })
	end

	local v13

	if FFlagBuildExperienceMonetizationNativeUI then
		v13 = React.useMemo(function()
			if v5 == nil or props.universeId == nil then
				return nil
			end

			return v5.getAndFetchShops(props.universeId)
		end, { v5, props.universeId })
	end

	local v14, managedPricingLoadStatus, v15, shopsLoadStatus

	if FFlagBuildExperienceMonetizationNativeUI then
		local v16 = signal6
		local useSignalState = SignalsReact.useSignalState

		if v12 ~= nil then
			v16 = v12.data
		end

		v14 = useSignalState(v16)
		local useSignalState2 = SignalsReact.useSignalState
		local v17 = if v12 == nil then signal9 else v12.status
		managedPricingLoadStatus = useSignalState2(v17)

		local v18 = signal7
		local useSignalState3 = SignalsReact.useSignalState

		if v13 ~= nil then
			v18 = v13.data
		end

		v15 = useSignalState3(v18)
		local useSignalState4 = SignalsReact.useSignalState
		local v19 = if v13 == nil then signal9 else v13.status
		shopsLoadStatus = useSignalState4(v19)
	else
		managedPricingLoadStatus = "NotReady"
		shopsLoadStatus = "NotReady"
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

			local function reportStatus(resource: string, p)
				if p ~= "NotReady" and ref.current[resource] ~= p then
					ref.current[resource] = p
					sendBuildExperienceEvent(
						p == "Ready" and "MONETIZATION_OPTIONS_LOAD_SUCCESS" or "MONETIZATION_OPTIONS_LOAD_FAILURE",
						{
							universeId = props.universeId,
							placeId = props.placeId,
							conversationId = props.sessionId
						},
						{ resource = resource }
					)
				end
			end
			reportStatus("permission", permissionLoadStatus)
			reportStatus("managed_pricing", managedPricingLoadStatus)
			reportStatus("shops", shopsLoadStatus)
		end, {
			managedPricingLoadStatus,
			permissionLoadStatus,
			props.placeId,
			props.sessionId,
			props.universeId,
			shopsLoadStatus
		})
	end

	local v16

	if FFlagBuildExperienceMonetizationMultiKind then
		if permissionLoadStatus == "Ready" and v11 ~= nil then
			v16 = v11.canMonetize == true
		else
			v16 = false
		end
	else
		v16 = not FFlagBuildExperienceMonetizationNativeUI
			or permissionLoadStatus ~= "Ready"
			or v11 == nil
			or v11.canMonetize == true
	end

	local v17 = not FFlagBuildExperienceMonetizationMultiKind and 0
		or SignalsReact.useSignalState(v4.getAccountResetGeneration)
	local v18

	if FFlagBuildExperienceMonetizationMultiKind then
		v18 = {
			v17,
			v4,
			props.products ~= nil,
			props.universeId or 0
		}
	else
		v18 = { v4, props.products ~= nil, props.universeId or 0 }
	end

	local v19 = React.useMemo(function()
		if props.products ~= nil or props.universeId == nil then
			return nil
		end

		if v then
			return (v4.fetchProducts(props.universeId))
		end

		return (v4.getAndFetchProducts(props.universeId))
	end, v18)

	local useSignalState = SignalsReact.useSignalState
	local v20 = if v19 == nil then signal else v19.data
	local developerProducts = useSignalState(v20)

	local useSignalState2 = SignalsReact.useSignalState
	local v21 = if v19 == nil then signal8 else v19.status
	local current = useSignalState2(v21)
	local v22

	if FFlagBuildExperienceMonetizationMultiKind then
		v22 = useMixedCatalog(
			props,
			v4,
			developerProducts,
			current,
			{
				productSection = v3.productSection,
				gamePassSection = v3.gamePassSection,
				subscriptionSection = v3.subscriptionSection
			},
			v5
		)
	end

	local gamePassCatalog

	if v22 == nil then
		gamePassCatalog = nil
	else
		gamePassCatalog = v22.gamePassCatalog
	end

	local subscriptionCatalog

	if v22 == nil then
		subscriptionCatalog = nil
	else
		subscriptionCatalog = v22.subscriptionCatalog
	end

	local products = React.useMemo(function()
		if props.products ~= nil then
			return props.products
		end

		local function fn(p: number)
			return v2:Format(LocalizationStrings.MONETIZATION_DEFAULT_PRODUCT_NAME, {
				PRODUCT_ID = p
			})
		end

		if FFlagBuildExperienceMonetizationMultiKind then
			return mapMonetizationCatalog(
				{
					developerProducts = developerProducts,
					gamePasses = gamePassCatalog,
					subscriptions = subscriptionCatalog
				},
				{
					formatDefaultProductName = fn,
					priceUnavailable = v3.priceUnavailable,
					developerProductType = v3.productType,
					gamePassType = v3.gamePassType,
					subscriptionType = v3.subscriptionType,
					onSale = v3.onSale,
					offSale = v3.offSale
				}
			)
		end

		return mapDeveloperProductsToMonetizationProducts(developerProducts, {
			formatDefaultProductName = fn,
			priceUnavailable = v3.priceUnavailable,
			productType = v3.productType,
			onSale = v3.onSale,
			offSale = v3.offSale
		})
	end, { developerProducts, v3, v2, props.products, gamePassCatalog, subscriptionCatalog })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if FFlagBuildExperienceMonetizationMultiKind or v19 == nil then
			return
		end

		if current == "NotReady" then
			ref.current = nil
			return
		end

		if ref.current == current then
			return
		end

		ref.current = current
		sendBuildExperienceEvent(
			current == "Ready" and "MONETIZATION_CATALOG_LOAD_SUCCESS" or "MONETIZATION_CATALOG_LOAD_FAILURE",
			{
				universeId = props.universeId,
				placeId = props.placeId,
				conversationId = props.sessionId
			}
		)
	end, { v19, current, props.placeId, props.sessionId, props.universeId })

	local onRetryCatalog = React.useCallback(function()
		if props.products == nil and props.universeId ~= nil then
			v4.fetchProducts(props.universeId)
		end
	end, { v4, props.products, props.universeId })

	if v22 ~= nil then
		onRetryCatalog = v22.onRetryAll
	end

	local onRetrySource

	if v22 ~= nil then
		onRetrySource = v22.onRetrySource
	end

	local onUpdateProductManagedPricing = React.useCallback(function(p: number, isManagedPricingEnabled: boolean)
		local function fn()
			return v4.update(props.universeId, p, {
				isManagedPricingEnabled = isManagedPricingEnabled
			})
		end

		if FFlagBuildExperienceMonetizationNativeUI and isManagedPricingEnabled then
			return v5.ensureManagedPricingAccepted(props.universeId):andThen(fn)
		end

		return fn()
	end, { v4, v5, props.universeId })
	local onUpdateProductSaleStatus = React.useCallback(function(p: number, isForSale: boolean)
		return v4.update(props.universeId, p, { isForSale = isForSale })
	end, { v4, props.universeId })
	local onUpdateProduct = React.useCallback(function(p: number, p2)
		return v4.update(props.universeId, p, p2, FFlagBuildExperienceDevProductModerationReadback)
	end, { v4, props.universeId })
	local onAcceptManagedPricing, onUpdateManagedPricing, onSetShopButton, onRetryOptions

	if FFlagBuildExperienceMonetizationNativeUI then
		onAcceptManagedPricing = React.useCallback(function()
			return v5.acceptManagedPricing(props.universeId)
		end, { v5, props.universeId })

		onUpdateManagedPricing = React.useCallback(function(p, flag: boolean)
			local function refreshProducts()
				return v4.list(props.universeId):catch(function(): nil
					return nil
				end)
			end

			return v5.updateDeveloperProductsManagedPricing(props.universeId, p, flag):andThen(function(p2)
				return v4.list(props.universeId):catch(function(): nil
					return nil
				end):andThen(function()
					return p2
				end)
			end, function(p2)
				return v4.list(props.universeId):catch(function(): nil
					return nil
				end):andThen(function()
					return Promise.reject(p2)
				end)
			end)
		end, { v4, v5, props.universeId })

		onSetShopButton = React.useCallback(function(flag: boolean)
			return v5.setShopGlobalIcon(props.universeId, flag)
		end, { v5, props.universeId })

		onRetryOptions = React.useCallback(function()
			local v23 = v5
			v23.fetchManagedPricing(props.universeId)
			v23.fetchShops(props.universeId)

			if FFlagBuildCheckGamePermissions then
				GamePermissions.getGamePermissionsStore().fetchUniversePermissions(props.universeId)
			elseif v8 == nil or v9 == "Failed" then
				v6.fetchSummary(props.universeId)
			else
				v23.fetchPermission(props.universeId, v8.creatorType, v8.creatorTargetId)
			end
		end, { v5, props.universeId, v8, v9, v6 })
	end

	local clone = table.clone(props)
	clone.products = products

	if FFlagBuildCheckGamePermissions then
		clone.canEditOnBuild = useGamePermissions({ universeId = props.universeId }).canEditOnBuild
	end

	clone.showOptions = FFlagBuildExperienceMonetizationNativeUI
		and (props.showOptions == true or props.universeId ~= nil)

	if FFlagBuildExperienceMonetizationNativeUI and props.universeId ~= nil then
		local managedPricingStatus

		if v14 ~= nil then
			managedPricingStatus = v14.status
		end

		clone.managedPricingStatus = managedPricingStatus
		local shops

		if v15 ~= nil then
			shops = v15.shops
		end

		clone.shops = shops
		local permissionCanMonetize

		if v11 ~= nil then
			permissionCanMonetize = v11.canMonetize
		end

		clone.permissionCanMonetize = permissionCanMonetize
		clone.managedPricingLoadStatus = managedPricingLoadStatus
		clone.shopsLoadStatus = shopsLoadStatus
		clone.permissionLoadStatus = permissionLoadStatus
		clone.onAcceptManagedPricing = onAcceptManagedPricing
		clone.onUpdateManagedPricing = onUpdateManagedPricing
		clone.onSetShopButton = onSetShopButton
		clone.onRetryOptions = onRetryOptions
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		local catalogSources

		if props.products == nil then
			catalogSources = v22.catalogSources
		end

		clone.catalogSources = catalogSources
		clone.onRetryCatalogSource = onRetrySource
		clone.catalogStatus = v22.status
	elseif current == "Ready" then
		clone.catalogStatus = "Ready"
	elseif current == "Failed" then
		clone.catalogStatus = "Failed"
	else
		clone.catalogStatus = "NotReady"
	end

	clone.onRetryCatalog = onRetryCatalog

	if props.universeId == nil or not v16 then
		onUpdateProductManagedPricing = nil
	end

	clone.onUpdateProductManagedPricing = onUpdateProductManagedPricing

	if FFlagBuildExperienceMonetizationProductEditing and props.universeId ~= nil and v16 then
		clone.onUpdateProductSaleStatus = onUpdateProductSaleStatus
		clone.onUpdateProduct = onUpdateProduct

		if FFlagBuildExperienceMonetizationManageKinds then
			clone.onUpdateProductKindSaleStatus = v22.onUpdateSaleStatus
			clone.onUpdateProductKind = v22.onUpdateProductDetails
		end

		if FFlagBuildExperienceMonetizationKindRegionalPricing then
			clone.onUpdateProductKindManagedPricing = v22.onUpdateManagedPricing
		end
	end

	local v23 = useMonetizationPageViewModel(clone)
	return React.createElement(MonetizationPageView, v23)
end

return MonetizationPageContainer
