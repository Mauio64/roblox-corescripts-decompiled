game:DefineFastFlag("LuaAppEnableCompactDataModelPayload", false)
game:DefineFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming", false)

local defineFastFlag = game:DefineFastFlag("LuaAppDisableDataModelStreamingInStudio", false)

local RunService = game:GetService("RunService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/SharedFlags")

local fFlagLuaAppEnableInExperienceDataModelStreamStarter = SharedFlags.FFlagLuaAppEnableInExperienceDataModelStreamStarter
local fFlagEnableWebViewStateTracker = SharedFlags.FFlagEnableWebViewStateTracker
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/Loggers").Logger:new("DataModelStreaming")
local HttpService = game:GetService("HttpService")
local getDataModelStreamAllowedHosts = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/DataModelStreaming/getDataModelStreamAllowedHosts")
local getDataModelRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/DataModelStreaming/getDataModelRoot")
local compactDataModelPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/DataModelStreaming/compactDataModelPayload")
local webViewStateTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/WebViewUtils").WebViewStateTracker

local v6 = getDataModelStreamAllowedHosts()
local count = 0
local v7 = nil

local v8 = nil
local success, result = pcall(function()
	local WebSocketService = game:GetService("WebSocketService")
	v8 = WebSocketService
end)

if not success then
	return function(p2)
		v5:error("WebSocketService is not available...")
	end
end

local function splitIntoChunks(result2, p2)
	local result3 = {}

	for i = 1, #result2, p2 do
		table.insert(result3, (string.sub(result2, i, i + p2 - 1)))
	end

	return result3
end

local function streamDataModel(object, p2, properties)
	local success2, result2 = pcall(function()
		if
			webViewStateTracker
			and fFlagEnableWebViewStateTracker
			and game:GetFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming")
			and webViewStateTracker.isOpen()
		then
			return HttpService:JSONEncode({
				type = "webview",
				webViewMetadata = webViewStateTracker.getWebViewMetadata()
			})
		end

		if game:GetFastFlag("LuaAppEnableCompactDataModelPayload") then
			return HttpService:JSONEncode(compactDataModelPayload(getDataModelRoot(properties)))
		end

		return HttpService:JSONEncode(getDataModelRoot(properties))
	end)

	if not success2 then
		v5:error(`Error encoding data model: {result2}`)
		return
	end

	v5:info(`Streaming data model, total size: {#result2}`)

	local v9 = splitIntoChunks(result2, 262144)
	local v10 = #v9

	for i, v11 in ipairs(v9) do
		object:Send(`DM_STREAM_CHUNK:{p2}:{v10}:{i}:{v11}`)
	end
end

local function getHostToTry()
	if v7 then
		return v7
	end

	count += 1

	if count > #v6 then
		return nil
	end

	return v6[count]
end

local function startDataModelStreamWsClient(p2)
	local v9

	if v7 then
		v9 = v7
	else
		count += 1
		v9 = if not (count > #v6) then v6[count] else nil
	end

	if not v9 then
		return
	end

	local v10 = v9

	if p2 then
		v10 ..= "/?source=" .. p2
	end

	local success2, result2 = pcall(function()
		return v8:CreateClient(v10)
	end)

	if not (success2 and result2) then
		v5:error("Failed to create WebSocket client")
		return
	end

	result2.Closed:Connect(function()
		startDataModelStreamWsClient(p2)
	end)

	result2.MessageReceived:Connect(function(json)
		v7 = v9

		if json:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
			print("[" .. "DataModelStreaming" .. "] uuid[" .. json .. "]")
		end

		local success3, result3 = pcall(function()
			return HttpService:JSONDecode(json)
		end)

		if success3 and result3.type == "data_model" then
			local v12 = HttpService:GenerateGUID(false)

			if result3.request_id then
				v12 = result3.request_id
			end

			streamDataModel(result2, v12, result3.properties)
		end
	end)
end

local function initDataModelStreamWsClientWithVPNGate(p2)
	local success2, result2 = pcall(function()
		return v8:CreateClient("ws://10.110.101.222:5052")
	end)

	if success2 and result2 then
		result2.MessageReceived:Connect(function(p3)
			pcall(function()
				result2:Close()
			end)
			startDataModelStreamWsClient(p2)
		end)
	end
end

local function initDataModelStreamWsClient(value)
	if defineFastFlag and RunService:IsStudio() then
		return
	end

	initDataModelStreamWsClientWithVPNGate(fFlagLuaAppEnableInExperienceDataModelStreamStarter and (value or "ua") or nil)
end

return initDataModelStreamWsClient
