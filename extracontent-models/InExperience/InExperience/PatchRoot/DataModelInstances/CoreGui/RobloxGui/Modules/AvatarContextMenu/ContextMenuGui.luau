local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local Settings = Modules:WaitForChild("Settings")
local AvatarContextMenu = Modules:WaitForChild("AvatarContextMenu")
local u7 = nil
local BindableEvent = Instance.new("BindableEvent")

require(AvatarContextMenu:WaitForChild("ContextMenuUtil"))
require(Settings:WaitForChild("Utility"))

local t1 = {}

t1.__index = t1

function t1.CreateContextMenuHolder(_, _) -- line: 33
	-- upvalues: RobloxGui (copy)
	local Frame = Instance.new("Frame")

	Frame.Name = "AvatarContextMenu"
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = RobloxGui
	Frame.AutoLocalize = false

	return Frame
end
function t1.CreateLeaveMenuButton(p3, p4, p5) -- line: 44
	local function closeMenu() -- line: 45
		-- upvalues: p3 (copy)
		p3.CloseMenuFunc()
	end

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "CloseMenuButton"
	ImageButton.BackgroundTransparency = 1
	ImageButton.AnchorPoint = Vector2.new(1, 0)
	ImageButton.Position = UDim2.new(1, -10, 0, 10)
	ImageButton.Size = UDim2.new(0.05, 0, 0.1, 0)
	ImageButton.Image = p5.LeaveMenuImage
	ImageButton.Selectable = false
	ImageButton.Activated:Connect(closeMenu)

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	UIAspectRatioConstraint.AspectRatio = 1
	UIAspectRatioConstraint.Parent = ImageButton
	ImageButton.Parent = p4

	return ImageButton
end

local function listenToViewportChange(p6) -- line: 71
	if p6 == nil then
		return
	end

	local connection = nil

	local function updateCamera() -- line: 76
		-- upvalues: connection (ref), p6 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if connection then
			connection:Disconnect()
		end

		connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(p6)
		p6()
	end

	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateCamera)

	local CurrentCamera = workspace.CurrentCamera

	if connection then
		connection:Disconnect()
	end

	connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(p6)
	p6()
end

function t1.CreateMenuFrame(p7, p8) -- line: 89
	-- upvalues: GuiService (copy)
	local v26 = p7:CreateContextMenuHolder()
	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "Menu"
	ImageButton.AnchorPoint = p8.AnchorPoint
	ImageButton.Size = p8.Size
	ImageButton.Position = p8.OnScreenPosition
	ImageButton.BackgroundTransparency = p8.BackgroundTransparency
	ImageButton.BackgroundColor3 = p8.BackgroundColor
	ImageButton.Image = p8.BackgroundImage
	ImageButton.ScaleType = p8.BackgroundImageScaleType
	ImageButton.SliceCenter = p8.BackgroundImageSliceCenter
	ImageButton.AutoButtonColor = false
	ImageButton.BorderSizePixel = 0
	ImageButton.Selectable = false
	ImageButton.Visible = false
	ImageButton.Active = true
	ImageButton.ClipsDescendants = true
	ImageButton.Modal = true
	GuiService:AddSelectionParent("AvatarContextMenuGroup", ImageButton)

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	UIAspectRatioConstraint.Name = "MenuAspectRatio"
	UIAspectRatioConstraint.AspectRatio = p8.AspectRatio
	UIAspectRatioConstraint.Parent = ImageButton

	local function updateAspectRatioForViewport() -- line: 120
		-- upvalues: UIAspectRatioConstraint (copy)
		local ViewportSize = workspace.CurrentCamera.ViewportSize

		if ViewportSize.x < ViewportSize.y then
			UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width

			return
		end

		UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	end

	if updateAspectRatioForViewport ~= nil then
		local connection = nil

		local function updateCamera() -- line: 76
			-- upvalues: connection (ref), updateAspectRatioForViewport (copy)
			local CurrentCamera = workspace.CurrentCamera

			if connection then
				connection:Disconnect()
			end

			connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAspectRatioForViewport)
			updateAspectRatioForViewport()
		end

		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateCamera)

		local CurrentCamera = workspace.CurrentCamera

		if connection then
			connection:Disconnect()
		end

		connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAspectRatioForViewport)

		local ViewportSize = workspace.CurrentCamera.ViewportSize

		if ViewportSize.x < ViewportSize.y then
			UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
		else
			UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
		end
	end

	local UISizeConstraint = Instance.new("UISizeConstraint")

	UISizeConstraint.Name = "MenuSizeConstraint"
	UISizeConstraint.MaxSize = p8.MaxSize
	UISizeConstraint.MinSize = p8.MinSize
	UISizeConstraint.Parent = ImageButton

	local Frame = Instance.new("Frame")

	Frame.Name = "Content"
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = ImageButton

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = "ContextActionList"
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 1)
	ScrollingFrame.BackgroundColor3 = p8.ButtonFrameColor
	ScrollingFrame.BackgroundTransparency = p8.ButtonFrameTransparency
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.LayoutOrder = 2
	ScrollingFrame.Size = UDim2.new(1, -12, 0.54, 0)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 208)
	ScrollingFrame.ScrollBarThickness = 4
	ScrollingFrame.Selectable = false
	ScrollingFrame.Parent = Frame

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 166
		-- upvalues: ScrollingFrame (copy), UIListLayout2 (copy)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y)
	end)
	UIListLayout2.Parent = ScrollingFrame

	local TextButton = Instance.new("TextButton")

	TextButton.Name = "NameTag"
	TextButton.AnchorPoint = Vector2.new(0.5, 1)
	TextButton.BackgroundColor3 = p8.NameTagColor
	TextButton.AutoButtonColor = false
	TextButton.BorderSizePixel = 0
	TextButton.LayoutOrder = 1
	TextButton.Size = UDim2.new(1, -12, 0.16, 0)
	TextButton.Font = p8.Font
	TextButton.TextColor3 = p8.TextColor
	TextButton.TextSize = 24 * p8.TextScale
	TextButton.Text = ""
	TextButton.TextXAlignment = Enum.TextXAlignment.Center
	TextButton.TextYAlignment = Enum.TextYAlignment.Center
	TextButton.Selectable = false
	TextButton.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Underline"
	Frame2.BackgroundColor3 = p8.NameUnderlineColor
	Frame2.AnchorPoint = Vector2.new(0, 1)
	Frame2.BorderSizePixel = 0
	Frame2.Position = UDim2.new(0, 0, 1, 0)
	Frame2.Size = UDim2.new(1, 0, 0, 2)
	Frame2.Parent = TextButton
	p7:CreateLeaveMenuButton(ImageButton, p8)
	ImageButton.Parent = v26
	p7.ContextMenuFrame = ImageButton

	return ImageButton
