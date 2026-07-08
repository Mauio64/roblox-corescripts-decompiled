local v1 = game:GetService("RunService"):IsStudio()
local u2 = false
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
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")
local CorePackages = game:GetService("CorePackages")
local u16 = false

function enableAvatarContextMenu(p1) -- line: 42
	-- upvalues: u2 (ref), u16 (ref), RbxAnalyticsService (copy)
	u2 = not not p1

	if u2 and not u16 then
		u16 = true
		RbxAnalyticsService:TrackEvent("Game", "AvatarContextMenuEnabled", "placeId: " .. tostring(game.PlaceId))
	end
end

StarterGui:RegisterSetCore("SetAvatarContextMenuEnabled", enableAvatarContextMenu)
StarterGui:RegisterSetCore("AvatarContextMenuEnabled", enableAvatarContextMenu)
StarterGui:RegisterGetCore("AvatarContextMenuEnabled", function() -- line: 53
	-- upvalues: u2 (ref)
	return u2
end)

local Modules = CoreGui.RobloxGui.Modules
local AvatarContextMenu = Modules.AvatarContextMenu
local ContextMenuGui = require(AvatarContextMenu.ContextMenuGui)
local ContextMenuItems = require(AvatarContextMenu.ContextMenuItems)
local ContextMenuUtil = require(AvatarContextMenu.ContextMenuUtil)
local SelectedCharacterIndicator = require(AvatarContextMenu.SelectedCharacterIndicator)
local ThemeHandler = require(AvatarContextMenu.ThemeHandler)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v25 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v26 = if FFlagEnableNewBackpack then nil else require(Modules.BackpackScript)
local EmotesMenuMaster = require(Modules.EmotesMenu.EmotesMenuMaster)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local FFlagAvatarContextMenuItemsChatButtonRefactor = require(Modules.Flags.FFlagAvatarContextMenuItemsChatButtonRefactor)
local ok, result = pcall(function() -- line: 78
	return UserSettings():IsUserFeatureEnabled("UserRaycastUpdateAPI2")
end)
local u32 = ok and result
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

if LocalPlayer.UserId <= 0 and not v1 then
	return
end

local u34 = false
local u35 = false
local u36 = nil
local u37 = nil
local u38 = nil
local u39 = nil
local u40 = nil
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local u42 = ContextMenuGui:CreateMenuFrame(ThemeHandler:GetTheme())
local u43 = ContextMenuItems.new(u42.Content.ContextActionList)

function SetSelectedPlayer(p2, p3) -- line: 116
	-- upvalues: u36 (ref), SelectedCharacterIndicator (copy), ThemeHandler (copy), FFlagAvatarContextMenuItemsChatButtonRefactor (copy), Chat (copy), LocalPlayer (ref), RunService (copy), ContextMenuUtil (copy), u43 (ref), ContextMenuGui (copy)
	if p2 == u36 then
		return
	end

	u36 = p2
	SelectedCharacterIndicator:ChangeSelectedPlayer(u36, ThemeHandler:GetTheme())

	if FFlagAvatarContextMenuItemsChatButtonRefactor then
		local t1 = {}
		local ok2, result2 = pcall(function() -- line: 123
			-- upvalues: Chat (copy), LocalPlayer (ref)
			return Chat:CanUserChatAsync(LocalPlayer.UserId)
		end)

		t1.localPlayerChatEnabled = ok2 and (RunService:IsStudio() or result2)
		t1.localPlayerCanChatWithSelectedPlayer = false

		if u36 then
			t1.localPlayerCanChatWithSelectedPlayer = ContextMenuUtil:GetCanChatWith(u36)
		end

		u43:BuildContextMenuItems(u36, t1)
	else
		u43:BuildContextMenuItems(u36)
	end

	ContextMenuGui:SwitchToPlayerEntry(u36, p3)
