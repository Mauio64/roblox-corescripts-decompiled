local t1 = {}

t1.__index = t1

local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local color3 = Color3.fromRGB(0, 162, 255)
local color3_2 = Color3.fromRGB(0, 0, 0)
local AvatarContextMenu = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("AvatarContextMenu")
local Frame = nil
local UIPageLayout = nil
local BindableEvent = nil
local t2 = {}
local t3 = {}

local function getSortedCarouselButtons() -- line: 34
	-- upvalues: Frame (ref)
	local t4 = {}
	local t5 = {}

	for i, child in ipairs(Frame:GetChildren()) do
		if child:IsA("GuiObject") and child.Name ~= "_CarouselDivider" then
			table.insert(t5, child)
			t4[child] = i
		end
	end

	table.sort(t5, function(p1, p2) -- line: 43
		-- upvalues: t4 (copy)
		if p1.LayoutOrder == p2.LayoutOrder then
			return t4[p1] < t4[p2]
		end

		return p1.LayoutOrder < p2.LayoutOrder
	end)

	return t5
end
local function CreateMenuCarousel(p3) -- line: 52
	-- upvalues: Frame (ref), UIPageLayout (ref), BindableEvent (ref), getSortedCarouselButtons (copy), color3_2 (copy), GuiService (copy), color3 (copy), t2 (ref), UserInputService (copy)
	local Frame2 = Instance.new("Frame")

	Frame2.Name = "PlayerCarousel"
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.BackgroundTransparency = 1
	Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame2.Size = UDim2.new(1, 0, 0.28, 0)
	Frame2.ClipsDescendants = true

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "InnerFrame"
	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.BackgroundTransparency = 1
	Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame3.Size = UDim2.new(0.8, 0, 1, 0)
	Frame3.ClipsDescendants = true
	Frame3.Active = true
	Frame3.Parent = Frame2
	Frame = Instance.new("Frame")
	Frame.Name = "SelectedPlayer"
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 100, 1, -10)
	Frame.Parent = Frame3
	UIPageLayout = Instance.new("UIPageLayout")
	UIPageLayout.EasingDirection = Enum.EasingDirection.Out
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.Padding = UDim.new(0, 5)
	UIPageLayout.TweenTime = 0.25
	UIPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIPageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIPageLayout.TouchInputEnabled = false
	UIPageLayout.Circular = true
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	UIAspectRatioConstraint.Parent = Frame
	BindableEvent = Instance.new("BindableEvent")
	BindableEvent.Name = "PlayerChanged"

	local CurrentPage = nil

	UIPageLayout:GetPropertyChangedSignal("CurrentPage"):Connect(function() -- line: 98
		-- upvalues: UIPageLayout (ref), getSortedCarouselButtons (copy), CurrentPage (ref), color3_2 (copy), GuiService (copy), color3 (copy), BindableEvent (ref), t2 (ref)
		if UIPageLayout.CurrentPage then
			if UIPageLayout.CurrentPage.Name == "_CarouselDivider" then
				local v70 = getSortedCarouselButtons()

				if CurrentPage == v70[1] then
					UIPageLayout:Previous()
				else
					UIPageLayout:Next()
				end
			else
				UIPageLayout.CurrentPage.BackgroundColor3 = color3_2
				CurrentPage = UIPageLayout.CurrentPage
			end
		end

		if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject.Parent == UIPageLayout.Parent then
			GuiService.SelectedCoreObject.BackgroundColor3 = color3
		end

		GuiService.SelectedCoreObject = UIPageLayout.CurrentPage

		if UIPageLayout.CurrentPage then
			BindableEvent:Fire(t2[UIPageLayout.CurrentPage])
		end
	end)
	UIPageLayout.Parent = Frame

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "NextButton"
	ImageButton.Image = p3.ScrollRightImage
	ImageButton.BackgroundTransparency = 1
	ImageButton.AnchorPoint = Vector2.new(1, 0.5)
	ImageButton.Position = UDim2.new(1, -5, 0.5, 0)
	ImageButton.Size = UDim2.new(0.3, 0, 0.3, 0)
	ImageButton.Selectable = false
	ImageButton.Parent = Frame2

	local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

	UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Width
	UIAspectRatioConstraint2.Parent = ImageButton

	local clone = ImageButton:Clone()

	clone.Name = "PrevButton"

	if p3.ScrollLeftImage ~= "" then
		clone.Image = p3.ScrollLeftImage
	else
		clone.Rotation = 180
	end

	clone.AnchorPoint = Vector2.new(0, 0.5)
	clone.Position = UDim2.new(0, 5, 0.5, 0)
	clone.Selectable = false
	clone.Parent = Frame2

	local function moveChangePage(p4) -- line: 146
		-- upvalues: UIPageLayout (ref)
		if p4 then
			UIPageLayout:Next()

			return
		end

		UIPageLayout:Previous()
	end

	ImageButton.MouseButton1Click:Connect(function() -- line: 154
		-- upvalues: UIPageLayout (ref)
		UIPageLayout:Next()
	end)
	clone.MouseButton1Click:Connect(function() -- line: 155
		-- upvalues: UIPageLayout (ref)
		UIPageLayout:Previous()
	end)

	local function checkButtonVisibility() -- line: 159
		-- upvalues: UserInputService (copy), clone (copy), Frame (ref), ImageButton (copy)
		local v72 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch

		clone.Visible = not v72 and #Frame:GetChildren() > 3
		ImageButton.Visible = not v72 and #Frame:GetChildren() > 3
	end

	local v30 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch

	clone.Visible = not v30 and #Frame:GetChildren() > 3
	ImageButton.Visible = not v30 and #Frame:GetChildren() > 3
	UserInputService.LastInputTypeChanged:Connect(checkButtonVisibility)

	return Frame2
