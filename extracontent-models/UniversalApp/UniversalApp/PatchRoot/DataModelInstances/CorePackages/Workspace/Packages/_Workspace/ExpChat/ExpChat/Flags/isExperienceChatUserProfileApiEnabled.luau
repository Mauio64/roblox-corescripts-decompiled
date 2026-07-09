local AppStorageService = game:GetService("AppStorageService")

game:DefineFastInt("ExperienceChatUserProfileApiRollout_v1", 0)
game:DefineFastFlag("ExperienceChatUserProfileApiEnabledForAll_v1", false)

local FastInt = game:GetFastInt("ExperienceChatUserProfileApiRollout_v1")
local Item = AppStorageService:GetItem("AppInstallationId")
local v4 = typeof(Item)
local v5 = if v4 ~= "number" then if v4 ~= "string" then nil else if not (string.len(Item) <= 0) then tonumber((string.sub(Item, -2))) else nil else Item
local v6 = if v5 ~= nil then FastInt >= v5 % 100 + 1 else FastInt >= 100

local function v7() -- line: 57
	-- upvalues: v6 (copy)
	return v6
end

return function() -- line: 72
	-- upvalues: v7 (copy)
	return game:GetFastFlag("ExperienceChatUserProfileApiEnabledForAll_v1") or v7()
end
