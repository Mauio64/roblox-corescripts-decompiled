local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui.RobloxGui
local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local Modules = RobloxGui.Modules
local PromptCreator = require(Modules.PromptCreator)
local SocialUtil = require(Modules.SocialUtil)
local FriendingUtility = require(Modules.FriendingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local UserRelationshipModals = require(CorePackages.Workspace.Packages.UserRelationshipModals)
local LegacyThumbnailUrls = require(Modules.Common.LegacyThumbnailUrls)
local FFlagRemoveHardCodedFriendLimitPrompt = require(Modules.Flags.FFlagRemoveHardCodedFriendLimitPrompt)
local v17 = game:DefineFastFlag("FriendRequestModalRevampV4", false)
local v18 = game:DefineFastFlag("FriendRequestModalIxpEnabled", false)
local v19 = game:DefineFastString("FriendRequestModalIxpLayer", "")
local _ = LegacyThumbnailUrls.Thumbnail
local _ = LegacyThumbnailUrls.Bust
local Size150x150 = Enum.ThumbnailSize.Size150x150
local Size352x352 = Enum.ThumbnailSize.Size352x352
local HeadShot = Enum.ThumbnailType.HeadShot
local AvatarThumbnail = Enum.ThumbnailType.AvatarThumbnail

local function LocalizedGetString(p1, p2) -- line: 50
	-- upvalues: RobloxTranslator (copy)
	pcall(function() -- line: 51
		-- upvalues: p2 (ref), RobloxTranslator (copy), p1 (copy)
		p2 = RobloxTranslator:FormatByKey(p1)
	end)

	return p2
end

function createFetchImageFunction(...) -- line: 57
	-- upvalues: SocialUtil (copy)
	local t1 = { ... }

	return function(p3) -- line: 59
		-- upvalues: SocialUtil (copy), t1 (copy)
		spawn(function() -- line: 60
			-- upvalues: SocialUtil (copy), t1 (copy), p3 (copy)
			local v49 = SocialUtil.GetPlayerImage(unpack(t1))

			if p3 and p3.Parent then
				p3.Image = v49
			end
		end)
	end
end
function SendFriendRequest(p4) -- line: 69
	-- upvalues: RbxAnalyticsService (copy), LocalPlayer (ref)
	RbxAnalyticsService:ReportCounter("FriendPlayerPrompt-RequestFriendship")
	RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "FriendPlayerPrompt")

	return (pcall(function() -- line: 73
		-- upvalues: LocalPlayer (ref), p4 (copy)
		LocalPlayer:RequestFriendship(p4)
	end))
end
function AtFriendLimit(p5) -- line: 79
	-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy), FriendingUtility (copy)
	assert(not FFlagRemoveHardCodedFriendLimitPrompt, "Should not call AtFriendLimit when FFlagRemoveHardCodedFriendLimitPrompt is enabled")

	local FriendCountAsync = FriendingUtility:GetFriendCountAsync(p5.UserId)

	if FriendCountAsync == nil then
		return false
	end

	if FriendCountAsync >= FriendingUtility:MaxFriendCount() then
		return true
	end

	return false
end
function DoPromptRequestFriendPlayer(p6) -- line: 94
	-- upvalues: LocalPlayer (ref), v18 (copy), IXPService (copy), v19 (copy), v17 (copy), UserRelationshipModals (copy), FFlagRemoveHardCodedFriendLimitPrompt (copy), PromptCreator (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy), RobloxTranslator (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		if LocalPlayer:IsFriendsWithAsync(p6.UserId) then
			return
		end
	elseif LocalPlayer:IsFriendsWith(p6.UserId) then
		return
	end

	if v18 then
		IXPService:LogFlagLinkedUserLayerExposure(v19)
	end

	if v17 then
		UserRelationshipModals.launchPromptFriendRequestModal(p6.UserId)

		return
	end

	local function promptCompletedCallback(p7) -- line: 117
		-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy), LocalPlayer (ref), PromptCreator (copy), p6 (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy)
		if p7 then
			if not FFlagRemoveHardCodedFriendLimitPrompt and AtFriendLimit(LocalPlayer) then
				while PromptCreator:IsCurrentlyPrompting() do
					wait()
				end

				PromptCreator:CreatePrompt({
					WindowTitle = "Friend Limit Reached",
					MainText = "You can not send a friend request because you are at the max friend limit.",
					ConfirmationText = "Okay",
					CancelActive = false,
					Image = "",
					ImageConsoleVR = "",
					FetchImageFunction = createFetchImageFunction(p6.UserId, Size150x150, HeadShot),
					FetchImageFunctionConsoleVR = createFetchImageFunction(p6.UserId, Size352x352, AvatarThumbnail),
					StripeColor = Color3.fromRGB(183, 34, 54)
				})

				return
			end

			if not FFlagRemoveHardCodedFriendLimitPrompt and AtFriendLimit(p6) then
				local v45 = string.format("You can not send a friend request to %s because they are at the max friend limit.", p6.Name)

				PromptCreator:CreatePrompt({
					WindowTitle = "Error Sending Friend Request",
					ConfirmationText = "Okay",
					CancelActive = false,
					Image = "",
					ImageConsoleVR = "",
					MainText = v45,
					FetchImageFunction = createFetchImageFunction(p6.UserId, Size150x150, HeadShot),
					FetchImageFunctionConsoleVR = createFetchImageFunction(p6.UserId, Size352x352, AvatarThumbnail),
					StripeColor = Color3.fromRGB(183, 34, 54)
				})

				return
			end

			if not SendFriendRequest(p6) then
				while PromptCreator:IsCurrentlyPrompting() do
					wait()
				end

				local v46 = string.format("An error occurred while sending %s a friend request. Please try again later.", p6.Name)

				PromptCreator:CreatePrompt({
					WindowTitle = "Error Sending Friend Request",
					ConfirmationText = "Okay",
					CancelActive = false,
					Image = "",
					ImageConsoleVR = "",
					MainText = v46,
					FetchImageFunction = createFetchImageFunction(p6.UserId, Size150x150, HeadShot),
					FetchImageFunctionConsoleVR = createFetchImageFunction(p6.UserId, Size352x352, AvatarThumbnail),
					StripeColor = Color3.fromRGB(183, 34, 54)
				})
			end
		end
	end

	local v36 = string.format("Would you like to send %s a Friend Request?", p6.Name)

	PromptCreator:CreatePrompt({
		ConfirmationText = "Send Request",
		CancelText = "Cancel",
		CancelActive = true,
		Image = "",
		ImageConsoleVR = "",
		WindowTitle = RobloxTranslator:FormatByKey("InGame.FriendPlayerPrompt.Title.SendFriendRequest"),
		MainText = v36,
		FetchImageFunction = createFetchImageFunction(p6.UserId, Size150x150, HeadShot),
		FetchImageFunctionConsoleVR = createFetchImageFunction(p6.UserId, Size352x352, AvatarThumbnail),
		PromptCompletedCallback = promptCompletedCallback
	})
