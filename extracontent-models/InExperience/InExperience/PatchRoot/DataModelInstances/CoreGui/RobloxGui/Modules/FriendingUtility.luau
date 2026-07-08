local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local FFlagRemoveHardCodedFriendLimitPrompt = require(RobloxGui.Modules.Flags.FFlagRemoveHardCodedFriendLimitPrompt)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local t1 = {}

t1.__index = t1

local v9 = game:GetService("ContentProvider").BaseUrl:lower()
local v10 = string.gsub(v9, "http:", "https:")
local v11 = string.gsub(v10, "www", "friends") .. "v1/users/{userId}/friends/count"

function t1.GetFriendCountAsync(_, p2) -- line: 25
	-- upvalues: v11 (copy), HttpRbxApiService (copy), HttpService (copy)
	local count = nil
	local ok, result = pcall(function() -- line: 28
		-- upvalues: v11 (copy), p2 (copy), HttpRbxApiService (copy)
		local v23 = string.gsub(v11, "{userId}", (tostring(p2)))

		return HttpRbxApiService:GetAsyncFullUrl(v23)
	end)

	if not ok then
		print(v11, "failed because", result)

		return nil
	end

	local data = HttpService:JSONDecode(result)

	if data.count then
		count = data.count
	end

	return count
end
function t1.MaxFriendCount(_) -- line: 46
	-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy)
	assert(not FFlagRemoveHardCodedFriendLimitPrompt, "Should not call MaxFriendCount when FFlagRemoveHardCodedFriendLimitPrompt is enabled")

	return 200
end

local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")

LocalPlayer.FriendStatusChanged:connect(function(p4, p5) -- line: 54
	-- upvalues: BindableEvent (copy), BindableEvent2 (copy)
	if p5 == Enum.FriendStatus.Friend then
		BindableEvent:Fire(p4)

		return
	end

	if p5 == Enum.FriendStatus.NotFriend then
		BindableEvent2:Fire(p4)
	end
end)
StarterGui:RegisterGetCore("PlayerFriendedEvent", function() -- line: 62
	-- upvalues: BindableEvent (copy)
	return BindableEvent
end)
StarterGui:RegisterGetCore("PlayerUnfriendedEvent", function() -- line: 63
	-- upvalues: BindableEvent2 (copy)
	return BindableEvent2
end)

return t1
