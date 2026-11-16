local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")

require(ChatUIPrimitives.Types)

local function resolveDisplayText(p, flag: boolean)
	if flag and p.translation ~= nil and p.translation ~= "" then
		return p.translation
	end

	return p.content
end

return resolveDisplayText
