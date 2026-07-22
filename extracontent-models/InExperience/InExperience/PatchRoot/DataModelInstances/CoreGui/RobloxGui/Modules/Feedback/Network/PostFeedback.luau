local ParentParent = script.Parent.Parent.Parent
local ParentParent2 = script.Parent.Parent
local InGameMenu = ParentParent.InGameMenu
local Url = require(InGameMenu.Network.Url)
local Constants = require(ParentParent2.Resources.Constants)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.InGameMenuDependencies).Promise
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local GetFFlagEnableSendImageFeedbackToBackend = require(RobloxGui.Modules.Flags.GetFFlagEnableSendImageFeedbackToBackend)

local function request(p1, p2, p3) -- line: 28
	-- upvalues: HttpService (copy)
	return HttpService:RequestInternal(p1):Start(function(p4, p5) -- line: 29
		-- upvalues: p2 (copy), p3 (copy)
		if p4 then
			p2()

			return
		end

		p3((tostring(p5.StatusMessage)))
	end)
end

return function(p6, p7, p8, p9, p10, p11, p12) -- line: 38
	-- upvalues: GetFFlagEnableSendImageFeedbackToBackend (copy), Players (copy), Constants (copy), Url (copy), HttpService (copy), Promise (copy)
	local t1

	if not GetFFlagEnableSendImageFeedbackToBackend() then
		local n1 = 1

		if p9 == "" or p9 == nil then
			p9 = "UID_" .. game.GameId
			n1 = 2
		end

		t1 = {
			LocalizationFeedback = {
				FeedbackTarget = {
					ServiceSource = {
						Type = n1,
						ExternalId = p9
					},
					Source = {
						ContentType = 1,
						Value = p7
					},
					Translation = {
						ContentType = 1,
						Value = p8
					}
				},
				Locale = not Players.LocalPlayer.LocaleId and "" or Players.LocalPlayer.LocaleId:gsub("-", "_"),
				ReasonType = p12,
				Suggestion = {
					ContentType = 1,
					Value = p10
				},
				Comments = p11
			}
		}
	else
		local InGameTranslations = Constants.ServiceSourceType.InGameTranslations

		if p9 == "" or p9 == nil then
			p9 = "UID_" .. game.GameId
			InGameTranslations = Constants.ServiceSourceType.InGameTranslationsNoEntryId
		end

		if p6 == Constants.ContentType.Image then
			InGameTranslations = Constants.ServiceSourceType.InGameUniverseAndImageAsset
		end

		t1 = {
			LocalizationFeedback = {
				FeedbackTarget = {
					ServiceSource = {
						Type = InGameTranslations,
						ExternalId = p9
					},
					Source = {
						ContentType = p6,
						Value = p7
					},
					Translation = {
						ContentType = p6,
						Value = p8
					}
				},
				Locale = not Players.LocalPlayer.LocaleId and "" or Players.LocalPlayer.LocaleId:gsub("-", "_"),
				ReasonType = p12,
				Suggestion = {
					ContentType = Constants.ContentType.Text,
					Value = p10
				},
				Comments = p11
			}
		}
	end

	local v26 = string.format("%sfeedback-api/v1/feedback/create-localization", Url.APIS_URL)
	local t2 = {
		Method = "POST",
		Url = v26,
		Body = HttpService:JSONEncode(t1),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 136
		-- upvalues: t2 (copy), HttpService (copy)
		spawn(function() -- line: 137
			-- upvalues: t2 (copy), resolve (copy), reject (copy), HttpService (copy)
			local v32 = t2
			local v33 = resolve
			local v34 = reject

			HttpService:RequestInternal(v32):Start(function(p13, p14) -- line: 29
				-- upvalues: v33 (copy), v34 (copy)
				if p13 then
					v33()

					return
				end

				v34((tostring(p14.StatusMessage)))
			end)
		end)
	end)
end
