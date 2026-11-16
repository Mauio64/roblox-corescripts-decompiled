game:DefineFastFlag("LuaAppEnableCompactDataModelPayload", false)
game:DefineFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming", false)

local defineFastFlag = game:DefineFastFlag("LuaAppDisableDataModelStreamingInStudio", false)

local RunService = game:GetService("RunService")

local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)

local FFlagLuaAppEnableInExperienceDataModelStreamStarter = SharedFlags.FFlagLuaAppEnableInExperienceDataModelStreamStarter
local FFlagEnableWebViewStateTracker = SharedFlags.FFlagEnableWebViewStateTracker
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new("DataModelStreaming")
local HttpService = game:GetService("HttpService")
local getDataModelStreamAllowedHosts = require(script.Parent.getDataModelStreamAllowedHosts)
local getDataModelRoot = require(script.Parent.getDataModelRoot)
local compactDataModelPayload = require(script.Parent.compactDataModelPayload)
local WebViewUtils = require(parent.WebViewUtils)
local WebViewStateTracker = WebViewUtils.WebViewStateTracker

local dataModelStreamAllowedHosts = getDataModelStreamAllowedHosts()
local count = 0
local v2 = nil

local v3 = nil
local success, _ = pcall(function()
	local WebSocketService = game:GetService("WebSocketService")
	v3 = WebSocketService
end)

if not success then
	return function(_: string?)
		v:error("WebSocketService is not available...")
	end
end

local function splitIntoChunks(result, p)
	local result2 = {}

	for i = 1, #result, p do
		table.insert(result2, (string.sub(result, i, i + p - 1)))
	end

	return result2
end

local function streamDataModel(object, p, properties)
	local success2, result = pcall(function()
		if
			WebViewStateTracker
			and FFlagEnableWebViewStateTracker
			and game:GetFastFlag("LuaAppEnableWebViewStateTrackerInDataModelStreaming")
			and WebViewStateTracker.isOpen()
		then
			return HttpService:JSONEncode({
				type = "webview",
				webViewMetadata = WebViewStateTracker.getWebViewMetadata()
			})
		end

		if game:GetFastFlag("LuaAppEnableCompactDataModelPayload") then
			return HttpService:JSONEncode(compactDataModelPayload(getDataModelRoot(properties)))
		end

		return HttpService:JSONEncode(getDataModelRoot(properties))
	end)

	if not success2 then
		v:error(`Error encoding data model: {result}`)
		return
	end

	v:info(`Streaming data model, total size: {#result}`)

	local v4 = splitIntoChunks(result, 262144)
	local v5 = #v4

	for i, v6 in ipairs(v4) do
		object:Send(`DM_STREAM_CHUNK:{p}:{v5}:{i}:{v6}`)
	end
end

local function getHostToTry() -- 1 equivalent call inferred from this helper
	if v2 then
		return v2
	end

	count += 1

	if count > #dataModelStreamAllowedHosts then
		return nil
	end

	return dataModelStreamAllowedHosts[count]
end

local function startDataModelStreamWsClient(p: string?)
	local hostToTry = getHostToTry() -- inferred equivalent call

	if not hostToTry then
		return
	end

	local v4 = hostToTry

	if p then
		v4 ..= "/?source=" .. p
	end

	local success2, result = pcall(function()
		return v3:CreateClient(v4)
	end)

	if not (success2 and result) then
		v:error("Failed to create WebSocket client")
		return
	end

	result.Closed:Connect(function()
		startDataModelStreamWsClient(p)
	end)

	result.MessageReceived:Connect(function(json)
		v2 = hostToTry

		if json:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
			print("[" .. "DataModelStreaming" .. "] uuid[" .. json .. "]")
		end

		local success3, result2 = pcall(function()
			return HttpService:JSONDecode(json)
		end)

		if success3 and result2.type == "data_model" then
			local v5 = HttpService:GenerateGUID(false)

			if result2.request_id then
				v5 = result2.request_id
			end

			streamDataModel(result, v5, result2.properties)
		end
	end)
end

local function initDataModelStreamWsClientWithVPNGate(p: string?)
	local success2, result = pcall(function()
		return v3:CreateClient("ws://10.110.101.222:5052")
	end)

	if success2 and result then
		result.MessageReceived:Connect(function(_)
			pcall(function()
				result:Close()
			end)
			startDataModelStreamWsClient(p)
		end)
	end
end

local function initDataModelStreamWsClient(value: string?)
	if defineFastFlag and RunService:IsStudio() then
		return
	end

	initDataModelStreamWsClientWithVPNGate(FFlagLuaAppEnableInExperienceDataModelStreamStarter and (value or "ua") or nil)
end

return initDataModelStreamWsClient
