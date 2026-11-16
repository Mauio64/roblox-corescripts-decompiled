local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")

local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)

local function formatInlineIcon(p: string, items)
	local v = { "family" }
	local v2 = {
		family = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
	}

	if items ~= nil then
		for k, item in items do
			if k == "family" then
				continue
			end

			if v2[k] == nil then
				table.insert(v, k)
			end

			v2[k] = item
		end
	end

	table.sort(v)

	local v3 = table.create(#v)

	for k, v4 in v do
		v3[k] = `{escapeRichText(v4)}='{escapeRichText(v2[v4])}'`
	end

	return `<font {table.concat(v3, " ")}>{escapeRichText(p)}</font>`
end

return formatInlineIcon
