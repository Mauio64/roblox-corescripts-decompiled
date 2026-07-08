local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TweenService = game:GetService("TweenService")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local Signal = AppCommonLib.Signal

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local v13 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local GetFFlagFixIGMTabTransitions = require(script.Parent.Flags.GetFFlagFixIGMTabTransitions)
local FFlagIEMSettingsGroups = require(script.Parent.Flags.FFlagIEMSettingsGroups)
local FFlagIEMFocusNavSupportNewButtons = require(script.Parent.Flags.FFlagIEMFocusNavSupportNewButtons)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagIEMFocusNavToButtons = SharedFlags.FFlagIEMFocusNavToButtons
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagIEMFocusNavPeoplePageToButtons = SharedFlags.FFlagIEMFocusNavPeoplePageToButtons
local FFlagIEMSettingsPageDisplaying = SharedFlags.FFlagIEMSettingsPageDisplaying
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")

local function Initialize() -- line: 48
	-- upvalues: FFlagEnableSideSheet (copy), FFlagIEMFocusNavToButtons (copy), Signal (copy), FFlagIEMTabFocusNav (copy), Create (copy), Utility (copy), v13 (copy), Theme (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), GuiService (copy), HttpService (copy), FFlagIEMSettingsGroups (copy), FFlagIEMFocusNavSupportNewButtons (copy), CoreGui (copy), FFlagIEMSettingsPageDisplaying (copy), UserGameSettings (copy), GetFFlagFixIGMTabTransitions (copy), TweenService (copy), EngineFeature (copy)
	local t1 = {
		HubRef = nil,
		LastSelectedObject = nil,
		TabPosition = 0,
		Active = false,
		OpenStateChangedCount = 0,
		ShouldShowBottomBar = not FFlagEnableSideSheet,
		ShouldShowHubBar = true,
		ShouldDisableDefaultScroll = false,
		IsPageClipped = true,
		SelectARow = nil
	}

	if FFlagIEMFocusNavToButtons then
		t1.LastSelectableObjectsUpdated = Signal.new()
		t1.LastSelectableObjects = {}
		t1.PageNextSelectionDown = nil
	end

	if FFlagIEMTabFocusNav then
		t1.FirstSelectableObjectsUpdated = Signal.new()
		t1.FirstSelectableObjects = {}
	end

	local t2 = {}
	local u27 = false

	t1.TabHeader = Create("TextButton")({
		Name = "Header",
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.2, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Selectable = not not FFlagIEMTabFocusNav or not FFlagIEMFocusNavToButtons and nil
	})

	if Utility:IsSmallTouchScreen() then
		t1.TabHeader.Size = UDim2.new(0, 84, 1, 0)
	elseif v13 then
		t1.TabHeader.Size = UDim2.new(0, 220, 1, 0)
	end

	if FFlagIEMTabFocusNav then
		local function switchToPage() -- line: 87
			-- upvalues: t1 (copy)
			if t1.HubRef and t1.HubRef.Pages.CurrentPage ~= t1 then
				t1.HubRef:SwitchToPage(t1, true)
			end
		end

		t1.TabHeader.Activated:connect(switchToPage)
		t1.TabHeader.SelectionGained:connect(switchToPage)
	else
		t1.TabHeader.MouseButton1Click:connect(function() -- line: 95
			-- upvalues: t1 (copy)
			if t1.HubRef then
				t1.HubRef:SwitchToPage(t1, true)
			end
		end)
	end

	local v29 = Create("TextLabel")({
		Name = "Icon",
		BackgroundTransparency = 1,
		Text = "",
		TextScaled = true,
		TextTransparency = 0.5,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0.5, -18),
		TextColor3 = Color3.new(1, 1, 1),
		Parent = t1.TabHeader
	})

	Create("UIAspectRatioConstraint")({
		Name = "AspectRatioConstraint",
		AspectRatio = 1,
		Parent = v29
	})

	local v30 = Create("TextLabel")({
		Name = "Title",
		Text = "",
		BackgroundTransparency = 1,
		TextTransparency = 0.5,
		Font = Theme.font(Enum.Font.SourceSansBold, "Button"),
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1.05, 0, 1, 0),
		Position = UDim2.new(1.2, Theme.TabHeaderIconPadding, 0, -2),
		TextXAlignment = Enum.TextXAlignment.Left
	})

	v30.TextSize = Theme.textSize(24)

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

	UITextSizeConstraint.MaxTextSize = Theme.textSize(24)
	v30.Parent = v29

	if Utility:IsPortrait() and Utility:IsSmallTouchScreen() then
		UITextSizeConstraint.Parent = v30
	end

	if Utility:IsSmallTouchScreen() then
		v30.TextSize = Theme.textSize(18)
		UITextSizeConstraint.MaxTextSize = Theme.textSize(18)
	elseif v13 then
		v30.TextSize = Theme.textSize(48)
		UITextSizeConstraint.MaxTextSize = Theme.textSize(48)
	end

	Create("ImageLabel")({
		Name = "TabSelection",
		Visible = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.color("TabSelection"),
		BackgroundTransparency = Theme.transparency("TabSelection"),
		Size = UDim2.new(1, -2, 0, 2),
		Position = UDim2.new(0, 3, 1, -2),
		Parent = t1.TabHeader
	})

	local v32 = Create("Frame")({
		Name = "TabLabel",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = t1.TabHeader
	})

	Create("UIListLayout")({
		Name = "Layout",
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = v32
	})
	v29.Parent = v32
	v30.Parent = v32
	v30.Size = UDim2.new(0, 0, 0, 0)
	v30.AutomaticSize = Enum.AutomaticSize.XY

	local function onResized() -- line: 180
		-- upvalues: t1 (copy), Utility (copy), v29 (copy), v13 (copy), Theme (copy), v32 (copy), v30 (copy)
		if not t1.TabHeader then
			return
		end

		if Utility:IsSmallTouchScreen() then
			v29.Size = UDim2.new(0, 34, 0, 28)
		elseif v13 then
			v29.Size = UDim2.new(0, 88, 0, 74)
		else
			local v35 = Theme.getIconSize(Theme.IconSize.Medium)

			v29.Size = UDim2.fromOffset(v35, v35)
		end

		local v36 = Utility:IsPortrait()
		local Layout = v32.Layout

		if v36 then
			if Utility:IsSmallTouchScreen() then
				v30.FontSize = Theme.fontSize(Enum.FontSize.Size14)
			end

			v29.Size = UDim2.new(0, 22, 0, 22)
			Layout.FillDirection = Enum.FillDirection.Vertical
			Layout.Padding = UDim.new(0, 0)
		else
			if Utility:IsSmallTouchScreen() then
				v30.FontSize = Theme.fontSize(Enum.FontSize.Size18)
			end

			Layout.FillDirection = Enum.FillDirection.Horizontal
			Layout.Padding = UDim.new(0, 10)
		end

		v29.Size = UDim2.fromOffset(v29.Size.X.Offset * 0.6666666666666666, v29.Size.Y.Offset * 0.6666666666666666)
	end

	Utility:OnResized(t1.TabHeader, onResized)
	t1.Page = Create("Frame")({
		Name = "Page",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
	Create("UIPadding")({
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 11),
		Parent = t1.Page
	})
	t1.PageListLayout = Create("UIListLayout")({
		Name = "RowListLayout",
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = t1.Page
	})

	if FFlagIEMFocusNavPeoplePageToButtons then
		t1.Page.SelectionGroup = true
	else
		GuiService:AddSelectionParent(HttpService:GenerateGUID(false), t1.Page)
	end

	t1.Displaying = Instance.new("BindableEvent")
	t1.Displaying.Name = "Displaying"
	t1.Displayed = Instance.new("BindableEvent")
	t1.Displayed.Name = "Displayed"
	t1.Displayed.Event:connect(function() -- line: 257
		-- upvalues: t1 (copy)
		if not t1.HubRef.Shield.Visible then
			return
		end

		t1:SelectARow()
	end)
	t1.Hidden = Instance.new("BindableEvent")
	t1.Hidden.Event:connect(function() -- line: 265
		-- upvalues: GuiService (copy), t1 (copy)
		if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(t1.Page) then
			GuiService.SelectedCoreObject = nil
		end
	end)
	t1.Hidden.Name = "Hidden"

	function t1.getValueChangerFrame(_, p2) -- line: 273
		if type(p2) ~= "table" then
			return p2
		end

		return p2.SliderFrame and p2.SliderFrame or (p2.SelectorFrame or p2.DropDownFrame)
	end
	function t1.SelectARow(_, p4) -- line: 287
		-- upvalues: FFlagIEMTabFocusNav (copy), GuiService (copy), t1 (copy), t2 (copy), FFlagIEMSettingsGroups (copy), FFlagIEMFocusNavToButtons (copy), FFlagIEMFocusNavSupportNewButtons (copy), CoreGui (copy)
		if FFlagIEMTabFocusNav and (not p4 and GuiService.SelectedCoreObject == t1.TabHeader) then
			return
		end

		if p4 or not GuiService.SelectedCoreObject or not GuiService.SelectedCoreObject:IsDescendantOf(t1.Page) then
			if t1.LastSelectedObject then
				GuiService.SelectedCoreObject = t1.LastSelectedObject

				return
			end

			if t2 and #t2 > 0 then
				local v46

				if FFlagIEMSettingsGroups then
					local n1 = 1e999
					local ValueChanger = t2[1].ValueChanger

					for _, v45 in t2 do
						if v45.SelectionFrame and n1 > v45.SelectionFrame.LayoutOrder then
							n1 = v45.SelectionFrame.LayoutOrder
							ValueChanger = v45
						end
					end

					v46 = t1:getValueChangerFrame(ValueChanger.ValueChanger)
				else
					v46 = t1:getValueChangerFrame(t2[1].ValueChanger)
				end

				GuiService.SelectedCoreObject = v46

				return
			end

			if FFlagIEMFocusNavToButtons and t1.PageNextSelectionDown and (not FFlagIEMFocusNavSupportNewButtons or t1.PageNextSelectionDown:IsDescendantOf(CoreGui)) then
				GuiService.SelectedCoreObject = t1.PageNextSelectionDown
			end
		end
	end
	function t1.Display(_, p6, p7) -- line: 326
		-- upvalues: t1 (copy), v29 (copy), v30 (copy), FFlagIEMSettingsPageDisplaying (copy), UserGameSettings (copy), GetFFlagFixIGMTabTransitions (copy), u27 (ref), TweenService (copy), EngineFeature (copy)
		t1.OpenStateChangedCount = t1.OpenStateChangedCount + 1

		if t1.TabHeader then
			t1.TabHeader.TabSelection.Visible = true
			v29.TextTransparency = 0
			v30.TextTransparency = 0
		end

		t1.Page.Parent = p6
		t1.Page.Visible = true

		if FFlagIEMSettingsPageDisplaying then
			t1.Displaying:Fire()
		end

		local uDim2 = UDim2.new(0, 0, 0, 0)

		local function v51() -- line: 343
			-- upvalues: UserGameSettings (copy), p6 (copy), GetFFlagFixIGMTabTransitions (copy), t1 (copy), uDim2 (copy), u27 (ref)
			if UserGameSettings.ReducedMotion then
				p6.InnerCanvasGroupShow.Visible = false
			end

			if GetFFlagFixIGMTabTransitions() then
				if UserGameSettings.ReducedMotion then
					p6.InnerCanvasGroupShow.GroupTransparency = 0
				end

				t1.Page.Position = uDim2
			end

			t1.Page.Visible = true
			u27 = true
			t1.Displayed:Fire()
		end

		if p7 then
			t1.Page.Position = uDim2

			if UserGameSettings.ReducedMotion then
				p6.InnerCanvasGroupShow.Visible = false
			end

			if GetFFlagFixIGMTabTransitions() then
				if UserGameSettings.ReducedMotion then
					p6.InnerCanvasGroupShow.GroupTransparency = 0
				end

				t1.Page.Position = uDim2
			end

			t1.Page.Visible = true
			u27 = true
			t1.Displayed:Fire()

			return
		end

		if UserGameSettings.ReducedMotion then
			t1.Page.Position = uDim2
			p6.InnerCanvasGroupShow.GroupTransparency = 1
			p6.InnerCanvasGroupShow.Visible = true
			t1.Page.Parent = p6.InnerCanvasGroupShow
			t1.Page.Visible = true

			local tweenInfo = TweenInfo.new(0.25)
			local t3 = {
				GroupTransparency = 0
			}
			local tween = TweenService:Create(p6.InnerCanvasGroupShow, tweenInfo, t3)

			tween:Play()
			tween.Completed:Connect(function() -- line: 374
				-- upvalues: t1 (copy), p6 (copy), UserGameSettings (copy), GetFFlagFixIGMTabTransitions (copy), uDim2 (copy), u27 (ref)
				t1.Page.Parent = p6

				if UserGameSettings.ReducedMotion then
					p6.InnerCanvasGroupShow.Visible = false
				end

				if GetFFlagFixIGMTabTransitions() then
					if UserGameSettings.ReducedMotion then
						p6.InnerCanvasGroupShow.GroupTransparency = 0
					end

					t1.Page.Position = uDim2
				end

				t1.Page.Visible = true
				u27 = true
				t1.Displayed:Fire()
			end)

			return
		end

		if EngineFeature then
			t1.Page:TweenPositionInternal(uDim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true, v51)

			return
		end

		t1.Page:TweenPosition(uDim2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true, v51)
	end
	function t1.Hide(_, p9, p10, p11, p12, p13, p14) -- line: 400
		-- upvalues: t1 (copy), v29 (copy), v30 (copy), UserGameSettings (copy), u27 (ref), TweenService (copy), EngineFeature (copy)
		t1.OpenStateChangedCount = t1.OpenStateChangedCount + 1

		if t1.TabHeader then
			t1.TabHeader.TabSelection.Visible = false
			v29.TextTransparency = 0.5
			v30.TextTransparency = 0.5
		end

		if t1.Page.Parent then
			local uDim2 = UDim2.new(1 * p9, 0, 0, 0)

			local function v63() -- line: 411
				-- upvalues: UserGameSettings (copy), p14 (copy), p13 (copy), t1 (copy), p10 (copy), u27 (ref)
				if UserGameSettings.ReducedMotion and p14 then
					p13.InnerCanvasGroupHide.Visible = false
				end

				t1.Page.Visible = false
				t1.Page.Position = UDim2.new(t1.TabPosition - p10, 0, 0, 0)
				u27 = false
				t1.Hidden:Fire()
			end
			local function v64() -- line: 421
				-- upvalues: p11 (copy), t1 (copy), uDim2 (copy), UserGameSettings (copy), p14 (copy), p13 (copy), p10 (copy), u27 (ref), TweenService (copy), EngineFeature (copy), v63 (copy)
				if p11 then
					t1.Page.Position = uDim2

					if UserGameSettings.ReducedMotion and p14 then
						p13.InnerCanvasGroupHide.Visible = false
					end

					t1.Page.Visible = false
					t1.Page.Position = UDim2.new(t1.TabPosition - p10, 0, 0, 0)
					u27 = false
					t1.Hidden:Fire()

					return
				end

				if UserGameSettings.ReducedMotion and p14 then
					p13.InnerCanvasGroupHide.GroupTransparency = 0
					p13.InnerCanvasGroupHide.Visible = true
					t1.Page.Parent = p13.InnerCanvasGroupHide

					local tweenInfo = TweenInfo.new(0.25)
					local t4 = {
						GroupTransparency = 1
					}
					local tween = TweenService:Create(p13.InnerCanvasGroupHide, tweenInfo, t4)

					tween:Play()
					tween.Completed:Connect(function() -- line: 437
						-- upvalues: t1 (copy), p13 (copy), uDim2 (copy), UserGameSettings (copy), p14 (copy), p10 (copy), u27 (ref)
						t1.Page.Parent = p13
						t1.Page.Position = uDim2

						if UserGameSettings.ReducedMotion and p14 then
							p13.InnerCanvasGroupHide.Visible = false
						end

						t1.Page.Visible = false
						t1.Page.Position = UDim2.new(t1.TabPosition - p10, 0, 0, 0)
						u27 = false
						t1.Hidden:Fire()
					end)

					return
				end

				if EngineFeature then
					t1.Page:TweenPositionInternal(uDim2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, v63)

					return
				end

				t1.Page:TweenPosition(uDim2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, v63)
			end

			if p12 then
				local OpenStateChangedCount = t1.OpenStateChangedCount

				delay(p12, function() -- line: 467
					-- upvalues: OpenStateChangedCount (copy), t1 (copy), v64 (copy)
					if OpenStateChangedCount == t1.OpenStateChangedCount then
						v64()
					end
				end)

				return
			end

			v64()
		end
	end
	function t1.GetDisplayed(_) -- line: 478
		-- upvalues: u27 (ref)
		return u27
	end
	function t1.GetVisibility(_) -- line: 482
		-- upvalues: t1 (copy)
		return t1.Page.Parent
	end
	function t1.GetTabHeader(_) -- line: 486
		-- upvalues: t1 (copy)
		return t1.TabHeader
	end
	function t1.GetRows(_) -- line: 490
		-- upvalues: FFlagIEMFocusNavToButtons (copy), t2 (copy)
		if not FFlagIEMFocusNavToButtons then
			return
		end

		return t2
	end
	function t1.SetHub(_, p20) -- line: 498
		-- upvalues: t1 (copy), t2 (copy)
		t1.HubRef = p20

		for _, v in next, t2 do
			if type(v.ValueChanger) == "table" then
				v.ValueChanger.HubRef = t1.HubRef
			end
		end
	end
	function t1.GetSize(_) -- line: 508
		-- upvalues: t1 (copy)
		return t1.Page.AbsoluteSize
	end
	function t1.AddRow(_, p23, p24, p25, p26) -- line: 512
		-- upvalues: t2 (copy), t1 (copy)
		t2[#t2 + 1] = {
			SelectionFrame = p23,
			Label = p24,
			ValueChanger = p25
		}

		local n2 = 0

		if p23 then
			n2 = p23.Size.Y.Offset
		end

		if p26 then
			t1.Page.Size = UDim2.new(1, 0, 0, t1.Page.Size.Y.Offset + n2 + p26)
		else
			t1.Page.Size = UDim2.new(1, 0, 0, t1.Page.Size.Y.Offset + n2)
		end

		if t1.HubRef and type(p25) == "table" then
			p25.HubRef = t1.HubRef
		end
	end

	return t1
end

return {
	CreateNewPage = function(_) -- line: 537
		-- upvalues: Initialize (copy)
		return (Initialize())
	end
}
