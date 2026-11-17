local HttpService = game:GetService("HttpService")

local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local parent = VirtualEvents.Parent

local NotificationsUpsell = require(parent.NotificationsUpsell)
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

require(VirtualEvents.Common.InGameRsvpPushUpsellTypes)
local logger = require(VirtualEvents.logger)
local FIntInGameRsvpPushUpsellTimeoutMs = require(VirtualEvents.Flags.FIntInGameRsvpPushUpsellTimeoutMs)

local promptType = {
	OsPrompt = "PushNotificationsUpsellInGameOsPrompt",
	Settings = "PushNotificationsUpsellInGameSettings"
}

local v = { "title", "body", "confirm" }

local FetchInGameRsvpPushUpsell = {}
FetchInGameRsvpPushUpsell.PromptType = promptType

function FetchInGameRsvpPushUpsell._sendRequest(p, callback)
	HttpService:RequestInternal(p):Start(function(_, p2)
		callback(p2)
	end)
end
function FetchInGameRsvpPushUpsell._buildClientAttributes()
	return NotificationsUpsell.PushPermissionClientAttributes.build()
end

local function getPromptsUrl(items)
	return `{urlBuilder.new({
		base = UrlBase.APIS,
		path = "modals-api/v1/prompts",
		query = { entryPoint = "InExperienceEventRsvpGoing", promptStyle = "Modal" }
	})()}&clientAttributes={HttpService:UrlEncode(HttpService:JSONEncode(items))}`
end

local function asTable(p) -- 4 equivalent calls inferred from this helper
	return if type(p) == "table" then p else nil
end

local function readTranslations(customPrompt)
	local translations = {}
	customPrompt = asTable(customPrompt) -- inferred equivalent call
	local translations2

	if customPrompt then
		translations2 = customPrompt.translations or customPrompt.Translations
	end

	translations2 = asTable(translations2) -- inferred equivalent call

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
	result = asTable(result) -- inferred equivalent call
	local customPrompts

	if result then
		customPrompts = result.customPrompts
	end

	customPrompts = asTable(customPrompts) -- inferred equivalent call

	if customPrompts == nil then
		return nil
	end

	for _, path in { "OsPrompt", "Settings" } do
		local promptType2 = promptType[path]
		local customPrompt = customPrompts[promptType2]

		if customPrompt ~= nil then
			local translations = readTranslations(customPrompt)

			for _, v2 in v do
				if translations[v2] == nil or translations[v2] == "" then
					logger:warning("In-game RSVP push upsell {} has no {} translation", promptType2, v2)
					return nil
				end
			end

			return { promptType = promptType2, path = path, translations = translations }
		end
	end

	return nil
end

local function request(url: string, method: string, jsonEncode: string?) -- 2 equivalent calls inferred from this helper
	return Promise.new(function(callback, callback2)
		FetchInGameRsvpPushUpsell._sendRequest({
			Url = url,
			Method = method,
			Headers = method == "POST" and { ["Content-Type"] = "application/json" } or {
				Accept = "application/json"
			},
			Body = jsonEncode
		}, function(p)
			local statusCode = p.StatusCode
			local v2

			if method == "POST" then
				if typeof(statusCode) == "number" and statusCode >= 200 then
					v2 = statusCode < 300
				else
					v2 = false
				end
			else
				v2 = statusCode == 200
			end

			if v2 then
				callback(p)
			else
				callback2(`{method} {url} failed: {tostring(p.StatusCode)}`)
			end
		end)
	end)
end

function FetchInGameRsvpPushUpsell.fetch()
	return Promise.new(function(callback)
		local v2 = false
		local function settle(p) -- 2 equivalent calls inferred from this helper
			if not v2 then
				v2 = true
				callback(p)
			end
		end

		task.delay(FIntInGameRsvpPushUpsellTimeoutMs / 1000, function()
			if not v2 then
				logger:warning(
					"In-game RSVP push upsell request timed out after {} ms",
					FIntInGameRsvpPushUpsellTimeoutMs
				)
				settle(nil) -- inferred equivalent call
			end
		end)

		FetchInGameRsvpPushUpsell._buildClientAttributes():andThen(function(items)
			if next(items) == nil then
				return nil
			end

			return request(getPromptsUrl(items), "GET"):andThen(function(p) -- inferred equivalent call
				local success, result = pcall(function()
					return HttpService:JSONDecode(p.Body)
				end)

				if success then
					return parsePrompt(result)
				end

				return Promise.reject("invalid prompts response")
			end)
		end):andThen(settle, function(p)
			if not v2 then
				logger:warning("In-game RSVP push upsell request failed: {}", (tostring(p)))
				settle(nil) -- inferred equivalent call
			end
		end)
	end)
end

local function postPromptEvent(path: string, p: string)
	request( -- inferred equivalent call
		urlBuilder.new({ base = UrlBase.APIS, path = path })(),
		"POST",
		HttpService:JSONEncode({ promptType = p, promptId = p })
	):catch(function(p2)
		logger:warning("In-game RSVP push upsell event failed: {}", (tostring(p2)))
	end)
end

function FetchInGameRsvpPushUpsell.reportImpression(p: string)
	postPromptEvent("modals-api/v1/prompts/impression", p)
end

function FetchInGameRsvpPushUpsell.reportDismiss(p: string)
	postPromptEvent("modals-api/v1/prompts/dismiss", p)
end

return FetchInGameRsvpPushUpsell
