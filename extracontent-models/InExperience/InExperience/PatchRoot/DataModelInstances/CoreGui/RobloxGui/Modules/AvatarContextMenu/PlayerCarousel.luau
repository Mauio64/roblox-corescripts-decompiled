local PlayerCarousel = {}
PlayerCarousel.__index = PlayerCarousel

local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local color = Color3.fromRGB(0, 162, 255)
local color2 = Color3.fromRGB(0, 0, 0)

local avatarContextMenu = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("AvatarContextMenu")
local selectedPlayer = nil
local uiPageLayout = nil
local playerChanged = nil
local v = {}
local v2 = {}

local function getSortedCarouselButtons()
	local guiObjects = {}
	local v3 = {}

	for i, guiObject in ipairs(selectedPlayer:GetChildren()) do
		if not (guiObject:IsA("GuiObject") and guiObject.Name ~= "_CarouselDivider") then
			continue
		end

		table.insert(guiObjects, guiObject)
		v3[guiObject] = i
	end

	table.sort(guiObjects, function(a, b): boolean
		if a.LayoutOrder == b.LayoutOrder then
			return v3[a] < v3[b]
		end

		return a.LayoutOrder < b.LayoutOrder
	end)

	return guiObjects
end

local function CreateMenuCarousel(p)
	local playerCarousel = Instance.new("Frame")
	playerCarousel.Name = "PlayerCarousel"
	playerCarousel.AnchorPoint = Vector2.new(0.5, 0.5)
	playerCarousel.BackgroundTransparency = 1
	playerCarousel.Position = UDim2.new(0.5, 0, 0.5, 0)
	playerCarousel.Size = UDim2.new(1, 0, 0.28, 0)
	playerCarousel.ClipsDescendants = true

	local innerFrame = Instance.new("Frame")
	innerFrame.Name = "InnerFrame"
	innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	innerFrame.BackgroundTransparency = 1
	innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	innerFrame.Size = UDim2.new(0.8, 0, 1, 0)
	innerFrame.ClipsDescendants = true
	innerFrame.Active = true
	innerFrame.Parent = playerCarousel

	selectedPlayer = Instance.new("Frame")
	selectedPlayer.Name = "SelectedPlayer"
	selectedPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	selectedPlayer.BackgroundTransparency = 1
	selectedPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
	selectedPlayer.Size = UDim2.new(0, 100, 1, -10)
	selectedPlayer.Parent = innerFrame

	uiPageLayout = Instance.new("UIPageLayout")
	uiPageLayout.EasingDirection = Enum.EasingDirection.Out
	uiPageLayout.EasingStyle = Enum.EasingStyle.Quad
	uiPageLayout.Padding = UDim.new(0, 5)
	uiPageLayout.TweenTime = 0.25
	uiPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiPageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiPageLayout.TouchInputEnabled = false
	uiPageLayout.Circular = true
	uiPageLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	uiAspectRatioConstraint.Parent = selectedPlayer

	playerChanged = Instance.new("BindableEvent")
	playerChanged.Name = "PlayerChanged"

	local currentPage = nil
	uiPageLayout:GetPropertyChangedSignal("CurrentPage"):Connect(function()
		if uiPageLayout.CurrentPage then
			if uiPageLayout.CurrentPage.Name == "_CarouselDivider" then
				local sortedCarouselButtons = getSortedCarouselButtons()

				if currentPage == sortedCarouselButtons[1] then
					uiPageLayout:Previous()
				else
					uiPageLayout:Next()
				end
			else
				uiPageLayout.CurrentPage.BackgroundColor3 = color2
				currentPage = uiPageLayout.CurrentPage
			end
		end

		if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject.Parent == uiPageLayout.Parent then
			GuiService.SelectedCoreObject.BackgroundColor3 = color
		end

		GuiService.SelectedCoreObject = uiPageLayout.CurrentPage

		if uiPageLayout.CurrentPage then
			playerChanged:Fire(v[uiPageLayout.CurrentPage])
		end
	end)
	uiPageLayout.Parent = selectedPlayer

	local nextButton = Instance.new("ImageButton")
	nextButton.Name = "NextButton"
	nextButton.Image = p.ScrollRightImage
	nextButton.BackgroundTransparency = 1
	nextButton.AnchorPoint = Vector2.new(1, 0.5)
	nextButton.Position = UDim2.new(1, -5, 0.5, 0)
	nextButton.Size = UDim2.new(0.3, 0, 0.3, 0)
	nextButton.Selectable = false
	nextButton.Parent = playerCarousel

	local uiAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
	uiAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Width
	uiAspectRatioConstraint2.Parent = nextButton

	local prevButton = nextButton:Clone()
	prevButton.Name = "PrevButton"

	if p.ScrollLeftImage == "" then
		prevButton.Rotation = 180
	else
		prevButton.Image = p.ScrollLeftImage
	end

	prevButton.AnchorPoint = Vector2.new(0, 0.5)
	prevButton.Position = UDim2.new(0, 5, 0.5, 0)
	prevButton.Selectable = false
	prevButton.Parent = playerCarousel

	local function moveChangePage(p2)
		if p2 then
			uiPageLayout:Next()
		else
			uiPageLayout:Previous()
		end
	end

	nextButton.MouseButton1Click:Connect(function()
		uiPageLayout:Next()
	end)
	prevButton.MouseButton1Click:Connect(function()
		uiPageLayout:Previous()
	end)

	local function checkButtonVisibility() -- 1 equivalent call inferred from this helper
		local v3 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch
		prevButton.Visible = not v3 and #selectedPlayer:GetChildren() > 3
		nextButton.Visible = not v3 and #selectedPlayer:GetChildren() > 3
	end

	checkButtonVisibility() -- inferred equivalent call
	UserInputService.LastInputTypeChanged:Connect(checkButtonVisibility)

	return playerCarousel
