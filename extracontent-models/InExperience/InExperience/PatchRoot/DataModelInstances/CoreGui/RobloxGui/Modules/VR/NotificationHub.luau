local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local _ = CFrame.Angles(-0.08726646259971647, 0, 0) * CFrame.new(0, 4, 0) * CFrame.Angles(-0.2617993877991494, 0, 0)
local color3 = Color3.new(0.3058823529411765, 0.32941176470588235, 0.3764705882352941)
local color3_2 = Color3.new(0.3215686274509804, 0.396078431372549, 0.5529411764705883)
local color3_3 = Color3.new(0.0784313725490196, 0.0784313725490196, 0.0784313725490196)
local color3_4 = Color3.new(0.2, 0.2, 0.2)
local v14 = Create("ImageLabel")({
	BackgroundTransparency = 1,
	Image = ""
})
local color3_5 = Color3.new(1, 1, 1)
local t1 = {
	ModuleName = "Notifications",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = true,
	UnreadCountChanged = function(...) -- line: 79
	end,
	SetVisible = nil
}

VRHub:RegisterModule(t1)

local v17 = Panel3D.Get("Notifications")
local v18 = Panel3D.Get("NotificationDetails")

local function IsDeveloperGroupEnabled() -- line: 88
	return false
end

local t2 = {}
local t3 = {}
local t4 = {
	__index = t2
}

function t2.new(p1, p2, p3) -- line: 96
	-- upvalues: t3 (copy), Create (copy), color3 (copy), color3_5 (copy), color3_3 (copy), t4 (copy)
	local t5 = {}

	table.insert(t3, t5)
	t5.zeroCF = p1.localCF
	t5.zOffset = 0
	t5.isPopping = false
	t5.isAnimating = false
	t5.tweener = nil
	t5.panel = p1
	t5.SetPopOut = nil

	function t5.panel.OnMouseEnter() -- line: 106
		-- upvalues: t3 (copy), t5 (copy)
		for _, v in pairs(t3) do
			if v ~= t5 then
				v:SetPopOut(false)
			end
		end

		t5:SetPopOut(true)
	end

	t5.titlebar = Create("ImageLabel")({
		Name = "TitlebarBackground",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		Parent = p2,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 0, 74),
		ImageColor3 = color3,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})
	t5.titleText = Create("TextLabel")({
		Name = "TitleText",
		BackgroundTransparency = 1,
		Parent = t5.titlebar,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Text = p3,
		TextColor3 = color3_5,
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size36
	})
	t5.content = Create("ImageLabel")({
		Name = "ContentFrame",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageTransparency = 0.5,
		Parent = p2,
		Position = UDim2.new(0, -1, 0, 74),
		Size = UDim2.new(1, 2, 1, -76),
		ImageColor3 = color3_3,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})

	return (setmetatable(t5, t4))
end
function t2.SetTitle(p4, p5) -- line: 163
	p4.titleText.Text = p5
end
function t2.AddCloseButton(p6, p7) -- line: 167
	-- upvalues: Create (copy)
	p6.closeButton = Create("ImageButton")({
		Name = "CloseButton",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Keyboard/close_button_icon.png",
		Parent = p6.titlebar,
		Position = UDim2.new(0, 22, 0, 22),
		Size = UDim2.new(0, 32, 0, 32),
		SelectionImageObject = Create("ImageButton")({
			Name = "CloseButtonHover",
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png",
			Position = UDim2.new(0, -11, 0, -11),
			Size = UDim2.new(1, 22, 1, 22)
		})
	})
	p6.closeButton.MouseButton1Click:connect(p7)
end
function t2.TweenZOffsetTo(p8, p9, p10, p11, p12) -- line: 189
	-- upvalues: Utility (copy)
	if p8.tweener and not p8.tweener:IsFinished() then
		p8.tweener:Cancel()
	end

	p8.tweener = Utility:TweenProperty(p8, "zOffset", p8.zOffset, p9, p10, p11, p12)
end
function t2.AnimateOut(p13, p14) -- line: 196
	-- upvalues: Utility (copy)
	p13.isAnimating = true
	p13:TweenZOffsetTo(-100, 0.25, Utility:GetEaseInOutQuad(), function() -- line: 198
		-- upvalues: p14 (copy), p13 (copy)
		if p14 then
			p14()
		end

		p13.isAnimating = false
	end)
