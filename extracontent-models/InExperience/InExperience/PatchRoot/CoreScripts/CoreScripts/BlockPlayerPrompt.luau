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

function createFetchImageFunction(...) -- line: 33
	-- upvalues: SocialUtil (copy)
	local t1 = { ... }

	return function(p1) -- line: 35
		-- upvalues: SocialUtil (copy), t1 (copy)
		spawn(function() -- line: 36
			-- upvalues: SocialUtil (copy), t1 (copy), p1 (copy)
			local v24 = SocialUtil.GetPlayerImage(unpack(t1))

			if p1 and p1.Parent then
				p1.Image = v24
			end
		end)
	end
end
function DoPromptBlockPlayer(p2) -- line: 45
	-- upvalues: BlockingUtility (copy), onBlockButtonActivated (copy)
	if BlockingUtility:IsPlayerBlockedByUserId(p2.UserId) then
		return
	end

	onBlockButtonActivated(p2)
end
function PromptBlockPlayer(p3) -- line: 53
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.UserId < 0 then
		error("PromptBlockPlayer can not be called for guests!")
	end

	if typeof(p3) == "Instance" and p3:IsA("Player") then
		if p3.UserId < 0 then
			error("PromptBlockPlayer can not be called on guests!")
		end

		if p3 == LocalPlayer then
			error("PromptBlockPlayer: A user can not block themselves!")
		end

		DoPromptBlockPlayer(p3)

		return
	end

	error("Invalid argument to PromptBlockPlayer")
end
function DoPromptUnblockPlayer(p4) -- line: 70
	-- upvalues: BlockingUtility (copy), PromptCreator (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy)
	BlockingUtility:IsPlayerBlockedByUserId(p4.UserId)

	local function promptCompletedCallback(p5) -- line: 78
		-- upvalues: BlockingUtility (copy), p4 (copy), PromptCreator (copy), Size150x150 (copy), HeadShot (copy), Size352x352 (copy), AvatarThumbnail (copy)
		if p5 and not BlockingUtility:UnblockPlayerAsync(p4) then
			while PromptCreator:IsCurrentlyPrompting() do
				wait()
			end

			PromptCreator:CreatePrompt({
				WindowTitle = "Error Unblocking User",
				ConfirmationText = "Okay",
				Image = "",
				ImageConsoleVR = "",
				MainText = string.format("An error occurred while unblocking %s. Please try again later.", p4.Name),
				FetchImageFunction = createFetchImageFunction(p4.UserId, Size150x150, HeadShot),
				FetchImageFunctionConsoleVR = createFetchImageFunction(p4.UserId, Size352x352, AvatarThumbnail),
				StripeColor = Color3.fromRGB(183, 34, 54)
			})
		end
	end

	PromptCreator:CreatePrompt({
		WindowTitle = "Confirm Unblock",
		ConfirmationText = "Unblock",
		CancelText = "Cancel",
		CancelActive = true,
		Image = "",
		ImageConsoleVR = "",
		MainText = string.format("Would you like to unblock %s?", p4.Name),
		FetchImageFunction = createFetchImageFunction(p4.UserId, Size150x150, HeadShot),
		FetchImageFunctionConsoleVR = createFetchImageFunction(p4.UserId, Size352x352, AvatarThumbnail),
		PromptCompletedCallback = promptCompletedCallback
	})
end
function PromptUnblockPlayer(p6) -- line: 113
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.UserId < 0 then
		error("PromptUnblockPlayer can not be called for guests!")
	end

	if typeof(p6) == "Instance" and p6:IsA("Player") then
		if p6.UserId < 0 then
			error("PromptUnblockPlayer can not be called on guests!")
		end

		if p6 == LocalPlayer then
			error("PromptUnblockPlayer: A user can not block themselves!")
		end

		DoPromptUnblockPlayer(p6)

		return
	end

	error("Invalid argument to PromptUnblockPlayer")
end
function GetBlockedUserIds() -- line: 130
	-- upvalues: LocalPlayer (ref), BlockingUtility (copy)
	if LocalPlayer.UserId < 0 then
		error("GetBlockedUserIds can not be called for guests!")
	end

	return BlockingUtility:GetBlockedUserIdsAsync()
end

StarterGui:RegisterSetCore("PromptBlockPlayer", PromptBlockPlayer)
StarterGui:RegisterSetCore("PromptUnblockPlayer", PromptUnblockPlayer)
StarterGui:RegisterGetCore("GetBlockedUserIds", GetBlockedUserIds)
