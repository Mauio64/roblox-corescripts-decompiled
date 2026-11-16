local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
require(ChatUIPrimitives.UniversalMessage.Types)

local function hasPreset(clone): boolean
	for _, category in clone.categories do
		for _, item in category.items do
			if item.content.kind == "preset" then
				return true
			end
		end
	end

	return false
end

local function withPresetDisclaimer(items, callback)
	local clones = {}

	for _, clone in items do
		if clone.footerText == nil and hasPreset(clone) then
			clone = table.clone(clone)
			clone.footerText = callback("Feature.Chat.PresetChat.Disclaimer")
		end

		table.insert(clones, clone)
	end

	return clones
end

return withPresetDisclaimer
