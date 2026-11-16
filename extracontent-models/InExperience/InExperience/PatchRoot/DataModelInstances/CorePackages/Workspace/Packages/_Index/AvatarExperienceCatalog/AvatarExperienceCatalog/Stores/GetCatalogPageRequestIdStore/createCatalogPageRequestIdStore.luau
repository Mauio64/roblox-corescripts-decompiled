local HttpService = game:GetService("HttpService")

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Signals = require(parent.Signals)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalizeScreenSizeForWire = AvatarExperienceCommon.Utils.normalizeScreenSizeForWire
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local Constants = require(AvatarExperienceCatalog.Constants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiBracedPageRequestId = AvatarExperienceFlags.FFlagAXSduiBracedPageRequestId
local FFlagAXSduiPageVariantRequestId = AvatarExperienceFlags.FFlagAXSduiPageVariantRequestId
local FFlagAXSduiPublishRequestIdWithResponse = AvatarExperienceFlags.FFlagAXSduiPublishRequestIdWithResponse

local function getVariantKey(p: string, p2: string) -- 8 equivalent calls inferred from this helper
	return `{p}|{normalizeScreenSizeForWire(p2)}`
end

local function createCatalogPageRequestIdStore()
	local signal, v = Signals.createSignal({})

	local v2 = {}
	local v3 = {}
	local v4 = {}
	local v5 = {}

	local function generateRequestId() -- 4 equivalent calls inferred from this helper
		if FFlagAXSduiBracedPageRequestId then
			return HttpService:GenerateGUID(true)
		end

		return HttpService:GenerateGUID(false)
	end

	local function setIdentifierRequestId(p: string, p2: string) -- 2 equivalent calls inferred from this helper
		local v6 = signal(false)

		if v6[p] == p2 then
			return
		end

		local clone = table.clone(v6)
		clone[p] = p2
		v(clone)
	end

	local function recordFetchedVariant(identifier: string, p: string, p2: string)
		local v6 = v4[identifier]

		if v6 == nil then
			v6 = {}
			v4[identifier] = v6
		end

		if v6[p] then
			return
		end

		if next(v6) ~= nil then
			sendAXCounterV2(Constants.COUNTERS.CatalogPageSecondVariantFetched, {
				identifier = identifier,
				screenSize = normalizeScreenSizeForWire(p2)
			})
		end

		v6[p] = true
	end

	local function getOrCreateVariantRequestIdForKey(identifier: string, p: string, p2: string)
		local v6 = v2[p]

		if v6 ~= nil then
			return v6
		end

		recordFetchedVariant(identifier, p, p2)
		local v7

		if v3[identifier] == nil then
			v3[identifier] = p

			v7 = signal(false)[identifier] or generateRequestId() -- inferred equivalent call
		else
			v7 = generateRequestId() -- inferred equivalent call
		end

		v2[p] = v7

		if v3[identifier] ~= p then
			return v7
		end

		local v8 = signal(false)

		if v8[identifier] == v7 then
			return v7
		end

		local clone = table.clone(v8)
		clone[identifier] = v7
		v(clone)

		return v7
	end

	local function getOrCreatePageRequestId(p: string)
		local v6

		if FFlagAXSduiPageVariantRequestId then
			v6 = v3[p]

			if v6 ~= nil then
				local v7 = v2[v6]

				if v7 ~= nil then
					return v7
				end
			end
		end

		local v7 = signal(false)
		local v8 = v7[p]

		if v8 ~= nil then
			return v8
		end

		local v9

		if FFlagAXSduiBracedPageRequestId then
			v9 = generateRequestId() -- inferred equivalent call
		else
			v9 = HttpService:GenerateGUID(false)
		end

		if FFlagAXSduiPageVariantRequestId and v6 ~= nil then
			v2[v6] = v9
		end

		local clone = table.clone(v7)
		clone[p] = v9
		v(clone)
		return v9
	end

	local function resetPageRequestId(p: string)
		if FFlagAXSduiPageVariantRequestId then
			local v6 = v3[p]

			if v6 ~= nil then
				v2[v6] = nil
			end
		end

		local v6 = signal(false)

		if v6[p] == nil then
			return
		end

		local v7 = {}

		for k, v8 in v6 do
			if k ~= p then
				v7[k] = v8
			end
		end

		v(v7)
	end

	local function getOrCreatePageVariantRequestId(identifier: string, p: string)
		return getOrCreateVariantRequestIdForKey(identifier, getVariantKey(identifier, p), p) -- inferred equivalent call
	end

	local function activatePageVariant(identifier: string, p: string)
		local variantKey = getVariantKey(identifier, p) -- inferred equivalent call
		local variantRequestIdForKey = getOrCreateVariantRequestIdForKey(identifier, variantKey, p)
		v3[identifier] = variantKey
		setIdentifierRequestId(identifier, variantRequestIdForKey) -- inferred equivalent call
		return variantRequestIdForKey
	end

	local function resetPageVariantRequestId(p: string, p2: string)
		local variantKey = getVariantKey(p, p2) -- inferred equivalent call
		local v6 = v3[p]
		v2[variantKey] = nil

		if FFlagAXSduiPublishRequestIdWithResponse then
			v5[variantKey] = nil
		end

		if v6 == nil or v6 == variantKey then
			resetPageRequestId(p)
		end
	end

	local function beginPageVariantRefresh(identifier: string, p: string)
		local variantKey = getVariantKey(identifier, p) -- inferred equivalent call

		if v2[variantKey] == nil then
			return getOrCreateVariantRequestIdForKey(identifier, variantKey, p)
		end

		local v6 = generateRequestId() -- inferred equivalent call
		v5[variantKey] = v6
		return v6
	end

	local function getPageVariantRequestIdToSend(identifier: string, p: string)
		local variantKey = getVariantKey(identifier, p) -- inferred equivalent call
		return v5[variantKey] or getOrCreateVariantRequestIdForKey(identifier, variantKey, p)
	end

	local function commitPageVariantRequestId(p: string, p2: string, p3: string)
		local variantKey = getVariantKey(p, p2) -- inferred equivalent call

		if v5[variantKey] ~= p3 then
			return
		end

		v5[variantKey] = nil
		v2[variantKey] = p3

		if v3[p] == variantKey then
			setIdentifierRequestId(p, p3) -- inferred equivalent call
		end
	end

	local function discardPageVariantRequestId(p: string, p2: string, p3: string)
		local variantKey = getVariantKey(p, p2) -- inferred equivalent call

		if v5[variantKey] == p3 then
			v5[variantKey] = nil
		end
	end

	local function getPageVariantRequestId(p: string, p2: string)
		return v2[getVariantKey(p, p2)] -- inferred equivalent call
	end

	return {
		getPageRequestIdMap = signal,
		getOrCreatePageRequestId = getOrCreatePageRequestId,
		resetPageRequestId = resetPageRequestId,
		getOrCreatePageVariantRequestId = getOrCreatePageVariantRequestId,
		activatePageVariant = activatePageVariant,
		resetPageVariantRequestId = resetPageVariantRequestId,
		beginPageVariantRefresh = beginPageVariantRefresh,
		getPageVariantRequestIdToSend = getPageVariantRequestIdToSend,
		commitPageVariantRequestId = commitPageVariantRequestId,
		discardPageVariantRequestId = discardPageVariantRequestId,
		getPageVariantRequestId = getPageVariantRequestId
	}
end

return createCatalogPageRequestIdStore
