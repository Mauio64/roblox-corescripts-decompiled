local Parent = script:FindFirstAncestor("Backpack").Parent
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules
local Signals = require(Parent.Signals)
local InExperienceTopBar = require(Parent.InExperienceTopBar)
local SettingsShowSignal = require(Parent.CoreScriptsCommon).SettingsShowSignal
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local isInExperienceUIVREnabled = require(Parent.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(Parent.SharedExperimentDefinition).InExperienceUIVRIXP
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores
local RobloxTranslator = require(Parent.RobloxTranslator)
local Responsive = require(Parent.Responsive)
local FFlagBackpackResponsiveUnits = require(Parent.SharedFlags).FFlagBackpackResponsiveUnits
local System = require(Parent.System)
local v17 = game:DefineFastFlag("EnableHotbarHide", false)
local t1 = {
	OpenClose = nil,
	IsHotbarVisible = false,
	IsOpen = false,
	StateChanged = Instance.new("BindableEvent"),
	ModuleName = "Backpack",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = true
}
local n1 = 60
local Size14 = Enum.FontSize.Size14
local u21 = 0.5 * UserGameSettings.PreferredTransparency
local color3 = Color3.new(0.12156862745098039, 0.12156862745098039, 0.12156862745098039)
local color3_2 = Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)
local color3_3 = Color3.new(0.35294117647058826, 0.5568627450980392, 0.9137254901960784)
local u25 = 0.5 * UserGameSettings.PreferredTransparency
local color3_4 = Color3.new(1, 1, 1)

UDim2.new(0, 14, 0, 9)

