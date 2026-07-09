local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local getHasAmazonUserAgent = require(Modules.LuaApp.Util.getHasAmazonUserAgent)
local getHasQuestUserAgent = require(Modules.LuaApp.Util.getHasQuestUserAgent)
local getPaymentFromPlatform = require(Modules.LuaApp.Util.getPaymentFromPlatform)

return function() -- line: 8
	-- upvalues: UserInputService (copy), getHasAmazonUserAgent (copy), getHasQuestUserAgent (copy), getPaymentFromPlatform (copy)
	local Platform = UserInputService:GetPlatform()
	local v7 = getHasAmazonUserAgent()
	local v8 = getHasQuestUserAgent()

	return getPaymentFromPlatform(Platform, v7, v8)
end
