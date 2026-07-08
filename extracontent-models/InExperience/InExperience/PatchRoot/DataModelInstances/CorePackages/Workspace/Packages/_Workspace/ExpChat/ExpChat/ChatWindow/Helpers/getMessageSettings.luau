local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)
local memoize = require(ExpChat.memoize)
local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)

return (memoize(function(p1, p2) -- line: 11
	-- upvalues: FFlagEnableInExpChatRewrite (copy), Config (copy)
	local t1 = {
		text = p1.text or "",
		prefixText = p1.prefixText or "",
		translation = p1.translation or "",
		useTranslation = p1.useTranslation,
		bodyTextProperties = {},
		prefixTextProperties = {},
		wasRewritten = if not FFlagEnableInExpChatRewrite then nil else p1.wasRewritten or false,
		originalText = if not FFlagEnableInExpChatRewrite then nil else p1.originalText or ""
	}

	if p2 then
		for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
			t1.bodyTextProperties[k] = p2[k]
			t1.prefixTextProperties[k] = p2[k]
		end
	end

	if p1.chatWindowMessageProperties then
		local chatWindowMessageProperties = p1.chatWindowMessageProperties
		local chatWindowMessagePropertiesText = chatWindowMessageProperties.Text

		t1.text = if not (chatWindowMessagePropertiesText == nil or chatWindowMessagePropertiesText == "") then chatWindowMessageProperties.Text else t1.text

		local PrefixText = chatWindowMessageProperties.PrefixText

		t1.prefixText = if not (PrefixText == nil or PrefixText == "") then chatWindowMessageProperties.PrefixText else t1.prefixText

		local Translation = chatWindowMessageProperties.Translation

		t1.translation = if not (Translation == nil or Translation == "") then chatWindowMessageProperties.Translation else t1.translation

		for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
			t1.bodyTextProperties[k] = chatWindowMessageProperties[k]
			t1.prefixTextProperties[k] = chatWindowMessageProperties[k]
		end

		if chatWindowMessageProperties.PrefixTextProperties then
			local PrefixTextProperties = chatWindowMessageProperties.PrefixTextProperties
			local PrefixText2 = PrefixTextProperties.PrefixText

			t1.prefixText = if not (PrefixText2 == nil or PrefixText2 == "") then PrefixTextProperties.PrefixText else t1.prefixText

			for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
				t1.prefixTextProperties[k] = PrefixTextProperties[k]
			end

			local UIGradient = PrefixTextProperties:FindFirstChildOfClass("UIGradient")

			if UIGradient then
				local t2 = {}

				for k, _ in pairs(Config.DefaultChatWindowChildrenCustomizationProperties.UIGradient) do
					t2[k] = UIGradient[k]
				end

				t1.prefixTextProperties.UIGradient = t2
			end
		end
	end

	return t1
end))