local BackquoteValue = Enum.KeyCode.Backquote.Value
local color3_5 = Color3.new(0, 0.6352941176470588, 1)
local s1 = "   Search"
local color3_6 = Color3.new(0.37, 0.37, 0.37)
local u31 = 0.15 * UserGameSettings.PreferredTransparency
local ZeroValue = Enum.KeyCode.Zero.Value
local BackspaceValue = Enum.KeyCode.Backspace.Value
local t2 = {
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

local v42 = require(Modules.TenFootInterface):IsEnabled()
local Create = require(Parent.AppCommonLib).Create
local GameTranslator = require(Modules.GameTranslator)

pcall(function() -- line: 123
	-- upvalues: s1 (ref), RobloxTranslator (copy)
	s1 = RobloxTranslator:FormatByKey("InGame.UnknownNamespace.BACKPACK_SEARCH")
end)

local u45 = true

if v42 then
	n1 = 100
	Size14 = Enum.FontSize.Size24
end

local u46 = false
local v47 = if not FFlagBackpackResponsiveUnits then UserInputService.TouchEnabled and GuiService:GetScreenResolution().X < 1024 else Responsive.GetInputModeStore().getPreferredInputType() == Responsive.Input.Touch and GuiService:GetScreenResolution().X < 1024
local LocalPlayer = Players.LocalPlayer
local u49 = nil
local u50 = nil
local u51 = nil
local u52 = nil
local u53 = nil
local u54 = nil
local u55 = nil
local u56 = nil
local UIGridLayout = nil
local u58 = nil
local u59 = nil
local u60 = nil
local u61 = nil
local Backpack = nil
local t3 = {}
local u64 = nil
local t4 = {}
local t5 = {}
local t6 = {}
local n2 = 0
local u69 = nil
local u70 = false
local u71 = false
local u72 = false
local u73 = false
local t7 = {}
local t8 = {}
local t9 = {}
local u77 = false
local n3 = 0
local u79 = not v47 and 10 or 3
local v80 = not v47 and 4 or 2
local u81 = nil
local u82 = nil

t1.BackpackEmpty = Create("BindableEvent")({
	Name = "BackpackEmpty"
})
t1.BackpackItemAdded = Create("BindableEvent")({
	Name = "BackpackAdded"
})
t1.BackpackItemRemoved = Create("BindableEvent")({
	Name = "BackpackRemoved"
})

local function NewGui(p1, p2) -- line: 199
	-- upvalues: Size14 (ref)
	local v119 = Instance.new(p1)

	v119.Name = p2
	v119.BackgroundColor3 = Color3.new(0, 0, 0)
	v119.BackgroundTransparency = 1
	v119.BorderColor3 = Color3.new(0, 0, 0)
	v119.BorderSizePixel = 0
	v119.Size = UDim2.new(1, 0, 1, 0)

	if p1:match("Text") then
		v119.TextColor3 = Color3.new(1, 1, 1)
		v119.Text = ""
		v119.Font = Enum.Font.SourceSans
		v119.FontSize = Size14
		v119.TextWrapped = true

		if p1 == "TextButton" then
			v119.Font = Enum.Font.SourceSansBold
			v119.BorderSizePixel = 1
		end
	end

	return v119
end
local function FindLowestEmpty() -- line: 221
	-- upvalues: u79 (ref), t3 (copy)
	for i = 1, u79 do
		local v121 = t3[i]

		if not v121.Tool then
			return v121
		end
	end

	return nil
end
local function isInventoryEmpty() -- line: 231
	-- upvalues: u79 (ref), t3 (copy)
	for i = u79 + 1, #t3 do
		local v123 = t3[i]

		if v123 and v123.Tool then
			return false
		end
	end

	return true
end

t1.IsInventoryEmpty = isInventoryEmpty

local function UseGazeSelection() -- line: 243
	return false
end
local function AdjustHotbarFrames(p3) -- line: 247
	-- upvalues: u53 (ref), u79 (ref), n2 (ref), v17 (copy), t3 (copy), u51 (ref), t1 (copy)
	if not u53 then
		return
	end

	local Visible = u53.Visible
	local v126 = Visible and u79 or n2
	local n4 = 0
	local v128 = if not v17 then v126 >= 1 else v126 >= 1 and not p3
	local g136 = nil
	local v135 = nil

	for i = 1, u79 do
		local v130 = t3[i]

		if ((if not v17 then v130.Tool else v130.Tool and not p3)) or Visible then
			n4 += 1
			v130:Readjust(n4, v126)
			v130.Frame.Visible = true
		else
			v130.Frame.Visible = false
		end
	end

	if u51 then
		local v131 = u51
		local v132 = not Visible

		if v132 then
			v132 = v128

			if not v132 then
				for i = u79 + 1, #t3 do
					local v134 = t3[i]

					if v134 and v134.Tool then
						v135 = false
						g136 = true
					end

					if g136 then
						break
					end
				end

				if not g136 then
					v135 = true
				end

				g136 = false
				v132 = not v135
			end
		end

		v131.Visible = v132
		u51.Position = UDim2.new(0.5, -15, 1, not v128 and -50 or -110)
	end

	t1.IsHotbarVisible = v128
end
local function UpdateScrollingFrameCanvasSize() -- line: 275
	-- upvalues: u55 (ref), u56 (ref), n1 (ref)
	if not u55 or not u56 then
		return
	end

	local v137 = math.floor(u55.AbsoluteSize.X / (n1 + 5))
	local v138 = math.ceil((#u56:GetChildren() - 1) / v137) * (n1 + 5) + 5

	u55.CanvasSize = UDim2.new(0, 0, 0, v138)
end
local function AdjustInventoryFrames() -- line: 285
	-- upvalues: u79 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
	for i = u79 + 1, #t3 do
		local v140 = t3[i]

		v140.Frame.LayoutOrder = v140.Index
		v140.Frame.Visible = v140.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end
local function UpdateBackpackLayout() -- line: 294
	-- upvalues: u50 (ref), u53 (ref), u79 (ref), n1 (ref), v80 (copy), u55 (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy)
	if not u50 or not u53 then
		return
	end

	u50.Size = UDim2.new(0, 5 + u79 * (n1 + 5), 0, n1 + 5 + 5)
	u50.Position = UDim2.new(0.5, -u50.Size.X.Offset / 2, 1, -u50.Size.Y.Offset)
	u53.Size = UDim2.new(0, u50.Size.X.Offset, 0, u50.Size.Y.Offset * v80 + 40)
	u53.Position = UDim2.new(0.5, -u53.Size.X.Offset / 2, 1, u50.Position.Y.Offset - u53.Size.Y.Offset)

	if u55 then
		u55.Size = UDim2.new(1, u55.ScrollBarThickness + 1, 1, -40)
		u55.Position = UDim2.new(0, 0, 0, 40)
	end

	AdjustHotbarFrames()
	AdjustInventoryFrames()
end
local function Clamp(p4, p5, p6) -- line: 326
	return (math.min(p5, (math.max(p4, p6))))
end
local function CheckBounds(p7, p8, p9) -- line: 330
	local AbsolutePosition = p7.AbsolutePosition
	local AbsoluteSize = p7.AbsoluteSize

	return p8 > AbsolutePosition.X and (p8 <= AbsolutePosition.X + AbsoluteSize.X and (p9 > AbsolutePosition.Y and p9 <= AbsolutePosition.Y + AbsoluteSize.Y))
end
local function GetOffset(p10, p11) -- line: 336
	return (p10.AbsolutePosition + p10.AbsoluteSize / 2 - p11).magnitude
end
local function DisableActiveHopper() -- line: 341
	-- upvalues: u69 (ref), t4 (copy)
	u69:ToggleSelect()
	t4[u69]:UpdateEquipView()
	u69 = nil
end
local function UnequipAllTools() -- line: 347
	-- upvalues: u61 (ref), u69 (ref), t4 (copy)
	if u61 then
		u61:UnequipTools()

		if u69 then
			u69:ToggleSelect()
			t4[u69]:UpdateEquipView()
			u69 = nil
		end
	end
end
local function EquipNewTool(p12) -- line: 356
	-- upvalues: u61 (ref), u69 (ref), t4 (copy), u60 (ref)
	if u61 then
		u61:UnequipTools()

		if u69 then
			u69:ToggleSelect()
			t4[u69]:UpdateEquipView()
			u69 = nil
		end
	end

	if p12:IsA("HopperBin") then
		p12:ToggleSelect()
		t4[p12]:UpdateEquipView()
		u69 = p12

		return
	end

	p12.Parent = u60
end
local function IsEquipped(p13) -- line: 368
	-- upvalues: u60 (ref)
	return p13 and (p13:IsA("HopperBin") and p13.Active or p13.Parent == u60)
end
local function MakeSlot(p14, p15) -- line: 372
	-- upvalues: t3 (copy), u25 (ref), color3_2 (copy), color3 (copy), u50 (ref), n1 (ref), GameTranslator (copy), u79 (ref), u53 (ref), n2 (ref), u71 (ref), u46 (ref), ContextActionService (copy), u82 (ref), t4 (copy), u64 (ref), u60 (ref), u81 (ref), NewGui (copy), color3_3 (copy), t6 (copy), UpdateScrollingFrameCanvasSize (copy), u61 (ref), u69 (ref), Backpack (ref), color3_4 (copy), MakeSlot (copy), u56 (ref), u73 (ref), t5 (copy), ZeroValue (copy), u55 (ref)
	local v155 = p15 or #t3 + 1
	local t10 = {
		Tool = nil,
		Index = v155,
		Frame = nil
	}
	local u157 = nil
	local u158 = nil
	local u159 = nil
	local u160 = nil
	local u161 = nil
	local u162 = nil
	local u163 = nil
	local u164 = nil

	local function UpdateSlotFading() -- line: 397
		-- upvalues: u157 (ref), u25 (ref), color3_2 (copy), color3 (copy)
		u157.SelectionImageObject = nil
		u157.BackgroundTransparency = if not u157.Draggable then u25 else 0
		u157.BackgroundColor3 = u157.Draggable and color3_2 or color3
	end

	function t10.Readjust(_, p17, p18) -- line: 403
		-- upvalues: u50 (ref), n1 (ref), u157 (ref)
		local v292 = u50.Size.X.Offset / 2
		local v293 = n1 + 5
		local v294 = p17 - (p18 / 2 + 0.5)

		u157.Position = UDim2.new(0, v292 - n1 / 2 + v293 * v294, 0, 5)
	end
	function t10.Fill(p19, p20) -- line: 411
		-- upvalues: u159 (ref), u160 (ref), GameTranslator (copy), u163 (ref), u161 (ref), u79 (ref), u53 (ref), u157 (ref), n2 (ref), u71 (ref), u46 (ref), ContextActionService (copy), u82 (ref), t4 (copy), u64 (ref), t3 (copy)
		if not p20 then
			return p19:Clear()
		end

		p19.Tool = p20

		local function assignToolData() -- line: 418
			-- upvalues: p20 (copy), u159 (ref), u160 (ref), GameTranslator (copy), u163 (ref)
			local TextureId = p20.TextureId

			u159.Image = TextureId

			if TextureId ~= "" then
				u160.Visible = false
			else
				u160.Visible = true
			end

			GameTranslator:TranslateAndRegister(u160, p20, p20.Name)

			if u163 and p20:IsA("Tool") then
				GameTranslator:TranslateAndRegister(u163, p20, p20.ToolTip)

				local v426 = u163.TextBounds.X + 6

				u163.Size = UDim2.new(0, v426, 0, 16)
				u163.Position = UDim2.new(0.5, -v426 / 2, 0, -25)
			end
		end

		assignToolData()

		local g302 = nil
		local v301 = nil

		if u161 then
			u161:disconnect()
			u161 = nil
		end

		u161 = p20.Changed:connect(function(p21) -- line: 444
			-- upvalues: assignToolData (copy)
			if p21 == "TextureId" or (p21 == "Name" or p21 == "ToolTip") then
				assignToolData()
			end
		end)

		local v298 = p19.Index <= u79
		local Visible = u53.Visible

		if not v298 or Visible then
			u157.Draggable = true
		end

		p19:UpdateEquipView()

		if v298 then
			n2 += 1

			if u71 and n2 >= 1 and not u46 then
				u46 = true
				ContextActionService:BindAction("RBXHotbarEquip", u82, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
			end
		end

		t4[p20] = p19

		for i = 1, u79 do
			v301 = t3[i]

			if not v301.Tool then
				g302 = true
			end

			if g302 then
				break
			end
		end

		if not g302 then
			v301 = nil
		end

		g302 = false
		u64 = v301
	end
	function t10.Clear(p22) -- line: 481
		-- upvalues: u161 (ref), u159 (ref), u160 (ref), u163 (ref), u157 (ref), u79 (ref), n2 (ref), u46 (ref), ContextActionService (copy), t4 (copy), u64 (ref), t3 (copy)
		if not p22.Tool then
			return
		end

		local g306 = nil
		local v305 = nil

		if u161 then
			u161:disconnect()
			u161 = nil
		end

		u159.Image = ""
		u160.Text = ""

		if u163 then
			u163.Text = ""
			u163.Visible = false
		end

		u157.Draggable = false
		p22:UpdateEquipView(true)

		if p22.Index <= u79 then
			n2 -= 1

			if n2 < 1 then
				u46 = false
				ContextActionService:UnbindAction("RBXHotbarEquip")
			end
		end

		t4[p22.Tool] = nil
		p22.Tool = nil

		for i = 1, u79 do
			v305 = t3[i]

			if not v305.Tool then
				g306 = true
			end

			if g306 then
				break
			end
		end

		if not g306 then
			v305 = nil
		end

		g306 = false
		u64 = v305
	end
	function t10.UpdateEquipView(p23, p24) -- line: 514
		-- upvalues: u60 (ref), u81 (ref), t10 (copy), u162 (ref), NewGui (copy), u157 (ref), color3_3 (copy), u25 (ref), color3_2 (copy), color3 (copy)
		local g309 = nil
		local Tool = nil

		repeat
			if g309 or not p24 then
				if not g309 then
					Tool = p23.Tool
				end

				if g309 or Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u60) then
					if not g309 then
						u81 = t10

						if not u162 then
							u162 = NewGui("Frame", "Equipped")
							u162.ZIndex = u157.ZIndex

							for _, v in pairs({
								{
									0.1,
									1,
									0,
									0
								},
								{
									0.8,
									0.1,
									0.1,
									0
								},
								{
									0.1,
									1,
									0.9,
									0
								},
								{
									0.8,
									0.1,
									0.1,
									0.9
								}
							}) do
								local v313 = NewGui("Frame", "Edge")

								v313.BackgroundTransparency = 0
								v313.BackgroundColor3 = color3_3
								v313.Size = UDim2.new(v[1], 0, v[2], 0)
								v313.Position = UDim2.new(v[3], 0, v[4], 0)
								v313.ZIndex = u162.ZIndex
								v313.Parent = u162
							end
						end

						u162.Parent = u157
					end

					g309 = false
					u157.SelectionImageObject = nil
					u157.BackgroundTransparency = if not u157.Draggable then u25 else 0
					u157.BackgroundColor3 = u157.Draggable and color3_2 or color3

					return
				end
			end

			if u162 then
				u162.Parent = nil
			end

			g309 = true
		until not g309
	end
	function t10.IsEquipped(p25) -- line: 546
		-- upvalues: u60 (ref)
		local Tool = p25.Tool

		return Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u60)
	end
	function t10.Delete(p26) -- line: 550
		-- upvalues: t6 (copy), u157 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
		t6[u157] = nil
		u157:Destroy()
		table.remove(t3, p26.Index)

		local v317 = #t3

		for i = p26.Index, v317 do
			t3[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end
	function t10.Swap(p27, p28) -- line: 564
		local Tool = p27.Tool
		local Tool2 = p28.Tool

		p27:Clear()

		if Tool2 then
			p28:Clear()
			p27:Fill(Tool2)
		end

		if Tool then
			p28:Fill(Tool)

			return
		end

		p28:Clear()
	end
	function t10.SlideBack(p29) -- line: 578
		-- upvalues: u157 (ref)
		p29.Index = p29.Index - 1
		u157.Name = p29.Index
		u157.LayoutOrder = p29.Index
	end
	function t10.TurnNumber(_, p31) -- line: 584
		-- upvalues: u164 (ref)
		if u164 then
			u164.Visible = p31
		end
	end
	function t10.SetClickability(p32, p33) -- line: 590
		-- upvalues: u157 (ref), u25 (ref), color3_2 (copy), color3 (copy)
		if p32.Tool then
			u157.Draggable = not p33
			u157.SelectionImageObject = nil
			u157.BackgroundTransparency = if not u157.Draggable then u25 else 0
			u157.BackgroundColor3 = u157.Draggable and color3_2 or color3
		end
	end
	function t10.CheckTerms(p34, p35) -- line: 597
		-- upvalues: u160 (ref), u163 (ref)
		local n5 = 0

		local function checkEm(p36, p37) -- line: 599
			-- upvalues: n5 (ref)
			local _, count = p36:lower():gsub(p37, "")

			n5 += count
		end

		local Tool = p34.Tool

		if Tool then
			for k in pairs(p35) do
				local _, count = u160.Text:lower():gsub(k, "")

				n5 += count

				if Tool:IsA("Tool") then
					local _, count2 = (u163 and u163.Text or ""):lower():gsub(k, "")

					n5 += count2
				end
			end
		end

		return n5
	end
	function t10.Select(_, p39) -- line: 617
		-- upvalues: t10 (copy), u60 (ref), u61 (ref), u69 (ref), t4 (copy), Backpack (ref)
		if p39 then
			return
		end

		local Tool = t10.Tool

		if Tool then
			if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u60) then
				if u61 then
					u61:UnequipTools()

					if u69 then
						u69:ToggleSelect()
						t4[u69]:UpdateEquipView()
						u69 = nil

						return
					end
				end
			elseif Tool.Parent == Backpack then
				if u61 then
					u61:UnequipTools()

					if u69 then
						u69:ToggleSelect()
						t4[u69]:UpdateEquipView()
						u69 = nil
					end
				end

				if Tool:IsA("HopperBin") then
					Tool:ToggleSelect()
					t4[Tool]:UpdateEquipView()
					u69 = Tool

					return
				end

				Tool.Parent = u60
			end
		end
	end

	u157 = NewGui("TextButton", v155)
	u157.BackgroundColor3 = color3
	u157.BorderColor3 = color3_4
	u157.Text = ""
	u157.AutoButtonColor = false
	u157.BorderSizePixel = 0
	u157.Size = UDim2.new(0, n1, 0, n1)
	u157.Active = true
	u157.Draggable = false
	u157.BackgroundTransparency = u25
	u157.MouseButton1Click:connect(function() -- line: 644
		-- upvalues: t10 (copy)
		changeSlot(t10)
	end)
	t10.Frame = u157

	local v166 = NewGui("Frame", "SelectionObjectClipper")

	v166.Visible = false
	v166.Parent = u157

	local v167 = NewGui("ImageLabel", "Selector")

	v167.Size = UDim2.new(1, 0, 1, 0)
	v167.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	v167.ScaleType = Enum.ScaleType.Slice
	v167.SliceCenter = Rect.new(12, 12, 52, 52)
	v167.Parent = v166
	u159 = NewGui("ImageLabel", "Icon")
	u159.Size = UDim2.new(0.8, 0, 0.8, 0)
	u159.Position = UDim2.new(0.1, 0, 0.1, 0)
	u159.Parent = u157
	u160 = NewGui("TextLabel", "ToolName")
	u160.Size = UDim2.new(1, -2, 1, -2)
	u160.Position = UDim2.new(0, 1, 0, 1)
	u160.Parent = u157
	t10.Frame.LayoutOrder = t10.Index

	if v155 <= u79 then
		u163 = NewGui("TextLabel", "ToolTip")
		u163.TextWrapped = false
		u163.TextYAlignment = Enum.TextYAlignment.Top
		u163.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		u163.BackgroundTransparency = 0
		u163.Visible = false
		u163.Parent = u157
		u157.MouseEnter:connect(function() -- line: 683
			-- upvalues: u163 (ref)
			if u163.Text ~= "" then
				u163.Visible = true
			end
		end)
		u157.MouseLeave:connect(function() -- line: 688
			-- upvalues: u163 (ref)
			u163.Visible = false
		end)

		function t10.MoveToInventory(p40) -- line: 692
			-- upvalues: t10 (copy), u79 (ref), MakeSlot (copy), u56 (ref), u60 (ref), u61 (ref), u69 (ref), t4 (copy), u73 (ref), u53 (ref)
			if t10.Index <= u79 then
				local Tool = t10.Tool

				p40:Clear()

				local v343 = MakeSlot(u56)

				v343:Fill(Tool)

				if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u60) and u61 then
					u61:UnequipTools()

					if u69 then
						u69:ToggleSelect()
						t4[u69]:UpdateEquipView()
						u69 = nil
					end
				end

				if u73 then
					v343.Frame.Visible = false
					v343.Parent = u53
				end
			end
		end

		if v155 < 10 or v155 == u79 then
			local v168 = v155 < 10 and v155 or 0

			u164 = NewGui("TextLabel", "Number")
			u164.Text = v168
			u164.Size = UDim2.new(0.15, 0, 0.15, 0)
			u164.Visible = false
			u164.Parent = u157
			t5[ZeroValue + v168] = function(p41) -- line: 718
				-- upvalues: t10 (copy)
				t10:Select(p41)
			end
		end
	end

	local Position = u157.Position
	local n6 = 0
	local Parent2 = nil

	u157.DragBegin:connect(function(p42) -- line: 729
		-- upvalues: t6 (copy), u157 (ref), Position (ref), u159 (ref), u160 (ref), u164 (ref), u162 (ref), Parent2 (ref), u56 (ref), u53 (ref), u158 (ref), NewGui (copy)
		t6[u157] = true
		Position = p42
		u157.BorderSizePixel = 2
		u157.ZIndex = 2
		u159.ZIndex = 2
		u160.ZIndex = 2
		u157.Parent.ZIndex = 2

		if u164 then
			u164.ZIndex = 2
		end

		if u162 then
			u162.ZIndex = 2

			for _, child in pairs(u162:GetChildren()) do
				child.ZIndex = 2
			end
		end

		Parent2 = u157.Parent

		if Parent2 == u56 then
			local _ = u157.AbsolutePosition
			local uDim2 = UDim2.new(0, u157.AbsolutePosition.X - u53.AbsolutePosition.X, 0, u157.AbsolutePosition.Y - u53.AbsolutePosition.Y)

			u157.Parent = u53
			u157.Position = uDim2
			u158 = NewGui("Frame", "FakeSlot")
			u158.LayoutOrder = u157.LayoutOrder
			u158.Size = u157.Size
			u158.BackgroundTransparency = 1
			u158.Parent = u56
		end
	end)
	u157.DragStopped:connect(function(p43, p44) -- line: 771
		-- upvalues: u158 (ref), u157 (ref), Position (ref), Parent2 (ref), u159 (ref), u160 (ref), u164 (ref), u162 (ref), t6 (copy), t10 (copy), u53 (ref), u79 (ref), n6 (ref), u64 (ref), u50 (ref), t3 (copy), u60 (ref), u61 (ref), u69 (ref), t4 (copy), u73 (ref)
		if u158 then
			u158:Destroy()
		end

		local timestamp = tick()

		u157.Position = Position
		u157.Parent = Parent2
		u157.BorderSizePixel = 0
		u157.ZIndex = 1
		u159.ZIndex = 1
		u160.ZIndex = 1
		Parent2.ZIndex = 1

		if u164 then
			u164.ZIndex = 1
		end

		if u162 then
			u162.ZIndex = 1

			for _, child in pairs(u162:GetChildren()) do
				child.ZIndex = 1
			end
		end

		t6[u157] = nil

		if not t10.Tool then
			return
		end

		local v355 = u53
		local AbsolutePosition = v355.AbsolutePosition
		local AbsoluteSize = v355.AbsoluteSize

		if p43 > AbsolutePosition.X and (p43 <= AbsolutePosition.X + AbsoluteSize.X and (p44 > AbsolutePosition.Y and p44 <= AbsolutePosition.Y + AbsoluteSize.Y)) then
			if t10.Index <= u79 then
				t10:MoveToInventory()
			end

			if t10.Index > u79 and timestamp - n6 < 0.5 then
				if u64 then
					local Tool = t10.Tool

					t10:Clear()
					u64:Fill(Tool)
					t10:Delete()
				end

				timestamp = 0
			end
		else
			local v359 = u50
			local AbsolutePosition2 = v359.AbsolutePosition
			local AbsoluteSize2 = v359.AbsoluteSize

			if p43 > AbsolutePosition2.X and (p43 <= AbsolutePosition2.X + AbsoluteSize2.X and (p44 > AbsolutePosition2.Y and p44 <= AbsolutePosition2.Y + AbsoluteSize2.Y)) then
				local t11 = {
					1e999,
					nil
				}

				for i = 1, u79 do
					local v364 = t3[i]
					local Frame = v364.Frame
					local vector2 = Vector2.new(p43, p44)
					local magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - vector2).magnitude

					if magnitude < t11[1] then
						t11 = {
							magnitude,
							v364
						}
					end
				end

				local v368 = t11[2]

				if v368 ~= t10 then
					t10:Swap(v368)

					if t10.Index > u79 then
						local Tool = t10.Tool

						if not Tool then
							t10:Delete()
						else
							if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u60) and u61 then
								u61:UnequipTools()

								if u69 then
									u69:ToggleSelect()
									t4[u69]:UpdateEquipView()
									u69 = nil
								end
							end

							if u73 then
								t10.Frame.Visible = false
								t10.Frame.Parent = u53
							end
						end
					end
				end
			elseif t10.Index <= u79 then
				t10:MoveToInventory()
			end
		end

		n6 = timestamp
	end)
	u157.Parent = p14
	t3[v155] = t10

	if v155 > u79 then
		UpdateScrollingFrameCanvasSize()

		if u55 and u53.Visible and not u73 then
			local v172 = u55.CanvasSize.Y.Offset - u55.AbsoluteSize.Y

			u55.CanvasPosition = Vector2.new(0, (math.max(0, v172)))
		end
	end

	return t10
