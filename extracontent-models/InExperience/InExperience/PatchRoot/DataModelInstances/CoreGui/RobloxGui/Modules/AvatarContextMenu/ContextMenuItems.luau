local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local TextChatService = game:GetService("TextChatService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local AvatarContextMenu = Modules:WaitForChild("AvatarContextMenu")
local ContextMenuUtil = require(AvatarContextMenu:WaitForChild("ContextMenuUtil"))
local ThemeHandler = require(AvatarContextMenu.ThemeHandler)

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local FFlagAvatarContextMenuItemsChatButtonRefactor = require(Modules.Flags.FFlagAvatarContextMenuItemsChatButtonRefactor)

local FFlagWhisperEmoteOnAvatarContextMenuWithExpChat = require(Modules.Common.Flags.FFlagWhisperEmoteOnAvatarContextMenuWithExpChat)

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v = {
	[Enum.AvatarContextMenuOption.Chat] = true,
	[Enum.AvatarContextMenuOption.Friend] = true,
	[Enum.AvatarContextMenuOption.Emote] = true,
	[Enum.AvatarContextMenuOption.InspectMenu] = true
}

local v2 = {}
local count = 0

local ContextMenuItems = {}
ContextMenuItems.__index = ContextMenuItems

function ContextMenuItems:UpdateInspectMenuEnabled()
	local inspectMenuEnabled = GuiService:GetInspectMenuEnabled()

	if inspectMenuEnabled ~= v[Enum.AvatarContextMenuOption.InspectMenu] then
		v[Enum.AvatarContextMenuOption.InspectMenu] = inspectMenuEnabled
	end
end

function ContextMenuItems:ClearMenuItems()
	local children = self.MenuItemFrame:GetChildren()

	for i = 1, #children do
		if children[i]:IsA("GuiObject") then
			children[i]:Destroy()
		end
	end
end

function ContextMenuItems:AddCustomAvatarMenuItem(p, event)
	count += 1
	v2[p] = { event = event, layoutOrder = count }
end

function ContextMenuItems:RemoveCustomAvatarMenuItem(p)
	v2[p] = nil
end

function ContextMenuItems:IsContextAvatarEnumItem(p): boolean
	local enumItems = Enum.AvatarContextMenuOption:GetEnumItems()

	for i = 1, #enumItems do
		if p == enumItems[i] then
			return true
		end
	end

	return false
end

function ContextMenuItems:EnableDefaultMenuItem(p)
	v[p] = true
end

function ContextMenuItems:RemoveDefaultMenuItem(p)
	v[p] = false
end

function ContextMenuItems:RegisterCoreMethods()
	local function addMenuItemFunc(value)
		if type(value) == "table" then
			local v3 = ""

			if value[1] and type(value[1]) == "string" then
				v3 = value[1]
			else
				error("AddAvatarContextMenuOption first argument must be a table or Enum.AvatarContextMenuOption")
			end

			if value[2] and typeof(value[2]) == "Instance" and value[2].ClassName == "BindableEvent" then
				self:AddCustomAvatarMenuItem(v3, value[2])
			else
				error("AddAvatarContextMenuOption second table entry must be a BindableEvent")
			end
		elseif typeof(value) ~= "EnumItem" then
			error("AddAvatarContextMenuOption first argument must be a table or Enum.AvatarContextMenuOption")
		elseif self:IsContextAvatarEnumItem(value) then
			self:EnableDefaultMenuItem(value)
		else
			error("AddAvatarContextMenuOption given EnumItem is not valid")
		end
	end
	StarterGui:RegisterSetCore("AddAvatarContextMenuOption", addMenuItemFunc)
	local function removeMenuItemFunc(value)
		if type(value) == "string" then
			self:RemoveCustomAvatarMenuItem(value)
		elseif typeof(value) ~= "EnumItem" then
			error("RemoveAvatarContextMenuOption first argument must be a string or Enum.AvatarContextMenuOption")
		elseif self:IsContextAvatarEnumItem(value) then
			self:RemoveDefaultMenuItem(value)
		else
			error("RemoveAvatarContextMenuOption given EnumItem is not valid")
		end
	end
	StarterGui:RegisterSetCore("RemoveAvatarContextMenuOption", removeMenuItemFunc)
end

function ContextMenuItems:CreateCustomMenuItems()
	for k, v3 in pairs(v2) do
		RbxAnalyticsService:TrackEvent("Game", "AvatarContextMenuCustomButton", "name: " .. tostring(k))
		local function customButtonFunc()
			if self.CloseMenuFunc then
				self:CloseMenuFunc()
			end

			v3.event:Fire(self.SelectedPlayer)
		end
		local customButton = ContextMenuUtil:MakeStyledButton(
			"CustomButton",
			GameTranslator:TranslateGameText(self.MenuItemFrame, k),
			UDim2.new(0.96, 0, 0, 52),
			customButtonFunc,
			ThemeHandler:GetTheme()
		)

		customButton.Name = "CustomButton"
		customButton.LayoutOrder = v3.layoutOrder
		customButton.Parent = self.MenuItemFrame
	end
end

local v3 = "Add Friend"
local text = "Friends"
local text2 = "Friend Request Pending"
local text3 = "Accept Friend Request"
local text4 = "Player Blocked"

function ContextMenuItems:CreateFriendButton(p, p2)
	v3 = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.AddFriend")
	text = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.Friends")
	text2 = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.FriendRequestPending")
	text3 = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.AcceptFriendRequest")
	text4 = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.PlayerBlocked")

	local v4 = self.MenuItemFrame:FindFirstChild("FriendStatus")

	if v4 then
		v4:Destroy()
		v4 = nil
	end

	local v5 = nil

	local function fn()
		if v5 and v4.Selectable then
			v4.Selectable = false
			v5.TextTransparency = 0.75
			v5.Text = text2
			RbxAnalyticsService:ReportCounter("AvatarContextMenu-RequestFriendship")
			RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "AvatarContextMenu")
			LocalPlayer:RequestFriendship(self.SelectedPlayer)
		end
	end

	v4, v5 = ContextMenuUtil:MakeStyledButton(
		"FriendStatus",
		v3,
		UDim2.new(0.96, 0, 0, 52),
		fn,
		ThemeHandler:GetTheme()
	)

	if p2 then
		v4.Selectable = false
		v5.TextTransparency = 0.75
		v5.Text = text4
	elseif p == Enum.FriendStatus.Friend then
		v4.Selectable = false
		v5.TextTransparency = 0.75
		v5.Text = text
	elseif p == Enum.FriendStatus.FriendRequestSent then
		v4.Selectable = false
		v5.TextTransparency = 0.75
		v5.Text = text2
	elseif p == Enum.FriendStatus.FriendRequestReceived then
		v5.Text = text3
	else
		v4.Selectable = true
		v5.TextTransparency = 0
	end

	v4.LayoutOrder = count + 1
	v4.Parent = self.MenuItemFrame