end
function t2.AnimateIn(p15, p16) -- line: 204
	-- upvalues: Utility (copy)
	p15.zOffset = -100
	p15:OnUpdate(0)
	p15.isAnimating = true
	p15:TweenZOffsetTo(0, 0.25, Utility:GetEaseInOutQuad(), function() -- line: 208
		-- upvalues: p16 (copy), p15 (copy)
		if p16 then
			p16()
		end

		p15.isAnimating = false
	end)
end
function t2.SetPopOut(p17, p18) -- line: 214
	-- upvalues: Utility (copy)
	if p17.isAnimating then
		return
	end

	if p18 then
		p17.isPopping = true
		p17:TweenZOffsetTo(0.25, 0.25, Utility:GetEaseInOutQuad(), function() -- line: 221
			-- upvalues: p17 (copy)
			p17.isPopping = false
		end)

		return
	end

	p17.isPopping = true
	p17:TweenZOffsetTo(0, 0.25, Utility:GetEaseInOutQuad(), function() -- line: 226
		-- upvalues: p17 (copy)
		p17.isPopping = false
	end)
end
function t2.OnUpdate(p19, _) -- line: 232
	-- upvalues: color3 (copy), color3_2 (copy)
	p19.panel.localCF = p19.zeroCF * CFrame.new(0, 0, p19.zOffset)
	p19.panel.needsLocalPositionUpdate = p19.isAnimating or p19.isPopping

	if p19.isPopping then
		local v62 = math.max(0, (math.min(1, p19.zOffset / 0.25)))

		p19.titlebar.ImageColor3 = color3:lerp(color3_2, v62)
	end
end

v17:SetType(Panel3D.Type.Standard)
v17:SetVisible(false)
v17:SetCanFade(false)
v17:ResizeStuds(2.277333324, 3.5, 150)

local v23 = Create("TextButton")({
	Name = "NotificationsListFrame",
	BackgroundTransparency = 1,
	Text = "",
	Selectable = true,
	Parent = v17:GetGUI(),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, -4, 1, 0),
	SelectionImageObject = v14
})
local u24 = t2.new(v17, v23, "Notifications")

u24:AddCloseButton(function() -- line: 263
	-- upvalues: t1 (copy)
	t1:SetVisible(false)
end)

function v17.OnUpdate(_, p22) -- line: 266
	-- upvalues: u24 (ref)
	u24:OnUpdate(p22)
end

v18:SetType(Panel3D.Type.Standard)
v18:SetVisible(false)
v18:SetCanFade(false)
v18:ResizeStuds(3.4159999859999997, 3.5, 150)

local v25 = Create("TextButton")({
	Name = "NotificationsDetailFrame",
	BackgroundTransparency = 1,
	Text = "",
	Selectable = true,
	Parent = v18:GetGUI(),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	SelectionImageObject = v14
})
local u26 = t2.new(v18, v25, "Friend Requests")

function v18.OnUpdate(_, p24) -- line: 291
	-- upvalues: u26 (ref)
	u26:OnUpdate(p24)
end

local t6 = {}
local t7 = {}

local function groupSort(p25, p26) -- line: 298
	return p25.order < p26.order
end

local u30 = nil

