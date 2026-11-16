local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local FFlagRemoveHardCodedFriendLimitPrompt = require(RobloxGui.Modules.Flags.FFlagRemoveHardCodedFriendLimitPrompt)

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local FriendingUtility = {}
FriendingUtility.__index = FriendingUtility

local ContentProvider = game:GetService("ContentProvider")
local baseUrl = ContentProvider.BaseUrl:lower()
local v = string.gsub(baseUrl, "http:", "https:")
local v2 = string.gsub(v, "www", "friends") .. "v1/users/{userId}/friends/count"

function FriendingUtility.GetFriendCountAsync(_, p)
	local count = nil

	local success, result = pcall(function()
		return HttpRbxApiService:GetAsyncFullUrl((string.gsub(v2, "{userId}", (tostring(p)))))
	end)

	if not success then
		print(v2, "failed because", result)
		return nil
	end

	local jsonDecode = HttpService:JSONDecode(result)

	if jsonDecode.count then
		count = jsonDecode.count
	end

	return count
end

function FriendingUtility.MaxFriendCount(_): number
	assert(
		not FFlagRemoveHardCodedFriendLimitPrompt,
		"Should not call MaxFriendCount when FFlagRemoveHardCodedFriendLimitPrompt is enabled"
	)
	return 200
end

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")

LocalPlayer.FriendStatusChanged:connect(function(p, p2)
	if p2 == Enum.FriendStatus.Friend then
		bindableEvent:Fire(p)
	elseif p2 == Enum.FriendStatus.NotFriend then
		bindableEvent2:Fire(p)
	end
end)

StarterGui:RegisterGetCore("PlayerFriendedEvent", function()
	return bindableEvent
end)
StarterGui:RegisterGetCore("PlayerUnfriendedEvent", function()
	return bindableEvent2
end)

return FriendingUtility
