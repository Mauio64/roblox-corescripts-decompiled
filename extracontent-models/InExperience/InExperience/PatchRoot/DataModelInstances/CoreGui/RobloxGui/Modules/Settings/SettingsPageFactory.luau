local GuiService = game:GetService("GuiService")
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

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot

local GetFFlagFixIGMTabTransitions = require(script.Parent.Flags.GetFFlagFixIGMTabTransitions)
local FFlagIEMSettingsGroups = require(script.Parent.Flags.FFlagIEMSettingsGroups)
local FFlagIEMFocusNavSupportNewButtons = require(script.Parent.Flags.FFlagIEMFocusNavSupportNewButtons)

local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

local function Initialize()
	local v2 = {}
	v2.HubRef = nil
	v2.LastSelectedObject = nil
	v2.TabPosition = 0
	v2.Active = false
	v2.OpenStateChangedCount = 0
	v2.ShouldShowBottomBar = not isSideSheetEnabled
	v2.ShouldShowHubBar = true
	v2.ShouldDisableDefaultScroll = false
	v2.IsPageClipped = true
	v2.SelectARow = nil
	v2.LastSelectableObjectsUpdated = Signal.new()
	v2.LastSelectableObjects = {}
	v2.PageNextSelectionDown = nil

	if FFlagIEMTabFocusNav then
		v2.FirstSelectableObjectsUpdated = Signal.new()
		v2.FirstSelectableObjects = {}
	end

	local rows = {}
	local displayed = false

	v2.TabHeader = Create("TextButton")({
		Name = "Header",
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.2, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Selectable = FFlagIEMTabFocusNav and true or false
	})

	if Utility:IsSmallTouchScreen() then
		v2.TabHeader.Size = UDim2.new(0, 84, 1, 0)
	elseif v then
		v2.TabHeader.Size = UDim2.new(0, 220, 1, 0)
	end

	if FFlagIEMTabFocusNav then
		local function switchToPage()
			if v2.HubRef and v2.HubRef.Pages.CurrentPage ~= v2 then
				v2.HubRef:SwitchToPage(v2, true)
			end
		end
		v2.TabHeader.Activated:connect(switchToPage)
		v2.TabHeader.SelectionGained:connect(switchToPage)
	else
		v2.TabHeader.MouseButton1Click:connect(function()
			if v2.HubRef then
				v2.HubRef:SwitchToPage(v2, true)
			end
		end)
	end

	local parent2 = Create("TextLabel")({
		Name = "Icon",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0.5, -18),
		Text = "",
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		TextTransparency = 0.5,
		Parent = v2.TabHeader
	})

	Create("UIAspectRatioConstraint")({
		Name = "AspectRatioConstraint",
		AspectRatio = 1,
		Parent = parent2
	})

	local parent3 = Create("TextLabel")({
		Name = "Title",
		Text = "",
		Font = Theme.font(Enum.Font.SourceSansBold, "Button"),
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1.05, 0, 1, 0),
		Position = UDim2.new(1.2, Theme.TabHeaderIconPadding, 0, -2),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 0.5
	})

	parent3.TextSize = Theme.textSize(24)
	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
	uiTextSizeConstraint.MaxTextSize = Theme.textSize(24)
	parent3.Parent = parent2

	if Utility:IsPortrait() and Utility:IsSmallTouchScreen() then
		uiTextSizeConstraint.Parent = parent3
	end

	if Utility:IsSmallTouchScreen() then
		parent3.TextSize = Theme.textSize(18)
		uiTextSizeConstraint.MaxTextSize = Theme.textSize(18)
	elseif v then
		parent3.TextSize = Theme.textSize(48)
		uiTextSizeConstraint.MaxTextSize = Theme.textSize(48)
	end

	Create("ImageLabel")({
		Name = "TabSelection",
		Visible = false,
		BackgroundColor3 = Theme.color("TabSelection"),
		BackgroundTransparency = Theme.transparency("TabSelection"),
		Size = UDim2.new(1, -2, 0, 2),
		Position = UDim2.new(0, 3, 1, -2),
		BorderSizePixel = 0,
		Parent = v2.TabHeader
	})

	local parent4 = Create("Frame")({
		Name = "TabLabel",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = v2.TabHeader
	})

	Create("UIListLayout")({
		Name = "Layout",
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = parent4
	})

	parent2.Parent = parent4
	parent3.Parent = parent4
	parent3.Size = UDim2.new(0, 0, 0, 0)
	parent3.AutomaticSize = Enum.AutomaticSize.XY

	local function onResized()
		if not v2.TabHeader then
			return
		end

		if Utility:IsSmallTouchScreen() then
			parent2.Size = UDim2.new(0, 34, 0, 28)
		elseif v then
			parent2.Size = UDim2.new(0, 88, 0, 74)
		else
			local iconSize = Theme.getIconSize(Theme.IconSize.Medium)
			parent2.Size = UDim2.fromOffset(iconSize, iconSize)
		end

		local isPortrait = Utility:IsPortrait()
		local layout = parent4.Layout

		if isPortrait then
			if Utility:IsSmallTouchScreen() then
				parent3.FontSize = Theme.fontSize(Enum.FontSize.Size14)
			end

			parent2.Size = UDim2.new(0, 22, 0, 22)
			layout.FillDirection = Enum.FillDirection.Vertical
			layout.Padding = UDim.new(0, 0)
		else
			if Utility:IsSmallTouchScreen() then
				parent3.FontSize = Theme.fontSize(Enum.FontSize.Size18)
			end

			layout.FillDirection = Enum.FillDirection.Horizontal
			layout.Padding = UDim.new(0, 10)
		end

		parent2.Size = UDim2.fromOffset(parent2.Size.X.Offset * (2 / 3), parent2.Size.Y.Offset * (2 / 3))
	end

	Utility:OnResized(v2.TabHeader, onResized)

	v2.Page = Create("Frame")({
		Name = "Page",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})

	Create("UIPadding")({
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 11),
		Parent = v2.Page
	})

	v2.PageListLayout = Create("UIListLayout")({
		Name = "RowListLayout",
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = v2.Page
	})

	v2.Page.SelectionGroup = true

	v2.Displaying = Instance.new("BindableEvent")
	v2.Displaying.Name = "Displaying"

	v2.Displayed = Instance.new("BindableEvent")
	v2.Displayed.Name = "Displayed"

	v2.Displayed.Event:connect(function()
		if not v2.HubRef.Shield.Visible then
			return
		end

		v2:SelectARow()
	end)

	v2.Hidden = Instance.new("BindableEvent")
	v2.Hidden.Event:connect(function()
		if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(v2.Page) then
			GuiService.SelectedCoreObject = nil
		end
	end)
	v2.Hidden.Name = "Hidden"

	function v2:getValueChangerFrame(data)
		if type(data) == "table" then
			return data.SliderFrame and data.SliderFrame or data.SelectorFrame or data.DropDownFrame
		end

		return data
	end

	function v2:SelectARow(p)
		if FFlagIEMTabFocusNav and not p and GuiService.SelectedCoreObject == v2.TabHeader then
			return
		end

		if p or not (GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(v2.Page)) then
			if v2.LastSelectedObject then
				GuiService.SelectedCoreObject = v2.LastSelectedObject
			elseif rows and #rows > 0 then
				local selectedCoreObject

				if FFlagIEMSettingsGroups then
					local v3 = rows[1].ValueChanger
					local v4 = 1e999

					for _, v5 in rows do
						if not (v5.SelectionFrame and v5.SelectionFrame.LayoutOrder < v4) then
							continue
						end

						v4 = v5.SelectionFrame.LayoutOrder
						v3 = v5
					end

					selectedCoreObject = v2:getValueChangerFrame(v3.ValueChanger)
				else
					selectedCoreObject = v2:getValueChangerFrame(rows[1].ValueChanger)
				end

				GuiService.SelectedCoreObject = selectedCoreObject
			elseif
				v2.PageNextSelectionDown
				and (not FFlagIEMFocusNavSupportNewButtons or v2.PageNextSelectionDown:IsDescendantOf(CoreGui))
			then
				GuiService.SelectedCoreObject = v2.PageNextSelectionDown
			end
		end
	end

	function v2.Display(_, parent, p)
		v2.OpenStateChangedCount += 1

		if v2.TabHeader then
			v2.TabHeader.TabSelection.Visible = true
			parent2.TextTransparency = 0
			parent3.TextTransparency = 0
		end

		v2.Page.Parent = parent
		v2.Page.Visible = true

		v2.Displaying:Fire()

		local udim = UDim2.new(0, 0, 0, 0)
		local function fn() -- 2 equivalent calls inferred from this helper
			if UserGameSettings.ReducedMotion then
				parent.InnerCanvasGroupShow.Visible = false
			end

			if GetFFlagFixIGMTabTransitions() then
				if UserGameSettings.ReducedMotion then
					parent.InnerCanvasGroupShow.GroupTransparency = 0
				end

				v2.Page.Position = udim
			end

			v2.Page.Visible = true
			displayed = true
			v2.Displayed:Fire()
		end

		if p then
			v2.Page.Position = udim
			fn() -- inferred equivalent call
		else
			if not UserGameSettings.ReducedMotion then
				v2.Page:TweenPositionInternal(udim, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true, fn)

				return
			end

			v2.Page.Position = udim
			parent.InnerCanvasGroupShow.GroupTransparency = 1
			parent.InnerCanvasGroupShow.Visible = true
			v2.Page.Parent = parent.InnerCanvasGroupShow
			v2.Page.Visible = true

			local tweenInfo = TweenInfo.new(0.25)
			local tween = TweenService:Create(parent.InnerCanvasGroupShow, tweenInfo, {
				GroupTransparency = 0
			})
			tween:Play()

			tween.Completed:Connect(function()
				v2.Page.Parent = parent
				fn() -- inferred equivalent call
			end)
		end
	end
	function v2.Hide(_, p, p2, p3, p4, parent, p5)
		v2.OpenStateChangedCount += 1

		if v2.TabHeader then
			v2.TabHeader.TabSelection.Visible = false
			parent2.TextTransparency = 0.5
			parent3.TextTransparency = 0.5
		end

		if v2.Page.Parent then
			local udim = UDim2.new(1 * p, 0, 0, 0)
			local function fn() -- 2 equivalent calls inferred from this helper
				if UserGameSettings.ReducedMotion and p5 then
					parent.InnerCanvasGroupHide.Visible = false
				end

				v2.Page.Visible = false
				v2.Page.Position = UDim2.new(v2.TabPosition - p2, 0, 0, 0)
				displayed = false
				v2.Hidden:Fire()
			end

			local function fn2()
				if p3 then
					v2.Page.Position = udim
					fn() -- inferred equivalent call
				else
					if not (UserGameSettings.ReducedMotion and p5) then
						v2.Page:TweenPositionInternal(
							udim,
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quad,
							0.1,
							true,
							fn
						)

						return
					end

					parent.InnerCanvasGroupHide.GroupTransparency = 0
					parent.InnerCanvasGroupHide.Visible = true
					v2.Page.Parent = parent.InnerCanvasGroupHide

					local tweenInfo = TweenInfo.new(0.25)
					local tween = TweenService:Create(parent.InnerCanvasGroupHide, tweenInfo, {
						GroupTransparency = 1
					})
					tween:Play()

					tween.Completed:Connect(function()
						v2.Page.Parent = parent
						v2.Page.Position = udim
						fn() -- inferred equivalent call
					end)
				end
			end

			if p4 then
				local openStateChangedCount = v2.OpenStateChangedCount
				delay(p4, function()
					if openStateChangedCount == v2.OpenStateChangedCount then
						fn2()
					end
				end)
			else
				fn2()
			end
		end
	end

	function v2.GetDisplayed(_)
		return displayed
	end

	function v2.GetVisibility(_)
		return v2.Page.Parent
	end

	function v2.GetTabHeader(_)
		return v2.TabHeader
	end

	function v2.GetRows(_)
		return rows
	end

	function v2.SetHub(_, hubRef)
		v2.HubRef = hubRef

		for _, row in next, rows do
			if type(row.ValueChanger) == "table" then
				row.ValueChanger.HubRef = v2.HubRef
			end
		end
	end

	function v2.GetSize(_)
		return v2.Page.AbsoluteSize
	end

	function v2.AddRow(_, selectionFrame, label, valueChanger, p)
		rows[#rows + 1] = {
			SelectionFrame = selectionFrame,
			Label = label,
			ValueChanger = valueChanger
		}

		local v3 = not selectionFrame and 0 or selectionFrame.Size.Y.Offset

		if p then
			v2.Page.Size = UDim2.new(1, 0, 0, v2.Page.Size.Y.Offset + v3 + p)
		else
			v2.Page.Size = UDim2.new(1, 0, 0, v2.Page.Size.Y.Offset + v3)
		end

		if v2.HubRef and type(valueChanger) == "table" then
			valueChanger.HubRef = v2.HubRef
		end
	end

	return v2
end

return {
	CreateNewPage = function(_)
		return Initialize()
	end
}