local function layoutNotificationsGroups() -- line: 303
	-- upvalues: t7 (copy), v17 (copy), u30 (ref)
	local n1 = 20

	for _, v in ipairs(t7) do
		if #v.notifications > 0 then
			local v72 = (math.min(3, #v.notifications) - 1) * 20 + 80

			v.frame.Position = UDim2.new(0.07500000000000001, 0, 0, n1)
			v.frame.Size = UDim2.new(0.85, -40, 0, v72)
			n1 = n1 + v72 + 20

			if v.notificationsDirty then
				v.notificationsDirty = false

				local n2 = 0
				local n3 = 0
				local v75 = #v.notifications

				if v75 > 0 then
					local v76 = math.max(1, v75 - 3 + 1)

					for i = 1, v75 do
						local v78 = v.notifications[i]

						if v76 <= i then
							v78.frame.Visible = true
							v78.frame.Position = UDim2.new(0, n2, 0, n2)
							n2 += 20
							v17:SetSubpanelDepth(v78.frame, n3)
							n3 += 0.25
						else
							v78.frame.Visible = false
						end
					end

					if v == u30 then
						local v79 = math.max(1, v75 - 2 + 1)
						local n4 = 0

						for i = 1, v75 do
							local v82 = v.notifications[i]

							if v79 <= i then
								v82.detailsFrame.Visible = true
								v82.detailsFrame.Position = UDim2.new(0, 20, n4, 20)
								v82.detailsFrame.Size = UDim2.new(1, -40, 0.5, -40)
								n4 += 0.5
							else
								v82.detailsFrame.Visible = false
							end
						end
					end
				end
			end
		end
	end
end

local t8 = {}
local t9 = {
	__index = t8
}

function t8.new(p27, p28, p29) -- line: 362
	-- upvalues: t9 (copy), Create (copy), u24 (ref), t6 (copy), t7 (copy)
	local self = setmetatable({}, t9)

	self.key = p27
	self.title = p28
	self.order = p29
	self.notifications = {}
	self.notificationsDirty = false
	self.frame = Create("Frame")({
		Name = "NotificationGroup",
		BackgroundTransparency = 1,
		Parent = u24.content
	})
	self.detailsFrame = Create("Frame")({
		Parent = nil,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})
	t6[p27] = self
	table.insert(t7, self)

	return self
end
function t8.Deactivate(p30) -- line: 389
	-- upvalues: v18 (copy)
	p30.detailsFrame.Parent = nil

	for _, child in pairs(p30.detailsFrame:GetChildren()) do
		v18:RemoveSubpanel(child)
	end
end
function t8.SwitchTo(p31) -- line: 396
	-- upvalues: u26 (ref), t6 (copy), u30 (ref)
	u26:SetTitle(p31.title)

	for _, v in pairs(t6) do
		if v ~= p31 then
			v:Deactivate()
		end
	end

	p31.detailsFrame.Parent = u26.content
	u30 = p31
	p31.notificationsDirty = true
end
function t8.BringNotificationToFront(p32, p33) -- line: 409
	-- upvalues: u30 (ref), layoutNotificationsGroups (copy)
	if p32 ~= u30 then
		p32:SwitchTo()
	end

	if #p32.notifications ~= 0 and p33 == p32.notifications[#p32.notifications] then
		layoutNotificationsGroups()

		return
	end

	for i, v in ipairs(p32.notifications) do
		if v == p33 then
			table.remove(p32.notifications, i)

			break
		end
	end

	table.insert(p32.notifications, p33)
	p32.notificationsDirty = true
	layoutNotificationsGroups()
end
function t8.RemoveNotification(p34, p35) -- line: 432
	-- upvalues: v17 (copy), v18 (copy), layoutNotificationsGroups (copy)
	for i, v in ipairs(p34.notifications) do
		if v == p35 then
			table.remove(p34.notifications, i)
			v17:RemoveSubpanel(p35.frame)
			v18:RemoveSubpanel(p35.detailsFrame)
			p35.detailsFrame:Destroy()
			p35.frame:Destroy()
			p34.notificationsDirty = true
			layoutNotificationsGroups()

			return
		end
	end
end
function t8.GetTopNotification(p36) -- line: 448
	local v102 = #p36.notifications

	if v102 <= 0 then
		return nil
	end

	return p36.notifications[v102]
end

t8.new("Friends", "Friends", 1)
t8.new("BadgeAwards", "Badges", 2)
t8.new("PlayerPoints", "Points", 3)

if false then
	t8.new("Developer", "Other", 4)
end

table.sort(t7, groupSort)

local function doCallback(p37, ...) -- line: 465
	if not p37 then
		return
	end

	if type(p37) == "function" then
		p37(...)

		return
	end

	if p37:IsA("BindableEvent") then
		p37:Fire(...)

		return
	end

	if p37:IsA("BindableFunction") then
		p37:Invoke(...)

		return
	end
end

local t10 = {}
local t11 = {
	__index = t10
}

function t10.new(p38, p39) -- line: 487
	-- upvalues: t11 (copy), Create (copy), v14 (copy), color3_4 (copy), color3_5 (copy), v18 (copy), doCallback (copy), layoutNotificationsGroups (copy)
	local self = setmetatable({}, t11)

	self.group = p38
	self.frame = Create("ImageButton")({
		BackgroundTransparency = 1,
		Parent = p38.frame,
		Size = UDim2.new(1, 0, 0, 80),
		SelectionImageObject = v14
	})
	self.frame.MouseButton1Click:connect(function() -- line: 498
		-- upvalues: self (copy)
		self:OnClicked()
	end)
	self.background = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/vr/rectBackgroundWhite.png",
		ImageTransparency = 0.1,
		Parent = self.frame,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 1, 2),
		ImageColor3 = color3_4,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})
	self.imageBackground = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/circleWhite.png",
		Parent = self.frame,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, 70, 0, 70),
		ImageColor3 = p39.imgBackgroundColor or Color3.new(1, 1, 1)
	})
	self.image = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Parent = self.imageBackground,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Image = p39.Image
	})

	local p39Text = p39.Text

	if p39.Title and p39.Text then
		p39Text = ("%s\n%s"):format(p39.Title, p39.Text)
	end

	self.text = Create("TextLabel")({
		BackgroundTransparency = 1,
		TextWrapped = true,
		Parent = self.frame,
		Position = UDim2.new(0, 80, 0, 0),
		Size = UDim2.new(1, -80, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = p39Text,
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size18,
		TextColor3 = color3_5
	})
	self.detailsFrame = Create("Frame")({
		BackgroundTransparency = 1,
		Parent = p38.detailsFrame
	})
	self.detailsFrame.MouseEnter:connect(function() -- line: 558
		-- upvalues: v18 (copy), self (copy)
		v18:SetSubpanelDepth(self.detailsFrame, 0.25)
	end)
	self.detailsFrame.MouseLeave:connect(function() -- line: 561
		-- upvalues: v18 (copy), self (copy)
		v18:SetSubpanelDepth(self.detailsFrame, 0)
	end)
	self.detailsBackground = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
		ImageTransparency = 0.1,
		Parent = self.detailsFrame,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(1, 2, 1, 2),
		ImageColor3 = Color3.new(0.2, 0.2, 0.2),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 10, 10)
	})
	self.detailsIconBackground = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/VR/circleWhite.png",
		Parent = self.detailsFrame,
		Position = UDim2.new(0, 20, 0, 10),
		Size = UDim2.new(0, 80, 0, 80),
		ImageColor3 = p39.imgBackgroundColor or Color3.new(1, 1, 1)
	})
	self.detailsIcon = Create("ImageLabel")({
		BackgroundTransparency = 1,
		Parent = self.detailsIconBackground,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Image = p39.Image
	})

	local v108 = p39.DetailText or p39.Title

	self.detailsText = Create("TextLabel")({
		BackgroundTransparency = 1,
		TextWrapped = true,
		Parent = self.detailsFrame,
		Position = UDim2.new(0, 110, 0, 10),
		Size = UDim2.new(1, -120, 0, 90),
		Text = v108,
		TextColor3 = color3_5,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size36
	})

	local function createButton(p40, p41, p42) -- line: 614
		-- upvalues: Create (copy), self (copy), v14 (copy), color3_5 (copy)
		local v136 = Create("ImageButton")({
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
			Parent = self.detailsFrame,
			Position = UDim2.new(p40, 0, 0.55, 0),
			Size = UDim2.new(p41, 0, 0.29, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 6, 46, 44),
			SelectionImageObject = v14
		})
		local v137 = Create("TextLabel")({
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, -6),
			Text = p42,
			TextColor3 = color3_5,
			Font = Enum.Font.SourceSansBold,
			FontSize = Enum.FontSize.Size24
		})

		v137.Parent = v136
		v136.SelectionGained:connect(function() -- line: 640
			-- upvalues: v136 (copy)
			v136.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"
		end)
		v136.SelectionLost:connect(function() -- line: 643
			-- upvalues: v136 (copy)
			v136.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
		end)

		return v136, v137
	end

	if p39.Button1Text and p39.Button2Text then
		local v110, v111 = createButton(0.07, 0.415, p39.Button1Text)

		self.detailsButton1 = v110
		self.detailsButton1Text = v111

		local v112, v113 = createButton(0.511, 0.415, p39.Button2Text)

		self.detailsButton2 = v112
		self.detailsButton2Text = v113
		self.detailsButton1.MouseButton1Click:connect(function() -- line: 653
			-- upvalues: doCallback (copy), p39 (copy), self (copy)
			doCallback(p39.Callback, p39.Button1Text)
			self:Dismiss()
		end)
		self.detailsButton2.MouseButton1Click:connect(function() -- line: 657
			-- upvalues: doCallback (copy), p39 (copy), self (copy)
			doCallback(p39.Callback, p39.Button2Text)
			self:Dismiss()
		end)
	elseif not p39.button2Text then
		local v114, v115 = createButton(0.07, 0.86, p39.Button1Text or "Dismiss")

		self.detailsButton1 = v114
		self.detailsButton1Text = v115
		self.detailsButton1.MouseButton1Click:connect(function() -- line: 664
			-- upvalues: doCallback (copy), p39 (copy), self (copy)
			doCallback(p39.Callback, p39.Button1Text)
			self:Dismiss()
		end)
	end

	table.insert(p38.notifications, self)
	p38.notificationsDirty = true
	layoutNotificationsGroups()

	return self
