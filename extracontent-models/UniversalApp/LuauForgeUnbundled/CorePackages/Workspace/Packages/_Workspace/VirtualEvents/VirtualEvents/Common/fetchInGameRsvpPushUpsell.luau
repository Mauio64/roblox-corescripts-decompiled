local HttpService = game:GetService("HttpService")

local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/NotificationsUpsell")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Promise")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder")
local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/InGameRsvpPushUpsellTypes")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/logger")
local FIntInGameRsvpPushUpsellTimeoutMs = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FIntInGameRsvpPushUpsellTimeoutMs")

local v5 = {
	OsPrompt = "PushNotificationsUpsellInGameOsPrompt",
	Settings = "PushNotificationsUpsellInGameSettings"
}

local v6 = { "title", "body", "confirm" }

local v7 = {}
v7.PromptType = v5

function v7._sendRequest(p2, callback)
	HttpService:RequestInternal(p2):Start(function(p3, p4)
		callback(p4)
	end)
end
function v7._buildClientAttributes()
	return NotificationsUpsell.PushPermissionClientAttributes.build()
end

local function getPromptsUrl(items)
	return `{urlBuilder.new({
		base = urlBase.APIS,
		path = "modals-api/v1/prompts",
		query = { entryPoint = "InExperienceEventRsvpGoing", promptStyle = "Modal" }
	})()}&clientAttributes={HttpService:UrlEncode(HttpService:JSONEncode(items))}`
end

local function asTable(p2)
	if type(p2) == "table" then
		return p2
	end

	return nil
end

local function readTranslations(customPrompt)
	local translations = {}

	if type(customPrompt) ~= "table" then
		customPrompt = nil
	end

	local translations2 = if customPrompt then customPrompt.translations or customPrompt.Translations else nil

	if type(translations2) ~= "table" then
		translations2 = nil
	end

	if not translations2 then
		return translations
	end

	for k, translation in translations2 do
		if not (type(k) == "string" and type(translation) == "string") then
			continue
		end

		translations[k] = translation
	end

	return translations
end

local function parsePrompt(result)
	if type(result) ~= "table" then
		result = nil
	end

	local customPrompts = if result then result.customPrompts else nil

	if type(customPrompts) ~= "table" then
		customPrompts = nil
	end

	if customPrompts == nil then
		return nil
	end

	for k, v8 in { "OsPrompt", "Settings" } do
		local v9 = v5[v8]
		local customPrompt = customPrompts[v9]

		if customPrompt ~= nil then
			local v10 = readTranslations(customPrompt)

			for k2, v11 in v6 do
				if v10[v11] == nil or v10[v11] == "" then
					logger:warning("In-game RSVP push upsell {} has no {} translation", v9, v11)
					return nil
				end
			end

			return { promptType = v9, path = v8, translations = v10 }
		end
	end

	return nil
end

local function request(p2, p3, p4)
	return Promise.new(function(callback, callback2)
		v7._sendRequest({
			Url = p2,
			Method = p3,
			Headers = p3 == "POST" and { ["Content-Type"] = "application/json" } or {
				Accept = "application/json"
			},
			Body = p4
		}, function(p5)
			local statusCode = p5.StatusCode
			local v8

			if p3 == "POST" then
				v8 = typeof(statusCode) == "number" and statusCode >= 200 and statusCode < 300
			else
				v8 = statusCode == 200
			end

			if v8 then
				callback(p5)
			else
				callback2(`{p3} {p2} failed: {tostring(p5.StatusCode)}`)
			end
		end)
	end)
end

function v7.fetch()
	return Promise.new(function(callback)
		local v8 = false
		local function settle(p2)
			if not v8 then
				v8 = true
				callback(p2)
			end
		end

		task.delay(FIntInGameRsvpPushUpsellTimeoutMs / 1000, function()
			if not v8 then
				logger:warning("In-game RSVP push upsell request timed out after {} ms", FIntInGameRsvpPushUpsellTimeoutMs)

				if not v8 then
					v8 = true
					callback(nil)
				end
			end
		end)

		v7._buildClientAttributes():andThen(function(items)
			if next(items) == nil then
				return nil
			end

			local promptsUrl = getPromptsUrl(items)
			local v9 = "GET"
			local v10 = nil
			return Promise.new(function(callback2, callback3)
				v7._sendRequest({
					Url = promptsUrl,
					Method = v9,
					Headers = v9 == "POST" and { ["Content-Type"] = "application/json" } or {
						Accept = "application/json"
					},
					Body = v10
				}, function(p2)
					local statusCode = p2.StatusCode
					local v11

					if v9 == "POST" then
						v11 = typeof(statusCode) == "number" and statusCode >= 200 and statusCode < 300
					else
						v11 = statusCode == 200
					end

					if v11 then
						callback2(p2)
					else
						callback3(`{v9} {promptsUrl} failed: {tostring(p2.StatusCode)}`)
					end
				end)
			end):andThen(function(p2)
				local success, result = pcall(function()
					return HttpService:JSONDecode(p2.Body)
				end)

				if success then
					return parsePrompt(result)
				end

				return Promise.reject("invalid prompts response")
			end)
		end):andThen(settle, function(p2)
			if not v8 then
				logger:warning("In-game RSVP push upsell request failed: {}", (tostring(p2)))

				if not v8 then
					v8 = true
					callback(nil)
				end
			end
		end)
	end)
end

local function postPromptEvent(p2, p3)
	local v8 = urlBuilder.new({ base = urlBase.APIS, path = p2 })()
	local jsonEncode = HttpService:JSONEncode({ promptType = p3, promptId = p3 })
	local v9 = "POST"
	Promise.new(function(callback, callback2)
		v7._sendRequest({
			Url = v8,
			Method = v9,
			Headers = v9 == "POST" and { ["Content-Type"] = "application/json" } or {
				Accept = "application/json"
			},
			Body = jsonEncode
		}, function(p4)
			local statusCode = p4.StatusCode
			local v10

			if v9 == "POST" then
				v10 = typeof(statusCode) == "number" and statusCode >= 200 and statusCode < 300
			else
				v10 = statusCode == 200
			end

			if v10 then
				callback(p4)
			else
				callback2(`{v9} {v8} failed: {tostring(p4.StatusCode)}`)
			end
		end)
	end):catch(function(p4)
		logger:warning("In-game RSVP push upsell event failed: {}", (tostring(p4)))
	end)
end

function v7.reportImpression(p2)
	postPromptEvent("modals-api/v1/prompts/impression", p2)
end

function v7.reportDismiss(p2)
	postPromptEvent("modals-api/v1/prompts/dismiss", p2)
end

return v7
