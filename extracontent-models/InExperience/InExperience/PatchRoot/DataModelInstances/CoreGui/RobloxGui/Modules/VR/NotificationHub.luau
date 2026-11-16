local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local Panel3D = VrCommon.Panel3D
local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon2.VRHub
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local _ = CFrame.Angles(-0.08726646259971647, 0, 0) * CFrame.new(0, 4, 0) * CFrame.Angles(-0.2617993877991494, 0, 0)

local color = Color3.new(78 / 255, 84 / 255, 96 / 255)
local color2 = Color3.new(82 / 255, 101 / 255, 141 / 255)
local color3 = Color3.new(20 / 255, 20 / 255, 20 / 255)

local color4 = Color3.new(0.2, 0.2, 0.2)

local selectionImageObject = Create("ImageLabel")({ BackgroundTransparency = 1, Image = "" })

local color5 = Color3.new(1, 1, 1)

local NotificationHub = {}
NotificationHub.ModuleName = "Notifications"
NotificationHub.KeepVRTopbarOpen = true
NotificationHub.VRIsExclusive = true
NotificationHub.VRClosesNonExclusive = true

function NotificationHub.UnreadCountChanged(...) end

NotificationHub.SetVisible = nil
VRHub:RegisterModule(NotificationHub)

local notifications = Panel3D.Get("Notifications")

local notificationDetails = Panel3D.Get("NotificationDetails")

local function IsDeveloperGroupEnabled(): boolean
	return false
end

local v = {}

local classes = {}
local v2 = { __index = v }
function v.new(panel, parent, text)
	local class = {}
	table.insert(classes, class)
	class.zeroCF = panel.localCF
	class.zOffset = 0
	class.isPopping = false
	class.isAnimating = false
	class.tweener = nil
	class.panel = panel
	class.SetPopOut = nil
	function class.panel.OnMouseEnter()
		for _, v3 in pairs(classes) do
			if v3 ~= class then
				v3:SetPopOut(false)
			end
		end

		class:SetPopOut(true)
	end

	class.titlebar = Create("ImageLabel")({
		Parent = parent,
		Name = "TitlebarBackground",
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 0, 74),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageColor3 = color,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})

	class.titleText = Create("TextLabel")({
		Parent = class.titlebar,
		Name = "TitleText",
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Text = text,
		TextColor3 = color5,
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size36,
		BackgroundTransparency = 1
	})

	class.content = Create("ImageLabel")({
		Parent = parent,
		Name = "ContentFrame",
		Position = UDim2.new(0, -1, 0, 74),
		Size = UDim2.new(1, 2, 1, -76),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageColor3 = color3,
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})

	return (setmetatable(class, v2))
end

function v:SetTitle(text)
	self.titleText.Text = text
end

function v:AddCloseButton(p)
	self.closeButton = Create("ImageButton")({
		Parent = self.titlebar,
		Name = "CloseButton",
		Position = UDim2.new(0, 22, 0, 22),
		Size = UDim2.new(0, 32, 0, 32),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Keyboard/close_button_icon.png",
		SelectionImageObject = Create("ImageButton")({
			Name = "CloseButtonHover",
			Position = UDim2.new(0, -11, 0, -11),
			Size = UDim2.new(1, 22, 1, 22),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
		})
	})

	self.closeButton.MouseButton1Click:connect(p)
end

function v:TweenZOffsetTo(p, p2, p3, p4)
	if self.tweener and not self.tweener:IsFinished() then
		self.tweener:Cancel()
	end

	self.tweener = Utility:TweenProperty(self, "zOffset", self.zOffset, p, p2, p3, p4)
end

function v:AnimateOut(callback)
	self.isAnimating = true
	self:TweenZOffsetTo(-100, 0.25, Utility:GetEaseInOutQuad(), function()
		if callback then
			callback()
		end

		self.isAnimating = false
	end)
end

function v:AnimateIn(callback)
	self.zOffset = -100
	self:OnUpdate(0)
	self.isAnimating = true
	self:TweenZOffsetTo(0, 0.25, Utility:GetEaseInOutQuad(), function()
		if callback then
			callback()
		end

		self.isAnimating = false
	end)
end

function v:SetPopOut(p)
	if self.isAnimating then
		return
	end

	if p then
		self.isPopping = true
		self:TweenZOffsetTo(0.25, 0.25, Utility:GetEaseInOutQuad(), function()
			self.isPopping = false
		end)
	else
		self.isPopping = true
		self:TweenZOffsetTo(0, 0.25, Utility:GetEaseInOutQuad(), function()
			self.isPopping = false
		end)
	end