end

function ContextMenuItems:UpdateFriendButton(p, p2)
	if self.MenuItemFrame:FindFirstChild("FriendStatus") then
		self:CreateFriendButton(p, p2)
	end
end

function ContextMenuItems:CreateInspectAndBuyButton()
	local function browseItems()
		if self.CloseMenuFunc then
			self:CloseMenuFunc()
		end

		if v[Enum.AvatarContextMenuOption.InspectMenu] then
			GuiService:InspectPlayerFromUserIdWithCtx(self.SelectedPlayer.UserId, "avatarContextMenu")
		else
			warn("The Inspect Menu is not currently available.")
		end
	end
	local styledButton = ContextMenuUtil:MakeStyledButton(
		"View",
		RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.View"),
		UDim2.new(0.96, 0, 0, 52),
		browseItems,
		ThemeHandler:GetTheme()
	)

	styledButton.LayoutOrder = count + 4
	styledButton.Parent = self.MenuItemFrame
end

local function findFirstTextChannel()
	local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if rbxGeneral then
		return rbxGeneral
	end

	for _, textSource in ipairs(TextChatService:GetDescendants()) do
		if not (textSource:IsA("TextSource") and textSource.UserId == Players.LocalPlayer.UserId and textSource.CanSend == true) then
			continue
		end

		local parent = textSource.Parent

		if parent:IsA("TextChannel") then
			return parent
		end
	end

	return nil
