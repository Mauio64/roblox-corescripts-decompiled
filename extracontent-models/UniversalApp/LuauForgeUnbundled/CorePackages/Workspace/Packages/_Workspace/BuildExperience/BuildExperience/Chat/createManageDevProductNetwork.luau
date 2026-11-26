require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local CreatorApiHttp = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorApiHttp")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local v5 = FFlagBuildExperienceManageDevProduct or FFlagBuildExperienceMonetizationNativeUI

local function getHeader(headers, value)
	if headers == nil then
		return nil
	end

	for k, item in headers do
		if string.lower(k) == string.lower(value) then
			return item
		end
	end

	return nil
end

local function getCsrfToken(p2)
	return getHeader(p2.headers, "x-csrf-token")
end

local function withoutQuery(value)
	return string.match(value, "^[^?]+") or value
end

local function getRequestId(p2)
	return getHeader(p2.headers, "x-request-id") or getHeader(p2.headers, "x-correlation-id")
end

local function getResponseCode(value)
	if typeof(value) == "table" then
		return value.statusCode
	end

	return tonumber(string.match(value, "status:%s*(%d%d%d)"))
		or tonumber(string.match(value, "HTTP%s+(%d%d%d)"))
end

local function classifyStartFailure(p2): string
	local v6 = string.lower((tostring(p2)))

	if string.find(v6, "x-api-key", 1, true) then
		return "missing-open-cloud-api-key"
	end

	if string.find(v6, "accept", 1, true) and string.find(v6, "header", 1, true) then
		return "restricted-accept-header"
	end

	return "request-start-failure"
end

local function emit(p2, p3, p4)
	local log = if p2 ~= nil then p2.log else nil

	if log ~= nil then
		pcall(log, p3)
	elseif v5 and p4 then
		warn(p3)
	end
end

local function reportRequestStart(p2, data, p3)
	local v6 = (p2 == nil or p2.label == nil) and "DeveloperProduct" or p2.label
	local v7 = getHeader(data.headers, "content-type") or "<none>"

	local method = data.method
	local url = data.url
	local formatted = `[{v6}] request transport=RequestInternal method={method} url={string.match(url, "^[^?]+") or url} contentType={v7} retryCount={p3}`
	local log = if p2 ~= nil then p2.log else nil

	if log == nil then
		return
	end

	pcall(log, formatted)
end

local function reportResponse(p2, data, p3, p4, value, p5)
	local v6 = (p2 == nil or p2.label == nil) and "DeveloperProduct" or p2.label
	local v7

	if typeof(value) == "table" then
		v7 = value.statusCode
	else
		v7 = tonumber(string.match(value, "status:%s*(%d%d%d)"))
			or tonumber(string.match(value, "HTTP%s+(%d%d%d)"))
	end

	local v8

	if typeof(value) == "table" then
		v8 = getHeader(value.headers, "x-request-id") or getHeader(value.headers, "x-correlation-id")
	end

	local v9 = typeof(value) == "table" and getHeader(value.headers, "x-csrf-token") ~= nil

	local method = data.method
	local url = data.url
	local formatted = `[{v6}] response transport=RequestInternal method={method} url={string.match(url, "^[^?]+") or url} responseCode={tostring(v7)} requestId={v8 or "none"} csrfTokenPresent={tostring(v9)} retryCount={p3} willRetry={tostring(p5)} transportSuccess={tostring(p4)}`
	local v10 = not p4 or v7 == nil or v7 >= 400
	local log = if p2 ~= nil then p2.log else nil

	if log ~= nil then
		pcall(log, formatted)
	elseif v5 and v10 then
		warn(formatted)
	end
end

local function reportStartFailure(p2, p3, p4, p5)
	local v6 = (p2 == nil or p2.label == nil) and "DeveloperProduct" or p2.label

	local method = p3.method
	local url = p3.url
	local formatted = `[{v6}] request transport=RequestInternal method={method} url={string.match(url, "^[^?]+") or url} retryCount={p4} startFailure={classifyStartFailure(p5)}`
	local log = if p2 ~= nil then p2.log else nil

	if log ~= nil then
		pcall(log, formatted)
	elseif v5 then
		warn(formatted)
	end
end

