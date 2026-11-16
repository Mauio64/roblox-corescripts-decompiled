local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local Settings = Modules:WaitForChild("Settings")
local AvatarContextMenu = Modules:WaitForChild("AvatarContextMenu")
local v = nil
local bindableEvent = Instance.new("BindableEvent")

require(AvatarContextMenu:WaitForChild("ContextMenuUtil"))
require(Settings:WaitForChild("Utility"))

local class = {}
class.__index = class

function class:CreateContextMenuHolder(_)
	local avatarContextMenu = Instance.new("Frame")
	avatarContextMenu.Name = "AvatarContextMenu"
	avatarContextMenu.Position = UDim2.new(0, 0, 0, 0)
	avatarContextMenu.Size = UDim2.new(1, 0, 1, 0)
	avatarContextMenu.BackgroundTransparency = 1
	avatarContextMenu.Parent = RobloxGui
	avatarContextMenu.AutoLocalize = false
	return avatarContextMenu
end

function class:CreateLeaveMenuButton(parent, p)
	local function closeMenu()
		self.CloseMenuFunc()
	end
	local closeMenuButton = Instance.new("ImageButton")
	closeMenuButton.Name = "CloseMenuButton"
	closeMenuButton.BackgroundTransparency = 1
	closeMenuButton.AnchorPoint = Vector2.new(1, 0)
	closeMenuButton.Position = UDim2.new(1, -10, 0, 10)
	closeMenuButton.Size = UDim2.new(0.05, 0, 0.1, 0)
	closeMenuButton.Image = p.LeaveMenuImage
	closeMenuButton.Selectable = false
	closeMenuButton.Activated:Connect(closeMenu)

	local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.Parent = closeMenuButton

	closeMenuButton.Parent = parent

	return closeMenuButton
end

local function listenToViewportChange(updateAspectRatioForViewport) -- 1 equivalent call inferred from this helper
	if updateAspectRatioForViewport == nil then
		return
	end

	local viewportSizeChangedConnection = nil

	local function updateCamera() -- 1 equivalent call inferred from this helper
		local currentCamera = workspace.CurrentCamera

		if viewportSizeChangedConnection then
			viewportSizeChangedConnection:Disconnect()
		end

		viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAspectRatioForViewport)
		updateAspectRatioForViewport()
	end

	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateCamera)
	updateCamera() -- inferred equivalent call
end

function class:CreateMenuFrame(data)
	local contextMenuHolder = self:CreateContextMenuHolder()

	local menu = Instance.new("ImageButton")
	menu.Name = "Menu"
	menu.AnchorPoint = data.AnchorPoint
	menu.Size = data.Size
	menu.Position = data.OnScreenPosition
	menu.BackgroundTransparency = data.BackgroundTransparency
	menu.BackgroundColor3 = data.BackgroundColor
	menu.Image = data.BackgroundImage
	menu.ScaleType = data.BackgroundImageScaleType
	menu.SliceCenter = data.BackgroundImageSliceCenter
	menu.AutoButtonColor = false
	menu.BorderSizePixel = 0
	menu.Selectable = false
	menu.Visible = false
	menu.Active = true
	menu.ClipsDescendants = true
	menu.Modal = true

	GuiService:AddSelectionParent("AvatarContextMenuGroup", menu)

	local menuAspectRatio = Instance.new("UIAspectRatioConstraint")
	menuAspectRatio.AspectType = Enum.AspectType.ScaleWithParentSize
	menuAspectRatio.DominantAxis = Enum.DominantAxis.Height
	menuAspectRatio.Name = "MenuAspectRatio"
	menuAspectRatio.AspectRatio = data.AspectRatio
	menuAspectRatio.Parent = menu

	local function updateAspectRatioForViewport()
		local viewportSize = workspace.CurrentCamera.ViewportSize

		if viewportSize.x < viewportSize.y then
			menuAspectRatio.DominantAxis = Enum.DominantAxis.Width
		else
			menuAspectRatio.DominantAxis = Enum.DominantAxis.Height
		end
	end

	listenToViewportChange(updateAspectRatioForViewport) -- inferred equivalent call
	local menuSizeConstraint = Instance.new("UISizeConstraint")
	menuSizeConstraint.Name = "MenuSizeConstraint"
	menuSizeConstraint.MaxSize = data.MaxSize
	menuSizeConstraint.MinSize = data.MinSize
	menuSizeConstraint.Parent = menu

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.Parent = menu

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = content

	local contextActionList = Instance.new("ScrollingFrame")
	contextActionList.Name = "ContextActionList"
	contextActionList.AnchorPoint = Vector2.new(0.5, 1)
	contextActionList.BackgroundColor3 = data.ButtonFrameColor
	contextActionList.BackgroundTransparency = data.ButtonFrameTransparency
	contextActionList.BorderSizePixel = 0
	contextActionList.LayoutOrder = 2
	contextActionList.Size = UDim2.new(1, -12, 0.54, 0)
	contextActionList.CanvasSize = UDim2.new(0, 0, 0, 208)
	contextActionList.ScrollBarThickness = 4
	contextActionList.Selectable = false
	contextActionList.Parent = content

	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Top

	uiListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		contextActionList.CanvasSize = UDim2.new(0, 0, 0, uiListLayout2.AbsoluteContentSize.Y)
	end)

	uiListLayout2.Parent = contextActionList

	local nameTag = Instance.new("TextButton")
	nameTag.Name = "NameTag"
	nameTag.AnchorPoint = Vector2.new(0.5, 1)
	nameTag.BackgroundColor3 = data.NameTagColor
	nameTag.AutoButtonColor = false
	nameTag.BorderSizePixel = 0
	nameTag.LayoutOrder = 1
	nameTag.Size = UDim2.new(1, -12, 0.16, 0)
	nameTag.Font = data.Font
	nameTag.TextColor3 = data.TextColor
	nameTag.TextSize = 24 * data.TextScale
	nameTag.Text = ""
	nameTag.TextXAlignment = Enum.TextXAlignment.Center
	nameTag.TextYAlignment = Enum.TextYAlignment.Center
	nameTag.Selectable = false
	nameTag.Parent = content

	local underline = Instance.new("Frame")
	underline.Name = "Underline"
	underline.BackgroundColor3 = data.NameUnderlineColor
	underline.AnchorPoint = Vector2.new(0, 1)
	underline.BorderSizePixel = 0
	underline.Position = UDim2.new(0, 0, 1, 0)
	underline.Size = UDim2.new(1, 0, 0, 2)
	underline.Parent = nameTag

	self:CreateLeaveMenuButton(menu, data)

	menu.Parent = contextMenuHolder
	self.ContextMenuFrame = menu

	return menu