end

local function isExperienceChatOn(p): boolean
	local success, _ = pcall(function()
		local _legacyChatService = Enum.ChatVersion.LegacyChatService
	end)

	if success and p.ChatVersion == Enum.ChatVersion.TextChatService then
		return true
	end

	return false
end

function ContextMenuItems:CreateEmoteButton()
	local function wave()
		if self.CloseMenuFunc then
			self:CloseMenuFunc()
		end

		RbxAnalyticsService:ReportCounter("AvatarContextMenu-Wave")
		RbxAnalyticsService:TrackEvent("Game", "AvatarContextMenuWave", "placeId: " .. tostring(game.PlaceId))

		Players:Chat("/e wave")

		local textChatService = self.TextChatService
		local success, _ = pcall(function()
			local _legacyChatService = Enum.ChatVersion.LegacyChatService
		end)

		local v4 = (success and textChatService.ChatVersion == Enum.ChatVersion.TextChatService and true or false)
			and findFirstTextChannel()

		if v4 then
			v4:SendAsync("/e wave")
		end
	end

	local styledButton = ContextMenuUtil:MakeStyledButton(
		"Wave",
		RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.Wave"),
		UDim2.new(0.96, 0, 0, 52),
		wave,
		ThemeHandler:GetTheme()
	)

	styledButton.LayoutOrder = count + 5
	styledButton.Parent = self.MenuItemFrame
end

local interface = t.interface({
	localPlayerChatEnabled = t.boolean,
	localPlayerCanChatWithSelectedPlayer = t.boolean
})

function ContextMenuItems:CreateChatButton(p)
	local v4 = FFlagWhisperEmoteOnAvatarContextMenuWithExpChat

	if not v4 then
		local textChatService = self.TextChatService
		local success, _ = pcall(function()
			local _legacyChatService = Enum.ChatVersion.LegacyChatService
		end)

		if success and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			return
		end
	end

	local flag = false
	local function chatFunc()
		if flag then
			return
		end

		if self.CloseMenuFunc then
			self:CloseMenuFunc()
		end

		RbxAnalyticsService:ReportCounter("AvatarContextMenu-Chat")
		RbxAnalyticsService:TrackEvent("Game", "AvatarContextMenuChat", "placeId: " .. tostring(game.PlaceId))

		if v4 then
			local textChatService = self.TextChatService
			local success, _ = pcall(function()
				local _legacyChatService = Enum.ChatVersion.LegacyChatService
			end)

			if success and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
				local firstTextChannel = findFirstTextChannel()

				if not firstTextChannel then
					return
				end

				task.spawn(function()
					firstTextChannel:SendAsync("/w @" .. self.SelectedPlayer.Name)
				end)

				if ExpChat.Events and ExpChat.Events.AvatarContextMenuWhisperSelected then
					ExpChat.Events.AvatarContextMenuWhisperSelected()
					return
				end

				return
			end
		end

		local ChatSelector = require(RobloxGui.Modules.ChatSelector)
		ChatSelector:SetVisible(true)

		if not ChatSelector:EnterWhisperState(self.SelectedPlayer) then
			local chatBar = nil
			pcall(function()
				chatBar = LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
			end)

			if chatBar then
				chatBar.Text = "/w " .. self.SelectedPlayer.Name
			end

			ChatSelector:FocusChatBar()
		end
	end

	local styledButton, v5 = ContextMenuUtil:MakeStyledButton(
		"ChatStatus",
		RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.Chat"),
		UDim2.new(0.96, 0, 0, 52),
		chatFunc,
		ThemeHandler:GetTheme()
	)

	styledButton.LayoutOrder = count + 3
	local v6

	if FFlagAvatarContextMenuItemsChatButtonRefactor then
		ArgCheck.assert(interface(p))
		v6 = p.localPlayerChatEnabled
	else
		local success, result = pcall(function()
			return Chat:CanUserChatAsync(LocalPlayer.UserId)
		end)

		v6 = success and (RunService:IsStudio() or result)
	end

	if v6 then
		styledButton.Parent = self.MenuItemFrame
		local v7

		if FFlagAvatarContextMenuItemsChatButtonRefactor then
			v7 = p.localPlayerCanChatWithSelectedPlayer
		else
			v7 = ContextMenuUtil:GetCanChatWith(self.SelectedPlayer)
		end

		if not v7 then
			flag = true
			styledButton.Selectable = false
			v5.TextTransparency = 0.75
			v5.Text = RobloxTranslator:FormatByKey("Corescripts.AvatarContextMenu.ChatDisabled")
		end
	else
		styledButton.Parent = nil
	end
