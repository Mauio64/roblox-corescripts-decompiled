local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Foundation = require(parent.Foundation)

local formatInlineIcon = require(ChatUIPrimitives.Utils.formatInlineIcon)

local IconName = Foundation.Enums.IconName

local function ceilToEven(p: number) -- 1 equivalent call inferred from this helper
	return (math.max(0, math.ceil(p / 2) * 2))
end

local function getPresetIconSize(p: number) -- 1 equivalent call inferred from this helper
	return ceilToEven(p * 3 / 4) -- inferred equivalent call
end

local function getPresetIconRichText(p: number)
	return formatInlineIcon(IconName.LightningBolt, {
		weight = "700",
		size = tostring(getPresetIconSize(p)) -- inferred equivalent call
	})
end

return getPresetIconRichText
