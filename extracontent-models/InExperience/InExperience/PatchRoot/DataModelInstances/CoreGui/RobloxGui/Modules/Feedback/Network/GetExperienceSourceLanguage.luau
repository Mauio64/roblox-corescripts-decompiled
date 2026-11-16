local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local Promise = require(CorePackages.Packages.Promise)

local parent = script.Parent.Parent
local resolveSourceLanguageName = require(parent.Network.resolveSourceLanguageName)

local function requestJson(url) -- 1 equivalent call inferred from this helper
	return Promise.new(function(callback, callback2)
		HttpService:RequestInternal({ Url = url, Method = "GET" }):Start(function(p, p2)
			if not p then
				callback2("Connection error")
				return
			end

			if p2.StatusCode < 200 or p2.StatusCode >= 400 then
				callback2("Status code: " .. tostring(p2.StatusCode))
				return
			end

			local success, result = pcall(function()
				return HttpService:JSONDecode(p2.Body)
			end)

			if success then
				callback(result)
			else
				callback2("Failed to decode response body")
			end
		end)
	end)
end

return function()
	local localeId = Players.LocalPlayer.LocaleId

	local v = not localeId and "" or localeId:gsub("-", "_")

	local url = string.format("%sv1/locales?displayValueLocale=%s", Url.LOCALE_URL, v)

	local url2 = string.format("%sv1/source-language/games/%d", Url.GAME_INTERNATIONALIZATION_URL, game.GameId)

	return Promise.all({ requestJson(url), requestJson(url2) }):andThen(function(list) -- inferred equivalent call
		local item = list[1]
		local item2 = list[2]

		local sourceLanguageName = resolveSourceLanguageName(item.data, item2.languageCode)

		if sourceLanguageName == nil then
			return Promise.reject("Could not resolve source language name")
		end

		return sourceLanguageName
	end)
end
