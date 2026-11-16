local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)
local memoize = require(ExpChat.memoize)

local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local formatGlobalChatPrefix = require(ExpChat.formatGlobalChatPrefix)

local function fn(p): boolean -- 4 equivalent calls inferred from this helper
	return p == nil or p == ""
end

return (memoize(function(data, p, p2)
	local v = {
		text = data.text or "",
		prefixText = 0,
		translation = 0,
		useTranslation = 0,
		bodyTextProperties = 0,
		prefixTextProperties = 0,
		wasRewritten = 0,
		originalText = 0
	}
	local prefixText

	if FFlagExpChatGlobalTabDefault then
		prefixText = formatGlobalChatPrefix(data.prefixText or "", data, p2)
	else
		prefixText = data.prefixText or ""
	end

	v.prefixText = prefixText

	v.translation = data.translation or ""
	v.useTranslation = data.useTranslation
	v.bodyTextProperties = {}
	v.prefixTextProperties = {}
	local wasRewritten

	if FFlagEnableInExpChatRewrite then
		wasRewritten = data.wasRewritten or false
	end

	v.wasRewritten = wasRewritten
	v.originalText = FFlagEnableInExpChatRewrite and (data.originalText or "") or nil

	if p then
		for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
			v.bodyTextProperties[k] = p[k]
			v.prefixTextProperties[k] = p[k]
		end
	end

	if not data.chatWindowMessageProperties then
		return v
	end

	local chatWindowMessageProperties = data.chatWindowMessageProperties
	local text

	if fn(chatWindowMessageProperties.Text) then -- inferred equivalent call
		text = v.text
	else
		text = chatWindowMessageProperties.Text
	end

	v.text = text
	local prefixText2

	if fn(chatWindowMessageProperties.PrefixText) then -- inferred equivalent call
		prefixText2 = v.prefixText
	else
		prefixText2 = chatWindowMessageProperties.PrefixText
	end

	v.prefixText = prefixText2
	local translation

	if fn(chatWindowMessageProperties.Translation) then -- inferred equivalent call
		translation = v.translation
	else
		translation = chatWindowMessageProperties.Translation
	end

	v.translation = translation

	for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
		v.bodyTextProperties[k] = chatWindowMessageProperties[k]
		v.prefixTextProperties[k] = chatWindowMessageProperties[k]
	end

	if not chatWindowMessageProperties.PrefixTextProperties then
		return v
	end

	local prefixTextProperties = chatWindowMessageProperties.PrefixTextProperties
	local prefixText3

	if fn(prefixTextProperties.PrefixText) then -- inferred equivalent call
		prefixText3 = v.prefixText
	else
		prefixText3 = prefixTextProperties.PrefixText
	end

	v.prefixText = prefixText3

	for k, _ in pairs(Config.DefaultChatWindowMessagePropertiesInstanceSettings) do
		v.prefixTextProperties[k] = prefixTextProperties[k]
	end

	local uiGradient = prefixTextProperties:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local uiGradient2 = {}

		for k, _ in pairs(Config.DefaultChatWindowChildrenCustomizationProperties.UIGradient) do
			uiGradient2[k] = uiGradient[k]
		end

		v.prefixTextProperties.UIGradient = uiGradient2
	end

	return v
end))
