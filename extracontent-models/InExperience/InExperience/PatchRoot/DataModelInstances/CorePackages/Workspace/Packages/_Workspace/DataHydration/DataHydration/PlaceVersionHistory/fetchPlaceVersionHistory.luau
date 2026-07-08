local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.PlaceVersionHistoryStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function debugRestore(s1: string) -- line: 22
	print(`[PlaceVersionHistoryRestoreDebug] { s1 }`)
end
local function debugNote(s2: string) -- line: 26
	print(`[PlaceVersionHistoryNoteDebug] { s2 }`)
end
local function bodyPreview(p1) -- line: 30
	if p1 == nil then
		return "nil"
	end

	local v23 = if typeof(p1) ~= "buffer" then tostring(p1) else buffer.tostring(p1)
	local v24 = string.gsub(v23, "[\r\n]+", " ")

	if #v24 > 500 then
		return string.sub(v24, 1, 500) .. "..."
	end

	return v24
end
local function appendQuery(s3: string, t1: {[any]: any}) -- line: 44
	local v27 = false
	local t2 = {}

	for v29, v30 in t1 do
		if v30 ~= nil then
			v27 = true
			table.insert(t2, ("%s=%s"):format(v29, (tostring(v30))))
		end
	end

	if not v27 then
		return s3
	end

	return s3 .. (string.find(s3, "?", 1, true) == nil and "?" or "&") .. table.concat(t2, "&")
end
local function historyUrl(s4: string, n1: number, p2) -- line: 61
	-- upvalues: appendQuery (copy)
	local v34 = ("%s/place-version-history-api/v1/%d/history"):format(s4, n1)

	if p2 == nil then
		return (appendQuery(v34, {
			pageSize = 100
		}))
	end

	return (appendQuery(v34, {
		cursor = p2.cursor,
		pageSize = p2.pageSize or p2.limit
	}))
end
local function notesUrl(s5: string, n2: number, s6: string) -- line: 69
	return ("%s/place-version-history-api/v1/%d/version/%s/notes"):format(s5, n2, s6)
end
local function revertUrl(s7: string, n3: number, n4: number) -- line: 73
	return ("%s/v1/assets/%d/revert-version?assetVersionNumber=%d"):format(s7, n3, n4)
end
local function rollbackUrl(s8: string, n5: number) -- line: 77
	return ("%s/universes/v1/places/%d/rollback"):format(s8, n5)
end
local function resolveBase(t3: {[any]: any}?) -- line: 81
	-- upvalues: UrlBase (copy)
	local v44 = t3 or {}

	return v44.network, v44.baseUrl or UrlBase.APIS
end
local function resolveDevelopBase(t4: {[any]: any}?) -- line: 86
	-- upvalues: UrlBase (copy)
	return (t4 or {}).developBaseUrl or UrlBase.new("develop")
end
local function resolveMutatingNetwork(t5: {[any]: any}?) -- line: 91
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t5 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end
local function toNumber(p3) -- line: 96
	if type(p3) == "number" then
		return p3
	end

	if type(p3) == "string" then
		return (tonumber(p3))
	end

	return nil
end

