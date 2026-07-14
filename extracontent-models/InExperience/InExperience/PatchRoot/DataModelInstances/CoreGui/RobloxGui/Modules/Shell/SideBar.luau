local Shell = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local GlobalSettings = require(Shell:FindFirstChild("GlobalSettings"))
local Utility = require(Shell:FindFirstChild("Utility"))
local ScreenManager = require(Shell:FindFirstChild("ScreenManager"))
local SoundManager = require(Shell:FindFirstChild("SoundManager"))
local Analytics = require(Shell:FindFirstChild("Analytics"))
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create

return function() -- line: 24
	-- upvalues: Create (copy), GlobalSettings (copy), SoundManager (copy), Analytics (copy), ScreenManager (copy), GuiService (copy), Utility (copy), ContextActionService (copy)
	local t1 = {}
	local t2 = {}
	local u13 = nil
	local u14 = false
	local v15 = Create("Frame")({
		Name = "ModalOverlay",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 4,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = GlobalSettings.ModalBackgroundColor
	})
	local v16 = Create("Frame")({
		Name = "SideBarContainer",
		BorderSizePixel = 0,
		ZIndex = 5,
		Size = UDim2.new(0.3, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = GlobalSettings.OverlayColor,
		Parent = v15
	})
	local v17 = Create("TextButton")({
		Name = "DummySelectionImage",
		Size = UDim2.new(0, 0, 0, 0),
		Visible = false,
		SoundManager:CreateSound("MoveSelection")
	})
	local v18 = Create("TextLabel")({
		Name = "Text",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Text = "",
		TextWrapped = true,
		Size = UDim2.new(1, -165, 1, -156),
		Position = UDim2.new(0, 65, 0, 156),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = GlobalSettings.WhiteTextColor,
		Font = GlobalSettings.RegularFont,
		FontSize = GlobalSettings.DescriptionSize
	})

	local function recalcPositions() -- line: 81
		-- upvalues: t2 (copy)
		for i = 1, #t2 do
			t2[i].Position = UDim2.new(0, 0, 0, (i - 1) * 75 + 156)
		end
	end

	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ClosedEvent"
	t1.Closed = BindableEvent.Event

	function t1.GetAnalyticsInfo(_) -- line: 94
		-- upvalues: Analytics (copy)
		return {
			[Analytics.WidgetNames("WidgetId")] = Analytics.WidgetNames("SideBarId")
		}
	end
	function t1.AddItem(_, p3, p4) -- line: 98
		-- upvalues: Create (copy), GlobalSettings (copy), v17 (copy), v16 (copy), SoundManager (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy), t2 (copy), recalcPositions (copy)
		local v26 = Create("TextButton")({
			Name = "SortButton",
			Size = UDim2.new(1, 0, 0, 75),
			BorderSizePixel = 0,
			BackgroundColor3 = GlobalSettings.BlueButtonColor,
			BackgroundTransparency = 1,
			ZIndex = 6,
			Text = "",
			SelectionImageObject = v17,
			Parent = v16,
			SoundManager:CreateSound("MoveSelection")
		})
		local v27 = Create("TextLabel")({
			Name = "SortName",
			BackgroundTransparency = 1,
			ZIndex = 7,
			Size = UDim2.new(1, -65, 1, 0),
			Position = UDim2.new(0, 65, 0, 0),
			Text = p3,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = GlobalSettings.WhiteTextColor,
			Font = GlobalSettings.RegularFont,
			FontSize = GlobalSettings.MediumFontSize,
			Parent = v26
		})

		v26.MouseButton1Click:connect(function() -- line: 128
			-- upvalues: SoundManager (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy), p4 (copy)
			SoundManager:Play("ButtonPress")
			ScreenManager:CloseCurrent(t1)
			BindableEvent:Fire()
			p4()
		end)
		v26.SelectionGained:connect(function() -- line: 134
			-- upvalues: v26 (copy), v27 (copy), GlobalSettings (copy)
			v26.BackgroundTransparency = 0
			v27.TextColor3 = GlobalSettings.TextSelectedColor
		end)
		v26.SelectionLost:connect(function() -- line: 138
			-- upvalues: v26 (copy), v27 (copy), GlobalSettings (copy)
			v26.BackgroundTransparency = 1
			v27.TextColor3 = GlobalSettings.WhiteTextColor
		end)
		t2[#t2 + 1] = v26
		recalcPositions()
	end
	function t1.SetText(_, p6) -- line: 147
		-- upvalues: v18 (copy), v16 (copy)
		v18.Text = p6
		v18.Parent = v16
	end
	function t1.ResetText(_) -- line: 152
		-- upvalues: v18 (copy)
		v18.Text = ""
		v18.Parent = nil
	end
	function t1.RemoveAllItems(_) -- line: 157
		-- upvalues: t1 (copy), t2 (copy)
		t1:ResetText()

		for k, v in pairs(t2) do
			v:Destroy()
			t2[k] = nil
		end
	end
	function t1.SetSelectedObject(_, p10, p11) -- line: 165
		-- upvalues: t2 (copy), u13 (ref), u14 (ref), GuiService (copy)
		if #t2 > 0 then
			u13 = p10 and t2[p10] or t2[1]

			if p11 == true and u13 and u14 then
				GuiService.SelectedCoreObject = u13

				return
			end
		else
			u13 = nil
		end
	end
	function t1.GetPriority(_) -- line: 177
		-- upvalues: GlobalSettings (copy)
		return GlobalSettings.OverlayPriority
	end
	function t1.Show(p13) -- line: 181
		-- upvalues: v15 (copy), ScreenManager (copy), Utility (copy), GlobalSettings (copy), v16 (copy), SoundManager (copy)
		v15.Parent = ScreenManager:GetScreenGuiByPriority(p13:GetPriority())
		Utility.PropertyTweener(v15, "BackgroundTransparency", 1, GlobalSettings.ModalBackgroundTransparency, 0.25, Utility.EaseInOutQuad, true, nil)
		v16:TweenPositionInternal(UDim2.new(1 - v16.Size.X.Scale, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.25, true, nil)
		SoundManager:Play("SideMenuSlideIn")
	end
	function t1.Hide(_) -- line: 190
		-- upvalues: Utility (copy), v15 (copy), v16 (copy)
		Utility.PropertyTweener(v15, "BackgroundTransparency", 0.3, 1, 0.25, Utility.EaseInOutQuad, true, function() -- line: 192
			-- upvalues: v15 (copy)
			v15.Parent = nil
		end)
		v16:TweenPositionInternal(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, true)
	end
	function t1.IsFocused(_) -- line: 198
		-- upvalues: u14 (ref)
		return u14
	end
	function t1.Focus(p16) -- line: 202
		-- upvalues: u14 (ref), GuiService (copy), v16 (copy), u13 (ref), Utility (copy), ContextActionService (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy)
		u14 = true
		GuiService:AddSelectionParent("SideBar", v16)

		if u13 then
			Utility.SetSelectedCoreObject(u13)
		else
			p16:SetSelectedObject(1)
			Utility.SetSelectedCoreObject(u13)
		end

		ContextActionService:BindCoreAction("CloseSideBar", function(_, p18, _) -- line: 214
			-- upvalues: ScreenManager (copy), t1 (copy), BindableEvent (copy)
			if p18 == Enum.UserInputState.End then
				ScreenManager:CloseCurrent(t1)
				BindableEvent:Fire()
			end
		end, false, Enum.KeyCode.ButtonB)
	end
	function t1.RemoveFocus(_) -- line: 223
		-- upvalues: u14 (ref), GuiService (copy), ContextActionService (copy), u13 (ref)
		u14 = false
		GuiService:RemoveSelectionGroup("SideBar")
		ContextActionService:UnbindCoreAction("CloseSideBar")
		u13 = nil
	end

	return t1
end
