game:DefineFastFlag("LuaAppEnableCompactDataModelPayload", false)
game:DefineFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming", false)

local v1 = game:DefineFastFlag("LuaAppDisableDataModelStreamingInStudio", false)
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local FFlagLuaAppEnableInExperienceDataModelStreamStarter = SharedFlags.FFlagLuaAppEnableInExperienceDataModelStreamStarter
local FFlagEnableWebViewStateTracker = SharedFlags.FFlagEnableWebViewStateTracker
local v7 = require(ParentParent.Loggers).Logger:new("DataModelStreaming")
local HttpService = game:GetService("HttpService")
local getDataModelStreamAllowedHosts = require(script.Parent.getDataModelStreamAllowedHosts)
local getDataModelRoot = require(script.Parent.getDataModelRoot)
local compactDataModelPayload = require(script.Parent.compactDataModelPayload)
local WebViewStateTracker = require(ParentParent.WebViewUtils).WebViewStateTracker
local v13 = getDataModelStreamAllowedHosts()
local n1 = 0
local u15 = nil
local WebSocketService = nil
local ok, _ = pcall(function() -- line: 30
	-- upvalues: WebSocketService (ref)
	WebSocketService = game:GetService("WebSocketService")
end)

if not ok then
	return function(_: string?) -- line: 35
		-- upvalues: v7 (copy)
		v7:error("WebSocketService is not available...")
	end
end

local function splitIntoChunks(p1, p2) -- line: 40
	local t1 = {}

	for i = 1, #p1, p2 do
		table.insert(t1, (string.sub(p1, i, i + p2 - 1)))
	end

	return t1
end
local function streamDataModel(p3, p4, p5) -- line: 48
	-- upvalues: WebViewStateTracker (copy), FFlagEnableWebViewStateTracker (copy), HttpService (copy), compactDataModelPayload (copy), getDataModelRoot (copy), v7 (copy), splitIntoChunks (copy)
	local ok2, result = pcall(function() -- line: 49
		-- upvalues: WebViewStateTracker (copy), FFlagEnableWebViewStateTracker (copy), HttpService (copy), compactDataModelPayload (copy), getDataModelRoot (copy), p5 (copy)
		if WebViewStateTracker and (FFlagEnableWebViewStateTracker and game:GetFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming") and WebViewStateTracker.isOpen()) then
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
		v7:error(`Error encoding data model: { result }`)

		return
	end

	v7:info(`Streaming data model, total size: { #result }`)

	local v35 = splitIntoChunks(result, 262144)
	local v36 = #v35

	for i, v in ipairs(v35) do
		p3:Send(`DM_STREAM_CHUNK:{ p4 }:{ v36 }:{ i }:{ v }`)
	end
end
local function getHostToTry() -- line: 83
	-- upvalues: u15 (ref), n1 (ref), v13 (copy)
	if u15 then
		return u15
	end

	n1 += 1

	if n1 > #v13 then
		return nil
	end

	return v13[n1]
end
local function startDataModelStreamWsClient(s2: string?) -- line: 96
	-- upvalues: u15 (ref), n1 (ref), v13 (copy), WebSocketService (ref), v7 (copy), startDataModelStreamWsClient (copy), HttpService (copy), streamDataModel (copy)
	local v40

	if u15 then
		v40 = u15
	else
		n1 += 1
		v40 = if not (n1 > #v13) then v13[n1] else nil
	end

	local v41 = v40

	if not v41 then
		return
	end

	local u42 = v41

	if s2 then
		u42 ..= "/?source=" .. s2
	end

	local ok3, result = pcall(function() -- line: 109
		-- upvalues: WebSocketService (ref), u42 (ref)
		return WebSocketService:CreateClient(u42)
	end)

	if not ok3 or not result then
		v7:error("Failed to create WebSocket client")

		return
	end

	local u45 = result

	u45.Closed:Connect(function() -- line: 118
		-- upvalues: startDataModelStreamWsClient (copy), s2 (copy)
		startDataModelStreamWsClient(s2)
	end)
	u45.MessageReceived:Connect(function(p6) -- line: 122
		-- upvalues: u15 (ref), v41 (copy), HttpService (copy), streamDataModel (copy), u45 (ref)
		u15 = v41

		if p6:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
			print("[" .. "DataModelStreaming" .. "] uuid[" .. p6 .. "]")
		end

		local ok4, result2 = pcall(function() -- line: 133
			-- upvalues: HttpService (copy), p6 (copy)
			return HttpService:JSONDecode(p6)
		end)

		if ok4 and result2.type == "data_model" then
			local guid = HttpService:GenerateGUID(false)

			if result2.request_id then
				guid = result2.request_id
			end

			streamDataModel(u45, guid, result2.properties)
		end
	end)
end
local function initDataModelStreamWsClientWithVPNGate(s3: string?) -- line: 147
	-- upvalues: WebSocketService (ref), startDataModelStreamWsClient (copy)
	local ok5, result = pcall(function() -- line: 148
		-- upvalues: WebSocketService (ref)
		return WebSocketService:CreateClient("ws://10.110.101.222:5052")
	end)

	if not ok5 or not result then
		return
	end

	result.MessageReceived:Connect(function(_) -- line: 155
		-- upvalues: result (copy), startDataModelStreamWsClient (copy), s3 (copy)
		pcall(function() -- line: 156
			-- upvalues: result (copy)
			result:Close()
		end)
		startDataModelStreamWsClient(s3)
	end)
end
local function initDataModelStreamWsClient(s4: string?) -- line: 163
	-- upvalues: FFlagLuaAppEnableInExperienceDataModelStreamStarter (copy), v1 (copy), RunService (copy), initDataModelStreamWsClientWithVPNGate (copy)
	local v50 = if not FFlagLuaAppEnableInExperienceDataModelStreamStarter then nil else s4 or "ua"

	if v1 and RunService:IsStudio() then
		return
	end

	initDataModelStreamWsClientWithVPNGate(v50)
end

return initDataModelStreamWsClient
