local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBuilder
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatComposer")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatActions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local useOnScreenKeyboardHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOnScreenKeyboardHeight")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local GetBuildPromptDraftStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptDraftStore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local formatError = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/formatError")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceMonetizationMultiKind = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationMultiKind")
local FFlagBuildExperienceDeveloperProductContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDeveloperProductContext")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local FFlagBuildExperienceMonetizationProductEditing = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationProductEditing")
local FFlagBuildExperienceMonetizationManageKinds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationManageKinds")

local FFlagBuildExperienceMonetizationKindRegionalPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationKindRegionalPricing")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationPageFixes") and FFlagBuildExperienceDeveloperProductContext

local fFlagBuildExperienceRemoveDevProductPriceCap = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceRemoveDevProductPriceCap

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageView")
local getProductKindCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/getProductKindCapabilities")

local v6 = {}
local v7

if FFlagBuildExperienceDeveloperProductContext then
	v7 = urlBuilder.fromString("apis:developer-products/v2/universes/{universeId}/developer-products/{productId}/creator")
else
	v7 = nil
end

local v8

if v5 then
	v8 = urlBuilder.fromString("apis:game-passes/v1/universes/{universeId}/game-passes/{productId}/creator")
else
	v8 = nil
end

local v9

if v5 then
	v9 = urlBuilder.fromString("apis:experience-subscriptions/v1/experiences/{universeId}/experience-subscriptions/{productId}")
else
	v9 = nil
end

local FFlagBuildExperienceDevProductModerationReadback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductModerationReadback")
local wasDeveloperProductTextModerated = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/wasDeveloperProductTextModerated")

local function logProductMutationFailure(p2, p3, p4)
	if not FFlagBuildExperienceMonetizationNativeUI then
		return
	end

	local v10 = string.gsub(formatError(p4), "[\r\n]+", " ")
	local productKind = p3.productKind or "DeveloperProduct"
	warn(`[{productKind}] action={p2} productId={p3.id} failed={string.sub(v10, 1, 200)}`)
end

local function formatLogError(p2)
	return (string.sub(string.gsub(formatError(p2), "[\r\n]+", " "), 1, 200))
end

local function sendMonetizationEvent(p2, p3, p4)
	if p4 == nil then
		sendBuildExperienceEvent(p2, p3)
	else
		sendBuildExperienceEvent(p2, p3, p4)
	end
end

local function noop(p2) end

