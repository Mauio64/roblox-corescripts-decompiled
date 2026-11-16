local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local isWhiteSpaceOnly = require(ExpChat.isWhiteSpaceOnly)
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs

return function(data)
	local v = ""
	local v2 = ""
	local v3

	if data then
		if getFFlagExpChatProtectedChatInternalAPIs() then
			v3 = data.TextInternal
		else
			v3 = data.Text
		end
	end

	if v3 and not isWhiteSpaceOnly(v3) then
		if getFFlagExpChatProtectedChatInternalAPIs() then
			v2 = data.TranslationInternal
		else
			v2 = data.Translation
		end

		v = v3
	end

	local v4 = if data then data.WasRewritten else false

	if v4 and data.RewrittenText and not isWhiteSpaceOnly(data.RewrittenText) then
		v = data.RewrittenText
		v2 = data.RewrittenTranslation
	end

	return v, v2
end
