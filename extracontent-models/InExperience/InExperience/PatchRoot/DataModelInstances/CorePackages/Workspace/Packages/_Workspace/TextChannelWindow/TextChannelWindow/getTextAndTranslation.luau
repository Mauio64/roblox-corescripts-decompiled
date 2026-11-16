local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local isWhitespaceOnly = require(script.Parent.isWhitespaceOnly)

local function getTextAndTranslation(data)
	local v

	if getFFlagExpChatProtectedChatInternalAPIs() then
		v = data.TextInternal
	else
		v = data.Text
	end

	local v2

	if getFFlagExpChatProtectedChatInternalAPIs() then
		v2 = data.TranslationInternal
	else
		v2 = data.Translation
	end

	local v3 = (not v or isWhitespaceOnly(v)) and "" or v

	if data.WasRewritten and data.RewrittenText and not isWhitespaceOnly(data.RewrittenText) then
		local rewrittenTranslation = data.RewrittenTranslation
		local rewrittenText = data.RewrittenText

		if rewrittenTranslation and rewrittenTranslation ~= "" then
			return rewrittenText, rewrittenTranslation
		end

		return rewrittenText, nil
	elseif v2 and v2 ~= "" then
		return v3, v2
	else
		return v3, nil
	end
end

return getTextAndTranslation