end
local function SetNumberOfHotbarSlots(p45) -- line: 880
	-- upvalues: u79 (ref), t3 (copy), MakeSlot (copy), u50 (ref), u64 (ref), n2 (ref), UpdateBackpackLayout (copy)
	if p45 ~= u79 then
		local v174 = u79

		if p45 < v174 then
			for i = v174, p45 + 1, -1 do
				local v176 = t3[i]

				if v176 then
					v176:MoveToInventory()
					v176:Delete()
				end
			end

			for i = v174, p45 + 1, -1 do
				local v178 = t3[i]

				if not v178.Tool then
					v178:Delete()
				end
			end
		else
			for i = v174, p45 do
				u79 = i

				if t3[i] then
					local _ = t3[i]
					local Tool = t3[i].Tool
					local v182 = MakeSlot(u50, i)

					if Tool then
						v182:Fill(Tool)
					elseif not u64 then
						u64 = v182
					end
				else
					local v183 = MakeSlot(u50, i)

					v183.Frame.Visible = false

					if not u64 then
						u64 = v183
					end
				end
			end
		end

		u79 = p45
		n2 = 0

		for i = 1, u79 do
			if t3[i] and t3[i].Tool then
				n2 += 1
			end
		end

		UpdateBackpackLayout()
	end
