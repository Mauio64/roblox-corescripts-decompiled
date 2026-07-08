local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local default = nil
local React = require(CorePackages.Packages.React)
local default2 = require(CorePackages.Workspace.Packages.CallProtocol).CallProtocol.default
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local ContactList = RobloxGui.Modules.ContactList
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)

require(ContactList.Enums.Pages)

local EngineFeature = game:GetEngineFeature("EnableIrisRerouteToRCC")

return function(p1, p2, p3, p4, t1: {[any]: any}) -- line: 27
	-- upvalues: useAnalytics (copy), React (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), default (ref), RobloxGui (copy), FaceAnimatorService (copy), EventNamesEnum (copy), EngineFeature (copy), Players (copy), default2 (copy), HttpService (copy), RobloxReplicatedStorage (copy)
	local v23 = useAnalytics()

	return React.useCallback(function() -- line: 36
		-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy), default (ref), RobloxGui (copy), FaceAnimatorService (copy), v23 (copy), EventNamesEnum (copy), p2 (copy), t1 (copy), EngineFeature (copy), Players (copy), default2 (copy), p3 (copy), HttpService (copy), p1 (copy), RobloxReplicatedStorage (copy), p4 (copy)
		SoundManager:PlaySound(Sounds.Select.Name, {
			Volume = 0.5
		}, SoundGroups.Iris)

		if default == nil then
			default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
		end

		local v24 = default.localMuted == nil or default.localMuted
		local v25 = not not FaceAnimatorService:IsStarted() and FaceAnimatorService.VideoAnimationEnabled

		v23.fireEvent(EventNamesEnum.PhoneBookCallFriendClicked, {
			eventTimestampMs = os.time() * 1000,
			friendUserId = tonumber(p2),
			searchQueryString = t1.searchQueryString,
			itemListIndex = t1.itemListIndex,
			isSuggestedUser = t1.isSuggestedUser,
			page = tostring(t1.page)
		})

		if EngineFeature then
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer then
				default2:initCall(tonumber(LocalPlayer.UserId) or 0, tonumber(p2) or 0, LocalPlayer.DisplayName, p3, v24, v25, HttpService:GenerateGUID(false), p1)
			end
		else
			coroutine.wrap(function() -- line: 71
				-- upvalues: RobloxReplicatedStorage (copy), p1 (copy), p2 (copy), p3 (copy), v24 (copy), v25 (copy)
				RobloxReplicatedStorage:WaitForChild("ContactListInvokeIrisInvite", 1e999):FireServer(p1, tonumber(p2), p3, v24, v25)
			end)()
		end

		p4()
	end, {
		p1,
		p2,
		p3,
		p4,
		t1
	})
end
