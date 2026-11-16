local CoreGui = game:GetService("CoreGui")
local shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")

local GlobalSettings = require(shell:FindFirstChild("GlobalSettings"))
local Utility = require(shell:FindFirstChild("Utility"))
local ScreenManager = require(shell:FindFirstChild("ScreenManager"))
local SoundManager = require(shell:FindFirstChild("SoundManager"))
local Analytics = require(shell:FindFirstChild("Analytics"))
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

return function()
	local class = {}

	local v = {}
	local selectedCoreObject = nil
	local v2 = false

	local parent = Create("Frame")({
		Name = "ModalOverlay",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = GlobalSettings.ModalBackgroundColor,
		BorderSizePixel = 0,
		ZIndex = 4
	})

	local parent2 = Create("Frame")({
		Name = "SideBarContainer",
		Size = UDim2.new(0.3, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = GlobalSettings.OverlayColor,
		ZIndex = 5,
		Parent = parent
	})

	local selectionImageObject = Create("TextButton")({
		Name = "DummySelectionImage",
		Size = UDim2.new(0, 0, 0, 0),
		Visible = false,
		SoundManager:CreateSound("MoveSelection")
	})

	local v3 = Create("TextLabel")({
		Name = "Text",
		Size = UDim2.new(1, -165, 1, -156),
		Position = UDim2.new(0, 65, 0, 156),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Text = "",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = GlobalSettings.WhiteTextColor,
		Font = GlobalSettings.RegularFont,
		FontSize = GlobalSettings.DescriptionSize,
		TextWrapped = true
	})

	local function recalcPositions()
		for i = 1, #v do
			v[i].Position = UDim2.new(0, 0, 0, (i - 1) * 75 + 156)
		end
	end

	local closedEvent = Instance.new("BindableEvent")
	closedEvent.Name = "ClosedEvent"
	class.Closed = closedEvent.Event

	function class.GetAnalyticsInfo(_)
		return {
			[Analytics.WidgetNames("WidgetId")] = Analytics.WidgetNames("SideBarId")
		}
	end

	function class.AddItem(_, text, callback)
		local parent3 = Create("TextButton")({
			Name = "SortButton",
			Size = UDim2.new(1, 0, 0, 75),
			BorderSizePixel = 0,
			BackgroundColor3 = GlobalSettings.BlueButtonColor,
			BackgroundTransparency = 1,
			ZIndex = 6,
			Text = "",
			SelectionImageObject = selectionImageObject,
			Parent = parent2,
			SoundManager:CreateSound("MoveSelection")
		})

		local v4 = Create("TextLabel")({
			Name = "SortName",
			Size = UDim2.new(1, -65, 1, 0),
			Position = UDim2.new(0, 65, 0, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = GlobalSettings.WhiteTextColor,
			Font = GlobalSettings.RegularFont,
			FontSize = GlobalSettings.MediumFontSize,
			ZIndex = 7,
			Parent = parent3
		})

		parent3.MouseButton1Click:connect(function()
			SoundManager:Play("ButtonPress")
			ScreenManager:CloseCurrent(class)
			closedEvent:Fire()
			callback()
		end)
		parent3.SelectionGained:connect(function()
			parent3.BackgroundTransparency = 0
			v4.TextColor3 = GlobalSettings.TextSelectedColor
		end)
		parent3.SelectionLost:connect(function()
			parent3.BackgroundTransparency = 1
			v4.TextColor3 = GlobalSettings.WhiteTextColor
		end)

		v[#v + 1] = parent3
		recalcPositions()
	end

	function class.SetText(_, text)
		v3.Text = text
		v3.Parent = parent2
	end

	function class:ResetText()
		v3.Text = ""
		v3.Parent = nil
	end

	function class.RemoveAllItems(_)
		class:ResetText()

		for k, v4 in pairs(v) do
			v4:Destroy()
			v[k] = nil
		end
	end

	function class:SetSelectedObject(p, p2)
		if #v > 0 then
			selectedCoreObject = p and v[p] or v[1]

			if p2 == true and selectedCoreObject and v2 then
				GuiService.SelectedCoreObject = selectedCoreObject
			end
		else
			selectedCoreObject = nil
		end
	end

	function class:GetPriority()
		return GlobalSettings.OverlayPriority
	end

	function class:Show()
		parent.Parent = ScreenManager:GetScreenGuiByPriority(self:GetPriority())
		Utility.PropertyTweener(
			parent,
			"BackgroundTransparency",
			1,
			GlobalSettings.ModalBackgroundTransparency,
			0.25,
			Utility.EaseInOutQuad,
			true,
			nil
		)
		parent2:TweenPositionInternal(
			UDim2.new(1 - parent2.Size.X.Scale, 0, 0, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad,
			0.25,
			true,
			nil
		)
		SoundManager:Play("SideMenuSlideIn")
	end

	function class.Hide(_)
		Utility.PropertyTweener(parent, "BackgroundTransparency", 0.3, 1, 0.25, Utility.EaseInOutQuad, true, function()
			parent.Parent = nil
		end)
		parent2:TweenPositionInternal(
			UDim2.new(1, 0, 0, 0),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Sine,
			0.25,
			true
		)
	end

	function class.IsFocused(_)
		return v2
	end

	function class:Focus()
		v2 = true
		GuiService:AddSelectionParent("SideBar", parent2)

		if not selectedCoreObject then
			self:SetSelectedObject(1)
		end

		Utility.SetSelectedCoreObject(selectedCoreObject)

		ContextActionService:BindCoreAction("CloseSideBar", function(_, p, _)
			if p == Enum.UserInputState.End then
				ScreenManager:CloseCurrent(class)
				closedEvent:Fire()
			end
		end, false, Enum.KeyCode.ButtonB)
	end

	function class.RemoveFocus(_)
		v2 = false
		GuiService:RemoveSelectionGroup("SideBar")
		ContextActionService:UnbindCoreAction("CloseSideBar")
		selectedCoreObject = nil
	end

	return class
end
