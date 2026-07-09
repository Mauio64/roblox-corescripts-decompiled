local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local isWhiteSpaceOnly = require(ExpChat.isWhiteSpaceOnly)
local getFFlagExpChatProtectedChatInternalAPIs = require(ExpChatParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs

return function(p1) -- line: 7
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), isWhiteSpaceOnly (copy)
	local s1 = ""
	local s2 = ""
	local v8 = if not p1 then nil else if not getFFlagExpChatProtectedChatInternalAPIs() then p1.Text else p1.TextInternal

	if v8 and not isWhiteSpaceOnly(v8) then
		s1 = v8
		s2 = if not getFFlagExpChatProtectedChatInternalAPIs() then p1.Translation else p1.TranslationInternal
	end

	if not not p1 and p1.WasRewritten and p1.RewrittenText and not isWhiteSpaceOnly(p1.RewrittenText) then
		s1 = p1.RewrittenText
		s2 = p1.RewrittenTranslation
	end

	return s1, s2
end