end

function t1.UpdateGuiTheme(p5, p6) -- line: 170
	p5.rbxGui.NextButton.Image = p6.ScrollRightImage

	if p6.ScrollLeftImage ~= "" then
		p5.rbxGui.PrevButton.Image = p6.ScrollLeftImage

		return
	end

	p5.rbxGui.PrevButton.Image = p6.ScrollRightImage
	p5.rbxGui.PrevButton.Rotation = 180
end
function t1.FadeTowardsEdges(_) -- line: 181
	-- upvalues: UIPageLayout (ref), getSortedCarouselButtons (copy)
	if not UIPageLayout.CurrentPage then
		return
	end

	local v34 = getSortedCarouselButtons()
	local n1 = 0

	for i, v in ipairs(v34) do
		if v == UIPageLayout.CurrentPage then
			n1 = i

			break
		end
	end

	for i, v in ipairs(v34) do
		local v40 = math.min((n1 - i) % #v34, (i - n1) % #v34)

		if v40 >= 2 then
			v.ImageTransparency = 0.7
		elseif v40 == 1 then
			v.ImageTransparency = 0.4
		else
			v.ImageTransparency = 0
		end
	end
end
function t1.AddCarouselDivider(_) -- line: 209
	-- upvalues: Frame (ref)
	local _CarouselDivider = Frame:FindFirstChild("_CarouselDivider")

	if _CarouselDivider then
		_CarouselDivider:Destroy()
	end

	if #Frame:GetChildren() - 1 < 5 then
		return
	end

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "_CarouselDivider"
	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame
	Frame4.LayoutOrder = 1000000

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "line"
	Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame5.BorderSizePixel = 0
	Frame5.Position = UDim2.new(0.25, 0, 0, -3)
	Frame5.Size = UDim2.new(0, 2, 1, 6)
	Frame5.Parent = Frame4

	local clone = Frame5:Clone()

	clone.Position = UDim2.new(0.5, 0, 0, -3)
	clone.Parent = Frame4

	local clone2 = Frame5:Clone()

	clone2.Position = UDim2.new(0.75, 0, 0, -3)
	clone2.Parent = Frame4
end
function t1.RemovePlayerEntry(p9, p10) -- line: 244
	-- upvalues: t3 (ref), t2 (ref), UIPageLayout (ref)
	local v49 = t3[p10]

	if v49 then
		t3[p10] = nil
		t2[v49] = nil
		v49:Destroy()

		if UIPageLayout then
			UIPageLayout:ApplyLayout()
		end

		p9:FadeTowardsEdges()
	end
end
function t1.ClearPlayerEntries(_) -- line: 259
	-- upvalues: t2 (ref), t3 (ref)
	for k in pairs(t2) do
		k:Destroy()
	end

	t2 = {}
	t3 = {}
end
function t1.CreatePlayerEntry(_, p13, p14) -- line: 268
	-- upvalues: t3 (ref), color3_2 (copy), color3 (copy), TweenService (copy), t2 (ref), UIPageLayout (ref), Frame (ref), AvatarContextMenu (copy), GuiService (copy)
	local v55 = t3[p13]

	if v55 then
		v55.LayoutOrder = p14

		return
	end

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = p13.Name
	ImageButton.BorderSizePixel = 0
	ImageButton.LayoutOrder = p14
	ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ImageButton.BackgroundTransparency = 0
	ImageButton.Size = UDim2.new(1, 0, 1, 0)
	ImageButton.SelectionLost:connect(function() -- line: 283
		-- upvalues: ImageButton (copy), color3_2 (copy)
		ImageButton.BackgroundColor3 = color3_2
	end)
	ImageButton.SelectionGained:connect(function() -- line: 284
		-- upvalues: ImageButton (copy), color3 (copy)
		ImageButton.BackgroundColor3 = color3
	end)

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(ImageButton, tweenInfo, {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	})

	tween:Play()
	t2[ImageButton] = p13
	t3[p13] = ImageButton
	ImageButton.MouseButton1Click:Connect(function() -- line: 298
		-- upvalues: UIPageLayout (ref), ImageButton (copy)
		UIPageLayout:JumpTo(ImageButton)
	end)
	ImageButton.Parent = Frame
	spawn(function() -- line: 304
		-- upvalues: AvatarContextMenu (copy), ImageButton (copy), p13 (copy), tween (ref), GuiService (copy), color3 (copy), color3_2 (copy)
		ImageButton.Image = require(AvatarContextMenu:WaitForChild("ContextMenuUtil")):GetHeadshotForPlayer(p13)
		tween:Cancel()
		tween = nil

		if ImageButton == GuiService.SelectedCoreObject then
			ImageButton.BackgroundColor3 = color3

			return
		end

		ImageButton.BackgroundColor3 = color3_2
	end)
end
function t1.SwitchToPlayerEntry(p15, p16, p17) -- line: 317
	-- upvalues: t3 (ref), UIPageLayout (ref)
	if not p16 then
		return
	end

	local v62 = t3[p16]

	if not v62 then
		p15:CreatePlayerEntry(p16, 0)
		v62 = t3[p16]
	end

	if p17 then
		UIPageLayout.TweenTime = 0
	end

	UIPageLayout:JumpTo(v62)
	spawn(function() -- line: 330
		-- upvalues: UIPageLayout (ref)
		UIPageLayout.TweenTime = 0.25
	end)
end
function t1.OffsetPlayerEntry(_, p19) -- line: 335
	-- upvalues: UIPageLayout (ref)
	if p19 == 0 then
		return
	end

	if p19 > 0 then
		UIPageLayout:Next()

		return
	end

	UIPageLayout:Previous()
end
function t1.GetSelectedPlayer(_) -- line: 345
	-- upvalues: t2 (ref), UIPageLayout (ref)
	return t2[UIPageLayout.CurrentPage]
end
function t1.new(p21) -- line: 349
	-- upvalues: t1 (copy), CreateMenuCarousel (copy), BindableEvent (ref)
	local self = setmetatable({}, t1)

	self.rbxGui = CreateMenuCarousel(p21)
	self.PlayerChanged = BindableEvent.Event
	BindableEvent.Event:Connect(function() -- line: 355
		-- upvalues: self (copy)
		self:FadeTowardsEdges()
	end)

	return self
end

return t1
