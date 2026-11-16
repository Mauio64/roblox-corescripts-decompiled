local ExpChat = script:FindFirstAncestor("ExpChat")
local Config = require(ExpChat.Config)

return function(value, p, p2)
	local v = p or Config.ChatWindowFont
	local v2 = p2 or Config.ChatWindowTextSize

	local v3 = string.gsub(value, "transparency=[\"']%d%.?%d*[\"']", "transparency='1.0'")

	local v4 = string.format(
		"<font transparency='1.0' family='%s' weight='%s' size='%s'><stroke transparency='1.0'>%s</stroke></font>",
		v.Family,
		string.gsub(tostring(v.Weight), "Enum.FontWeight.", ""),
		v2,
		v3
	)

	if v.Style == Enum.FontStyle.Italic then
		return "<i>" .. v4 .. "</i>"
	end

	return v4
end
