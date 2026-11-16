local parent = script:FindFirstAncestor("Backpack").Parent

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules
local Signals = require(parent.Signals)
local InExperienceTopBar = require(parent.InExperienceTopBar)
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local InExperienceAppChatModal = require(parent.AppChat.InExperienceAppChatModal)
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP

local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local RobloxTranslator = require(parent.RobloxTranslator)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local FFlagBackpackResponsiveUnits = SharedFlags.FFlagBackpackResponsiveUnits
local System = require(parent.System)
local defineFastFlag = game:DefineFastFlag("EnableHotbarHide", false)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagStudioDeviceSimVRSwitchFixes = SharedFlags2.FFlagStudioDeviceSimVRSwitchFixes

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
local SharedFlags3 = require(parent.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags3.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v2 = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot

local AppCommonLib = require(parent.AppCommonLib)
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

local parent4 = nil
local v6 = nil
local v7 = nil
local v8 = nil
local parent5 = nil
local v9 = nil
local parent6 = nil
local parent7 = nil
local uiGridLayout = nil
local v10 = nil
local v11 = nil

local parent8 = nil
local v12 = nil
local backpack = nil

local slots = {}
local v13 = nil
local v14 = {}
local v15 = {}
local v16 = {}
local v17 = 0
local v18 = nil
local v19 = false
local v20 = false
local v21 = false
local flag = false
local v22 = {}
local connections = {}
local connections2 = {}
local flag2 = false
local v23 = 0
local v24 = v5 and 3 or 10
local v25 = v5 and 2 or 4
local v26 = nil
local fn

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
	for i = 1, v24 do
		local v27 = slots[i]

		if not v27.Tool then
			return v27
		end
	end

	return nil
end

local function isInventoryEmpty(): boolean -- 2 equivalent calls inferred from this helper
	for i = v24 + 1, #slots do
		local v27 = slots[i]

		if v27 and v27.Tool then
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
	if not parent5 then
		return
	end

	local visible = parent5.Visible
	local v27 = visible and v24 or v17
	local count = 0
	local isHotbarVisible

	if defineFastFlag then
		if v27 >= 1 then
			isHotbarVisible = not p
		else
			isHotbarVisible = false
		end
	else
		isHotbarVisible = v27 >= 1
	end

	for i = 1, v24 do
		local v28 = slots[i]
		local v29

		if defineFastFlag then
			v29 = v28.Tool and not p
		else
			v29 = v28.Tool
		end

		if v29 or visible then
			count += 1
			v28:Readjust(count, v27)
			v28.Frame.Visible = true
		else
			v28.Frame.Visible = false
		end
	end

	if v7 then
		local v28 = v7
		local visible2 = not visible

		if visible2 then
			if isHotbarVisible then
				visible2 = isHotbarVisible
			else
				visible2 = not isInventoryEmpty() -- inferred equivalent call
			end
		end

		v28.Visible = visible2
		v7.Position = UDim2.new(0.5, -15, 1, isHotbarVisible and -110 or -50)
	end

	BackpackScript.IsHotbarVisible = isHotbarVisible
end

local function UpdateScrollingFrameCanvasSize()
	if not (parent6 and parent7) then
		return
	end

	local v27 = math.floor(parent6.AbsoluteSize.X / (v + 5))
	local v28 = math.ceil((#parent7:GetChildren() - 1) / v27) * (v + 5) + 5
	parent6.CanvasSize = UDim2.new(0, 0, 0, v28)
end

local function AdjustInventoryFrames()
	for i = v24 + 1, #slots do
		local v27 = slots[i]
		v27.Frame.LayoutOrder = v27.Index
		v27.Frame.Visible = v27.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout()
	if not (v6 and parent5) then
		return
	end

	v6.Size = UDim2.new(0, 5 + v24 * (v + 5), 0, v + 5 + 5)

	v6.Position = UDim2.new(0.5, -v6.Size.X.Offset / 2, 1, -v6.Size.Y.Offset)
	parent5.Size = UDim2.new(0, v6.Size.X.Offset, 0, v6.Size.Y.Offset * v25 + 40)

	parent5.Position = UDim2.new(0.5, -parent5.Size.X.Offset / 2, 1, v6.Position.Y.Offset - parent5.Size.Y.Offset)

	if parent6 then
		parent6.Size = UDim2.new(1, parent6.ScrollBarThickness + 1, 1, -40)
		parent6.Position = UDim2.new(0, 0, 0, 40)
	end

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
	v18:ToggleSelect()
	v14[v18]:UpdateEquipView()
	v18 = nil
end

local function UnequipAllTools() -- 8 equivalent calls inferred from this helper
	if v12 then
		v12:UnequipTools()

		if v18 then
			DisableActiveHopper() -- inferred equivalent call
		end
	end
end

local function EquipNewTool(hopperBin) -- 1 equivalent call inferred from this helper
	UnequipAllTools() -- inferred equivalent call

	if not hopperBin:IsA("HopperBin") then
		hopperBin.Parent = parent8

		return
	end

	hopperBin:ToggleSelect()
	v14[hopperBin]:UpdateEquipView()
	v18 = hopperBin
end

local function IsEquipped(hopperBin) -- 4 equivalent calls inferred from this helper
	return hopperBin and (hopperBin:IsA("HopperBin") and hopperBin.Active or hopperBin.Parent == parent8)
end

local function MakeSlot(parent2, p)
	local name = p or #slots + 1

	local slot = {}
	slot.Tool = nil
	slot.Index = name
	slot.Frame = nil
	local v27 = nil
	local v28 = nil
	local v29 = nil
	local v30 = nil
	local changedConnection = nil
	local parent9 = nil

	local v31 = nil
	local v32 = nil

	local function UpdateSlotFading() -- 2 equivalent calls inferred from this helper
		v27.SelectionImageObject = nil
		v27.BackgroundTransparency = v27.Draggable and 0 or backgroundTransparency2
		v27.BackgroundColor3 = v27.Draggable and color2 or color
	end

	function slot:Readjust(p2, p3)
		local halfOffset = v6.Size.X.Offset / 2
		local v46 = v + 5
		local v47 = p2 - (p3 / 2 + 0.5)
		v27.Position = UDim2.new(0, halfOffset - v / 2 + v46 * v47, 0, 5)
	end

	function slot:Fill(tool)
		if not tool then
			return self:Clear()
		end

		self.Tool = tool

		local function assignToolData()
			local textureId = tool.TextureId
			v29.Image = textureId

			if textureId == "" then
				v30.Visible = true
			else
				v30.Visible = false
			end

			GameTranslator:TranslateAndRegister(v30, tool, tool.Name)

			if v31 and tool:IsA("Tool") then
				GameTranslator:TranslateAndRegister(v31, tool, tool.ToolTip)
				local v45 = v31.TextBounds.X + 6
				v31.Size = UDim2.new(0, v45, 0, 16)
				v31.Position = UDim2.new(0.5, -v45 / 2, 0, -25)
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

		local v45 = self.Index <= v24
		local visible = parent5.Visible

		if not v45 or visible then
			v27.Draggable = true
		end

		self:UpdateEquipView()

		if v45 then
			v17 += 1

			if v20 and v17 >= 1 and not v4 then
				v4 = true
				ContextActionService:BindAction(
					"RBXHotbarEquip",
					fn,
					false,
					Enum.KeyCode.ButtonL1,
					Enum.KeyCode.ButtonR1
				)
			end
		end

		v14[tool] = self
		local flag3 = true
		local v46

		for i = 1, v24 do
			v46 = slots[i]

			if not v46.Tool then
				flag3 = false
				break
			end
		end

		if flag3 then
			v46 = nil
		end

		v13 = v46
	end

	function slot:Clear()
		if not self.Tool then
			return
		end

		if changedConnection then
			changedConnection:disconnect()
			changedConnection = nil
		end

		v29.Image = ""
		v30.Text = ""

		if v31 then
			v31.Text = ""
			v31.Visible = false
		end

		v27.Draggable = false

		self:UpdateEquipView(true)

		if self.Index <= v24 then
			v17 -= 1

			if v17 < 1 then
				v4 = false
				ContextActionService:UnbindAction("RBXHotbarEquip")
			end
		end

		v14[self.Tool] = nil
		self.Tool = nil
		local flag3 = true
		local v45

		for i = 1, v24 do
			v45 = slots[i]

			if not v45.Tool then
				flag3 = false
				break
			end
		end

		if flag3 then
			v45 = nil
		end

		v13 = v45
	end

	function slot:UpdateEquipView(p2)
		if p2 then
			if parent9 then
				parent9.Parent = nil
			end
		elseif IsEquipped(self.Tool) then -- inferred equivalent call
			v26 = slot

			if not parent9 then
				parent9 = NewGui("Frame", "Equipped")
				parent9.ZIndex = v27.ZIndex

				for _, v45 in pairs({
					{ 0.1, 1, 0, 0 },
					{ 0.8, 0.1, 0.1, 0 },
					{ 0.1, 1, 0.9, 0 },
					{ 0.8, 0.1, 0.1, 0.9 }
				}) do
					local newGui = NewGui("Frame", "Edge")
					newGui.BackgroundTransparency = 0
					newGui.BackgroundColor3 = color3
					newGui.Size = UDim2.new(v45[1], 0, v45[2], 0)
					newGui.Position = UDim2.new(v45[3], 0, v45[4], 0)
					newGui.ZIndex = parent9.ZIndex
					newGui.Parent = parent9
				end
			end

			parent9.Parent = v27
		elseif parent9 then
			parent9.Parent = nil
		end

		UpdateSlotFading() -- inferred equivalent call
	end

	function slot:IsEquipped()
		local tool = self.Tool
		return tool and (tool:IsA("HopperBin") and tool.Active or tool.Parent == parent8)
	end

	function slot:Delete()
		v16[v27] = nil
		v27:Destroy()
		table.remove(slots, self.Index)
		local v45 = #slots

		for i = self.Index, v45 do
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
		v27.Name = self.Index
		v27.LayoutOrder = self.Index
	end

	function slot:TurnNumber(visible)
		if v32 then
			v32.Visible = visible
		end
	end

	function slot:SetClickability(p2)
		if self.Tool then
			v27.Draggable = not p2
			UpdateSlotFading() -- inferred equivalent call
		end
	end

	function slot:CheckTerms(items)
		local total = 0
		local function checkEm(text, k) -- 2 equivalent calls inferred from this helper
			local _, v45 = text:lower():gsub(k, "")
			total += v45
		end
		local tool = self.Tool

		if not tool then
			return total
		end

		for k in pairs(items) do
			checkEm(v30.Text, k) -- inferred equivalent call

			if tool:IsA("Tool") then
				checkEm(v31 and v31.Text or "", k) -- inferred equivalent call
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
				UnequipAllTools() -- inferred equivalent call
			elseif tool.Parent == backpack then
				EquipNewTool(tool) -- inferred equivalent call
			end
		end
	end

	v27 = NewGui("TextButton", name)
	v27.BackgroundColor3 = color
	v27.BorderColor3 = color4
	v27.Text = ""
	v27.AutoButtonColor = false
	v27.BorderSizePixel = 0
	v27.Size = UDim2.new(0, v, 0, v)
	v27.Active = true
	v27.Draggable = false
	v27.BackgroundTransparency = backgroundTransparency2
	v27.MouseButton1Click:connect(function()
		changeSlot(slot)
	end)
	slot.Frame = v27

	local parent10 = NewGui("Frame", "SelectionObjectClipper")
	parent10.Visible = false
	parent10.Parent = v27

	local newGui = NewGui("ImageLabel", "Selector")
	newGui.Size = UDim2.new(1, 0, 1, 0)
	newGui.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	newGui.ScaleType = Enum.ScaleType.Slice
	newGui.SliceCenter = Rect.new(12, 12, 52, 52)
	newGui.Parent = parent10

	v29 = NewGui("ImageLabel", "Icon")
	v29.Size = UDim2.new(0.8, 0, 0.8, 0)
	v29.Position = UDim2.new(0.1, 0, 0.1, 0)
	v29.Parent = v27

	v30 = NewGui("TextLabel", "ToolName")
	v30.Size = UDim2.new(1, -2, 1, -2)
	v30.Position = UDim2.new(0, 1, 0, 1)
	v30.Parent = v27

	slot.Frame.LayoutOrder = slot.Index

	if name <= v24 then
		v31 = NewGui("TextLabel", "ToolTip")
		v31.TextWrapped = false
		v31.TextYAlignment = Enum.TextYAlignment.Top
		v31.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		v31.BackgroundTransparency = 0
		v31.Visible = false
		v31.Parent = v27
		v27.MouseEnter:connect(function()
			if v31.Text ~= "" then
				v31.Visible = true
			end
		end)
		v27.MouseLeave:connect(function()
			v31.Visible = false
		end)

		function slot:MoveToInventory()
			if slot.Index <= v24 then
				local tool = slot.Tool
				self:Clear()
				local slot2 = MakeSlot(parent7)
				slot2:Fill(tool)

				if IsEquipped(tool) then -- inferred equivalent call
					UnequipAllTools() -- inferred equivalent call
				end

				if flag then
					slot2.Frame.Visible = false
					slot2.Parent = parent5
				end
			end
		end

		if name < 10 or name == v24 then
			local text

			if name < 10 then
				text = name or 0
			else
				text = 0
			end

			v32 = NewGui("TextLabel", "Number")
			v32.Text = text
			v32.Size = UDim2.new(0.15, 0, 0.15, 0)
			v32.Visible = false
			v32.Parent = v27

			v15[value2 + text] = function(p2)
				slot:Select(p2)
			end
		end
	end

	local position = v27.Position
	local v48 = 0
	local parent3 = nil

	v27.DragBegin:connect(function(p2)
		v16[v27] = true
		position = p2

		v27.BorderSizePixel = 2

		v27.ZIndex = 2
		v29.ZIndex = 2
		v30.ZIndex = 2
		v27.Parent.ZIndex = 2

		if v32 then
			v32.ZIndex = 2
		end

		if parent9 then
			parent9.ZIndex = 2

			for _, child in pairs(parent9:GetChildren()) do
				child.ZIndex = 2
			end
		end

		parent3 = v27.Parent

		if parent3 == parent7 then
			local _absolutePosition = v27.AbsolutePosition
			local udim = UDim2.new(
				0,
				v27.AbsolutePosition.X - parent5.AbsolutePosition.X,
				0,
				v27.AbsolutePosition.Y - parent5.AbsolutePosition.Y
			)

			v27.Parent = parent5
			v27.Position = udim

			v28 = NewGui("Frame", "FakeSlot")
			v28.LayoutOrder = v27.LayoutOrder
			v28.Size = v27.Size
			v28.BackgroundTransparency = 1
			v28.Parent = parent7
		end
	end)

	v27.DragStopped:connect(function(p2, p3)
		if v28 then
			v28:Destroy()
		end

		local v49 = tick()
		v27.Position = position
		v27.Parent = parent3

		v27.BorderSizePixel = 0

		v27.ZIndex = 1
		v29.ZIndex = 1
		v30.ZIndex = 1
		parent3.ZIndex = 1

		if v32 then
			v32.ZIndex = 1
		end

		if parent9 then
			parent9.ZIndex = 1

			for _, child in pairs(parent9:GetChildren()) do
				child.ZIndex = 1
			end
		end

		v16[v27] = nil

		if not slot.Tool then
			return
		end

		if CheckBounds(parent5, p2, p3) then -- inferred equivalent call
			if slot.Index <= v24 then
				slot:MoveToInventory()
			end

			local index = slot.Index

			if v24 < index and v49 - v48 < 0.5 then
				if v13 then
					local tool = slot.Tool
					slot:Clear()
					v13:Fill(tool)
					slot:Delete()
				end

				v49 = 0
			end
		elseif CheckBounds(v6, p2, p3) then -- inferred equivalent call
			local v50 = { 1e999, nil }

			for i = 1, v24 do
				local v51 = slots[i]
				local offset = GetOffset(v51.Frame, Vector2.new(p2, p3)) -- inferred equivalent call

				if offset < v50[1] then
					v50 = { offset, v51 }
				end
			end

			local v51 = v50[2]

			if v51 ~= slot then
				slot:Swap(v51)
				local index = slot.Index

				if v24 < index then
					local tool = slot.Tool

					if tool then
						if IsEquipped(tool) then -- inferred equivalent call
							UnequipAllTools() -- inferred equivalent call
						end

						if flag then
							slot.Frame.Visible = false
							slot.Frame.Parent = parent5
						end
					else
						slot:Delete()
					end
				end
			end
		elseif slot.Index <= v24 then
			slot:MoveToInventory()
		end

		v48 = v49
	end)

	v27.Parent = parent2
	slots[name] = slot

	if v24 < name then
		UpdateScrollingFrameCanvasSize()

		if parent6 and parent5.Visible and not flag then
			local v49 = parent6.CanvasSize.Y.Offset - parent6.AbsoluteSize.Y
			parent6.CanvasPosition = Vector2.new(0, (math.max(0, v49)))
		end
	end

	return slot
end

local function SetNumberOfHotbarSlots(p)
	if v24 ~= p then
		local v27 = v24

		if p < v27 then
			for i = v27, p + 1, -1 do
				local v28 = slots[i]

				if not v28 then
					continue
				end

				v28:MoveToInventory()
				v28:Delete()
			end

			for i = v27, p + 1, -1 do
				local v28 = slots[i]

				if not v28.Tool then
					v28:Delete()
				end
			end
		else
			for i = v27, p do
				v24 = i

				if slots[i] then
					local _ = slots[i]
					local tool = slots[i].Tool

					local slot = MakeSlot(v6, i)

					if tool then
						slot:Fill(tool)
					elseif not v13 then
						v13 = slot
					end
				else
					local slot = MakeSlot(v6, i)

					slot.Frame.Visible = false

					if not v13 then
						v13 = slot
					end
				end
			end
		end

		v24 = p
		v17 = 0

		for i = 1, v24 do
			if slots[i] and slots[i].Tool then
				v17 += 1
			end
		end

		UpdateBackpackLayout()
	end
end

local function OnChildAdded(child)
	if not parent4 then
		return
	end

	if child:IsA("Tool") or child:IsA("HopperBin") then
		if child.Parent == parent8 then
			v23 = tick()
		end

		if v18 and child.Parent == parent8 then
			DisableActiveHopper() -- inferred equivalent call
		end

		if not v19 and child.Parent == parent8 and not v14[child] then
			local starterGear = LocalPlayer:FindFirstChild("StarterGear")

			if starterGear and starterGear:FindFirstChild(child.Name) then
				v19 = true

				for i = (v13 or MakeSlot(parent7)).Index, 1, -1 do
					local v27 = slots[i]
					local v28 = i - 1

					if v28 > 0 then
						slots[v28]:Swap(v27)
					else
						v27:Fill(child)
					end
				end

				for _, tool in pairs(parent8:GetChildren()) do
					if tool:IsA("Tool") and tool ~= child then
						tool.Parent = backpack
					end
				end

				AdjustHotbarFrames()
				return
			end
		end

		local v27 = v14[child]

		if v27 then
			v27:UpdateEquipView()
		else
			local v28 = v13 or MakeSlot(parent7)
			v28:Fill(child)

			if v28.Index <= v24 and not parent5.Visible then
				AdjustHotbarFrames()
			end

			if child:IsA("HopperBin") and child.Active then
				UnequipAllTools() -- inferred equivalent call
				v18 = child
			end
		end

		BackpackScript.BackpackItemAdded:Fire()
	elseif child:IsA("Humanoid") and child.Parent == parent8 then
		v12 = child
	end
end

local function OnChildRemoved(instance)
	if not (parent4 and (instance:IsA("Tool") or instance:IsA("HopperBin"))) then
		return
	end

	v23 = tick()

	local parent2 = instance.Parent

	if parent2 == parent8 or parent2 == backpack then
		return
	end

	local v27 = v14[instance]

	if v27 then
		v27:Clear()
		local index = v27.Index

		if v24 < index then
			v27:Delete()
		elseif not parent5.Visible then
			AdjustHotbarFrames()
		end
	end

	if instance == v18 then
		v18 = nil
	end

	BackpackScript.BackpackItemRemoved:Fire()

	if isInventoryEmpty() then -- inferred equivalent call
		BackpackScript.BackpackEmpty:Fire()
	end
end

local function OnCharacterAdded(character)
	for i = #slots, 1, -1 do
		local v27 = slots[i]

		if v27.Tool then
			v27:Clear()
		end

		if v24 < i then
			v27:Delete()
		end
	end

	v18 = nil

	for _, connection in pairs(connections) do
		connection:disconnect()
	end

	connections = {}

	parent8 = character
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
	local v27 = p.UserInputType == Enum.UserInputType.Keyboard
		and not v21
		and (v20 or p.KeyCode.Value == value3)
		and v15[p.KeyCode.Value]

	if v27 then
		v27(p2)
	end

	local userInputType = p.UserInputType

	if
		not p2
		and (userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch)
		and parent5
		and parent5.Visible
	then
		BackpackScript.OpenClose()
	end
end

local function OnUISChanged(p)
	if p == "KeyboardEnabled" or p == "VREnabled" then
		local v27 = UserInputService.KeyboardEnabled and not VRService.VREnabled

		for i = 1, v24 do
			slots[i]:TurnNumber(v27)
		end
	end
end

local v27 = nil
local lastTime = nil

local function fn2() end
local vector2 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions()
	ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
	ContextActionService:UnbindAction("RBXCloseInventory")
end

local function setHotbarVisibility(visible, p)
	for i = 1, v24 do
		local v28 = slots[i]

		if v28 and v28.Frame and (p or v28.Tool) then
			v28.Frame.Visible = visible
		end
	end
end

local function getInputDirection(data)
	local v28 = data.UserInputState == Enum.UserInputState.End and -1 or 1

	if data.KeyCode == Enum.KeyCode.Thumbstick1 then
		local magnitude = data.Position.magnitude

		if magnitude > 0.98 then
			vector2 = Vector2.new(data.Position.x / magnitude, -data.Position.y / magnitude)
		else
			vector2 = Vector2.new(0, 0)
		end
	elseif data.KeyCode == Enum.KeyCode.DPadLeft then
		vector2 = Vector2.new(vector2.x - v28 * 1, vector2.y)
	elseif data.KeyCode == Enum.KeyCode.DPadRight then
		vector2 = Vector2.new(vector2.x + v28 * 1, vector2.y)
	elseif data.KeyCode == Enum.KeyCode.DPadUp then
		vector2 = Vector2.new(vector2.x, vector2.y - v28 * 1)
	elseif data.KeyCode == Enum.KeyCode.DPadDown then
		vector2 = Vector2.new(vector2.x, vector2.y + v28 * 1)
	else
		vector2 = Vector2.new(0, 0)
	end

	return vector2
end

fn = function(_, p, p2)
	if p ~= Enum.UserInputState.Begin then
		return
	end

	if
		v27
		and (v27.KeyCode == Enum.KeyCode.ButtonR1 and p2.KeyCode == Enum.KeyCode.ButtonL1 or v27.KeyCode == Enum.KeyCode.ButtonL1 and p2.KeyCode == Enum.KeyCode.ButtonR1)
		and tick() - lastTime <= 0.06
	then
		UnequipAllTools() -- inferred equivalent call
		v27 = p2
		lastTime = tick()
	else
		v27 = p2
		lastTime = tick()

		delay(0.06, function()
			if v27 ~= p2 then
				return
			end

			local v28 = p2.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 1

			for i = 1, v24 do
				local v29 = slots[i]

				if not v29 then
					return
				end

				if v29:IsEquipped() then
					local v30 = v28 + i
					local v31 = false

					if v24 < v30 then
						v30 = 1
						v31 = true
					elseif v30 < 1 then
						v30 = v24
						v31 = true
					end

					local v32 = v30

					while not slots[v30].Tool do
						v30 += v28

						if v30 == v32 then
							return
						end

						if v24 < v30 then
							v30 = 1
							v31 = true
						elseif v30 < 1 then
							v30 = v24
							v31 = true
						end
					end

					if not v31 then
						slots[v30]:Select()

						return
					end

					UnequipAllTools() -- inferred equivalent call
					v26 = nil
					return
				end
			end

			if v26 and v26.Tool then
				v26:Select()
				return
			end

			for i = v28 == -1 and v24 or 1, v28 == -1 and 1 or v24, v28 do
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

				if v9 and v9.SelectionImageObject then
					v9.SelectionImageObject.Visible = false
				end

				local index = object.Index

				if v24 < index and not object.Tool then
					if GuiService.SelectedCoreObject == object.Frame then
						GuiService.SelectedCoreObject = gamepadSwapSlot.Frame
					end

					object:Delete()
				end

				local index2 = gamepadSwapSlot.Index

				if v24 < index2 and not gamepadSwapSlot.Tool then
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

			if v9 and v9.SelectionImageObject then
				v9.SelectionImageObject.Visible = true
			end
		end
	else
		object:Select()

		if v9 and v9.SelectionImageObject then
			v9.SelectionImageObject.Visible = false
		end
	end
end

function enableGamepadInventoryControl()
	local function fn3(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		if getGamepadSwapSlot() then
			local gamepadSwapSlot = getGamepadSwapSlot()

			if gamepadSwapSlot then
				gamepadSwapSlot.Frame.BorderSizePixel = 0
			end
		elseif parent5 and parent5.Visible then
			BackpackScript.OpenClose()
		end
	end

	ContextActionService:BindAction("RBXBackpackHasGamepadFocus", fn2, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("RBXCloseInventory", fn3, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

	if v6 then
		GuiService.SelectedCoreObject = v6:FindFirstChild("1")
	end
end

function disableGamepadInventoryControl()
	unbindAllGamepadEquipActions()

	for i = 1, v24 do
		local v28 = slots[i]

		if v28 and v28.Frame then
			v28.Frame.BorderSizePixel = 0
		end
	end

	if parent4 and GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(parent4) then
		GuiService.SelectedCoreObject = nil
	end
end

local function bindBackpackHotbarAction() -- 1 equivalent call inferred from this helper
	if v20 and not v4 then
		v4 = true
		ContextActionService:BindAction("RBXHotbarEquip", fn, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
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

		if parent4 then
			if FFlagStudioDeviceSimVRSwitchFixes then
				GuiService:RemoveSelectionGroup("RBXBackpackSelection")
			end

			GuiService:AddSelectionParent("RBXBackpackSelection", parent4)
		end

		if v17 >= 1 then
			bindBackpackHotbarAction() -- inferred equivalent call
		end

		if parent5 and parent5.Visible then
			enableGamepadInventoryControl()
		end
	end
end

local function setBackpackEnabled(p)
	local visible = p and v3
	v20 = visible

	if parent4 then
		if FFlagMountCoreGuiBackpack then
			if visible then
				parent4.Parent = RobloxGui
			else
				parent4.Parent = nil
			end
		else
			parent4.Visible = visible
		end
	end

	for _, v28 in pairs(v22) do
		if visible then
			GuiService:AddKey(v28)
		else
			GuiService:RemoveKey(v28)
		end
	end

	if visible then
		if v17 >= 1 and v20 and not v4 then
			v4 = true
			ContextActionService:BindAction("RBXHotbarEquip", fn, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end
	else
		unbindBackpackHotbarAction() -- inferred equivalent call
	end
end

local function MakeVRRoundButton(name, image)
	local parent2 = NewGui("ImageButton", name)
	parent2.Size = UDim2.new(0, 40, 0, 40)
	parent2.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local newGui = NewGui("ImageLabel", "Icon")
	newGui.Size = UDim2.new(0.5, 0, 0.5, 0)
	newGui.Position = UDim2.new(0.25, 0, 0.25, 0)
	newGui.Image = image
	newGui.Parent = parent2

	local selectionImageObject = NewGui("ImageLabel", "Selection")
	selectionImageObject.Size = UDim2.new(0.9, 0, 0.9, 0)
	selectionImageObject.Position = UDim2.new(0.05, 0, 0.05, 0)
	selectionImageObject.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	parent2.SelectionImageObject = selectionImageObject

	return parent2, newGui, selectionImageObject
end

function BackpackScript.createGui()
	parent4 = NewGui("Frame", "Backpack")

	if FFlagMountCoreGuiBackpack then
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
			parent4.Parent = RobloxGui
		end
	else
		parent4.Visible = false
		parent4.Parent = RobloxGui
	end

	v6 = NewGui("Frame", "Hotbar")
	v6.Parent = parent4

	for i = 1, v24 do
		local slot = MakeSlot(v6, i)
		slot.Frame.Visible = false

		if not v13 then
			v13 = slot
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

	v8 = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
	v8.Position = UDim2.new(0, 0, 0, -50)
	v8.MouseButton1Click:connect(function()
		if parent5.Visible then
			BackpackScript.OpenClose()
		end
	end)

	local newGui = NewGui("ImageLabel", "LeftBumper")
	newGui.Size = UDim2.new(0, 40, 0, 40)
	newGui.Position = UDim2.new(0, -newGui.Size.X.Offset, 0.5, -newGui.Size.Y.Offset / 2)

	local newGui2 = NewGui("ImageLabel", "RightBumper")
	newGui2.Size = UDim2.new(0, 40, 0, 40)
	newGui2.Position = UDim2.new(1, 0, 0.5, -newGui2.Size.Y.Offset / 2)

	parent5 = NewGui("Frame", "Inventory")
	parent5.BackgroundTransparency = backgroundTransparency
	parent5.BackgroundColor3 = color
	parent5.Active = true
	parent5.Visible = false
	parent5.Parent = parent4

	v9 = NewGui("TextButton", "VRInventorySelector")
	v9.Position = UDim2.new(0, 0, 0, 0)
	v9.Size = UDim2.new(1, 0, 1, 0)
	v9.BackgroundTransparency = 1
	v9.Text = ""
	v9.Parent = parent5

	local selectionImageObject2 = NewGui("ImageLabel", "Selector")
	selectionImageObject2.Size = UDim2.new(1, 0, 1, 0)
	selectionImageObject2.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	selectionImageObject2.ScaleType = Enum.ScaleType.Slice
	selectionImageObject2.SliceCenter = Rect.new(12, 12, 52, 52)
	selectionImageObject2.Visible = false
	v9.SelectionImageObject = selectionImageObject2

	parent6 = NewGui("ScrollingFrame", "ScrollingFrame")
	parent6.Selectable = false
	parent6.CanvasSize = UDim2.new(0, 0, 0, 0)
	parent6.Parent = parent5

	parent7 = NewGui("Frame", "UIGridFrame")
	parent7.Selectable = false
	parent7.Size = UDim2.new(1, -10, 1, 0)
	parent7.Position = UDim2.new(0, 5, 0, 0)
	parent7.Parent = parent6

	uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiGridLayout.CellSize = UDim2.new(0, v, 0, v)
	uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	uiGridLayout.Parent = parent7

	v10 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	v10.Size = UDim2.new(0, 34, 0, 34)
	v10.Position = UDim2.new(0.5, -v10.Size.X.Offset / 2, 0, 43)
	v10.Icon.Position = v10.Icon.Position - UDim2.new(0, 0, 0, 2)
	v10.MouseButton1Click:connect(function()
		if not parent6 then
			return
		end

		parent6.CanvasPosition = Vector2.new(
			parent6.CanvasPosition.X,
			Clamp(0, parent6.CanvasSize.Y.Offset - parent6.AbsoluteWindowSize.Y, parent6.CanvasPosition.Y - (v + 5)) -- inferred equivalent call
		)
	end)

	v11 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	v11.Rotation = 180
	v11.Icon.Position = v11.Icon.Position - UDim2.new(0, 0, 0, 2)
	v11.Size = UDim2.new(0, 34, 0, 34)
	v11.Position = UDim2.new(0.5, -v11.Size.X.Offset / 2, 1, -v11.Size.Y.Offset - 3)
	v11.MouseButton1Click:connect(function()
		if not parent6 then
			return
		end

		parent6.CanvasPosition = Vector2.new(
			parent6.CanvasPosition.X,
			Clamp(0, parent6.CanvasSize.Y.Offset - parent6.AbsoluteWindowSize.Y, parent6.CanvasPosition.Y + (v + 5)) -- inferred equivalent call
		)
	end)

	parent6.Changed:connect(function(p)
		if not parent6 then
			return
		end

		if p == "AbsoluteWindowSize" or p == "CanvasPosition" or p == "CanvasSize" then
			local visible = parent6.CanvasPosition.Y ~= 0
			local visible2 = parent6.CanvasPosition.Y < parent6.CanvasSize.Y.Offset - parent6.AbsoluteWindowSize.Y

			v10.Visible = visible
			v11.Visible = visible2
		end
	end)

	UpdateBackpackLayout()

	local parent2 = Create("Frame")({
		Name = "GamepadHintsFrame",
		Size = UDim2.new(0, v6.Size.X.Offset, 0, v2 and 95 or 60),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = parent4
	})

	local function addGamepadHint(image, p, text)
		local parent3 = Create("Frame")({
			Name = "HintFrame",
			Size = UDim2.new(1, 0, 1, -5),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Parent = parent2
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
		hintImage.Parent = parent3
		create(hintImage)

		local parent9 = Create("TextLabel")({
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
			Parent = parent3
		})

		local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
		uiTextSizeConstraint.Parent = parent9
		uiTextSizeConstraint.MaxTextSize = parent9.TextSize
	end

	local function resizeGamepadHintsFrame()
		if not (v6 and parent5) then
			return
		end

		parent2.Size = UDim2.new(v6.Size.X.Scale, v6.Size.X.Offset, 0, v2 and 95 or 60)
		parent2.Position = UDim2.new(
			v6.Position.X.Scale,
			v6.Position.X.Offset,
			parent5.Position.Y.Scale,
			parent5.Position.Y.Offset - parent2.Size.Y.Offset
		)

		local children = parent2:GetChildren()
		local total = 0

		for i = 1, #children do
			children[i].Size = UDim2.new(1, 0, 1, -5)
			children[i].Position = UDim2.new(0, 0, 0, 0)

			total += children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X
		end

		local v28 = (parent2.AbsoluteSize.X - total) / (#children - 1)

		for i = 1, #children do
			children[i].Position = i == 1 and UDim2.new(0, 0, 0, 0)
				or UDim2.new(0, children[i - 1].Position.X.Offset + children[i - 1].Size.X.Offset + v28, 0, 0)

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

	local parent3 = NewGui("Frame", "Search")

	parent3.BackgroundColor3 = color6
	parent3.BackgroundTransparency = backgroundTransparency3
	parent3.Size = UDim2.new(0, 190, 0, 30)
	parent3.Position = UDim2.new(1, -parent3.Size.X.Offset - 5, 0, 5)
	parent3.Parent = parent5

	local newGui3 = NewGui("TextBox", "TextBox")
	newGui3.Text = text2
	newGui3.ClearTextOnFocus = false
	newGui3.FontSize = Enum.FontSize.Size24
	newGui3.TextXAlignment = Enum.TextXAlignment.Left
	newGui3.Size = parent3.Size - UDim2.new(0, 0, 0, 0)
	newGui3.Position = UDim2.new(0, 0, 0, 0)
	newGui3.Parent = parent3

	local newGui4 = NewGui("TextButton", "X")
	newGui4.Text = "x"
	newGui4.TextColor3 = color3
	newGui4.FontSize = Enum.FontSize.Size24
	newGui4.TextYAlignment = Enum.TextYAlignment.Bottom
	newGui4.BackgroundColor3 = color6
	newGui4.BackgroundTransparency = 0
	newGui4.Size = UDim2.new(0, parent3.Size.Y.Offset - 10, 0, parent3.Size.Y.Offset - 10)

	newGui4.Position = UDim2.new(1, -newGui4.Size.X.Offset - 10, 0.5, -newGui4.Size.Y.Offset / 2)
	newGui4.ZIndex = 0
	newGui4.Visible = false
	newGui4.BorderSizePixel = 0
	newGui4.Parent = parent3

	local function search()
		local set2 = {}

		for k in newGui3.Text:gmatch("%S+") do
			set2[k:lower()] = true
		end

		local v28 = {}

		for i = v24 + 1, #slots do
			local v29 = slots[i]
			table.insert(v28, { v29, (v29:CheckTerms(set2)) })
			v29.Frame.Visible = false
			v29.Frame.Parent = parent5
		end

		table.sort(v28, function(a, b): boolean
			return a[2] > b[2]
		end)

		flag = true
		local count = 0

		for _, v29 in ipairs(v28) do
			local v30 = v29[1]

			if not (v29[2] > 0) then
				continue
			end

			v30.Frame.Visible = true
			v30.Frame.Parent = parent7
			v30.Frame.LayoutOrder = v24 + count
			count += 1
		end

		if parent6 then
			parent6.CanvasPosition = Vector2.new(0, 0)
		end

		UpdateScrollingFrameCanvasSize()

		newGui4.ZIndex = 3
	end

	local function clearResults()
		if newGui4.ZIndex > 0 then
			flag = false

			for i = v24 + 1, #slots do
				local v28 = slots[i]
				v28.Frame.LayoutOrder = v28.Index
				v28.Frame.Parent = parent7
				v28.Frame.Visible = true
			end

			newGui4.ZIndex = 0
		end

		UpdateScrollingFrameCanvasSize()
	end

	local function reset() -- 2 equivalent calls inferred from this helper
		clearResults()
		newGui3.Text = text2
	end

	local function onChanged(p)
		if p == "Text" then
			local text = newGui3.Text

			if text == "" then
				clearResults()
			elseif text ~= text2 then
				search()
			end

			newGui4.Visible = text ~= "" and text ~= text2
		end
	end

	local function onFocused()
		if newGui3.Text == text2 then
			newGui3.Text = ""
		end
	end

	local function focusLost(p)
		if p then
			search()
		elseif newGui3.Text == "" then
			newGui3.Text = text2
		end
	end

	newGui3.Focused:connect(onFocused)
	newGui4.MouseButton1Click:connect(reset)
	newGui3.Changed:connect(onChanged)
	newGui3.FocusLost:connect(focusLost)

	table.insert(connections2, BackpackScript.StateChanged.Event:connect(function(modal)
		newGui4.Modal = modal

		if not modal then
			reset() -- inferred equivalent call
		end
	end))

	v15[Enum.KeyCode.Escape.Value] = function(p)
		if p then
			reset() -- inferred equivalent call
		elseif parent5 and parent5.Visible then
			BackpackScript.OpenClose()
		end
	end

	local function detectGamepad(p)
		if p == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
			parent3.Visible = false
		else
			parent3.Visible = true
		end
	end
	table.insert(connections2, UserInputService.LastInputTypeChanged:connect(detectGamepad))

	local function fn3(_, p, _)
		if not (p == Enum.UserInputState.Begin and GuiService.SelectedCoreObject) then
			return
		end

		for i = 1, v24 do
			if slots[i].Frame == GuiService.SelectedCoreObject and slots[i].Tool then
				slots[i]:MoveToInventory()
				break
			end
		end
	end

	local function openClose()
		if not parent5 then
			return
		end

		if not next(v16) then
			parent5.Visible = not parent5.Visible
			local visible = parent5.Visible
			AdjustHotbarFrames()
			v6.Active = not v6.Active

			for i = 1, v24 do
				slots[i]:SetClickability(not visible)
			end
		end

		if parent5.Visible then
			if flag2 then
				if set[UserInputService:GetLastInputType()] then
					resizeGamepadHintsFrame()
					parent2.Visible = true
				end

				enableGamepadInventoryControl()
			end
		else
			if flag2 then
				parent2.Visible = false
			end

			disableGamepadInventoryControl()
		end

		if parent5.Visible then
			ContextActionService:BindAction("RBXRemoveSlot", fn3, false, Enum.KeyCode.ButtonX)
		else
			ContextActionService:UnbindAction("RBXRemoveSlot")
		end

		BackpackScript.IsOpen = parent5.Visible
		BackpackScript.StateChanged:Fire(parent5.Visible)
	end

	v15[value] = function()
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

	table.insert(connections2, LocalPlayer.CharacterAdded:connect(OnCharacterAdded))

	if LocalPlayer.Character then
		OnCharacterAdded(LocalPlayer.Character)
	end

	for i = 0, 9 do
		table.insert(v22, (tostring(i)))
	end

	table.insert(v22, "`")

	table.insert(connections2, UserInputService.InputBegan:connect(OnInputBegan))

	table.insert(connections2, UserInputService.TextBoxFocused:connect(function()
		v21 = true
	end))

	table.insert(connections2, UserInputService.TextBoxFocusReleased:connect(function()
		v21 = false
	end))

	v15[value3] = function()
		if v18 then
			UnequipAllTools() -- inferred equivalent call
		end
	end

	table.insert(connections2, UserInputService.Changed:connect(OnUISChanged))
	local v28 = UserInputService.KeyboardEnabled and not VRService.VREnabled

	for i = 1, v24 do
		slots[i]:TurnNumber(v28)
	end

	if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
		gamepadConnected()
	end

	table.insert(connections2, UserInputService.GamepadConnected:connect(function(p)
		if p == Enum.UserInputType.Gamepad1 then
			gamepadConnected()
		end
	end))

	table.insert(connections2, UserInputService.GamepadDisconnected:connect(function(p)
		if p == Enum.UserInputType.Gamepad1 then
			gamepadDisconnected()
		end
	end))

	if defineFastFlag then
		table.insert(connections2, SettingsShowSignal:connect(function(p)
			if p then
				if BackpackScript.IsHotbarVisible then
					AdjustHotbarFrames(true)
				end
			else
				AdjustHotbarFrames(false)
			end
		end))
	end

	table.insert(connections2, GuiService.MenuOpened:Connect(function()
		if
			BackpackScript.IsOpen
			and (not isInExperienceUIVREnabled or InExperienceUIVRIXP:isMovePanelToCenter() or not VRService.VREnabled)
		then
			BackpackScript.OpenClose()
		end
	end))

	table.insert(connections2, InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p)
		if p and BackpackScript.IsOpen then
			BackpackScript.OpenClose()
		end
	end))

	local function OnPreferredTransparencyChanged()
		local preferredTransparency = UserGameSettings.PreferredTransparency

		backgroundTransparency = 0.5 * UserGameSettings.PreferredTransparency

		if parent5 then
			parent5.BackgroundTransparency = backgroundTransparency
		end

		backgroundTransparency2 = 0.5 * preferredTransparency

		for _, v29 in ipairs(slots) do
			v29.Frame.BackgroundTransparency = backgroundTransparency2
		end

		backgroundTransparency3 = 0.15 * UserGameSettings.PreferredTransparency
		parent3.BackgroundTransparency = backgroundTransparency3
	end
	table.insert(
		connections2,
		UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)
	)
end

function BackpackScript.destroyGui()
	for _, connection in pairs(connections2) do
		connection:disconnect()
	end

	table.clear(connections2)

	for _, connection in pairs(connections) do
		connection:disconnect()
	end

	table.clear(connections)

	ContextActionService:UnbindAction("RBXHotbarEquip")
	ContextActionService:UnbindAction("RBXRemoveSlot")
	unbindAllGamepadEquipActions()

	for i = #slots, 1, -1 do
		local v28 = slots[i]

		if v28.Tool then
			v28:Clear()
		end
	end

	table.clear(slots)
	table.clear(v14)
	table.clear(v15)
	table.clear(v16)
	table.clear(v22)

	if parent4 then
		parent4:Destroy()
		parent4 = nil
	end

	v6 = nil
	v7 = nil
	v8 = nil
	parent5 = nil
	v9 = nil
	parent6 = nil
	parent7 = nil
	uiGridLayout = nil
	v10 = nil
	v11 = nil

	parent8 = nil
	v12 = nil
	backpack = nil
	v13 = nil
	v17 = 0
	v18 = nil
	v19 = false
	v20 = false
	v21 = false
	flag = false
	flag2 = false
	v4 = false
	v23 = 0
	v26 = nil
	BackpackScript.OpenClose = nil
	BackpackScript.IsOpen = false
	BackpackScript.IsHotbarVisible = false
end

function BackpackScript:TopbarEnabledChanged(p)
	v3 = p
	setBackpackEnabled(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end

if FFlagTopBarSignalizeSetCores then
	BackpackScript.disposeEffect = Signals.createEffect(function(p)
		local getTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

		if getTopBarStore then
			BackpackScript:TopbarEnabledChanged(getTopBarStore(p).getTopBarCoreGuiEnabled(p))
		end
	end)
end

local Features = System.Features
local lifecycle = Features.registerLifecycle(Features.FeatureName.Backpack, {
	defaultVisible = false,
	coreGuiType = Enum.CoreGuiType.Backpack
}).lifecycle

lifecycle:onEnabledChanged(function(p)
	if p then
		BackpackScript.createGui()
	else
		BackpackScript.destroyGui()
	end

	setBackpackEnabled(p)
end)

lifecycle:onVisibilityChanged(function(p)
	if BackpackScript.OpenClose and BackpackScript.IsOpen ~= p then
		BackpackScript.OpenClose()
	end

	return BackpackScript.IsOpen
end)

BackpackScript.StateChanged.Event:connect(function(p)
	if lifecycle then
		lifecycle.setVisible(p)
	end
end)

return BackpackScript
