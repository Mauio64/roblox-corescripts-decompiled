require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local statusCodes = Http.StatusCodes
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")
local creatorApiHttp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/creatorApiHttp")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MonetizationOptions/MonetizationOptionsTypes")
local fetchGamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/fetchGamePassConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")

local interface = t.interface({
	status = t.union(
		t.literal("Disabled"),
		t.literal("Pending"),
		t.literal("Accepted")
	)
})

local interface2 = t.interface({
	errorCode = t.optional(t.string),
	errorMessage = t.optional(t.string),
	field = t.optional(t.string),
	hint = t.optional(t.string)
})

local interface3 = t.interface({ productId = t.integer, error = interface2 })

local interface4 = t.interface({ errors = t.array(interface3) })

local interface5 = t.interface({
	gamePassId = t.integer,
	error = interface2
})

local interface6 = t.interface({ errors = t.array(interface5) })

local interface7 = t.interface({
	name = t.string,
	isEnabled = t.boolean
})

local interface8 = t.interface({
	shopId = t.integer,
	entryPoints = t.array(interface7)
})

local interface9 = t.interface({
	shopId = t.integer,
	status = t.union(t.literal("Draft"), t.literal("Active"))
})

local interface10 = t.interface({ shops = t.array(interface8) })

local interface11 = t.interface({
	createdCategories = t.array(t.table)
})

local interface12 = t.interface({ monetizeExperience = t.boolean })

local interface13 = t.interface({
	status = t.union(
		t.literal("Invalid"),
		t.literal("NotMigrated"),
		t.literal("Migrating"),
		t.literal("Migrated")
	)
})

local interface14 = t.interface({
	permissions = t.optional(t.map(t.string, t.boolean))
})

local function validateResponse(p2, callback, p3)
	local v5, v6 = callback(p3)
	assert(v5, `Invalid {p2} response: {tostring(v6)}`)
	return p3
end

local function decodeManagedPricingResponse(p2)
	local v5, v6 = interface(p2)
	assert(v5, `Invalid Managed Pricing response: {tostring(v6)}`)
	return p2
end

local function decodeBulkDeveloperProductUpdateResponse(p2)
	local v5, v6 = interface4(p2)
	assert(v5, `Invalid bulk developer product update response: {tostring(v6)}`)
	return p2
end

local function decodeBulkGamePassUpdateResponse(gamePassIdSet, p2)
	local v5, v6 = interface6(p2)
	assert(v5, `Invalid bulk Game Pass update response: {tostring(v6)}`)

	local gamePassIdSet2 = {}

	for k, err in p2.errors do
		assert(gamePassIdSet[err.gamePassId], "Bulk Game Pass update error has an unexpected ID")
		assert(not gamePassIdSet2[err.gamePassId], "Bulk Game Pass update error has a duplicate ID")
		gamePassIdSet2[err.gamePassId] = true
	end

	return p2
end

local function decodeCreatedShop(p2)
	local v5, v6 = interface9(p2)
	assert(v5, `Invalid created Shop response: {tostring(v6)}`)
	return p2
end

local function decodeShopListResponse(p2)
	local v5, v6 = interface10(p2)
	assert(v5, `Invalid Shop list response: {tostring(v6)}`)
	return p2
end

local function decodeUniversePermissionResponse(p2)
	local v5, v6 = interface12(p2)
	assert(v5, `Invalid universe permission response: {tostring(v6)}`)

	return { canMonetize = p2.monetizeExperience }
end

local function decodeGroupMigrationResponse(p2)
	local v5, v6 = interface13(p2)
	assert(v5, `Invalid group migration response: {tostring(v6)}`)
	return p2
end

local function decodeGroupPermissionResponse(p2)
	local v5, v6 = interface14(p2)
	assert(v5, `Invalid group permission response: {tostring(v6)}`)

	return {
		canMonetize = p2.permissions ~= nil and p2.permissions.canMonetize == true
	}
end

local function decodeBatchUpdateShopItemsResponse(p2)
	local v5, v6 = interface11(p2)
	assert(v5, `Invalid Shop item update response: {tostring(v6)}`)
	return p2
end

local function decodeEmptyResponse(p2): nil
	return nil
