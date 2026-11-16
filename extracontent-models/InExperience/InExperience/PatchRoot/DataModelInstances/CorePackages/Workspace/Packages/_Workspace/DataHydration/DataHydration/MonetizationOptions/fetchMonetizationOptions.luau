local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local Promise = require(parent.Promise)
local t = require(parent.t)
local UrlBuilder = require(parent.UrlBuilder)
local creatorApiHttp = require(DataHydration.creatorApiHttp)
require(script.Parent.MonetizationOptionsTypes)
local fetchGamePassConfig = require(DataHydration.GamePassConfig.fetchGamePassConfig)
require(DataHydration.GamePassConfig.GamePassConfigTypes)

local interface = t.interface({
	status = t.union(t.literal("Disabled"), t.literal("Pending"), t.literal("Accepted"))
})

local interface2 = t.interface({
	errorCode = t.optional(t.string),
	errorMessage = t.optional(t.string),
	field = t.optional(t.string),
	hint = t.optional(t.string)
})

local interface3 = t.interface({ productId = t.integer, error = interface2 })

local interface4 = t.interface({ errors = t.array(interface3) })

local interface5 = t.interface({ gamePassId = t.integer, error = interface2 })

local interface6 = t.interface({ errors = t.array(interface5) })

local interface7 = t.interface({ name = t.string, isEnabled = t.boolean })

local interface8 = t.interface({ shopId = t.integer, entryPoints = t.array(interface7) })

local interface9 = t.interface({
	shopId = t.integer,
	status = t.union(t.literal("Draft"), t.literal("Active"))
})

local interface10 = t.interface({ shops = t.array(interface8) })

local interface11 = t.interface({ createdCategories = t.array(t.table) })

local interface12 = t.interface({ monetizeExperience = t.boolean })

local interface13 = t.interface({
	status = t.union(t.literal("Invalid"), t.literal("NotMigrated"), t.literal("Migrating"), t.literal("Migrated"))
})

local interface14 = t.interface({
	permissions = t.optional(t.map(t.string, t.boolean))
})

local function validateResponse(p: string, callback, p2)
	local v, v2 = callback(p2)
	assert(v, `Invalid {p} response: {tostring(v2)}`)
	return p2
end

local function decodeManagedPricingResponse(p)
	local v, v2 = interface(p)
	assert(v, `Invalid Managed Pricing response: {tostring(v2)}`)
	return p
end

local function decodeBulkDeveloperProductUpdateResponse(p)
	local v, v2 = interface4(p)
	assert(v, `Invalid bulk developer product update response: {tostring(v2)}`)
	return p
end

local function decodeBulkGamePassUpdateResponse(gamePassIdSet, p)
	local v, v2 = interface6(p)
	assert(v, `Invalid bulk Game Pass update response: {tostring(v2)}`)

	local gamePassIdSet2 = {}

	for _, err in p.errors do
		assert(gamePassIdSet[err.gamePassId], "Bulk Game Pass update error has an unexpected ID")
		assert(not gamePassIdSet2[err.gamePassId], "Bulk Game Pass update error has a duplicate ID")
		gamePassIdSet2[err.gamePassId] = true
	end

	return p
end

local function decodeCreatedShop(p)
	local v, v2 = interface9(p)
	assert(v, `Invalid created Shop response: {tostring(v2)}`)
	return p
end

local function decodeShopListResponse(p)
	local v, v2 = interface10(p)
	assert(v, `Invalid Shop list response: {tostring(v2)}`)
	return p
end

local function decodeUniversePermissionResponse(p)
	local v, v2 = interface12(p)
	assert(v, `Invalid universe permission response: {tostring(v2)}`)

	return { canMonetize = p.monetizeExperience }
end

local function decodeGroupMigrationResponse(p)
	local v, v2 = interface13(p)
	assert(v, `Invalid group migration response: {tostring(v2)}`)
	return p
end

local function decodeGroupPermissionResponse(p)
	local v, v2 = interface14(p)
	assert(v, `Invalid group permission response: {tostring(v2)}`)

	return {
		canMonetize = p.permissions ~= nil and p.permissions.canMonetize == true
	}
end

local function decodeBatchUpdateShopItemsResponse(p)
	local v, v2 = interface11(p)
	assert(v, `Invalid Shop item update response: {tostring(v2)}`)
	return p
