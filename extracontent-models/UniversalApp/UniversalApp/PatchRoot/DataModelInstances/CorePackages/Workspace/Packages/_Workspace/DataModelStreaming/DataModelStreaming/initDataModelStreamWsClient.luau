game:DefineFastFlag("LuaAppEnableCompactDataModelPayload", false)
game:DefineFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming", false)

local v1 = game:DefineFastFlag("LuaAppDisableDataModelStreamingInStudio", false)
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent.Parent
local v4 = require(ParentParent.Loggers).Logger:new("DataModelStreaming")
local HttpService = game:GetService("HttpService")
local getDataModelStreamAllowedHosts = require(script.Parent.getDataModelStreamAllowedHosts)
local getDataModelRoot = require(script.Parent.getDataModelRoot)
local compactDataModelPayload = require(script.Parent.compactDataModelPayload)
local WebViewStateTracker = require(ParentParent.WebViewUtils).WebViewStateTracker
local FFlagEnableWebViewStateTracker = require(ParentParent.SharedFlags).FFlagEnableWebViewStateTracker
local v11 = getDataModelStreamAllowedHosts()
local n1 = 0
local u13 = nil
local WebSocketService = nil
local ok, _ = pcall(function() -- line: 26
	-- upvalues: WebSocketService (ref)
	WebSocketService = game:GetService("WebSocketService")
end)

if not ok then
	return function() -- line: 31
		-- upvalues: v4 (copy)
		v4:error("WebSocketService is not available...")
	end
end

local function splitIntoChunks(p1, p2) -- line: 36
	local t1 = {}

	for i = 1, #p1, p2 do
		table.insert(t1, (string.sub(p1, i, i + p2 - 1)))
	end

	return t1
end
local function streamDataModel(p3, p4, p5) -- line: 44
	-- upvalues: FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), HttpService (copy), compactDataModelPayload (copy), getDataModelRoot (copy), v4 (copy), splitIntoChunks (copy)
	local ok2, result = pcall(function() -- line: 45
		-- upvalues: FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), HttpService (copy), compactDataModelPayload (copy), getDataModelRoot (copy), p5 (copy)
		if FFlagEnableWebViewStateTracker and (game:GetFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming") and WebViewStateTracker.isOpen()) then
			return HttpService:JSONEncode({
				type = "webview",
				webViewMetadata = WebViewStateTracker.getWebViewMetadata()
			})
		end

		if game:GetFastFlag("LuaAppEnableCompactDataModelPayload") then
			return HttpService:JSONEncode(compactDataModelPayload(getDataModelRoot(p5)))
		end

		return HttpService:JSONEncode(getDataModelRoot(p5))
	end)

	if not ok2 then
		v4:error(`Error encoding data model: { result }`)

		return
	end

	v4:info(`Streaming data model, total size: { #result }`)

	local v32 = splitIntoChunks(result, 262144)
	local v33 = #v32

	for i, v in ipairs(v32) do
		p3:Send(`DM_STREAM_CHUNK:{ p4 }:{ v33 }:{ i }:{ v }`)
	end
end
local function getHostToTry() -- line: 77
	-- upvalues: u13 (ref), n1 (ref), v11 (copy)
	if u13 then
		return u13
	end

	n1 += 1

	if n1 > #v11 then
		return nil
	end

	return v11[n1]
end
local function startDataModelStreamWsClient() -- line: 90
	-- upvalues: u13 (ref), n1 (ref), v11 (copy), WebSocketService (ref), v4 (copy), startDataModelStreamWsClient (copy), HttpService (copy), streamDataModel (copy)
	local v36

	if u13 then
		v36 = u13
	else
		n1 += 1
		v36 = if not (n1 > #v11) then v11[n1] else nil
	end

	local v37 = v36

	if not v37 then
		return
	end

	local ok3, result = pcall(function() -- line: 98
		-- upvalues: WebSocketService (ref), v37 (copy)
		return WebSocketService:CreateClient(v37)
	end)

	if not ok3 or not result then
		v4:error("Failed to create WebSocket client")

		return
	end

	local u40 = result

	u40.Closed:Connect(function() -- line: 107
		-- upvalues: startDataModelStreamWsClient (copy)
		startDataModelStreamWsClient()
	end)
	u40.MessageReceived:Connect(function(p6) -- line: 111
		-- upvalues: u13 (ref), v37 (copy), HttpService (copy), streamDataModel (copy), u40 (ref)
		u13 = v37

		if p6:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
			print("[" .. "DataModelStreaming" .. "] uuid[" .. p6 .. "]")
		end

		local ok4, result2 = pcall(function() -- line: 122
			-- upvalues: HttpService (copy), p6 (copy)
			return HttpService:JSONDecode(p6)
		end)

		if ok4 and result2.type == "data_model" then
			local guid = HttpService:GenerateGUID(false)

			if result2.request_id then
				guid = result2.request_id
			end

			streamDataModel(u40, guid, result2.properties)
		end
	end)
end
local function initDataModelStreamWsClientWithVPNGate() -- line: 136
	-- upvalues: WebSocketService (ref), startDataModelStreamWsClient (copy)
	local ok5, result = pcall(function() -- line: 137
		-- upvalues: WebSocketService (ref)
		return WebSocketService:CreateClient("ws://10.110.101.222:5052")
	end)

	if not ok5 or not result then
		return
	end

	result.MessageReceived:Connect(function(_) -- line: 144
		-- upvalues: result (copy), startDataModelStreamWsClient (copy)
		pcall(function() -- line: 145
			-- upvalues: result (copy)
			result:Close()
		end)
		startDataModelStreamWsClient()
	end)
end
local function initDataModelStreamWsClient() -- line: 152
	-- upvalues: v1 (copy), RunService (copy), initDataModelStreamWsClientWithVPNGate (copy)
	if v1 and RunService:IsStudio() then
		return
	end

	initDataModelStreamWsClientWithVPNGate()
end

return initDataModelStreamWsClient