end

function v:OnUpdate(_)
	self.panel.localCF = self.zeroCF * CFrame.new(0, 0, self.zOffset)
	self.panel.needsLocalPositionUpdate = self.isAnimating or self.isPopping

	if self.isPopping then
		local v3 = math.max(0, (math.min(1, self.zOffset / 0.25)))
		self.titlebar.ImageColor3 = color:lerp(color2, v3)
	end
end

notifications:SetType(Panel3D.Type.Standard)
notifications:SetVisible(false)
notifications:SetCanFade(false)
notifications:ResizeStuds(2.277333324, 3.5, 150)
local v3 = Create("TextButton")({
	Parent = notifications:GetGUI(),
	Name = "NotificationsListFrame",
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, -4, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	Selectable = true,
	SelectionImageObject = selectionImageObject
})

local v4 = v.new(notifications, v3, "Notifications")
v4:AddCloseButton(function()
	NotificationHub:SetVisible(false)
end)
function notifications:OnUpdate(p)
	v4:OnUpdate(p)
end

notificationDetails:SetType(Panel3D.Type.Standard)
notificationDetails:SetVisible(false)
notificationDetails:SetCanFade(false)
notificationDetails:ResizeStuds(3.4159999859999997, 3.5, 150)
local v5 = Create("TextButton")({
	Parent = notificationDetails:GetGUI(),
	Name = "NotificationsDetailFrame",
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	Selectable = true,
	SelectionImageObject = selectionImageObject
})

local v6 = v.new(notificationDetails, v5, "Friend Requests")
function notificationDetails:OnUpdate(p)
	v6:OnUpdate(p)
end

local v7 = {}
local v8 = {}
local function groupSort(p, p2): boolean
	return p.order < p2.order
end

local v9 = nil