return {
	fetchHistory = function(n6: number, t6: {[any]: any}?, p4) -- line: 108
		-- upvalues: UrlBase (copy), historyUrl (copy), fetch (copy), asPromise (copy)
		local v51 = t6 or {}
		local network = v51.network
		local v53 = v51.baseUrl or UrlBase.APIS
		local v54 = historyUrl(v53, n6, p4)
		local v55 = fetch({
			method = "GET",
			analyticsKey = "place-version-history.get-history",
			network = network,
			url = v54,
			decode = function(p5) -- line: 120
				return p5
			end
		})

		return asPromise(v55)
	end,
	revertVersion = function(n7: number, n8: number, t7: {[any]: any}?) -- line: 127
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v59 = ("%s/v1/assets/%d/revert-version?assetVersionNumber=%d"):format((t7 or {}).developBaseUrl or UrlBase.new("develop"), n7, n8)
		local v60 = fetch({
			method = "POST",
			analyticsKey = "place-version-history.revert-version",
			legacy = true,
			network = (t7 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = v59,
			body = {},
			decode = function(_) -- line: 141
				-- upvalues: n7 (copy), n8 (copy)
				return {
					assetId = n7,
					assetVersionNumber = n8
				}
			end
		})

		return asPromise(v60)
	end,
	rollbackPlace = function(n9: number, n10: number, s9: string?, b1: boolean?, t8: {[any]: any}?) -- line: 151
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), bodyPreview (copy), asPromise (copy)
		local v66 = t8 or {}
		local _ = v66.network
		local v68 = ("%s/universes/v1/places/%d/rollback"):format(v66.baseUrl or UrlBase.APIS, n9)
		local v69 = fetch({
			method = "POST",
			analyticsKey = "place-version-history.rollback-place",
			network = (t8 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = v68,
			body = {
				versionToRollback = n10,
				message = s9,
				published = b1
			},
			analytics = function(_, p8, p9, p10, p11, p12) -- line: 170
				-- upvalues: bodyPreview (copy)
				if p10 == nil then
					if p12 ~= "succeeded" then
						local v88 = `request failed method={ p8 } url={ p9 } status={ p12 } durationMs={ math.floor(p11) } response=nil`

						print(`[PlaceVersionHistoryRestoreDebug] { v88 }`)
					end

					return
				end

				if p12 == "succeeded" and p10.statusCode >= 200 and p10.statusCode < 300 then
					return
				end

				local v89 = `request failed method={ p8 } url={ p9 } status={ p12 } httpStatus={ p10.statusCode } httpError={ tostring(p10.httpError) } durationMs={ math.floor(p11) } body="{ bodyPreview(p10.responseBody) }"`

				print(`[PlaceVersionHistoryRestoreDebug] { v89 }`)
			end,
			decode = function(p13) -- line: 192
				-- upvalues: n9 (copy), n10 (copy), s9 (copy)
				local t9 = {
					placeId = n9,
					versionToRollback = n10
				}
				local newVersionNumber = p13.newVersionNumber

				t9.newVersionNumber = if type(newVersionNumber) ~= "number" then if type(newVersionNumber) ~= "string" then nil else tonumber(newVersionNumber) else newVersionNumber
				t9.message = s9

				return t9
			end
		})

		return asPromise(v69)
	end,
	addVersionNote = function(n11: number, s10: string, p14, t10: {[any]: any}?) -- line: 204
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), bodyPreview (copy), asPromise (copy)
		local v74 = t10 or {}
		local _ = v74.network
		local v76 = v74.baseUrl or UrlBase.APIS
		local v77 = if p14.title ~= nil then tostring(#p14.title) else "nil"
		local v78 = if p14.description ~= nil then tostring(#p14.description) else "nil"
		local v79 = fetch({
			method = "POST",
			analyticsKey = "place-version-history.add-note",
			network = (t10 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/place-version-history-api/v1/%d/version/%s/notes"):format(v76, n11, s10),
			body = p14,
			analytics = function(_, p16, p17, p18, p19, p20) -- line: 219
				-- upvalues: v77 (copy), v78 (copy), bodyPreview (copy)
				if p18 == nil then
					if p20 ~= "succeeded" then
						local v99 = `request failed method={ p16 } url={ p17 } status={ p20 } durationMs={ math.floor(p19) } titleLength={ v77 } descriptionLength={ v78 } response=nil`

						print(`[PlaceVersionHistoryNoteDebug] { v99 }`)
					end

					return
				end

				if p20 == "succeeded" and p18.statusCode >= 200 and p18.statusCode < 300 then
					return
				end

				local v100 = `request failed method={ p16 } url={ p17 } status={ p20 } httpStatus={ p18.statusCode } httpError={ tostring(p18.httpError) } durationMs={ math.floor(p19) } titleLength={ v77 } descriptionLength={ v78 } body="{ bodyPreview(p18.responseBody) }"`

				print(`[PlaceVersionHistoryNoteDebug] { v100 }`)
			end,
			decode = function(p21) -- line: 243
				-- upvalues: n11 (copy), s10 (copy)
				return {
					placeId = n11,
					version = s10,
					placeVersion = p21.placeVersion
				}
			end
		})

		return asPromise(v79)
	end
}
