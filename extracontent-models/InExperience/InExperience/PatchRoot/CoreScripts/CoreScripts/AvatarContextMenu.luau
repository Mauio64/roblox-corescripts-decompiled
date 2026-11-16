local RunService = game:GetService("RunService")
local isStudio = RunService:IsStudio()
local v = false

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService2 = game:GetService("RunService")
local Chat = game:GetService("Chat")
local CorePackages = game:GetService("CorePackages")

local v2 = false
function enableAvatarContextMenu(p)
	v = p and true or false

	if v and not v2 then
		v2 = true
		RbxAnalyticsService:TrackEvent("Game", "AvatarContextMenuEnabled", "placeId: " .. tostring(game.PlaceId))
	end
end

StarterGui:RegisterSetCore("SetAvatarContextMenuEnabled", enableAvatarContextMenu)
StarterGui:RegisterSetCore("AvatarContextMenuEnabled", enableAvatarContextMenu)

StarterGui:RegisterGetCore("AvatarContextMenuEnabled", function()
	return v
end)

local Modules = CoreGui.RobloxGui.Modules
local avatarContextMenu = Modules.AvatarContextMenu

local ContextMenuGui = require(avatarContextMenu.ContextMenuGui)
local ContextMenuItems = require(avatarContextMenu.ContextMenuItems)
local ContextMenuUtil = require(avatarContextMenu.ContextMenuUtil)
local SelectedCharacterIndicator = require(avatarContextMenu.SelectedCharacterIndicator)
local ThemeHandler = require(avatarContextMenu.ThemeHandler)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(Modules.BackpackScript)
end

local EmotesMenuMaster = require(Modules.EmotesMenu.EmotesMenuMaster)

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local FFlagAvatarContextMenuItemsChatButtonRefactor = require(Modules.Flags.FFlagAvatarContextMenuItemsChatButtonRefactor)

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRaycastUpdateAPI2")
end)

local LocalPlayer = Players.LocalPlayer
local v3 = success and result

while not LocalPlayer do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

if LocalPlayer.UserId <= 0 and not isStudio then
	return
end

local v4 = false

local flag = false
local v5 = nil

local v6 = nil
local v7 = nil

local v8 = nil

local selectedPlayerChangedConnection = nil

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local menuFrame = ContextMenuGui:CreateMenuFrame(ThemeHandler:GetTheme())
local v9 = ContextMenuItems.new(menuFrame.Content.ContextActionList)

function SetSelectedPlayer(p, p2)
	if v5 == p then
		return
	end

	v5 = p
	SelectedCharacterIndicator:ChangeSelectedPlayer(v5, ThemeHandler:GetTheme())

	if FFlagAvatarContextMenuItemsChatButtonRefactor then
		local success2, result2 = pcall(function()
			return Chat:CanUserChatAsync(LocalPlayer.UserId)
		end)
		local v10 = {
			["localPlayerChatEnabled"] = success2 and (RunService2:IsStudio() or result2),
			localPlayerCanChatWithSelectedPlayer = false
		}

		if v5 then
			v10.localPlayerCanChatWithSelectedPlayer = ContextMenuUtil:GetCanChatWith(v5)
		end

		v9:BuildContextMenuItems(v5, v10)
	else
		v9:BuildContextMenuItems(v5)
	end

	ContextMenuGui:SwitchToPlayerEntry(v5, p2)
end

function OpenMenu(p)
	v4 = true

	menuFrame.Visible = true
	menuFrame.Content.ContextActionList.CanvasPosition = Vector2.new(0, 0)
	menuFrame.Position = p.OffScreenPosition

	selectedPlayerChangedConnection = ContextMenuGui.SelectedPlayerChanged:connect(function()
		SetSelectedPlayer(ContextMenuGui:GetSelectedPlayer())
	end)

	menuFrame.Position = p.OffScreenPosition
	local tween = TweenService:Create(menuFrame, tweenInfo, { Position = p.OnScreenPosition })
	tween:Play()
	tween.Completed:wait()

	v4 = false
