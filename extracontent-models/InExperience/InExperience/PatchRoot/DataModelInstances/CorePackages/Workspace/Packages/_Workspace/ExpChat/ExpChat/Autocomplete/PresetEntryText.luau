local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)

local getPresetIconRichText = ExpChatShared.getPresetIconRichText

local function getIconSuffix(p: number) -- 2 equivalent calls inferred from this helper
	return ` {getPresetIconRichText(p)}`
end

local PresetEntryText = {}

function PresetEntryText.decorate(p: string, p2: number)
	return p .. getIconSuffix(p2) -- inferred equivalent call
end

function PresetEntryText.undecorate(value: string, p: number)
	local iconSuffix = getIconSuffix(p) -- inferred equivalent call

	if string.sub(value, -#iconSuffix) == iconSuffix then
		return (string.sub(value, 1, #value - #iconSuffix))
	end

	return value
end

return PresetEntryText
