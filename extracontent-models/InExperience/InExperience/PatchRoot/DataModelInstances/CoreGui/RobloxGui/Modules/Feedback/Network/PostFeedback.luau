local parent = script.Parent.Parent.Parent
local parent2 = script.Parent.Parent

local inGameMenu = parent.InGameMenu
local Url = require(inGameMenu.Network.Url)
local Constants = require(parent2.Resources.Constants)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Promise = InGameMenuDependencies.Promise
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local GetFFlagEnableSendImageFeedbackToBackend = require(RobloxGui.Modules.Flags.GetFFlagEnableSendImageFeedbackToBackend)

local function request(p, callback, callback2) -- 1 equivalent call inferred from this helper
	return HttpService:RequestInternal(p):Start(function(p2, p3)
		if p2 then
			callback()
		else
			callback2((tostring(p3.StatusMessage)))
		end
	end)
end

return function(contentType, p, p2, externalId, p3, comments, reasonType)
	local v

	if GetFFlagEnableSendImageFeedbackToBackend() then
		local v2 = Constants.ServiceSourceType.InGameTranslations

		if externalId == "" or externalId == nil then
			externalId = "UID_" .. game.GameId
			v2 = Constants.ServiceSourceType.InGameTranslationsNoEntryId
		end

		if contentType == Constants.ContentType.Image then
			v2 = Constants.ServiceSourceType.InGameUniverseAndImageAsset
		end

		v = {
			LocalizationFeedback = {
				FeedbackTarget = {
					ServiceSource = { Type = v2, ExternalId = externalId },
					Source = { ContentType = contentType, Value = p },
					Translation = (contentType ~= Constants.ContentType.Image or p2 ~= nil and p2 ~= "") and {
						ContentType = contentType,
						Value = p2
					} or nil
				},
				Locale = not Players.LocalPlayer.LocaleId and "" or Players.LocalPlayer.LocaleId:gsub("-", "_"),
				ReasonType = reasonType,
				Suggestion = { ContentType = Constants.ContentType.Text, Value = p3 },
				Comments = comments
			}
		}
	else
		local v2

		if externalId == "" or externalId == nil then
			externalId = "UID_" .. game.GameId
			v2 = 2
		else
			v2 = 1
		end

		v = {
			LocalizationFeedback = {
				FeedbackTarget = {
					ServiceSource = { Type = v2, ExternalId = externalId },
					Source = { ContentType = 1, Value = p },
					Translation = { ContentType = 1, Value = p2 }
				},
				Locale = not Players.LocalPlayer.LocaleId and "" or Players.LocalPlayer.LocaleId:gsub("-", "_"),
				ReasonType = reasonType,
				Suggestion = { ContentType = 1, Value = p3 },
				Comments = comments
			}
		}
	end

	local v2 = {
		Url = string.format("%sfeedback-api/v1/feedback/create-localization", Url.APIS_URL),
		Method = "POST",
		Body = HttpService:JSONEncode(v),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(callback, callback2)
		spawn(function()
			request(v2, callback, callback2) -- inferred equivalent call
		end)
	end)
end
