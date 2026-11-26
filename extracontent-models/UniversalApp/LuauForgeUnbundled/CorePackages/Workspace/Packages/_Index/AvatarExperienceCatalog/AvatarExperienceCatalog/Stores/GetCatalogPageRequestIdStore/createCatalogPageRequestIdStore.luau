local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local normalizeScreenSizeForWire = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Utils.normalizeScreenSizeForWire
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXSduiBracedPageRequestId = AvatarExperienceFlags.FFlagAXSduiBracedPageRequestId
local fFlagAXSduiPageVariantRequestId = AvatarExperienceFlags.FFlagAXSduiPageVariantRequestId
local fFlagAXSduiPublishRequestIdWithResponse = AvatarExperienceFlags.FFlagAXSduiPublishRequestIdWithResponse

local function getVariantKey(p2, p3)
	return `{p2}|{normalizeScreenSizeForWire(p3)}`
end

local function createCatalogPageRequestIdStore()
	local signal, v5 = Signals.createSignal({})

	local v6 = {}
	local values = {}
	local v7 = {}
	local v8 = {}

	local function generateRequestId()
		if fFlagAXSduiBracedPageRequestId then
			return HttpService:GenerateGUID(true)
		end

		return HttpService:GenerateGUID(false)
	end

	local function setIdentifierRequestId(p2, p3)
		local v9 = signal(false)

		if v9[p2] == p3 then
			return
		end

		local clone = table.clone(v9)
		clone[p2] = p3
		v5(clone)
	end

	local function recordFetchedVariant(p2, p3, p4)
		local v9 = v7[p2]

		if v9 == nil then
			v9 = {}
			v7[p2] = v9
		end

		if v9[p3] then
			return
		end

		if next(v9) ~= nil then
			sendAXCounterV2(Constants.COUNTERS.CatalogPageSecondVariantFetched, {
				identifier = p2,
				screenSize = normalizeScreenSizeForWire(p4)
			})
		end

		v9[p3] = true
	end

	local function getOrCreateVariantRequestIdForKey(p2, p3, p4)
		local v9 = v6[p3]

		if v9 ~= nil then
			return v9
		end

		recordFetchedVariant(p2, p3, p4)
		local v10

		if values[p2] == nil then
			values[p2] = p3

			v10 = signal(false)[p2]

			if not v10 then
				if fFlagAXSduiBracedPageRequestId then
					v10 = HttpService:GenerateGUID(true)
				else
					v10 = HttpService:GenerateGUID(false)
				end
			end
		elseif fFlagAXSduiBracedPageRequestId then
			v10 = HttpService:GenerateGUID(true)
		else
			v10 = HttpService:GenerateGUID(false)
		end

		v6[p3] = v10

		if values[p2] ~= p3 then
			return v10
		end

		local v11 = signal(false)

		if v11[p2] == v10 then
			return v10
		end

		local clone = table.clone(v11)
		clone[p2] = v10
		v5(clone)

		return v10
	end

	local function getOrCreatePageRequestId(p2)
		local v9

		if fFlagAXSduiPageVariantRequestId then
			v9 = values[p2]

			if v9 ~= nil then
				local v10 = v6[v9]

				if v10 ~= nil then
					return v10
				end
			end
		end

		local v10 = signal(false)
		local v11 = v10[p2]

		if v11 ~= nil then
			return v11
		end

		local v12

		if fFlagAXSduiBracedPageRequestId then
			if fFlagAXSduiBracedPageRequestId then
				v12 = HttpService:GenerateGUID(true)
			else
				v12 = HttpService:GenerateGUID(false)
			end
		else
			v12 = HttpService:GenerateGUID(false)
		end

		if fFlagAXSduiPageVariantRequestId and v9 ~= nil then
			v6[v9] = v12
		end

		local clone = table.clone(v10)
		clone[p2] = v12
		v5(clone)
		return v12
	end

	local function resetPageRequestId(p2)
		if fFlagAXSduiPageVariantRequestId then
			local v9 = values[p2]

			if v9 ~= nil then
				v6[v9] = nil
			end
		end

		local v9 = signal(false)

		if v9[p2] == nil then
			return
		end

		local v10 = {}

		for k, v11 in v9 do
			if k ~= p2 then
				v10[k] = v11
			end
		end

		v5(v10)
	end

	local function getOrCreatePageVariantRequestId(p2, p3)
		return getOrCreateVariantRequestIdForKey(p2, `{p2}|{normalizeScreenSizeForWire(p3)}`, p3)
	end

	local function activatePageVariant(p2, p3)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		local variantRequestIdForKey = getOrCreateVariantRequestIdForKey(p2, formatted, p3)
		values[p2] = formatted
		local v9 = signal(false)

		if v9[p2] == variantRequestIdForKey then
			return variantRequestIdForKey
		end

		local clone = table.clone(v9)
		clone[p2] = variantRequestIdForKey
		v5(clone)

		return variantRequestIdForKey
	end

	local function resetPageVariantRequestId(p2, p3)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		local v9 = values[p2]
		v6[formatted] = nil

		if fFlagAXSduiPublishRequestIdWithResponse then
			v8[formatted] = nil
		end

		if v9 == nil or v9 == formatted then
			resetPageRequestId(p2)
		end
	end

	local function beginPageVariantRefresh(p2, p3)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		if v6[formatted] == nil then
			return getOrCreateVariantRequestIdForKey(p2, formatted, p3)
		end

		local v9

		if fFlagAXSduiBracedPageRequestId then
			v9 = HttpService:GenerateGUID(true)
		else
			v9 = HttpService:GenerateGUID(false)
		end

		v8[formatted] = v9
		return v9
	end

	local function getPageVariantRequestIdToSend(p2, p3)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		return v8[formatted] or getOrCreateVariantRequestIdForKey(p2, formatted, p3)
	end

	local function commitPageVariantRequestId(p2, p3, p4)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		if v8[formatted] ~= p4 then
			return
		end

		v8[formatted] = nil
		v6[formatted] = p4

		if values[p2] == formatted then
			local v9 = signal(false)

			if v9[p2] == p4 then
				return
			end

			local clone = table.clone(v9)
			clone[p2] = p4
			v5(clone)
		end
	end

	local function discardPageVariantRequestId(p2, p3, p4)
		local formatted = `{p2}|{normalizeScreenSizeForWire(p3)}`

		if v8[formatted] == p4 then
			v8[formatted] = nil
		end
	end

	local function getPageVariantRequestId(p2, p3)
		return v6[`{p2}|{normalizeScreenSizeForWire(p3)}`]
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
