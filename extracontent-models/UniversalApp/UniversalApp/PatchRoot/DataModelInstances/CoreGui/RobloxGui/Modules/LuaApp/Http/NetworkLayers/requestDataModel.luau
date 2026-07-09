local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local HttpError = require(Modules.LuaApp.Http.HttpError)
local HttpResponse = require(Modules.LuaApp.Http.HttpResponse)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes

local function makeRequest(p1, p2, p3) -- line: 20
	-- upvalues: StatusCodes (copy), HttpResponse (copy)
	local timestamp = tick()
	local ok, result = pcall(p2, unpack(p3))
	local v15 = (tick() - timestamp) * 1000
	local OK

	if ok then
		OK = StatusCodes.OK
	else
		OK = StatusCodes.UNKNOWN_ERROR

		local match = string.match(result, ".*%((.*)%)")

		if match then
			local v18 = string.find(match, "%d%d%d")

			if v18 then
				OK = tonumber((string.sub(match, v18, v18 + 2)))
				result = string.sub(match, v18 + 4)
			end
		end
	end

	return HttpResponse.new(p1, result, v15, OK)
end
local function getErrorFromResponse(p4) -- line: 58
	-- upvalues: HttpError (copy), StatusCodes (copy)
	local Unknown = HttpError.Kind.Unknown
	local responseBody = p4.responseBody

	if p4.responseCode ~= StatusCodes.UNKNOWN_ERROR then
		local responseCode = p4.responseCode

		if responseCode >= 500 then
			Unknown = HttpError.Kind.RequireExternalRetry
		else
			Unknown = HttpError.Kind.RequestFailure
			responseBody = tostring(responseCode)
		end
	end

	return HttpError.new(p4.requestUrl, Unknown, responseBody)
end

return function(p5) -- line: 78
	-- upvalues: Promise (copy), makeRequest (copy), StatusCodes (copy), HttpError (copy)
	local u24 = p5 or game

	return function(p6, p7, p8) -- line: 90
		-- upvalues: u24 (ref), Promise (copy), makeRequest (copy), StatusCodes (copy), HttpError (copy)
		assert(type(p6) == "string", "Expected url to be a string")
		assert(type(p7) == "string", "Expected requestMethod to be a string")

		local v28 = string.upper(p7)

		if p8 then
			assert(type(p8) == "table", "Expected extra args to be a table")
		end

		if v28 == "POST" then
			assert(p8.postBody, "Expected a postBody to be specified with this request")

			if not p8.contentType then
				p8.contentType = "application/json"
			end
		end

		local HttpGetAsync = nil
		local t1 = nil

		if v28 == "GET" then
			HttpGetAsync = u24.HttpGetAsync
			t1 = {
				u24,
				p6
			}
		elseif v28 == "POST" then
			HttpGetAsync = u24.HttpPostAsync
			t1 = {
				u24,
				p6,
				p8.postBody,
				p8.contentType
			}
		else
			error(string.format("Unsupported requestMethod : %s", v28 or "nil"))
		end

		return (Promise.new(function(resolve, reject) -- line: 117
			-- upvalues: makeRequest (copy), p6 (copy), HttpGetAsync (ref), t1 (ref), StatusCodes (copy), HttpError (copy)
			spawn(function() -- line: 118
				-- upvalues: makeRequest (copy), p6 (copy), HttpGetAsync (ref), t1 (ref), StatusCodes (copy), resolve (copy), HttpError (copy), reject (copy)
				local v33 = makeRequest(p6, HttpGetAsync, t1)

				if v33.responseCode == StatusCodes.OK then
					resolve(v33)

					return
				end

				local Unknown = HttpError.Kind.Unknown
				local responseBody = v33.responseBody

				if v33.responseCode ~= StatusCodes.UNKNOWN_ERROR then
					local responseCode = v33.responseCode

					if responseCode >= 500 then
						Unknown = HttpError.Kind.RequireExternalRetry
					else
						Unknown = HttpError.Kind.RequestFailure
						responseBody = tostring(responseCode)
					end
				end

				local v37 = HttpError.new(v33.requestUrl, Unknown, responseBody)

				reject(v37)
			end)
		end))
	end
end
