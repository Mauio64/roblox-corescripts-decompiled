local getPresetIconSize = require(script.Parent.getPresetIconSize)

local function getPresetIconRichText(n1: number) -- line: 12
	-- upvalues: getPresetIconSize (copy)
	return `<font size='{ getPresetIconSize(n1) }' weight='700' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>lightning-bolt</font>`
end

return getPresetIconRichText
