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
local defineFastFlag = game:DefineFastFlag("FriendRequestModalIxpEnabled", false)
local defineFastString = game:DefineFastString("FriendRequestModalIxpLayer", "")

local Thumbnail = LegacyThumbnailUrls.Thumbnail
local Bust = LegacyThumbnailUrls.Bust

local Size150x150 = Enum.ThumbnailSize.Size150x150
local Size352x352 = Enum.ThumbnailSize.Size352x352

local HeadShot = Enum.ThumbnailType.HeadShot
local AvatarThumbnail = Enum.ThumbnailType.AvatarThumbnail

local function LocalizedGetString(p, p2)
	pcall(function()
		p2 = RobloxTranslator:FormatByKey(p)
	end)
	return p2
end

function createFetchImageFunction(...)
	local v = { ... }
	return function(p)
		spawn(function()
			local playerImage = SocialUtil.GetPlayerImage(unpack(v))

			if p and p.Parent then
				p.Image = playerImage
			end
		end)
	end
end

function SendFriendRequest(p)
	RbxAnalyticsService:ReportCounter("FriendPlayerPrompt-RequestFriendship")
	RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "FriendPlayerPrompt")

	return (pcall(function()
		LocalPlayer:RequestFriendship(p)
	end))
end

function AtFriendLimit(p): boolean
	assert(
		not FFlagRemoveHardCodedFriendLimitPrompt,
		"Should not call AtFriendLimit when FFlagRemoveHardCodedFriendLimitPrompt is enabled"
	)

	local friendCountAsync = FriendingUtility:GetFriendCountAsync(p.UserId)

	return friendCountAsync ~= nil and FriendingUtility:MaxFriendCount() <= friendCountAsync
end

function DoPromptRequestFriendPlayer(p)
	if LocalPlayer:IsFriendsWithAsync(p.UserId) then
		return
	end

	if defineFastFlag then
		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
	end

	UserRelationshipModals.launchPromptFriendRequestModal(p.UserId)
end

function PromptRequestFriendPlayer(player)
	if LocalPlayer.UserId < 0 then
		error("PromptSendFriendRequest can not be called for guests!")
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("Invalid argument to PromptSendFriendRequest")

		return
	end

	if player.UserId < 0 then
		error("PromptSendFriendRequest can not be called on guests!")
	end

	if player == LocalPlayer then
		error("PromptSendFriendRequest: A user can not friend themselves!")
	end

	DoPromptRequestFriendPlayer(player)
end

function UnFriendPlayer(p)
	return (pcall(function()
		LocalPlayer:RevokeFriendship(p)
	end))
end

function DoPromptUnfriendPlayer(p)
	if not LocalPlayer:IsFriendsWithAsync(p.UserId) then
		return
	end

	local function promptCompletedCallback(p2)
		if p2 and not UnFriendPlayer(p) then
			while PromptCreator:IsCurrentlyPrompting() do
				wait()
			end

			PromptCreator:CreatePrompt({
				WindowTitle = "Error Unfriending Person",
				MainText = string.format("An error occurred while unfriending %s. Please try again later.", p.Name),
				ConfirmationText = "Okay",
				CancelActive = false,
				Image = "",
				ImageConsoleVR = "",
				FetchImageFunction = createFetchImageFunction(p.UserId, Size150x150, HeadShot),
				FetchImageFunctionConsoleVR = createFetchImageFunction(p.UserId, Size352x352, AvatarThumbnail),
				StripeColor = Color3.fromRGB(183, 34, 54)
			})
		end
	end

	PromptCreator:CreatePrompt({
		WindowTitle = "Unfriend Person?",
		MainText = string.format("Would you like to remove %s from your friends list?", p.Name),
		ConfirmationText = "Unfriend",
		CancelText = "Cancel",
		CancelActive = true,
		Image = "",
		ImageConsoleVR = "",
		FetchImageFunction = createFetchImageFunction(p.UserId, Size150x150, HeadShot),
		FetchImageFunctionConsoleVR = createFetchImageFunction(p.UserId, Size352x352, AvatarThumbnail),
		PromptCompletedCallback = promptCompletedCallback
	})
end

function PromptUnfriendPlayer(player)
	if LocalPlayer.UserId < 0 then
		error("PromptUnfriend can not be called for guests!")
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("Invalid argument to PromptUnfriend")

		return
	end

	if player.UserId < 0 then
		error("PromptUnfriend can not be called on guests!")
	end

	if player == LocalPlayer then
		error("PromptUnfriend: A user can not unfriend themselves!")
	end

	DoPromptUnfriendPlayer(player)
end

StarterGui:RegisterSetCore("PromptSendFriendRequest", PromptRequestFriendPlayer)
StarterGui:RegisterSetCore("PromptUnfriend", PromptUnfriendPlayer)
