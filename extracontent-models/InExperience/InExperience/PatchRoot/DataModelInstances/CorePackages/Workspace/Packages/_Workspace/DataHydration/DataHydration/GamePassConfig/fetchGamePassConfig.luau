local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local creatorApiHttp = require(DataHydration.creatorApiHttp)
require(script.Parent.GamePassConfigTypes)
local incompleteListCode = require(script.Parent.incompleteListCode)

local FFlagDataHydrationPreserveIncompleteCatalogResults = require(DataHydration.Flags.FFlagDataHydrationPreserveIncompleteCatalogResults)

local function collectionUrl(p: string, p2: number) -- 2 equivalent calls inferred from this helper
	return ("%s/game-passes/v1/universes/%d/game-passes"):format(p, p2)
end

local function passUrl(p: string, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	return ("%s/%d"):format(collectionUrl(p, p2), p3) -- inferred equivalent call
end

local function requestParts(data)
	local parts = {}

	if data.name ~= nil then
		table.insert(parts, { name = "name", value = data.name })
	end

	if data.description ~= nil then
		table.insert(parts, { name = "description", value = data.description })
	end

	if data.priceInRobux ~= nil then
		table.insert(parts, { name = "price", value = tostring(data.priceInRobux) })
	end

	if data.isForSale ~= nil then
		table.insert(parts, { name = "isForSale", value = tostring(data.isForSale) })
	end

	if data.isManagedPricingEnabled ~= nil then
		table.insert(parts, {
			name = "isManagedPricingEnabled",
			value = tostring(data.isManagedPricingEnabled)
		})
	end

	if data.imageFile ~= nil then
		table.insert(parts, creatorApiHttp.imagePart(data.imageFile))
	end

	return parts
end

local function listPage(p: number, pageToken: string?, p2)
	local v = creatorApiHttp.withQuery(("%s/creator"):format(collectionUrl(creatorApiHttp.baseUrl(p2), p)), {
		pageToken = pageToken
	})

	return creatorApiHttp.get(p2, v, "game-pass.list", function(p3)
		return p3
	end)
end

local FetchGamePassConfig = {}

function FetchGamePassConfig.list(p: number, p2)
	local gamePasses = {}
	local nextPageTokenSet = {}
	local gamePassIdSet = {}
	local function fetchNext(pageToken: string?, p3: number)
		return listPage(p, pageToken, p2):andThen(function(p4)
			for _, gamePass in p4.gamePasses do
				if FFlagDataHydrationPreserveIncompleteCatalogResults then
					assert(not gamePassIdSet[gamePass.gamePassId], "Game Pass list contains a duplicate ID")
					gamePassIdSet[gamePass.gamePassId] = true
				end

				table.insert(gamePasses, gamePass)
			end

			local nextPageToken = p4.nextPageToken

			if nextPageToken == nil or nextPageToken == "" then
				return { gamePasses = gamePasses }
			end

			if nextPageTokenSet[nextPageToken] or p3 >= 50 then
				return Promise.reject({
					code = incompleteListCode,
					message = nextPageTokenSet[nextPageToken] and "Repeated page token" or "Page limit reached",
					gamePasses = gamePasses,
					nextPageToken = nextPageToken
				})
			end

			nextPageTokenSet[nextPageToken] = true
			return fetchNext(nextPageToken, p3 + 1)
		end)
	end

	return fetchNext(nil, 1)
end

function FetchGamePassConfig.get(p: number, p2: number, p3)
	return creatorApiHttp.get(
		p3,
		("%s/creator"):format(passUrl(creatorApiHttp.baseUrl(p3), p, p2)),
		"game-pass.get",
		function(p4)
			assert(p4.gamePassId == p2, "Game Pass response ID does not match the requested ID")
			return p4
		end
	)
end

function FetchGamePassConfig.batchGet(p: number, gamePassIds, p2)
	return creatorApiHttp.json(
		creatorApiHttp.mutatingNetwork(p2),
		"POST",
		("%s/creator:batchGet"):format(collectionUrl(creatorApiHttp.baseUrl(p2), p)),
		{ gamePassIds = gamePassIds },
		"game-pass.batch-get",
		creatorApiHttp.jsonDecoder(function(p3)
			local v = {}

			for _, item in gamePassIds do
				v[item] = true
			end

			for _, gamePass in p3.gamePasses do
				assert(v[gamePass.gamePassId], "Game Pass batch contains an unexpected or duplicate ID")
				v[gamePass.gamePassId] = nil
			end

			return p3
		end)
	)
end

function FetchGamePassConfig.create(p: number, data, p2)
	local v = requestParts({
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		isForSale = data.isForSale ~= nil and data.isForSale,
		isManagedPricingEnabled = data.isManagedPricingEnabled,
		imageFile = data.imageFile
	})

	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p2),
		"POST",
		collectionUrl(creatorApiHttp.baseUrl(p2), p), -- inferred equivalent call
		v,
		"game-pass.create",
		creatorApiHttp.jsonDecoder(function(p3)
			local v2 = type(p3.gamePassId) == "number" and p3.gamePassId % 1 == 0 and p3.gamePassId > 0
			assert(v2, "Created Game Pass response has an invalid ID")

			return p3
		end)
	)
end

function FetchGamePassConfig.update(p: number, gamePassId: number, p2, p3)
	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p3),
		"PATCH",
		passUrl(creatorApiHttp.baseUrl(p3), p, gamePassId), -- inferred equivalent call
		requestParts(p2),
		"game-pass.update",
		creatorApiHttp.noContentDecoder(function()
			return { gamePassId = gamePassId }
		end)
	)
end

function FetchGamePassConfig.setArchived(p: number, p2: number, flag: boolean, p3)
	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p3),
		"PATCH",
		passUrl(creatorApiHttp.baseUrl(p3), p, p2), -- inferred equivalent call
		{
			{ name = "isArchived", value = tostring(flag) }
		},
		"game-pass.set-archived",
		creatorApiHttp.noContentDecoder(function(): nil
			return nil
		end)
	)
end

function FetchGamePassConfig.getSalesLimit(p: number, p2)
	return creatorApiHttp.get(
		p2,
		("%s/game-passes/v1/game-passes/universes/%d/sales-limit"):format(creatorApiHttp.baseUrl(p2), p),
		"game-pass.sales-limit",
		function(p3)
			return p3
		end
	)
end

return FetchGamePassConfig
