local LocalizationService = game:GetService("LocalizationService")
local Chat = game:GetService("Chat")

local v = {
	System = "InGame.Chat.Label.SystemMessagePrefix",
	Team = "InGame.Chat.Label.TeamMessagePrefix"
}

local v2 = {
	["From(%s.+)"] = { English = "From", LocalizationKey = "InGame.Chat.Label.From" },
	["To(%s.+)"] = { English = "To", LocalizationKey = "InGame.Chat.Label.To" }
}

local ChatLocalization = { _hasFetchedLocalization = false }

function ChatLocalization:_getTranslator()
	if self._translator or self._hasFetchedLocalization then
		return self._translator
	end

	self._hasFetchedLocalization = true

	local chatLocalization = Chat:WaitForChild("ChatLocalization", 4)

	if chatLocalization then
		self._translator = chatLocalization:GetTranslator(LocalizationService.RobloxLocaleId)
		LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
			self._hasFetchedLocalization = false
			self._translator = nil
		end)
	else
		warn("Missing ChatLocalization. Chat interface will not be localized.")
	end

	return self._translator
end

function ChatLocalization:Get(p, p2, p3)
	local v3 = p2
	pcall(function()
		local translator = self:_getTranslator()

		if translator then
			v3 = translator:FormatByKey(p, p3)
		else
			warn("Missing Translator. Used default for", p)
		end
	end)
	return v3
end

function ChatLocalization:LocalizeFormattedMessage(value)
	local v3, v4 = string.find(value, "{RBX_LOCALIZATION_KEY}")

	if not v3 then
		return value
	end

	local v5, v6 = string.find(value, "{RBX_LOCALIZATION_DEFAULT}")

	if not v5 then
		return value
	end

	local v7, v8 = string.find(value, "{RBX_LOCALIZATION_PARAMS}")
	local v9 = string.sub(value, v4 + 1, v5 - 1)

	if not v7 then
		return self:Get(v9, (string.sub(value, v6 + 1)))
	end

	local v10 = string.sub(value, v6 + 1, v7 - 1)
	local v11 = string.sub(value, v8 + 1)
	local v12 = {}

	for k, v13 in string.gmatch(v11, "([^%s]+)=([^%s]+)") do
		v12[k] = v13
	end

	return self:Get(v9, v10, v12)
end

function ChatLocalization.FormatMessageToSend(_, p, p2, p3, p4)
	if p3 and p4 then
		return "{RBX_LOCALIZATION_KEY}" .. p .. "{RBX_LOCALIZATION_DEFAULT}" .. p2 .. "{RBX_LOCALIZATION_PARAMS}" .. p3 .. "=" .. p4
	end

	return "{RBX_LOCALIZATION_KEY}" .. p .. "{RBX_LOCALIZATION_DEFAULT}" .. p2
end

function ChatLocalization:tryLocalize(value)
	if v[value] then
		return self:Get(v[value], value)
	end

	for k, v3 in pairs(v) do
		if string.find(value, k) then
			local v4 = self:Get(v3, k)
			return string.gsub(value, k, v4, 1)
		end
	end

	for k, v3 in pairs(v2) do
		local v4 = string.find(value, k)
		local v5 = string.match(value, k)

		if v4 and v5 then
			local v6 = self:Get(v3.LocalizationKey, v3.English)
			return (not (v4 > 1) and "" or value:sub(1, v4 - 1)) .. v6 .. v5
		end
	end

	return value
end

return ChatLocalization