end
function PromptRequestFriendPlayer(p8) -- line: 230
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.UserId < 0 then
		error("PromptSendFriendRequest can not be called for guests!")
	end

	if typeof(p8) == "Instance" and p8:IsA("Player") then
		if p8.UserId < 0 then
			error("PromptSendFriendRequest can not be called on guests!")
		end

		if p8 == LocalPlayer then
			error("PromptSendFriendRequest: A user can not friend themselves!")
		end

		DoPromptRequestFriendPlayer(p8)

		return
	end

	error("Invalid argument to PromptSendFriendRequest")
end
function UnFriendPlayer(p9) -- line: 247
	-- upvalues: LocalPlayer (ref)
	return (pcall(function() -- line: 248
		-- upvalues: LocalPlayer (ref), p9 (copy)
		LocalPlayer:RevokeFriendship(p9)
	end))
end
function DoPromptUnfriendPlayer(p10) -- line: 254
	-- upvalues: LocalPlayer (ref), PromptCreator (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		if not LocalPlayer:IsFriendsWithAsync(p10.UserId) then
			return
		end
	elseif not LocalPlayer:IsFriendsWith(p10.UserId) then
		return
	end

	local function promptCompletedCallback(p11) -- line: 268
		-- upvalues: p10 (copy), PromptCreator (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy)
		if p11 and not UnFriendPlayer(p10) then
			while PromptCreator:IsCurrentlyPrompting() do
				wait()
			end

			local v48 = string.format("An error occurred while unfriending %s. Please try again later.", p10.Name)

			PromptCreator:CreatePrompt({
				WindowTitle = "Error Unfriending Person",
				ConfirmationText = "Okay",
				CancelActive = false,
				Image = "",
				ImageConsoleVR = "",
				MainText = v48,
				FetchImageFunction = createFetchImageFunction(p10.UserId, Size150x150, HeadShot),
				FetchImageFunctionConsoleVR = createFetchImageFunction(p10.UserId, Size352x352, AvatarThumbnail),
				StripeColor = Color3.fromRGB(183, 34, 54)
			})
		end
	end

	local v41 = string.format("Would you like to remove %s from your friends list?", p10.Name)

	PromptCreator:CreatePrompt({
		WindowTitle = "Unfriend Person?",
		ConfirmationText = "Unfriend",
		CancelText = "Cancel",
		CancelActive = true,
		Image = "",
		ImageConsoleVR = "",
		MainText = v41,
		FetchImageFunction = createFetchImageFunction(p10.UserId, Size150x150, HeadShot),
		FetchImageFunctionConsoleVR = createFetchImageFunction(p10.UserId, Size352x352, AvatarThumbnail),
		PromptCompletedCallback = promptCompletedCallback
	})
end
function PromptUnfriendPlayer(p12) -- line: 328
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.UserId < 0 then
		error("PromptUnfriend can not be called for guests!")
	end

	if typeof(p12) == "Instance" and p12:IsA("Player") then
		if p12.UserId < 0 then
			error("PromptUnfriend can not be called on guests!")
		end

		if p12 == LocalPlayer then
			error("PromptUnfriend: A user can not unfriend themselves!")
		end

		DoPromptUnfriendPlayer(p12)

		return
	end

	error("Invalid argument to PromptUnfriend")
end

StarterGui:RegisterSetCore("PromptSendFriendRequest", PromptRequestFriendPlayer)
StarterGui:RegisterSetCore("PromptUnfriend", PromptUnfriendPlayer)
