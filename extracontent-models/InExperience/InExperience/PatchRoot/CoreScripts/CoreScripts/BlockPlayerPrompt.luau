local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
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
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local onBlockButtonActivated = require(Modules.Settings.onBlockButtonActivated)

local Size150x150 = Enum.ThumbnailSize.Size150x150
local Size352x352 = Enum.ThumbnailSize.Size352x352

local HeadShot = Enum.ThumbnailType.HeadShot
local AvatarThumbnail = Enum.ThumbnailType.AvatarThumbnail

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

function DoPromptBlockPlayer(p)
	if BlockingUtility:IsPlayerBlockedByUserId(p.UserId) then
		return
	end

	onBlockButtonActivated(p)
end

function PromptBlockPlayer(player)
	if LocalPlayer.UserId < 0 then
		error("PromptBlockPlayer can not be called for guests!")
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("Invalid argument to PromptBlockPlayer")

		return
	end

	if player.UserId < 0 then
		error("PromptBlockPlayer can not be called on guests!")
	end

	if player == LocalPlayer then
		error("PromptBlockPlayer: A user can not block themselves!")
	end

	DoPromptBlockPlayer(player)
end

function DoPromptUnblockPlayer(p)
	local _ = not BlockingUtility:IsPlayerBlockedByUserId(p.UserId)

	local function promptCompletedCallback(p2)
		if p2 and not BlockingUtility:UnblockPlayerAsync(p) then
			while PromptCreator:IsCurrentlyPrompting() do
				wait()
			end

			PromptCreator:CreatePrompt({
				WindowTitle = "Error Unblocking User",
				MainText = string.format("An error occurred while unblocking %s. Please try again later.", p.Name),
				ConfirmationText = "Okay",
				Image = "",
				ImageConsoleVR = "",
				FetchImageFunction = createFetchImageFunction(p.UserId, Size150x150, HeadShot),
				FetchImageFunctionConsoleVR = createFetchImageFunction(p.UserId, Size352x352, AvatarThumbnail),
				StripeColor = Color3.fromRGB(183, 34, 54)
			})
		end
	end

	PromptCreator:CreatePrompt({
		WindowTitle = "Confirm Unblock",
		MainText = string.format("Would you like to unblock %s?", p.Name),
		ConfirmationText = "Unblock",
		CancelText = "Cancel",
		CancelActive = true,
		Image = "",
		ImageConsoleVR = "",
		FetchImageFunction = createFetchImageFunction(p.UserId, Size150x150, HeadShot),
		FetchImageFunctionConsoleVR = createFetchImageFunction(p.UserId, Size352x352, AvatarThumbnail),
		PromptCompletedCallback = promptCompletedCallback
	})
end

function PromptUnblockPlayer(player)
	if LocalPlayer.UserId < 0 then
		error("PromptUnblockPlayer can not be called for guests!")
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("Invalid argument to PromptUnblockPlayer")

		return
	end

	if player.UserId < 0 then
		error("PromptUnblockPlayer can not be called on guests!")
	end

	if player == LocalPlayer then
		error("PromptUnblockPlayer: A user can not block themselves!")
	end

	DoPromptUnblockPlayer(player)
end

function GetBlockedUserIds()
	if LocalPlayer.UserId < 0 then
		error("GetBlockedUserIds can not be called for guests!")
	end

	return BlockingUtility:GetBlockedUserIdsAsync()
end

StarterGui:RegisterSetCore("PromptBlockPlayer", PromptBlockPlayer)
StarterGui:RegisterSetCore("PromptUnblockPlayer", PromptUnblockPlayer)
StarterGui:RegisterGetCore("GetBlockedUserIds", GetBlockedUserIds)
