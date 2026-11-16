local RunService = game:GetService("RunService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local HttpClient = require(parent.HttpClient)
require(InExperienceShop.Types)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local parseGamePassTrialAvailabilities = require(script.Parent.parseGamePassTrialAvailabilities)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function emptyAvailabilities()
	return { available = {}, active = {}, redeemed = {} }
end

local function trialAvailabilitiesUrl(p: number) -- 1 equivalent call inferred from this helper
	return `{Url.APIS_URL}game-passes/v1/universes/{p}/trial-availabilities`
end

return {
	fetchGamePassTrialAvailabilities = function(p: number)
		if not FFlagLuaAppEnableGamePassFreeTrials or not RunService:IsStudio() or game.GameId ~= 0 then
			return asPromise((fetch({
				method = "GET",
				url = trialAvailabilitiesUrl(p), -- inferred equivalent call
				analyticsKey = "game-pass-trial-availabilities.get",
				decode = function(p2)
					if typeof(p2) ~= "table" or typeof(p2.trialAvailabilities) ~= "table" then
						error("fetchGamePassTrialAvailabilities: malformed response, expected { trialAvailabilities = ... }")
					end

					return parseGamePassTrialAvailabilities(p2.trialAvailabilities)
				end
			})))
		end

		ShopDebugLogger.logLazy(function()
			return "fetchGamePassTrialAvailabilities: skipped unpublished Studio universeId=" .. tostring(p)
		end)

		return Promise.resolve(emptyAvailabilities())
	end
}
