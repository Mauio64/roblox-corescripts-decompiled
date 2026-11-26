local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/UrlBuilder").UrlBuilder
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/AppCommonLib").Logging
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ScreenTime/ArgCheck")

local v5 = {
	GET_INSTRUCTIONS = "timed-entertainment-allowance/v1/instructions",
	REPORT_EXECUTION = "timed-entertainment-allowance/v1/reportExecute"
}

local v6 = {
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

local v7 = urlBuilder.new({
	base = url.APIS_URL,
	path = "timed-entertainment-allowance/v1/instructions"
})()

local v8 = urlBuilder.new({
	base = url.APIS_URL,
	path = "timed-entertainment-allowance/v1/reportExecute"
})()

local v9 = urlBuilder.new({ base = url.AUTH_URL, path = "v1/logout" })()

local function checkFormat(items, p2)
	for k, item in pairs(items) do
		assert(p2[k] ~= nil, "Missing key")
		assert(type(p2[k]) == item, "Wrong type")
	end
end

local v10 = { httpService = nil }

function v10:new(p3)
	ArgCheck.isNotNil(p3, "httpService")
	local v11 = { httpService = p3 }

	setmetatable(v11, self)
	self.__index = self
	return v11
end

function v10:getInstructions(callback)
	ArgCheck.isNotNil(self.httpService, "httpService")
	ArgCheck.isNotNil(callback, "callback")
	self.httpService:RequestInternal({ Url = v7, Method = "GET" }):Start(function(p3, p4)
		local v11 = false
		local v12 = {}
		local success, result

		if p3 then
			if p4.StatusCode == 401 then
				success = false
				v11 = true
				result = "Unauthorized"
			elseif p4.StatusCode < 200 or p4.StatusCode >= 400 then
				result = "Status code: " .. p4.StatusCode
				success = false
			else
				success, result = pcall(function()
					local jsonDecode = self.httpService:JSONDecode(p4.Body)
					checkFormat(v6.GET_INSTRUCTIONS, jsonDecode)
					assert(jsonDecode.errorCode == 0, "Error code is not 0")

					for i, instruction in ipairs(jsonDecode.instructions) do
						checkFormat(v6.INSTRUCTION, instruction)
					end

					v12 = jsonDecode.instructions
				end)
			end
		else
			success = false
			result = "Connection error"
		end

		if not success then
			logging.warn("HttpRequests" .. " getInstructions failed: " .. v7 .. ", " .. result)
		end

		callback(success, v11, v12)
	end)
end

function v10:reportExecution(p3, p4, callback)
	ArgCheck.isNotNil(self.httpService, "httpService")

	local v11 = os.date("%Y-%m-%dT%H:%M:%SZ")
	local jsonEncode = self.httpService:JSONEncode({
		instructionName = p3,
		serialId = p4,
		execTime = v11
	})

	self.httpService:RequestInternal({
		Url = v8,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonEncode
	}):Start(function(p5, p6)
		local result, success

		if p5 then
			if p6.StatusCode < 200 and p6.StatusCode >= 400 then
				result = "Status code: " .. p6.StatusCode
				success = false
			else
				success, result = pcall(function()
					local jsonDecode = self.httpService:JSONDecode(p6.Body)
					checkFormat(v6.REPORT_EXECUTION, jsonDecode)
					assert(jsonDecode.errorCode == 0, "Error code is not 0")
				end)
			end
		else
			success = false
			result = "Connection error"
		end

		if not success then
			logging.warn("HttpRequests" .. " reportExecution failed: " .. v8 .. ", " .. result)
		end

		if callback ~= nil then
			callback(success)
		end
	end)
end

function v10.logout(p2)
	ArgCheck.isNotNil(p2.httpService, "httpService")
	local internal = p2.httpService:RequestInternal({
		Url = v9,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = ""
	})

	pcall(function()
		internal:Start(function(p3, p4) end)
	end)
end

return v10