end

local function decodeEmptyResponse(_): nil
	return nil
end

local function transportOptions(options)
	local v = options or {}
	return {
		network = v.network,
		readNetwork = v.readNetwork,
		mutatingNetwork = v.mutatingNetwork,
		baseUrl = v.baseUrl,
		retryReads = false
	}
end

local function resolveBase(p) -- 8 equivalent calls inferred from this helper
	return creatorApiHttp.baseUrl(transportOptions(p))
end

local function get(p: string, p2: string, p3, callback) -- 1 equivalent call inferred from this helper
	return creatorApiHttp.get(transportOptions(p3), p, p2, callback)
end

local function mutate(p: string, p2: string, p3, p4: string, p5, callback) -- 2 equivalent calls inferred from this helper
	local v = transportOptions(p5)
	return creatorApiHttp.json(creatorApiHttp.mutatingNetwork(v), p, p2, p3, p4, creatorApiHttp.jsonDecoder(callback))
end

local FetchMonetizationOptions = {}

function FetchMonetizationOptions.getManagedPricing(p: number, p2)
	return get(
		("%s/price-configuration-api/v1/universes/%d/managed-pricing"):format(resolveBase(p2), p), -- inferred equivalent call
		"monetization-options.managed-pricing.get",
		p2,
		decodeManagedPricingResponse
	)
end

function FetchMonetizationOptions.acceptManagedPricing(p: number, p2)
	return mutate(
		"POST",
		("%s/price-configuration-api/v1/universes/%d/managed-pricing:accept"):format(resolveBase(p2), p), -- inferred equivalent call
		nil,
		"monetization-options.managed-pricing.accept",
		p2,
		decodeEmptyResponse
	)
end

