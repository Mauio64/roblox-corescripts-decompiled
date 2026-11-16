local parent = script:FindFirstAncestor("ScreenTime").Parent
local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local ArgCheck = require(parent.ArgCheck)

local _ = {
	GET_INSTRUCTIONS = "timed-entertainment-allowance/v1/instructions",
	REPORT_EXECUTION = "timed-entertainment-allowance/v1/reportExecute"
}

local v = {
	GET_INSTRUCTIONS = { errorCode = "number", instructions = "table" },
	INSTRUCTION = {
		type = "number",
		instructionName = "string",
		serialId = "string",
		title = "string",
		message = "string",
		url = "string",
		modalType = "number",
		data = "string"
	},
	REPORT_EXECUTION = { errorCode = "number" }
}

local url = urlBuilder.new({
	base = Url.APIS_URL,
	path = "timed-entertainment-allowance/v1/instructions"
})()

local url2 = urlBuilder.new({
	base = Url.APIS_URL,
	path = "timed-entertainment-allowance/v1/reportExecute"
})()

local url3 = urlBuilder.new({ base = Url.AUTH_URL, path = "v1/logout" })()

local function checkFormat(items, p)
	for k, item in pairs(items) do
		assert(p[k] ~= nil, "Missing key")
		assert(type(p[k]) == item, "Wrong type")
	end
end

local HttpRequests = { httpService = nil }

function HttpRequests:new(httpService)
	ArgCheck.isNotNil(httpService, "httpService")
	local v2 = { httpService = httpService }

	setmetatable(v2, self)
	self.__index = self
	return v2
end

function HttpRequests.getInstructions(p, callback)
	ArgCheck.isNotNil(p.httpService, "httpService")
	ArgCheck.isNotNil(callback, "callback")
	p.httpService:RequestInternal({ Url = url, Method = "GET" }):Start(function(p2, p3)
		local v2 = false
		local v3 = {}
		local success, result

		if p2 then
			if p3.StatusCode == 401 then
				success = false
				v2 = true
				result = "Unauthorized"
			elseif p3.StatusCode < 200 or p3.StatusCode >= 400 then
				result = "Status code: " .. p3.StatusCode
				success = false
			else
				success, result = pcall(function()
					local jsonDecode = p.httpService:JSONDecode(p3.Body)
					checkFormat(v.GET_INSTRUCTIONS, jsonDecode)
					assert(jsonDecode.errorCode == 0, "Error code is not 0")

					for _, instruction in ipairs(jsonDecode.instructions) do
						checkFormat(v.INSTRUCTION, instruction)
					end

					v3 = jsonDecode.instructions
				end)
			end
		else
			success = false
			result = "Connection error"
		end

		if not success then
			Logging.warn("HttpRequests" .. " getInstructions failed: " .. url .. ", " .. result)
		end

		callback(success, v2, v3)
	end)
end

function HttpRequests.reportExecution(p, instructionName, serialId, callback)
	ArgCheck.isNotNil(p.httpService, "httpService")

	local execTime = os.date("%Y-%m-%dT%H:%M:%SZ")
	local jsonEncode = p.httpService:JSONEncode({
		instructionName = instructionName,
		serialId = serialId,
		execTime = execTime
	})

	p.httpService:RequestInternal({
		Url = url2,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonEncode
	}):Start(function(p2, p3)
		local result, success

		if p2 then
			if p3.StatusCode < 200 and p3.StatusCode >= 400 then
				result = "Status code: " .. p3.StatusCode
				success = false
			else
				success, result = pcall(function()
					local jsonDecode = p.httpService:JSONDecode(p3.Body)
					checkFormat(v.REPORT_EXECUTION, jsonDecode)
					assert(jsonDecode.errorCode == 0, "Error code is not 0")
				end)
			end
		else
			success = false
			result = "Connection error"
		end

		if not success then
			Logging.warn("HttpRequests" .. " reportExecution failed: " .. url2 .. ", " .. result)
		end

		if callback ~= nil then
			callback(success)
		end
	end)
end

function HttpRequests.logout(p)
	ArgCheck.isNotNil(p.httpService, "httpService")
	local internal = p.httpService:RequestInternal({
		Url = url3,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = ""
	})

	pcall(function()
		internal:Start(function(_, _) end)
	end)
end

return HttpRequests
