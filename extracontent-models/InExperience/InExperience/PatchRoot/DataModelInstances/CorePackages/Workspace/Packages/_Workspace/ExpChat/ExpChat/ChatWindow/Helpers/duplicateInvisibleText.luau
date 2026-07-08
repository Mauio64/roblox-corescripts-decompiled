local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)

return function(p1, p2, p3) -- line: 4
	-- upvalues: Config (copy)
	local v6 = p2 or Config.ChatWindowFont
	local v7 = p3 or Config.ChatWindowTextSize
	local v8 = string.gsub(p1, "transparency=[\"']%d%.?%d*[\"']", "transparency='1.0'")
	local v9 = string.format("<font transparency='1.0' family='%s' weight='%s' size='%s'><stroke transparency='1.0'>%s</stroke></font>", v6.Family, string.gsub(tostring(v6.Weight), "Enum.FontWeight.", ""), v7, v8)

	if v6.Style == Enum.FontStyle.Italic then
		v9 = "<i>" .. v9 .. "</i>"
	end

	return v9
end
