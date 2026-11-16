local getPresetIconSize = require(script.Parent.getPresetIconSize)

local function getPresetIconRichText(p: number)
	return `<font size='{getPresetIconSize(p)}' weight='700' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>lightning-bolt</font>`
end

return getPresetIconRichText
