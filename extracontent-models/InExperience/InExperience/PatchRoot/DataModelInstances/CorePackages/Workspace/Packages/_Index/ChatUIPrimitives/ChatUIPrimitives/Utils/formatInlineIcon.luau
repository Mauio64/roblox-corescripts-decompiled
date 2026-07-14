local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)

local function formatInlineIcon(s1: string, t1: {[any]: any}?) -- line: 24
	-- upvalues: escapeRichText (copy)
	local t2 = { "family" }
	local t3 = {
		family = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
	}

	if t1 ~= nil then
		for v8, v9 in t1 do
			if v8 ~= "family" then
				if t3[v8] == nil then
					table.insert(t2, v8)
				end

				t3[v8] = v9
			end
		end
	end

	table.sort(t2)

	local t4 = table.create(#t2)

	for v11, v12 in t2 do
		t4[v11] = `{ escapeRichText(v12) }='{ escapeRichText(t3[v12]) }'`
	end

	return `<font { table.concat(t4, " ") }>{ escapeRichText(s1) }</font>`
end

return formatInlineIcon
