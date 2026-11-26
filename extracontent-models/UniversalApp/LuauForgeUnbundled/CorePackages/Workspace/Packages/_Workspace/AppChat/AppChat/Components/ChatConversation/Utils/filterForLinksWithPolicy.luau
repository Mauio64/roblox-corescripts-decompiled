local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")

local filterForLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/filterForLinks")

local v5 = {
	"roblox.com",
	"sitetest%d%.robloxlabs.com",
	"gametest%d%.robloxlabs.com",
	"roblox.cn",
	"roblox.qq.com",
	"roblox%-cn.com"
}

return function(p2)
	ArgCheck.isType(p2, "table", "filterForLinks.text")

	return filterForLinks(p2, v5)
end
