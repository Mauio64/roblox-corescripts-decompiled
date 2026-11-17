local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Modules = RobloxGui.Modules
local Signals = require(CorePackages.Packages.Signals)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local SharedExperimentDefinition2 = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP

local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBackpackResponsiveUnits = SharedFlags.FFlagBackpackResponsiveUnits
local defineFastFlag = game:DefineFastFlag("EnableHotbarHide", false)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagStudioDeviceSimVRSwitchFixes = SharedFlags2.FFlagStudioDeviceSimVRSwitchFixes

local function featureSAToolEquipEnabled(): boolean -- 2 equivalent calls inferred from this helper
	return workspace.AuthorityMode == Enum.AuthorityMode.Server
end

local BackpackScript = {}
BackpackScript.OpenClose = nil
BackpackScript.IsHotbarVisible = false
BackpackScript.IsOpen = false
BackpackScript.StateChanged = Instance.new("BindableEvent")
BackpackScript.ModuleName = "Backpack"
BackpackScript.KeepVRTopbarOpen = true
BackpackScript.VRIsExclusive = true
BackpackScript.VRClosesNonExclusive = true
local v = 60
local fontSize = Enum.FontSize.Size14

local backgroundTransparency = 0.5 * UserGameSettings.PreferredTransparency
local color = Color3.new(31 / 255, 31 / 255, 31 / 255)

local color2 = Color3.new(49 / 255, 49 / 255, 49 / 255)
local color3 = Color3.new(90 / 255, 142 / 255, 233 / 255)

local backgroundTransparency2 = 0.5 * UserGameSettings.PreferredTransparency
local color4 = Color3.new(1, 1, 1)

UDim2.new(0, 14, 0, 9)
local value = Enum.KeyCode.Backquote.Value

local color5 = Color3.new(0, 162 / 255, 1)

local text2 = "   Search"

local color6 = Color3.new(0.37, 0.37, 0.37)

local backgroundTransparency3 = 0.15 * UserGameSettings.PreferredTransparency

local value2 = Enum.KeyCode.Zero.Value
local value3 = Enum.KeyCode.Backspace.Value

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")
local GamepadService = game:GetService("GamepadService")
RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags3.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v2 = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local GameTranslator = require(Modules.GameTranslator)

pcall(function()
	text2 = RobloxTranslator:FormatByKey("InGame.UnknownNamespace.BACKPACK_SEARCH")
end)

local v3 = true

if v2 then
	fontSize = Enum.FontSize.Size24
	v = 100
end

local v4 = false
local v5

if FFlagBackpackResponsiveUnits then
	if Responsive.GetInputModeStore().getPreferredInputType() == Responsive.Input.Touch then
		v5 = GuiService:GetScreenResolution().X < 1024
	else
		v5 = false
	end
else
	v5 = UserInputService.TouchEnabled and GuiService:GetScreenResolution().X < 1024
end

local LocalPlayer = Players.LocalPlayer

local parent3 = nil
local v6 = nil
local v7 = nil

local parent4 = nil
local v8 = nil
local parent5 = nil
local parent6 = nil

local parent7 = nil
local v9 = nil
local backpack = nil

local slots = {}
local v10 = nil
local v11 = {}
local v12 = {}
local v13 = {}
local v14 = 0
local v15 = nil
local v16 = false
local v17 = false
local v18 = false
local flag = false
local v19 = {}
local connections = {}
local flag2 = false
local v20 = 0
local v21 = v5 and 3 or 10
local v22 = v5 and 2 or 4
local v23 = nil

BackpackScript.BackpackEmpty = Create("BindableEvent")({ Name = "BackpackEmpty" })

BackpackScript.BackpackItemAdded = Create("BindableEvent")({ Name = "BackpackAdded" })

BackpackScript.BackpackItemRemoved = Create("BindableEvent")({ Name = "BackpackRemoved" })

local function NewGui(className, name)
	local instance = Instance.new(className)
	instance.Name = name
	instance.BackgroundColor3 = Color3.new(0, 0, 0)
	instance.BackgroundTransparency = 1
	instance.BorderColor3 = Color3.new(0, 0, 0)
	instance.BorderSizePixel = 0
	instance.Size = UDim2.new(1, 0, 1, 0)

	if not className:match("Text") then
		return instance
	end

	instance.TextColor3 = Color3.new(1, 1, 1)
	instance.Text = ""
	instance.Font = Enum.Font.SourceSans
	instance.FontSize = fontSize
	instance.TextWrapped = true

	if className == "TextButton" then
		instance.Font = Enum.Font.SourceSansBold
		instance.BorderSizePixel = 1
	end

	return instance
end

local function FindLowestEmpty()
	for i = 1, v21 do
		local v24 = slots[i]

		if not v24.Tool then
			return v24
		end
	end

	return nil
end

local function isInventoryEmpty(): boolean -- 2 equivalent calls inferred from this helper
	for i = v21 + 1, #slots do
		local v24 = slots[i]

		if v24 and v24.Tool then
			return false
		end
	end

	return true
end

BackpackScript.IsInventoryEmpty = isInventoryEmpty

local function UseGazeSelection(): boolean
	return false
end

local function AdjustHotbarFrames(p)
	local visible = parent4.Visible
	local v24 = visible and v21 or v14
	local count = 0
	local isHotbarVisible

	if defineFastFlag then
		if v24 >= 1 then
			isHotbarVisible = not p
		else
			isHotbarVisible = false
		end
	else
		isHotbarVisible = v24 >= 1
	end

	for i = 1, v21 do
		local v25 = slots[i]
		local v26

		if defineFastFlag then
			v26 = v25.Tool and not p
		else
			v26 = v25.Tool
		end

		if v26 or visible then
			count += 1
			v25:Readjust(count, v24)
			v25.Frame.Visible = true
		else
			v25.Frame.Visible = false
		end
	end

	local v25 = v7
	local visible2 = not visible

	if visible2 then
		if isHotbarVisible then
			visible2 = isHotbarVisible
		else
			visible2 = not isInventoryEmpty() -- inferred equivalent call
		end
	end

	v25.Visible = visible2
	v7.Position = UDim2.new(0.5, -15, 1, isHotbarVisible and -110 or -50)
	BackpackScript.IsHotbarVisible = isHotbarVisible
end