local function withCsrfRetry(p2, p3)
	return {
		request = function(p4, callback)
			local flag = false
			local v6 = {}
			local function startAttempt(data, p5)
				local v7 = p3
				local v8 = (v7 == nil or v7.label == nil) and "DeveloperProduct" or v7.label
				local v9 = getHeader(data.headers, "content-type") or "<none>"

				local method = data.method
				local url = data.url
				local formatted = `[{v8}] request transport=RequestInternal method={method} url={string.match(url, "^[^?]+") or url} contentType={v9} retryCount={p5}`
				local log = if v7 ~= nil then v7.log else nil

				if log ~= nil then
					pcall(log, formatted)
				end

				local v10 = false
				local success, result = pcall(p2.request, data, function(p6, p7)
					v10 = true

					if flag then
						return
					end

					local v11

					if p6 and typeof(p7) == "table" and p5 == 0 then
						v11 = getHeader(p7.headers, "x-csrf-token")
					end

					local v12 = if p6 and typeof(p7) == "table" and p7.statusCode == 403 then v11 ~= nil else false

					reportResponse(p3, data, p5, p6, p7, v12)

					if not v12 then
						callback(p6, p7)
						return
					end

					local headers = {}

					if data.headers ~= nil then
						for k, header in data.headers do
							headers[k] = header
						end
					end

					headers["x-csrf-token"] = v11
					startAttempt({
						url = data.url,
						method = data.method,
						headers = headers,
						body = data.body,
						onMessage = data.onMessage,
						priority = data.priority
					}, p5 + 1)
				end)

				if not success then
					if not v10 then
						local v11 = p3
						local v12 = (v11 == nil or v11.label == nil) and "DeveloperProduct" or v11.label

						local method2 = data.method
						local url2 = data.url
						local formatted2 = `[{v12}] request transport=RequestInternal method={method2} url={string.match(url2, "^[^?]+") or url2} retryCount={p5} startFailure={classifyStartFailure(result)}`
						local log2 = if v11 ~= nil then v11.log else nil

						if log2 == nil then
							if v5 then
								warn(formatted2)
							end
						else
							pcall(log2, formatted2)
						end
					end

					error(result, 0)
				end

				table.insert(v6, result)
			end

			startAttempt(p4, 0)

			return function()
				if flag then
					return
				end

				flag = true

				for k, v7 in v6 do
					v7()
				end
			end
		end
	}
end

local function createManageDevProductNetwork(p2, p3)
	local withoutRestrictedAcceptHeader = CreatorApiHttp.withoutRestrictedAcceptHeader(p2)
	return {
		request = function(p4, callback)
			local flag = false
			local v6 = {}
			local function startAttempt(data, p5)
				local v7 = p3
				local v8 = (v7 == nil or v7.label == nil) and "DeveloperProduct" or v7.label
				local v9 = getHeader(data.headers, "content-type") or "<none>"

				local method = data.method
				local url = data.url
				local formatted = `[{v8}] request transport=RequestInternal method={method} url={string.match(url, "^[^?]+") or url} contentType={v9} retryCount={p5}`
				local log = if v7 ~= nil then v7.log else nil

				if log ~= nil then
					pcall(log, formatted)
				end

				local v10 = false
				local success, result = pcall(withoutRestrictedAcceptHeader.request, data, function(p6, p7)
					v10 = true

					if flag then
						return
					end

					local v11

					if p6 and typeof(p7) == "table" and p5 == 0 then
						v11 = getHeader(p7.headers, "x-csrf-token")
					end

					local v12 = if p6 and typeof(p7) == "table" and p7.statusCode == 403 then v11 ~= nil else false

					reportResponse(p3, data, p5, p6, p7, v12)

					if not v12 then
						callback(p6, p7)
						return
					end

					local headers = {}

					if data.headers ~= nil then
						for k, header in data.headers do
							headers[k] = header
						end
					end

					headers["x-csrf-token"] = v11
					startAttempt({
						url = data.url,
						method = data.method,
						headers = headers,
						body = data.body,
						onMessage = data.onMessage,
						priority = data.priority
					}, p5 + 1)
				end)

				if not success then
					if not v10 then
						local v11 = p3
						local v12 = (v11 == nil or v11.label == nil) and "DeveloperProduct" or v11.label

						local method2 = data.method
						local url2 = data.url
						local formatted2 = `[{v12}] request transport=RequestInternal method={method2} url={string.match(url2, "^[^?]+") or url2} retryCount={p5} startFailure={classifyStartFailure(result)}`
						local log2 = if v11 ~= nil then v11.log else nil

						if log2 == nil then
							if v5 then
								warn(formatted2)
							end
						else
							pcall(log2, formatted2)
						end
					end

					error(result, 0)
				end

				table.insert(v6, result)
			end

			startAttempt(p4, 0)

			return function()
				if flag then
					return
				end

				flag = true

				for k, v7 in v6 do
					v7()
				end
			end
		end
	}
end

return createManageDevProductNetwork
