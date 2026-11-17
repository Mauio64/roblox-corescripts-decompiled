local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Promise = require(parent.Promise)
local React = require(parent.React)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(BuildExperience.Components.Chat.ChatComposer)
require(BuildExperience.Components.Chat.ChatActions)
require(BuildExperience.Chat.chatTypes)
local useOnScreenKeyboardHeight = require(BuildExperience.utils.useOnScreenKeyboardHeight)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local GetBuildPromptDraftStore = require(BuildExperience.Stores.GetBuildPromptDraftStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local formatError = require(BuildExperience.utils.formatError)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceMonetizationMultiKind = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationMultiKind)
local FFlagBuildExperienceDeveloperProductContext = require(BuildExperience.Flags.FFlagBuildExperienceDeveloperProductContext)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local FFlagBuildExperienceMonetizationProductEditing = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationProductEditing)
local FFlagBuildExperienceMonetizationManageKinds = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationManageKinds)

local FFlagBuildExperienceMonetizationKindRegionalPricing = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationKindRegionalPricing)
local FFlagBuildExperienceMonetizationPageFixes = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationPageFixes)
local v = FFlagBuildExperienceMonetizationPageFixes and FFlagBuildExperienceDeveloperProductContext

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceRemoveDevProductPriceCap = SharedFlags.FFlagBuildExperienceRemoveDevProductPriceCap

require(script.Parent.MonetizationPageView)
local getProductKindCapabilities = require(script.Parent.getProductKindCapabilities)

local v2 = {}
local v3

if FFlagBuildExperienceDeveloperProductContext then
	v3 = urlBuilder.fromString("apis:developer-products/v2/universes/{universeId}/developer-products/{productId}/creator")
else
	v3 = nil
end

local v4

if v then
	v4 = urlBuilder.fromString("apis:game-passes/v1/universes/{universeId}/game-passes/{productId}/creator")
else
	v4 = nil
end

local v5

if v then
	v5 = urlBuilder.fromString("apis:experience-subscriptions/v1/experiences/{universeId}/experience-subscriptions/{productId}")
else
	v5 = nil
end

local FFlagBuildExperienceDevProductModerationReadback = require(BuildExperience.Flags.FFlagBuildExperienceDevProductModerationReadback)
local wasDeveloperProductTextModerated = require(BuildExperience.utils.wasDeveloperProductTextModerated)

local function logProductMutationFailure(p: string, p2, p3)
	if not FFlagBuildExperienceMonetizationNativeUI then
		return
	end

	local v6 = string.gsub(formatError(p3), "[\r\n]+", " ")
	local productKind = p2.productKind or "DeveloperProduct"
	warn(`[{productKind}] action={p} productId={p2.id} failed={string.sub(v6, 1, 200)}`)
end

local function formatLogError(p) -- 2 equivalent calls inferred from this helper
	return (string.sub(string.gsub(formatError(p), "[\r\n]+", " "), 1, 200))
end

local function sendMonetizationEvent(p, p2, p3) -- 19 equivalent calls inferred from this helper
	if p3 == nil then
		sendBuildExperienceEvent(p, p2)
	else
		sendBuildExperienceEvent(p, p2, p3)
	end
end

local function noop(_) end

local v6 = {
	selectedProductIdRef = { current = nil },
	isProductSaleStatusPending = false,
	setIsProductSaleStatusPending = noop,
	productSaleStatusError = false,
	setProductSaleStatusError = noop,
	isProductEditPending = false,
	setIsProductEditPending = noop,
	productEditError = nil,
	setProductEditError = noop,
	editName = "",
	setEditName = noop,
	editDescription = "",
	setEditDescription = noop,
	editPrice = "",
	setEditPrice = noop
}

local v7 = {
	loadStatus = "NotReady",
	canMonetize = false,
	canChangeManagedPricing = false,
	managedPricingState = "Unavailable",
	managedPricingSupportingText = nil,
	shopButtonEnabled = false,
	isManagedPricingPending = false,
	isShopButtonPending = false,
	managedPricingError = nil,
	shopButtonError = nil,
	showAcknowledgement = false,
	onManagedPricingChanged = noop,
	onShopButtonChanged = noop,
	onConfirmManagedPricing = function() end,
	onCancelManagedPricing = function() end,
	onRetry = function() end,
	labels = {
		options = LocalizationStrings.MONETIZATION_OPTIONS,
		pricingOptions = LocalizationStrings.MONETIZATION_PRICING_OPTIONS,
		pricingOptionsDescription = LocalizationStrings.MONETIZATION_PRICING_OPTIONS_DESCRIPTION,
		managedPricing = LocalizationStrings.MONETIZATION_MANAGED_PRICING,
		managedPricingDescription = LocalizationStrings.MONETIZATION_MANAGED_PRICING_DESCRIPTION,
		shopUI = LocalizationStrings.MONETIZATION_SHOP_UI,
		shopButton = LocalizationStrings.MONETIZATION_SHOP_BUTTON,
		shopButtonDescription = LocalizationStrings.MONETIZATION_SHOP_BUTTON_DESCRIPTION,
		optionsLoadError = LocalizationStrings.MONETIZATION_OPTIONS_LOAD_ERROR,
		permissionDenied = LocalizationStrings.MONETIZATION_PERMISSION_DENIED,
		mixed = LocalizationStrings.MONETIZATION_MANAGED_PRICING_MIXED,
		unavailable = LocalizationStrings.MONETIZATION_MANAGED_PRICING_UNAVAILABLE,
		noEligibleProducts = LocalizationStrings.MONETIZATION_NO_ELIGIBLE_PRODUCTS,
		optionsUpdateError = LocalizationStrings.MONETIZATION_OPTIONS_UPDATE_ERROR,
		partialUpdateError = LocalizationStrings.MONETIZATION_MANAGED_PRICING_PARTIAL_ERROR,
		acknowledgementTitle = LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_TITLE,
		acknowledgementDescription = LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_DESCRIPTION,
		agree = LocalizationStrings.MONETIZATION_AGREE
	}
}

local function trim(value: string) -- 3 equivalent calls inferred from this helper
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function textLength(list: string) -- 2 equivalent calls inferred from this helper
	return utf8.len(list) or #list
end

local function productIdentity(p) -- 13 equivalent calls inferred from this helper
	return p.identity or p.id
end

local function canManageProduct(p): boolean -- 10 equivalent calls inferred from this helper
	return p ~= nil and (p.productKind == nil or p.productKind == "DeveloperProduct") and p.canManage ~= false
end

local function canDescribeKindProduct(p) -- 1 equivalent call inferred from this helper
	local v8 = v

	if v8 then
		if p == nil then
			return false
		end

		return p.productKind == "GamePass" or p.productKind == "Subscription"
	end

	return v8
end

local function hasProductComposer(p)
	local v8 = canManageProduct(p) -- inferred equivalent call

	if v8 then
		return v8
	end

	v8 = v

	if v8 then
		if p == nil then
			return false
		end

		return p.productKind == "GamePass" or p.productKind == "Subscription"
	end

	return v8
end

local function productResourceUrl(universeId: number, state)
	local v8 = { universeId = universeId, productId = state.id }

	if not canDescribeKindProduct(state) then -- inferred equivalent call
		return v3(v8)
	end

	if state.productKind == "GamePass" then
		return (v4(v8))
	end

	return (v5(v8))
end

local function getKindSaleCapabilities(p) -- 8 equivalent calls inferred from this helper
	if not FFlagBuildExperienceMonetizationManageKinds then
		return nil
	end

	local v8

	if p ~= nil then
		v8 = p.productKind
	end

	return getProductKindCapabilities(v8)
end

local function getKindRegionalPricingCapabilities(p) -- 2 equivalent calls inferred from this helper
	local kindSaleCapabilities = getKindSaleCapabilities(p) -- inferred equivalent call

	if
		FFlagBuildExperienceMonetizationKindRegionalPricing
		and kindSaleCapabilities ~= nil
		and kindSaleCapabilities.regionalPricing
	then
		return kindSaleCapabilities
	end

	return nil
end