end
function t10.OnClicked(p43) -- line: 677
	-- upvalues: layoutNotificationsGroups (copy)
	p43.group:SwitchTo()
	layoutNotificationsGroups()
end
function t10.Dismiss(p44) -- line: 685
	p44.group:RemoveNotification(p44)
end

local t12 = {}
local u38 = false
local n5 = 0

RobloxGui:WaitForChild("SendNotificationInfo").Event:connect(function(p45) -- line: 697
	-- upvalues: t6 (copy), t10 (copy), u38 (ref), n5 (ref), t1 (copy)
	local v119 = p45.GroupName and t6[p45.GroupName]

	if not v119 then
		if not false then
			return
		end

		v119 = t6.Developer
	end

	t10.new(v119, p45)

	if not u38 then
		n5 += 1
		t1.UnreadCountChanged(n5)
	end
end)

local function onMenuCloseShortcut(_, p47, _) -- line: 716
	-- upvalues: t1 (copy)
	if p47 == Enum.UserInputState.Begin then
		t1:SetVisible(false)
	end
end

t1.VisibilityStateChanged = Create("BindableEvent")({
	Name = "VisibilityStateChanged"
})

function t1.GetNumberOfPendingNotifications(_) -- line: 726
	-- upvalues: t12 (copy)
	return #t12