end

local function transportOptions(options)
	local v5 = options or {}
	return {
		network = v5.network,
		readNetwork = v5.readNetwork,
		mutatingNetwork = v5.mutatingNetwork,
		baseUrl = v5.baseUrl,
		retryReads = false
	}
end

local function resolveBase(p2)
	return creatorApiHttp.baseUrl(transportOptions(p2))
end

local function get(p2, p3, p4, p5)
	return creatorApiHttp.get(transportOptions(p4), p2, p3, p5)
end

local function mutate(p2, p3, p4, p5, p6, p7)
	local v5 = transportOptions(p6)
	return creatorApiHttp.json(creatorApiHttp.mutatingNetwork(v5), p2, p3, p4, p5, creatorApiHttp.jsonDecoder(p7))
end

local v5 = {}

function v5.getManagedPricing(p2, p3)
	return get(
		("%s/price-configuration-api/v1/universes/%d/managed-pricing"):format(
			creatorApiHttp.baseUrl(transportOptions(p3)),
			p2
		),
		"monetization-options.managed-pricing.get",
		p3,
		decodeManagedPricingResponse
	)
end

function v5.acceptManagedPricing(p2, p3)
	return mutate(
		"POST",
		("%s/price-configuration-api/v1/universes/%d/managed-pricing:accept"):format(
			creatorApiHttp.baseUrl(transportOptions(p3)),
			p2
		),
		nil,
		"monetization-options.managed-pricing.accept",
		p3,
		decodeEmptyResponse
	)
end