local function canEditKindProduct(p) -- 7 equivalent calls inferred from this helper
	return FFlagBuildExperienceMonetizationProductEditing and getKindSaleCapabilities(p) ~= nil -- inferred equivalent call
end

local function canEditProduct(p)
	return canManageProduct(p) or canEditKindProduct(p) -- inferred equivalent call
end

local function canOpenProductEdit(data, p) -- 1 equivalent call inferred from this helper
	local v8 = canManageProduct(p) -- inferred equivalent call

	if not v8 then
		v8 = canEditKindProduct(p) -- inferred equivalent call
	end

	if v8 then
		if data.onUpdateProductKind == nil then
			return not canEditKindProduct(p) -- inferred equivalent call
		end

		return true
	end

	return v8
end

local function canEditProductName(p) -- 3 equivalent calls inferred from this helper
	local kindSaleCapabilities = getKindSaleCapabilities(p) -- inferred equivalent call
	return kindSaleCapabilities == nil or kindSaleCapabilities.editableName
end

local function getEditedProductName(p, value: string)
	if canEditProductName(p) then -- inferred equivalent call
		return trim(value) -- inferred equivalent call
	end

	return nil
end

local function canEditProductPrice(p) -- 2 equivalent calls inferred from this helper
	local kindSaleCapabilities = getKindSaleCapabilities(p) -- inferred equivalent call
	return kindSaleCapabilities == nil or kindSaleCapabilities.editablePrice
end

local function getEditTelemetryParameters(p) -- 2 equivalent calls inferred from this helper
	local editTelemetryParameters = { productId = p.id }

	if canEditKindProduct(p) and p.productKind ~= nil then -- inferred equivalent call
		editTelemetryParameters.productKind = p.productKind
	end

	return editTelemetryParameters
end

local function findProduct(items, p: string?) -- 3 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	for _, item in items do
		if productIdentity(item) == p then -- inferred equivalent call
			return item
		end
	end

	return nil
end

local v8 = {
	managedPricing = { "isManagedPricingEnabled" },
	saleStatus = { "isForSale" },
	details = { "name", "description", "priceInRobux", "price" }
}

local function withOverride(p, p2: string) -- 3 equivalent calls inferred from this helper
	return function(p3)
		local v9 = productIdentity(p) -- inferred equivalent call
		local clone = table.clone(p3[v9] or {})
		clone[p2] = p
		local clone2 = table.clone(p3)
		clone2[v9] = clone
		return clone2
	end
end

local function withoutOverride(p: string, p2: string) -- 5 equivalent calls inferred from this helper
	return function(p3)
		if (p3[p] or {})[p2] == nil then
			return p3
		end

		local clone = table.clone(p3[p])
		clone[p2] = nil
		local clone2 = table.clone(p3)
		clone2[p] = clone

		if next(clone) == nil then
			clone2[p] = nil
		end

		return clone2
	end
end

local function applyProductOverrides(p, items)
	if items == nil then
		return p
	end

	local clone = table.clone(p)

	for k, item in items do
		for _, v9 in v8[k] do
			clone[v9] = item[v9]
		end
	end

	return clone
end

local function clearReadBackOverrides(products, state, setState)
	for k, item in state do
		local product = findProduct(products, k) -- inferred equivalent call
		local details = item.details

		if
			product ~= nil
			and details ~= nil
			and product.name == details.name
			and product.description == details.description
			and product.priceInRobux == details.priceInRobux
		then
			setState(withoutOverride(k, "details")) -- inferred equivalent call
		end

		local function clearReadBackToggle(p: string, p2: string) -- 1 equivalent call inferred from this helper
			local v9 = item[p]

			if product == nil or v9 == nil then
				return
			end

			if (product[p2] == true) == (v9[p2] == true) then
				setState(withoutOverride(k, p)) -- inferred equivalent call
			end
		end

		clearReadBackToggle("managedPricing", "isManagedPricingEnabled") -- inferred equivalent call
		local saleStatus = item.saleStatus

		if product ~= nil and saleStatus ~= nil and (product.isForSale == true) == (saleStatus.isForSale == true) then
			setState(withoutOverride(k, "saleStatus")) -- inferred equivalent call
		end
	end
end

local function useManageProductState(data)
	local useRef = React.useRef
	local v9

	if data ~= nil then
		v9 = productIdentity(data) -- inferred equivalent call
	end

	local selectedProductIdRef = useRef(v9)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(nil)

	local state5, setState5 = React.useState(data == nil and "" or data.name)

	local state6, setState6 = React.useState(data == nil and "" or data.description)
	local state7, setState7 = React.useState((data == nil or data.priceInRobux == nil) and "" or tostring(data.priceInRobux))

	return {
		selectedProductIdRef = selectedProductIdRef,
		isProductSaleStatusPending = state,
		setIsProductSaleStatusPending = setState,
		productSaleStatusError = state2,
		setProductSaleStatusError = setState2,
		isProductEditPending = state3,
		setIsProductEditPending = setState3,
		productEditError = state4,
		setProductEditError = setState4,
		editName = state5,
		setEditName = setState5,
		editDescription = state6,
		setEditDescription = setState6,
		editPrice = state7,
		setEditPrice = setState7
	}
end

local function getEligibleProducts(items)
	local eligibleProducts = {}

	for _, item in items do
		if not (canManageProduct(item) and item.isForSale == true and item.isArchived ~= true and item.isImmutable ~= true) then -- inferred equivalent call
			continue
		end

		if not (item.isInActivePriceOptimizationExperiment ~= true and item.priceInRobux ~= nil and item.priceInRobux > 0) then
			continue
		end

		table.insert(eligibleProducts, item)
	end

	return eligibleProducts
end

local function isProductMutationDisabled(data): boolean -- 5 equivalent calls inferred from this helper
	return data ~= nil
		and (data.isArchived == true or data.isImmutable == true or data.isInActivePriceOptimizationExperiment == true)
end

local function validateProductEdit(p, list: string?, editDescription: string, editPrice: string, data)
	if list ~= nil then
		if list == "" then
			return data.nameRequiredError
		end

		if textLength(list) > 50 then -- inferred equivalent call
			return data.nameLengthError
		end
	end

	if textLength(editDescription) > 1000 then -- inferred equivalent call
		return data.descriptionLengthError
	end

	if not canEditProductPrice(p) then -- inferred equivalent call
		return nil, nil
	end

	local v9 = tonumber(editPrice)
	local isForSale = p.isForSale == true

	if
		editPrice == "" and isForSale
		or editPrice ~= "" and v9 == nil
		or v9 ~= nil and v9 % 1 ~= 0
		or v9 ~= nil and v9 < 1
		or not FFlagBuildExperienceRemoveDevProductPriceCap and v9 ~= nil and v9 > 1000000000
	then
		return data.priceError
	end

	return nil, v9
end

local function resolveProductEditSubmit(data, p)
	if canEditKindProduct(p) then -- inferred equivalent call
		local onUpdateProductKind = data.onUpdateProductKind

		if onUpdateProductKind == nil then
			return nil
		end

		return function(p2)
			return onUpdateProductKind(p.productKind, p.id, p2)
		end
	else
		local onUpdateProduct = data.onUpdateProduct
		local id = tonumber(p.id)

		if onUpdateProduct == nil or id == nil then
			return nil
		end

		return function(data2)
			local name = data2.name

			if name == nil then
				return Promise.reject("A name is required to update a developer product.")
			end

			return onUpdateProduct(id, {
				name = name,
				description = data2.description,
				priceInRobux = data2.priceInRobux
			})
		end
	end
end

local function applyProductEditResult(data, data2, p: string?, editDescription: string, p2: number?)
	local clone = table.clone(data)

	if p == nil then
		clone.name = data2.name or data.name
	else
		local name

		if FFlagBuildExperienceDevProductModerationReadback then
			name = data2.name or ""
		else
			name = data2.name or p
		end

		clone.name = name
	end

	local description

	if FFlagBuildExperienceDevProductModerationReadback then
		description = data2.description or ""
	elseif data2.description == nil then
		description = editDescription
	else
		description = data2.description
	end

	clone.description = description
	local v9

	if data2.priceInformation ~= nil then
		v9 = data2.priceInformation.defaultPriceInRobux
	end

	local priceInRobux = v9 or p2 or data.priceInRobux
	clone.priceInRobux = priceInRobux
	local price

	if priceInRobux == nil then
		price = data.price
	else
		price = tostring(priceInRobux)
	end

	clone.price = price
	local v10

	if FFlagBuildExperienceDevProductModerationReadback then
		v10 = wasDeveloperProductTextModerated(p, data2.name)
			or wasDeveloperProductTextModerated(editDescription, data2.description)
	elseif p == nil or data2.name == nil or data2.name == p then
		if data2.description == nil then
			v10 = false
		else
			v10 = data2.description ~= editDescription
		end
	else
		v10 = true
	end

	return clone, v10