end

function ContextMenuItems:RemoveLastButtonUnderline()
	local children = self.MenuItemFrame:GetChildren()
	local v4 = -1
	local v5 = nil

	for _, guiObject in pairs(children) do
		if not (guiObject:IsA("GuiObject") and v4 < guiObject.LayoutOrder) then
			continue
		end

		v4 = guiObject.LayoutOrder
		v5 = guiObject
	end

	local underline = v5 and v5:FindFirstChild("Underline")

	if underline then
		underline:Destroy()
	end
end

function ContextMenuItems:BuildContextMenuItems(p, p2)
	if not p then
		return
	end

	local friendStatus = ContextMenuUtil:GetFriendStatus(p)
	local isPlayerBlockedByUserId = BlockingUtility:IsPlayerBlockedByUserId(p.UserId)
	self:ClearMenuItems()
	self:SetSelectedPlayer(p)

	if v[Enum.AvatarContextMenuOption.Friend] then
		self:CreateFriendButton(friendStatus, isPlayerBlockedByUserId)
	end

	if v[Enum.AvatarContextMenuOption.Chat] then
		self:CreateChatButton(p2)
	end

	if v[Enum.AvatarContextMenuOption.Emote] then
		self:CreateEmoteButton()
	end

	if v[Enum.AvatarContextMenuOption.InspectMenu] then
		self:CreateInspectAndBuyButton()
	end

	self:CreateCustomMenuItems()

	self:RemoveLastButtonUnderline()
end

function ContextMenuItems:SetSelectedPlayer(selectedPlayer)
	self.SelectedPlayer = selectedPlayer
end

function ContextMenuItems:SetCloseMenuFunc(closeMenuFunc)
	self.CloseMenuFunc = closeMenuFunc
end

function ContextMenuItems.new(menuItemFrame, p)
	local self = setmetatable({}, ContextMenuItems)

	self.MenuItemFrame = menuItemFrame
	self.SelectedPlayer = nil
	self.TextChatService = p and p.TextChatService or TextChatService
	self:RegisterCoreMethods()

	ContextMenuItems:UpdateInspectMenuEnabled()

	return self
end

GuiService.InspectMenuEnabledChangedSignal:Connect(function(p)
	if p then
		ContextMenuItems:EnableDefaultMenuItem(Enum.AvatarContextMenuOption.InspectMenu)
	else
		ContextMenuItems:RemoveDefaultMenuItem(Enum.AvatarContextMenuOption.InspectMenu)
	end
end)

return ContextMenuItems
