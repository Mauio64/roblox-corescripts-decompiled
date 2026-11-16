require(script.Parent.Parent.projectMessageEnvelope)

local function getReference(p) -- 2 equivalent calls inferred from this helper
	local repliesTo = p.repliesTo
	return if repliesTo ~= nil then repliesTo[1] else nil
end

local function getReplyText(p) -- 1 equivalent call inferred from this helper
	local reference = getReference(p) -- inferred equivalent call
	local preview

	if reference ~= nil then
		preview = reference.preview
	end

	if preview == nil or preview.fallbackText == "" then
		return nil
	end

	return preview.fallbackText
end

return {
	getReplyText = getReplyText,
	getReplyLabel = function(p)
		local reference = getReference(p) -- inferred equivalent call

		if reference == nil then
			return nil
		end

		if getReplyText(p) == nil then -- inferred equivalent call
			return nil
		end

		local label = reference.label
		return if not (label == nil or label == "") then label else nil
	end
}