end

local function getKindEditState(state, flag: boolean, data)
	if state ~= nil and canEditKindProduct(state) and flag and data.onUpdateProductKind ~= nil then -- inferred equivalent call
		return {
			canEdit = true,
			canEditName = canEditProductName(state), -- inferred equivalent call
			canEditPrice = canEditProductPrice(state) -- inferred equivalent call
		}
	end

	return {}
end

local function getManagedPricingState(managedPricingStatus: string?, eligibleProducts): string -- 1 equivalent call inferred from this helper
	if managedPricingStatus == nil or managedPricingStatus == "Disabled" then
		return "Unavailable"
	end

	local count = 0

	for _, item in eligibleProducts do
		if item.isManagedPricingEnabled == true then
			count += 1
		end
	end

	if count == 0 then
		return "AllOff"
	end

	return if count == #eligibleProducts then "AllOn" else "Mixed"
end

local function getShopButtonEnabled(shops): boolean
	local v9

	if shops ~= nil then
		v9 = shops[1]
	end

	for _, v10 in (v9 == nil or v9.entryPoints == nil) and {} or v9.entryPoints do
		if v10.name == "InExperienceGlobalIconEnabled" then
			return v10.isEnabled == true
		end
	end

	return false
end

local function combineLoadStatus(items): string
	for _, item in items do
		if item == "Failed" then
			return "Failed"
		end
	end

	for _, item in items do
		if item ~= "Ready" then
			return "NotReady"
		end
	end

	return "Ready"
end

local function getDisplayedManagedPricingState(state: boolean?, managedPricingState) -- 1 equivalent call inferred from this helper
	if state == nil then
		return managedPricingState
	end

	return if state then "AllOn" else "AllOff"
end