end
function t1.UpdateGuiTheme(p9, p10) -- line: 206
	-- upvalues: u7 (ref)
	p9.ContextMenuFrame.Size = p10.Size
	p9.ContextMenuFrame.AnchorPoint = p10.AnchorPoint
	p9.ContextMenuFrame.BackgroundTransparency = p10.BackgroundTransparency
	p9.ContextMenuFrame.BackgroundColor3 = p10.BackgroundColor
	p9.ContextMenuFrame.Image = p10.BackgroundImage
	p9.ContextMenuFrame.ScaleType = p10.BackgroundImageScaleType
	p9.ContextMenuFrame.SliceCenter = p10.BackgroundImageSliceCenter
	p9.ContextMenuFrame.CloseMenuButton.Image = p10.LeaveMenuImage
	p9.ContextMenuFrame.MenuSizeConstraint.MaxSize = p10.MaxSize
	p9.ContextMenuFrame.MenuSizeConstraint.MinSize = p10.MinSize
	p9.ContextMenuFrame.MenuAspectRatio.AspectRatio = p10.AspectRatio

	local Content = p9.ContextMenuFrame.Content

	Content.ContextActionList.BackgroundColor3 = p10.ButtonFrameColor
	Content.ContextActionList.BackgroundTransparency = p10.ButtonFrameTransparency
	Content.NameTag.BackgroundColor3 = p10.NameTagColor
	Content.NameTag.Font = p10.Font
	Content.NameTag.TextColor3 = p10.TextColor
	Content.NameTag.TextSize = 24 * p10.TextScale
	Content.NameTag.Underline.BackgroundColor3 = p10.NameUnderlineColor

	if u7 then
		u7:UpdateGuiTheme(p10)
	end
end
function t1.BuildPlayerCarousel(p11, p12, p13) -- line: 239
	-- upvalues: u7 (ref), AvatarContextMenu (copy), BindableEvent (copy)
	if not u7 then
		u7 = require(AvatarContextMenu.PlayerCarousel).new(p13)
		u7.rbxGui.Parent = p11.ContextMenuFrame.Content
	end

	u7:ClearPlayerEntries()

	if p11.PlayerChangedConnection then
		p11.PlayerChangedConnection:Disconnect()
	end

	p11.PlayerChangedConnection = u7.PlayerChanged:Connect(function(p14) -- line: 251
		-- upvalues: p11 (copy), BindableEvent (copy)
		if p14 then
			p11.ContextMenuFrame.Content.NameTag.Text = p14.Name
		else
			p11.ContextMenuFrame.Content.NameTag.Text = ""
		end

		BindableEvent:Fire(p14)
	end)

	for i = 1, #p12 do
		u7:CreatePlayerEntry(p12[i][1], p12[i][2])
	end

	u7:FadeTowardsEdges()
	u7:AddCarouselDivider()
end
function t1.RemovePlayerEntry(_, p16) -- line: 267
	-- upvalues: u7 (ref)
	if not u7 then
		return
	end

	u7:RemovePlayerEntry(p16)
end
function t1.GetBottomScreenPaddingConstant(_) -- line: 273
	return 0.02
end
function t1.SetCloseMenuFunc(p18, p19) -- line: 277
	p18.CloseMenuFunc = p19
end
function t1.SwitchToPlayerEntry(_, p21, p22) -- line: 281
	-- upvalues: u7 (ref)
	if not u7 then
		return
	end

	u7:SwitchToPlayerEntry(p21, p22)
end
function t1.OffsetPlayerEntry(_, p24) -- line: 286
	-- upvalues: u7 (ref)
	if not u7 then
		return
	end

	u7:OffsetPlayerEntry(p24)
end
function t1.GetSelectedPlayer(_) -- line: 291
	-- upvalues: u7 (ref)
	if not u7 then
		return nil
	end

	return u7:GetSelectedPlayer()
end
function t1.new() -- line: 296
	-- upvalues: t1 (copy), BindableEvent (copy)
	local self = setmetatable({}, t1)

	self.CloseMenuFunc = nil
	self.ContextMenuFrame = nil
	self.LastSetPlayerIcon = nil
	self.PlayerChangedConnection = nil
	self.SelectedPlayerChanged = BindableEvent.Event

	return self
end

return t1.new()
