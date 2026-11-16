local AppStorageService = game:GetService("AppStorageService")

game:DefineFastInt("ExperienceChatUserProfileApiRollout_v1", 0)
game:DefineFastFlag("ExperienceChatUserProfileApiEnabledForAll_v1", false)

local function fn() -- 1 equivalent call inferred from this helper
	return game:GetFastInt("ExperienceChatUserProfileApiRollout_v1")
end

local v = fn() -- inferred equivalent call
local v2 = AppStorageService:GetItem("AppInstallationId")

local typeName = typeof(v2)

if typeName ~= "number" then
	if typeName == "string" and not (string.len(v2) <= 0) then
		v2 = tonumber((string.sub(v2, -2)))
	else
		v2 = nil
	end
end

local v3

if v2 == nil then
	v3 = v >= 100
else
	v3 = v2 % 100 + 1 <= v
end

local function fn2()
	return v3
end

local function fn3() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("ExperienceChatUserProfileApiEnabledForAll_v1")
end

return function()
	return fn3() or fn2() -- inferred equivalent call
end
