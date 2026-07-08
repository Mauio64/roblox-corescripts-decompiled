local LocalizationService = game:GetService("LocalizationService")
local Chat = game:GetService("Chat")
local t1 = {
	System = "InGame.Chat.Label.SystemMessagePrefix",
	Team = "InGame.Chat.Label.TeamMessagePrefix"
}
local t2 = {
	["From(%s.+)"] = {
		English = "From",
		LocalizationKey = "InGame.Chat.Label.From"
	},
	["To(%s.+)"] = {
		English = "To",
		LocalizationKey = "InGame.Chat.Label.To"
	}
}

return {
	_hasFetchedLocalization = false,
	_getTranslator = function(p1) -- line: 27
		-- upvalues: Chat (copy), LocalizationService (copy)
		if not p1._translator and not p1._hasFetchedLocalization then
			p1._hasFetchedLocalization = true

			local ChatLocalization = Chat:WaitForChild("ChatLocalization", 4)

			if ChatLocalization then
				p1._translator = ChatLocalization:GetTranslator(LocalizationService.RobloxLocaleId)
				LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 35
					-- upvalues: p1 (copy)
					p1._hasFetchedLocalization = false
					p1._translator = nil
				end)
			else
				warn("Missing ChatLocalization. Chat interface will not be localized.")
			end
		end

		return p1._translator
	end,
	Get = function(p2, p3, p4, p5) -- line: 47
		pcall(function() -- line: 49
			-- upvalues: p2 (copy), p4 (ref), p3 (copy), p5 (copy)
			local v41 = p2:_getTranslator()

			if v41 then
				p4 = v41:FormatByKey(p3, p5)

				return
			end

			warn("Missing Translator. Used default for", p3)
		end)

		return p4
	end,
	LocalizeFormattedMessage = function(p6, p7) -- line: 60
		local start, stop = string.find(p7, "{RBX_LOCALIZATION_KEY}")

		if not start then
			return p7
		end

		local start2, stop2 = string.find(p7, "{RBX_LOCALIZATION_DEFAULT}")

		if not start2 then
			return p7
		end

		local start3, stop3 = string.find(p7, "{RBX_LOCALIZATION_PARAMS}")
		local v20 = string.sub(p7, stop + 1, start2 - 1)

		if not start3 then
			return p6:Get(v20, (string.sub(p7, stop2 + 1)))
		end

		local v21 = string.sub(p7, stop2 + 1, start3 - 1)
		local v22 = string.sub(p7, stop3 + 1)
		local t3 = {}

		for match, v25 in string.gmatch(v22, "([^%s]+)=([^%s]+)") do
			t3[match] = v25
		end

		return p6:Get(v20, v21, t3)
	end,
	FormatMessageToSend = function(_, p9, p10, p11, p12) -- line: 89
		if p11 and p12 then
			return "{RBX_LOCALIZATION_KEY}" .. p9 .. "{RBX_LOCALIZATION_DEFAULT}" .. p10 .. "{RBX_LOCALIZATION_PARAMS}" .. p11 .. "=" .. p12
		end

		return "{RBX_LOCALIZATION_KEY}" .. p9 .. "{RBX_LOCALIZATION_DEFAULT}" .. p10
	end,
	tryLocalize = function(p13, p14) -- line: 100
		-- upvalues: t1 (copy), t2 (copy)
		if t1[p14] then
			return p13:Get(t1[p14], p14)
		end

		for k, v in pairs(t1) do
			if string.find(p14, k) then
				local v35 = p13:Get(v, k)

				return string.gsub(p14, k, v35, 1)
			end
		end

		for k, v in pairs(t2) do
			local v38 = string.find(p14, k)
			local match = string.match(p14, k)

			if v38 and match then
				local v40 = p13:Get(v.LocalizationKey, v.English)

				return (not (v38 > 1) and "" or p14:sub(1, v38 - 1)) .. v40 .. match
			end
		end

		return p14
	end
}