local function layoutNotificationsGroups()
	local v10 = 20

	for _, v11 in ipairs(v8) do
		if not (#v11.notifications > 0) then
			continue
		end

		local v12 = (math.min(3, #v11.notifications) - 1) * 20 + 80

		v11.frame.Position = UDim2.new(0.07500000000000001, 0, 0, v10)
		v11.frame.Size = UDim2.new(0.85, -40, 0, v12)
		v10 = v10 + v12 + 20

		if not v11.notificationsDirty then
			continue
		end

		v11.notificationsDirty = false

		local total = 0
		local total2 = 0

		local count = #v11.notifications

		if not (count > 0) then
			continue
		end

		local v13 = math.max(1, count - 3 + 1)

		for i = 1, count do
			local notification = v11.notifications[i]

			if v13 <= i then
				notification.frame.Visible = true
				notification.frame.Position = UDim2.new(0, total, 0, total)
				total += 20

				notifications:SetSubpanelDepth(notification.frame, total2)
				total2 += 0.25
			else
				notification.frame.Visible = false
			end
		end

		if v9 ~= v11 then
			continue
		end

		local v14 = math.max(1, count - 2 + 1)
		local total3 = 0

		for i = 1, count do
			local notification = v11.notifications[i]

			if v14 <= i then
				notification.detailsFrame.Visible = true
				notification.detailsFrame.Position = UDim2.new(0, 20, total3, 20)
				notification.detailsFrame.Size = UDim2.new(1, -40, 0.5, -40)

				total3 += 0.5
			else
				notification.detailsFrame.Visible = false
			end
		end
	end
end

local v10 = {}

local v11 = { __index = v10 }
function v10.new(p, title, order)
	local self = setmetatable({}, v11)

	self.key = p
	self.title = title
	self.order = order
	self.notifications = {}
	self.notificationsDirty = false
	self.frame = Create("Frame")({
		Parent = v4.content,
		Name = "NotificationGroup",
		BackgroundTransparency = 1
	})

	self.detailsFrame = Create("Frame")({
		Parent = nil,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})

	v7[p] = self
	table.insert(v8, self)

	return self
end

function v10:Deactivate()
	self.detailsFrame.Parent = nil

	for _, child in pairs(self.detailsFrame:GetChildren()) do
		notificationDetails:RemoveSubpanel(child)
	end
end

function v10:SwitchTo()
	v6:SetTitle(self.title)

	for _, v12 in pairs(v7) do
		if v12 ~= self then
			v12:Deactivate()
		end
	end

	self.detailsFrame.Parent = v6.content

	v9 = self
	self.notificationsDirty = true
end

function v10:BringNotificationToFront(p)
	if v9 ~= self then
		self:SwitchTo()
	end

	if #self.notifications ~= 0 and p == self.notifications[#self.notifications] then
		layoutNotificationsGroups()
		return
	end

	for i, notification in ipairs(self.notifications) do
		if notification == p then
			table.remove(self.notifications, i)
			break
		end
	end

	table.insert(self.notifications, p)
	self.notificationsDirty = true
	layoutNotificationsGroups()
end

function v10:RemoveNotification(p)
	for i, notification in ipairs(self.notifications) do
		if notification == p then
			table.remove(self.notifications, i)
			notifications:RemoveSubpanel(p.frame)
			notificationDetails:RemoveSubpanel(p.detailsFrame)
			p.detailsFrame:Destroy()
			p.frame:Destroy()

			self.notificationsDirty = true
			layoutNotificationsGroups()
			break
		end
	end
end

function v10.GetTopNotification(p)
	local count = #p.notifications

	if count <= 0 then
		return nil
	end

	return p.notifications[count]
end

v10.new("Friends", "Friends", 1)
v10.new("BadgeAwards", "Badges", 2)
v10.new("PlayerPoints", "Points", 3)

table.sort(v8, groupSort)

local function doCallback(callback, ...)
	if not callback then
		return
	end

	if type(callback) == "function" then
		callback(...)
		return
	end

	if callback:IsA("BindableEvent") then
		callback:Fire(...)
		return
	end

	if not callback:IsA("BindableFunction") then
		return
	end

	callback:Invoke(...)
end

local v12 = {}

local v13 = { __index = v12 }
function v12:new(data)
	local object = setmetatable({}, v13)
	object.group = self
	object.frame = Create("ImageButton")({
		Parent = self.frame,
		Size = UDim2.new(1, 0, 0, 80),
		SelectionImageObject = selectionImageObject,
		BackgroundTransparency = 1
	})

	object.frame.MouseButton1Click:connect(function()
		object:OnClicked()
	end)
	object.background = Create("ImageLabel")({
		Parent = object.frame,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 1, 2),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/vr/rectBackgroundWhite.png",
		ImageColor3 = color4,
		ImageTransparency = 0.1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})

	object.imageBackground = Create("ImageLabel")({
		Parent = object.frame,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, 70, 0, 70),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/circleWhite.png",
		ImageColor3 = data.imgBackgroundColor or Color3.new(1, 1, 1)
	})

	object.image = Create("ImageLabel")({
		Parent = object.imageBackground,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = data.Image
	})

	local text = data.Text

	if data.Title and data.Text then
		text = ("%s\n%s"):format(data.Title, data.Text)
	end

	object.text = Create("TextLabel")({
		Parent = object.frame,
		Position = UDim2.new(0, 80, 0, 0),
		Size = UDim2.new(1, -80, 1, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = text,
		TextWrapped = true,
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = color5
	})

	object.detailsFrame = Create("Frame")({ Parent = self.detailsFrame, BackgroundTransparency = 1 })

	object.detailsFrame.MouseEnter:connect(function()
		notificationDetails:SetSubpanelDepth(object.detailsFrame, 0.25)
	end)
	object.detailsFrame.MouseLeave:connect(function()
		notificationDetails:SetSubpanelDepth(object.detailsFrame, 0)
	end)
	object.detailsBackground = Create("ImageLabel")({
		Parent = object.detailsFrame,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 1, 2),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageColor3 = Color3.new(0.2, 0.2, 0.2),
		ImageTransparency = 0.1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})

	object.detailsIconBackground = Create("ImageLabel")({
		Parent = object.detailsFrame,
		Position = UDim2.new(0, 20, 0, 10),
		Size = UDim2.new(0, 80, 0, 80),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/circleWhite.png",
		ImageColor3 = data.imgBackgroundColor or Color3.new(1, 1, 1)
	})

	object.detailsIcon = Create("ImageLabel")({
		Parent = object.detailsIconBackground,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = data.Image
	})

	local detailText = data.DetailText or data.Title
	object.detailsText = Create("TextLabel")({
		Parent = object.detailsFrame,
		Position = UDim2.new(0, 110, 0, 10),
		Size = UDim2.new(1, -120, 0, 90),
		BackgroundTransparency = 1,
		Text = detailText,
		TextWrapped = true,
		TextColor3 = color5,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size36
	})

	local function createButton(p, p2, text2)
		local parent = Create("ImageButton")({
			Parent = object.detailsFrame,
			Position = UDim2.new(p, 0, 0.55, 0),
			Size = UDim2.new(p2, 0, 0.29, 0),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 6, 46, 44),
			SelectionImageObject = selectionImageObject
		})

		local v14 = Create("TextLabel")({
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, -6),
			BackgroundTransparency = 1,
			Text = text2,
			TextColor3 = color5,
			Font = Enum.Font.SourceSansBold,
			FontSize = Enum.FontSize.Size24
		})

		v14.Parent = parent

		parent.SelectionGained:connect(function()
			parent.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"
		end)
		parent.SelectionLost:connect(function()
			parent.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
		end)
		return parent, v14
	end

	if data.Button1Text and data.Button2Text then
		local button, detailsButton1Text = createButton(0.07, 0.415, data.Button1Text)
		object.detailsButton1 = button
		object.detailsButton1Text = detailsButton1Text
		local button2, detailsButton2Text = createButton(0.511, 0.415, data.Button2Text)
		object.detailsButton2 = button2
		object.detailsButton2Text = detailsButton2Text

		object.detailsButton1.MouseButton1Click:connect(function()
			doCallback(data.Callback, data.Button1Text)
			object:Dismiss()
		end)
		object.detailsButton2.MouseButton1Click:connect(function()
			doCallback(data.Callback, data.Button2Text)
			object:Dismiss()
		end)
	elseif not data.button2Text then
		local button, detailsButton1Text = createButton(0.07, 0.86, data.Button1Text or "Dismiss")
		object.detailsButton1 = button
		object.detailsButton1Text = detailsButton1Text
		object.detailsButton1.MouseButton1Click:connect(function()
			doCallback(data.Callback, data.Button1Text)
			object:Dismiss()
		end)
	end

	table.insert(self.notifications, object)
	self.notificationsDirty = true
	layoutNotificationsGroups()

	return object
