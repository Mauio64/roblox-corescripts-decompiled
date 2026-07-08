local Parent = script:FindFirstAncestor("ScreenTime").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Logging = require(Parent.AppCommonLib).Logging
local ArgCheck = require(Parent.ArgCheck)
local _ = {
	GET_INSTRUCTIONS = "timed-entertainment-allowance/v1/instructions",
	REPORT_EXECUTION = "timed-entertainment-allowance/v1/reportExecute"
}
local t1 = {
	GET_INSTRUCTIONS = {
		errorCode = "number",
		instructions = "table"
	},
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
	REPORT_EXECUTION = {
		errorCode = "number"
	}
}
local v8 = UrlBuilder.new({
	path = "timed-entertainment-allowance/v1/instructions",
	base = Url.APIS_URL
})()
local v9 = UrlBuilder.new({
	path = "timed-entertainment-allowance/v1/reportExecute",
	base = Url.APIS_URL
})()
local v10 = UrlBuilder.new({
	path = "v1/logout",
	base = Url.AUTH_URL
})()

local function checkFormat(p1, p2) -- line: 60
	for k, v in pairs(p1) do
		assert(p2[k] ~= nil, "Missing key")
		assert(v == type(p2[k]), "Wrong type")
	end
end

return {
	httpService = nil,
	new = function(p3, p4) -- line: 77
		-- upvalues: ArgCheck (copy)
		ArgCheck.isNotNil(p4, "httpService")

		local t2 = {
			httpService = p4
		}

		setmetatable(t2, p3)
		p3.__index = p3

		return t2
	end,
	getInstructions = function(p5, p6) -- line: 99
		-- upvalues: ArgCheck (copy), v8 (copy), checkFormat (copy), t1 (copy), Logging (copy)
		ArgCheck.isNotNil(p5.httpService, "httpService")
		ArgCheck.isNotNil(p6, "callback")
		p5.httpService:RequestInternal({
			Method = "GET",
			Url = v8
		}):Start(function(p7, p8) -- line: 106
			-- upvalues: p5 (copy), checkFormat (copy), t1 (copy), Logging (copy), v8 (copy), p6 (copy)
			local v31 = false
			local t3 = {}
			local v33, s1

			if not p7 then
				v33 = false
				s1 = "Connection error"
			elseif p8.StatusCode == 401 then
				v33 = false
				v31 = true
				s1 = "Unauthorized"
			elseif p8.StatusCode < 200 or p8.StatusCode >= 400 then
				v33 = false
				s1 = "Status code: " .. p8.StatusCode
			else
				v33, s1 = pcall(function() -- line: 123
					-- upvalues: p5 (copy), p8 (copy), checkFormat (copy), t1 (copy), t3 (ref)
					local data = p5.httpService:JSONDecode(p8.Body)

					checkFormat(t1.GET_INSTRUCTIONS, data)
					assert(data.errorCode == 0, "Error code is not 0")

					for _, v in ipairs(data.instructions) do
						checkFormat(t1.INSTRUCTION, v)
					end

					t3 = data.instructions
				end)
			end

			if not v33 then
				Logging.warn("HttpRequests" .. " getInstructions failed: " .. v8 .. ", " .. s1)
			end

			p6(v33, v31, t3)
		end)
	end,
	reportExecution = function(p9, p10, p11, p12) -- line: 148
		-- upvalues: ArgCheck (copy), v9 (copy), checkFormat (copy), t1 (copy), Logging (copy)
		ArgCheck.isNotNil(p9.httpService, "httpService")

		local v25 = os.date("%Y-%m-%dT%H:%M:%SZ")
		local json = p9.httpService:JSONEncode({
			instructionName = p10,
			serialId = p11,
			execTime = v25
		})

		p9.httpService:RequestInternal({
			Method = "POST",
			Url = v9,
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = json
		}):Start(function(p13, p14) -- line: 165
			-- upvalues: p9 (copy), checkFormat (copy), t1 (copy), Logging (copy), v9 (copy), p12 (copy)
			local v37, s2

			if not p13 then
				v37 = false
				s2 = "Connection error"
			elseif p14.StatusCode < 200 and p14.StatusCode >= 400 then
				v37 = false
				s2 = "Status code: " .. p14.StatusCode
			else
				v37, s2 = pcall(function() -- line: 176
					-- upvalues: p9 (copy), p14 (copy), checkFormat (copy), t1 (copy)
					local data = p9.httpService:JSONDecode(p14.Body)

					checkFormat(t1.REPORT_EXECUTION, data)
					assert(data.errorCode == 0, "Error code is not 0")
				end)
			end

			if not v37 then
				Logging.warn("HttpRequests" .. " reportExecution failed: " .. v9 .. ", " .. s2)
			end

			if p12 ~= nil then
				p12(v37)
			end
		end)
	end,
	logout = function(p15) -- line: 191
		-- upvalues: ArgCheck (copy), v10 (copy)
		ArgCheck.isNotNil(p15.httpService, "httpService")

		local v28 = p15.httpService:RequestInternal({
			Method = "POST",
			Body = "",
			Url = v10,
			Headers = {
				["Content-Type"] = "application/json"
			}
		})

		pcall(function() -- line: 201
			-- upvalues: v28 (copy)
			v28:Start(function(_, _) -- line: 202
			end)
		end)
	end
}
