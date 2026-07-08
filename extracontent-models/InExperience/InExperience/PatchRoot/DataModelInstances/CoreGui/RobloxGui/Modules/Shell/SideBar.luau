local Shell = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local GlobalSettings = require(Shell:FindFirstChild("GlobalSettings"))
local Utility = require(Shell:FindFirstChild("Utility"))
local ScreenManager = require(Shell:FindFirstChild("ScreenManager"))
local SoundManager = require(Shell:FindFirstChild("SoundManager"))
local Analytics = require(Shell:FindFirstChild("Analytics"))
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create

return function() -- line: 26
	-- upvalues: Create (copy), GlobalSettings (copy), SoundManager (copy), Analytics (copy), ScreenManager (copy), GuiService (copy), Utility (copy), EngineFeature (copy), ContextActionService (copy)
	local t1 = {}
	local t2 = {}
	local u14 = nil
	local u15 = false
	local v16 = Create("Frame")({
		Name = "ModalOverlay",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 4,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = GlobalSettings.ModalBackgroundColor
	})
	local v17 = Create("Frame")({
		Name = "SideBarContainer",
		BorderSizePixel = 0,
		ZIndex = 5,
		Size = UDim2.new(0.3, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = GlobalSettings.OverlayColor,
		Parent = v16
	})
	local v18 = Create("TextButton")({
		Name = "DummySelectionImage",
		Size = UDim2.new(0, 0, 0, 0),
		Visible = false,
		SoundManager:CreateSound("MoveSelection")
	})
	local v19 = Create("TextLabel")({
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

	local function recalcPositions() -- line: 83
		-- upvalues: t2 (copy)
		for i = 1, #t2 do
			t2[i].Position = UDim2.new(0, 0, 0, (i - 1) * 75 + 156)
		end
	end

	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "ClosedEvent"
	t1.Closed = BindableEvent.Event

	function t1.GetAnalyticsInfo(_) -- line: 96
		-- upvalues: Analytics (copy)
		return {
			[Analytics.WidgetNames("WidgetId")] = Analytics.WidgetNames("SideBarId")
		}
	end
	function t1.AddItem(_, p3, p4) -- line: 100
		-- upvalues: Create (copy), GlobalSettings (copy), v18 (copy), v17 (copy), SoundManager (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy), t2 (copy), recalcPositions (copy)
		local v27 = Create("TextButton")({
			Name = "SortButton",
			Size = UDim2.new(1, 0, 0, 75),
			BorderSizePixel = 0,
			BackgroundColor3 = GlobalSettings.BlueButtonColor,
			BackgroundTransparency = 1,
			ZIndex = 6,
			Text = "",
			SelectionImageObject = v18,
			Parent = v17,
			SoundManager:CreateSound("MoveSelection")
		})
		local v28 = Create("TextLabel")({
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
			Parent = v27
		})

		v27.MouseButton1Click:connect(function() -- line: 130
			-- upvalues: SoundManager (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy), p4 (copy)
			SoundManager:Play("ButtonPress")
			ScreenManager:CloseCurrent(t1)
			BindableEvent:Fire()
			p4()
		end)
		v27.SelectionGained:connect(function() -- line: 136
			-- upvalues: v27 (copy), v28 (copy), GlobalSettings (copy)
			v27.BackgroundTransparency = 0
			v28.TextColor3 = GlobalSettings.TextSelectedColor
		end)
		v27.SelectionLost:connect(function() -- line: 140
			-- upvalues: v27 (copy), v28 (copy), GlobalSettings (copy)
			v27.BackgroundTransparency = 1
			v28.TextColor3 = GlobalSettings.WhiteTextColor
		end)
		t2[#t2 + 1] = v27
		recalcPositions()
	end
	function t1.SetText(_, p6) -- line: 149
		-- upvalues: v19 (copy), v17 (copy)
		v19.Text = p6
		v19.Parent = v17
	end
	function t1.ResetText(_) -- line: 154
		-- upvalues: v19 (copy)
		v19.Text = ""
		v19.Parent = nil
	end
	function t1.RemoveAllItems(_) -- line: 159
		-- upvalues: t1 (copy), t2 (copy)
		t1:ResetText()

		for k, v in pairs(t2) do
			v:Destroy()
			t2[k] = nil
		end
	end
	function t1.SetSelectedObject(_, p10, p11) -- line: 167
		-- upvalues: t2 (copy), u14 (ref), u15 (ref), GuiService (copy)
		if #t2 > 0 then
			u14 = p10 and t2[p10] or t2[1]

			if p11 == true and u14 and u15 then
				GuiService.SelectedCoreObject = u14

				return
			end
		else
			u14 = nil
		end
	end
	function t1.GetPriority(_) -- line: 179
		-- upvalues: GlobalSettings (copy)
		return GlobalSettings.OverlayPriority
	end
	function t1.Show(p13) -- line: 183
		-- upvalues: v16 (copy), ScreenManager (copy), Utility (copy), GlobalSettings (copy), EngineFeature (copy), v17 (copy), SoundManager (copy)
		v16.Parent = ScreenManager:GetScreenGuiByPriority(p13:GetPriority())
		Utility.PropertyTweener(v16, "BackgroundTransparency", 1, GlobalSettings.ModalBackgroundTransparency, 0.25, Utility.EaseInOutQuad, true, nil)

		if EngineFeature then
			v17:TweenPositionInternal(UDim2.new(1 - v17.Size.X.Scale, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.25, true, nil)
		else
			v17:TweenPosition(UDim2.new(1 - v17.Size.X.Scale, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.25, true)
		end

		SoundManager:Play("SideMenuSlideIn")
	end
	function t1.Hide(_) -- line: 197
		-- upvalues: Utility (copy), v16 (copy), EngineFeature (copy), v17 (copy)
		Utility.PropertyTweener(v16, "BackgroundTransparency", 0.3, 1, 0.25, Utility.EaseInOutQuad, true, function() -- line: 199
			-- upvalues: v16 (copy)
			v16.Parent = nil
		end)

		if EngineFeature then
			v17:TweenPositionInternal(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, true)

			return
		end

		v17:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, true)
	end
	function t1.IsFocused(_) -- line: 209
		-- upvalues: u15 (ref)
		return u15
	end
	function t1.Focus(p16) -- line: 213
		-- upvalues: u15 (ref), GuiService (copy), v17 (copy), u14 (ref), Utility (copy), ContextActionService (copy), ScreenManager (copy), t1 (copy), BindableEvent (copy)
		u15 = true
		GuiService:AddSelectionParent("SideBar", v17)

		if u14 then
			Utility.SetSelectedCoreObject(u14)
		else
			p16:SetSelectedObject(1)
			Utility.SetSelectedCoreObject(u14)
		end

		ContextActionService:BindCoreAction("CloseSideBar", function(_, p18, _) -- line: 225
			-- upvalues: ScreenManager (copy), t1 (copy), BindableEvent (copy)
			if p18 == Enum.UserInputState.End then
				ScreenManager:CloseCurrent(t1)
				BindableEvent:Fire()
			end
		end, false, Enum.KeyCode.ButtonB)
	end
	function t1.RemoveFocus(_) -- line: 234
		-- upvalues: u15 (ref), GuiService (copy), ContextActionService (copy), u14 (ref)
		u15 = false
		GuiService:RemoveSelectionGroup("SideBar")
		ContextActionService:UnbindCoreAction("CloseSideBar")
		u14 = nil
	end

	return t1
end