end
function OpenMenu(p4) -- line: 137
	-- upvalues: u34 (ref), u42 (ref), u40 (ref), ContextMenuGui (copy), TweenService (copy), tweenInfo (copy)
	u34 = true
	u42.Visible = true
	u42.Content.ContextActionList.CanvasPosition = Vector2.new(0, 0)
	u42.Position = p4.OffScreenPosition
	u40 = ContextMenuGui.SelectedPlayerChanged:connect(function() -- line: 144
		-- upvalues: ContextMenuGui (copy)
		SetSelectedPlayer(ContextMenuGui:GetSelectedPlayer())
	end)
	u42.Position = p4.OffScreenPosition

	local tween = TweenService:Create(u42, tweenInfo, {
		Position = p4.OnScreenPosition
	})

	tween:Play()
	tween.Completed:wait()
	u34 = false
end
function BindMenuActions() -- line: 156
	-- upvalues: ContextActionService (copy), ContextMenuGui (copy), GuiService (copy)
	ContextActionService:BindCoreAction("EscapeAvatarContextMenu", function(_, p6, _) -- line: 158
		if p6 ~= Enum.UserInputState.Begin then
			return
		end

		CloseContextMenu()
	end, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("SwitchPageAvatarContextMenu", function(_, p9, p10) -- line: 167
		-- upvalues: ContextMenuGui (copy)
		if p9 == Enum.UserInputState.Begin then
			if p10.KeyCode == Enum.KeyCode.ButtonR1 then
				ContextMenuGui:OffsetPlayerEntry(1)

				return
			end

			if p10.KeyCode == Enum.KeyCode.ButtonL1 then
				ContextMenuGui:OffsetPlayerEntry(-1)
			end
		end
	end, false, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1)

	local u57 = nil

	u57 = GuiService.MenuOpened:connect(function() -- line: 180
		-- upvalues: u57 (ref)
		u57:disconnect()

		if Enum.UserInputState.Begin ~= Enum.UserInputState.Begin then
			return
		end

		CloseContextMenu()
	end)
end
function BuildPlayerCarousel(_, p12) -- line: 186
	-- upvalues: Players (copy), v1 (copy), LocalPlayer (ref), ContextMenuUtil (copy), ContextMenuGui (copy), ThemeHandler (copy)
	local t2 = {}
	local players = Players:GetPlayers()

	for i = 1, #players do
		if (players[i].UserId > 0 or v1) and players[i] ~= LocalPlayer then
			local PlayerPosition = ContextMenuUtil:GetPlayerPosition(players[i])

			if PlayerPosition then
				local magnitude = (p12 - PlayerPosition).magnitude

				table.insert(t2, {
					players[i],
					magnitude
				})
			end
		end
	end

	local function closestPlayerComp(p13, p14) -- line: 201
		return p13[2] > p14[2]
	end

	table.sort(t2, closestPlayerComp)
	ContextMenuGui:BuildPlayerCarousel(t2, ThemeHandler:GetTheme())
end

Players.PlayerRemoving:connect(function(p15) -- line: 209
	-- upvalues: u35 (ref), u36 (ref), ContextMenuGui (copy)
	if u35 and p15 ~= u36 then
		ContextMenuGui:RemovePlayerEntry(p15)
	end
end)

local function CloseOtherOpenCoreGui() -- line: 215
	-- upvalues: EmotesMenuMaster (copy), FFlagEnableNewBackpack (copy), v25 (copy), v26 (copy)
	if EmotesMenuMaster:isOpen() then
		EmotesMenuMaster:close()
	end

	if FFlagEnableNewBackpack then
		v25.setVisibility(v25.FeatureName.Backpack, false)

		return
	end

	if v26.IsOpen then
		v26.OpenClose()
	end
end

function OpenContextMenu(p16, p17) -- line: 229
	-- upvalues: u34 (ref), u35 (ref), u2 (ref), EmotesMenuMaster (copy), FFlagEnableNewBackpack (copy), v25 (copy), v26 (copy), ContextMenuUtil (copy), ContextMenuGui (copy), ThemeHandler (copy)
	if u34 or (u35 or not u2) then
		return
	end

	u35 = true

	if EmotesMenuMaster:isOpen() then
		EmotesMenuMaster:close()
	end

	if FFlagEnableNewBackpack then
		v25.setVisibility(v25.FeatureName.Backpack, false)
	elseif v26.IsOpen then
		v26.OpenClose()
	end

	BuildPlayerCarousel(p16, p17)
	ContextMenuUtil:DisablePlayerMovement()
	BindMenuActions()
	SetSelectedPlayer(p16, true)
	ContextMenuGui:UpdateGuiTheme(ThemeHandler:GetTheme())
	OpenMenu(ThemeHandler:GetTheme())
end
function CloseContextMenu() -- line: 247
	-- upvalues: GuiService (copy), ContextActionService (copy), ContextMenuUtil (copy), u40 (ref), TweenService (copy), u42 (ref), tweenInfo2 (copy), u35 (ref)
	GuiService.SelectedCoreObject = nil
	ContextActionService:UnbindCoreAction("EscapeAvatarContextMenu")
	ContextActionService:UnbindCoreAction("SwitchPageAvatarContextMenu")
	ContextMenuUtil:EnablePlayerMovement()

	if u40 then
		u40:disconnect()
	end

	local tween = TweenService:Create(u42, tweenInfo2, {
		Position = UDim2.new(0.5, 0, 1, u42.AbsoluteSize.Y)
	})

	tween:Play()
	tween.Completed:wait()
	u42.Visible = false
	SetSelectedPlayer(nil)
	u35 = false
end

ContextMenuGui:SetCloseMenuFunc(CloseContextMenu)
u43:SetCloseMenuFunc(CloseContextMenu)

local function isPointInside(p18, p19, p20) -- line: 269
	return p18.X >= p19.X and (p18.X <= p20.X and (p18.Y >= p19.Y and p18.Y <= p20.Y))
end

function PointInSwipeArea(p21) -- line: 276
	-- upvalues: u42 (ref)
	local AbsolutePosition = u42.AbsolutePosition
	local NameTag = u42.Content:FindFirstChild("NameTag")
	local vector2 = Vector2.new(AbsolutePosition.x + u42.AbsoluteSize.x, NameTag.AbsolutePosition.y + NameTag.AbsoluteSize.y)

	return p21.X >= AbsolutePosition.X and (p21.X <= vector2.X and (p21.Y >= AbsolutePosition.Y and p21.Y <= vector2.Y))
end
function LocalPlayerHasToolEquipped() -- line: 285
	-- upvalues: LocalPlayer (ref)
	if not LocalPlayer.Character then
		return false
	end

	for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
		if child:IsA("BackpackItem") then
			return true
		end
	end

	return false
end
function shouldIgnoreLocalCharacter() -- line: 297
	-- upvalues: LocalPlayer (ref)
	if LocalPlayer.Character then
		local Head = LocalPlayer.Character:FindFirstChild("Head")

		if Head and Head:IsA("BasePart") then
			return Head.LocalTransparencyModifier >= 0.95
		end
	end
end
function clickedOnPoint(p22) -- line: 307
	-- upvalues: u32 (ref), raycastParams (copy), LocalPlayer (ref), ContextMenuUtil (copy), v1 (copy), u35 (ref)
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	if LocalPlayerHasToolEquipped() then
		return
	end

	local v82 = CurrentCamera:ScreenPointToRay(p22.X, p22.Y)

	if u32 then
		raycastParams.FilterDescendantsInstances = if not shouldIgnoreLocalCharacter() then {} else { LocalPlayer.Character }

		local raycastResult = workspace:Raycast(v82.Origin, v82.Direction * 100, raycastParams)
		local v84 = if not raycastResult then nil else ContextMenuUtil:FindPlayerFromPart(raycastResult.Instance)

		if v84 and (v1 and v84 ~= LocalPlayer or v84 ~= LocalPlayer and v84.UserId > 0) then
			if u35 then
				SetSelectedPlayer(v84)

				return
			end

			OpenContextMenu(v84, raycastResult.Position)

			return
		end

		if not v84 and u35 then
			CloseContextMenu()

			return
		end
	else
		local ray = Ray.new(v82.Origin, v82.Direction * 100)
		local part, position

		if shouldIgnoreLocalCharacter() then
			part, position = workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
		else
			part, position = workspace:FindPartOnRay(ray, nil, false, true)
		end

		local PlayerFromPart = ContextMenuUtil:FindPlayerFromPart(part)

		if PlayerFromPart and (v1 and PlayerFromPart ~= LocalPlayer or PlayerFromPart ~= LocalPlayer and PlayerFromPart.UserId > 0) then
			if u35 then
				SetSelectedPlayer(PlayerFromPart)

				return
			end

			OpenContextMenu(PlayerFromPart, position)

			return
		end

		if not PlayerFromPart and u35 then
			CloseContextMenu()
		end
	end
end
function OnUserInput(p23, p24) -- line: 352
	-- upvalues: u37 (ref), u38 (ref)
	if p24.UserInputState == Enum.UserInputState.Begin and u37 == nil then
		u37 = p24
		u38 = p23

		return
	end

	if p24 == u37 and p24.UserInputState == Enum.UserInputState.Change then
		if (p23 - u38).magnitude > 5 then
			u37 = nil
			u38 = nil

			return
		end
	elseif p24.UserInputState == Enum.UserInputState.End and p24 == u37 then
		u37 = nil
		u38 = nil
		clickedOnPoint(p23)
	end
end
function OnMouseMoved(p25) -- line: 368
	-- upvalues: u35 (ref), u37 (ref), u38 (ref)
	if not u35 and (u37 and (p25 - u38).magnitude > 20) then
		u37 = nil
		u38 = nil
	end
end
function trackTouchSwipeInput(p26) -- line: 375
	-- upvalues: u39 (ref)
	if p26.UserInputType == Enum.UserInputType.Touch then
		if not u39 and p26.UserInputState == Enum.UserInputState.Begin then
			if PointInSwipeArea(p26.Position) then
				u39 = p26

				return
			end
		elseif p26 == u39 and p26.UserInputState == Enum.UserInputState.End then
			spawn(function() -- line: 382
				-- upvalues: u39 (ref)
				u39 = nil
			end)
		end
	end
end

local function functionProcessInput(p27, p28) -- line: 389
	-- upvalues: u37 (ref)
	trackTouchSwipeInput(p27)

	if p28 then
		if p27 == u37 then
			u37 = nil
		end

		return
	end

	if p27.UserInputType == Enum.UserInputType.MouseButton1 or p27.UserInputType == Enum.UserInputType.Touch then
		OnUserInput(Vector2.new(p27.Position.X, p27.Position.Y), p27)

		return
	end

	if p27.UserInputType == Enum.UserInputType.MouseMovement then
		OnMouseMoved(Vector2.new(p27.Position.X, p27.Position.Y))
	end
end

UserInputService.InputBegan:Connect(functionProcessInput)
UserInputService.InputChanged:Connect(functionProcessInput)
UserInputService.InputEnded:Connect(functionProcessInput)
UserInputService.TouchSwipe:Connect(function(p29, _, p31) -- line: 411
	-- upvalues: u35 (ref), u39 (ref), ContextMenuGui (copy)
	if not p31 then
		return
	end

	if not u35 then
		return
	end

	if not u39 then
		return
	end

	local n1 = 0

	if p29 == Enum.SwipeDirection.Left then
		n1 = 1
	elseif p29 == Enum.SwipeDirection.Right then
		n1 = -1
	end

	if n1 ~= 0 then
		ContextMenuGui:OffsetPlayerEntry(n1)
		SetSelectedPlayer(ContextMenuGui:GetSelectedPlayer())
	end
end)
LocalPlayer.FriendStatusChanged:Connect(function(p32, p33) -- line: 429
	-- upvalues: u36 (ref), BlockingUtility (copy), u43 (ref)
	if p32 and p32 == u36 then
		local v101 = BlockingUtility:IsPlayerBlockedByUserId(p32.UserId)

		u43:UpdateFriendButton(p33, v101)
	end
end)

if FFlagEnableNewBackpack then
	v25.onVisibilityChanged(v25.FeatureName.Backpack, function(p34) -- line: 437
		-- upvalues: u35 (ref)
		if p34 and u35 then
			CloseContextMenu()
		end
	end)
else
	v26.StateChanged.Event:Connect(function(p35) -- line: 443
		-- upvalues: u35 (ref)
		if p35 and u35 then
			CloseContextMenu()
		end
	end)
end

EmotesMenuMaster.EmotesMenuToggled.Event:Connect(function(p36) -- line: 450
	-- upvalues: u35 (ref)
	if p36 and u35 then
		CloseContextMenu()
	end
end)

function GetWorldPoint(p37) -- line: 456
	-- upvalues: LocalPlayer (ref)
	if p37.Character then
		local HumanoidRootPart = p37.Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			return HumanoidRootPart.Position
		end
	end

	if p37 ~= LocalPlayer then
		return GetWorldPoint(LocalPlayer)
	end

	return (Vector3.new(0, 0, 0))
end

StarterGui:RegisterGetCore("AvatarContextMenuTarget", function() -- line: 470
	-- upvalues: u36 (ref)
	return u36
end)
StarterGui:RegisterSetCore("AvatarContextMenuTarget", function(p38) -- line: 475
	-- upvalues: u35 (ref), u34 (ref)
	if typeof(p38) == "Instance" and p38:IsA("Player") then
		if p38.Parent ~= nil then
			if u35 or u34 then
				SetSelectedPlayer(p38, true)

				return
			end

			OpenContextMenu(p38, GetWorldPoint(p38))

			return
		end

		error("AvatarContextMenuTarget Player must be in the game")

		return
	end

	if p38 == nil then
		CloseContextMenu()

		return
	end

	error("AvatarContextMenuTarget argument must be a Player or nil")
end)

local function getClosestPlayer() -- line: 495
	-- upvalues: LocalPlayer (ref), Players (copy)
	if not LocalPlayer.Character then
		return
	end

	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local HumanoidRootPartPosition = HumanoidRootPart.Position
	local v110 = nil
	local n2 = 1e999
	local HumanoidRootPart2Position = nil
	local players = Players:GetPlayers()

	for _, v in ipairs(players) do
		if v ~= LocalPlayer and v.Character then
			local HumanoidRootPart2 = v.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 and n2 > (HumanoidRootPart2.Position - HumanoidRootPartPosition).magnitude then
				v110 = v
				n2 = (HumanoidRootPart2.Position - HumanoidRootPartPosition).magnitude
				HumanoidRootPart2Position = HumanoidRootPart2.Position
			end
		end
	end

	return v110, HumanoidRootPart2Position
end
local function gamepadOpenMenu(_, p40, _) -- line: 523
	-- upvalues: u2 (ref), GuiService (copy), u35 (ref), getClosestPlayer (copy)
	if not u2 then
		return Enum.ContextActionResult.Pass
	end

	if GuiService.SelectedCoreObject or GuiService.SelectedObject then
		return Enum.ContextActionResult.Pass
	end

	if p40 ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Sink
	end

	if u35 then
		CloseContextMenu()
	else
		local v120, v121 = getClosestPlayer()

		if v120 then
			OpenContextMenu(v120, v121)
		end
	end

	return Enum.ContextActionResult.Sink
end

ContextActionService:BindCoreAction("GamepadOpenAvatarContextMenu", gamepadOpenMenu, false, Enum.KeyCode.DPadUp)