end
function t1.IsVisible(_) -- line: 730
	-- upvalues: u38 (ref)
	return u38
end
function t1.SetVisible(_, p52) -- line: 734
	-- upvalues: u38 (ref), Panel3D (copy), n5 (ref), t1 (copy), v17 (copy), u24 (ref), v18 (copy), u26 (ref), ContextActionService (copy), onMenuCloseShortcut (copy), VRHub (copy)
	if p52 == u38 then
		return
	end

	u38 = p52
	Panel3D.Get("Topbar3D"):SetCanFade(not p52)

	if p52 then
		n5 = 0
		t1.UnreadCountChanged(n5)
		v17.localCF = CFrame.new(-1.7079999929999998, 0, 0)
		u24.zeroCF = v17.localCF
		u24:AnimateIn(nil)
		v18.localCF = CFrame.new(1.138666662, 0, 0)
		u26.zeroCF = v18.localCF
		u26:AnimateIn(nil)
		v17:SetVisible(true)
		v18:SetVisible(true)
		ContextActionService:BindCoreAction("NotificationsMenuCloseShortcut", onMenuCloseShortcut, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)
		VRHub:FireModuleOpened(t1.ModuleName)
	else
		spawn(function() -- line: 766
			-- upvalues: u24 (ref), v17 (copy), u26 (ref), v18 (copy)
			u24:AnimateOut(function() -- line: 767
				-- upvalues: v17 (copy)
				v17:SetVisible(false)
			end)
			u26:AnimateOut(function() -- line: 770
				-- upvalues: v18 (copy)
				v18:SetVisible(false)
			end)
		end)
		ContextActionService:UnbindCoreAction("NotificationsMenuCloseShortcut")
		VRHub:FireModuleClosed(t1.ModuleName)
	end

	t1.VisibilityStateChanged:Fire(p52)
end

VRHub.ModuleOpened.Event:connect(function(p53, _, _, _) -- line: 788
	-- upvalues: t1 (copy)
	if p53 ~= t1.ModuleName then
		t1:SetVisible(false)
	end
end)

return t1