local function UpdateScrollingFrameCanvasSize()
	local v24 = math.floor(parent5.AbsoluteSize.X / (v + 5))
	local v25 = math.ceil((#parent6:GetChildren() - 1) / v24) * (v + 5) + 5
	parent5.CanvasSize = UDim2.new(0, 0, 0, v25)
end

local function AdjustInventoryFrames()
	for i = v21 + 1, #slots do
		local v24 = slots[i]
		v24.Frame.LayoutOrder = v24.Index
		v24.Frame.Visible = v24.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout()
	v6.Size = UDim2.new(0, 5 + v21 * (v + 5), 0, v + 5 + 5)
	v6.Position = UDim2.new(0.5, -v6.Size.X.Offset / 2, 1, -v6.Size.Y.Offset)
	parent4.Size = UDim2.new(0, v6.Size.X.Offset, 0, v6.Size.Y.Offset * v22 + 40)
	parent4.Position = UDim2.new(0.5, -parent4.Size.X.Offset / 2, 1, v6.Position.Y.Offset - parent4.Size.Y.Offset)

	parent5.Size = UDim2.new(1, parent5.ScrollBarThickness + 1, 1, -40)
	parent5.Position = UDim2.new(0, 0, 0, 40)
	AdjustHotbarFrames()
	AdjustInventoryFrames()
end

local function Clamp(p, p2, p3) -- 2 equivalent calls inferred from this helper
	return (math.min(p2, (math.max(p, p3))))
end

local function CheckBounds(p, p2, p3): boolean -- 2 equivalent calls inferred from this helper
	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	return absolutePosition.X < p2
		and p2 <= absolutePosition.X + absoluteSize.X
		and absolutePosition.Y < p3
		and p3 <= absolutePosition.Y + absoluteSize.Y
end

local function GetOffset(frame, vector2) -- 1 equivalent call inferred from this helper
	return (frame.AbsolutePosition + frame.AbsoluteSize / 2 - vector2).magnitude
end

local function DisableActiveHopper() -- 2 equivalent calls inferred from this helper
	v15:ToggleSelect()
	v11[v15]:UpdateEquipView()
	v15 = nil
end

local function UnequipAllTools() -- 8 equivalent calls inferred from this helper
	if v9 then
		v9:UnequipTools()

		if v15 then
			DisableActiveHopper() -- inferred equivalent call
		end
	end
end

local function EquipNewTool(hopperBin)
	UnequipAllTools() -- inferred equivalent call

	if hopperBin:IsA("HopperBin") then
		hopperBin:ToggleSelect()
		v11[hopperBin]:UpdateEquipView()
		v15 = hopperBin
	else
		if featureSAToolEquipEnabled() then -- inferred equivalent call
			LocalPlayer:RequestTool(hopperBin)
		end

		hopperBin.Parent = parent7
	end
end

local function IsEquipped(hopperBin) -- 4 equivalent calls inferred from this helper
	return hopperBin and (hopperBin:IsA("HopperBin") and hopperBin.Active or hopperBin.Parent == parent7)
end

local function MakeSlot(parent, p)
	local name = p or #slots + 1

	local slot = {}
	slot.Tool = nil
	slot.Index = name
	slot.Frame = nil
	local v24 = nil
	local v25 = nil
	local v26 = nil
	local v27 = nil
	local changedConnection = nil
	local parent8 = nil

	local v28 = nil
	local v29 = nil

	local function UpdateSlotFading() -- 2 equivalent calls inferred from this helper
		v24.SelectionImageObject = nil
		v24.BackgroundTransparency = v24.Draggable and 0 or backgroundTransparency2
		v24.BackgroundColor3 = v24.Draggable and color2 or color
	end

	function slot:Readjust(p2, p3)
		local halfOffset = v6.Size.X.Offset / 2
		local v30 = v + 5
		local v31 = p2 - (p3 / 2 + 0.5)
		v24.Position = UDim2.new(0, halfOffset - v / 2 + v30 * v31, 0, 5)
	end

	function slot:Fill(tool)
		if not tool then
			return self:Clear()
		end

		self.Tool = tool

		local function assignToolData()
			local textureId = tool.TextureId
			v26.Image = textureId

			if textureId == "" then
				v27.Visible = true
			else
				v27.Visible = false
			end

			GameTranslator:TranslateAndRegister(v27, tool, tool.Name)

			if v28 and tool:IsA("Tool") then
				GameTranslator:TranslateAndRegister(v28, tool, tool.ToolTip)
				local v30 = v28.TextBounds.X + 6
				v28.Size = UDim2.new(0, v30, 0, 16)
				v28.Position = UDim2.new(0.5, -v30 / 2, 0, -25)
			end
		end
		assignToolData()

		if changedConnection then
			changedConnection:disconnect()
			changedConnection = nil
		end

		changedConnection = tool.Changed:connect(function(p2)
			if p2 == "TextureId" or p2 == "Name" or p2 == "ToolTip" then
				assignToolData()
			end
		end)

		local v30 = self.Index <= v21
		local visible = parent4.Visible

		if not v30 or visible then
			v24.Draggable = true
		end

		self:UpdateEquipView()

		if v30 then
			v14 += 1

			if v17 and v14 >= 1 and not v4 then
				v4 = true
				ContextActionService:BindAction(
					"RBXHotbarEquip",
					changeToolFunc,
					false,
					Enum.KeyCode.ButtonL1,
					Enum.KeyCode.ButtonR1
				)
			end
		end

		v11[tool] = self
		local flag3 = true
		local v31

		for i = 1, v21 do
			v31 = slots[i]

			if not v31.Tool then
				flag3 = false
				break
			end
		end

		if flag3 then
			v31 = nil
		end

		v10 = v31
	end

	function slot:Clear()
		if not self.Tool then
			return
		end

		if changedConnection then
			changedConnection:disconnect()
			changedConnection = nil
		end

		v26.Image = ""
		v27.Text = ""

		if v28 then
			v28.Text = ""
			v28.Visible = false
		end

		v24.Draggable = false

		self:UpdateEquipView(true)

		if self.Index <= v21 then
			v14 -= 1

			if v14 < 1 then
				v4 = false
				ContextActionService:UnbindAction("RBXHotbarEquip")
			end
		end

		v11[self.Tool] = nil
		self.Tool = nil
		local flag3 = true
		local v30

		for i = 1, v21 do
			v30 = slots[i]

			if not v30.Tool then
				flag3 = false
				break
			end
		end

		if flag3 then
			v30 = nil
		end

		v10 = v30
	end

	function slot:UpdateEquipView(p2)
		if p2 then
			if parent8 then
				parent8.Parent = nil
			end
		elseif IsEquipped(self.Tool) then -- inferred equivalent call
			v23 = slot

			if not parent8 then
				parent8 = NewGui("Frame", "Equipped")
				parent8.ZIndex = v24.ZIndex

				for _, v30 in pairs({
					{ 0.1, 1, 0, 0 },
					{ 0.8, 0.1, 0.1, 0 },
					{ 0.1, 1, 0.9, 0 },
					{ 0.8, 0.1, 0.1, 0.9 }
				}) do
					local newGui = NewGui("Frame", "Edge")
					newGui.BackgroundTransparency = 0
					newGui.BackgroundColor3 = color3
					newGui.Size = UDim2.new(v30[1], 0, v30[2], 0)
					newGui.Position = UDim2.new(v30[3], 0, v30[4], 0)
					newGui.ZIndex = parent8.ZIndex
					newGui.Parent = parent8
				end
			end

			parent8.Parent = v24
		elseif parent8 then
			parent8.Parent = nil
		end

		UpdateSlotFading() -- inferred equivalent call
	end

	function slot:IsEquipped()
		local tool = self.Tool
		return tool and (tool:IsA("HopperBin") and tool.Active or tool.Parent == parent7)
	end

	function slot:Delete()
		v13[v24] = nil
		v24:Destroy()
		table.remove(slots, self.Index)
		local v30 = #slots

		for i = self.Index, v30 do
			slots[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end

	function slot:Swap(object)
		local tool = self.Tool
		local tool2 = object.Tool
		self:Clear()

		if tool2 then
			object:Clear()
			self:Fill(tool2)
		end

		if tool then
			object:Fill(tool)
		else
			object:Clear()
		end
	end

	function slot:SlideBack()
		self.Index -= 1
		v24.Name = self.Index
		v24.LayoutOrder = self.Index
	end

	function slot:TurnNumber(visible)
		if v29 then
			v29.Visible = visible
		end
	end

	function slot:SetClickability(p2)
		if self.Tool then
			v24.Draggable = not p2
			UpdateSlotFading() -- inferred equivalent call
		end
	end

	function slot:CheckTerms(items)
		local total = 0
		local function checkEm(text, k) -- 2 equivalent calls inferred from this helper
			local _, v30 = text:lower():gsub(k, "")
			total += v30
		end
		local tool = self.Tool

		if not tool then
			return total
		end

		for k in pairs(items) do
			checkEm(v27.Text, k) -- inferred equivalent call

			if tool:IsA("Tool") then
				checkEm(v28 and v28.Text or "", k) -- inferred equivalent call
			end
		end

		return total
	end

	function slot:Select(p2)
		if p2 then
			return
		end

		local tool = slot.Tool

		if tool then
			if IsEquipped(tool) then -- inferred equivalent call
				if featureSAToolEquipEnabled() and not tool:IsA("HopperBin") then -- inferred equivalent call
					LocalPlayer:RequestTool(nil)
				end

				UnequipAllTools() -- inferred equivalent call
			elseif tool.Parent == backpack then
				EquipNewTool(tool)
			end
		end
	end

	v24 = NewGui("TextButton", name)
	v24.BackgroundColor3 = color
	v24.BorderColor3 = color4
	v24.Text = ""
	v24.AutoButtonColor = false
	v24.BorderSizePixel = 0
	v24.Size = UDim2.new(0, v, 0, v)
	v24.Active = true
	v24.Draggable = false
	v24.BackgroundTransparency = backgroundTransparency2
	v24.MouseButton1Click:connect(function()
		changeSlot(slot)
	end)
	slot.Frame = v24

	local parent9 = NewGui("Frame", "SelectionObjectClipper")
	parent9.Visible = false
	parent9.Parent = v24

	local newGui = NewGui("ImageLabel", "Selector")
	newGui.Size = UDim2.new(1, 0, 1, 0)
	newGui.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	newGui.ScaleType = Enum.ScaleType.Slice
	newGui.SliceCenter = Rect.new(12, 12, 52, 52)
	newGui.Parent = parent9

	v26 = NewGui("ImageLabel", "Icon")
	v26.Size = UDim2.new(0.8, 0, 0.8, 0)
	v26.Position = UDim2.new(0.1, 0, 0.1, 0)
	v26.Parent = v24

	v27 = NewGui("TextLabel", "ToolName")
	v27.Size = UDim2.new(1, -2, 1, -2)
	v27.Position = UDim2.new(0, 1, 0, 1)
	v27.Parent = v24

	slot.Frame.LayoutOrder = slot.Index

	if name <= v21 then
		v28 = NewGui("TextLabel", "ToolTip")
		v28.TextWrapped = false
		v28.TextYAlignment = Enum.TextYAlignment.Top
		v28.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		v28.BackgroundTransparency = 0
		v28.Visible = false
		v28.Parent = v24
		v24.MouseEnter:connect(function()
			if v28.Text ~= "" then
				v28.Visible = true
			end
		end)
		v24.MouseLeave:connect(function()
			v28.Visible = false
		end)

		function slot:MoveToInventory()
			if slot.Index <= v21 then
				local tool = slot.Tool
				self:Clear()
				local slot2 = MakeSlot(parent6)
				slot2:Fill(tool)

				if IsEquipped(tool) then -- inferred equivalent call
					UnequipAllTools() -- inferred equivalent call
				end

				if flag then
					slot2.Frame.Visible = false
					slot2.Parent = parent4
				end
			end
		end

		if name < 10 or name == v21 then
			local text

			if name < 10 then
				text = name or 0
			else
				text = 0
			end

			v29 = NewGui("TextLabel", "Number")
			v29.Text = text
			v29.Size = UDim2.new(0.15, 0, 0.15, 0)
			v29.Visible = false
			v29.Parent = v24

			v12[value2 + text] = function(p2)
				slot:Select(p2)
			end
		end
	end

	local position = v24.Position
	local v30 = 0
	local parent2 = nil

	v24.DragBegin:connect(function(p2)
		v13[v24] = true
		position = p2

		v24.BorderSizePixel = 2

		v24.ZIndex = 2
		v26.ZIndex = 2
		v27.ZIndex = 2
		v24.Parent.ZIndex = 2

		if v29 then
			v29.ZIndex = 2
		end

		if parent8 then
			parent8.ZIndex = 2

			for _, child in pairs(parent8:GetChildren()) do
				child.ZIndex = 2
			end
		end

		parent2 = v24.Parent

		if parent2 == parent6 then
			local _absolutePosition = v24.AbsolutePosition
			local udim = UDim2.new(
				0,
				v24.AbsolutePosition.X - parent4.AbsolutePosition.X,
				0,
				v24.AbsolutePosition.Y - parent4.AbsolutePosition.Y
			)
			v24.Parent = parent4
			v24.Position = udim

			v25 = NewGui("Frame", "FakeSlot")
			v25.LayoutOrder = v24.LayoutOrder
			v25.Size = v24.Size
			v25.BackgroundTransparency = 1
			v25.Parent = parent6
		end
	end)

	v24.DragStopped:connect(function(p2, p3)
		if v25 then
			v25:Destroy()
		end

		local v31 = tick()
		v24.Position = position
		v24.Parent = parent2

		v24.BorderSizePixel = 0

		v24.ZIndex = 1
		v26.ZIndex = 1
		v27.ZIndex = 1
		parent2.ZIndex = 1

		if v29 then
			v29.ZIndex = 1
		end

		if parent8 then
			parent8.ZIndex = 1

			for _, child in pairs(parent8:GetChildren()) do
				child.ZIndex = 1
			end
		end

		v13[v24] = nil

		if not slot.Tool then
			return
		end

		if CheckBounds(parent4, p2, p3) then -- inferred equivalent call
			if slot.Index <= v21 then
				slot:MoveToInventory()
			end

			local index = slot.Index

			if v21 < index and v31 - v30 < 0.5 then
				if v10 then
					local tool = slot.Tool
					slot:Clear()
					v10:Fill(tool)
					slot:Delete()
				end

				v31 = 0
			end
		elseif CheckBounds(v6, p2, p3) then -- inferred equivalent call
			local v32 = { 1e999, nil }

			for i = 1, v21 do
				local v48 = slots[i]
				local offset = GetOffset(v48.Frame, Vector2.new(p2, p3)) -- inferred equivalent call

				if offset < v32[1] then
					v32 = { offset, v48 }
				end
			end

			local v48 = v32[2]

			if v48 ~= slot then
				slot:Swap(v48)
				local index = slot.Index

				if v21 < index then
					local tool = slot.Tool

					if tool then
						if IsEquipped(tool) then -- inferred equivalent call
							UnequipAllTools() -- inferred equivalent call
						end

						if flag then
							slot.Frame.Visible = false
							slot.Frame.Parent = parent4
						end
					else
						slot:Delete()
					end
				end
			end
		elseif slot.Index <= v21 then
			slot:MoveToInventory()
		end

		v30 = v31
	end)

	v24.Parent = parent
	slots[name] = slot

	if v21 < name then
		UpdateScrollingFrameCanvasSize()

		if parent4.Visible and not flag then
			local v31 = parent5.CanvasSize.Y.Offset - parent5.AbsoluteSize.Y
			parent5.CanvasPosition = Vector2.new(0, (math.max(0, v31)))
		end
	end

	return slot
end

local function SetNumberOfHotbarSlots(p)
	if v21 ~= p then
		local v24 = v21

		if p < v24 then
			for i = v24, p + 1, -1 do
				local v25 = slots[i]

				if not v25 then
					continue
				end

				v25:MoveToInventory()
				v25:Delete()
			end

			for i = v24, p + 1, -1 do
				local v25 = slots[i]

				if not v25.Tool then
					v25:Delete()
				end
			end
		else
			for i = v24, p do
				v21 = i

				if slots[i] then
					local _ = slots[i]
					local tool = slots[i].Tool

					local slot = MakeSlot(v6, i)

					if tool then
						slot:Fill(tool)
					elseif not v10 then
						v10 = slot
					end
				else
					local slot = MakeSlot(v6, i)

					slot.Frame.Visible = false

					if not v10 then
						v10 = slot
					end
				end
			end
		end

		v21 = p
		v14 = 0

		for i = 1, v21 do
			if slots[i] and slots[i].Tool then
				v14 += 1
			end
		end

		UpdateBackpackLayout()
	end
end

local function OnChildAdded(child)
	if child:IsA("Tool") or child:IsA("HopperBin") then
		if child.Parent == parent7 then
			v20 = tick()
		end

		if v15 and child.Parent == parent7 then
			DisableActiveHopper() -- inferred equivalent call
		end

		if not v16 and child.Parent == parent7 and not v11[child] then
			local starterGear = LocalPlayer:FindFirstChild("StarterGear")

			if starterGear and starterGear:FindFirstChild(child.Name) then
				v16 = true

				for i = (v10 or MakeSlot(parent6)).Index, 1, -1 do
					local v24 = slots[i]
					local v25 = i - 1

					if v25 > 0 then
						slots[v25]:Swap(v24)
					else
						v24:Fill(child)
					end
				end

				for _, tool in pairs(parent7:GetChildren()) do
					if tool:IsA("Tool") and tool ~= child then
						tool.Parent = backpack
					end
				end

				AdjustHotbarFrames()
				return
			end
		end

		local v24 = v11[child]

		if v24 then
			v24:UpdateEquipView()
		else
			local v25 = v10 or MakeSlot(parent6)
			v25:Fill(child)

			if v25.Index <= v21 and not parent4.Visible then
				AdjustHotbarFrames()
			end

			if child:IsA("HopperBin") and child.Active then
				UnequipAllTools() -- inferred equivalent call
				v15 = child
			end
		end

		BackpackScript.BackpackItemAdded:Fire()
	elseif child:IsA("Humanoid") and child.Parent == parent7 then
		v9 = child
	end
end

local function OnChildRemoved(instance)
	if not (instance:IsA("Tool") or instance:IsA("HopperBin")) then
		return
	end

	v20 = tick()

	local parent = instance.Parent

	if parent == parent7 or parent == backpack then
		return
	end

	local v24 = v11[instance]

	if v24 then
		v24:Clear()
		local index = v24.Index

		if v21 < index then
			v24:Delete()
		elseif not parent4.Visible then
			AdjustHotbarFrames()
		end
	end

	if instance == v15 then
		v15 = nil
	end

	BackpackScript.BackpackItemRemoved:Fire()

	if isInventoryEmpty() then -- inferred equivalent call
		BackpackScript.BackpackEmpty:Fire()
	end
end

local function OnCharacterAdded(character)
	for i = #slots, 1, -1 do
		local v24 = slots[i]

		if v24.Tool then
			v24:Clear()
		end

		if v21 < i then
			v24:Delete()
		end
	end

	v15 = nil

	for _, connection in pairs(connections) do
		connection:disconnect()
	end

	connections = {}

	parent7 = character
	table.insert(connections, character.ChildRemoved:connect(OnChildRemoved))
	table.insert(connections, character.ChildAdded:connect(OnChildAdded))

	for _, child in pairs(character:GetChildren()) do
		OnChildAdded(child)
	end

	backpack = LocalPlayer:WaitForChild("Backpack")
	table.insert(connections, backpack.ChildRemoved:connect(OnChildRemoved))
	table.insert(connections, backpack.ChildAdded:connect(OnChildAdded))

	for _, child in pairs(backpack:GetChildren()) do
		OnChildAdded(child)
	end

	AdjustHotbarFrames()
end

local function OnInputBegan(p, p2)
	local v24 = p.UserInputType == Enum.UserInputType.Keyboard
		and not v18
		and (v17 or p.KeyCode.Value == value3)
		and v12[p.KeyCode.Value]

	if v24 then
		v24(p2)
	end

	local userInputType = p.UserInputType

	if
		not p2
		and (userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch)
		and parent4.Visible
	then
		BackpackScript.OpenClose()
	end
end

local function OnUISChanged(p)
	if p == "KeyboardEnabled" or p == "VREnabled" then
		local v24 = UserInputService.KeyboardEnabled and not VRService.VREnabled

		for i = 1, v21 do
			slots[i]:TurnNumber(v24)
		end
	end
end

local v24 = nil
local lastTime = nil

local function fn() end
local vector2 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions()
	ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
	ContextActionService:UnbindAction("RBXCloseInventory")
end

local function setHotbarVisibility(visible, p)
	for i = 1, v21 do
		local v25 = slots[i]

		if v25 and v25.Frame and (p or v25.Tool) then
			v25.Frame.Visible = visible
		end
	end
end

local function getInputDirection(data)
	local v25 = data.UserInputState == Enum.UserInputState.End and -1 or 1

	if data.KeyCode == Enum.KeyCode.Thumbstick1 then
		local magnitude = data.Position.magnitude

		if magnitude > 0.98 then
			vector2 = Vector2.new(data.Position.x / magnitude, -data.Position.y / magnitude)
		else
			vector2 = Vector2.new(0, 0)
		end
	elseif data.KeyCode == Enum.KeyCode.DPadLeft then
		vector2 = Vector2.new(vector2.x - v25 * 1, vector2.y)
	elseif data.KeyCode == Enum.KeyCode.DPadRight then
		vector2 = Vector2.new(vector2.x + v25 * 1, vector2.y)
	elseif data.KeyCode == Enum.KeyCode.DPadUp then
		vector2 = Vector2.new(vector2.x, vector2.y - v25 * 1)
	elseif data.KeyCode == Enum.KeyCode.DPadDown then
		vector2 = Vector2.new(vector2.x, vector2.y + v25 * 1)
	else
		vector2 = Vector2.new(0, 0)
	end

	return vector2
end

function changeToolFunc(_, p, p2)
	if p ~= Enum.UserInputState.Begin then
		return
	end

	if
		v24
		and (v24.KeyCode == Enum.KeyCode.ButtonR1 and p2.KeyCode == Enum.KeyCode.ButtonL1 or v24.KeyCode == Enum.KeyCode.ButtonL1 and p2.KeyCode == Enum.KeyCode.ButtonR1)
		and tick() - lastTime <= 0.06
	then
		UnequipAllTools() -- inferred equivalent call
		v24 = p2
		lastTime = tick()
	else
		v24 = p2
		lastTime = tick()

		delay(0.06, function()
			if v24 ~= p2 then
				return
			end

			local v25 = p2.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1

			for i = 1, v21 do
				if slots[i]:IsEquipped() then
					local v26 = v25 + i
					local v27 = false

					if v21 < v26 then
						v26 = 1
						v27 = true
					elseif v26 < 1 then
						v26 = v21
						v27 = true
					end

					local v28 = v26

					while not slots[v26].Tool do
						v26 += v25

						if v26 == v28 then
							return
						end

						if v21 < v26 then
							v26 = 1
							v27 = true
						elseif v26 < 1 then
							v26 = v21
							v27 = true
						end
					end

					if not v27 then
						slots[v26]:Select()

						return
					end

					UnequipAllTools() -- inferred equivalent call
					v23 = nil
					return
				end
			end

			if v23 and v23.Tool then
				v23:Select()
				return
			end

			for i = v25 == -1 and v21 or 1, v25 == -1 and 1 or v21, v25 do
				if slots[i].Tool then
					slots[i]:Select()
					break
				end
			end
		end)
	end
end

function getGamepadSwapSlot()
	for i = 1, #slots do
		if slots[i].Frame.BorderSizePixel > 0 then
			return slots[i]
		end
	end
end

function changeSlot(object)
	local gamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if object.Frame == GuiService.SelectedCoreObject and not gamepadCursorEnabled then
		local gamepadSwapSlot = getGamepadSwapSlot()

		if gamepadSwapSlot then
			gamepadSwapSlot.Frame.BorderSizePixel = 0

			if gamepadSwapSlot ~= object then
				object:Swap(gamepadSwapSlot)
				v8.SelectionImageObject.Visible = false

				local index = object.Index

				if v21 < index and not object.Tool then
					if GuiService.SelectedCoreObject == object.Frame then
						GuiService.SelectedCoreObject = gamepadSwapSlot.Frame
					end

					object:Delete()
				end

				local index2 = gamepadSwapSlot.Index

				if v21 < index2 and not gamepadSwapSlot.Tool then
					if GuiService.SelectedCoreObject == gamepadSwapSlot.Frame then
						GuiService.SelectedCoreObject = object.Frame
					end

					gamepadSwapSlot:Delete()
				end
			end
		else
			local size = object.Frame.Size
			local position = object.Frame.Position
			object.Frame:TweenSizeAndPositionInternal(
				size + UDim2.new(0, 10, 0, 10),
				position - UDim2.new(0, 5, 0, 5),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true,
				function()
					object.Frame:TweenSizeAndPositionInternal(
						size,
						position,
						Enum.EasingDirection.In,
						Enum.EasingStyle.Quad,
						0.1,
						true
					)
				end
			)
			object.Frame.BorderSizePixel = 3
			v8.SelectionImageObject.Visible = true
		end
	else
		object:Select()
		v8.SelectionImageObject.Visible = false
	end
end

function enableGamepadInventoryControl()
	local function fn2(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		if getGamepadSwapSlot() then
			local gamepadSwapSlot = getGamepadSwapSlot()

			if gamepadSwapSlot then
				gamepadSwapSlot.Frame.BorderSizePixel = 0
			end
		elseif parent4.Visible then
			BackpackScript.OpenClose()
		end
	end

	ContextActionService:BindAction("RBXBackpackHasGamepadFocus", fn, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("RBXCloseInventory", fn2, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

	GuiService.SelectedCoreObject = v6:FindFirstChild("1")
end

function disableGamepadInventoryControl()
	unbindAllGamepadEquipActions()

	for i = 1, v21 do
		local v25 = slots[i]

		if v25 and v25.Frame then
			v25.Frame.BorderSizePixel = 0
		end
	end

	if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(parent3) then
		GuiService.SelectedCoreObject = nil
	end
end

local function bindBackpackHotbarAction() -- 1 equivalent call inferred from this helper
	if v17 and not v4 then
		v4 = true
		ContextActionService:BindAction(
			"RBXHotbarEquip",
			changeToolFunc,
			false,
			Enum.KeyCode.ButtonL1,
			Enum.KeyCode.ButtonR1
		)
	end
end

local function unbindBackpackHotbarAction() -- 1 equivalent call inferred from this helper
	disableGamepadInventoryControl()
	v4 = false
	ContextActionService:UnbindAction("RBXHotbarEquip")
end

function gamepadDisconnected()
	if not VRService.VREnabled then
		flag2 = false
		disableGamepadInventoryControl()
	end
end

function gamepadConnected()
	if not VRService.VREnabled then
		flag2 = true

		if FFlagStudioDeviceSimVRSwitchFixes then
			GuiService:RemoveSelectionGroup("RBXBackpackSelection")
		end

		GuiService:AddSelectionParent("RBXBackpackSelection", parent3)

		if v14 >= 1 then
			bindBackpackHotbarAction() -- inferred equivalent call
		end

		if parent4.Visible then
			enableGamepadInventoryControl()
		end
	end
end

local function OnCoreGuiChanged(p, coreGuiEnabled)
	if p == Enum.CoreGuiType.Backpack or p == Enum.CoreGuiType.All then
		local visible = coreGuiEnabled and v3
		v17 = visible

		if FFlagMountCoreGuiBackpack then
			if visible then
				parent3.Parent = RobloxGui
			else
				parent3.Parent = nil
			end
		else
			parent3.Visible = visible
		end

		for _, v25 in pairs(v19) do
			if visible then
				GuiService:AddKey(v25)
			else
				GuiService:RemoveKey(v25)
			end
		end

		if visible then
			if v14 >= 1 and v17 and not v4 then
				v4 = true
				ContextActionService:BindAction(
					"RBXHotbarEquip",
					changeToolFunc,
					false,
					Enum.KeyCode.ButtonL1,
					Enum.KeyCode.ButtonR1
				)
			end
		else
			unbindBackpackHotbarAction() -- inferred equivalent call
		end
	end
end

local function MakeVRRoundButton(name, image)
	local parent = NewGui("ImageButton", name)
	parent.Size = UDim2.new(0, 40, 0, 40)
	parent.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local newGui = NewGui("ImageLabel", "Icon")
	newGui.Size = UDim2.new(0.5, 0, 0.5, 0)
	newGui.Position = UDim2.new(0.25, 0, 0.25, 0)
	newGui.Image = image
	newGui.Parent = parent

	local selectionImageObject = NewGui("ImageLabel", "Selection")
	selectionImageObject.Size = UDim2.new(0.9, 0, 0.9, 0)
	selectionImageObject.Position = UDim2.new(0.05, 0, 0.05, 0)
	selectionImageObject.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	parent.SelectionImageObject = selectionImageObject

	return parent, newGui, selectionImageObject
end

parent3 = NewGui("Frame", "Backpack")

if FFlagMountCoreGuiBackpack then
	if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
		parent3.Parent = RobloxGui
	end
else
	parent3.Visible = false
	parent3.Parent = RobloxGui
end

v6 = NewGui("Frame", "Hotbar")
v6.Parent = parent3

for i = 1, v21 do
	local slot = MakeSlot(v6, i)
	slot.Frame.Visible = false

	if not v10 then
		v10 = slot
	end
end

v7 = NewGui("ImageButton", "OpenInventory")

v7.Size = UDim2.new(0, 30, 0, 30)
v7.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
v7.MouseButton1Click:connect(function()
	BackpackScript.OpenClose()
end)
v7.SelectionGained:connect(function()
	v7.ImageColor3 = color5
end)
v7.SelectionLost:connect(function()
	v7.ImageColor3 = Color3.new(1, 1, 1)
end)
local selectionImageObject = NewGui("Frame", "Selection")
selectionImageObject.Visible = false
v7.SelectionImageObject = selectionImageObject

local vrRoundButton = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
vrRoundButton.Position = UDim2.new(0, 0, 0, -50)
vrRoundButton.MouseButton1Click:connect(function()
	if parent4.Visible then
		BackpackScript.OpenClose()
	end
end)

LeftBumperButton = NewGui("ImageLabel", "LeftBumper")
LeftBumperButton.Size = UDim2.new(0, 40, 0, 40)
LeftBumperButton.Position = UDim2.new(0, -LeftBumperButton.Size.X.Offset, 0.5, -LeftBumperButton.Size.Y.Offset / 2)

RightBumperButton = NewGui("ImageLabel", "RightBumper")
RightBumperButton.Size = UDim2.new(0, 40, 0, 40)
RightBumperButton.Position = UDim2.new(1, 0, 0.5, -RightBumperButton.Size.Y.Offset / 2)

parent4 = NewGui("Frame", "Inventory")
parent4.BackgroundTransparency = backgroundTransparency
parent4.BackgroundColor3 = color
parent4.Active = true
parent4.Visible = false
parent4.Parent = parent3

v8 = NewGui("TextButton", "VRInventorySelector")
v8.Position = UDim2.new(0, 0, 0, 0)
v8.Size = UDim2.new(1, 0, 1, 0)
v8.BackgroundTransparency = 1
v8.Text = ""
v8.Parent = parent4

local selectionImageObject2 = NewGui("ImageLabel", "Selector")
selectionImageObject2.Size = UDim2.new(1, 0, 1, 0)
selectionImageObject2.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
selectionImageObject2.ScaleType = Enum.ScaleType.Slice
selectionImageObject2.SliceCenter = Rect.new(12, 12, 52, 52)
selectionImageObject2.Visible = false
v8.SelectionImageObject = selectionImageObject2

parent5 = NewGui("ScrollingFrame", "ScrollingFrame")
parent5.Selectable = false
parent5.CanvasSize = UDim2.new(0, 0, 0, 0)
parent5.Parent = parent4

parent6 = NewGui("Frame", "UIGridFrame")
parent6.Selectable = false
parent6.Size = UDim2.new(1, -10, 1, 0)
parent6.Position = UDim2.new(0, 5, 0, 0)
parent6.Parent = parent5

local uiGridLayout = Instance.new("UIGridLayout")
uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiGridLayout.CellSize = UDim2.new(0, v, 0, v)
uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
uiGridLayout.Parent = parent6

local vrRoundButton2 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
vrRoundButton2.Size = UDim2.new(0, 34, 0, 34)
vrRoundButton2.Position = UDim2.new(0.5, -vrRoundButton2.Size.X.Offset / 2, 0, 43)
vrRoundButton2.Icon.Position = vrRoundButton2.Icon.Position - UDim2.new(0, 0, 0, 2)
vrRoundButton2.MouseButton1Click:connect(function()
	parent5.CanvasPosition = Vector2.new(
		parent5.CanvasPosition.X,
		Clamp(0, parent5.CanvasSize.Y.Offset - parent5.AbsoluteWindowSize.Y, parent5.CanvasPosition.Y - (v + 5)) -- inferred equivalent call
	)
end)

local vrRoundButton3 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
vrRoundButton3.Rotation = 180
vrRoundButton3.Icon.Position = vrRoundButton3.Icon.Position - UDim2.new(0, 0, 0, 2)
vrRoundButton3.Size = UDim2.new(0, 34, 0, 34)
vrRoundButton3.Position = UDim2.new(0.5, -vrRoundButton3.Size.X.Offset / 2, 1, -vrRoundButton3.Size.Y.Offset - 3)
vrRoundButton3.MouseButton1Click:connect(function()
	parent5.CanvasPosition = Vector2.new(
		parent5.CanvasPosition.X,
		Clamp(0, parent5.CanvasSize.Y.Offset - parent5.AbsoluteWindowSize.Y, parent5.CanvasPosition.Y + (v + 5)) -- inferred equivalent call
	)
end)

parent5.Changed:connect(function(p)
	if p == "AbsoluteWindowSize" or p == "CanvasPosition" or p == "CanvasSize" then
		local visible = parent5.CanvasPosition.Y ~= 0
		local visible2 = parent5.CanvasPosition.Y < parent5.CanvasSize.Y.Offset - parent5.AbsoluteWindowSize.Y

		vrRoundButton2.Visible = visible
		vrRoundButton3.Visible = visible2
	end
end)

UpdateBackpackLayout()

local parent = Create("Frame")({
	Name = "GamepadHintsFrame",
	Size = UDim2.new(0, v6.Size.X.Offset, 0, v2 and 95 or 60),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = parent3
})

local function addGamepadHint(image, p, text)
	local parent2 = Create("Frame")({
		Name = "HintFrame",
		Size = UDim2.new(1, 0, 1, -5),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local create = Create("ImageLabel")
	local hintImage = {
		Name = "HintImage",
		Size = v2 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60),
		BackgroundTransparency = 1,
		Image = 0,
		Parent = 0
	}
	image = v2 and p or image
	hintImage.Image = image
	hintImage.Parent = parent2
	create(hintImage)

	local v25 = Create("TextLabel")({
		Name = "HintText",
		Position = UDim2.new(0, v2 and 100 or 70, 0, 0),
		Size = UDim2.new(1, -(v2 and 100 or 70), 1, 0),
		Font = Enum.Font.SourceSansBold,
		FontSize = v2 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = parent2
	})

	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", v25)
	uiTextSizeConstraint.MaxTextSize = v25.TextSize
end

local function resizeGamepadHintsFrame()
	parent.Size = UDim2.new(v6.Size.X.Scale, v6.Size.X.Offset, 0, v2 and 95 or 60)
	parent.Position = UDim2.new(
		v6.Position.X.Scale,
		v6.Position.X.Offset,
		parent4.Position.Y.Scale,
		parent4.Position.Y.Offset - parent.Size.Y.Offset
	)

	local children = parent:GetChildren()
	local total = 0

	for i = 1, #children do
		children[i].Size = UDim2.new(1, 0, 1, -5)
		children[i].Position = UDim2.new(0, 0, 0, 0)
		total += children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X
	end

	local v25 = (parent.AbsoluteSize.X - total) / (#children - 1)

	for i = 1, #children do
		children[i].Position = i == 1 and UDim2.new(0, 0, 0, 0)
			or UDim2.new(0, children[i - 1].Position.X.Offset + children[i - 1].Size.X.Offset + v25, 0, 0)
		children[i].Size = UDim2.new(
			0,
			children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X,
			1,
			-5
		)
	end
end

addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonX@2x.png",
	"Remove From Hotbar"
)
addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonA@2x.png",
	"Select/Swap"
)
addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png",
	"Close Backpack"
)

local parent2 = NewGui("Frame", "Search")

parent2.BackgroundColor3 = color6
parent2.BackgroundTransparency = backgroundTransparency3
parent2.Size = UDim2.new(0, 190, 0, 30)
parent2.Position = UDim2.new(1, -parent2.Size.X.Offset - 5, 0, 5)
parent2.Parent = parent4

local newGui = NewGui("TextBox", "TextBox")
newGui.Text = text2
newGui.ClearTextOnFocus = false
newGui.FontSize = Enum.FontSize.Size24
newGui.TextXAlignment = Enum.TextXAlignment.Left
newGui.Size = parent2.Size - UDim2.new(0, 0, 0, 0)
newGui.Position = UDim2.new(0, 0, 0, 0)
newGui.Parent = parent2

local newGui2 = NewGui("TextButton", "X")
newGui2.Text = "x"
newGui2.TextColor3 = color3
newGui2.FontSize = Enum.FontSize.Size24
newGui2.TextYAlignment = Enum.TextYAlignment.Bottom
newGui2.BackgroundColor3 = color6
newGui2.BackgroundTransparency = 0
newGui2.Size = UDim2.new(0, parent2.Size.Y.Offset - 10, 0, parent2.Size.Y.Offset - 10)
newGui2.Position = UDim2.new(1, -newGui2.Size.X.Offset - 10, 0.5, -newGui2.Size.Y.Offset / 2)
newGui2.ZIndex = 0
newGui2.Visible = false
newGui2.BorderSizePixel = 0
newGui2.Parent = parent2

local function search()
	local set2 = {}

	for k in newGui.Text:gmatch("%S+") do
		set2[k:lower()] = true
	end

	local v25 = {}

	for i = v21 + 1, #slots do
		local v26 = slots[i]
		table.insert(v25, { v26, (v26:CheckTerms(set2)) })
		v26.Frame.Visible = false
		v26.Frame.Parent = parent4
	end

	table.sort(v25, function(a, b): boolean
		return a[2] > b[2]
	end)

	flag = true
	local count = 0

	for _, v26 in ipairs(v25) do
		local v27 = v26[1]

		if not (v26[2] > 0) then
			continue
		end

		v27.Frame.Visible = true
		v27.Frame.Parent = parent6
		v27.Frame.LayoutOrder = v21 + count
		count += 1
	end

	parent5.CanvasPosition = Vector2.new(0, 0)
	UpdateScrollingFrameCanvasSize()

	newGui2.ZIndex = 3
end

local function clearResults()
	if newGui2.ZIndex > 0 then
		flag = false

		for i = v21 + 1, #slots do
			local v25 = slots[i]
			v25.Frame.LayoutOrder = v25.Index
			v25.Frame.Parent = parent6
			v25.Frame.Visible = true
		end

		newGui2.ZIndex = 0
	end

	UpdateScrollingFrameCanvasSize()
end

local function reset() -- 2 equivalent calls inferred from this helper
	clearResults()
	newGui.Text = text2
end

local function onChanged(p)
	if p == "Text" then
		local text = newGui.Text

		if text == "" then
			clearResults()
		elseif text ~= text2 then
			search()
		end

		newGui2.Visible = text ~= "" and text ~= text2
	end
end

local function onFocused()
	if newGui.Text == text2 then
		newGui.Text = ""
	end
end

local function focusLost(p)
	if p then
		search()
	elseif newGui.Text == "" then
		newGui.Text = text2
	end
end

newGui.Focused:connect(onFocused)
newGui2.MouseButton1Click:connect(reset)
newGui.Changed:connect(onChanged)
newGui.FocusLost:connect(focusLost)

BackpackScript.StateChanged.Event:connect(function(modal)
	newGui2.Modal = modal

	if not modal then
		reset() -- inferred equivalent call
	end
end)

v12[Enum.KeyCode.Escape.Value] = function(p)
	if p then
		reset() -- inferred equivalent call
	elseif parent4.Visible then
		BackpackScript.OpenClose()
	end
end

local function detectGamepad(p)
	if p == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
		parent2.Visible = false
	else
		parent2.Visible = true
	end
end
UserInputService.LastInputTypeChanged:connect(detectGamepad)

local function fn2(_, p, _)
	if not (p == Enum.UserInputState.Begin and GuiService.SelectedCoreObject) then
		return
	end

	for i = 1, v21 do
		if slots[i].Frame == GuiService.SelectedCoreObject and slots[i].Tool then
			slots[i]:MoveToInventory()
			break
		end
	end
end

local function openClose()
	if not next(v13) then
		parent4.Visible = not parent4.Visible
		local visible = parent4.Visible
		AdjustHotbarFrames()
		v6.Active = not v6.Active

		for i = 1, v21 do
			slots[i]:SetClickability(not visible)
		end
	end

	if parent4.Visible then
		if flag2 then
			if set[UserInputService:GetLastInputType()] then
				resizeGamepadHintsFrame()
				parent.Visible = true
			end

			enableGamepadInventoryControl()
		end
	else
		if flag2 then
			parent.Visible = false
		end

		disableGamepadInventoryControl()
	end

	if parent4.Visible then
		ContextActionService:BindAction("RBXRemoveSlot", fn2, false, Enum.KeyCode.ButtonX)
	else
		ContextActionService:UnbindAction("RBXRemoveSlot")
	end

	BackpackScript.IsOpen = parent4.Visible
	BackpackScript.StateChanged:Fire(parent4.Visible)
end

v12[value] = function()
	if GuiService.MenuIsOpen then
		return
	end

	openClose()
end
BackpackScript.OpenClose = openClose

while not LocalPlayer do
	wait()
	LocalPlayer = Players.LocalPlayer
end

LocalPlayer.CharacterAdded:connect(OnCharacterAdded)

if LocalPlayer.Character then
	OnCharacterAdded(LocalPlayer.Character)
end

for i = 0, 9 do
	table.insert(v19, (tostring(i)))
end

table.insert(v19, "`")

UserInputService.InputBegan:connect(OnInputBegan)

UserInputService.TextBoxFocused:connect(function()
	v18 = true
end)
UserInputService.TextBoxFocusReleased:connect(function()
	v18 = false
end)

v12[value3] = function()
	if v15 then
		UnequipAllTools() -- inferred equivalent call
	end
end

UserInputService.Changed:connect(OnUISChanged)
local v25 = UserInputService.KeyboardEnabled and not VRService.VREnabled

for i = 1, v21 do
	slots[i]:TurnNumber(v25)
end

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
	gamepadConnected()
end

UserInputService.GamepadConnected:connect(function(p)
	if p == Enum.UserInputType.Gamepad1 then
		gamepadConnected()
	end
end)
UserInputService.GamepadDisconnected:connect(function(p)
	if p == Enum.UserInputType.Gamepad1 then
		gamepadDisconnected()
	end
end)

function BackpackScript:TopbarEnabledChanged(p)
	v3 = p

	OnCoreGuiChanged(Enum.CoreGuiType.Backpack, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end

if FFlagTopBarSignalizeSetCores then
	BackpackScript.disposeEffect = Signals.createEffect(function(p)
		local getTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

		if getTopBarStore then
			BackpackScript:TopbarEnabledChanged(getTopBarStore(p).getTopBarCoreGuiEnabled(p))
		end
	end)
end

StarterGui.CoreGuiChangedSignal:connect(OnCoreGuiChanged)
local Backpack = Enum.CoreGuiType.Backpack
local Health = Enum.CoreGuiType.Health
OnCoreGuiChanged(Backpack, StarterGui:GetCoreGuiEnabled(Backpack))
OnCoreGuiChanged(Health, StarterGui:GetCoreGuiEnabled(Health))

if defineFastFlag then
	SettingsShowSignal:connect(function(p)
		if p then
			if BackpackScript.IsHotbarVisible then
				AdjustHotbarFrames(true)
			end
		else
			AdjustHotbarFrames(false)
		end
	end)
end

GuiService.MenuOpened:Connect(function()
	if
		BackpackScript.IsOpen
		and (not isInExperienceUIVREnabled or InExperienceUIVRIXP:isMovePanelToCenter() or not VRService.VREnabled)
	then
		BackpackScript.OpenClose()
	end
end)

InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p)
	if p and BackpackScript.IsOpen then
		BackpackScript.OpenClose()
	end
end)

local function OnPreferredTransparencyChanged()
	local preferredTransparency = UserGameSettings.PreferredTransparency

	backgroundTransparency = 0.5 * UserGameSettings.PreferredTransparency
	parent4.BackgroundTransparency = backgroundTransparency

	backgroundTransparency2 = 0.5 * preferredTransparency

	for _, v26 in ipairs(slots) do
		v26.Frame.BackgroundTransparency = backgroundTransparency2
	end

	backgroundTransparency3 = 0.15 * UserGameSettings.PreferredTransparency
	parent2.BackgroundTransparency = backgroundTransparency3
end
UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)

return BackpackScript