end
local function OnChildAdded(p46) -- line: 942
	-- upvalues: u49 (ref), u60 (ref), u61 (ref), n3 (ref), u69 (ref), t4 (copy), u70 (ref), LocalPlayer (ref), u64 (ref), MakeSlot (copy), u56 (ref), t3 (copy), Backpack (ref), AdjustHotbarFrames (copy), u79 (ref), u53 (ref), t1 (copy)
	if not u49 then
		return
	end

	if not p46:IsA("Tool") and not p46:IsA("HopperBin") then
		if p46:IsA("Humanoid") and p46.Parent == u60 then
			u61 = p46
		end

		return
	end

	if p46.Parent == u60 then
		n3 = tick()
	end

	if u69 and p46.Parent == u60 then
		u69:ToggleSelect()
		t4[u69]:UpdateEquipView()
		u69 = nil
	end

	if not u70 and p46.Parent == u60 and not t4[p46] then
		local StarterGear = LocalPlayer:FindFirstChild("StarterGear")

		if StarterGear and StarterGear:FindFirstChild(p46.Name) then
			u70 = true

			for i = (u64 or MakeSlot(u56)).Index, 1, -1 do
				local v188 = t3[i]
				local v189 = i - 1

				if v189 > 0 then
					t3[v189]:Swap(v188)
				else
					v188:Fill(p46)
				end
			end

			for _, child in pairs(u60:GetChildren()) do
				if child:IsA("Tool") and child ~= p46 then
					child.Parent = Backpack
				end
			end

			AdjustHotbarFrames()

			return
		end
	end

	local v192 = t4[p46]

	if v192 then
		v192:UpdateEquipView()
	else
		local v193 = u64 or MakeSlot(u56)

		v193:Fill(p46)

		if v193.Index <= u79 and not u53.Visible then
			AdjustHotbarFrames()
		end

		if p46:IsA("HopperBin") and p46.Active then
			if u61 then
				u61:UnequipTools()

				if u69 then
					u69:ToggleSelect()
					t4[u69]:UpdateEquipView()
					u69 = nil
				end
			end

			u69 = p46
		end
	end

	t1.BackpackItemAdded:Fire()
end
local function OnChildRemoved(p47) -- line: 1012
	-- upvalues: u49 (ref), n3 (ref), u60 (ref), Backpack (ref), t4 (copy), u79 (ref), u53 (ref), AdjustHotbarFrames (copy), u69 (ref), t1 (copy), t3 (copy)
	if not u49 then
		return
	end

	if not p47:IsA("Tool") and not p47:IsA("HopperBin") then
		return
	end

	n3 = tick()

	local p47Parent = p47.Parent

	if p47Parent == u60 or p47Parent == Backpack then
		return
	end

	local v196 = t4[p47]
	local g200 = nil
	local v199 = nil

	if v196 then
		v196:Clear()

		if v196.Index > u79 then
			v196:Delete()
		elseif not u53.Visible then
			AdjustHotbarFrames()
		end
	end

	if p47 == u69 then
		u69 = nil
	end

	t1.BackpackItemRemoved:Fire()

	for i = u79 + 1, #t3 do
		local v198 = t3[i]

		if v198 and v198.Tool then
			v199 = false
			g200 = true
		end

		if g200 then
			break
		end
	end

	if not g200 then
		v199 = true
	end

	g200 = false

	if v199 then
		t1.BackpackEmpty:Fire()
	end
end
local function OnCharacterAdded(p48) -- line: 1049
	-- upvalues: t3 (copy), u79 (ref), u69 (ref), t8 (ref), u60 (ref), OnChildRemoved (copy), OnChildAdded (copy), Backpack (ref), LocalPlayer (ref), AdjustHotbarFrames (copy)
	for i = #t3, 1, -1 do
		local v203 = t3[i]

		if v203.Tool then
			v203:Clear()
		end

		if i > u79 then
			v203:Delete()
		end
	end

	u69 = nil

	for _, v in pairs(t8) do
		v:disconnect()
	end

	t8 = {}
	u60 = p48
	table.insert(t8, p48.ChildRemoved:connect(OnChildRemoved))
	table.insert(t8, p48.ChildAdded:connect(OnChildAdded))

	for _, child in pairs(p48:GetChildren()) do
		OnChildAdded(child)
	end

	Backpack = LocalPlayer:WaitForChild("Backpack")
	table.insert(t8, Backpack.ChildRemoved:connect(OnChildRemoved))
	table.insert(t8, Backpack.ChildAdded:connect(OnChildAdded))

	for _, child in pairs(Backpack:GetChildren()) do
		OnChildAdded(child)
	end

	AdjustHotbarFrames()
