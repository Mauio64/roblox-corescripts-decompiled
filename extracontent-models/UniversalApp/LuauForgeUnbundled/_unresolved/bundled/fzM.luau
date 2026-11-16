local module = require("@luauforge/bundled/fzN")

local v5 = { Default = "Default", Classic = "Classic", Halloween2026 = "Halloween2026" }

local v6 = { v5.Default, v5.Classic, v5.Halloween2026 }

local v7 = {
	[v5.Default] = "",
	[v5.Classic] = "Classic",
	[v5.Halloween2026] = "Halloween2026"
}

local set = { [v5.Classic] = true, [v5.Halloween2026] = true }

local colors = {
	[v5.Default] = Color3.fromHex("#335FFF"),
	[v5.Classic] = Color3.fromHex("#FFFFFF"),
	[v5.Halloween2026] = Color3.fromHex("#E92127")
}

local v8 = {}

for k, v9 in v6 do
	v8[v9] = `rbxasset://textures/ui/LuaApp/graphic/app_icon_{v9}.png`
end

return {
	AppIcon = v5,
	ORDERED = v6,
	NATIVE_NAME = v7,
	REQUIRES_PLUS = set,
	PREVIEW_COLOR = colors,
	PREVIEW_IMAGE = v8,
	isAppIcon = function(value): boolean
		return type(value) == "string" and v7[value] ~= nil
	end,
	canUseAppIcon = function(p2, p3, p4): boolean
		if not set[p2] or p3 then
			return true
		end

		return (p4 or module)[p2] == true
	end
}
