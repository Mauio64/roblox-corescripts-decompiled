local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local creatorApiHttp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/creatorApiHttp")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")
local incompleteListCode = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/incompleteListCode")

local FFlagDataHydrationPreserveIncompleteCatalogResults = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagDataHydrationPreserveIncompleteCatalogResults")

local function collectionUrl(p2, p3)
	return ("%s/game-passes/v1/universes/%d/game-passes"):format(p2, p3)
end

local function passUrl(p2, p3, p4)
	return ("%s/%d"):format(("%s/game-passes/v1/universes/%d/game-passes"):format(p2, p3), p4)
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

local function listPage(p2, p3, p4)
	local v6 = creatorApiHttp.withQuery(("%s/creator"):format(collectionUrl(creatorApiHttp.baseUrl(p4), p2)), {
		pageToken = p3
	})

	return creatorApiHttp.get(p4, v6, "game-pass.list", function(p5)
		return p5
	end)
end

return {
	list = function(p2, p3)
		local gamePasses = {}
		local nextPageTokenSet = {}
		local gamePassIdSet = {}
		local function fetchNext(p4, p5)
			return listPage(p2, p4, p3):andThen(function(p6)
				for k, gamePass in p6.gamePasses do
					if FFlagDataHydrationPreserveIncompleteCatalogResults then
						assert(
							not gamePassIdSet[gamePass.gamePassId],
							"Game Pass list contains a duplicate ID"
						)
						gamePassIdSet[gamePass.gamePassId] = true
					end

					table.insert(gamePasses, gamePass)
				end

				local nextPageToken = p6.nextPageToken

				if nextPageToken == nil or nextPageToken == "" then
					return { gamePasses = gamePasses }
				end

				if nextPageTokenSet[nextPageToken] or p5 >= 50 then
					return Promise.reject({
						code = incompleteListCode,
						message = nextPageTokenSet[nextPageToken] and "Repeated page token" or "Page limit reached",
						gamePasses = gamePasses,
						nextPageToken = nextPageToken
					})
				end

				nextPageTokenSet[nextPageToken] = true
				return fetchNext(nextPageToken, p5 + 1)
			end)
		end

		return fetchNext(nil, 1)
	end,
	get = function(p2, p3, p4)
		return creatorApiHttp.get(
			p4,
			("%s/creator"):format(passUrl(creatorApiHttp.baseUrl(p4), p2, p3)),
			"game-pass.get",
			function(p5)
				assert(p5.gamePassId == p3, "Game Pass response ID does not match the requested ID")
				return p5
			end
		)
	end,
	batchGet = function(p2, items, p3)
		return creatorApiHttp.json(
			creatorApiHttp.mutatingNetwork(p3),
			"POST",
			("%s/creator:batchGet"):format(collectionUrl(creatorApiHttp.baseUrl(p3), p2)),
			{ gamePassIds = items },
			"game-pass.batch-get",
			creatorApiHttp.jsonDecoder(function(p4)
				local v6 = {}

				for k, item in items do
					v6[item] = true
				end

				for k, gamePass in p4.gamePasses do
					assert(
						v6[gamePass.gamePassId],
						"Game Pass batch contains an unexpected or duplicate ID"
					)
					v6[gamePass.gamePassId] = nil
				end

				return p4
			end)
		)
	end,
	create = function(p2, data, p3)
		local v9 = requestParts({
			name = data.name,
			description = data.description,
			priceInRobux = data.priceInRobux,
			isForSale = data.isForSale ~= nil and data.isForSale,
			isManagedPricingEnabled = data.isManagedPricingEnabled,
			imageFile = data.imageFile
		})
		return creatorApiHttp.multipart(
			creatorApiHttp.mutatingNetwork(p3),
			"POST",
			("%s/game-passes/v1/universes/%d/game-passes"):format(creatorApiHttp.baseUrl(p3), p2),
			v9,
			"game-pass.create",
			creatorApiHttp.jsonDecoder(function(p4)
				local v10 = type(p4.gamePassId) == "number" and p4.gamePassId % 1 == 0 and p4.gamePassId > 0
				assert(v10, "Created Game Pass response has an invalid ID")

				return p4
			end)
		)
	end,
	update = function(p2, p3, p4, p5)
		return creatorApiHttp.multipart(
			creatorApiHttp.mutatingNetwork(p5),
			"PATCH",
			("%s/%d"):format(
				("%s/game-passes/v1/universes/%d/game-passes"):format(creatorApiHttp.baseUrl(p5), p2),
				p3
			),
			requestParts(p4),
			"game-pass.update",
			creatorApiHttp.noContentDecoder(function()
				return { gamePassId = p3 }
			end)
		)
	end,
	setArchived = function(p2, p3, p4, p5)
		return creatorApiHttp.multipart(
			creatorApiHttp.mutatingNetwork(p5),
			"PATCH",
			("%s/%d"):format(
				("%s/game-passes/v1/universes/%d/game-passes"):format(creatorApiHttp.baseUrl(p5), p2),
				p3
			),
			{
				{ name = "isArchived", value = tostring(p4) }
			},
			"game-pass.set-archived",
			creatorApiHttp.noContentDecoder(function(): nil
				return nil
			end)
		)
	end,
	getSalesLimit = function(p2, p3)
		return creatorApiHttp.get(
			p3,
			("%s/game-passes/v1/game-passes/universes/%d/sales-limit"):format(creatorApiHttp.baseUrl(p3), p2),
			"game-pass.sales-limit",
			function(p4)
				return p4
			end
		)
	end
}