end

function v12:OnClicked()
	self.group:SwitchTo()
	layoutNotificationsGroups()
end

function v12:Dismiss()
	self.group:RemoveNotification(self)
end

local v14 = {}
local v15 = false
local count = 0

RobloxGui:WaitForChild("SendNotificationInfo").Event:connect(function(p)
	local v16 = p.GroupName and v7[p.GroupName]

	if not v16 then
		return
	end

	v12.new(v16, p)

	if not v15 then
		count += 1
		NotificationHub.UnreadCountChanged(count)
	end
end)

local function onMenuCloseShortcut(_, p, _)
	if p == Enum.UserInputState.Begin then
		NotificationHub:SetVisible(false)
	end
end

NotificationHub.VisibilityStateChanged = Create("BindableEvent")({ Name = "VisibilityStateChanged" })

function NotificationHub.GetNumberOfPendingNotifications(_)
	return #v14
end

function NotificationHub.IsVisible(_)
	return v15
end

function NotificationHub:SetVisible(p)
	if v15 == p then
		return
	end

	v15 = p

	Panel3D.Get("Topbar3D"):SetCanFade(not p)

	if p then
		count = 0
		NotificationHub.UnreadCountChanged(count)

		notifications.localCF = CFrame.new(-1.7079999929999998, 0, 0)
		v4.zeroCF = notifications.localCF

		v4:AnimateIn(nil)

		notificationDetails.localCF = CFrame.new(1.138666662, 0, 0)
		v6.zeroCF = notificationDetails.localCF

		v6:AnimateIn(nil)

		notifications:SetVisible(true)
		notificationDetails:SetVisible(true)

		ContextActionService:BindCoreAction(
			"NotificationsMenuCloseShortcut",
			onMenuCloseShortcut,
			false,
			Enum.KeyCode.ButtonB,
			Enum.KeyCode.ButtonStart
		)

		VRHub:FireModuleOpened(NotificationHub.ModuleName)
	else
		spawn(function()
			v4:AnimateOut(function()
				notifications:SetVisible(false)
			end)
			v6:AnimateOut(function()
				notificationDetails:SetVisible(false)
			end)
		end)

		ContextActionService:UnbindCoreAction("NotificationsMenuCloseShortcut")

		VRHub:FireModuleClosed(NotificationHub.ModuleName)
	end

	NotificationHub.VisibilityStateChanged:Fire(p)
end

VRHub.ModuleOpened.Event:connect(function(p, _, _, _)
	if p ~= NotificationHub.ModuleName then
		NotificationHub:SetVisible(false)
	end
end)

return NotificationHub
