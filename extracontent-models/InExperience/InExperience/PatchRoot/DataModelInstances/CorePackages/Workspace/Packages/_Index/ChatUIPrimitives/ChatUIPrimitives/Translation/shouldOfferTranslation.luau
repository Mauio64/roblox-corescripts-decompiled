local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")

require(ChatUIPrimitives.Types)

local function shouldOfferTranslation(p, flag: boolean): boolean
	if not flag then
		return false
	end

	local translation = p.translation
	return translation ~= nil and translation ~= "" and translation ~= p.content
end

return shouldOfferTranslation
