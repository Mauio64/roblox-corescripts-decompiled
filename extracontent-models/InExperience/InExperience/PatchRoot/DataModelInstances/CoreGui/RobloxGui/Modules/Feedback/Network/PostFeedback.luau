local InGameMenu = script.Parent.Parent.Parent.InGameMenu
local Url = require(InGameMenu.Network.Url)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.InGameMenuDependencies).Promise

local function request(p1, p2, p3) -- line: 22
	-- upvalues: HttpService (copy)
	return HttpService:RequestInternal(p1):Start(function(p4, p5) -- line: 23
		-- upvalues: p2 (copy), p3 (copy)
		if p4 then
			p2()

			return
		end

		p3((tostring(p5.StatusMessage)))
	end)
end

return function(p6, p7, p8, p9, p10, p11) -- line: 32
	-- upvalues: Players (copy), Url (copy), HttpService (copy), Promise (copy)
	local n1 = 1

	if p8 == "" or p8 == nil then
		p8 = "UID_" .. game.GameId
		n1 = 2
	end

	local t1 = {
		LocalizationFeedback = {
			FeedbackTarget = {
				ServiceSource = {
					Type = n1,
					ExternalId = p8
				},
				Source = {
					ContentType = 1,
					Value = p6
				},
				Translation = {
					ContentType = 1,
					Value = p7
				}
			},
			Locale = not Players.LocalPlayer.LocaleId and "" or Players.LocalPlayer.LocaleId:gsub("-", "_"),
			ReasonType = p11,
			Suggestion = {
				ContentType = 1,
				Value = p9
			},
			Comments = p10
		}
	}
	local v19 = string.format("%sfeedback-api/v1/feedback/create-localization", Url.APIS_URL)
	local t2 = {
		Method = "POST",
		Url = v19,
		Body = HttpService:JSONEncode(t1),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 87
		-- upvalues: t2 (copy), HttpService (copy)
		spawn(function() -- line: 88
			-- upvalues: t2 (copy), resolve (copy), reject (copy), HttpService (copy)
			local v25 = t2
			local v26 = resolve
			local v27 = reject

			HttpService:RequestInternal(v25):Start(function(p12, p13) -- line: 23
				-- upvalues: v26 (copy), v27 (copy)
				if p12 then
					v26()

					return
				end

				v27((tostring(p13.StatusMessage)))
			end)
		end)
	end)
end
