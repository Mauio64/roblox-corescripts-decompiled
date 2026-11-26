local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceVersionHistory/PlaceVersionHistoryStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function debugRestore(p2)
	print(`[PlaceVersionHistoryRestoreDebug] {p2}`)
end

local function debugNote(p2)
	print(`[PlaceVersionHistoryNoteDebug] {p2}`)
end

local function bodyPreview(responseBody)
	if responseBody == nil then
		return "nil"
	end

	local v5

	if typeof(responseBody) == "buffer" then
		v5 = buffer.tostring(responseBody)
	else
		v5 = tostring(responseBody)
	end

	local v6 = string.gsub(v5, "[\r\n]+", " ")

	if #v6 > 500 then
		return string.sub(v6, 1, 500) .. "..."
	end

	return v6
end

local function appendQuery(value, items)
	local v5 = {}
	local flag = false

	for k, item in items do
		if item == nil then
			continue
		end

		table.insert(v5, ("%s=%s"):format(k, (tostring(item))))
		flag = true
	end

	if flag then
		return value .. (string.find(value, "?", 1, true) == nil and "?" or "&") .. table.concat(v5, "&")
	end

	return value
end

local function historyUrl(baseUrl, p2, data)
	local formatted = ("%s/place-version-history-api/v1/%d/history"):format(baseUrl, p2)

	if data == nil then
		return appendQuery(formatted, { pageSize = 100 })
	end

	return appendQuery(formatted, {
		cursor = data.cursor,
		pageSize = data.pageSize or data.limit,
		isPublished = data.isPublished
	})
end

local function notesUrl(p2, p3, p4)
	return ("%s/place-version-history-api/v1/%d/version/%s/notes"):format(p2, p3, p4)
end

local function revertUrl(p2, p3, p4)
	return ("%s/v1/assets/%d/revert-version?assetVersionNumber=%d"):format(p2, p3, p4)
end

local function rollbackUrl(p2, p3)
	return ("%s/universes/v1/places/%d/rollback"):format(p2, p3)
end

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.APIS
end

local function resolveDevelopBase(options)
	return (options or {}).developBaseUrl or urlBase.new("develop")
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function toNumber(value)
	if type(value) == "number" then
		return value
	end

	if type(value) == "string" then
		return (tonumber(value))
	end

	return nil
end

local v5 = { DEFAULT_HISTORY_PAGE_SIZE = 100 }

function v5.fetchHistory(p2, options, p3)
	local v6 = options or {}
	local network = v6.network
	local baseUrl = v6.baseUrl or urlBase.APIS

	return asPromise((fetch({
		network = network,
		method = "GET",
		url = historyUrl(baseUrl, p2, p3),
		analyticsKey = "place-version-history.get-history",
		decode = function(p4)
			return p4
		end
	})))
end

function v5.revertVersion(p2, p3, options)
	local formatted = ("%s/v1/assets/%d/revert-version?assetVersionNumber=%d"):format(
		(options or {}).developBaseUrl or urlBase.new("develop"),
		p2,
		p3
	)

	return asPromise((fetch({
		network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		method = "POST",
		url = formatted,
		body = {},
		analyticsKey = "place-version-history.revert-version",
		legacy = true,
		decode = function(p4)
			return { assetId = p2, assetVersionNumber = p3 }
		end
	})))
end

function v5.rollbackPlace(p2, p3, message, p4, options)
	local v6 = options or {}
	local network = v6.network
	local formatted = ("%s/universes/v1/places/%d/rollback"):format(v6.baseUrl or urlBase.APIS, p2)

	return asPromise((fetch({
		network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		method = "POST",
		url = formatted,
		body = { versionToRollback = p3, message = message, published = p4 },
		analyticsKey = "place-version-history.rollback-place",
		analytics = function(p5, p6, p7, data, p8, p9)
			if data == nil then
				if p9 ~= "succeeded" then
					local formatted2 = `request failed method={p6} url={p7} status={p9} durationMs={math.floor(p8)} response=nil`
					print(`[PlaceVersionHistoryRestoreDebug] {formatted2}`)
				end
			else
				if p9 == "succeeded" and data.statusCode >= 200 and data.statusCode < 300 then
					return
				end

				local formatted2 = `request failed method={p6} url={p7} status={p9} httpStatus={data.statusCode} httpError={tostring(data.httpError)} durationMs={math.floor(p8)} body="{bodyPreview(data.responseBody)}"`
				print(`[PlaceVersionHistoryRestoreDebug] {formatted2}`)
			end
		end,
		decode = function(p5)
			local v7 = {
				placeId = p2,
				versionToRollback = p3,
				newVersionNumber = 0,
				message = 0
			}

			local newVersionNumber = p5.newVersionNumber

			if type(newVersionNumber) ~= "number" then
				newVersionNumber = if type(newVersionNumber) == "string" then tonumber(newVersionNumber) else nil
			end

			v7.newVersionNumber = newVersionNumber
			v7.message = message
			return v7
		end
	})))
end

function v5.addVersionNote(p2, p3, p4, options)
	local v6 = options or {}
	local network = v6.network
	local baseUrl = v6.baseUrl or urlBase.APIS

	local v7 = p4.title == nil and "nil" or tostring(#p4.title)
	local v8 = p4.description == nil and "nil" or tostring(#p4.description)
	return asPromise((fetch({
		network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		method = "POST",
		url = ("%s/place-version-history-api/v1/%d/version/%s/notes"):format(baseUrl, p2, p3),
		body = p4,
		analyticsKey = "place-version-history.add-note",
		analytics = function(p5, p6, p7, data, p8, p9)
			if data == nil then
				if p9 ~= "succeeded" then
					local formatted = `request failed method={p6} url={p7} status={p9} durationMs={math.floor(p8)} titleLength={v7} descriptionLength={v8} response=nil`
					print(`[PlaceVersionHistoryNoteDebug] {formatted}`)
				end
			else
				if p9 == "succeeded" and data.statusCode >= 200 and data.statusCode < 300 then
					return
				end

				local formatted = `request failed method={p6} url={p7} status={p9} httpStatus={data.statusCode} httpError={tostring(data.httpError)} durationMs={math.floor(p8)} titleLength={v7} descriptionLength={v8} body="{bodyPreview(data.responseBody)}"`
				print(`[PlaceVersionHistoryNoteDebug] {formatted}`)
			end
		end,
		decode = function(p5)
			return { placeId = p2, version = p3, placeVersion = p5.placeVersion }
		end
	})))
end

return v5