end

function class:UpdateGuiTheme(data)
	self.ContextMenuFrame.Size = data.Size
	self.ContextMenuFrame.AnchorPoint = data.AnchorPoint

	self.ContextMenuFrame.BackgroundTransparency = data.BackgroundTransparency
	self.ContextMenuFrame.BackgroundColor3 = data.BackgroundColor
	self.ContextMenuFrame.Image = data.BackgroundImage
	self.ContextMenuFrame.ScaleType = data.BackgroundImageScaleType
	self.ContextMenuFrame.SliceCenter = data.BackgroundImageSliceCenter

	self.ContextMenuFrame.CloseMenuButton.Image = data.LeaveMenuImage

	self.ContextMenuFrame.MenuSizeConstraint.MaxSize = data.MaxSize
	self.ContextMenuFrame.MenuSizeConstraint.MinSize = data.MinSize

	self.ContextMenuFrame.MenuAspectRatio.AspectRatio = data.AspectRatio

	local content = self.ContextMenuFrame.Content
	content.ContextActionList.BackgroundColor3 = data.ButtonFrameColor
	content.ContextActionList.BackgroundTransparency = data.ButtonFrameTransparency

	content.NameTag.BackgroundColor3 = data.NameTagColor
	content.NameTag.Font = data.Font
	content.NameTag.TextColor3 = data.TextColor
	content.NameTag.TextSize = 24 * data.TextScale

	content.NameTag.Underline.BackgroundColor3 = data.NameUnderlineColor

	if v then
		v:UpdateGuiTheme(data)
	end
end

function class:BuildPlayerCarousel(list, p)
	if not v then
		local PlayerCarousel = require(AvatarContextMenu.PlayerCarousel)
		v = PlayerCarousel.new(p)
		v.rbxGui.Parent = self.ContextMenuFrame.Content
	end

	v:ClearPlayerEntries()

	if self.PlayerChangedConnection then
		self.PlayerChangedConnection:Disconnect()
	end

	self.PlayerChangedConnection = v.PlayerChanged:Connect(function(p2)
		if p2 then
			self.ContextMenuFrame.Content.NameTag.Text = p2.Name
		else
			self.ContextMenuFrame.Content.NameTag.Text = ""
		end

		bindableEvent:Fire(p2)
	end)

	for i = 1, #list do
		v:CreatePlayerEntry(list[i][1], list[i][2])
	end

	v:FadeTowardsEdges()
	v:AddCarouselDivider()
end

function class:RemovePlayerEntry(p)
	if not v then
		return
	end

	v:RemovePlayerEntry(p)
end

function class.GetBottomScreenPaddingConstant(_): number
	return 0.02
end

function class:SetCloseMenuFunc(closeMenuFunc)
	self.CloseMenuFunc = closeMenuFunc
end

function class:SwitchToPlayerEntry(p, p2)
	if not v then
		return
	end

	v:SwitchToPlayerEntry(p, p2)
end

function class:OffsetPlayerEntry(p)
	if not v then
		return
	end

	v:OffsetPlayerEntry(p)
end

function class:GetSelectedPlayer()
	if v then
		return v:GetSelectedPlayer()
	end

	return nil
end

function class.new()
	local self = setmetatable({}, class)

	self.CloseMenuFunc = nil

	self.ContextMenuFrame = nil
	self.LastSetPlayerIcon = nil

	self.PlayerChangedConnection = nil

	self.SelectedPlayerChanged = bindableEvent.Event

	return self
end

return class.new()
