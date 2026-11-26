local getPresetIconSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getPresetIconSize")

local function getPresetIconRichText(p2)
	return `<font size='{module(p2)}' weight='700' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>lightning-bolt</font>`
end

return getPresetIconRichText