end

function BindMenuActions()
	ContextActionService:BindCoreAction("EscapeAvatarContextMenu", function(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		CloseContextMenu()
	end, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)

	ContextActionService:BindCoreAction("SwitchPageAvatarContextMenu", function(_, p, p2)
		if p == Enum.UserInputState.Begin then
			if p2.KeyCode == Enum.KeyCode.ButtonR1 then
				ContextMenuGui:OffsetPlayerEntry(1)
			elseif p2.KeyCode == Enum.KeyCode.ButtonL1 then
				ContextMenuGui:OffsetPlayerEntry(-1)
			end
		end
	end, false, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1)

	local menuOpenedConnection = nil
	menuOpenedConnection = GuiService.MenuOpened:connect(function()
		menuOpenedConnection:disconnect()

		if Enum.UserInputState.Begin ~= Enum.UserInputState.Begin then
			return
		end

		CloseContextMenu()
	end)
end

function BuildPlayerCarousel(_, p)
	local players = Players:GetPlayers()
	local v10 = {}

	for i = 1, #players do
		if not ((players[i].UserId > 0 or isStudio) and players[i] ~= LocalPlayer) then
			continue
		end

		local playerPosition = ContextMenuUtil:GetPlayerPosition(players[i])

		if not playerPosition then
			continue
		end

		local magnitude = (p - playerPosition).magnitude
		table.insert(v10, { players[i], magnitude })
	end

	local function closestPlayerComp(list, list2): boolean
		return list[2] > list2[2]
	end

	table.sort(v10, closestPlayerComp)

	ContextMenuGui:BuildPlayerCarousel(v10, ThemeHandler:GetTheme())
end

Players.PlayerRemoving:connect(function(p)
	if flag and p ~= v5 then
		ContextMenuGui:RemovePlayerEntry(p)
	end
end)

local function CloseOtherOpenCoreGui() -- 1 equivalent call inferred from this helper
	if EmotesMenuMaster:isOpen() then
		EmotesMenuMaster:close()
	end

	if FFlagEnableNewBackpack then
		features.setVisibility(features.FeatureName.Backpack, false)
	elseif BackpackScript.IsOpen then
		BackpackScript.OpenClose()
	end
end

function OpenContextMenu(p, p2)
	if v4 or flag or not v then
		return
	end

	flag = true
	CloseOtherOpenCoreGui() -- inferred equivalent call
	BuildPlayerCarousel(p, p2)
	ContextMenuUtil:DisablePlayerMovement()
	BindMenuActions()
	SetSelectedPlayer(p, true)

	ContextMenuGui:UpdateGuiTheme(ThemeHandler:GetTheme())
	OpenMenu(ThemeHandler:GetTheme())
end

function CloseContextMenu()
	GuiService.SelectedCoreObject = nil

	ContextActionService:UnbindCoreAction("EscapeAvatarContextMenu")
	ContextActionService:UnbindCoreAction("SwitchPageAvatarContextMenu")

	ContextMenuUtil:EnablePlayerMovement()

	if selectedPlayerChangedConnection then
		selectedPlayerChangedConnection:disconnect()
	end

	local tween = TweenService:Create(menuFrame, tweenInfo2, {
		Position = UDim2.new(0.5, 0, 1, menuFrame.AbsoluteSize.Y)
	})
	tween:Play()
	tween.Completed:wait()

	menuFrame.Visible = false
	SetSelectedPlayer(nil)
	flag = false
end
ContextMenuGui:SetCloseMenuFunc(CloseContextMenu)
local closeContextMenu = CloseContextMenu
v9:SetCloseMenuFunc(closeContextMenu)

local function isPointInside(p, absolutePosition, vector2): boolean -- 1 equivalent call inferred from this helper
	return p.X >= absolutePosition.X and p.X <= vector2.X and p.Y >= absolutePosition.Y and p.Y <= vector2.Y
end

function PointInSwipeArea(p)
	local absolutePosition = menuFrame.AbsolutePosition

	local nameTag = menuFrame.Content:FindFirstChild("NameTag")
	return isPointInside( -- inferred equivalent call
		p,
		absolutePosition,
		Vector2.new(absolutePosition.x + menuFrame.AbsoluteSize.x, nameTag.AbsolutePosition.y + nameTag.AbsoluteSize.y)
	)
end

function LocalPlayerHasToolEquipped(): boolean
	if not LocalPlayer.Character then
		return false
	end

	for _, backpackItem in ipairs(LocalPlayer.Character:GetChildren()) do
		if backpackItem:IsA("BackpackItem") then
			return true
		end
	end

	return false
end

function shouldIgnoreLocalCharacter()
	if LocalPlayer.Character then
		local head = LocalPlayer.Character:FindFirstChild("Head")

		if head and head:IsA("BasePart") then
			return head.LocalTransparencyModifier >= 0.95
		end
	end
end

function clickedOnPoint(p)
	local currentCamera = workspace.CurrentCamera

	if not currentCamera or LocalPlayerHasToolEquipped() then
		return
	end

	local screenPointToRay = currentCamera:ScreenPointToRay(p.X, p.Y)

	if v3 then
		raycastParams.FilterDescendantsInstances = shouldIgnoreLocalCharacter() and { LocalPlayer.Character } or {}
		local raycastResult = workspace:Raycast(
			screenPointToRay.Origin,
			screenPointToRay.Direction * 100,
			raycastParams
		)
		local v10

		if raycastResult then
			v10 = ContextMenuUtil:FindPlayerFromPart(raycastResult.Instance)
		end

		if v10 and (isStudio and v10 ~= LocalPlayer or v10 ~= LocalPlayer and v10.UserId > 0) then
			if flag then
				SetSelectedPlayer(v10)
			else
				OpenContextMenu(v10, raycastResult.Position)
			end
		elseif not v10 and flag then
			CloseContextMenu()
		end
	else
		local ray = Ray.new(screenPointToRay.Origin, screenPointToRay.Direction * 100)
		local v10, v11

		if shouldIgnoreLocalCharacter() then
			v10, v11 = workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
		else
			v10, v11 = workspace:FindPartOnRay(ray, nil, false, true)
		end

		local player = ContextMenuUtil:FindPlayerFromPart(v10)

		if player and (isStudio and player ~= LocalPlayer or player ~= LocalPlayer and player.UserId > 0) then
			if flag then
				SetSelectedPlayer(player)
			else
				OpenContextMenu(player, v11)
			end
		elseif not player and flag then
			CloseContextMenu()
		end
	end
end

function OnUserInput(p, p2)
	if p2.UserInputState == Enum.UserInputState.Begin and v6 == nil then
		v6 = p2
		v7 = p
	elseif v6 == p2 and p2.UserInputState == Enum.UserInputState.Change then
		if (p - v7).magnitude > 5 then
			v6 = nil
			v7 = nil
		end
	elseif p2.UserInputState == Enum.UserInputState.End and v6 == p2 then
		v6 = nil
		v7 = nil
		clickedOnPoint(p)
	end
end

function OnMouseMoved(p)
	if not flag and v6 and (p - v7).magnitude > 20 then
		v6 = nil
		v7 = nil
	end
end

function trackTouchSwipeInput(data)
	if data.UserInputType == Enum.UserInputType.Touch then
		if v8 or data.UserInputState ~= Enum.UserInputState.Begin then
			if v8 == data and data.UserInputState == Enum.UserInputState.End then
				spawn(function()
					v8 = nil
				end)
			end
		elseif PointInSwipeArea(data.Position) then
			v8 = data
		end
	end
end

local function functionProcessInput(p, p2)
	trackTouchSwipeInput(p)

	if p2 then
		if p == v6 then
			v6 = nil
		end
	elseif p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
		OnUserInput(Vector2.new(p.Position.X, p.Position.Y), p)
	elseif p.UserInputType == Enum.UserInputType.MouseMovement then
		OnMouseMoved(Vector2.new(p.Position.X, p.Position.Y))
	end
end

UserInputService.InputBegan:Connect(functionProcessInput)
UserInputService.InputChanged:Connect(functionProcessInput)
UserInputService.InputEnded:Connect(functionProcessInput)

UserInputService.TouchSwipe:Connect(function(p, _, p2)
	if not (p2 and flag and v8) then
		return
	end

	local v10 = p == Enum.SwipeDirection.Left and 1 or p == Enum.SwipeDirection.Right and -1 or 0

	if v10 ~= 0 then
		ContextMenuGui:OffsetPlayerEntry(v10)
		SetSelectedPlayer(ContextMenuGui:GetSelectedPlayer())
	end
end)

LocalPlayer.FriendStatusChanged:Connect(function(p, p2)
	if p and p == v5 then
		v9:UpdateFriendButton(p2, (BlockingUtility:IsPlayerBlockedByUserId(p.UserId)))
	end
end)

if FFlagEnableNewBackpack then
	features.onVisibilityChanged(features.FeatureName.Backpack, function(p)
		if p and flag then
			CloseContextMenu()
		end
	end)
else
	BackpackScript.StateChanged.Event:Connect(function(p)
		if p and flag then
			CloseContextMenu()
		end
	end)
end

EmotesMenuMaster.EmotesMenuToggled.Event:Connect(function(p)
	if p and flag then
		CloseContextMenu()
	end
end)

function GetWorldPoint(player)
	local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		return humanoidRootPart.Position
	end

	if player == LocalPlayer then
		return Vector3.new(0, 0, 0)
	end

	return GetWorldPoint(LocalPlayer)
end

StarterGui:RegisterGetCore("AvatarContextMenuTarget", function()
	return v5
end)

StarterGui:RegisterSetCore("AvatarContextMenuTarget", function(player)
	local v10

	if typeof(player) == "Instance" then
		v10 = player:IsA("Player")
	else
		v10 = false
	end

	if v10 then
		if player.Parent == nil then
			error("AvatarContextMenuTarget Player must be in the game")
		elseif flag or v4 then
			SetSelectedPlayer(player, true)
		else
			OpenContextMenu(player, GetWorldPoint(player))
		end
	elseif player == nil then
		CloseContextMenu()
	else
		error("AvatarContextMenuTarget argument must be a Player or nil")
	end
end)

local function getClosestPlayer()
	if not LocalPlayer.Character then
		return
	end

	local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return
	end

	local position = humanoidRootPart.Position

	local players = Players:GetPlayers()
	local v10 = 1e999
	local v11 = nil
	local position2 = nil

	for _, player in ipairs(players) do
		if not (player ~= LocalPlayer and player.Character) then
			continue
		end

		local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

		if not (humanoidRootPart2 and (humanoidRootPart2.Position - position).magnitude < v10) then
			continue
		end

		v10 = (humanoidRootPart2.Position - position).magnitude
		position2 = humanoidRootPart2.Position
		v11 = player
	end

	return v11, position2
end

local function gamepadOpenMenu(_, p, _)
	if not v or (GuiService.SelectedCoreObject or GuiService.SelectedObject) then
		return Enum.ContextActionResult.Pass
	end

	if p ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Sink
	end

	if flag then
		CloseContextMenu()
	else
		local closestPlayer, v10 = getClosestPlayer()

		if closestPlayer then
			OpenContextMenu(closestPlayer, v10)
		end
	end

	return Enum.ContextActionResult.Sink
end

ContextActionService:BindCoreAction("GamepadOpenAvatarContextMenu", gamepadOpenMenu, false, Enum.KeyCode.DPadUp)
