local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local Lumberyak = require(parent.Lumberyak)

return (Lumberyak.Logger.new(nil, "SocialLuaAnalytics"))
