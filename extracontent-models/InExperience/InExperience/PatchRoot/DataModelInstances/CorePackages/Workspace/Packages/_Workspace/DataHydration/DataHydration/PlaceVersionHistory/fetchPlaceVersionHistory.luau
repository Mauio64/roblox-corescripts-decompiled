local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.PlaceVersionHistoryStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function debugRestore(p: string) -- 2 equivalent calls inferred from this helper
	print(`[PlaceVersionHistoryRestoreDebug] {p}`)
end

local function debugNote(p: string) -- 2 equivalent calls inferred from this helper
	print(`[PlaceVersionHistoryNoteDebug] {p}`)
end

local function bodyPreview(responseBody)
	if responseBody == nil then
		return "nil"
	end

	local v

	if typeof(responseBody) == "buffer" then
		v = buffer.tostring(responseBody)
	else
		v = tostring(responseBody)
	end

	local v2 = string.gsub(v, "[\r\n]+", " ")

	if #v2 > 500 then
		return string.sub(v2, 1, 500) .. "..."
	end

	return v2
end

local function appendQuery(value: string, items)
	local v = {}
	local flag = false

	for k, item in items do
		if item == nil then
			continue
		end

		table.insert(v, ("%s=%s"):format(k, (tostring(item))))
		flag = true
	end

	if flag then
		return value .. (string.find(value, "?", 1, true) == nil and "?" or "&") .. table.concat(v, "&")
	end

	return value
end

local function historyUrl(baseUrl: string, p: number, data)
	local formatted = ("%s/place-version-history-api/v1/%d/history"):format(baseUrl, p)

	if data == nil then
		return appendQuery(formatted, { pageSize = 100 })
	end

	return appendQuery(formatted, {
		cursor = data.cursor,
		pageSize = data.pageSize or data.limit,
		isPublished = data.isPublished
	})
end

local function notesUrl(p: string, p2: number, p3: string) -- 1 equivalent call inferred from this helper
	return ("%s/place-version-history-api/v1/%d/version/%s/notes"):format(p, p2, p3)
end

local function revertUrl(p: string, p2: number, p3: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/assets/%d/revert-version?assetVersionNumber=%d"):format(p, p2, p3)
end

local function rollbackUrl(baseUrl: string, p: number) -- 1 equivalent call inferred from this helper
	return ("%s/universes/v1/places/%d/rollback"):format(baseUrl, p)
end

local function resolveBase(options) -- 1 equivalent call inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.APIS
end

local function resolveDevelopBase(options) -- 1 equivalent call inferred from this helper
	return (options or {}).developBaseUrl or UrlBase.new("develop")
end

local function resolveMutatingNetwork(options) -- 3 equivalent calls inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function toNumber(newVersionNumber) -- 1 equivalent call inferred from this helper
	if type(newVersionNumber) == "number" then
		return newVersionNumber
	end

	if type(newVersionNumber) == "string" then
		return (tonumber(newVersionNumber))
	end

	return nil
end

local FetchPlaceVersionHistory = { DEFAULT_HISTORY_PAGE_SIZE = 100 }

function FetchPlaceVersionHistory.fetchHistory(p: number, options, p2)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = historyUrl(v.baseUrl or UrlBase.APIS, p, p2),
		analyticsKey = "place-version-history.get-history",
		decode = function(p3)
			return p3
		end
	})))
end

function FetchPlaceVersionHistory.revertVersion(assetId: number, assetVersionNumber: number, options)
	local url = revertUrl(resolveDevelopBase(options), assetId, assetVersionNumber) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = url,
		body = {},
		analyticsKey = "place-version-history.revert-version",
		legacy = true,
		decode = function(_)
			return { assetId = assetId, assetVersionNumber = assetVersionNumber }
		end
	})))
end

function FetchPlaceVersionHistory.rollbackPlace(placeId: number, versionToRollback: number, message: string?, published: boolean?, options)
	local v = options or {}
	local _network = v.network
	local url = rollbackUrl(v.baseUrl or UrlBase.APIS, placeId) -- inferred equivalent call

	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = url,
		body = { versionToRollback = versionToRollback, message = message, published = published },
		analyticsKey = "place-version-history.rollback-place",
		analytics = function(_, p, p2, data, p3, p4)
			if data == nil then
				if p4 ~= "succeeded" then
					debugRestore(`request failed method={p} url={p2} status={p4} durationMs={math.floor(p3)} response=nil`) -- inferred equivalent call
				end
			else
				if p4 == "succeeded" and data.statusCode >= 200 and data.statusCode < 300 then
					return
				end

				debugRestore(`request failed method={p} url={p2} status={p4} httpStatus={data.statusCode} httpError={tostring(data.httpError)} durationMs={math.floor(p3)} body="{bodyPreview(data.responseBody)}"`) -- inferred equivalent call
			end
		end,
		decode = function(p)
			return {
				placeId = placeId,
				versionToRollback = versionToRollback,
				newVersionNumber = toNumber(p.newVersionNumber), -- inferred equivalent call
				message = message
			}
		end
	})))
end

function FetchPlaceVersionHistory.addVersionNote(placeId: number, version: string, body, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	local v2 = body.title == nil and "nil" or tostring(#body.title)
	local v3 = body.description == nil and "nil" or tostring(#body.description)
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = notesUrl(v, placeId, version), -- inferred equivalent call
		body = body,
		analyticsKey = "place-version-history.add-note",
		analytics = function(_, p, p2, data, p3, p4)
			if data == nil then
				if p4 ~= "succeeded" then
					debugNote(`request failed method={p} url={p2} status={p4} durationMs={math.floor(p3)} titleLength={v2} descriptionLength={v3} response=nil`) -- inferred equivalent call
				end
			else
				if p4 == "succeeded" and data.statusCode >= 200 and data.statusCode < 300 then
					return
				end

				debugNote(`request failed method={p} url={p2} status={p4} httpStatus={data.statusCode} httpError={tostring(data.httpError)} durationMs={math.floor(p3)} titleLength={v2} descriptionLength={v3} body="{bodyPreview(data.responseBody)}"`) -- inferred equivalent call
			end
		end,
		decode = function(p)
			return { placeId = placeId, version = version, placeVersion = p.placeVersion }
		end
	})))
end

return FetchPlaceVersionHistory