function v5.updateDeveloperProductsManagedPricing(p2, list, p3, p4)
	local baseUrl = creatorApiHttp.baseUrl(transportOptions(p4))

	local v6 = {}
	local total = 1
	local function updateNextBatch()
		local v7 = {}

		for i = total, math.min(total + 30 - 1, #list) do
			table.insert(v7, {
				productId = list[i],
				changedProperties = { isManagedPricingEnabled = p3 }
			})
		end

		if #v7 == 0 then
			return Promise.resolve({ errors = v6 })
		end

		total += #v7

		local formatted = ("%s/developer-products/v1/universes/%d/developer-products"):format(baseUrl, p2)
		local v9 = transportOptions(p4)
		return creatorApiHttp.json(
			creatorApiHttp.mutatingNetwork(v9),
			"PATCH",
			formatted,
			{ developerProductUpdates = v7 },
			"monetization-options.managed-pricing.update-products",
			creatorApiHttp.jsonDecoder(decodeBulkDeveloperProductUpdateResponse)
		):andThen(function(p5)
			for k, v10 in p5.errors or {} do
				table.insert(v6, v10)
			end

			return updateNextBatch()
		end)
	end

	return updateNextBatch()
end

local function bulkUpdateGamePasses(p2, p3, p4, p5, fn, p6, p7)
	local baseUrl = creatorApiHttp.baseUrl(transportOptions(p7))

	local clone = table.clone(p3)
	local v6 = {
		baseUrl = baseUrl,
		network = creatorApiHttp.readNetwork(transportOptions(p7))
	}
	local errors = {}
	local v7 = {}
	local v8 = 1
	local frozen = table.freeze({
		errorMessage = "The local user changed while the bulk Game Pass request was running"
	})

	local function isRequestCurrent()
		return p7 == nil or (p7.isRequestCurrent == nil or p7.isRequestCurrent())
	end

	local function appendSessionChanged(items, p8)
		for k, item in items do
			local v9 = if p8 ~= nil then p8[item] else nil

			local v11 = if v9 == nil then {
				gamePassId = item,
				status = "unverified",
				reason = "session_changed",
				error = frozen
			} else {
				gamePassId = item,
				status = "failed",
				reason = "service_error",
				error = v9.error
			}
			table.insert(v7, v11)
		end
	end

	local function updateNextBatch()
		if p7 == nil or p7.isRequestCurrent == nil or p7.isRequestCurrent() then
			local v9 = {}
			local v10 = {}

			for i = v8, math.min(v8 + 30 - 1, #clone) do
				table.insert(v9, clone[i])
				table.insert(v10, {
					gamePassId = clone[i],
					changedPropertyNames = { p4 },
					changedProperties = p5
				})
			end

			if #v10 == 0 then
				return Promise.resolve({ errors = errors, results = v7 })
			end

			v8 += #v10
			local gamePassIdSet = {}

			for k, v11 in v10 do
				gamePassIdSet[v11.gamePassId] = true
			end

			local function readBack(p8, p9)
				local errorsByGamePassId = {}
				local gamePassIds = {}

				if p8 ~= nil then
					for k, err in p8.errors do
						table.insert(errors, err)
						errorsByGamePassId[err.gamePassId] = err
					end
				end

				for k, v11 in v10 do
					if errorsByGamePassId[v11.gamePassId] == nil then
						table.insert(gamePassIds, v11.gamePassId)
					end
				end

				if p7 == nil or p7.isRequestCurrent == nil or p7.isRequestCurrent() then
					return fetchGamePassConfig.batchGet(p2, gamePassIds, v6):andThen(function(p10)
						if p7 ~= nil and p7.isRequestCurrent ~= nil and not p7.isRequestCurrent() then
							appendSessionChanged(v9, errorsByGamePassId)
							return updateNextBatch()
						end

						local gamePassesByGamePassId = {}

						for k, gamePass in p10.gamePasses do
							gamePassesByGamePassId[gamePass.gamePassId] = gamePass
						end

						for k, v11 in v10 do
							local gamePassId = v11.gamePassId
							local v12 = errorsByGamePassId[gamePassId]
							local v13 = gamePassesByGamePassId[gamePassId]

							if v12 == nil then
								if v13 == nil then
									table.insert(v7, {
										gamePassId = gamePassId,
										status = "unverified",
										reason = "readback_failed",
										mutationError = p9
									})
								else
									local v14 = fn(v13)
									table.insert(v7, {
										gamePassId = gamePassId,
										status = v14 and "confirmed" or "unverified",
										reason = not v14 and "readback_mismatch" or nil,
										config = v13,
										mutationError = p9
									})
								end
							else
								table.insert(v7, {
									gamePassId = gamePassId,
									status = "failed",
									reason = "service_error",
									error = v12.error
								})
							end
						end

						return updateNextBatch()
					end, function(p10)
						if p7 ~= nil and p7.isRequestCurrent ~= nil and not p7.isRequestCurrent() then
							appendSessionChanged(v9, errorsByGamePassId)
							return updateNextBatch()
						end

						for k, v11 in v10 do
							local v12 = errorsByGamePassId[v11.gamePassId]

							local v14 = if v12 == nil then {
								gamePassId = v11.gamePassId,
								status = "unverified",
								reason = "readback_failed",
								error = p10,
								mutationError = p9
							} else {
								gamePassId = v11.gamePassId,
								status = "failed",
								reason = "service_error",
								error = v12.error
							}
							table.insert(v7, v14)
						end

						return updateNextBatch()
					end)
				end

				appendSessionChanged(v9, errorsByGamePassId)
				return updateNextBatch()
			end

			local formatted = ("%s/game-passes/v1/game-passes/universes/%d/bulk-update"):format(baseUrl, p2)

			local function fn2(p8)
				return decodeBulkGamePassUpdateResponse(gamePassIdSet, p8)
			end

			local v12 = transportOptions(p7)
			return creatorApiHttp.json(
				creatorApiHttp.mutatingNetwork(v12),
				"POST",
				formatted,
				{ gamePassUpdates = v10 },
				p6,
				creatorApiHttp.jsonDecoder(fn2)
			):andThen(
				function(p8)
					return readBack(p8, nil)
				end,
				function(p8)
					local responseCode = if typeof(p8) == "table" then p8.responseCode else nil

					if
						responseCode == nil
						or not (statusCodes.BAD_REQUEST <= responseCode)
						or not (responseCode < statusCodes.INTERNAL_SERVER_ERROR)
						or responseCode == statusCodes.REQUEST_TIMEOUT
					then
						return readBack(nil, p8)
					end

					local v13 = responseCode == statusCodes.UNAUTHORIZED
						or responseCode == statusCodes.FORBIDDEN
						or responseCode == statusCodes.TOO_MANY_REQUESTS
					local v14 = if v13 then #clone else v8 - 1

					for i = v8 - #v10, v14 do
						table.insert(v7, {
							gamePassId = clone[i],
							status = "failed",
							reason = "service_error",
							error = p8
						})
					end

					if v13 then
						return { errors = errors, results = v7 }
					end

					return updateNextBatch()
				end
			)
		else
			local v9 = {}

			for i = v8, #clone do
				table.insert(v9, clone[i])
			end

			v8 = #clone + 1
			appendSessionChanged(v9)
			return Promise.resolve({ errors = errors, results = v7 })
		end
	end

	return updateNextBatch()
end

function v5.updateGamePassesManagedPricing(p2, p3, p4, p5)
	return bulkUpdateGamePasses(p2, p3, "ManagedPricing", { ManagedPricing = p4 }, function(p6): boolean
		return p6.isManagedPricingEnabled == p4
	end, "monetization-options.managed-pricing.update-game-passes", p5)
end

function v5.updateGamePassesArchived(p2, p3, p4, p5)
	return bulkUpdateGamePasses(p2, p3, "Archived", { Archived = p4 }, function(p6): boolean
		return p6.isArchived == p4 and (not p4 or p6.isForSale == false)
	end, "monetization-options.archive.update-game-passes", p5)
end

function v5.listShops(p2, p3)
	local baseUrl = creatorApiHttp.baseUrl(transportOptions(p3))

	return get(
		UrlBuilder.UrlBuilder.addQueryString(("%s/shops-api/v1/shops"):format(baseUrl), {
			["scope.type"] = "Universe",
			["scope.scopeId"] = tostring(p2)
		}),
		"monetization-options.shops.list",
		p3,
		decodeShopListResponse
	)
end

function v5.createShop(p2, p3, p4)
	return mutate("POST", ("%s/shops-api/v1/shops"):format((creatorApiHttp.baseUrl(transportOptions(p4)))), {
		scope = { type = "Universe", scopeId = tostring(p2) },
		entryPoints = {
			{ name = "InExperienceGlobalIconEnabled", isEnabled = p3 }
		}
	}, "monetization-options.shops.create", p4, decodeCreatedShop)
end

function v5.setShopGlobalIcon(p2, p3, p4)
	return mutate(
		"PATCH",
		("%s/shops-api/v1/shops/%d/items"):format(creatorApiHttp.baseUrl(transportOptions(p4)), p2),
		{
			changedEntryPoints = {
				{ name = "InExperienceGlobalIconEnabled", isEnabled = p3 }
			}
		},
		"monetization-options.shops.update-global-icon",
		p4,
		decodeBatchUpdateShopItemsResponse
	)
end

function v5.getMonetizationPermission(p2, p3, p4, p5)
	local baseUrl = creatorApiHttp.baseUrl(transportOptions(p5))

	if p3 ~= "Group" or p4 == nil then
		return get(
			("%s/orgs/v2/universes/%d/permissions/resolved"):format(baseUrl, p2),
			"monetization-options.permission.universe",
			p5,
			decodeUniversePermissionResponse
		)
	end

	local groupsBaseUrl = p5 and p5.groupsBaseUrl or Http.Url.GROUPS_URL
	local function getLegacyPermission()
		return get(
			("%s/orgs/v2/universes/%d/permissions/resolved"):format(baseUrl, p2),
			"monetization-options.permission.universe",
			p5,
			decodeUniversePermissionResponse
		)
	end

	local formatted = ("%sv1/groups/%d/migration"):format(groupsBaseUrl, p4)
	return creatorApiHttp.get(
		transportOptions(p5),
		formatted,
		"monetization-options.permission.group-migration",
		decodeGroupMigrationResponse
	):catch(function(p6)
		if type(p6) == "table" and p6.responseCode == 409 then
			return { status = "NotMigrated" }
		end

		return Promise.reject(p6)
	end):andThen(function(p6)
		if p6.status == "Migrated" then
			return get(
				("%sv2/groups/%d/universes/%d/permissions/resolved"):format(groupsBaseUrl, p4, p2),
				"monetization-options.permission.group",
				p5,
				decodeGroupPermissionResponse
			)
		end

		return getLegacyPermission()
	end)
end

return v5