local v10 = {
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

local v11 = {
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

local function trim(value)
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function textLength(list)
	return utf8.len(list) or #list
end

local function productIdentity(p2)
	return p2.identity or p2.id
end

local function canManageProduct(p2): boolean
	return p2 ~= nil
		and (p2.productKind == nil or p2.productKind == "DeveloperProduct")
		and p2.canManage ~= false
end

local function canDescribeKindProduct(p2)
	local v12 = v5

	if v12 then
		v12 = not (p2 == nil) and (p2.productKind == "GamePass" or p2.productKind == "Subscription")
	end

	return v12
end

local function hasProductComposer(p2)
	local v12

	if p2 == nil or p2.productKind ~= nil and p2.productKind ~= "DeveloperProduct" then
		v12 = false
	else
		v12 = p2.canManage ~= false
	end

	if v12 then
		return v12
	end

	v12 = v5

	if v12 then
		v12 = not (p2 == nil) and (p2.productKind == "GamePass" or p2.productKind == "Subscription")
	end

	return v12
end

local function productResourceUrl(universeId, state)
	local v12 = { universeId = universeId, productId = state.id }
	local v13 = v5

	if v13 then
		if state == nil then
			v13 = false
		else
			v13 = state.productKind == "GamePass" or state.productKind == "Subscription"
		end
	end

	if not v13 then
		return v7(v12)
	end

	if state.productKind == "GamePass" then
		return (v8(v12))
	end

	return (v9(v12))
end

local function getKindSaleCapabilities(p2)
	if not FFlagBuildExperienceMonetizationManageKinds then
		return nil
	end

	local v13 = if p2 ~= nil then p2.productKind else nil
	return getProductKindCapabilities(v13)
end

local function getKindRegionalPricingCapabilities(p2)
	local v12

	if FFlagBuildExperienceMonetizationManageKinds then
		local v14 = if p2 ~= nil then p2.productKind else nil
		v12 = getProductKindCapabilities(v14)
	end

	if FFlagBuildExperienceMonetizationKindRegionalPricing and v12 ~= nil and v12.regionalPricing then
		return v12
	end

	return nil
end

local function canEditKindProduct(p2)
	local v12 = FFlagBuildExperienceMonetizationProductEditing

	if not v12 then
		return v12
	end

	local v13

	if FFlagBuildExperienceMonetizationManageKinds then
		local v15 = if p2 ~= nil then p2.productKind else nil
		v13 = getProductKindCapabilities(v15)
	end

	v12 = v13 ~= nil
	return v12
end

local function canEditProduct(p2)
	local v12

	if p2 == nil or p2.productKind ~= nil and p2.productKind ~= "DeveloperProduct" then
		v12 = false
	else
		v12 = p2.canManage ~= false
	end

	if v12 then
		return v12
	end

	v12 = FFlagBuildExperienceMonetizationProductEditing

	if not v12 then
		return v12
	end

	local v13

	if FFlagBuildExperienceMonetizationManageKinds then
		local v15 = if p2 ~= nil then p2.productKind else nil
		v13 = getProductKindCapabilities(v15)
	end

	v12 = v13 ~= nil
	return v12
end

local function canOpenProductEdit(p2, p3)
	local v12

	if p3 == nil or p3.productKind ~= nil and p3.productKind ~= "DeveloperProduct" then
		v12 = false
	else
		v12 = p3.canManage ~= false
	end

	if not v12 then
		v12 = FFlagBuildExperienceMonetizationProductEditing

		if v12 then
			local v13

			if FFlagBuildExperienceMonetizationManageKinds then
				local v15 = if p3 ~= nil then p3.productKind else nil
				v13 = getProductKindCapabilities(v15)
			end

			v12 = v13 ~= nil
		end
	end

	if not v12 then
		return v12
	end

	if p2.onUpdateProductKind == nil then
		local v13 = FFlagBuildExperienceMonetizationProductEditing

		if v13 then
			local v14

			if FFlagBuildExperienceMonetizationManageKinds then
				local v16 = if p3 ~= nil then p3.productKind else nil
				v14 = getProductKindCapabilities(v16)
			end

			v13 = v14 ~= nil
		end

		v12 = not v13
	else
		v12 = true
	end

	return v12
end

local function canEditProductName(p2)
	local v12

	if not FFlagBuildExperienceMonetizationManageKinds then
		return v12 == nil or v12.editableName
	end

	local v14 = if p2 ~= nil then p2.productKind else nil
	v12 = getProductKindCapabilities(v14)

	return v12 == nil or v12.editableName
end

local function getEditedProductName(p2, value)
	local v12

	if FFlagBuildExperienceMonetizationManageKinds then
		local v14 = if p2 ~= nil then p2.productKind else nil
		v12 = getProductKindCapabilities(v14)
	end

	if v12 == nil or v12.editableName then
		return string.match(value, "^%s*(.-)%s*$") or ""
	end

	return nil
end

local function canEditProductPrice(p2)
	local v12

	if not FFlagBuildExperienceMonetizationManageKinds then
		return v12 == nil or v12.editablePrice
	end

	local v14 = if p2 ~= nil then p2.productKind else nil
	v12 = getProductKindCapabilities(v14)

	return v12 == nil or v12.editablePrice
end

local function getEditTelemetryParameters(p2)
	local editTelemetryParameters = { productId = p2.id }
	local v12 = FFlagBuildExperienceMonetizationProductEditing

	if v12 then
		local v13

		if FFlagBuildExperienceMonetizationManageKinds then
			local v15 = if p2 ~= nil then p2.productKind else nil
			v13 = getProductKindCapabilities(v15)
		end

		v12 = v13 ~= nil
	end

	if v12 and p2.productKind ~= nil then
		editTelemetryParameters.productKind = p2.productKind
	end

	return editTelemetryParameters
end

local function findProduct(items, p2)
	if p2 == nil then
		return nil
	end

	for k, item in items do
		if (item.identity or item.id) == p2 then
			return item
		end
	end

	return nil
end

local v12 = {
	managedPricing = { "isManagedPricingEnabled" },
	saleStatus = { "isForSale" },
	details = { "name", "description", "priceInRobux", "price" }
}

local function withOverride(p2, p3)
	return function(p4)
		local v13 = p2
		local identity = v13.identity or v13.id

		local clone = table.clone(p4[identity] or {})
		clone[p3] = p2
		local clone2 = table.clone(p4)
		clone2[identity] = clone
		return clone2
	end
end

local function withoutOverride(p2, p3)
	return function(p4)
		if (p4[p2] or {})[p3] == nil then
			return p4
		end

		local clone = table.clone(p4[p2])
		clone[p3] = nil
		local clone2 = table.clone(p4)
		clone2[p2] = clone

		if next(clone) == nil then
			clone2[p2] = nil
		end

		return clone2
	end
end

local function applyProductOverrides(p2, items)
	if items == nil then
		return p2
	end

	local clone = table.clone(p2)

	for k, item in items do
		for k2, v13 in v12[k] do
			clone[v13] = item[v13]
		end
	end

	return clone
end

local function clearReadBackOverrides(products, state, setState)
	for k, item in state do
		local v13

		if k == nil then
			v13 = nil
		else
			local flag = true

			for k2, item2 in products do
				if (item2.identity or item2.id) == k then
					v13 = item2
					flag = false
					break
				end
			end

			if flag then
				v13 = nil
			end
		end

		local details = item.details

		if
			v13 ~= nil
			and details ~= nil
			and v13.name == details.name
			and v13.description == details.description
			and v13.priceInRobux == details.priceInRobux
		then
			local v14 = "details"
			setState(function(p2)
				if (p2[k] or {})[v14] == nil then
					return p2
				end

				local clone = table.clone(p2[k])
				clone[v14] = nil
				local clone2 = table.clone(p2)
				clone2[k] = clone

				if next(clone) == nil then
					clone2[k] = nil
				end

				return clone2
			end)
		end

		local function clearReadBackToggle(p2, p3)
			local v15 = item[p2]

			if v13 == nil or v15 == nil then
				return
			end

			if (v13[p3] == true) == (v15[p3] == true) then
				local v16 = k
				setState(function(p4)
					if (p4[v16] or {})[p2] == nil then
						return p4
					end

					local clone = table.clone(p4[v16])
					clone[p2] = nil
					local clone2 = table.clone(p4)
					clone2[v16] = clone

					if next(clone) == nil then
						clone2[v16] = nil
					end

					return clone2
				end)
			end
		end

		local managedPricing = item.managedPricing

		if
			v13 ~= nil
			and managedPricing ~= nil
			and (v13.isManagedPricingEnabled == true) == (managedPricing.isManagedPricingEnabled == true)
		then
			local v15 = "managedPricing"
			setState(function(p2)
				if (p2[k] or {})[v15] == nil then
					return p2
				end

				local clone = table.clone(p2[k])
				clone[v15] = nil
				local clone2 = table.clone(p2)
				clone2[k] = clone

				if next(clone) == nil then
					clone2[k] = nil
				end

				return clone2
			end)
		end

		local saleStatus = item.saleStatus

		if not (v13 ~= nil and saleStatus ~= nil and (v13.isForSale == true) == (saleStatus.isForSale == true)) then
			continue
		end

		local v15 = "saleStatus"
		setState(function(p2)
			if (p2[k] or {})[v15] == nil then
				return p2
			end

			local clone = table.clone(p2[k])
			clone[v15] = nil
			local clone2 = table.clone(p2)
			clone2[k] = clone

			if next(clone) == nil then
				clone2[k] = nil
			end

			return clone2
		end)
	end
end

local function useManageProductState(data)
	local useRef = React.useRef
	local v13 = if data ~= nil then data.identity or data.id else nil

	local v14 = useRef(v13)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(nil)

	local state5, setState5 = React.useState(data == nil and "" or data.name)

	local state6, setState6 = React.useState(data == nil and "" or data.description)
	local state7, setState7 = React.useState((data == nil or data.priceInRobux == nil) and "" or tostring(data.priceInRobux))

	return {
		selectedProductIdRef = v14,
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

	for k, item in items do
		local v13

		if item == nil or item.productKind ~= nil and item.productKind ~= "DeveloperProduct" then
			v13 = false
		else
			v13 = item.canManage ~= false
		end

		if not (v13 and item.isForSale == true and item.isArchived ~= true and item.isImmutable ~= true) then
			continue
		end

		if not (item.isInActivePriceOptimizationExperiment ~= true and item.priceInRobux ~= nil and item.priceInRobux > 0) then
			continue
		end

		table.insert(eligibleProducts, item)
	end

	return eligibleProducts
end

local function isProductMutationDisabled(data): boolean
	return data ~= nil
		and (data.isArchived == true or data.isImmutable == true or data.isInActivePriceOptimizationExperiment == true)
end

local function validateProductEdit(p2, list, editDescription, editPrice, data)
	if list ~= nil then
		if list == "" then
			return data.nameRequiredError
		end

		if (utf8.len(list) or #list) > 50 then
			return data.nameLengthError
		end
	end

	if (utf8.len(editDescription) or #editDescription) > 1000 then
		return data.descriptionLengthError
	end

	local v13

	if FFlagBuildExperienceMonetizationManageKinds then
		local v15 = if p2 ~= nil then p2.productKind else nil
		v13 = getProductKindCapabilities(v15)
	end

	if v13 ~= nil and not v13.editablePrice then
		return nil, nil
	end

	local v14 = tonumber(editPrice)
	local isForSale = p2.isForSale == true

	if
		editPrice == "" and isForSale
		or editPrice ~= "" and v14 == nil
		or v14 ~= nil and v14 % 1 ~= 0
		or v14 ~= nil and v14 < 1
		or not fFlagBuildExperienceRemoveDevProductPriceCap and v14 ~= nil and v14 > 1000000000
	then
		return data.priceError
	end

	return nil, v14
end

local function resolveProductEditSubmit(data, p2)
	local v13 = FFlagBuildExperienceMonetizationProductEditing

	if v13 then
		local v14

		if FFlagBuildExperienceMonetizationManageKinds then
			local v16 = if p2 ~= nil then p2.productKind else nil
			v14 = getProductKindCapabilities(v16)
		end

		v13 = v14 ~= nil
	end

	if v13 then
		local onUpdateProductKind = data.onUpdateProductKind

		if onUpdateProductKind == nil then
			return nil
		end

		return function(p3)
			return onUpdateProductKind(p2.productKind, p2.id, p3)
		end
	else
		local onUpdateProduct = data.onUpdateProduct
		local id = tonumber(p2.id)

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

local function applyProductEditResult(data, data2, p2, editDescription, p3)
	local clone = table.clone(data)

	if p2 == nil then
		clone.name = data2.name or data.name
	else
		local v13 = if FFlagBuildExperienceDevProductModerationReadback then data2.name or "" else data2.name or p2
		clone.name = v13
	end

	local v13

	if FFlagBuildExperienceDevProductModerationReadback then
		v13 = data2.description or ""
	else
		v13 = if data2.description == nil then editDescription else data2.description
	end

	clone.description = v13

	local v15 = (if data2.priceInformation ~= nil then data2.priceInformation.defaultPriceInRobux else nil)
		or p3
		or data.priceInRobux
	clone.priceInRobux = v15
	local v16 = if v15 == nil then data.price else tostring(v15)
	clone.price = v16
	local v17

	if FFlagBuildExperienceDevProductModerationReadback then
		v17 = wasDeveloperProductTextModerated(p2, data2.name) or wasDeveloperProductTextModerated(editDescription, data2.description)
	elseif p2 == nil or data2.name == nil or data2.name == p2 then
		v17 = not (data2.description == nil) and data2.description ~= editDescription
	else
		v17 = true
	end

	return clone, v17
end

local function getKindEditState(state, p2, data)
	if state ~= nil then
		local v13 = FFlagBuildExperienceMonetizationProductEditing

		if v13 then
			local v14

			if FFlagBuildExperienceMonetizationManageKinds then
				local v16 = if state ~= nil then state.productKind else nil
				v14 = getProductKindCapabilities(v16)
			end

			v13 = v14 ~= nil
		end

		if v13 and p2 and data.onUpdateProductKind ~= nil then
			local v15

			if FFlagBuildExperienceMonetizationManageKinds then
				local v17 = if state ~= nil then state.productKind else nil
				v15 = getProductKindCapabilities(v17)
			end

			local v14 = {
				canEdit = true,
				canEditName = v15 == nil or v15.editableName,
				canEditPrice = 0
			}
			local v16

			if FFlagBuildExperienceMonetizationManageKinds then
				local v18 = if state ~= nil then state.productKind else nil
				v16 = getProductKindCapabilities(v18)
			end

			v14.canEditPrice = v16 == nil or v16.editablePrice
			return v14
		end
	end

	return {}
end

local function getManagedPricingState(p2, list): string
	if p2 == nil or p2 == "Disabled" then
		return "Unavailable"
	end

	local count = 0

	for k, item in list do
		if item.isManagedPricingEnabled == true then
			count += 1
		end
	end

	if count == 0 then
		return "AllOff"
	end

	if count == #list then
		return "AllOn"
	end

	return "Mixed"
end

local function getShopButtonEnabled(shops): boolean
	local v13 = if shops ~= nil then shops[1] else nil

	for k, v14 in (v13 == nil or v13.entryPoints == nil) and {} or v13.entryPoints do
		if v14.name == "InExperienceGlobalIconEnabled" then
			return v14.isEnabled == true
		end
	end

	return false
end

local function combineLoadStatus(items): string
	for k, item in items do
		if item == "Failed" then
			return "Failed"
		end
	end

	for k, item in items do
		if item ~= "Ready" then
			return "NotReady"
		end
	end

	return "Ready"
end

local function getDisplayedManagedPricingState(p2, p3)
	if p2 == nil then
		return p3
	end

	if p2 then
		return "AllOn"
	end

	return "AllOff"
end

local function useOptionsState(data, products, p2, ref, p3)
	local v13 = useLocalization({
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

	local managedPricingStatus = data.managedPricingStatus
	local v14

	if managedPricingStatus == nil or managedPricingStatus == "Disabled" then
		v14 = "Unavailable"
	else
		local count = 0

		for k, eligibleProduct in eligibleProducts do
			if eligibleProduct.isManagedPricingEnabled == true then
				count += 1
			end
		end

		v14 = if count == 0 then "AllOff" elseif count == #eligibleProducts then "AllOn" else "Mixed"
	end

	local shopButtonEnabled = getShopButtonEnabled(data.shops)
	local v15 = {
		data.managedPricingLoadStatus or "NotReady",
		data.shopsLoadStatus or "NotReady",
		data.permissionLoadStatus or "NotReady"
	}
	local flag = true
	local v16

	for k, v17 in v15 do
		if v17 == "Failed" then
			v16 = "Failed"
			flag = false
			break
		end
	end

	if flag then
		local flag2 = true

		for k, v17 in v15 do
			if v17 ~= "Ready" then
				v16 = "NotReady"
				flag2 = false
				break
			end
		end

		if flag2 then
			v16 = "Ready"
		end
	end

	local v17 = v16 == "Ready" and data.permissionCanMonetize == true
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
		if state3 ~= nil and (state3 and v14 == "AllOn" or not state3 and v14 == "AllOff") then
			setState3(nil)
		end
	end, { v14, state3 })

	React.useEffect(function()
		if state4 ~= nil and state4 == shopButtonEnabled then
			setState4(nil)
		end
	end, { state4, shopButtonEnabled })

	local v18 = React.useCallback(function(p4, p5)
		local onUpdateManagedPricing = data.onUpdateManagedPricing

		if
			ref.current ~= p3
			or ref2.current ~= nil
			or state
			or not v17
			or onUpdateManagedPricing == nil
			or data.managedPricingStatus == nil
			or data.managedPricingStatus == "Disabled"
			or #eligibleProducts == 0
		then
			return
		end

		local ids = {}

		for k, eligibleProduct in eligibleProducts do
			local id = tonumber(eligibleProduct.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		if #ids == 0 then
			setState7(false)
			return
		end

		local v19 = {}
		ref2.current = v19

		setState5(nil)
		setState3(p4)
		setState(true)
		local v20

		if p5 and data.onAcceptManagedPricing ~= nil then
			v20 = data.onAcceptManagedPricing():andThen(function()
				if ref.current == p3 and ref2.current == v19 then
					return onUpdateManagedPricing(ids, p4)
				end

				return nil
			end)
		else
			v20 = onUpdateManagedPricing(ids, p4)
		end

		v20:andThen(function(p6)
			if ref.current ~= p3 or ref2.current ~= v19 then
				return
			end

			setState7(false)

			if type(p6) == "table" and type(p6.errors) == "table" and #p6.errors > 0 then
				warn(`[MonetizationOptions] Managed Pricing update partially failed (universeId={tostring(p2.universeId)})`)

				local v21 = p2
				local v22 = { action = "managed_pricing", failureType = "partial" }

				if v22 == nil then
					sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v21)
				else
					sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v21, v22)
				end

				setState3(nil)
				setState5(v13.partialUpdateError)
			else
				local v21 = p2
				local v22 = { action = "managed_pricing" }

				if v22 == nil then
					sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", v21)
				else
					sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", v21, v22)
				end
			end
		end):catch(function(p6)
			if ref.current ~= p3 or ref2.current ~= v19 then
				return
			end

			warn(`[MonetizationOptions] Managed Pricing update failed (universeId={tostring(p2.universeId)}): {string.sub(string.gsub(module7(p6), "[\r\n]+", " "), 1, 200)}`)

			local v21 = p2
			local v22 = { action = "managed_pricing", failureType = "request" }

			if v22 == nil then
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v21)
			else
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v21, v22)
			end

			setState7(false)
			setState3(nil)
			setState5(v13.optionsUpdateError)
		end):finally(function()
			if ref.current == p3 and ref2.current == v19 then
				ref2.current = nil
				setState(false)
			end
		end)
	end, {
		v17,
		eligibleProducts,
		state,
		v13.optionsUpdateError,
		v13.partialUpdateError,
		data.managedPricingStatus,
		data.onAcceptManagedPricing,
		data.onUpdateManagedPricing,
		p2,
		p3
	})

	local v19 = React.useCallback(function(p4)
		if
			ref.current ~= p3
			or not v17
			or data.onUpdateManagedPricing == nil
			or data.managedPricingStatus == nil
			or data.managedPricingStatus == "Disabled"
			or #eligibleProducts == 0
		then
			return
		end

		if data.managedPricingStatus == "Pending" and p4 then
			setState7(true)
		else
			v18(p4, false)
		end
	end, {
		v17,
		eligibleProducts,
		data.managedPricingStatus,
		data.onUpdateManagedPricing,
		v18
	})

	local v20 = React.useCallback(function(p4)
		local onSetShopButton = data.onSetShopButton

		if ref.current ~= p3 or ref3.current ~= nil or state2 or not v17 or onSetShopButton == nil then
			return
		end

		local v21 = {}
		ref3.current = v21
		setState6(nil)
		setState4(p4)
		setState2(true)
		onSetShopButton(p4):andThen(function()
			if ref.current ~= p3 or ref3.current ~= v21 then
				return
			end

			local v22 = p2
			local v23 = { action = "shop_button" }

			if v23 == nil then
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", v22)
			else
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_SUCCESS", v22, v23)
			end
		end):catch(function(p5)
			if ref.current ~= p3 or ref3.current ~= v21 then
				return
			end

			warn(`[MonetizationOptions] Shop button update failed (universeId={tostring(p2.universeId)}): {string.sub(string.gsub(module7(p5), "[\r\n]+", " "), 1, 200)}`)

			local v22 = p2
			local v23 = { action = "shop_button", failureType = "request" }

			if v23 == nil then
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v22)
			else
				sendBuildExperienceEvent("MONETIZATION_OPTIONS_UPDATE_FAILURE", v22, v23)
			end

			setState4(nil)
			setState6(v13.optionsUpdateError)
		end):finally(function()
			if ref.current == p3 and ref3.current == v21 then
				ref3.current = nil
				setState2(false)
			end
		end)
	end, { v17, state2, v13.optionsUpdateError, data.onSetShopButton, p2, p3 })
	local v21 = state3 ~= nil and (state3 and "AllOn" or "AllOff") or v14
	local v22 = {
		loadStatus = v16,
		canMonetize = v17,
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
	local v23

	if v17 then
		if data.onUpdateManagedPricing == nil or not (#eligibleProducts > 0) then
			v23 = false
		else
			v23 = v21 ~= "Unavailable"
		end
	else
		v23 = v17
	end

	v22.canChangeManagedPricing = v23

	v22.managedPricingState = v21
	local v24 = if #eligibleProducts == 0 and v21 ~= "Unavailable" then v13.noEligibleProducts else nil
	v22.managedPricingSupportingText = v24

	local v25 = if state4 == nil then shopButtonEnabled else state4
	v22.shopButtonEnabled = v25
	v22.isManagedPricingPending = state
	v22.isShopButtonPending = state2
	v22.managedPricingError = state5
	v22.shopButtonError = state6
	v22.showAcknowledgement = state7
	v22.onManagedPricingChanged = v19
	v22.onShopButtonChanged = v20
	function v22.onConfirmManagedPricing()
		v18(true, true)
	end
	function v22.onCancelManagedPricing()
		if not state then
			setState7(false)
		end
	end
	v22.onRetry = data.onRetryOptions or function() end
	v22.labels = v13
	return v22
end

local function getRegionalPricingViewState(data, state, canChangeKind, state2, p2)
	local v13

	if FFlagBuildExperienceMonetizationManageKinds then
		local v15 = if state ~= nil then state.productKind else nil
		v13 = getProductKindCapabilities(v15)
	end

	if not FFlagBuildExperienceMonetizationKindRegionalPricing or v13 == nil or not v13.regionalPricing then
		v13 = nil
	end

	local priceInRobux = if state ~= nil then state.priceInRobux else nil

	local v14 = if v13 == nil then data.onUpdateProductManagedPricing ~= nil else data.onUpdateProductKindManagedPricing ~= nil

	if FFlagBuildExperienceMonetizationKindRegionalPricing then
		if canChangeKind then
			canChangeKind = not (v13 == nil) and data.onUpdateProductKindManagedPricing ~= nil
		end
	else
		canChangeKind = nil
	end

	local v15

	if not (v13 == nil or not state2) then
		v15 = if priceInRobux == nil then p2.kindPriceRequiredForRegionalPricing else p2.updateError
	end

	return { canUpdate = v14, canChangeKind = canChangeKind, errorLabel = v15 }
end

local function getInitialSelection(p2, list)
	local initialMode = if FFlagBuildExperienceMonetizationNativeUI or p2.initialMode ~= "options" then p2.initialMode else nil

	if initialMode == "detail" or FFlagBuildExperienceMonetizationProductEditing and initialMode == "edit" then
		return initialMode, list[1]
	end

	return initialMode, nil
end

local function useMonetizationLocalization()
	local v15 = if FFlagBuildExperienceDeveloperProductContext then LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER else nil
	local v14 = {
		composerPlaceholder = v15,
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

	local v16 = if FFlagBuildExperienceMonetizationManageKinds then LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_KIND_SALE else nil
	v14.kindPriceRequiredForSale = v16

	local v17 = if FFlagBuildExperienceMonetizationKindRegionalPricing then LocalizationStrings.MONETIZATION_PRICE_REQUIRED_FOR_REGIONAL_PRICING else nil
	v14.kindPriceRequiredForRegionalPricing = v17
	return useLocalization(v14)
end

local function useMonetizationPageViewModel(data)
	local v13 = useMonetizationLocalization()
	local products = data.products or v6
	local initialMode = if FFlagBuildExperienceMonetizationNativeUI or data.initialMode ~= "options" then data.initialMode else nil

	local v14 = if initialMode == "detail" or FFlagBuildExperienceMonetizationProductEditing and initialMode == "edit" then products[1] else nil

	local v15 = React.useMemo(function()
		return {
			universeId = data.universeId,
			placeId = data.placeId,
			conversationId = data.sessionId,
			messageId = nil,
			turnId = nil,
			chatOpenId = nil
		}
	end, { data.placeId or 0, data.sessionId or "", data.universeId or 0 })
	local v16 = React.useMemo(function()
		return {}
	end, { data.universeId or 0 })
	local ref = React.useRef(nil)
	React.useLayoutEffect(function()
		ref.current = v16
		return function()
			if ref.current == v16 then
				ref.current = nil
			end
		end
	end, { v16 })
	local v17 = v11

	if FFlagBuildExperienceMonetizationNativeUI then
		v17 = useOptionsState(data, products, v15, ref, v16)
	end

	local v18 = not FFlagBuildExperienceMonetizationMultiKind

	if not v18 then
		v18 = data.permissionLoadStatus == "Ready" and data.permissionCanMonetize == true
	end

	local v19 = #products > 0 and "catalog" or "empty"
	local state, setState = React.useState(initialMode or v19)

	local state2, setState2 = React.useState(v14)

	local setState3 = noop

	local setState4 = noop
	local state3, state4

	if FFlagBuildExperienceMonetizationMultiKind then
		local useState = React.useState
		local v20 = if v14 ~= nil then v14.identity or v14.id else nil

		state3, setState3 = useState(v20)

		state4, setState4 = React.useState({})
	else
		state3 = nil
		state4 = {}
	end

	local v20

	if FFlagBuildExperienceMonetizationMultiKind then
		local v21 = state3

		if v21 ~= nil then
			for k, product in products do
				if (product.identity or product.id) == v21 then
					v20 = product
					break
				end
			end
		end
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		if v20 == nil then
			state2 = nil
		else
			local v22 = if state3 ~= nil then state4[state3] else nil
			state2 = applyProductOverrides(v20, v22)
		end
	end

	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local ref2 = React.useRef(nil)
	local v21 = v10

	if FFlagBuildExperienceMonetizationProductEditing then
		v21 = useManageProductState(v14)
	end

	local selectedProductIdRef = v21.selectedProductIdRef
	local isProductSaleStatusPending = v21.isProductSaleStatusPending
	local setIsProductSaleStatusPending = v21.setIsProductSaleStatusPending
	local productSaleStatusError = v21.productSaleStatusError
	local setProductSaleStatusError = v21.setProductSaleStatusError
	local isProductEditPending = v21.isProductEditPending
	local setIsProductEditPending = v21.setIsProductEditPending
	local productEditError = v21.productEditError
	local setProductEditError = v21.setProductEditError
	local editName = v21.editName
	local setEditName = v21.setEditName
	local editDescription = v21.editDescription
	local setEditDescription = v21.setEditDescription
	local editPrice = v21.editPrice
	local setEditPrice = v21.setEditPrice

	React.useLayoutEffect(function()
		ref2.current = nil
		setState(initialMode or v19)

		if FFlagBuildExperienceMonetizationMultiKind then
			local identity

			if v14 ~= nil then
				local v23 = v14
				identity = v23.identity or v23.id
			end

			setState3(identity)
			setState4({})
		else
			setState2(v14)
		end

		setState5(false)
		setState6(false)

		if FFlagBuildExperienceMonetizationProductEditing then
			local v22 = selectedProductIdRef
			local identity

			if v14 ~= nil then
				local v23 = v14
				identity = v23.identity or v23.id
			end

			v22.current = identity

			setIsProductSaleStatusPending(false)
			setProductSaleStatusError(false)
			setIsProductEditPending(false)
			setProductEditError(nil)
			setEditName(v14 == nil and "" or v14.name)
			setEditDescription(v14 == nil and "" or v14.description)
			setEditPrice((v14 == nil or v14.priceInRobux == nil) and "" or tostring(v14.priceInRobux))
		end
	end, { data.universeId or 0 })
	React.useEffect(function()
		local v22 = v15
		local v23 = { source = "monetization_page" }

		if v23 == nil then
			sendBuildExperienceEvent("MONETIZATION_ENTRY_CLICK", v22)
		else
			sendBuildExperienceEvent("MONETIZATION_ENTRY_CLICK", v22, v23)
		end

		sendBuildExperienceEvent("MONETIZATION_PAGE_IMPRESSION", v15)
	end, { v15 })

	React.useEffect(function()
		if initialMode == nil and (state == "catalog" or state == "empty") and state ~= v19 then
			setState(v19)
		end
	end, { v19, initialMode, state })

	if FFlagBuildExperienceMonetizationMultiKind then
		React.useEffect(function()
			if state3 ~= nil then
				local v22 = products
				local v23 = state3
				local v24

				if v23 ~= nil then
					for k, v26 in v22 do
						if (v26.identity or v26.id) == v23 then
							v24 = v26
							break
						end
					end
				end

				if v24 == nil then
					selectedProductIdRef.current = nil
					setState3(nil)
					setState(v19)
				end
			end

			clearReadBackOverrides(products, state4, setState4)
		end, { v19, state4, products, state3 })
	end

	local function fn()
		local v22 = v15
		local v23 = { mode = tostring(state) }

		if v23 == nil then
			sendBuildExperienceEvent("MONETIZATION_CLOSE_CLICK", v22)
		else
			sendBuildExperienceEvent("MONETIZATION_CLOSE_CLICK", v22, v23)
		end

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

			setState(v19)
		elseif FFlagBuildExperienceMonetizationNativeUI and state == "options" and initialMode ~= "options" then
			setState(v19)
		else
			data.onClose()
		end
	end

	local v24 = React.useCallback(fn, {
		v19,
		if FFlagBuildExperienceMonetizationProductEditing then isProductEditPending else nil,
		state,
		initialMode,
		data.onClose,
		v15,
		setProductEditError
	})

	local v25 = React.useCallback(function(p2)
		for k, product in products do
			if (product.identity or product.id) == p2 then
				local v26 = { productId = product.id }

				if FFlagBuildExperienceMonetizationMultiKind then
					v26.productKind = product.productKind
				end

				local v27 = v15

				if v26 == nil then
					sendBuildExperienceEvent("MONETIZATION_PRODUCT_CLICK", v27)
				else
					sendBuildExperienceEvent("MONETIZATION_PRODUCT_CLICK", v27, v26)
				end

				if FFlagBuildExperienceMonetizationProductEditing then
					setState6(false)
					setProductSaleStatusError(false)
					setProductEditError(nil)
				end

				if FFlagBuildExperienceMonetizationProductEditing then
					selectedProductIdRef.current = product.identity or product.id
				end

				if FFlagBuildExperienceMonetizationMultiKind then
					setState3(p2)
				else
					setState2(product)
				end

				setState("detail")
				break
			end
		end
	end, { products, setProductEditError, setProductSaleStatusError, v15 })

	local fn2 = not FFlagBuildExperienceMonetizationNativeUI and function() end or React.useCallback(function()
		setState("options")
	end, {})

	local function fn3(isManagedPricingEnabled)
		local v26 = state2
		local id = if v26 ~= nil then tonumber(v26.id) else nil
		local onUpdateProductManagedPricing = data.onUpdateProductManagedPricing
		local v27

		if FFlagBuildExperienceMonetizationManageKinds then
			local v29 = if v26 ~= nil then v26.productKind else nil
			v27 = getProductKindCapabilities(v29)
		end

		if not FFlagBuildExperienceMonetizationKindRegionalPricing or v27 == nil or not v27.regionalPricing then
			v27 = nil
		end

		local onUpdateProductKindManagedPricing = data.onUpdateProductKindManagedPricing

		if ref.current == v16 and ref2.current == nil and v26 ~= nil then
			local v28

			if v26 == nil or v26.productKind ~= nil and v26.productKind ~= "DeveloperProduct" then
				v28 = false
			else
				v28 = v26.canManage ~= false
			end

			if (v28 or v27 ~= nil) and v18 then
				local v29

				if v27 == nil then
					v29 = id == nil or onUpdateProductManagedPricing == nil
				else
					v29 = onUpdateProductKindManagedPricing == nil
				end

				if not (v29 or state5 or FFlagBuildExperienceMonetizationProductEditing and isProductSaleStatusPending) then
					local v30

					if v26 == nil then
						v30 = false
					else
						v30 = v26.isArchived == true
							or v26.isImmutable == true
							or v26.isInActivePriceOptimizationExperiment == true
					end

					if not v30 then
						if FFlagBuildExperienceMonetizationNativeUI and isManagedPricingEnabled and v26.priceInRobux == nil then
							setState6(true)
							return
						end

						local v31 = {}
						ref2.current = v31
						local productKind = if v27 ~= nil then v26.productKind else nil
						local v32 = v15
						local v33 = {
							isEnabled = tostring(isManagedPricingEnabled),
							productId = v26.id,
							productKind = productKind
						}

						if v33 == nil then
							sendBuildExperienceEvent("MONETIZATION_MANAGED_PRICING_CLICK", v32)
						else
							sendBuildExperienceEvent("MONETIZATION_MANAGED_PRICING_CLICK", v32, v33)
						end

						local clone = table.clone(v26)
						clone.isManagedPricingEnabled = isManagedPricingEnabled

						if FFlagBuildExperienceMonetizationMultiKind then
							local v34 = "managedPricing"
							setState4(function(p2)
								local v35 = clone
								local identity = v35.identity or v35.id

								local clone2 = table.clone(p2[identity] or {})
								clone2[v34] = clone
								local clone3 = table.clone(p2)
								clone3[identity] = clone2
								return clone3
							end)
						else
							setState2(clone)
						end

						setState6(false)
						setState5(true)
						local v34

						if v27 == nil then
							v34 = onUpdateProductManagedPricing(id, isManagedPricingEnabled)
						else
							v34 = onUpdateProductKindManagedPricing(
								v26.productKind,
								v26.id,
								isManagedPricingEnabled
							)
						end

						v34:andThen(function()
							if ref.current ~= v16 or ref2.current ~= v31 then
								return
							end

							local v35 = v15
							local v36 = {
								action = "managed_pricing",
								productId = v26.id,
								productKind = productKind
							}

							if v36 == nil then
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v35)
							else
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v35, v36)
							end
						end):catch(function(p2)
							if ref.current ~= v16 or ref2.current ~= v31 then
								return
							end

							local v35 = v26

							if FFlagBuildExperienceMonetizationNativeUI then
								local v36 = string.gsub(formatError(p2), "[\r\n]+", " ")
								local productKind2 = v35.productKind or "DeveloperProduct"
								warn(`[{productKind2}] action=managed_pricing productId={v35.id} failed={string.sub(v36, 1, 200)}`)
							end

							if FFlagBuildExperienceMonetizationMultiKind then
								local v37 = v26
								local identity = v37.identity or v37.id

								local v38 = "managedPricing"
								setState4(function(p3)
									if (p3[identity] or {})[v38] == nil then
										return p3
									end

									local clone2 = table.clone(p3[identity])
									clone2[v38] = nil
									local clone3 = table.clone(p3)
									clone3[identity] = clone2

									if next(clone2) == nil then
										clone3[identity] = nil
									end

									return clone3
								end)
							end

							local v36 = v15
							local v37 = {
								action = "managed_pricing",
								productId = v26.id,
								productKind = productKind
							}

							if v37 == nil then
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v36)
							else
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v36, v37)
							end

							if FFlagBuildExperienceMonetizationProductEditing then
								local v38 = v26

								if selectedProductIdRef.current == (v38.identity or v38.id) then
									if not FFlagBuildExperienceMonetizationMultiKind then
										setState2(v26)
									end

									setState6(true)
								end
							else
								if not FFlagBuildExperienceMonetizationMultiKind then
									setState2(v26)
								end

								setState6(true)
							end
						end):finally(function()
							if ref.current == v16 and ref2.current == v31 then
								ref2.current = nil
								setState5(false)
							end
						end)
					end
				end
			end
		end
	end

	local v28 = React.useCallback(fn3, {
		v18,
		state5,
		if FFlagBuildExperienceMonetizationProductEditing then isProductSaleStatusPending else nil,
		data.onUpdateProductManagedPricing,
		state2,
		v15,
		v16,
		data.onUpdateProductKindManagedPricing or false
	})

	local v29 = React.useCallback(function(isForSale)
		local v30 = state2
		local id = if v30 ~= nil then tonumber(v30.id) else nil
		local onUpdateProductSaleStatus = data.onUpdateProductSaleStatus
		local v31

		if FFlagBuildExperienceMonetizationManageKinds then
			local v33 = if v30 ~= nil then v30.productKind else nil
			v31 = getProductKindCapabilities(v33)
		end

		local onUpdateProductKindSaleStatus = data.onUpdateProductKindSaleStatus

		if FFlagBuildExperienceMonetizationProductEditing and ref.current == v16 and ref2.current == nil and v30 ~= nil then
			local v32

			if v30 == nil or v30.productKind ~= nil and v30.productKind ~= "DeveloperProduct" then
				v32 = false
			else
				v32 = v30.canManage ~= false
			end

			if (v32 or v31 ~= nil) and v18 then
				local v33

				if v31 == nil then
					v33 = id == nil or onUpdateProductSaleStatus == nil
				else
					v33 = onUpdateProductKindSaleStatus == nil
				end

				if not (v33 or isProductSaleStatusPending or state5) then
					local v34

					if v30 == nil then
						v34 = false
					else
						v34 = v30.isArchived == true
							or v30.isImmutable == true
							or v30.isInActivePriceOptimizationExperiment == true
					end

					if not v34 then
						if
							FFlagBuildExperienceMonetizationNativeUI
							and isForSale
							and v30.priceInRobux == nil
							and (v31 == nil or v31.priceRequiredForSale)
						then
							setProductSaleStatusError(true)
							return
						end

						local v35 = {}
						ref2.current = v35
						local productKind = if v31 ~= nil then v30.productKind else nil
						local v36 = v15
						local v37 = {
							isEnabled = tostring(isForSale),
							productId = v30.id,
							productKind = productKind
						}

						if v37 == nil then
							sendBuildExperienceEvent("MONETIZATION_SALE_STATUS_CLICK", v36)
						else
							sendBuildExperienceEvent("MONETIZATION_SALE_STATUS_CLICK", v36, v37)
						end

						local clone = table.clone(v30)
						clone.isForSale = isForSale

						if FFlagBuildExperienceMonetizationMultiKind then
							local v38 = "saleStatus"
							setState4(function(p2)
								local v39 = clone
								local identity = v39.identity or v39.id

								local clone2 = table.clone(p2[identity] or {})
								clone2[v38] = clone
								local clone3 = table.clone(p2)
								clone3[identity] = clone2
								return clone3
							end)
						else
							setState2(clone)
						end

						setProductSaleStatusError(false)
						setIsProductSaleStatusPending(true)
						local v38

						if v31 == nil then
							v38 = onUpdateProductSaleStatus(id, isForSale)
						else
							v38 = onUpdateProductKindSaleStatus(v30.productKind, v30.id, isForSale)
						end

						v38:andThen(function()
							if ref.current ~= v16 or ref2.current ~= v35 then
								return
							end

							local v39 = v15
							local v40 = {
								action = "sale_status",
								productId = v30.id,
								productKind = productKind
							}

							if v40 == nil then
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v39)
							else
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v39, v40)
							end
						end):catch(function(p2)
							if ref.current ~= v16 or ref2.current ~= v35 then
								return
							end

							local v39 = v30

							if FFlagBuildExperienceMonetizationNativeUI then
								local v40 = string.gsub(formatError(p2), "[\r\n]+", " ")
								local productKind2 = v39.productKind or "DeveloperProduct"
								warn(`[{productKind2}] action=sale_status productId={v39.id} failed={string.sub(v40, 1, 200)}`)
							end

							if FFlagBuildExperienceMonetizationMultiKind then
								local v41 = v30
								local identity = v41.identity or v41.id

								local v42 = "saleStatus"
								setState4(function(p3)
									if (p3[identity] or {})[v42] == nil then
										return p3
									end

									local clone2 = table.clone(p3[identity])
									clone2[v42] = nil
									local clone3 = table.clone(p3)
									clone3[identity] = clone2

									if next(clone2) == nil then
										clone3[identity] = nil
									end

									return clone3
								end)
							end

							local v40 = v15
							local v41 = {
								action = "sale_status",
								productId = v30.id,
								productKind = productKind
							}

							if v41 == nil then
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v40)
							else
								sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v40, v41)
							end

							local v42 = v30

							if selectedProductIdRef.current == (v42.identity or v42.id) then
								if not FFlagBuildExperienceMonetizationMultiKind then
									setState2(v30)
								end

								setProductSaleStatusError(true)
							end
						end):finally(function()
							if ref.current == v16 and ref2.current == v35 then
								ref2.current = nil
								setIsProductSaleStatusPending(false)
							end
						end)
					end
				end
			end
		end
	end, {
		v18,
		state5,
		isProductSaleStatusPending,
		data.onUpdateProductSaleStatus,
		state2,
		setIsProductSaleStatusPending,
		setProductSaleStatusError,
		v15,
		v16,
		data.onUpdateProductKindSaleStatus or false
	})

	local onUpdateProductKind = data.onUpdateProductKind or false
	local v30 = React.useCallback(function()
		local v31 = state2

		if FFlagBuildExperienceMonetizationProductEditing and v31 ~= nil then
			local v32 = data
			local v33

			if v31 == nil or v31.productKind ~= nil and v31.productKind ~= "DeveloperProduct" then
				v33 = false
			else
				v33 = v31.canManage ~= false
			end

			if not v33 then
				v33 = FFlagBuildExperienceMonetizationProductEditing

				if v33 then
					local v34

					if FFlagBuildExperienceMonetizationManageKinds then
						local v36 = if v31 ~= nil then v31.productKind else nil
						v34 = getProductKindCapabilities(v36)
					end

					v33 = v34 ~= nil
				end
			end

			if v33 then
				if v32.onUpdateProductKind == nil then
					local v34 = FFlagBuildExperienceMonetizationProductEditing

					if v34 then
						local v35

						if FFlagBuildExperienceMonetizationManageKinds then
							local v37 = if v31 ~= nil then v31.productKind else nil
							v35 = getProductKindCapabilities(v37)
						end

						v34 = v35 ~= nil
					end

					v33 = not v34
				else
					v33 = true
				end
			end

			if v33 and v18 then
				local v34

				if v31 == nil then
					v34 = false
				else
					v34 = v31.isArchived == true
						or v31.isImmutable == true
						or v31.isInActivePriceOptimizationExperiment == true
				end

				if not v34 then
					local v35 = v15
					local v36 = { productId = v31.id }
					local v37 = FFlagBuildExperienceMonetizationProductEditing

					if v37 then
						local v38

						if FFlagBuildExperienceMonetizationManageKinds then
							local v40 = if v31 ~= nil then v31.productKind else nil
							v38 = getProductKindCapabilities(v40)
						end

						v37 = v38 ~= nil
					end

					if v37 and v31.productKind ~= nil then
						v36.productKind = v31.productKind
					end

					if v36 == nil then
						sendBuildExperienceEvent("MONETIZATION_EDIT_CLICK", v35)
					else
						sendBuildExperienceEvent("MONETIZATION_EDIT_CLICK", v35, v36)
					end

					setEditName(v31.name)
					setEditDescription(v31.description)
					setEditPrice(v31.priceInRobux == nil and "" or tostring(v31.priceInRobux))
					setProductEditError(nil)
					setState("edit")
				end
			end
		end
	end, {
		v18,
		onUpdateProductKind,
		state2,
		setEditDescription,
		setEditName,
		setEditPrice,
		setProductEditError,
		v15
	})

	local v31 = React.useCallback(function(p2)
		setEditName(p2)
		setProductEditError(nil)
	end, {})
	local v32 = React.useCallback(function(p2)
		setEditDescription(p2)
		setProductEditError(nil)
	end, {})
	local v33 = React.useCallback(function(p2)
		setEditPrice(p2)
		setProductEditError(nil)
	end, {})
	local v34 = React.useCallback(function()
		if isProductEditPending or ref2.current ~= nil then
			return
		end

		local v36 = v15
		local v37 = state2 ~= nil and { productId = state2.id } or nil

		if v37 == nil then
			sendBuildExperienceEvent("MONETIZATION_EDIT_CANCEL_CLICK", v36)
		else
			sendBuildExperienceEvent("MONETIZATION_EDIT_CANCEL_CLICK", v36, v37)
		end

		setProductEditError(nil)
		setState("detail")
	end, { isProductEditPending, state2, v15 })

	local v35 = React.useCallback(function()
		local v36 = state2
		local v37 = if v36 ~= nil then resolveProductEditSubmit(data, v36) else nil

		if FFlagBuildExperienceMonetizationProductEditing and ref.current == v16 and ref2.current == nil and v36 ~= nil then
			local v38

			if v36 == nil or v36.productKind ~= nil and v36.productKind ~= "DeveloperProduct" then
				v38 = false
			else
				v38 = v36.canManage ~= false
			end

			if not v38 then
				v38 = FFlagBuildExperienceMonetizationProductEditing

				if v38 then
					local v39

					if FFlagBuildExperienceMonetizationManageKinds then
						local v41 = if v36 ~= nil then v36.productKind else nil
						v39 = getProductKindCapabilities(v41)
					end

					v38 = v39 ~= nil
				end
			end

			if v38 and v18 and v37 ~= nil and not isProductEditPending then
				local v39 = { productId = v36.id }
				local v40 = FFlagBuildExperienceMonetizationProductEditing

				if v40 then
					local v41

					if FFlagBuildExperienceMonetizationManageKinds then
						local v43 = if v36 ~= nil then v36.productKind else nil
						v41 = getProductKindCapabilities(v43)
					end

					v40 = v41 ~= nil
				end

				if v40 and v36.productKind ~= nil then
					v39.productKind = v36.productKind
				end

				local v41 = v15

				if v39 == nil then
					sendBuildExperienceEvent("MONETIZATION_EDIT_SAVE_CLICK", v41)
				else
					sendBuildExperienceEvent("MONETIZATION_EDIT_SAVE_CLICK", v41, v39)
				end

				local v43

				if FFlagBuildExperienceMonetizationManageKinds then
					local v45 = if v36 ~= nil then v36.productKind else nil
					v43 = getProductKindCapabilities(v45)
				end

				local v44 = (v43 == nil or v43.editableName)
					and (string.match(editName, "^%s*(.-)%s*$") or "")
					or nil

				local v45, v46 = validateProductEdit(v36, v44, editDescription, editPrice, v13)

				if v45 ~= nil then
					setProductEditError(v45)
					return
				end

				local v47 = {}
				ref2.current = v47

				setProductEditError(nil)
				setIsProductEditPending(true)
				v37({ name = v44, description = editDescription, priceInRobux = v46 }):andThen(function(p2)
					if ref.current ~= v16 or ref2.current ~= v47 then
						return
					end

					local clone = table.clone(v39)
					clone.action = "product_details"

					local v48 = v15

					if clone == nil then
						sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v48)
					else
						sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_SUCCESS", v48, clone)
					end

					local v49, v50 = applyProductEditResult(v36, p2, v44, editDescription, v46)

					if FFlagBuildExperienceMonetizationMultiKind then
						local v51 = "details"
						setState4(function(p3)
							local v52 = v49
							local identity = v52.identity or v52.id

							local clone2 = table.clone(p3[identity] or {})
							clone2[v51] = v49
							local clone3 = table.clone(p3)
							clone3[identity] = clone2
							return clone3
						end)
					else
						setState2(v49)
					end

					setState6(false)
					setProductSaleStatusError(false)

					if v50 then
						setProductEditError(v13.moderationError)
					elseif FFlagBuildExperienceMonetizationMultiKind then
						local v51 = v36

						if selectedProductIdRef.current == (v51.identity or v51.id) then
							setState("detail")
						end
					else
						setState("detail")
					end
				end):catch(function(p2)
					if ref.current ~= v16 or ref2.current ~= v47 then
						return
					end

					local v48 = v36

					if FFlagBuildExperienceMonetizationNativeUI then
						local v49 = string.gsub(formatError(p2), "[\r\n]+", " ")
						local productKind = v48.productKind or "DeveloperProduct"
						warn(`[{productKind}] action=product_details productId={v48.id} failed={string.sub(v49, 1, 200)}`)
					end

					local clone = table.clone(v39)
					clone.action = "product_details"

					local v49 = v15

					if clone == nil then
						sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v49)
					else
						sendBuildExperienceEvent("MONETIZATION_PRODUCT_UPDATE_FAILURE", v49, clone)
					end

					setProductEditError(v13.updateError)
				end):finally(function()
					if ref.current == v16 and ref2.current == v47 then
						ref2.current = nil
						setIsProductEditPending(false)
					end
				end)
			end
		end
	end, {
		v18,
		editDescription,
		editName,
		editPrice,
		isProductEditPending,
		v13.descriptionLengthError,
		v13.moderationError,
		v13.nameLengthError,
		v13.nameRequiredError,
		v13.priceError,
		v13.updateError,
		data.onUpdateProduct,
		onUpdateProductKind,
		state2,
		setIsProductEditPending,
		setProductEditError,
		setProductSaleStatusError,
		v15,
		v16
	})

	local onComposerActivated = data.onComposerActivated or data.onClose
	local canEditOnBuild = data.canEditOnBuild ~= false
	local v36

	if FFlagBuildCheckGamePermissions and data.permissionLoadStatus ~= nil then
		v36 = data.permissionLoadStatus == "Ready" and data.permissionCanMonetize == true
	else
		v36 = v18
	end

	local v37, v38

	if FFlagBuildExperienceDeveloperProductContext then
		local v39, v40 = React.useBinding("")
		local ref3 = React.useRef(nil)
		v37 = useOnScreenKeyboardHeight()
		React.useEffect(function()
			v40("")
		end, {
			data.universeId or 0,
			data.sessionId or "",
			state2 == nil and "" or state2.id,
			v40
		})

		local v41 = React.useCallback(function(): boolean
			local value = v39:getValue()
			local v42 = string.match(value, "^%s*(.-)%s*$") or ""

			if v42 == "" or state ~= "detail" or state2 == nil or data.universeId == nil then
				return false
			end

			GetBuildPromptDraftStore().queueDraft({
				universeId = data.universeId,
				sessionId = data.sessionId,
				text = v42,
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

			v40("")

			if ref3.current ~= nil then
				ref3.current.releaseFocus()
			end

			onComposerActivated()
			return true
		end, {
			v39,
			onComposerActivated,
			state,
			data.sessionId,
			data.universeId,
			state2,
			v40
		})

		if state == "detail" and state2 ~= nil then
			local v42

			if state2 == nil or state2.productKind ~= nil and state2.productKind ~= "DeveloperProduct" then
				v42 = false
			else
				v42 = state2.canManage ~= false
			end

			if not v42 then
				v42 = v5

				if v42 then
					if state2 == nil then
						v42 = false
					else
						v42 = state2.productKind == "GamePass" or state2.productKind == "Subscription"
					end
				end
			end

			if v42 and data.universeId ~= nil then
				v38 = {
					composerText = v39,
					onComposerChanged = v40,
					placeholder = v13.composerPlaceholder,
					textBoxRef = ref3,
					isAssistantResponding = false,
					canSendWhileResponding = false,
					allowImageAttachments = false,
					tracksExternalText = true,
					onSend = v41,
					onStop = function() end,
					isReadOnly = not canEditOnBuild
				}
			end
		end
	end

	local v39 = React.useCallback(function()
		if not v36 then
			return
		end

		sendBuildExperienceEvent("MONETIZATION_CREATE_CLICK", v15)

		if data.onCreateProduct ~= nil then
			data.onCreateProduct()
			return
		end

		GetBuildPromptDraftStore().queueDraft({
			universeId = data.universeId,
			sessionId = data.sessionId,
			text = v13.createProductPrompt
		})

		onComposerActivated()
	end, {
		onComposerActivated,
		v13.createProductPrompt,
		v36,
		data.onCreateProduct,
		data.sessionId,
		data.universeId,
		v15
	})

	local v40 = React.useCallback(function()
		sendBuildExperienceEvent("MONETIZATION_RETRY_CLICK", v15)

		if data.onRetryCatalog ~= nil then
			data.onRetryCatalog()
		end
	end, { data.onRetryCatalog, v15 })
	local v41

	if FFlagBuildExperienceMonetizationMultiKind then
		v41 = React.useCallback(function(p2)
			local v42 = v15
			local v43 = { catalogKind = tostring(p2) }

			if v43 == nil then
				sendBuildExperienceEvent("MONETIZATION_RETRY_CLICK", v42)
			else
				sendBuildExperienceEvent("MONETIZATION_RETRY_CLICK", v42, v43)
			end

			if data.onRetryCatalogSource ~= nil then
				data.onRetryCatalogSource(p2)
			end
		end, { data.onRetryCatalogSource, v15 })
	end

	local v42

	if FFlagBuildExperienceMonetizationManageKinds then
		local v44 = if state2 ~= nil then state2.productKind else nil
		v42 = getProductKindCapabilities(v44)
	end

	local priceInRobux = if state2 ~= nil then state2.priceInRobux else nil
	local regionalPricingViewState = getRegionalPricingViewState(data, state2, v18, state6, v13)

	local kindEditState = getKindEditState(state2, v18, data)
	local v43 = {}
	v43.mode = state
	local v44 = if FFlagBuildExperienceDeveloperProductContext then state ~= "detail" and 0 or v37 else nil
	v43.keyboardHeight = v44

	v43.chatActions = v38
	v43.products = products
	v43.catalogSources = data.catalogSources
	v43.showOptions = FFlagBuildExperienceMonetizationNativeUI and data.showOptions == true
	v43.optionsLoadStatus = v17.loadStatus
	v43.canMonetize = v17.canMonetize
	v43.canCreateProduct = v36
	v43.canChangeManagedPricing = v17.canChangeManagedPricing
	v43.managedPricingState = v17.managedPricingState
	v43.managedPricingSupportingText = v17.managedPricingSupportingText
	v43.shopButtonEnabled = v17.shopButtonEnabled
	v43.isOptionsManagedPricingPending = v17.isManagedPricingPending
	v43.isShopButtonPending = v17.isShopButtonPending
	v43.managedPricingError = v17.managedPricingError
	v43.shopButtonError = v17.shopButtonError
	v43.showManagedPricingAcknowledgement = v17.showAcknowledgement
	v43.disableDialogPortal = data.disableDialogPortal
	v43.selectedProduct = state2
	local v45

	if data.isProductDisabled == true then
		v45 = true
	else
		local v46

		if state2 == nil or state2.productKind ~= nil and state2.productKind ~= "DeveloperProduct" then
			v46 = false
		else
			v46 = state2.canManage ~= false
		end

		if v46 then
			if state2 == nil then
				v45 = false
			else
				v45 = state2.isArchived == true
					or state2.isImmutable == true
					or state2.isInActivePriceOptimizationExperiment == true
			end
		else
			v45 = false
			local v47

			if FFlagBuildExperienceMonetizationManageKinds then
				local v49 = if state2 ~= nil then state2.productKind else nil
				v47 = getProductKindCapabilities(v49)
			end

			if v47 ~= nil then
				if state2 == nil then
					v45 = false
				else
					v45 = state2.isArchived == true
						or state2.isImmutable == true
						or state2.isInActivePriceOptimizationExperiment == true
				end
			end
		end
	end

	v43.isProductDisabled = v45

	v43.isProductManagedPricingPending = state5
	v43.isProductSaleStatusPending = isProductSaleStatusPending
	v43.isProductEditPending = isProductEditPending
	v43.canUpdateProductManagedPricing = regionalPricingViewState.canUpdate
	local v46 = FFlagBuildExperienceMonetizationProductEditing

	if v46 then
		if state2 == nil or state2.productKind ~= nil and state2.productKind ~= "DeveloperProduct" then
			v46 = false
		else
			v46 = state2.canManage ~= false
		end

		if v46 then
			if v18 then
				v46 = not (data.onUpdateProductSaleStatus == nil) and data.onUpdateProduct ~= nil
			else
				v46 = v18
			end
		end
	end

	v43.canManageProduct = v46

	v43.canChangeKindManagedPricing = regionalPricingViewState.canChangeKind
	v43.canEditKindProduct = kindEditState.canEdit
	v43.canEditName = kindEditState.canEditName
	v43.canEditPrice = kindEditState.canEditPrice
	local v47

	if FFlagBuildExperienceMonetizationManageKinds then
		if v18 then
			v47 = false
			local v48

			if FFlagBuildExperienceMonetizationManageKinds then
				local v50 = if state2 ~= nil then state2.productKind else nil
				v48 = getProductKindCapabilities(v50)
			end

			if v48 ~= nil then
				v47 = data.onUpdateProductKindSaleStatus ~= nil
			end
		else
			v47 = v18
		end
	end

	v43.canChangeSaleStatus = v47

	v43.productManagedPricingError = state6
	v43.productManagedPricingErrorLabel = regionalPricingViewState.errorLabel
	v43.productSaleStatusError = productSaleStatusError ~= false
	local v48

	if FFlagBuildExperienceMonetizationManageKinds and productSaleStatusError and v42 ~= nil then
		if v42.priceRequiredForSale and priceInRobux == nil then
			v48 = v13.kindPriceRequiredForSale
		else
			v48 = v13.updateError
		end
	end

	v43.productSaleStatusErrorLabel = v48

	v43.productEditError = productEditError
	v43.editName = editName
	v43.editDescription = editDescription
	v43.editPrice = editPrice
	v43.catalogStatus = data.catalogStatus or "Ready"
	v43.emptyTitle = v13.emptyTitle
	v43.emptyDescription = v13.emptyDescription
	v43.onClose = v24
	v43.onOpenCreate = v39
	v43.onOpenOptions = fn2
	v43.onManagedPricingChanged = v17.onManagedPricingChanged
	v43.onShopButtonChanged = v17.onShopButtonChanged
	v43.onConfirmManagedPricing = v17.onConfirmManagedPricing
	v43.onCancelManagedPricing = v17.onCancelManagedPricing
	v43.onRetryOptions = v17.onRetry
	v43.onProductActivated = v25
	v43.onProductManagedPricingChanged = v28
	v43.onProductSaleStatusChanged = v29
	v43.onOpenProductEdit = v30
	v43.onEditNameChanged = v31
	v43.onEditDescriptionChanged = v32
	v43.onEditPriceChanged = v33
	v43.onCancelProductEdit = v34
	v43.onSaveProductEdit = v35
	v43.onRetryCatalog = v40
	v43.onRetryCatalogSource = v41
	v43.labels = {
		title = v13.title,
		options = v17.labels.options,
		pricingOptions = v17.labels.pricingOptions,
		pricingOptionsDescription = v17.labels.pricingOptionsDescription,
		managedPricing = v17.labels.managedPricing,
		managedPricingDescription = v17.labels.managedPricingDescription,
		shopUI = v17.labels.shopUI,
		shopButton = v17.labels.shopButton,
		shopButtonDescription = v17.labels.shopButtonDescription,
		optionsLoadError = v17.labels.optionsLoadError,
		permissionDenied = v17.labels.permissionDenied,
		mixed = v17.labels.mixed,
		unavailable = v17.labels.unavailable,
		noEligibleProducts = v17.labels.noEligibleProducts,
		optionsUpdateError = v17.labels.optionsUpdateError,
		partialUpdateError = v17.labels.partialUpdateError,
		acknowledgementTitle = v17.labels.acknowledgementTitle,
		acknowledgementDescription = v17.labels.acknowledgementDescription,
		agree = v17.labels.agree,
		emptyCreateProduct = v13.emptyCreateProduct,
		pricing = v13.pricing,
		regionalPricing = v13.regionalPricing,
		loading = v13.loading,
		loadErrorTitle = v13.loadErrorTitle,
		loadErrorDescription = v13.loadErrorDescription,
		retry = v13.retry,
		updateError = v13.updateError,
		availableForPurchase = v13.availableForPurchase,
		edit = v13.edit,
		editProduct = v13.editProduct,
		name = v13.name,
		description = v13.description,
		price = v13.price,
		priceError = v13.priceError,
		priceRequiredForSale = v13.priceRequiredForSale,
		cancel = v13.cancel,
		save = v13.save
	}
	return v43
end

return useMonetizationPageViewModel
