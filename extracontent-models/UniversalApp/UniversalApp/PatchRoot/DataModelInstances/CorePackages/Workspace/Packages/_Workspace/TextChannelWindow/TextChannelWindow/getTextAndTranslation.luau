local ParentParent = script.Parent.Parent
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local isWhitespaceOnly = require(script.Parent.isWhitespaceOnly)

local function getTextAndTranslation(p1) -- line: 5
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), isWhitespaceOnly (copy)
	local v6 = if not getFFlagExpChatProtectedChatInternalAPIs() then p1.Text else p1.TextInternal
	local v7 = if not getFFlagExpChatProtectedChatInternalAPIs() then p1.Translation else p1.TranslationInternal

	if not v6 or isWhitespaceOnly(v6) then
		v6 = ""
	end

	if p1.WasRewritten and p1.RewrittenText and not isWhitespaceOnly(p1.RewrittenText) then
		local RewrittenTranslation = p1.RewrittenTranslation
		local RewrittenText = p1.RewrittenText

		if RewrittenTranslation and RewrittenTranslation ~= "" then
			return RewrittenText, RewrittenTranslation
		end

		return RewrittenText, nil
	end

	if v7 and v7 ~= "" then
		return v6, v7
	end

	return v6, nil
end

return getTextAndTranslation