end

function PlayerCarousel.UpdateGuiTheme(p, p2)
	p.rbxGui.NextButton.Image = p2.ScrollRightImage

	if p2.ScrollLeftImage ~= "" then
		p.rbxGui.PrevButton.Image = p2.ScrollLeftImage
		return
	end

	p.rbxGui.PrevButton.Image = p2.ScrollRightImage
	p.rbxGui.PrevButton.Rotation = 180
end

function PlayerCarousel:FadeTowardsEdges()
	if not uiPageLayout.CurrentPage then
		return
	end

	local sortedCarouselButtons = getSortedCarouselButtons()
	local v3 = 0

	for i, sortedCarouselButton in ipairs(sortedCarouselButtons) do
		if sortedCarouselButton == uiPageLayout.CurrentPage then
			v3 = i
			break
		end
	end

	for i, sortedCarouselButton in ipairs(sortedCarouselButtons) do
		local v4 = math.min((v3 - i) % #sortedCarouselButtons, (i - v3) % #sortedCarouselButtons)

		if v4 >= 2 then
			sortedCarouselButton.ImageTransparency = 0.7
		elseif v4 == 1 then
			sortedCarouselButton.ImageTransparency = 0.4
		else
			sortedCarouselButton.ImageTransparency = 0
		end
	end
end

function PlayerCarousel.AddCarouselDivider(_)
	local carouselDivider = selectedPlayer:FindFirstChild("_CarouselDivider")

	if carouselDivider then
		carouselDivider:Destroy()
	end

	if #selectedPlayer:GetChildren() - 1 < 5 then
		return
	end

	local carouselDivider2 = Instance.new("Frame")
	carouselDivider2.Name = "_CarouselDivider"
	carouselDivider2.Size = UDim2.new(1, 0, 1, 0)
	carouselDivider2.BackgroundTransparency = 1
	carouselDivider2.Parent = selectedPlayer
	carouselDivider2.LayoutOrder = 1000000

	local line = Instance.new("Frame")
	line.Name = "line"
	line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	line.BorderSizePixel = 0
	line.Position = UDim2.new(0.25, 0, 0, -3)
	line.Size = UDim2.new(0, 2, 1, 6)
	line.Parent = carouselDivider2

	local clone = line:Clone()
	clone.Position = UDim2.new(0.5, 0, 0, -3)
	clone.Parent = carouselDivider2

	local clone2 = line:Clone()
	clone2.Position = UDim2.new(0.75, 0, 0, -3)
	clone2.Parent = carouselDivider2
end

function PlayerCarousel:RemovePlayerEntry(p)
	local v3 = v2[p]

	if v3 then
		v2[p] = nil
		v[v3] = nil

		v3:Destroy()

		if uiPageLayout then
			uiPageLayout:ApplyLayout()
		end

		self:FadeTowardsEdges()
	end
end

function PlayerCarousel.ClearPlayerEntries(_)
	for k in pairs(v) do
		k:Destroy()
	end

	v = {}
	v2 = {}
end

function PlayerCarousel:CreatePlayerEntry(p, layoutOrder)
	local v3 = v2[p]

	if v3 then
		v3.LayoutOrder = layoutOrder
		return
	end

	local imageButton = Instance.new("ImageButton")
	imageButton.Name = p.Name
	imageButton.BorderSizePixel = 0
	imageButton.LayoutOrder = layoutOrder
	imageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	imageButton.BackgroundTransparency = 0
	imageButton.Size = UDim2.new(1, 0, 1, 0)

	imageButton.SelectionLost:connect(function()
		imageButton.BackgroundColor3 = color2
	end)
	imageButton.SelectionGained:connect(function()
		imageButton.BackgroundColor3 = color
	end)

	local tween = TweenService:Create(
		imageButton,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true),
		{ BackgroundColor3 = Color3.fromRGB(255, 255, 255) }
	)

	tween:Play()

	v[imageButton] = p
	v2[p] = imageButton

	imageButton.MouseButton1Click:Connect(function()
		uiPageLayout:JumpTo(imageButton)
	end)

	imageButton.Parent = selectedPlayer

	spawn(function()
		local ContextMenuUtil = require(avatarContextMenu:WaitForChild("ContextMenuUtil"))
		imageButton.Image = ContextMenuUtil:GetHeadshotForPlayer(p)
		tween:Cancel()
		tween = nil

		if imageButton == GuiService.SelectedCoreObject then
			imageButton.BackgroundColor3 = color
		else
			imageButton.BackgroundColor3 = color2
		end
	end)
end

function PlayerCarousel:SwitchToPlayerEntry(p, p2)
	if not p then
		return
	end

	local v3 = v2[p]

	if not v3 then
		self:CreatePlayerEntry(p, 0)
		v3 = v2[p]
	end

	if p2 then
		uiPageLayout.TweenTime = 0
	end

	uiPageLayout:JumpTo(v3)
	spawn(function()
		uiPageLayout.TweenTime = 0.25
	end)
end

function PlayerCarousel.OffsetPlayerEntry(_, p)
	if p == 0 then
		return
	end

	if p > 0 then
		uiPageLayout:Next()
	else
		uiPageLayout:Previous()
	end
end

function PlayerCarousel.GetSelectedPlayer(_)
	return v[uiPageLayout.CurrentPage]
end

function PlayerCarousel.new(p)
	local object = setmetatable({}, PlayerCarousel)

	object.rbxGui = CreateMenuCarousel(p)
	object.PlayerChanged = playerChanged.Event

	playerChanged.Event:Connect(function()
		object:FadeTowardsEdges()
	end)

	return object
end

return PlayerCarousel