end
local function OnInputBegan(p49, p50) -- line: 1088
	-- upvalues: u72 (ref), u71 (ref), BackspaceValue (copy), t5 (copy), u53 (ref), t1 (copy)
	if p49.UserInputType == Enum.UserInputType.Keyboard and not u72 and (u71 or p49.KeyCode.Value == BackspaceValue) then
		local v212 = t5[p49.KeyCode.Value]

		if v212 then
			v212(p50)
		end
	end

	local UserInputType = p49.UserInputType

	if not p50 and ((UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and u53 and u53.Visible) then
		t1.OpenClose()
	end
end
local function OnUISChanged(p51) -- line: 1111
	-- upvalues: UserInputService (copy), VRService (copy), u79 (ref), t3 (copy)
	if p51 == "KeyboardEnabled" or p51 == "VREnabled" then
		local v215 = UserInputService.KeyboardEnabled and not VRService.VREnabled

		for i = 1, u79 do
			t3[i]:TurnNumber(v215)
		end
	end
end

local u105 = nil
local timestamp = nil

local function v107() -- line: 1123
end

local vector2 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions() -- line: 1127
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
	ContextActionService:UnbindAction("RBXCloseInventory")
end

local function setHotbarVisibility(p52, p53) -- line: 1132
	-- upvalues: u79 (ref), t3 (copy)
	for i = 1, u79 do
		local v220 = t3[i]

		if v220 and v220.Frame and (p53 or v220.Tool) then
			v220.Frame.Visible = p52
		end
	end
end
local function getInputDirection(p54) -- line: 1141
	-- upvalues: vector2 (ref)
	local n7 = 1

	if p54.UserInputState == Enum.UserInputState.End then
		n7 = -1
	end

	if p54.KeyCode == Enum.KeyCode.Thumbstick1 then
		local magnitude = p54.Position.magnitude

		if magnitude > 0.98 then
			vector2 = Vector2.new(p54.Position.x / magnitude, -p54.Position.y / magnitude)
		else
			vector2 = Vector2.new(0, 0)
		end
	elseif p54.KeyCode == Enum.KeyCode.DPadLeft then
		vector2 = Vector2.new(vector2.x - n7 * 1, vector2.y)
	elseif p54.KeyCode == Enum.KeyCode.DPadRight then
		vector2 = Vector2.new(vector2.x + n7 * 1, vector2.y)
	elseif p54.KeyCode == Enum.KeyCode.DPadUp then
		vector2 = Vector2.new(vector2.x, vector2.y - n7 * 1)
	elseif p54.KeyCode == Enum.KeyCode.DPadDown then
		vector2 = Vector2.new(vector2.x, vector2.y + n7 * 1)
	else
		vector2 = Vector2.new(0, 0)
	end

	return vector2
end

function u82(_, p56, p57) -- line: 1202
	-- upvalues: u105 (ref), timestamp (ref), u61 (ref), u69 (ref), t4 (copy), u79 (ref), t3 (copy), u81 (ref)
	if p56 ~= Enum.UserInputState.Begin then
		return
	end

	if u105 and ((u105.KeyCode == Enum.KeyCode.ButtonR1 and p57.KeyCode == Enum.KeyCode.ButtonL1 or u105.KeyCode == Enum.KeyCode.ButtonL1 and p57.KeyCode == Enum.KeyCode.ButtonR1) and tick() - timestamp <= 0.06) then
		if u61 then
			u61:UnequipTools()

			if u69 then
				u69:ToggleSelect()
				t4[u69]:UpdateEquipView()
				u69 = nil
			end
		end

		u105 = p57
		timestamp = tick()

		return
	end

	u105 = p57
	timestamp = tick()
	delay(0.06, function() -- line: 1230
		-- upvalues: u105 (ref), p57 (copy), u79 (ref), t3 (copy), u61 (ref), u69 (ref), t4 (copy), u81 (ref)
		if u105 ~= p57 then
			return
		end

		local v370 = p57.KeyCode ~= Enum.KeyCode.ButtonL1 and 1 or -1

		for i = 1, u79 do
			local v372 = t3[i]

			if not v372 then
				return
			end

			if v372:IsEquipped() then
				local v373 = v370 + i
				local v374 = false

				if v373 > u79 then
					v373 = 1
					v374 = true
				elseif v373 < 1 then
					v373 = u79
					v374 = true
				end

				local v375 = v373

				while not t3[v375].Tool do
					v375 += v370

					if v375 == v373 then
						return
					end

					if v375 > u79 then
						v375 = 1
						v374 = true
					elseif v375 < 1 then
						v375 = u79
						v374 = true
					end
				end

				if v374 then
					if u61 then
						u61:UnequipTools()

						if u69 then
							u69:ToggleSelect()
							t4[u69]:UpdateEquipView()
							u69 = nil
						end
					end

					u81 = nil

					return
				end

				t3[v375]:Select()

				return
			end
		end

		if u81 and u81.Tool then
			u81:Select()

			return
		end

		for i = v370 == -1 and u79 or 1, if v370 ~= -1 then u79 else 1, v370 do
			if t3[i].Tool then
				t3[i]:Select()

				return
			end
		end
	end)
end
function getGamepadSwapSlot() -- line: 1300
	-- upvalues: t3 (copy)
	for i = 1, #t3 do
		if t3[i].Frame.BorderSizePixel > 0 then
			return t3[i]
		end
	end
end
function changeSlot(p58) -- line: 1308
	-- upvalues: GamepadService (copy), GuiService (copy), u54 (ref), u79 (ref)
	local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if p58.Frame == GuiService.SelectedCoreObject and not GamepadCursorEnabled then
		local v237 = getGamepadSwapSlot()

		if v237 then
			v237.Frame.BorderSizePixel = 0

			if v237 ~= p58 then
				p58:Swap(v237)

				if u54 and u54.SelectionImageObject then
					u54.SelectionImageObject.Visible = false
				end

				if p58.Index > u79 and not p58.Tool then
					if GuiService.SelectedCoreObject == p58.Frame then
						GuiService.SelectedCoreObject = v237.Frame
					end

					p58:Delete()
				end

				if v237.Index > u79 and not v237.Tool then
					if GuiService.SelectedCoreObject == v237.Frame then
						GuiService.SelectedCoreObject = p58.Frame
					end

					v237:Delete()

					return
				end
			end
		else
			local FrameSize = p58.Frame.Size
			local FramePosition = p58.Frame.Position

			p58.Frame:TweenSizeAndPositionInternal(FrameSize + UDim2.new(0, 10, 0, 10), FramePosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 1346
				-- upvalues: p58 (copy), FrameSize (copy), FramePosition (copy)
				p58.Frame:TweenSizeAndPositionInternal(FrameSize, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
			end)
			p58.Frame.BorderSizePixel = 3

			if u54 and u54.SelectionImageObject then
				u54.SelectionImageObject.Visible = true

				return
			end
		end
	else
		p58:Select()

		if u54 and u54.SelectionImageObject then
			u54.SelectionImageObject.Visible = false
		end
	end
end
function enableGamepadInventoryControl() -- line: 1370
	-- upvalues: u53 (ref), t1 (copy), ContextActionService (copy), v107 (copy), u50 (ref), GuiService (copy)
	ContextActionService:BindAction("RBXBackpackHasGamepadFocus", v107, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("RBXCloseInventory", function(_, inputState, _) -- line: 1371
		-- upvalues: u53 (ref), t1 (copy)
		if inputState ~= Enum.UserInputState.Begin then
			return
		end

		if getGamepadSwapSlot() then
			local v380 = getGamepadSwapSlot()

			if v380 then
				v380.Frame.BorderSizePixel = 0

				return
			end
		elseif u53 and u53.Visible then
			t1.OpenClose()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

	if not false and u50 then
		GuiService.SelectedCoreObject = u50:FindFirstChild("1")
	end
end
function disableGamepadInventoryControl() -- line: 1403
	-- upvalues: u79 (ref), t3 (copy), u49 (ref), GuiService (copy)
	unbindAllGamepadEquipActions()

	for i = 1, u79 do
		local v241 = t3[i]

		if v241 and v241.Frame then
			v241.Frame.BorderSizePixel = 0
		end
	end

	if u49 and GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(u49) then
		GuiService.SelectedCoreObject = nil
	end
end

local function bindBackpackHotbarAction() -- line: 1418
	-- upvalues: u71 (ref), u46 (ref), ContextActionService (copy), u82 (ref)
	if u71 and not u46 then
		u46 = true
		ContextActionService:BindAction("RBXHotbarEquip", u82, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
	end
end
local function unbindBackpackHotbarAction() -- line: 1431
	-- upvalues: u46 (ref), ContextActionService (copy)
	disableGamepadInventoryControl()
	u46 = false
	ContextActionService:UnbindAction("RBXHotbarEquip")
end

function gamepadDisconnected() -- line: 1437
	-- upvalues: VRService (copy), u77 (ref)
	if not VRService.VREnabled then
		u77 = false
		disableGamepadInventoryControl()
	end
end
function gamepadConnected() -- line: 1444
	-- upvalues: VRService (copy), u77 (ref), u49 (ref), GuiService (copy), n2 (ref), u71 (ref), u46 (ref), ContextActionService (copy), u82 (ref), u53 (ref)
	if not VRService.VREnabled then
		u77 = true

		if u49 then
			GuiService:AddSelectionParent("RBXBackpackSelection", u49)
		end

		if n2 >= 1 and u71 and not u46 then
			u46 = true
			ContextActionService:BindAction("RBXHotbarEquip", u82, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end

		if u53 and u53.Visible then
			enableGamepadInventoryControl()
		end
	end
end

local function setBackpackEnabled(p61) -- line: 1461
	-- upvalues: u45 (ref), u71 (ref), u49 (ref), FFlagMountCoreGuiBackpack (copy), RobloxGui (copy), t7 (copy), GuiService (copy), n2 (ref), u46 (ref), ContextActionService (copy), u82 (ref)
	local v243 = p61 and u45

	u71 = v243

	if u49 then
		if FFlagMountCoreGuiBackpack then
			if v243 then
				u49.Parent = RobloxGui
			else
				u49.Parent = nil
			end
		else
			u49.Visible = v243
		end
	end

	for _, v in pairs(t7) do
		if v243 then
			GuiService:AddKey(v)
		else
			GuiService:RemoveKey(v)
		end
	end

	if v243 then
		if n2 >= 1 and u71 and not u46 then
			u46 = true
			ContextActionService:BindAction("RBXHotbarEquip", u82, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)

			return
		end
	else
		disableGamepadInventoryControl()
		u46 = false
		ContextActionService:UnbindAction("RBXHotbarEquip")
	end
end
local function MakeVRRoundButton(p62, p63) -- line: 1494
	-- upvalues: NewGui (copy)
	local v248 = NewGui("ImageButton", p62)

	v248.Size = UDim2.new(0, 40, 0, 40)
	v248.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local v249 = NewGui("ImageLabel", "Icon")

	v249.Size = UDim2.new(0.5, 0, 0.5, 0)
	v249.Position = UDim2.new(0.25, 0, 0.25, 0)
	v249.Image = p63
	v249.Parent = v248

	local v250 = NewGui("ImageLabel", "Selection")

	v250.Size = UDim2.new(0.9, 0, 0.9, 0)
	v250.Position = UDim2.new(0.05, 0, 0.05, 0)
	v250.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	v248.SelectionImageObject = v250

	return v248, v249, v250
end

function t1.createGui() -- line: 1514
	-- upvalues: u49 (ref), NewGui (copy), FFlagMountCoreGuiBackpack (copy), StarterGui (copy), RobloxGui (copy), u50 (ref), u79 (ref), MakeSlot (copy), u64 (ref), u51 (ref), t1 (copy), color3_5 (copy), u52 (ref), MakeVRRoundButton (copy), u53 (ref), u21 (ref), color3 (copy), u54 (ref), u55 (ref), u56 (ref), UIGridLayout (ref), n1 (ref), u58 (ref), u59 (ref), UpdateBackpackLayout (copy), Create (copy), v42 (copy), color3_6 (copy), u31 (ref), s1 (ref), color3_3 (copy), t3 (copy), u73 (ref), UpdateScrollingFrameCanvasSize (copy), t9 (copy), t5 (copy), VRService (copy), UserInputService (copy), GuiService (copy), t6 (copy), AdjustHotbarFrames (copy), u77 (ref), t2 (copy), ContextActionService (copy), BackquoteValue (copy), LocalPlayer (ref), Players (copy), OnCharacterAdded (copy), t7 (copy), OnInputBegan (copy), u72 (ref), BackspaceValue (copy), u69 (ref), u61 (ref), t4 (copy), OnUISChanged (copy), v17 (copy), SettingsShowSignal (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), InExperienceAppChatModal (copy), UserGameSettings (copy), u25 (ref)
	u49 = NewGui("Frame", "Backpack")

	if FFlagMountCoreGuiBackpack then
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
			u49.Parent = RobloxGui
		end
	else
		u49.Visible = false
		u49.Parent = RobloxGui
	end

	u50 = NewGui("Frame", "Hotbar")
	u50.Parent = u49

	for i = 1, u79 do
		local v252 = MakeSlot(u50, i)

		v252.Frame.Visible = false

		if not u64 then
			u64 = v252
		end
	end

	u51 = NewGui("ImageButton", "OpenInventory")
	u51.Size = UDim2.new(0, 30, 0, 30)
	u51.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
	u51.MouseButton1Click:connect(function() -- line: 1545
		-- upvalues: t1 (copy)
		t1.OpenClose()
	end)
	u51.SelectionGained:connect(function() -- line: 1548
		-- upvalues: u51 (ref), color3_5 (copy)
		u51.ImageColor3 = color3_5
	end)
	u51.SelectionLost:connect(function() -- line: 1551
		-- upvalues: u51 (ref)
		u51.ImageColor3 = Color3.new(1, 1, 1)
	end)

	local v253 = NewGui("Frame", "Selection")

	v253.Visible = false
	u51.SelectionImageObject = v253
	u52 = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
	u52.Position = UDim2.new(0, 0, 0, -50)
	u52.MouseButton1Click:connect(function() -- line: 1561
		-- upvalues: u53 (ref), t1 (copy)
		if u53.Visible then
			t1.OpenClose()
		end
	end)

	local v254 = NewGui("ImageLabel", "LeftBumper")

	v254.Size = UDim2.new(0, 40, 0, 40)
	v254.Position = UDim2.new(0, -v254.Size.X.Offset, 0.5, -v254.Size.Y.Offset / 2)

	local v255 = NewGui("ImageLabel", "RightBumper")

	v255.Size = UDim2.new(0, 40, 0, 40)
	v255.Position = UDim2.new(1, 0, 0.5, -v255.Size.Y.Offset / 2)
	u53 = NewGui("Frame", "Inventory")
	u53.BackgroundTransparency = u21
	u53.BackgroundColor3 = color3
	u53.Active = true
	u53.Visible = false
	u53.Parent = u49
	u54 = NewGui("TextButton", "VRInventorySelector")
	u54.Position = UDim2.new(0, 0, 0, 0)
	u54.Size = UDim2.new(1, 0, 1, 0)
	u54.BackgroundTransparency = 1
	u54.Text = ""
	u54.Parent = u53

	local v256 = NewGui("ImageLabel", "Selector")

	v256.Size = UDim2.new(1, 0, 1, 0)
	v256.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	v256.ScaleType = Enum.ScaleType.Slice
	v256.SliceCenter = Rect.new(12, 12, 52, 52)
	v256.Visible = false
	u54.SelectionImageObject = v256
	u55 = NewGui("ScrollingFrame", "ScrollingFrame")
	u55.Selectable = false
	u55.CanvasSize = UDim2.new(0, 0, 0, 0)
	u55.Parent = u53
	u56 = NewGui("Frame", "UIGridFrame")
	u56.Selectable = false
	u56.Size = UDim2.new(1, -10, 1, 0)
	u56.Position = UDim2.new(0, 5, 0, 0)
	u56.Parent = u55
	UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellSize = UDim2.new(0, n1, 0, n1)
	UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	UIGridLayout.Parent = u56
	u58 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	u58.Size = UDim2.new(0, 34, 0, 34)
	u58.Position = UDim2.new(0.5, -u58.Size.X.Offset / 2, 0, 43)
	u58.Icon.Position = u58.Icon.Position - UDim2.new(0, 0, 0, 2)
	u58.MouseButton1Click:connect(function() -- line: 1621
		-- upvalues: u55 (ref), n1 (ref)
		if not u55 then
			return
		end

		u55.CanvasPosition = Vector2.new(u55.CanvasPosition.X, (math.min(u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y, (math.max(0, u55.CanvasPosition.Y - (n1 + 5))))))
	end)
	u59 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	u59.Rotation = 180
	u59.Icon.Position = u59.Icon.Position - UDim2.new(0, 0, 0, 2)
	u59.Size = UDim2.new(0, 34, 0, 34)
	u59.Position = UDim2.new(0.5, -u59.Size.X.Offset / 2, 1, -u59.Size.Y.Offset - 3)
	u59.MouseButton1Click:connect(function() -- line: 1642
		-- upvalues: u55 (ref), n1 (ref)
		if not u55 then
			return
		end

		u55.CanvasPosition = Vector2.new(u55.CanvasPosition.X, (math.min(u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y, (math.max(0, u55.CanvasPosition.Y + (n1 + 5))))))
	end)
	u55.Changed:connect(function(p64) -- line: 1656
		-- upvalues: u55 (ref), u58 (ref), u59 (ref)
		if not u55 then
			return
		end

		if p64 == "AbsoluteWindowSize" or p64 == "CanvasPosition" or p64 == "CanvasSize" then
			local v382 = u55.CanvasPosition.Y ~= 0
			local v383 = u55.CanvasPosition.Y < u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y

			u58.Visible = v382
			u59.Visible = v383
		end
	end)
	UpdateBackpackLayout()

	local v257 = Create("Frame")({
		Name = "GamepadHintsFrame",
		BackgroundTransparency = 1,
		Visible = false,
		Size = UDim2.new(0, u50.Size.X.Offset, 0, not v42 and 60 or 95),
		Parent = u49
	})

	local function addGamepadHint(p65, p66, p67) -- line: 1682
		-- upvalues: Create (copy), v257 (copy), v42 (copy)
		local v387 = Create("Frame")({
			Name = "HintFrame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -5),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = v257
		})

		Create("ImageLabel")({
			Name = "HintImage",
			BackgroundTransparency = 1,
			Size = v42 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60),
			Image = v42 and p66 or p65,
			Parent = v387
		})

		local v388 = Create("TextLabel")({
			Name = "HintText",
			BackgroundTransparency = 1,
			TextWrapped = true,
			Position = UDim2.new(0, not v42 and 70 or 100, 0, 0),
			Size = UDim2.new(1, -(not v42 and 70 or 100), 1, 0),
			Font = Enum.Font.SourceSansBold,
			FontSize = v42 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
			Text = p67,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = v387
		})
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

		UITextSizeConstraint.Parent = v388
		UITextSizeConstraint.MaxTextSize = v388.TextSize
	end
	local function resizeGamepadHintsFrame() -- line: 1717
		-- upvalues: u50 (ref), u53 (ref), v257 (copy), v42 (copy)
		if not u50 or not u53 then
			return
		end

		v257.Size = UDim2.new(u50.Size.X.Scale, u50.Size.X.Offset, 0, not v42 and 60 or 95)
		v257.Position = UDim2.new(u50.Position.X.Scale, u50.Position.X.Offset, u53.Position.Y.Scale, u53.Position.Y.Offset - v257.Size.Y.Offset)

		local n8 = 0
		local children = v257:GetChildren()

		for i = 1, #children do
			children[i].Size = UDim2.new(1, 0, 1, -5)
			children[i].Position = UDim2.new(0, 0, 0, 0)
			n8 += children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X
		end

		local v393 = (v257.AbsoluteSize.X - n8) / (#children - 1)

		for i = 1, #children do
			children[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, children[i - 1].Position.X.Offset + children[i - 1].Size.X.Offset + v393, 0, 0)
			children[i].Size = UDim2.new(0, children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X, 1, -5)
		end
	end

	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonX@2x.png", "Remove From Hotbar")
	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonA@2x.png", "Select/Swap")
	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png", "Close Backpack")

	local v260 = NewGui("Frame", "Search")

	v260.BackgroundColor3 = color3_6
	v260.BackgroundTransparency = u31
	v260.Size = UDim2.new(0, 190, 0, 30)
	v260.Position = UDim2.new(1, -v260.Size.X.Offset - 5, 0, 5)
	v260.Parent = u53

	local v261 = NewGui("TextBox", "TextBox")

	v261.Text = s1
	v261.ClearTextOnFocus = false
	v261.FontSize = Enum.FontSize.Size24
	v261.TextXAlignment = Enum.TextXAlignment.Left
	v261.Size = v260.Size - UDim2.new(0, 0, 0, 0)
	v261.Position = UDim2.new(0, 0, 0, 0)
	v261.Parent = v260

	local v262 = NewGui("TextButton", "X")

	v262.Text = "x"
	v262.TextColor3 = color3_3
	v262.FontSize = Enum.FontSize.Size24
	v262.TextYAlignment = Enum.TextYAlignment.Bottom
	v262.BackgroundColor3 = color3_6
	v262.BackgroundTransparency = 0
	v262.Size = UDim2.new(0, v260.Size.Y.Offset - 10, 0, v260.Size.Y.Offset - 10)
	v262.Position = UDim2.new(1, -v262.Size.X.Offset - 10, 0.5, -v262.Size.Y.Offset / 2)
	v262.ZIndex = 0
	v262.Visible = false
	v262.BorderSizePixel = 0
	v262.Parent = v260

	local function search() -- line: 1815
		-- upvalues: v261 (copy), u79 (ref), t3 (copy), u53 (ref), u73 (ref), u56 (ref), u55 (ref), UpdateScrollingFrameCanvasSize (copy), v262 (copy)
		local t12 = {}

		for match in v261.Text:gmatch("%S+") do
			t12[match:lower()] = true
		end

		local t13 = {}

		for i = u79 + 1, #t3 do
			local v399 = t3[i]

			table.insert(t13, {
				v399,
				(v399:CheckTerms(t12))
			})
			v399.Frame.Visible = false
			v399.Frame.Parent = u53
		end

		table.sort(t13, function(p68, p69) -- line: 1830
			return p68[2] > p69[2]
		end)
		u73 = true

		local n9 = 0

		for _, v in ipairs(t13) do
			local v403 = v[1]

			if v[2] > 0 then
				v403.Frame.Visible = true
				v403.Frame.Parent = u56
				v403.Frame.LayoutOrder = u79 + n9
				n9 += 1
			end
		end

		if u55 then
			u55.CanvasPosition = Vector2.new(0, 0)
		end

		UpdateScrollingFrameCanvasSize()
		v262.ZIndex = 3
	end
	local function clearResults() -- line: 1854
		-- upvalues: v262 (copy), u73 (ref), u79 (ref), t3 (copy), u56 (ref), UpdateScrollingFrameCanvasSize (copy)
		if v262.ZIndex > 0 then
			u73 = false

			for i = u79 + 1, #t3 do
				local v405 = t3[i]

				v405.Frame.LayoutOrder = v405.Index
				v405.Frame.Parent = u56
				v405.Frame.Visible = true
			end

			v262.ZIndex = 0
		end

		UpdateScrollingFrameCanvasSize()
	end
	local function reset() -- line: 1868
		-- upvalues: clearResults (copy), v261 (copy), s1 (ref)
		clearResults()
		v261.Text = s1
	end
	local function onChanged(p70) -- line: 1873
		-- upvalues: v261 (copy), clearResults (copy), s1 (ref), search (copy), v262 (copy)
		if p70 == "Text" then
			local Text = v261.Text

			if Text == "" then
				clearResults()
			elseif Text ~= s1 then
				search()
			end

			v262.Visible = Text ~= "" and Text ~= s1
		end
	end
	local function onFocused() -- line: 1885
		-- upvalues: v261 (copy), s1 (ref)
		if v261.Text == s1 then
			v261.Text = ""
		end
	end
	local function focusLost(p71) -- line: 1891
		-- upvalues: search (copy), v261 (copy), s1 (ref)
		if p71 then
			search()

			return
		end

		if v261.Text == "" then
			v261.Text = s1
		end
	end

	v261.Focused:connect(onFocused)
	v262.MouseButton1Click:connect(reset)
	v261.Changed:connect(onChanged)
	v261.FocusLost:connect(focusLost)
	table.insert(t9, t1.StateChanged.Event:connect(function(p72) -- line: 1907
		-- upvalues: v262 (copy), clearResults (copy), v261 (copy), s1 (ref)
		v262.Modal = p72

		if not p72 then
			clearResults()
			v261.Text = s1
		end
	end))
	t5[Enum.KeyCode.Escape.Value] = function(p73) -- line: 1915
		-- upvalues: clearResults (copy), v261 (copy), s1 (ref), u53 (ref), t1 (copy)
		if p73 then
			clearResults()
			v261.Text = s1

			return
		end

		if u53 and u53.Visible then
			t1.OpenClose()
		end
	end

	local function detectGamepad(p74) -- line: 1923
		-- upvalues: VRService (copy), v260 (copy)
		if p74 == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
			v260.Visible = false

			return
		end

		v260.Visible = true
	end

	table.insert(t9, UserInputService.LastInputTypeChanged:connect(detectGamepad))

	local function v270(_, p76, _) -- line: 1934
		-- upvalues: GuiService (copy), u79 (ref), t3 (copy)
		if p76 ~= Enum.UserInputState.Begin then
			return
		end

		if not GuiService.SelectedCoreObject then
			return
		end

		for i = 1, u79 do
			if t3[i].Frame == GuiService.SelectedCoreObject and t3[i].Tool then
				t3[i]:MoveToInventory()

				return
			end
		end
	end
	local function openClose() -- line: 1950
		-- upvalues: u53 (ref), t6 (copy), AdjustHotbarFrames (copy), u50 (ref), u79 (ref), t3 (copy), u77 (ref), t2 (copy), UserInputService (copy), resizeGamepadHintsFrame (copy), v257 (copy), ContextActionService (copy), v270 (copy), t1 (copy)
		if not u53 then
			return
		end

		if not next(t6) then
			u53.Visible = not u53.Visible

			local Visible = u53.Visible

			AdjustHotbarFrames()
			u50.Active = not u50.Active

			for i = 1, u79 do
				t3[i]:SetClickability(not Visible)
			end
		end

		if u53.Visible then
			if u77 then
				if t2[UserInputService:GetLastInputType()] then
					resizeGamepadHintsFrame()
					v257.Visible = true
				end

				enableGamepadInventoryControl()
			end
		else
			if u77 then
				v257.Visible = false
			end

			disableGamepadInventoryControl()
		end

		if u53.Visible then
			ContextActionService:BindAction("RBXRemoveSlot", v270, false, Enum.KeyCode.ButtonX)
		else
			ContextActionService:UnbindAction("RBXRemoveSlot")
		end

		t1.IsOpen = u53.Visible
		t1.StateChanged:Fire(u53.Visible)
	end

	t5[BackquoteValue] = function() -- line: 1989
		-- upvalues: GuiService (copy), openClose (copy)
		if GuiService.MenuIsOpen then
			return
		end

		openClose()
	end
	t1.OpenClose = openClose

	while not LocalPlayer do
		wait()
		LocalPlayer = Players.LocalPlayer
	end

	table.insert(t9, LocalPlayer.CharacterAdded:connect(OnCharacterAdded))

	if LocalPlayer.Character then
		OnCharacterAdded(LocalPlayer.Character)
	end

	for i = 0, 9 do
		table.insert(t7, (tostring(i)))
	end

	table.insert(t7, "`")
	table.insert(t9, UserInputService.InputBegan:connect(OnInputBegan))
	table.insert(t9, UserInputService.TextBoxFocused:connect(function() -- line: 2026
		-- upvalues: u72 (ref)
		u72 = true
	end))
	table.insert(t9, UserInputService.TextBoxFocusReleased:connect(function() -- line: 2032
		-- upvalues: u72 (ref)
		u72 = false
	end))
	t5[BackspaceValue] = function() -- line: 2038
		-- upvalues: u69 (ref), u61 (ref), t4 (copy)
		if u69 and u61 then
			u61:UnequipTools()

			if u69 then
				u69:ToggleSelect()
				t4[u69]:UpdateEquipView()
				u69 = nil
			end
		end
	end
	table.insert(t9, UserInputService.Changed:connect(OnUISChanged))

	local v273 = UserInputService.KeyboardEnabled and not VRService.VREnabled

	for i = 1, u79 do
		t3[i]:TurnNumber(v273)
	end

	if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
		gamepadConnected()
	end

	table.insert(t9, UserInputService.GamepadConnected:connect(function(p78) -- line: 2054
		if p78 == Enum.UserInputType.Gamepad1 then
			gamepadConnected()
		end
	end))
	table.insert(t9, UserInputService.GamepadDisconnected:connect(function(p79) -- line: 2062
		if p79 == Enum.UserInputType.Gamepad1 then
			gamepadDisconnected()
		end
	end))

	if v17 then
		table.insert(t9, SettingsShowSignal:connect(function(p80) -- line: 2073
			-- upvalues: t1 (copy), AdjustHotbarFrames (copy)
			if p80 then
				if t1.IsHotbarVisible then
					AdjustHotbarFrames(true)

					return
				end
			else
				AdjustHotbarFrames(false)
			end
		end))
	end

	table.insert(t9, GuiService.MenuOpened:Connect(function() -- line: 2087
		-- upvalues: t1 (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), VRService (copy)
		if t1.IsOpen and (not isInExperienceUIVREnabled or (InExperienceUIVRIXP:isMovePanelToCenter() and true or not VRService.VREnabled)) then
			t1.OpenClose()
		end
	end))
	table.insert(t9, InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p81) -- line: 2103
		-- upvalues: t1 (copy)
		if p81 and t1.IsOpen then
			t1.OpenClose()
		end
	end))

	local function OnPreferredTransparencyChanged() -- line: 2110
		-- upvalues: UserGameSettings (copy), u21 (ref), u53 (ref), u25 (ref), t3 (copy), u31 (ref), v260 (copy)
		local PreferredTransparency = UserGameSettings.PreferredTransparency

		u21 = 0.5 * UserGameSettings.PreferredTransparency

		if u53 then
			u53.BackgroundTransparency = u21
		end

		u25 = 0.5 * PreferredTransparency

		for _, v in ipairs(t3) do
			v.Frame.BackgroundTransparency = u25
		end

		u31 = 0.15 * UserGameSettings.PreferredTransparency
		v260.BackgroundTransparency = u31
	end

	table.insert(t9, UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged))
end
function t1.destroyGui() -- line: 2132
	-- upvalues: t9 (copy), t8 (ref), ContextActionService (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u55 (ref), u56 (ref), UIGridLayout (ref), u58 (ref), u59 (ref), u60 (ref), u61 (ref), Backpack (ref), u64 (ref), n2 (ref), u69 (ref), u70 (ref), u71 (ref), u72 (ref), u73 (ref), u77 (ref), u46 (ref), n3 (ref), u81 (ref), t1 (copy)
	for _, v in pairs(t9) do
		v:disconnect()
	end

	table.clear(t9)

	for _, v in pairs(t8) do
		v:disconnect()
	end

	table.clear(t8)
	ContextActionService:UnbindAction("RBXHotbarEquip")
	ContextActionService:UnbindAction("RBXRemoveSlot")
	unbindAllGamepadEquipActions()

	for i = #t3, 1, -1 do
		local v281 = t3[i]

		if v281.Tool then
			v281:Clear()
		end
	end

	table.clear(t3)
	table.clear(t4)
	table.clear(t5)
	table.clear(t6)
	table.clear(t7)

	if u49 then
		u49:Destroy()
		u49 = nil
	end

	u50 = nil
	u51 = nil
	u52 = nil
	u53 = nil
	u54 = nil
	u55 = nil
	u56 = nil
	UIGridLayout = nil
	u58 = nil
	u59 = nil
	u60 = nil
	u61 = nil
	Backpack = nil
	u64 = nil
	n2 = 0
	u69 = nil
	u70 = false
	u71 = false
	u72 = false
	u73 = false
	u77 = false
	u46 = false
	n3 = 0
	u81 = nil
	t1.OpenClose = nil
	t1.IsOpen = false
	t1.IsHotbarVisible = false
end
function t1.TopbarEnabledChanged(_, p83) -- line: 2194
	-- upvalues: u45 (ref), setBackpackEnabled (copy), StarterGui (copy)
	u45 = p83
	setBackpackEnabled(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end

if FFlagTopBarSignalizeSetCores then
	t1.disposeEffect = Signals.createEffect(function(p84) -- line: 2200
		-- upvalues: InExperienceTopBar (copy), t1 (copy)
		local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

		if GetTopBarStore then
			t1:TopbarEnabledChanged(GetTopBarStore(p84).getTopBarCoreGuiEnabled(p84))
		end
	end)
end

local Features = System.Features
local lifecycle = Features.registerLifecycle(Features.FeatureName.Backpack, {
	defaultVisible = false,
	coreGuiType = Enum.CoreGuiType.Backpack
}).lifecycle

lifecycle:onEnabledChanged(function(p85) -- line: 2215
	-- upvalues: t1 (copy), setBackpackEnabled (copy)
	if p85 then
		t1.createGui()
	else
		t1.destroyGui()
	end

	setBackpackEnabled(p85)
end)
lifecycle:onVisibilityChanged(function(p86) -- line: 2225
	-- upvalues: t1 (copy)
	if t1.OpenClose and p86 ~= t1.IsOpen then
		t1.OpenClose()
	end

	return t1.IsOpen
end)
t1.StateChanged.Event:connect(function(p87) -- line: 2233
	-- upvalues: lifecycle (copy)
	if lifecycle then
		lifecycle.setVisible(p87)
	end
end)

return t1