function FetchMonetizationOptions.updateDeveloperProductsManagedPricing(p: number, list, isManagedPricingEnabled: boolean, p2)
	local base = resolveBase(p2) -- inferred equivalent call
	local errors = {}
	local total = 1
	local function updateNextBatch()
		local developerProductUpdates = {}

		for i = total, math.min(total + 30 - 1, #list) do
			table.insert(developerProductUpdates, {
				productId = list[i],
				changedProperties = { isManagedPricingEnabled = isManagedPricingEnabled }
			})
		end

		if #developerProductUpdates == 0 then
			return Promise.resolve({ errors = errors })
		end

		total += #developerProductUpdates

		return mutate( -- inferred equivalent call
			"PATCH",
			("%s/developer-products/v1/universes/%d/developer-products"):format(base, p),
			{ developerProductUpdates = developerProductUpdates },
			"monetization-options.managed-pricing.update-products",
			p2,
			decodeBulkDeveloperProductUpdateResponse
		):andThen(function(p3)
			for _, v in p3.errors or {} do
				table.insert(errors, v)
			end

			return updateNextBatch()
		end)
	end

	return updateNextBatch()
end

local function bulkUpdateGamePasses(p: number, p2, p3: string, changedProperties, fn, p4: string, p5)
	local base = resolveBase(p5) -- inferred equivalent call
	local clone = table.clone(p2)
	local v = {
		baseUrl = base,
		network = creatorApiHttp.readNetwork(transportOptions(p5))
	}
	local errors = {}
	local results = {}
	local v2 = 1
	local frozen = table.freeze({
		errorMessage = "The local user changed while the bulk Game Pass request was running"
	})

	local function isRequestCurrent() -- 1 equivalent call inferred from this helper
		return p5 == nil or (p5.isRequestCurrent == nil or p5.isRequestCurrent())
	end

	local function appendSessionChanged(items, p6)
		for _, item in items do
			local v3

			if p6 ~= nil then
				v3 = p6[item]
			end

			local v4

			if v3 == nil then
				v4 = {
					gamePassId = item,
					status = "unverified",
					reason = "session_changed",
					error = frozen
				}
			else
				v4 = {
					gamePassId = item,
					status = "failed",
					reason = "service_error",
					error = v3.error
				}
			end

			table.insert(results, v4)
		end
	end

	local function updateNextBatch()
		if isRequestCurrent() then -- inferred equivalent call
			local v3 = {}
			local gamePassUpdates = {}

			for i = v2, math.min(v2 + 30 - 1, #clone) do
				table.insert(v3, clone[i])
				table.insert(gamePassUpdates, {
					gamePassId = clone[i],
					changedPropertyNames = { p3 },
					changedProperties = changedProperties
				})
			end

			if #gamePassUpdates == 0 then
				return Promise.resolve({ errors = errors, results = results })
			end

			v2 += #gamePassUpdates
			local gamePassIdSet = {}

			for _, v4 in gamePassUpdates do
				gamePassIdSet[v4.gamePassId] = true
			end

			local function readBack(p6, mutationError)
				local errorsByGamePassId = {}
				local gamePassIds = {}

				if p6 ~= nil then
					for _, err in p6.errors do
						table.insert(errors, err)
						errorsByGamePassId[err.gamePassId] = err
					end
				end

				for _, v4 in gamePassUpdates do
					if errorsByGamePassId[v4.gamePassId] == nil then
						table.insert(gamePassIds, v4.gamePassId)
					end
				end

				if p5 == nil or p5.isRequestCurrent == nil or p5.isRequestCurrent() then
					return fetchGamePassConfig.batchGet(p, gamePassIds, v):andThen(function(p7)
						if p5 ~= nil and p5.isRequestCurrent ~= nil and not p5.isRequestCurrent() then
							appendSessionChanged(v3, errorsByGamePassId)
							return updateNextBatch()
						end

						local gamePassesByGamePassId = {}

						for _, gamePass in p7.gamePasses do
							gamePassesByGamePassId[gamePass.gamePassId] = gamePass
						end

						for _, v4 in gamePassUpdates do
							local gamePassId = v4.gamePassId
							local v5 = errorsByGamePassId[gamePassId]
							local config = gamePassesByGamePassId[gamePassId]

							if v5 == nil then
								if config == nil then
									table.insert(results, {
										gamePassId = gamePassId,
										status = "unverified",
										reason = "readback_failed",
										mutationError = mutationError
									})
								else
									local v6 = fn(config)
									table.insert(results, {
										gamePassId = gamePassId,
										status = v6 and "confirmed" or "unverified",
										reason = not v6 and "readback_mismatch" or nil,
										config = config,
										mutationError = mutationError
									})
								end
							else
								table.insert(results, {
									gamePassId = gamePassId,
									status = "failed",
									reason = "service_error",
									error = v5.error
								})
							end
						end

						return updateNextBatch()
					end, function(err)
						if p5 ~= nil and p5.isRequestCurrent ~= nil and not p5.isRequestCurrent() then
							appendSessionChanged(v3, errorsByGamePassId)
							return updateNextBatch()
						end

						for _, v4 in gamePassUpdates do
							local v5 = errorsByGamePassId[v4.gamePassId]
							local v6

							if v5 == nil then
								v6 = {
									gamePassId = v4.gamePassId,
									status = "unverified",
									reason = "readback_failed",
									error = err,
									mutationError = mutationError
								}
							else
								v6 = {
									gamePassId = v4.gamePassId,
									status = "failed",
									reason = "service_error",
									error = v5.error
								}
							end

							table.insert(results, v6)
						end

						return updateNextBatch()
					end)
				end

				appendSessionChanged(v3, errorsByGamePassId)
				return updateNextBatch()
			end

			local function fn2(p6)
				return decodeBulkGamePassUpdateResponse(gamePassIdSet, p6)
			end

			return mutate( -- inferred equivalent call
				"POST",
				("%s/game-passes/v1/game-passes/universes/%d/bulk-update"):format(base, p),
				{ gamePassUpdates = gamePassUpdates },
				p4,
				p5,
				fn2
			):andThen(
				function(p6)
					return readBack(p6, nil)
				end,
				function(err)
					local responseCode

					if typeof(err) == "table" then
						responseCode = err.responseCode
					end

					if
						responseCode == nil
						or not (StatusCodes.BAD_REQUEST <= responseCode)
						or not (responseCode < StatusCodes.INTERNAL_SERVER_ERROR)
						or responseCode == StatusCodes.REQUEST_TIMEOUT
					then
						return readBack(nil, err)
					end

					local v4 = responseCode == StatusCodes.UNAUTHORIZED
						or responseCode == StatusCodes.FORBIDDEN
						or responseCode == StatusCodes.TOO_MANY_REQUESTS
					local v5

					if v4 then
						v5 = #clone
					else
						v5 = v2 - 1
					end

					for i = v2 - #gamePassUpdates, v5 do
						table.insert(results, {
							gamePassId = clone[i],
							status = "failed",
							reason = "service_error",
							error = err
						})
					end

					if v4 then
						return { errors = errors, results = results }
					end

					return updateNextBatch()
				end
			)
		else
			local v3 = {}

			for i = v2, #clone do
				table.insert(v3, clone[i])
			end

			v2 = #clone + 1
			appendSessionChanged(v3)
			return Promise.resolve({ errors = errors, results = results })
		end
	end

	return updateNextBatch()
end

function FetchMonetizationOptions.updateGamePassesManagedPricing(p: number, p2, managedPricing: boolean, p3)
	return bulkUpdateGamePasses(p, p2, "ManagedPricing", { ManagedPricing = managedPricing }, function(p4): boolean
		return p4.isManagedPricingEnabled == managedPricing
	end, "monetization-options.managed-pricing.update-game-passes", p3)
end

function FetchMonetizationOptions.updateGamePassesArchived(p: number, p2, archived: boolean, p3)
	return bulkUpdateGamePasses(p, p2, "Archived", { Archived = archived }, function(p4): boolean
		return p4.isArchived == archived and (not archived or p4.isForSale == false)
	end, "monetization-options.archive.update-game-passes", p3)
end

function FetchMonetizationOptions.listShops(p: number, p2)
	local base = resolveBase(p2) -- inferred equivalent call
	return get(
		UrlBuilder.UrlBuilder.addQueryString(("%s/shops-api/v1/shops"):format(base), {
			["scope.type"] = "Universe",
			["scope.scopeId"] = tostring(p)
		}),
		"monetization-options.shops.list",
		p2,
		decodeShopListResponse
	)
end

function FetchMonetizationOptions.createShop(p: number, isEnabled: boolean, p2)
	return mutate("POST", ("%s/shops-api/v1/shops"):format((resolveBase(p2))), { -- inferred equivalent call
		scope = { type = "Universe", scopeId = tostring(p) },
		entryPoints = {
			{ name = "InExperienceGlobalIconEnabled", isEnabled = isEnabled }
		}
	}, "monetization-options.shops.create", p2, decodeCreatedShop)
end

function FetchMonetizationOptions.setShopGlobalIcon(p: number, isEnabled: boolean, p2)
	return mutate("PATCH", ("%s/shops-api/v1/shops/%d/items"):format(resolveBase(p2), p), { -- inferred equivalent call
		changedEntryPoints = {
			{ name = "InExperienceGlobalIconEnabled", isEnabled = isEnabled }
		}
	}, "monetization-options.shops.update-global-icon", p2, decodeBatchUpdateShopItemsResponse)
end

function FetchMonetizationOptions.getMonetizationPermission(p: number, p2: string, p3: number?, p4)
	local base = resolveBase(p4) -- inferred equivalent call

	if p2 ~= "Group" or p3 == nil then
		return get(
			("%s/orgs/v2/universes/%d/permissions/resolved"):format(base, p),
			"monetization-options.permission.universe",
			p4,
			decodeUniversePermissionResponse
		)
	end

	local groupsBaseUrl = p4 and p4.groupsBaseUrl or Http.Url.GROUPS_URL
	local function getLegacyPermission()
		return get(
			("%s/orgs/v2/universes/%d/permissions/resolved"):format(base, p),
			"monetization-options.permission.universe",
			p4,
			decodeUniversePermissionResponse
		)
	end

	return get( -- inferred equivalent call
		("%sv1/groups/%d/migration"):format(groupsBaseUrl, p3),
		"monetization-options.permission.group-migration",
		p4,
		decodeGroupMigrationResponse
	):catch(function(p5)
		if type(p5) == "table" and p5.responseCode == 409 then
			return { status = "NotMigrated" }
		end

		return Promise.reject(p5)
	end):andThen(function(p5)
		if p5.status == "Migrated" then
			return get(
				("%sv2/groups/%d/universes/%d/permissions/resolved"):format(groupsBaseUrl, p3, p),
				"monetization-options.permission.group",
				p4,
				decodeGroupPermissionResponse
			)
		end

		return getLegacyPermission()
	end)
end

return FetchMonetizationOptions
