local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.HttpClient)
local CreatorApiHttp = require(parent.DataHydration.CreatorApiHttp)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local v = FFlagBuildExperienceManageDevProduct or FFlagBuildExperienceMonetizationNativeUI

local function getHeader(headers, value: string)
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

local function getCsrfToken(p) -- 2 equivalent calls inferred from this helper
	return getHeader(p.headers, "x-csrf-token")
end

local function withoutQuery(url: string) -- 3 equivalent calls inferred from this helper
	return string.match(url, "^[^?]+") or url
end

local function getRequestId(value) -- 1 equivalent call inferred from this helper
	return getHeader(value.headers, "x-request-id") or getHeader(value.headers, "x-correlation-id")
end

local function getResponseCode(value) -- 1 equivalent call inferred from this helper
	if typeof(value) == "table" then
		return value.statusCode
	end

	return tonumber(string.match(value, "status:%s*(%d%d%d)")) or tonumber(string.match(value, "HTTP%s+(%d%d%d)"))
end

local function classifyStartFailure(p): string
	local v2 = string.lower((tostring(p)))

	if string.find(v2, "x-api-key", 1, true) then
		return "missing-open-cloud-api-key"
	end

	if string.find(v2, "accept", 1, true) and string.find(v2, "header", 1, true) then
		return "restricted-accept-header"
	end

	return "request-start-failure"
end

local function emit(p, p2: string, flag: boolean?) -- 3 equivalent calls inferred from this helper
	local log

	if p ~= nil then
		log = p.log
	end

	if log ~= nil then
		pcall(log, p2)
	elseif v and flag then
		warn(p2)
	end
end

local function reportRequestStart(p, data, p2: number) -- 1 equivalent call inferred from this helper
	local v2 = (p == nil or p.label == nil) and "DeveloperProduct" or p.label
	local v3 = getHeader(data.headers, "content-type") or "<none>"

	emit( -- inferred equivalent call
		p,
		`[{v2}] request transport=RequestInternal method={data.method} url={withoutQuery(data.url)} contentType={v3} retryCount={p2}`,
		false
	)
end

local function reportResponse(p, data, p2: number, flag: boolean, value, flag2: boolean)
	local v2 = (p == nil or p.label == nil) and "DeveloperProduct" or p.label
	local responseCode = getResponseCode(value) -- inferred equivalent call
	local v3

	if typeof(value) == "table" then
		v3 = getRequestId(value) -- inferred equivalent call
	end

	local v4

	if typeof(value) == "table" then
		v4 = getCsrfToken(value) ~= nil -- inferred equivalent call
	else
		v4 = false
	end

	emit( -- inferred equivalent call
		p,
		`[{v2}] response transport=RequestInternal method={data.method} url={withoutQuery(data.url)} responseCode={tostring(responseCode)} requestId={v3 or "none"} csrfTokenPresent={tostring(v4)} retryCount={p2} willRetry={tostring(flag2)} transportSuccess={tostring(flag)}`,
		not flag or responseCode == nil or responseCode >= 400
	)
end

local function reportStartFailure(p, data, p2: number, result) -- 1 equivalent call inferred from this helper
	emit( -- inferred equivalent call
		p,
		`[{(p == nil or p.label == nil) and "DeveloperProduct" or p.label}] request transport=RequestInternal method={data.method} url={withoutQuery(data.url)} retryCount={p2} startFailure={classifyStartFailure(result)}`,
		true
	)
end

local function withCsrfRetry(p, p2) -- 1 equivalent call inferred from this helper
	return {
		request = function(p3, callback)
			local flag = false
			local v2 = {}
			local function startAttempt(data, p4: number)
				reportRequestStart(p2, data, p4) -- inferred equivalent call
				local v3 = false
				local success, result = pcall(p.request, data, function(p5, p6)
					v3 = true

					if flag then
						return
					end

					local xcsrftoken

					if p5 and typeof(p6) == "table" and p4 == 0 then
						xcsrftoken = getCsrfToken(p6) -- inferred equivalent call
					end

					local v4

					if p5 and typeof(p6) == "table" and p6.statusCode == 403 then
						v4 = xcsrftoken ~= nil
					else
						v4 = false
					end

					reportResponse(p2, data, p4, p5, p6, v4)

					if not v4 then
						callback(p5, p6)
						return
					end

					local headers = {}

					if data.headers ~= nil then
						for k, header in data.headers do
							headers[k] = header
						end
					end

					headers["x-csrf-token"] = xcsrftoken
					startAttempt({
						url = data.url,
						method = data.method,
						headers = headers,
						body = data.body,
						onMessage = data.onMessage,
						priority = data.priority
					}, p4 + 1)
				end)

				if not success then
					if not v3 then
						reportStartFailure(p2, data, p4, result) -- inferred equivalent call
					end

					error(result, 0)
				end

				table.insert(v2, result)
			end

			startAttempt(p3, 0)

			return function()
				if flag then
					return
				end

				flag = true

				for _, v3 in v2 do
					v3()
				end
			end
		end
	}
end

local function createManageDevProductNetwork(p, p2)
	return withCsrfRetry(CreatorApiHttp.withoutRestrictedAcceptHeader(p), p2) -- inferred equivalent call
end

return createManageDevProductNetwork