local function useOptionsState(data, products, p, ref, p2)
	local labels = useLocalization({
		options = LocalizationStrings.MONETIZATION_OPTIONS,
		pricingOptions = LocalizationStrings.MONETIZATION_PRICING_OPTIONS,
		pricingOptionsDescription = LocalizationStrings.MONETIZATION_PRICING_OPTIONS_DESCRIPTION,
		managedPricing = LocalizationStrings.MONETIZATION_MANAGED_PRICING,
		managedPricingDescription = LocalizationStrings.MONETIZATION_MANAGED_PRICING_DESCRIPTION,
		shopUI = LocalizationStrings.MONETIZATION_SHOP_UI,
		shopButton = LocalizationStrings.MONETIZATION_SHOP_BUTTON,
		shopButtonDescription = LocalizationStrings.MONETIZATION_SHOP_BUTTON_DESCRIPTION,
		optionsLoadError = LocalizationStrings.MONETIZATION_OPTIONS_LOAD_ERROR,
		permissionDenied = LocalizationStrings.MONETIZATION_PERMISSION_DENIED,
		mixed = LocalizationStrings.MONETIZATION_MANAGED_PRICING_MIXED,
		unavailable = LocalizationStrings.MONETIZATION_MANAGED_PRICING_UNAVAILABLE,
		noEligibleProducts = LocalizationStrings.MONETIZATION_NO_ELIGIBLE_PRODUCTS,
		optionsUpdateError = LocalizationStrings.MONETIZATION_OPTIONS_UPDATE_ERROR,
		partialUpdateError = LocalizationStrings.MONETIZATION_MANAGED_PRICING_PARTIAL_ERROR,
		acknowledgementTitle = LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_TITLE,
		acknowledgementDescription = LocalizationStrings.MONETIZATION_MANAGED_PRICING_ACK_DESCRIPTION,
		agree = LocalizationStrings.MONETIZATION_AGREE
	})

	local eligibleProducts = getEligibleProducts(products)

	local managedPricingState = getManagedPricingState(data.managedPricingStatus, eligibleProducts) -- inferred equivalent call
	local shopButtonEnabled = getShopButtonEnabled(data.shops)
	local v9 = {
		data.managedPricingLoadStatus or "NotReady",
		data.shopsLoadStatus or "NotReady",
		data.permissionLoadStatus or "NotReady"
	}
	local flag = true
	local loadStatus

	for _, v10 in v9 do
		if v10 == "Failed" then
			loadStatus = "Failed"
			flag = false
			break
		end
	end

	if flag then
		local flag2 = true

		for _, v10 in v9 do
			if v10 ~= "Ready" then
				loadStatus = "NotReady"
				flag2 = false
				break
			end
		end

		if flag2 then
			loadStatus = "Ready"
		end
	end

	local canMonetize

	if loadStatus == "Ready" then
		canMonetize = data.permissionCanMonetize == true
	else
		canMonetize = false
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local state5, setState5 = React.useState(nil)
	local state6, setState6 = React.useState(nil)
	local state7, setState7 = React.useState(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	React.useLayoutEffect(function()
		ref2.current = nil
		ref3.current = nil
		setState(false)
		setState2(false)
		setState3(nil)
		setState4(nil)
		setState5(nil)
		setState6(nil)
		setState7(false)
	end, { data.universeId or 0 })

	React.useEffect(function()
		if
			state3 ~= nil
			and (state3 and managedPricingState == "AllOn" or not state3 and managedPricingState == "AllOff")
		then
			setState3(nil)
		end
	end, { managedPricingState, state3 })

	React.useEffect(function()
		if state4 ~= nil and state4 == shopButtonEnabled then
			setState4(nil)
		end
	end, { state4, shopButtonEnabled })

	local v10 = React.useCallback(function(flag2: boolean, flag3: boolean)
		local onUpdateManagedPricing = data.onUpdateManagedPricing

		if
			ref.current ~= p2
			or ref2.current ~= nil
			or state
			or not canMonetize
			or onUpdateManagedPricing == nil
			or data.managedPricingStatus == nil
			or data.managedPricingStatus == "Disabled"
			or #eligibleProducts == 0
		then
			return
		end

		local ids = {}

		for _, eligibleProduct in eligibleProducts do
			local id = tonumber(eligibleProduct.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		if #ids == 0 then
			setState7(false)
			return
		end

		local current = {}
		ref2.current = current

		setState5(nil)
		setState3(flag2)
		setState(true)
		local v10

		if flag3 and data.onAcceptManagedPricing ~= nil then
			v10 = data.onAcceptManagedPricing():andThen(function()
				if ref.current == p2 and ref2.current == current then
					return onUpdateManagedPricing(ids, flag2)
				end

				return nil
			end)
		else
			v10 = onUpdateManagedPricing(ids, flag2)
		end

		v10:andThen(function(p3)
			if ref.current ~= p2 or ref2.current ~= current then
				return
			end

			setState7(false)

			if type(p3) == "table" and type(p3.errors) == "table" and #p3.errors > 0 then
				warn(`[MonetizationOptions] Managed Pricing update partially failed (universeId={tostring(p.universeId)})`)

				sendMonetizationEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", p, { -- inferred equivalent call
					action = "managed_pricing",
					failureType = "partial"
				})

				setState3(nil)
				setState5(labels.partialUpdateError)
			else
				sendMonetizationEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", p, { -- inferred equivalent call
					action = "managed_pricing"
				})
			end
		end):catch(function(p3)
			if ref.current ~= p2 or ref2.current ~= current then
				return
			end

			warn(`[MonetizationOptions] Managed Pricing update failed (universeId={tostring(p.universeId)}): {formatLogError(p3)}`) -- inferred equivalent call

			sendMonetizationEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", p, { -- inferred equivalent call
				action = "managed_pricing",
				failureType = "request"
			})

			setState7(false)
			setState3(nil)
			setState5(labels.optionsUpdateError)
		end):finally(function()
			if ref.current == p2 and ref2.current == current then
				ref2.current = nil
				setState(false)
			end
		end)
	end, {
		canMonetize,
		eligibleProducts,
		state,
		labels.optionsUpdateError,
		labels.partialUpdateError,
		data.managedPricingStatus,
		data.onAcceptManagedPricing,
		data.onUpdateManagedPricing,
		p,
		p2
	})

	local onManagedPricingChanged = React.useCallback(function(flag2: boolean)
		if
			ref.current ~= p2
			or not canMonetize
			or data.onUpdateManagedPricing == nil
			or data.managedPricingStatus == nil
			or data.managedPricingStatus == "Disabled"
			or #eligibleProducts == 0
		then
			return
		end

		if data.managedPricingStatus == "Pending" and flag2 then
			setState7(true)
		else
			v10(flag2, false)
		end
	end, {
		canMonetize,
		eligibleProducts,
		data.managedPricingStatus,
		data.onUpdateManagedPricing,
		v10
	})

	local onShopButtonChanged = React.useCallback(function(flag2: boolean)
		local onSetShopButton = data.onSetShopButton

		if ref.current ~= p2 or ref3.current ~= nil or state2 or not canMonetize or onSetShopButton == nil then
			return
		end

		local current = {}
		ref3.current = current
		setState6(nil)
		setState4(flag2)
		setState2(true)
		onSetShopButton(flag2):andThen(function()
			if ref.current ~= p2 or ref3.current ~= current then
				return
			end

			sendMonetizationEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", p, { -- inferred equivalent call
				action = "shop_button"
			})
		end):catch(function(p3)
			if ref.current ~= p2 or ref3.current ~= current then
				return
			end

			warn(`[MonetizationOptions] Shop button update failed (universeId={tostring(p.universeId)}): {formatLogError(p3)}`) -- inferred equivalent call

			sendMonetizationEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", p, { -- inferred equivalent call
				action = "shop_button",
				failureType = "request"
			})

			setState4(nil)
			setState6(labels.optionsUpdateError)
		end):finally(function()
			if ref.current == p2 and ref3.current == current then
				ref3.current = nil
				setState2(false)
			end
		end)
	end, { canMonetize, state2, labels.optionsUpdateError, data.onSetShopButton, p, p2 })
	local displayedManagedPricingState = getDisplayedManagedPricingState(state3, managedPricingState) -- inferred equivalent call
	local v11 = {
		loadStatus = loadStatus,
		canMonetize = canMonetize,
		canChangeManagedPricing = 0,
		managedPricingState = 0,
		managedPricingSupportingText = 0,
		shopButtonEnabled = 0,
		isManagedPricingPending = 0,
		isShopButtonPending = 0,
		managedPricingError = 0,
		shopButtonError = 0,
		showAcknowledgement = 0,
		onManagedPricingChanged = 0,
		onShopButtonChanged = 0,
		onConfirmManagedPricing = 0,
		onCancelManagedPricing = 0,
		onRetry = 0,
		labels = 0
	}
	local canChangeManagedPricing

	if canMonetize then
		if data.onUpdateManagedPricing == nil or not (#eligibleProducts > 0) then
			canChangeManagedPricing = false
		else
			canChangeManagedPricing = displayedManagedPricingState ~= "Unavailable"
		end
	else
		canChangeManagedPricing = canMonetize
	end

	v11.canChangeManagedPricing = canChangeManagedPricing

	v11.managedPricingState = displayedManagedPricingState
	local managedPricingSupportingText

	if #eligibleProducts == 0 and displayedManagedPricingState ~= "Unavailable" then
		managedPricingSupportingText = labels.noEligibleProducts
	end

	v11.managedPricingSupportingText = managedPricingSupportingText
	local shopButtonEnabled2

	if state4 == nil then
		shopButtonEnabled2 = shopButtonEnabled
	else
		shopButtonEnabled2 = state4
	end

	v11.shopButtonEnabled = shopButtonEnabled2
	v11.isManagedPricingPending = state
	v11.isShopButtonPending = state2
	v11.managedPricingError = state5
	v11.shopButtonError = state6
	v11.showAcknowledgement = state7
	v11.onManagedPricingChanged = onManagedPricingChanged
	v11.onShopButtonChanged = onShopButtonChanged
	function v11.onConfirmManagedPricing()
		v10(true, true)
	end
	function v11.onCancelManagedPricing()
		if not state then
			setState7(false)
		end
	end
	v11.onRetry = data.onRetryOptions or function() end
	v11.labels = labels
	return v11
end

local function getRegionalPricingViewState(data, state, canChangeKind: boolean, state2: boolean, p)
	local kindRegionalPricingCapabilities = getKindRegionalPricingCapabilities(state) -- inferred equivalent call
	local priceInRobux

	if state ~= nil then
		priceInRobux = state.priceInRobux
	end

	local canUpdate

	if kindRegionalPricingCapabilities == nil then
		canUpdate = data.onUpdateProductManagedPricing ~= nil
	else
		canUpdate = data.onUpdateProductKindManagedPricing ~= nil
	end

	if FFlagBuildExperienceMonetizationKindRegionalPricing then
		if canChangeKind then
			if kindRegionalPricingCapabilities == nil then
				canChangeKind = false
			else
				canChangeKind = data.onUpdateProductKindManagedPricing ~= nil
			end
		end
	else
		canChangeKind = nil
	end

	local errorLabel

	if not (kindRegionalPricingCapabilities == nil or not state2) then
		if priceInRobux == nil then
			errorLabel = p.kindPriceRequiredForRegionalPricing
		else
			errorLabel = p.updateError
		end
	end

	return { canUpdate = canUpdate, canChangeKind = canChangeKind, errorLabel = errorLabel }
end

local function getInitialSelection(data, products) -- 1 equivalent call inferred from this helper
	local initialMode

	if FFlagBuildExperienceMonetizationNativeUI or data.initialMode ~= "options" then
		initialMode = data.initialMode
	end

	if initialMode == "detail" or FFlagBuildExperienceMonetizationProductEditing and initialMode == "edit" then
		return initialMode, products[1]
	end

	return initialMode, nil
end

local function useMonetizationLocalization()
	local composerPlaceholder

	if FFlagBuildExperienceDeveloperProductContext then
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER
	end

	local v9 = {
		composerPlaceholder = composerPlaceholder,
		title = LocalizationStrings.MONETIZATION_TITLE,
		emptyTitle = LocalizationStrings.MONETIZATION_EMPTY_TITLE,
		emptyDescription = LocalizationStrings.MONETIZATION_EMPTY_DESCRIPTION,
		emptyCreateProduct = LocalizationStrings.MONETIZATION_EMPTY_CREATE_PRODUCT,
		createProductPrompt = LocalizationStrings.MONETIZATION_CREATE_PRODUCT_PROMPT,
		pricing = LocalizationStrings.MONETIZATION_PRICING,
		regionalPricing = LocalizationStrings.MONETIZATION_REGIONAL_PRICING,
		loading = LocalizationStrings.MONETIZATION_LOADING,
		loadErrorTitle = LocalizationStrings.BUILD_ELIGIBILITY_ERROR_TITLE,
		loadErrorDescription = LocalizationStrings.CHAT_ERROR_UPSTREAM_UNAVAILABLE,
		updateError = LocalizationStrings.CHAT_DEFAULT_FAILURE,
		retry = LocalizationStrings.MONETIZATION_RETRY,
		availableForPurchase = LocalizationStrings.MONETIZATION_AVAILABLE_FOR_PURCHASE,
		edit = LocalizationStrings.MONETIZATION_EDIT,
		editProduct = LocalizationStrings.MONETIZATION_EDIT_PRODUCT,
		name = LocalizationStrings.MONETIZATION_NAME,
		description = LocalizationStrings.MONETIZATION_DESCRIPTION,
		price = LocalizationStrings.MONETIZATION_PRICE,
		cancel = LocalizationStrings.MONETIZATION_CANCEL,
		save = LocalizationStrings.MONETIZATION_SAVE,
		nameRequiredError = LocalizationStrings.MONETIZATION_NAME_REQUIRED_ERROR,
		nameLengthError = LocalizationStrings.MONETIZATION_NAME_LENGTH_ERROR,
		descriptionLengthError = LocalizationStrings.MONETIZATION_DESCRIPTION_LENGTH_ERROR,
		priceError = LocalizationStrings.MONETIZATION_PRICE_ERROR,
		priceRequiredForSale = LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_SALE,
		moderationError = LocalizationStrings.MONETIZATION_MODERATION_ERROR,
		kindPriceRequiredForSale = 0,
		kindPriceRequiredForRegionalPricing = 0
	}
	local kindPriceRequiredForSale

	if FFlagBuildExperienceMonetizationManageKinds then
		kindPriceRequiredForSale = LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_KIND_SALE
	end

	v9.kindPriceRequiredForSale = kindPriceRequiredForSale
	local kindPriceRequiredForRegionalPricing

	if FFlagBuildExperienceMonetizationKindRegionalPricing then
		kindPriceRequiredForRegionalPricing = LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_REGIONAL_PRICING
	end

	v9.kindPriceRequiredForRegionalPricing = kindPriceRequiredForRegionalPricing
	return useLocalization(v9)
end

local function useMonetizationPageViewModel(data)
	local v9 = useMonetizationLocalization()
	local products = data.products or v2
	local initialSelection, v10 = getInitialSelection(data, products) -- inferred equivalent call
	local v11 = React.useMemo(function()
		return {
			universeId = data.universeId,
			placeId = data.placeId,
			conversationId = data.sessionId,
			messageId = nil,
			turnId = nil,
			chatOpenId = nil
		}
	end, { data.placeId or 0, data.sessionId or "", data.universeId or 0 })
	local current = React.useMemo(function()
		return {}
	end, { data.universeId or 0 })
	local ref = React.useRef(nil)
	React.useLayoutEffect(function()
		ref.current = current
		return function()
			if ref.current == current then
				ref.current = nil
			end
		end
	end, { current })
	local v12 = v7

	if FFlagBuildExperienceMonetizationNativeUI then
		v12 = useOptionsState(data, products, v11, ref, current)
	end

	local v13 = not FFlagBuildExperienceMonetizationMultiKind

	if not v13 then
		if data.permissionLoadStatus == "Ready" then
			v13 = data.permissionCanMonetize == true
		else
			v13 = false
		end
	end

	local v14 = #products > 0 and "catalog" or "empty"
	local state, setState = React.useState(initialSelection or v14)

	local state2, setState2 = React.useState(v10)

	local setState3 = noop

	local setState4 = noop
	local state3, state4

	if FFlagBuildExperienceMonetizationMultiKind then
		local useState = React.useState
		local v15

		if v10 ~= nil then
			v15 = productIdentity(v10) -- inferred equivalent call
		end

		state3, setState3 = useState(v15)

		state4, setState4 = React.useState({})
	else
		state3 = nil
		state4 = {}
	end

	local v15

	if FFlagBuildExperienceMonetizationMultiKind then
		v15 = findProduct(products, state3) -- inferred equivalent call
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		if v15 == nil then
			state2 = nil
		else
			local v16

			if state3 ~= nil then
				v16 = state4[state3]
			end

			state2 = applyProductOverrides(v15, v16)
		end
	end

	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local ref2 = React.useRef(nil)
	local v16 = v6

	if FFlagBuildExperienceMonetizationProductEditing then
		v16 = useManageProductState(v10)
	end

	local selectedProductIdRef = v16.selectedProductIdRef
	local isProductSaleStatusPending = v16.isProductSaleStatusPending
	local setIsProductSaleStatusPending = v16.setIsProductSaleStatusPending
	local productSaleStatusError = v16.productSaleStatusError
	local setProductSaleStatusError = v16.setProductSaleStatusError
	local isProductEditPending = v16.isProductEditPending
	local setIsProductEditPending = v16.setIsProductEditPending
	local productEditError = v16.productEditError
	local setProductEditError = v16.setProductEditError
	local editName = v16.editName
	local setEditName = v16.setEditName
	local editDescription = v16.editDescription
	local setEditDescription = v16.setEditDescription
	local editPrice = v16.editPrice
	local setEditPrice = v16.setEditPrice

	React.useLayoutEffect(function()
		ref2.current = nil
		setState(initialSelection or v14)

		if FFlagBuildExperienceMonetizationMultiKind then
			local v17

			if v10 ~= nil then
				v17 = productIdentity(v10) -- inferred equivalent call
			end

			setState3(v17)
			setState4({})
		else
			setState2(v10)
		end

		setState5(false)
		setState6(false)

		if FFlagBuildExperienceMonetizationProductEditing then
			local current2

			if v10 ~= nil then
				current2 = productIdentity(v10) -- inferred equivalent call
			end

			selectedProductIdRef.current = current2

			setIsProductSaleStatusPending(false)
			setProductSaleStatusError(false)
			setIsProductEditPending(false)
			setProductEditError(nil)
			setEditName(v10 == nil and "" or v10.name)
			setEditDescription(v10 == nil and "" or v10.description)
			setEditPrice((v10 == nil or v10.priceInRobux == nil) and "" or tostring(v10.priceInRobux))
		end
	end, { data.universeId or 0 })
	React.useEffect(function()
		local v17 = v11
		local v18 = { source = "monetization_page" }

		if v18 == nil then
			sendBuildExperienceEvent("MONETIZATION_ENTRY_CLICK", v17)
		else
			sendBuildExperienceEvent("MONETIZATION_ENTRY_CLICK", v17, v18)
		end

		sendBuildExperienceEvent("MONETIZATION_PAGE_IMPRESSION", v11)
	end, { v11 })

	React.useEffect(function()
		if initialSelection == nil and (state == "catalog" or state == "empty") and state ~= v14 then
			setState(v14)
		end
	end, { v14, initialSelection, state })

	if FFlagBuildExperienceMonetizationMultiKind then
		React.useEffect(function()
			if state3 ~= nil and findProduct(products, state3) == nil then -- inferred equivalent call
				selectedProductIdRef.current = nil
				setState3(nil)
				setState(v14)
			end

			clearReadBackOverrides(products, state4, setState4)
		end, { v14, state4, products, state3 })
	end

	local useCallback = React.useCallback
	local function fn()
		sendMonetizationEvent("MONETIZATION_CLOSE_CLICK", v11, { mode = tostring(state) }) -- inferred equivalent call

		if FFlagBuildExperienceMonetizationProductEditing and state == "edit" then
			if isProductEditPending or ref2.current ~= nil then
				return
			end

			setProductEditError(nil)
			setState("detail")
		elseif state == "detail" then
			if FFlagBuildExperienceMonetizationProductEditing then
				selectedProductIdRef.current = nil
			end

			if FFlagBuildExperienceMonetizationMultiKind then
				setState3(nil)
			else
				setState2(nil)
			end

			setState(v14)
		elseif FFlagBuildExperienceMonetizationNativeUI and state == "options" and initialSelection ~= "options" then
			setState(v14)
		else
			data.onClose()
		end
	end

	local v17

	if FFlagBuildExperienceMonetizationProductEditing then
		v17 = isProductEditPending
	end

	local onClose = useCallback(fn, {
		v14,
		v17,
		state,
		initialSelection,
		data.onClose,
		v11,
		setProductEditError
	})

	local onProductActivated = React.useCallback(function(p: string)
		for _, product in products do
			if productIdentity(product) == p then -- inferred equivalent call
				local v18 = { productId = product.id }

				if FFlagBuildExperienceMonetizationMultiKind then
					v18.productKind = product.productKind
				end

				sendMonetizationEvent("MONETIZATION_PRODUCT_CLICK", v11, v18) -- inferred equivalent call

				if FFlagBuildExperienceMonetizationProductEditing then
					setState6(false)
					setProductSaleStatusError(false)
					setProductEditError(nil)
				end

				if FFlagBuildExperienceMonetizationProductEditing then
					selectedProductIdRef.current = productIdentity(product) -- inferred equivalent call
				end

				if FFlagBuildExperienceMonetizationMultiKind then
					setState3(p)
				else
					setState2(product)
				end

				setState("detail")
				break
			end
		end
	end, { products, setProductEditError, setProductSaleStatusError, v11 })

	local fn2 = not FFlagBuildExperienceMonetizationNativeUI and function() end or React.useCallback(function()
		setState("options")
	end, {})

	local useCallback2 = React.useCallback
	local function fn3(isManagedPricingEnabled: boolean)
		local v18 = state2
		local id

		if v18 ~= nil then
			id = tonumber(v18.id)
		end

		local onUpdateProductManagedPricing = data.onUpdateProductManagedPricing
		local kindRegionalPricingCapabilities = getKindRegionalPricingCapabilities(v18) -- inferred equivalent call
		local onUpdateProductKindManagedPricing = data.onUpdateProductKindManagedPricing

		if
			ref.current == current
			and ref2.current == nil
			and v18 ~= nil
			and (canManageProduct(v18) or kindRegionalPricingCapabilities ~= nil) -- inferred equivalent call
			and v13
		then
			local v19

			if kindRegionalPricingCapabilities == nil then
				v19 = id == nil or onUpdateProductManagedPricing == nil
			else
				v19 = onUpdateProductKindManagedPricing == nil
			end

			if
				not (v19 or state5 or FFlagBuildExperienceMonetizationProductEditing and isProductSaleStatusPending)
				and not isProductMutationDisabled(v18) -- inferred equivalent call
			then
				if FFlagBuildExperienceMonetizationNativeUI and isManagedPricingEnabled and v18.priceInRobux == nil then
					setState6(true)
					return
				end

				local current2 = {}
				ref2.current = current2
				local productKind

				if kindRegionalPricingCapabilities == nil then
					productKind = nil
				else
					productKind = v18.productKind
				end

				sendMonetizationEvent("MONETIZATION_MANAGED_PRICING_CLICK", v11, { -- inferred equivalent call
					isEnabled = tostring(isManagedPricingEnabled),
					productId = v18.id,
					productKind = productKind
				})

				local clone = table.clone(v18)
				clone.isManagedPricingEnabled = isManagedPricingEnabled

				if FFlagBuildExperienceMonetizationMultiKind then
					setState4(withOverride(clone, "managedPricing")) -- inferred equivalent call
				else
					setState2(clone)
				end

				setState6(false)
				setState5(true)
				local v20

				if kindRegionalPricingCapabilities == nil then
					v20 = onUpdateProductManagedPricing(id, isManagedPricingEnabled)
				else
					v20 = onUpdateProductKindManagedPricing(v18.productKind, v18.id, isManagedPricingEnabled)
				end

				v20:andThen(function()
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v11, { -- inferred equivalent call
						action = "managed_pricing",
						productId = v18.id,
						productKind = productKind
					})
				end):catch(function(p)
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					local v21 = v18

					if FFlagBuildExperienceMonetizationNativeUI then
						local v22 = string.gsub(formatError(p), "[\r\n]+", " ")
						local productKind2 = v21.productKind or "DeveloperProduct"
						warn(`[{productKind2}] action=managed_pricing productId={v21.id} failed={string.sub(v22, 1, 200)}`)
					end

					if FFlagBuildExperienceMonetizationMultiKind then
						setState4(withoutOverride(productIdentity(v18), "managedPricing")) -- inferred equivalent call
					end

					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v11, { -- inferred equivalent call
						action = "managed_pricing",
						productId = v18.id,
						productKind = productKind
					})

					if FFlagBuildExperienceMonetizationProductEditing then
						if selectedProductIdRef.current == productIdentity(v18) then -- inferred equivalent call
							if not FFlagBuildExperienceMonetizationMultiKind then
								setState2(v18)
							end

							setState6(true)
						end
					else
						if not FFlagBuildExperienceMonetizationMultiKind then
							setState2(v18)
						end

						setState6(true)
					end
				end):finally(function()
					if ref.current == current and ref2.current == current2 then
						ref2.current = nil
						setState5(false)
					end
				end)
			end
		end
	end

	local v18

	if FFlagBuildExperienceMonetizationProductEditing then
		v18 = isProductSaleStatusPending
	end

	local onProductManagedPricingChanged = useCallback2(fn3, {
		v13,
		state5,
		v18,
		data.onUpdateProductManagedPricing,
		state2,
		v11,
		current,
		data.onUpdateProductKindManagedPricing or false
	})

	local onProductSaleStatusChanged = React.useCallback(function(isForSale: boolean)
		local v19 = state2
		local id

		if v19 ~= nil then
			id = tonumber(v19.id)
		end

		local onUpdateProductSaleStatus = data.onUpdateProductSaleStatus
		local kindSaleCapabilities = getKindSaleCapabilities(v19) -- inferred equivalent call
		local onUpdateProductKindSaleStatus = data.onUpdateProductKindSaleStatus

		if
			FFlagBuildExperienceMonetizationProductEditing
			and ref.current == current
			and ref2.current == nil
			and v19 ~= nil
			and (canManageProduct(v19) or kindSaleCapabilities ~= nil) -- inferred equivalent call
			and v13
		then
			local v20

			if kindSaleCapabilities == nil then
				v20 = id == nil or onUpdateProductSaleStatus == nil
			else
				v20 = onUpdateProductKindSaleStatus == nil
			end

			if not (v20 or isProductSaleStatusPending or state5) and not isProductMutationDisabled(v19) then -- inferred equivalent call
				if
					FFlagBuildExperienceMonetizationNativeUI
					and isForSale
					and v19.priceInRobux == nil
					and (kindSaleCapabilities == nil or kindSaleCapabilities.priceRequiredForSale)
				then
					setProductSaleStatusError(true)
					return
				end

				local current2 = {}
				ref2.current = current2
				local productKind

				if kindSaleCapabilities == nil then
					productKind = nil
				else
					productKind = v19.productKind
				end

				sendMonetizationEvent("MONETIZATION_SALE_STATUS_CLICK", v11, { -- inferred equivalent call
					isEnabled = tostring(isForSale),
					productId = v19.id,
					productKind = productKind
				})

				local clone = table.clone(v19)
				clone.isForSale = isForSale

				if FFlagBuildExperienceMonetizationMultiKind then
					setState4(withOverride(clone, "saleStatus")) -- inferred equivalent call
				else
					setState2(clone)
				end

				setProductSaleStatusError(false)
				setIsProductSaleStatusPending(true)
				local v21

				if kindSaleCapabilities == nil then
					v21 = onUpdateProductSaleStatus(id, isForSale)
				else
					v21 = onUpdateProductKindSaleStatus(v19.productKind, v19.id, isForSale)
				end

				v21:andThen(function()
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v11, { -- inferred equivalent call
						action = "sale_status",
						productId = v19.id,
						productKind = productKind
					})
				end):catch(function(p)
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					local v22 = v19

					if FFlagBuildExperienceMonetizationNativeUI then
						local v23 = string.gsub(formatError(p), "[\r\n]+", " ")
						local productKind2 = v22.productKind or "DeveloperProduct"
						warn(`[{productKind2}] action=sale_status productId={v22.id} failed={string.sub(v23, 1, 200)}`)
					end

					if FFlagBuildExperienceMonetizationMultiKind then
						setState4(withoutOverride(productIdentity(v19), "saleStatus")) -- inferred equivalent call
					end

					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v11, { -- inferred equivalent call
						action = "sale_status",
						productId = v19.id,
						productKind = productKind
					})

					if selectedProductIdRef.current == productIdentity(v19) then -- inferred equivalent call
						if not FFlagBuildExperienceMonetizationMultiKind then
							setState2(v19)
						end

						setProductSaleStatusError(true)
					end
				end):finally(function()
					if ref.current == current and ref2.current == current2 then
						ref2.current = nil
						setIsProductSaleStatusPending(false)
					end
				end)
			end
		end
	end, {
		v13,
		state5,
		isProductSaleStatusPending,
		data.onUpdateProductSaleStatus,
		state2,
		setIsProductSaleStatusPending,
		setProductSaleStatusError,
		v11,
		current,
		data.onUpdateProductKindSaleStatus or false
	})

	local onUpdateProductKind = data.onUpdateProductKind or false
	local onOpenProductEdit = React.useCallback(function()
		local v19 = state2

		if
			FFlagBuildExperienceMonetizationProductEditing
			and v19 ~= nil
			and canOpenProductEdit(data, v19) -- inferred equivalent call
			and v13
			and not isProductMutationDisabled(v19) -- inferred equivalent call
		then
			sendMonetizationEvent("MONETIZATION_EDIT_CLICK", v11, getEditTelemetryParameters(v19)) -- inferred equivalent call
			setEditName(v19.name)
			setEditDescription(v19.description)
			setEditPrice(v19.priceInRobux == nil and "" or tostring(v19.priceInRobux))
			setProductEditError(nil)
			setState("edit")
		end
	end, {
		v13,
		onUpdateProductKind,
		state2,
		setEditDescription,
		setEditName,
		setEditPrice,
		setProductEditError,
		v11
	})

	local onEditNameChanged = React.useCallback(function(p: string)
		setEditName(p)
		setProductEditError(nil)
	end, {})
	local onEditDescriptionChanged = React.useCallback(function(p: string)
		setEditDescription(p)
		setProductEditError(nil)
	end, {})
	local onEditPriceChanged = React.useCallback(function(p: string)
		setEditPrice(p)
		setProductEditError(nil)
	end, {})
	local onCancelProductEdit = React.useCallback(function()
		if isProductEditPending or ref2.current ~= nil then
			return
		end

		sendMonetizationEvent("MONETIZATION_EDIT_CANCEL_CLICK", v11, state2 ~= nil and { -- inferred equivalent call
			productId = state2.id
		} or nil)

		setProductEditError(nil)
		setState("detail")
	end, { isProductEditPending, state2, v11 })

	local onSaveProductEdit = React.useCallback(function()
		local v19 = state2
		local v20

		if v19 ~= nil then
			v20 = resolveProductEditSubmit(data, v19)
		end

		if
			FFlagBuildExperienceMonetizationProductEditing
			and ref.current == current
			and ref2.current == nil
			and v19 ~= nil
		then
			local v21 = canManageProduct(v19) -- inferred equivalent call

			if not v21 then
				v21 = canEditKindProduct(v19) -- inferred equivalent call
			end

			if v21 and v13 and v20 ~= nil and not isProductEditPending then
				local editTelemetryParameters = getEditTelemetryParameters(v19) -- inferred equivalent call
				sendMonetizationEvent("MONETIZATION_EDIT_SAVE_CLICK", v11, editTelemetryParameters) -- inferred equivalent call
				local name = canEditProductName(v19) and trim(editName) or nil -- inferred equivalent call
				local v22, priceInRobux = validateProductEdit(v19, name, editDescription, editPrice, v9)

				if v22 ~= nil then
					setProductEditError(v22)
					return
				end

				local current2 = {}
				ref2.current = current2

				setProductEditError(nil)
				setIsProductEditPending(true)
				v20({ name = name, description = editDescription, priceInRobux = priceInRobux }):andThen(function(p)
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					local clone = table.clone(editTelemetryParameters)
					clone.action = "product_details"
					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v11, clone) -- inferred equivalent call
					local v23, v24 = applyProductEditResult(v19, p, name, editDescription, priceInRobux)

					if FFlagBuildExperienceMonetizationMultiKind then
						setState4(withOverride(v23, "details")) -- inferred equivalent call
					else
						setState2(v23)
					end

					setState6(false)
					setProductSaleStatusError(false)

					if v24 then
						setProductEditError(v9.moderationError)
					elseif FFlagBuildExperienceMonetizationMultiKind then
						if selectedProductIdRef.current == productIdentity(v19) then -- inferred equivalent call
							setState("detail")
						end
					else
						setState("detail")
					end
				end):catch(function(p)
					if ref.current ~= current or ref2.current ~= current2 then
						return
					end

					local v23 = v19

					if FFlagBuildExperienceMonetizationNativeUI then
						local v24 = string.gsub(formatError(p), "[\r\n]+", " ")
						local productKind = v23.productKind or "DeveloperProduct"
						warn(`[{productKind}] action=product_details productId={v23.id} failed={string.sub(v24, 1, 200)}`)
					end

					local clone = table.clone(editTelemetryParameters)
					clone.action = "product_details"
					sendMonetizationEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v11, clone) -- inferred equivalent call
					setProductEditError(v9.updateError)
				end):finally(function()
					if ref.current == current and ref2.current == current2 then
						ref2.current = nil
						setIsProductEditPending(false)
					end
				end)
			end
		end
	end, {
		v13,
		editDescription,
		editName,
		editPrice,
		isProductEditPending,
		v9.descriptionLengthError,
		v9.moderationError,
		v9.nameLengthError,
		v9.nameRequiredError,
		v9.priceError,
		v9.updateError,
		data.onUpdateProduct,
		onUpdateProductKind,
		state2,
		setIsProductEditPending,
		setProductEditError,
		setProductSaleStatusError,
		v11,
		current
	})

	local onComposerActivated = data.onComposerActivated or data.onClose
	local canEditOnBuild = data.canEditOnBuild ~= false
	local canCreateProduct

	if FFlagBuildCheckGamePermissions and data.permissionLoadStatus ~= nil then
		if data.permissionLoadStatus == "Ready" then
			canCreateProduct = data.permissionCanMonetize == true
		else
			canCreateProduct = false
		end
	else
		canCreateProduct = v13
	end

	local v19, chatActions

	if FFlagBuildExperienceDeveloperProductContext then
		local composerText, onComposerChanged = React.useBinding("")
		local ref3 = React.useRef(nil)
		v19 = useOnScreenKeyboardHeight()
		React.useEffect(function()
			onComposerChanged("")
		end, {
			data.universeId or 0,
			data.sessionId or "",
			state2 == nil and "" or state2.id,
			onComposerChanged
		})

		local onSend = React.useCallback(function(): boolean
			local text = trim(composerText:getValue()) -- inferred equivalent call

			if text == "" or state ~= "detail" or state2 == nil or data.universeId == nil then
				return false
			end

			GetBuildPromptDraftStore().queueDraft({
				universeId = data.universeId,
				sessionId = data.sessionId,
				text = text,
				autoSend = true,
				resourceAttachments = {
					{
						type = "resource_link",
						name = state2.name,
						uri = productResourceUrl(data.universeId, state2),
						mimeType = "application/json"
					}
				}
			})

			onComposerChanged("")

			if ref3.current ~= nil then
				ref3.current.releaseFocus()
			end

			onComposerActivated()
			return true
		end, {
			composerText,
			onComposerActivated,
			state,
			data.sessionId,
			data.universeId,
			state2,
			onComposerChanged
		})

		if state == "detail" and state2 ~= nil then
			local v20 = canManageProduct(state2) -- inferred equivalent call

			if not v20 then
				v20 = v

				if v20 then
					if state2 == nil then
						v20 = false
					else
						v20 = state2.productKind == "GamePass" or state2.productKind == "Subscription"
					end
				end
			end

			if v20 and data.universeId ~= nil then
				chatActions = {
					composerText = composerText,
					onComposerChanged = onComposerChanged,
					placeholder = v9.composerPlaceholder,
					textBoxRef = ref3,
					isAssistantResponding = false,
					canSendWhileResponding = false,
					allowImageAttachments = false,
					tracksExternalText = true,
					onSend = onSend,
					onStop = function() end,
					isReadOnly = not canEditOnBuild
				}
			end
		end
	end

	local onOpenCreate = React.useCallback(function()
		if not canCreateProduct then
			return
		end

		sendBuildExperienceEvent("MONETIZATION_CREATE_CLICK", v11)

		if data.onCreateProduct ~= nil then
			data.onCreateProduct()
			return
		end

		GetBuildPromptDraftStore().queueDraft({
			universeId = data.universeId,
			sessionId = data.sessionId,
			text = v9.createProductPrompt
		})

		onComposerActivated()
	end, {
		onComposerActivated,
		v9.createProductPrompt,
		canCreateProduct,
		data.onCreateProduct,
		data.sessionId,
		data.universeId,
		v11
	})

	local onRetryCatalog = React.useCallback(function()
		sendBuildExperienceEvent("MONETIZATION_RETRY_CLICK", v11)

		if data.onRetryCatalog ~= nil then
			data.onRetryCatalog()
		end
	end, { data.onRetryCatalog, v11 })
	local onRetryCatalogSource

	if FFlagBuildExperienceMonetizationMultiKind then
		onRetryCatalogSource = React.useCallback(function(p)
			sendMonetizationEvent("MONETIZATION_RETRY_CLICK", v11, { catalogKind = tostring(p) }) -- inferred equivalent call

			if data.onRetryCatalogSource ~= nil then
				data.onRetryCatalogSource(p)
			end
		end, { data.onRetryCatalogSource, v11 })
	end

	local kindSaleCapabilities = getKindSaleCapabilities(state2) -- inferred equivalent call
	local priceInRobux

	if state2 ~= nil then
		priceInRobux = state2.priceInRobux
	end

	local regionalPricingViewState = getRegionalPricingViewState(data, state2, v13, state6, v9)

	local kindEditState = getKindEditState(state2, v13, data)
	local v20 = {}
	v20.mode = state
	local keyboardHeight

	if FFlagBuildExperienceDeveloperProductContext then
		keyboardHeight = state ~= "detail" and 0 or v19
	end

	v20.keyboardHeight = keyboardHeight

	v20.chatActions = chatActions
	v20.products = products
	v20.catalogSources = data.catalogSources
	v20.showOptions = FFlagBuildExperienceMonetizationNativeUI and data.showOptions == true
	v20.optionsLoadStatus = v12.loadStatus
	v20.canMonetize = v12.canMonetize
	v20.canCreateProduct = canCreateProduct
	v20.canChangeManagedPricing = v12.canChangeManagedPricing
	v20.managedPricingState = v12.managedPricingState
	v20.managedPricingSupportingText = v12.managedPricingSupportingText
	v20.shopButtonEnabled = v12.shopButtonEnabled
	v20.isOptionsManagedPricingPending = v12.isManagedPricingPending
	v20.isShopButtonPending = v12.isShopButtonPending
	v20.managedPricingError = v12.managedPricingError
	v20.shopButtonError = v12.shopButtonError
	v20.showManagedPricingAcknowledgement = v12.showAcknowledgement
	v20.disableDialogPortal = data.disableDialogPortal
	v20.selectedProduct = state2
	local isProductDisabled

	if data.isProductDisabled == true then
		isProductDisabled = true
	elseif canManageProduct(state2) then -- inferred equivalent call
		isProductDisabled = isProductMutationDisabled(state2) -- inferred equivalent call
	else
		isProductDisabled = false

		if getKindSaleCapabilities(state2) ~= nil then -- inferred equivalent call
			isProductDisabled = isProductMutationDisabled(state2) -- inferred equivalent call
		end
	end

	v20.isProductDisabled = isProductDisabled

	v20.isProductManagedPricingPending = state5
	v20.isProductSaleStatusPending = isProductSaleStatusPending
	v20.isProductEditPending = isProductEditPending
	v20.canUpdateProductManagedPricing = regionalPricingViewState.canUpdate
	local canManageProduct2 = FFlagBuildExperienceMonetizationProductEditing

	if canManageProduct2 then
		canManageProduct2 = canManageProduct(state2) -- inferred equivalent call

		if canManageProduct2 then
			if v13 then
				if data.onUpdateProductSaleStatus == nil then
					canManageProduct2 = false
				else
					canManageProduct2 = data.onUpdateProduct ~= nil
				end
			else
				canManageProduct2 = v13
			end
		end
	end

	v20.canManageProduct = canManageProduct2

	v20.canChangeKindManagedPricing = regionalPricingViewState.canChangeKind
	v20.canEditKindProduct = kindEditState.canEdit
	v20.canEditName = kindEditState.canEditName
	v20.canEditPrice = kindEditState.canEditPrice
	local canChangeSaleStatus

	if FFlagBuildExperienceMonetizationManageKinds then
		if v13 then
			canChangeSaleStatus = false

			if getKindSaleCapabilities(state2) ~= nil then -- inferred equivalent call
				canChangeSaleStatus = data.onUpdateProductKindSaleStatus ~= nil
			end
		else
			canChangeSaleStatus = v13
		end
	end

	v20.canChangeSaleStatus = canChangeSaleStatus

	v20.productManagedPricingError = state6
	v20.productManagedPricingErrorLabel = regionalPricingViewState.errorLabel
	v20.productSaleStatusError = productSaleStatusError ~= false
	local productSaleStatusErrorLabel

	if FFlagBuildExperienceMonetizationManageKinds and productSaleStatusError and kindSaleCapabilities ~= nil then
		if kindSaleCapabilities.priceRequiredForSale and priceInRobux == nil then
			productSaleStatusErrorLabel = v9.kindPriceRequiredForSale
		else
			productSaleStatusErrorLabel = v9.updateError
		end
	end

	v20.productSaleStatusErrorLabel = productSaleStatusErrorLabel

	v20.productEditError = productEditError
	v20.editName = editName
	v20.editDescription = editDescription
	v20.editPrice = editPrice
	v20.catalogStatus = data.catalogStatus or "Ready"
	v20.emptyTitle = v9.emptyTitle
	v20.emptyDescription = v9.emptyDescription
	v20.onClose = onClose
	v20.onOpenCreate = onOpenCreate
	v20.onOpenOptions = fn2
	v20.onManagedPricingChanged = v12.onManagedPricingChanged
	v20.onShopButtonChanged = v12.onShopButtonChanged
	v20.onConfirmManagedPricing = v12.onConfirmManagedPricing
	v20.onCancelManagedPricing = v12.onCancelManagedPricing
	v20.onRetryOptions = v12.onRetry
	v20.onProductActivated = onProductActivated
	v20.onProductManagedPricingChanged = onProductManagedPricingChanged
	v20.onProductSaleStatusChanged = onProductSaleStatusChanged
	v20.onOpenProductEdit = onOpenProductEdit
	v20.onEditNameChanged = onEditNameChanged
	v20.onEditDescriptionChanged = onEditDescriptionChanged
	v20.onEditPriceChanged = onEditPriceChanged
	v20.onCancelProductEdit = onCancelProductEdit
	v20.onSaveProductEdit = onSaveProductEdit
	v20.onRetryCatalog = onRetryCatalog
	v20.onRetryCatalogSource = onRetryCatalogSource
	v20.labels = {
		title = v9.title,
		options = v12.labels.options,
		pricingOptions = v12.labels.pricingOptions,
		pricingOptionsDescription = v12.labels.pricingOptionsDescription,
		managedPricing = v12.labels.managedPricing,
		managedPricingDescription = v12.labels.managedPricingDescription,
		shopUI = v12.labels.shopUI,
		shopButton = v12.labels.shopButton,
		shopButtonDescription = v12.labels.shopButtonDescription,
		optionsLoadError = v12.labels.optionsLoadError,
		permissionDenied = v12.labels.permissionDenied,
		mixed = v12.labels.mixed,
		unavailable = v12.labels.unavailable,
		noEligibleProducts = v12.labels.noEligibleProducts,
		optionsUpdateError = v12.labels.optionsUpdateError,
		partialUpdateError = v12.labels.partialUpdateError,
		acknowledgementTitle = v12.labels.acknowledgementTitle,
		acknowledgementDescription = v12.labels.acknowledgementDescription,
		agree = v12.labels.agree,
		emptyCreateProduct = v9.emptyCreateProduct,
		pricing = v9.pricing,
		regionalPricing = v9.regionalPricing,
		loading = v9.loading,
		loadErrorTitle = v9.loadErrorTitle,
		loadErrorDescription = v9.loadErrorDescription,
		retry = v9.retry,
		updateError = v9.updateError,
		availableForPurchase = v9.availableForPurchase,
		edit = v9.edit,
		editProduct = v9.editProduct,
		name = v9.name,
		description = v9.description,
		price = v9.price,
		priceError = v9.priceError,
		priceRequiredForSale = v9.priceRequiredForSale,
		cancel = v9.cancel,
		save = v9.save
	}
	return v20
end

return useMonetizationPageViewModel
