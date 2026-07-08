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
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
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
local u22 = 0.5 * UserGameSettings.PreferredTransparency
local color3 = Color3.new(0.12156862745098039, 0.12156862745098039, 0.12156862745098039)
local color3_2 = Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)
local color3_3 = Color3.new(0.35294117647058826, 0.5568627450980392, 0.9137254901960784)
local u26 = 0.5 * UserGameSettings.PreferredTransparency
local color3_4 = Color3.new(1, 1, 1)

UDim2.new(0, 14, 0, 9)

local BackquoteValue = Enum.KeyCode.Backquote.Value
local color3_5 = Color3.new(0, 0.6352941176470588, 1)
local s1 = "   Search"
local color3_6 = Color3.new(0.37, 0.37, 0.37)
local u32 = 0.15 * UserGameSettings.PreferredTransparency
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

local v43 = require(Modules.TenFootInterface):IsEnabled()
local Create = require(Parent.AppCommonLib).Create
local GameTranslator = require(Modules.GameTranslator)

pcall(function() -- line: 124
	-- upvalues: s1 (ref), RobloxTranslator (copy)
	s1 = RobloxTranslator:FormatByKey("InGame.UnknownNamespace.BACKPACK_SEARCH")
end)

local u46 = true

if v43 then
	n1 = 100
	Size14 = Enum.FontSize.Size24
end

local u47 = false
local v48 = if not FFlagBackpackResponsiveUnits then UserInputService.TouchEnabled and GuiService:GetScreenResolution().X < 1024 else Responsive.GetInputModeStore().getPreferredInputType() == Responsive.Input.Touch and GuiService:GetScreenResolution().X < 1024
local LocalPlayer = Players.LocalPlayer
local u50 = nil
local u51 = nil
local u52 = nil
local u53 = nil
local u54 = nil
local u55 = nil
local u56 = nil
local u57 = nil
local UIGridLayout = nil
local u59 = nil
local u60 = nil
local u61 = nil
local u62 = nil
local Backpack = nil
local t3 = {}
local u65 = nil
local t4 = {}
local t5 = {}
local t6 = {}
local n2 = 0
local u70 = nil
local u71 = false
local u72 = false
local u73 = false
local u74 = false
local t7 = {}
local t8 = {}
local t9 = {}
local u78 = false
local n3 = 0
local u80 = not v48 and 10 or 3
local v81 = not v48 and 4 or 2
local u82 = nil
local u83 = nil

t1.BackpackEmpty = Create("BindableEvent")({
	Name = "BackpackEmpty"
})
t1.BackpackItemAdded = Create("BindableEvent")({
	Name = "BackpackAdded"
})
t1.BackpackItemRemoved = Create("BindableEvent")({
	Name = "BackpackRemoved"
})

local function NewGui(p1, p2) -- line: 200
	-- upvalues: Size14 (ref)
	local v120 = Instance.new(p1)

	v120.Name = p2
	v120.BackgroundColor3 = Color3.new(0, 0, 0)
	v120.BackgroundTransparency = 1
	v120.BorderColor3 = Color3.new(0, 0, 0)
	v120.BorderSizePixel = 0
	v120.Size = UDim2.new(1, 0, 1, 0)

	if p1:match("Text") then
		v120.TextColor3 = Color3.new(1, 1, 1)
		v120.Text = ""
		v120.Font = Enum.Font.SourceSans
		v120.FontSize = Size14
		v120.TextWrapped = true

		if p1 == "TextButton" then
			v120.Font = Enum.Font.SourceSansBold
			v120.BorderSizePixel = 1
		end
	end

	return v120
end
local function FindLowestEmpty() -- line: 222
	-- upvalues: u80 (ref), t3 (copy)
	for i = 1, u80 do
		local v122 = t3[i]

		if not v122.Tool then
			return v122
		end
	end

	return nil
end
local function isInventoryEmpty() -- line: 232
	-- upvalues: u80 (ref), t3 (copy)
	for i = u80 + 1, #t3 do
		local v124 = t3[i]

		if v124 and v124.Tool then
			return false
		end
	end

	return true
end

t1.IsInventoryEmpty = isInventoryEmpty

local function UseGazeSelection() -- line: 244
	return false
end
local function AdjustHotbarFrames(p3) -- line: 248
	-- upvalues: u54 (ref), u80 (ref), n2 (ref), v17 (copy), t3 (copy), u52 (ref), t1 (copy)
	if not u54 then
		return
	end

	local Visible = u54.Visible
	local v127 = Visible and u80 or n2
	local n4 = 0
	local v129 = if not v17 then v127 >= 1 else v127 >= 1 and not p3
	local g137 = nil
	local v136 = nil

	for i = 1, u80 do
		local v131 = t3[i]

		if ((if not v17 then v131.Tool else v131.Tool and not p3)) or Visible then
			n4 += 1
			v131:Readjust(n4, v127)
			v131.Frame.Visible = true
		else
			v131.Frame.Visible = false
		end
	end

	if u52 then
		local v132 = u52
		local v133 = not Visible

		if v133 then
			v133 = v129

			if not v133 then
				for i = u80 + 1, #t3 do
					local v135 = t3[i]

					if v135 and v135.Tool then
						v136 = false
						g137 = true
					end

					if g137 then
						break
					end
				end

				if not g137 then
					v136 = true
				end

				g137 = false
				v133 = not v136
			end
		end

		v132.Visible = v133
		u52.Position = UDim2.new(0.5, -15, 1, not v129 and -50 or -110)
	end

	t1.IsHotbarVisible = v129
end
local function UpdateScrollingFrameCanvasSize() -- line: 276
	-- upvalues: u56 (ref), u57 (ref), n1 (ref)
	if not u56 or not u57 then
		return
	end

	local v138 = math.floor(u56.AbsoluteSize.X / (n1 + 5))
	local v139 = math.ceil((#u57:GetChildren() - 1) / v138) * (n1 + 5) + 5

	u56.CanvasSize = UDim2.new(0, 0, 0, v139)
end
local function AdjustInventoryFrames() -- line: 286
	-- upvalues: u80 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
	for i = u80 + 1, #t3 do
		local v141 = t3[i]

		v141.Frame.LayoutOrder = v141.Index
		v141.Frame.Visible = v141.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end
local function UpdateBackpackLayout() -- line: 295
	-- upvalues: u51 (ref), u54 (ref), u80 (ref), n1 (ref), v81 (copy), u56 (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy)
	if not u51 or not u54 then
		return
	end

	u51.Size = UDim2.new(0, 5 + u80 * (n1 + 5), 0, n1 + 5 + 5)
	u51.Position = UDim2.new(0.5, -u51.Size.X.Offset / 2, 1, -u51.Size.Y.Offset)
	u54.Size = UDim2.new(0, u51.Size.X.Offset, 0, u51.Size.Y.Offset * v81 + 40)
	u54.Position = UDim2.new(0.5, -u54.Size.X.Offset / 2, 1, u51.Position.Y.Offset - u54.Size.Y.Offset)

	if u56 then
		u56.Size = UDim2.new(1, u56.ScrollBarThickness + 1, 1, -40)
		u56.Position = UDim2.new(0, 0, 0, 40)
	end

	AdjustHotbarFrames()
	AdjustInventoryFrames()
end
local function Clamp(p4, p5, p6) -- line: 327
	return (math.min(p5, (math.max(p4, p6))))
end
local function CheckBounds(p7, p8, p9) -- line: 331
	local AbsolutePosition = p7.AbsolutePosition
	local AbsoluteSize = p7.AbsoluteSize

	return p8 > AbsolutePosition.X and (p8 <= AbsolutePosition.X + AbsoluteSize.X and (p9 > AbsolutePosition.Y and p9 <= AbsolutePosition.Y + AbsoluteSize.Y))
end
local function GetOffset(p10, p11) -- line: 337
	return (p10.AbsolutePosition + p10.AbsoluteSize / 2 - p11).magnitude
end
local function DisableActiveHopper() -- line: 342
	-- upvalues: u70 (ref), t4 (copy)
	u70:ToggleSelect()
	t4[u70]:UpdateEquipView()
	u70 = nil
end
local function UnequipAllTools() -- line: 348
	-- upvalues: u62 (ref), u70 (ref), t4 (copy)
	if u62 then
		u62:UnequipTools()

		if u70 then
			u70:ToggleSelect()
			t4[u70]:UpdateEquipView()
			u70 = nil
		end
	end
end
local function EquipNewTool(p12) -- line: 357
	-- upvalues: u62 (ref), u70 (ref), t4 (copy), u61 (ref)
	if u62 then
		u62:UnequipTools()

		if u70 then
			u70:ToggleSelect()
			t4[u70]:UpdateEquipView()
			u70 = nil
		end
	end

	if p12:IsA("HopperBin") then
		p12:ToggleSelect()
		t4[p12]:UpdateEquipView()
		u70 = p12

		return
	end

	p12.Parent = u61
end
local function IsEquipped(p13) -- line: 369
	-- upvalues: u61 (ref)
	return p13 and (p13:IsA("HopperBin") and p13.Active or p13.Parent == u61)
end
local function MakeSlot(p14, p15) -- line: 373
	-- upvalues: t3 (copy), u26 (ref), color3_2 (copy), color3 (copy), u51 (ref), n1 (ref), GameTranslator (copy), u80 (ref), u54 (ref), n2 (ref), u72 (ref), u47 (ref), ContextActionService (copy), u83 (ref), t4 (copy), u65 (ref), u61 (ref), u82 (ref), NewGui (copy), color3_3 (copy), t6 (copy), UpdateScrollingFrameCanvasSize (copy), u62 (ref), u70 (ref), Backpack (ref), color3_4 (copy), MakeSlot (copy), u57 (ref), u74 (ref), t5 (copy), ZeroValue (copy), u56 (ref)
	local v156 = p15 or #t3 + 1
	local t10 = {
		Tool = nil,
		Index = v156,
		Frame = nil
	}
	local u158 = nil
	local u159 = nil
	local u160 = nil
	local u161 = nil
	local u162 = nil
	local u163 = nil
	local u164 = nil
	local u165 = nil

	local function UpdateSlotFading() -- line: 398
		-- upvalues: u158 (ref), u26 (ref), color3_2 (copy), color3 (copy)
		u158.SelectionImageObject = nil
		u158.BackgroundTransparency = if not u158.Draggable then u26 else 0
		u158.BackgroundColor3 = u158.Draggable and color3_2 or color3
	end

	function t10.Readjust(_, p17, p18) -- line: 404
		-- upvalues: u51 (ref), n1 (ref), u158 (ref)
		local v293 = u51.Size.X.Offset / 2
		local v294 = n1 + 5
		local v295 = p17 - (p18 / 2 + 0.5)

		u158.Position = UDim2.new(0, v293 - n1 / 2 + v294 * v295, 0, 5)
	end
	function t10.Fill(p19, p20) -- line: 412
		-- upvalues: u160 (ref), u161 (ref), GameTranslator (copy), u164 (ref), u162 (ref), u80 (ref), u54 (ref), u158 (ref), n2 (ref), u72 (ref), u47 (ref), ContextActionService (copy), u83 (ref), t4 (copy), u65 (ref), t3 (copy)
		if not p20 then
			return p19:Clear()
		end

		p19.Tool = p20

		local function assignToolData() -- line: 419
			-- upvalues: p20 (copy), u160 (ref), u161 (ref), GameTranslator (copy), u164 (ref)
			local TextureId = p20.TextureId

			u160.Image = TextureId

			if TextureId ~= "" then
				u161.Visible = false
			else
				u161.Visible = true
			end

			GameTranslator:TranslateAndRegister(u161, p20, p20.Name)

			if u164 and p20:IsA("Tool") then
				GameTranslator:TranslateAndRegister(u164, p20, p20.ToolTip)

				local v427 = u164.TextBounds.X + 6

				u164.Size = UDim2.new(0, v427, 0, 16)
				u164.Position = UDim2.new(0.5, -v427 / 2, 0, -25)
			end
		end

		assignToolData()

		local g303 = nil
		local v302 = nil

		if u162 then
			u162:disconnect()
			u162 = nil
		end

		u162 = p20.Changed:connect(function(p21) -- line: 445
			-- upvalues: assignToolData (copy)
			if p21 == "TextureId" or (p21 == "Name" or p21 == "ToolTip") then
				assignToolData()
			end
		end)

		local v299 = p19.Index <= u80
		local Visible = u54.Visible

		if not v299 or Visible then
			u158.Draggable = true
		end

		p19:UpdateEquipView()

		if v299 then
			n2 += 1

			if u72 and n2 >= 1 and not u47 then
				u47 = true
				ContextActionService:BindAction("RBXHotbarEquip", u83, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
			end
		end

		t4[p20] = p19

		for i = 1, u80 do
			v302 = t3[i]

			if not v302.Tool then
				g303 = true
			end

			if g303 then
				break
			end
		end

		if not g303 then
			v302 = nil
		end

		g303 = false
		u65 = v302
	end
	function t10.Clear(p22) -- line: 482
		-- upvalues: u162 (ref), u160 (ref), u161 (ref), u164 (ref), u158 (ref), u80 (ref), n2 (ref), u47 (ref), ContextActionService (copy), t4 (copy), u65 (ref), t3 (copy)
		if not p22.Tool then
			return
		end

		local g307 = nil
		local v306 = nil

		if u162 then
			u162:disconnect()
			u162 = nil
		end

		u160.Image = ""
		u161.Text = ""

		if u164 then
			u164.Text = ""
			u164.Visible = false
		end

		u158.Draggable = false
		p22:UpdateEquipView(true)

		if p22.Index <= u80 then
			n2 -= 1

			if n2 < 1 then
				u47 = false
				ContextActionService:UnbindAction("RBXHotbarEquip")
			end
		end

		t4[p22.Tool] = nil
		p22.Tool = nil

		for i = 1, u80 do
			v306 = t3[i]

			if not v306.Tool then
				g307 = true
			end

			if g307 then
				break
			end
		end

		if not g307 then
			v306 = nil
		end

		g307 = false
		u65 = v306
	end
	function t10.UpdateEquipView(p23, p24) -- line: 515
		-- upvalues: u61 (ref), u82 (ref), t10 (copy), u163 (ref), NewGui (copy), u158 (ref), color3_3 (copy), u26 (ref), color3_2 (copy), color3 (copy)
		local g310 = nil
		local Tool = nil

		repeat
			if g310 or not p24 then
				if not g310 then
					Tool = p23.Tool
				end

				if g310 or Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u61) then
					if not g310 then
						u82 = t10

						if not u163 then
							u163 = NewGui("Frame", "Equipped")
							u163.ZIndex = u158.ZIndex

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
								local v314 = NewGui("Frame", "Edge")

								v314.BackgroundTransparency = 0
								v314.BackgroundColor3 = color3_3
								v314.Size = UDim2.new(v[1], 0, v[2], 0)
								v314.Position = UDim2.new(v[3], 0, v[4], 0)
								v314.ZIndex = u163.ZIndex
								v314.Parent = u163
							end
						end

						u163.Parent = u158
					end

					g310 = false
					u158.SelectionImageObject = nil
					u158.BackgroundTransparency = if not u158.Draggable then u26 else 0
					u158.BackgroundColor3 = u158.Draggable and color3_2 or color3

					return
				end
			end

			if u163 then
				u163.Parent = nil
			end

			g310 = true
		until not g310
	end
	function t10.IsEquipped(p25) -- line: 547
		-- upvalues: u61 (ref)
		local Tool = p25.Tool

		return Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u61)
	end
	function t10.Delete(p26) -- line: 551
		-- upvalues: t6 (copy), u158 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
		t6[u158] = nil
		u158:Destroy()
		table.remove(t3, p26.Index)

		local v318 = #t3

		for i = p26.Index, v318 do
			t3[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end
	function t10.Swap(p27, p28) -- line: 565
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
	function t10.SlideBack(p29) -- line: 579
		-- upvalues: u158 (ref)
		p29.Index = p29.Index - 1
		u158.Name = p29.Index
		u158.LayoutOrder = p29.Index
	end
	function t10.TurnNumber(_, p31) -- line: 585
		-- upvalues: u165 (ref)
		if u165 then
			u165.Visible = p31
		end
	end
	function t10.SetClickability(p32, p33) -- line: 591
		-- upvalues: u158 (ref), u26 (ref), color3_2 (copy), color3 (copy)
		if p32.Tool then
			u158.Draggable = not p33
			u158.SelectionImageObject = nil
			u158.BackgroundTransparency = if not u158.Draggable then u26 else 0
			u158.BackgroundColor3 = u158.Draggable and color3_2 or color3
		end
	end
	function t10.CheckTerms(p34, p35) -- line: 598
		-- upvalues: u161 (ref), u164 (ref)
		local n5 = 0

		local function checkEm(p36, p37) -- line: 600
			-- upvalues: n5 (ref)
			local _, count = p36:lower():gsub(p37, "")

			n5 += count
		end

		local Tool = p34.Tool

		if Tool then
			for k in pairs(p35) do
				local _, count = u161.Text:lower():gsub(k, "")

				n5 += count

				if Tool:IsA("Tool") then
					local _, count2 = (u164 and u164.Text or ""):lower():gsub(k, "")

					n5 += count2
				end
			end
		end

		return n5
	end
	function t10.Select(_, p39) -- line: 618
		-- upvalues: t10 (copy), u61 (ref), u62 (ref), u70 (ref), t4 (copy), Backpack (ref)
		if p39 then
			return
		end

		local Tool = t10.Tool

		if Tool then
			if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u61) then
				if u62 then
					u62:UnequipTools()

					if u70 then
						u70:ToggleSelect()
						t4[u70]:UpdateEquipView()
						u70 = nil

						return
					end
				end
			elseif Tool.Parent == Backpack then
				if u62 then
					u62:UnequipTools()

					if u70 then
						u70:ToggleSelect()
						t4[u70]:UpdateEquipView()
						u70 = nil
					end
				end

				if Tool:IsA("HopperBin") then
					Tool:ToggleSelect()
					t4[Tool]:UpdateEquipView()
					u70 = Tool

					return
				end

				Tool.Parent = u61
			end
		end
	end

	u158 = NewGui("TextButton", v156)
	u158.BackgroundColor3 = color3
	u158.BorderColor3 = color3_4
	u158.Text = ""
	u158.AutoButtonColor = false
	u158.BorderSizePixel = 0
	u158.Size = UDim2.new(0, n1, 0, n1)
	u158.Active = true
	u158.Draggable = false
	u158.BackgroundTransparency = u26
	u158.MouseButton1Click:connect(function() -- line: 645
		-- upvalues: t10 (copy)
		changeSlot(t10)
	end)
	t10.Frame = u158

	local v167 = NewGui("Frame", "SelectionObjectClipper")

	v167.Visible = false
	v167.Parent = u158

	local v168 = NewGui("ImageLabel", "Selector")

	v168.Size = UDim2.new(1, 0, 1, 0)
	v168.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	v168.ScaleType = Enum.ScaleType.Slice
	v168.SliceCenter = Rect.new(12, 12, 52, 52)
	v168.Parent = v167
	u160 = NewGui("ImageLabel", "Icon")
	u160.Size = UDim2.new(0.8, 0, 0.8, 0)
	u160.Position = UDim2.new(0.1, 0, 0.1, 0)
	u160.Parent = u158
	u161 = NewGui("TextLabel", "ToolName")
	u161.Size = UDim2.new(1, -2, 1, -2)
	u161.Position = UDim2.new(0, 1, 0, 1)
	u161.Parent = u158
	t10.Frame.LayoutOrder = t10.Index

	if v156 <= u80 then
		u164 = NewGui("TextLabel", "ToolTip")
		u164.TextWrapped = false
		u164.TextYAlignment = Enum.TextYAlignment.Top
		u164.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		u164.BackgroundTransparency = 0
		u164.Visible = false
		u164.Parent = u158
		u158.MouseEnter:connect(function() -- line: 684
			-- upvalues: u164 (ref)
			if u164.Text ~= "" then
				u164.Visible = true
			end
		end)
		u158.MouseLeave:connect(function() -- line: 689
			-- upvalues: u164 (ref)
			u164.Visible = false
		end)

		function t10.MoveToInventory(p40) -- line: 693
			-- upvalues: t10 (copy), u80 (ref), MakeSlot (copy), u57 (ref), u61 (ref), u62 (ref), u70 (ref), t4 (copy), u74 (ref), u54 (ref)
			if t10.Index <= u80 then
				local Tool = t10.Tool

				p40:Clear()

				local v344 = MakeSlot(u57)

				v344:Fill(Tool)

				if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u61) and u62 then
					u62:UnequipTools()

					if u70 then
						u70:ToggleSelect()
						t4[u70]:UpdateEquipView()
						u70 = nil
					end
				end

				if u74 then
					v344.Frame.Visible = false
					v344.Parent = u54
				end
			end
		end

		if v156 < 10 or v156 == u80 then
			local v169 = v156 < 10 and v156 or 0

			u165 = NewGui("TextLabel", "Number")
			u165.Text = v169
			u165.Size = UDim2.new(0.15, 0, 0.15, 0)
			u165.Visible = false
			u165.Parent = u158
			t5[ZeroValue + v169] = function(p41) -- line: 719
				-- upvalues: t10 (copy)
				t10:Select(p41)
			end
		end
	end

	local Position = u158.Position
	local n6 = 0
	local Parent2 = nil

	u158.DragBegin:connect(function(p42) -- line: 730
		-- upvalues: t6 (copy), u158 (ref), Position (ref), u160 (ref), u161 (ref), u165 (ref), u163 (ref), Parent2 (ref), u57 (ref), u54 (ref), u159 (ref), NewGui (copy)
		t6[u158] = true
		Position = p42
		u158.BorderSizePixel = 2
		u158.ZIndex = 2
		u160.ZIndex = 2
		u161.ZIndex = 2
		u158.Parent.ZIndex = 2

		if u165 then
			u165.ZIndex = 2
		end

		if u163 then
			u163.ZIndex = 2

			for _, child in pairs(u163:GetChildren()) do
				child.ZIndex = 2
			end
		end

		Parent2 = u158.Parent

		if Parent2 == u57 then
			local _ = u158.AbsolutePosition
			local uDim2 = UDim2.new(0, u158.AbsolutePosition.X - u54.AbsolutePosition.X, 0, u158.AbsolutePosition.Y - u54.AbsolutePosition.Y)

			u158.Parent = u54
			u158.Position = uDim2
			u159 = NewGui("Frame", "FakeSlot")
			u159.LayoutOrder = u158.LayoutOrder
			u159.Size = u158.Size
			u159.BackgroundTransparency = 1
			u159.Parent = u57
		end
	end)
	u158.DragStopped:connect(function(p43, p44) -- line: 772
		-- upvalues: u159 (ref), u158 (ref), Position (ref), Parent2 (ref), u160 (ref), u161 (ref), u165 (ref), u163 (ref), t6 (copy), t10 (copy), u54 (ref), u80 (ref), n6 (ref), u65 (ref), u51 (ref), t3 (copy), u61 (ref), u62 (ref), u70 (ref), t4 (copy), u74 (ref)
		if u159 then
			u159:Destroy()
		end

		local timestamp = tick()

		u158.Position = Position
		u158.Parent = Parent2
		u158.BorderSizePixel = 0
		u158.ZIndex = 1
		u160.ZIndex = 1
		u161.ZIndex = 1
		Parent2.ZIndex = 1

		if u165 then
			u165.ZIndex = 1
		end

		if u163 then
			u163.ZIndex = 1

			for _, child in pairs(u163:GetChildren()) do
				child.ZIndex = 1
			end
		end

		t6[u158] = nil

		if not t10.Tool then
			return
		end

		local v356 = u54
		local AbsolutePosition = v356.AbsolutePosition
		local AbsoluteSize = v356.AbsoluteSize

		if p43 > AbsolutePosition.X and (p43 <= AbsolutePosition.X + AbsoluteSize.X and (p44 > AbsolutePosition.Y and p44 <= AbsolutePosition.Y + AbsoluteSize.Y)) then
			if t10.Index <= u80 then
				t10:MoveToInventory()
			end

			if t10.Index > u80 and timestamp - n6 < 0.5 then
				if u65 then
					local Tool = t10.Tool

					t10:Clear()
					u65:Fill(Tool)
					t10:Delete()
				end

				timestamp = 0
			end
		else
			local v360 = u51
			local AbsolutePosition2 = v360.AbsolutePosition
			local AbsoluteSize2 = v360.AbsoluteSize

			if p43 > AbsolutePosition2.X and (p43 <= AbsolutePosition2.X + AbsoluteSize2.X and (p44 > AbsolutePosition2.Y and p44 <= AbsolutePosition2.Y + AbsoluteSize2.Y)) then
				local t11 = {
					1e999,
					nil
				}

				for i = 1, u80 do
					local v365 = t3[i]
					local Frame = v365.Frame
					local vector2 = Vector2.new(p43, p44)
					local magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - vector2).magnitude

					if magnitude < t11[1] then
						t11 = {
							magnitude,
							v365
						}
					end
				end

				local v369 = t11[2]

				if v369 ~= t10 then
					t10:Swap(v369)

					if t10.Index > u80 then
						local Tool = t10.Tool

						if not Tool then
							t10:Delete()
						else
							if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u61) and u62 then
								u62:UnequipTools()

								if u70 then
									u70:ToggleSelect()
									t4[u70]:UpdateEquipView()
									u70 = nil
								end
							end

							if u74 then
								t10.Frame.Visible = false
								t10.Frame.Parent = u54
							end
						end
					end
				end
			elseif t10.Index <= u80 then
				t10:MoveToInventory()
			end
		end

		n6 = timestamp
	end)
	u158.Parent = p14
	t3[v156] = t10

	if v156 > u80 then
		UpdateScrollingFrameCanvasSize()

		if u56 and u54.Visible and not u74 then
			local v173 = u56.CanvasSize.Y.Offset - u56.AbsoluteSize.Y

			u56.CanvasPosition = Vector2.new(0, (math.max(0, v173)))
		end
	end

	return t10
end
local function SetNumberOfHotbarSlots(p45) -- line: 881
	-- upvalues: u80 (ref), t3 (copy), MakeSlot (copy), u51 (ref), u65 (ref), n2 (ref), UpdateBackpackLayout (copy)
	if p45 ~= u80 then
		local v175 = u80

		if p45 < v175 then
			for i = v175, p45 + 1, -1 do
				local v177 = t3[i]

				if v177 then
					v177:MoveToInventory()
					v177:Delete()
				end
			end

			for i = v175, p45 + 1, -1 do
				local v179 = t3[i]

				if not v179.Tool then
					v179:Delete()
				end
			end
		else
			for i = v175, p45 do
				u80 = i

				if t3[i] then
					local _ = t3[i]
					local Tool = t3[i].Tool
					local v183 = MakeSlot(u51, i)

					if Tool then
						v183:Fill(Tool)
					elseif not u65 then
						u65 = v183
					end
				else
					local v184 = MakeSlot(u51, i)

					v184.Frame.Visible = false

					if not u65 then
						u65 = v184
					end
				end
			end
		end

		u80 = p45
		n2 = 0

		for i = 1, u80 do
			if t3[i] and t3[i].Tool then
				n2 += 1
			end
		end

		UpdateBackpackLayout()
	end
end
local function OnChildAdded(p46) -- line: 943
	-- upvalues: u50 (ref), u61 (ref), u62 (ref), n3 (ref), u70 (ref), t4 (copy), u71 (ref), LocalPlayer (ref), u65 (ref), MakeSlot (copy), u57 (ref), t3 (copy), Backpack (ref), AdjustHotbarFrames (copy), u80 (ref), u54 (ref), t1 (copy)
	if not u50 then
		return
	end

	if not p46:IsA("Tool") and not p46:IsA("HopperBin") then
		if p46:IsA("Humanoid") and p46.Parent == u61 then
			u62 = p46
		end

		return
	end

	if p46.Parent == u61 then
		n3 = tick()
	end

	if u70 and p46.Parent == u61 then
		u70:ToggleSelect()
		t4[u70]:UpdateEquipView()
		u70 = nil
	end

	if not u71 and p46.Parent == u61 and not t4[p46] then
		local StarterGear = LocalPlayer:FindFirstChild("StarterGear")

		if StarterGear and StarterGear:FindFirstChild(p46.Name) then
			u71 = true

			for i = (u65 or MakeSlot(u57)).Index, 1, -1 do
				local v189 = t3[i]
				local v190 = i - 1

				if v190 > 0 then
					t3[v190]:Swap(v189)
				else
					v189:Fill(p46)
				end
			end

			for _, child in pairs(u61:GetChildren()) do
				if child:IsA("Tool") and child ~= p46 then
					child.Parent = Backpack
				end
			end

			AdjustHotbarFrames()

			return
		end
	end

	local v193 = t4[p46]

	if v193 then
		v193:UpdateEquipView()
	else
		local v194 = u65 or MakeSlot(u57)

		v194:Fill(p46)

		if v194.Index <= u80 and not u54.Visible then
			AdjustHotbarFrames()
		end

		if p46:IsA("HopperBin") and p46.Active then
			if u62 then
				u62:UnequipTools()

				if u70 then
					u70:ToggleSelect()
					t4[u70]:UpdateEquipView()
					u70 = nil
				end
			end

			u70 = p46
		end
	end

	t1.BackpackItemAdded:Fire()
end
local function OnChildRemoved(p47) -- line: 1013
	-- upvalues: u50 (ref), n3 (ref), u61 (ref), Backpack (ref), t4 (copy), u80 (ref), u54 (ref), AdjustHotbarFrames (copy), u70 (ref), t1 (copy), t3 (copy)
	if not u50 then
		return
	end

	if not p47:IsA("Tool") and not p47:IsA("HopperBin") then
		return
	end

	n3 = tick()

	local p47Parent = p47.Parent

	if p47Parent == u61 or p47Parent == Backpack then
		return
	end

	local v197 = t4[p47]
	local g201 = nil
	local v200 = nil

	if v197 then
		v197:Clear()

		if v197.Index > u80 then
			v197:Delete()
		elseif not u54.Visible then
			AdjustHotbarFrames()
		end
	end

	if p47 == u70 then
		u70 = nil
	end

	t1.BackpackItemRemoved:Fire()

	for i = u80 + 1, #t3 do
		local v199 = t3[i]

		if v199 and v199.Tool then
			v200 = false
			g201 = true
		end

		if g201 then
			break
		end
	end

	if not g201 then
		v200 = true
	end

	g201 = false

	if v200 then
		t1.BackpackEmpty:Fire()
	end
end
local function OnCharacterAdded(p48) -- line: 1050
	-- upvalues: t3 (copy), u80 (ref), u70 (ref), t8 (ref), u61 (ref), OnChildRemoved (copy), OnChildAdded (copy), Backpack (ref), LocalPlayer (ref), AdjustHotbarFrames (copy)
	for i = #t3, 1, -1 do
		local v204 = t3[i]

		if v204.Tool then
			v204:Clear()
		end

		if i > u80 then
			v204:Delete()
		end
	end

	u70 = nil

	for _, v in pairs(t8) do
		v:disconnect()
	end

	t8 = {}
	u61 = p48
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
local function OnInputBegan(p49, p50) -- line: 1089
	-- upvalues: u73 (ref), u72 (ref), BackspaceValue (copy), t5 (copy), u54 (ref), t1 (copy)
	if p49.UserInputType == Enum.UserInputType.Keyboard and not u73 and (u72 or p49.KeyCode.Value == BackspaceValue) then
		local v213 = t5[p49.KeyCode.Value]

		if v213 then
			v213(p50)
		end
	end

	local UserInputType = p49.UserInputType

	if not p50 and ((UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and u54 and u54.Visible) then
		t1.OpenClose()
	end
end
local function OnUISChanged(p51) -- line: 1112
	-- upvalues: UserInputService (copy), VRService (copy), u80 (ref), t3 (copy)
	if p51 == "KeyboardEnabled" or p51 == "VREnabled" then
		local v216 = UserInputService.KeyboardEnabled and not VRService.VREnabled

		for i = 1, u80 do
			t3[i]:TurnNumber(v216)
		end
	end
end

local u106 = nil
local timestamp = nil

local function v108() -- line: 1124
end

local vector2 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions() -- line: 1128
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
	ContextActionService:UnbindAction("RBXCloseInventory")
end

local function setHotbarVisibility(p52, p53) -- line: 1133
	-- upvalues: u80 (ref), t3 (copy)
	for i = 1, u80 do
		local v221 = t3[i]

		if v221 and v221.Frame and (p53 or v221.Tool) then
			v221.Frame.Visible = p52
		end
	end
end
local function getInputDirection(p54) -- line: 1142
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

function u83(_, p56, p57) -- line: 1203
	-- upvalues: u106 (ref), timestamp (ref), u62 (ref), u70 (ref), t4 (copy), u80 (ref), t3 (copy), u82 (ref)
	if p56 ~= Enum.UserInputState.Begin then
		return
	end

	if u106 and ((u106.KeyCode == Enum.KeyCode.ButtonR1 and p57.KeyCode == Enum.KeyCode.ButtonL1 or u106.KeyCode == Enum.KeyCode.ButtonL1 and p57.KeyCode == Enum.KeyCode.ButtonR1) and tick() - timestamp <= 0.06) then
		if u62 then
			u62:UnequipTools()

			if u70 then
				u70:ToggleSelect()
				t4[u70]:UpdateEquipView()
				u70 = nil
			end
		end

		u106 = p57
		timestamp = tick()

		return
	end

	u106 = p57
	timestamp = tick()
	delay(0.06, function() -- line: 1231
		-- upvalues: u106 (ref), p57 (copy), u80 (ref), t3 (copy), u62 (ref), u70 (ref), t4 (copy), u82 (ref)
		if u106 ~= p57 then
			return
		end

		local v371 = p57.KeyCode ~= Enum.KeyCode.ButtonL1 and 1 or -1

		for i = 1, u80 do
			local v373 = t3[i]

			if not v373 then
				return
			end

			if v373:IsEquipped() then
				local v374 = v371 + i
				local v375 = false

				if v374 > u80 then
					v374 = 1
					v375 = true
				elseif v374 < 1 then
					v374 = u80
					v375 = true
				end

				local v376 = v374

				while not t3[v376].Tool do
					v376 += v371

					if v376 == v374 then
						return
					end

					if v376 > u80 then
						v376 = 1
						v375 = true
					elseif v376 < 1 then
						v376 = u80
						v375 = true
					end
				end

				if v375 then
					if u62 then
						u62:UnequipTools()

						if u70 then
							u70:ToggleSelect()
							t4[u70]:UpdateEquipView()
							u70 = nil
						end
					end

					u82 = nil

					return
				end

				t3[v376]:Select()

				return
			end
		end

		if u82 and u82.Tool then
			u82:Select()

			return
		end

		for i = v371 == -1 and u80 or 1, if v371 ~= -1 then u80 else 1, v371 do
			if t3[i].Tool then
				t3[i]:Select()

				return
			end
		end
	end)
end
function getGamepadSwapSlot() -- line: 1301
	-- upvalues: t3 (copy)
	for i = 1, #t3 do
		if t3[i].Frame.BorderSizePixel > 0 then
			return t3[i]
		end
	end
end
function changeSlot(p58) -- line: 1309
	-- upvalues: GamepadService (copy), GuiService (copy), u55 (ref), u80 (ref), EngineFeature (copy)
	local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if p58.Frame == GuiService.SelectedCoreObject and not GamepadCursorEnabled then
		local v238 = getGamepadSwapSlot()

		if v238 then
			v238.Frame.BorderSizePixel = 0

			if v238 ~= p58 then
				p58:Swap(v238)

				if u55 and u55.SelectionImageObject then
					u55.SelectionImageObject.Visible = false
				end

				if p58.Index > u80 and not p58.Tool then
					if GuiService.SelectedCoreObject == p58.Frame then
						GuiService.SelectedCoreObject = v238.Frame
					end

					p58:Delete()
				end

				if v238.Index > u80 and not v238.Tool then
					if GuiService.SelectedCoreObject == v238.Frame then
						GuiService.SelectedCoreObject = p58.Frame
					end

					v238:Delete()

					return
				end
			end
		else
			local FrameSize = p58.Frame.Size
			local FramePosition = p58.Frame.Position

			if EngineFeature then
				p58.Frame:TweenSizeAndPositionInternal(FrameSize + UDim2.new(0, 10, 0, 10), FramePosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 1348
					-- upvalues: p58 (copy), FrameSize (copy), FramePosition (copy)
					p58.Frame:TweenSizeAndPositionInternal(FrameSize, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
				end)
			else
				p58.Frame:TweenSizeAndPosition(FrameSize + UDim2.new(0, 10, 0, 10), FramePosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 1367
					-- upvalues: p58 (copy), FrameSize (copy), FramePosition (copy)
					p58.Frame:TweenSizeAndPosition(FrameSize, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
				end)
			end

			p58.Frame.BorderSizePixel = 3

			if u55 and u55.SelectionImageObject then
				u55.SelectionImageObject.Visible = true

				return
			end
		end
	else
		p58:Select()

		if u55 and u55.SelectionImageObject then
			u55.SelectionImageObject.Visible = false
		end
	end
end
function enableGamepadInventoryControl() -- line: 1392
	-- upvalues: u54 (ref), t1 (copy), ContextActionService (copy), v108 (copy), u51 (ref), GuiService (copy)
	ContextActionService:BindAction("RBXBackpackHasGamepadFocus", v108, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("RBXCloseInventory", function(_, inputState, _) -- line: 1393
		-- upvalues: u54 (ref), t1 (copy)
		if inputState ~= Enum.UserInputState.Begin then
			return
		end

		if getGamepadSwapSlot() then
			local v381 = getGamepadSwapSlot()

			if v381 then
				v381.Frame.BorderSizePixel = 0

				return
			end
		elseif u54 and u54.Visible then
			t1.OpenClose()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

	if not false and u51 then
		GuiService.SelectedCoreObject = u51:FindFirstChild("1")
	end
end
function disableGamepadInventoryControl() -- line: 1425
	-- upvalues: u80 (ref), t3 (copy), u50 (ref), GuiService (copy)
	unbindAllGamepadEquipActions()

	for i = 1, u80 do
		local v242 = t3[i]

		if v242 and v242.Frame then
			v242.Frame.BorderSizePixel = 0
		end
	end

	if u50 and GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(u50) then
		GuiService.SelectedCoreObject = nil
	end
end

local function bindBackpackHotbarAction() -- line: 1440
	-- upvalues: u72 (ref), u47 (ref), ContextActionService (copy), u83 (ref)
	if u72 and not u47 then
		u47 = true
		ContextActionService:BindAction("RBXHotbarEquip", u83, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
	end
end
local function unbindBackpackHotbarAction() -- line: 1453
	-- upvalues: u47 (ref), ContextActionService (copy)
	disableGamepadInventoryControl()
	u47 = false
	ContextActionService:UnbindAction("RBXHotbarEquip")
end

function gamepadDisconnected() -- line: 1459
	-- upvalues: VRService (copy), u78 (ref)
	if not VRService.VREnabled then
		u78 = false
		disableGamepadInventoryControl()
	end
end
function gamepadConnected() -- line: 1466
	-- upvalues: VRService (copy), u78 (ref), u50 (ref), GuiService (copy), n2 (ref), u72 (ref), u47 (ref), ContextActionService (copy), u83 (ref), u54 (ref)
	if not VRService.VREnabled then
		u78 = true

		if u50 then
			GuiService:AddSelectionParent("RBXBackpackSelection", u50)
		end

		if n2 >= 1 and u72 and not u47 then
			u47 = true
			ContextActionService:BindAction("RBXHotbarEquip", u83, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end

		if u54 and u54.Visible then
			enableGamepadInventoryControl()
		end
	end
end

local function setBackpackEnabled(p61) -- line: 1483
	-- upvalues: u46 (ref), u72 (ref), u50 (ref), FFlagMountCoreGuiBackpack (copy), RobloxGui (copy), t7 (copy), GuiService (copy), n2 (ref), u47 (ref), ContextActionService (copy), u83 (ref)
	local v244 = p61 and u46

	u72 = v244

	if u50 then
		if FFlagMountCoreGuiBackpack then
			if v244 then
				u50.Parent = RobloxGui
			else
				u50.Parent = nil
			end
		else
			u50.Visible = v244
		end
	end

	for _, v in pairs(t7) do
		if v244 then
			GuiService:AddKey(v)
		else
			GuiService:RemoveKey(v)
		end
	end

	if v244 then
		if n2 >= 1 and u72 and not u47 then
			u47 = true
			ContextActionService:BindAction("RBXHotbarEquip", u83, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)

			return
		end
	else
		disableGamepadInventoryControl()
		u47 = false
		ContextActionService:UnbindAction("RBXHotbarEquip")
	end
end
local function MakeVRRoundButton(p62, p63) -- line: 1516
	-- upvalues: NewGui (copy)
	local v249 = NewGui("ImageButton", p62)

	v249.Size = UDim2.new(0, 40, 0, 40)
	v249.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local v250 = NewGui("ImageLabel", "Icon")

	v250.Size = UDim2.new(0.5, 0, 0.5, 0)
	v250.Position = UDim2.new(0.25, 0, 0.25, 0)
	v250.Image = p63
	v250.Parent = v249

	local v251 = NewGui("ImageLabel", "Selection")

	v251.Size = UDim2.new(0.9, 0, 0.9, 0)
	v251.Position = UDim2.new(0.05, 0, 0.05, 0)
	v251.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	v249.SelectionImageObject = v251

	return v249, v250, v251
end

function t1.createGui() -- line: 1536
	-- upvalues: u50 (ref), NewGui (copy), FFlagMountCoreGuiBackpack (copy), StarterGui (copy), RobloxGui (copy), u51 (ref), u80 (ref), MakeSlot (copy), u65 (ref), u52 (ref), t1 (copy), color3_5 (copy), u53 (ref), MakeVRRoundButton (copy), u54 (ref), u22 (ref), color3 (copy), u55 (ref), u56 (ref), u57 (ref), UIGridLayout (ref), n1 (ref), u59 (ref), u60 (ref), UpdateBackpackLayout (copy), Create (copy), v43 (copy), color3_6 (copy), u32 (ref), s1 (ref), color3_3 (copy), t3 (copy), u74 (ref), UpdateScrollingFrameCanvasSize (copy), t9 (copy), t5 (copy), VRService (copy), UserInputService (copy), GuiService (copy), t6 (copy), AdjustHotbarFrames (copy), u78 (ref), t2 (copy), ContextActionService (copy), BackquoteValue (copy), LocalPlayer (ref), Players (copy), OnCharacterAdded (copy), t7 (copy), OnInputBegan (copy), u73 (ref), BackspaceValue (copy), u70 (ref), u62 (ref), t4 (copy), OnUISChanged (copy), v17 (copy), SettingsShowSignal (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), InExperienceAppChatModal (copy), UserGameSettings (copy), u26 (ref)
	u50 = NewGui("Frame", "Backpack")

	if FFlagMountCoreGuiBackpack then
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
			u50.Parent = RobloxGui
		end
	else
		u50.Visible = false
		u50.Parent = RobloxGui
	end

	u51 = NewGui("Frame", "Hotbar")
	u51.Parent = u50

	for i = 1, u80 do
		local v253 = MakeSlot(u51, i)

		v253.Frame.Visible = false

		if not u65 then
			u65 = v253
		end
	end

	u52 = NewGui("ImageButton", "OpenInventory")
	u52.Size = UDim2.new(0, 30, 0, 30)
	u52.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
	u52.MouseButton1Click:connect(function() -- line: 1567
		-- upvalues: t1 (copy)
		t1.OpenClose()
	end)
	u52.SelectionGained:connect(function() -- line: 1570
		-- upvalues: u52 (ref), color3_5 (copy)
		u52.ImageColor3 = color3_5
	end)
	u52.SelectionLost:connect(function() -- line: 1573
		-- upvalues: u52 (ref)
		u52.ImageColor3 = Color3.new(1, 1, 1)
	end)

	local v254 = NewGui("Frame", "Selection")

	v254.Visible = false
	u52.SelectionImageObject = v254
	u53 = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
	u53.Position = UDim2.new(0, 0, 0, -50)
	u53.MouseButton1Click:connect(function() -- line: 1583
		-- upvalues: u54 (ref), t1 (copy)
		if u54.Visible then
			t1.OpenClose()
		end
	end)

	local v255 = NewGui("ImageLabel", "LeftBumper")

	v255.Size = UDim2.new(0, 40, 0, 40)
	v255.Position = UDim2.new(0, -v255.Size.X.Offset, 0.5, -v255.Size.Y.Offset / 2)

	local v256 = NewGui("ImageLabel", "RightBumper")

	v256.Size = UDim2.new(0, 40, 0, 40)
	v256.Position = UDim2.new(1, 0, 0.5, -v256.Size.Y.Offset / 2)
	u54 = NewGui("Frame", "Inventory")
	u54.BackgroundTransparency = u22
	u54.BackgroundColor3 = color3
	u54.Active = true
	u54.Visible = false
	u54.Parent = u50
	u55 = NewGui("TextButton", "VRInventorySelector")
	u55.Position = UDim2.new(0, 0, 0, 0)
	u55.Size = UDim2.new(1, 0, 1, 0)
	u55.BackgroundTransparency = 1
	u55.Text = ""
	u55.Parent = u54

	local v257 = NewGui("ImageLabel", "Selector")

	v257.Size = UDim2.new(1, 0, 1, 0)
	v257.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	v257.ScaleType = Enum.ScaleType.Slice
	v257.SliceCenter = Rect.new(12, 12, 52, 52)
	v257.Visible = false
	u55.SelectionImageObject = v257
	u56 = NewGui("ScrollingFrame", "ScrollingFrame")
	u56.Selectable = false
	u56.CanvasSize = UDim2.new(0, 0, 0, 0)
	u56.Parent = u54
	u57 = NewGui("Frame", "UIGridFrame")
	u57.Selectable = false
	u57.Size = UDim2.new(1, -10, 1, 0)
	u57.Position = UDim2.new(0, 5, 0, 0)
	u57.Parent = u56
	UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellSize = UDim2.new(0, n1, 0, n1)
	UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	UIGridLayout.Parent = u57
	u59 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	u59.Size = UDim2.new(0, 34, 0, 34)
	u59.Position = UDim2.new(0.5, -u59.Size.X.Offset / 2, 0, 43)
	u59.Icon.Position = u59.Icon.Position - UDim2.new(0, 0, 0, 2)
	u59.MouseButton1Click:connect(function() -- line: 1643
		-- upvalues: u56 (ref), n1 (ref)
		if not u56 then
			return
		end

		u56.CanvasPosition = Vector2.new(u56.CanvasPosition.X, (math.min(u56.CanvasSize.Y.Offset - u56.AbsoluteWindowSize.Y, (math.max(0, u56.CanvasPosition.Y - (n1 + 5))))))
	end)
	u60 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
	u60.Rotation = 180
	u60.Icon.Position = u60.Icon.Position - UDim2.new(0, 0, 0, 2)
	u60.Size = UDim2.new(0, 34, 0, 34)
	u60.Position = UDim2.new(0.5, -u60.Size.X.Offset / 2, 1, -u60.Size.Y.Offset - 3)
	u60.MouseButton1Click:connect(function() -- line: 1664
		-- upvalues: u56 (ref), n1 (ref)
		if not u56 then
			return
		end

		u56.CanvasPosition = Vector2.new(u56.CanvasPosition.X, (math.min(u56.CanvasSize.Y.Offset - u56.AbsoluteWindowSize.Y, (math.max(0, u56.CanvasPosition.Y + (n1 + 5))))))
	end)
	u56.Changed:connect(function(p64) -- line: 1678
		-- upvalues: u56 (ref), u59 (ref), u60 (ref)
		if not u56 then
			return
		end

		if p64 == "AbsoluteWindowSize" or p64 == "CanvasPosition" or p64 == "CanvasSize" then
			local v383 = u56.CanvasPosition.Y ~= 0
			local v384 = u56.CanvasPosition.Y < u56.CanvasSize.Y.Offset - u56.AbsoluteWindowSize.Y

			u59.Visible = v383
			u60.Visible = v384
		end
	end)
	UpdateBackpackLayout()

	local v258 = Create("Frame")({
		Name = "GamepadHintsFrame",
		BackgroundTransparency = 1,
		Visible = false,
		Size = UDim2.new(0, u51.Size.X.Offset, 0, not v43 and 60 or 95),
		Parent = u50
	})

	local function addGamepadHint(p65, p66, p67) -- line: 1704
		-- upvalues: Create (copy), v258 (copy), v43 (copy)
		local v388 = Create("Frame")({
			Name = "HintFrame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -5),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = v258
		})

		Create("ImageLabel")({
			Name = "HintImage",
			BackgroundTransparency = 1,
			Size = v43 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60),
			Image = v43 and p66 or p65,
			Parent = v388
		})

		local v389 = Create("TextLabel")({
			Name = "HintText",
			BackgroundTransparency = 1,
			TextWrapped = true,
			Position = UDim2.new(0, not v43 and 70 or 100, 0, 0),
			Size = UDim2.new(1, -(not v43 and 70 or 100), 1, 0),
			Font = Enum.Font.SourceSansBold,
			FontSize = v43 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
			Text = p67,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = v388
		})
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

		UITextSizeConstraint.Parent = v389
		UITextSizeConstraint.MaxTextSize = v389.TextSize
	end
	local function resizeGamepadHintsFrame() -- line: 1739
		-- upvalues: u51 (ref), u54 (ref), v258 (copy), v43 (copy)
		if not u51 or not u54 then
			return
		end

		v258.Size = UDim2.new(u51.Size.X.Scale, u51.Size.X.Offset, 0, not v43 and 60 or 95)
		v258.Position = UDim2.new(u51.Position.X.Scale, u51.Position.X.Offset, u54.Position.Y.Scale, u54.Position.Y.Offset - v258.Size.Y.Offset)

		local n8 = 0
		local children = v258:GetChildren()

		for i = 1, #children do
			children[i].Size = UDim2.new(1, 0, 1, -5)
			children[i].Position = UDim2.new(0, 0, 0, 0)
			n8 += children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X
		end

		local v394 = (v258.AbsoluteSize.X - n8) / (#children - 1)

		for i = 1, #children do
			children[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, children[i - 1].Position.X.Offset + children[i - 1].Size.X.Offset + v394, 0, 0)
			children[i].Size = UDim2.new(0, children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X, 1, -5)
		end
	end

	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonX@2x.png", "Remove From Hotbar")
	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonA@2x.png", "Select/Swap")
	addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png", "Close Backpack")

	local v261 = NewGui("Frame", "Search")

	v261.BackgroundColor3 = color3_6
	v261.BackgroundTransparency = u32
	v261.Size = UDim2.new(0, 190, 0, 30)
	v261.Position = UDim2.new(1, -v261.Size.X.Offset - 5, 0, 5)
	v261.Parent = u54

	local v262 = NewGui("TextBox", "TextBox")

	v262.Text = s1
	v262.ClearTextOnFocus = false
	v262.FontSize = Enum.FontSize.Size24
	v262.TextXAlignment = Enum.TextXAlignment.Left
	v262.Size = v261.Size - UDim2.new(0, 0, 0, 0)
	v262.Position = UDim2.new(0, 0, 0, 0)
	v262.Parent = v261

	local v263 = NewGui("TextButton", "X")

	v263.Text = "x"
	v263.TextColor3 = color3_3
	v263.FontSize = Enum.FontSize.Size24
	v263.TextYAlignment = Enum.TextYAlignment.Bottom
	v263.BackgroundColor3 = color3_6
	v263.BackgroundTransparency = 0
	v263.Size = UDim2.new(0, v261.Size.Y.Offset - 10, 0, v261.Size.Y.Offset - 10)
	v263.Position = UDim2.new(1, -v263.Size.X.Offset - 10, 0.5, -v263.Size.Y.Offset / 2)
	v263.ZIndex = 0
	v263.Visible = false
	v263.BorderSizePixel = 0
	v263.Parent = v261

	local function search() -- line: 1837
		-- upvalues: v262 (copy), u80 (ref), t3 (copy), u54 (ref), u74 (ref), u57 (ref), u56 (ref), UpdateScrollingFrameCanvasSize (copy), v263 (copy)
		local t12 = {}

		for match in v262.Text:gmatch("%S+") do
			t12[match:lower()] = true
		end

		local t13 = {}

		for i = u80 + 1, #t3 do
			local v400 = t3[i]

			table.insert(t13, {
				v400,
				(v400:CheckTerms(t12))
			})
			v400.Frame.Visible = false
			v400.Frame.Parent = u54
		end

		table.sort(t13, function(p68, p69) -- line: 1852
			return p68[2] > p69[2]
		end)
		u74 = true

		local n9 = 0

		for _, v in ipairs(t13) do
			local v404 = v[1]

			if v[2] > 0 then
				v404.Frame.Visible = true
				v404.Frame.Parent = u57
				v404.Frame.LayoutOrder = u80 + n9
				n9 += 1
			end
		end

		if u56 then
			u56.CanvasPosition = Vector2.new(0, 0)
		end

		UpdateScrollingFrameCanvasSize()
		v263.ZIndex = 3
	end
	local function clearResults() -- line: 1876
		-- upvalues: v263 (copy), u74 (ref), u80 (ref), t3 (copy), u57 (ref), UpdateScrollingFrameCanvasSize (copy)
		if v263.ZIndex > 0 then
			u74 = false

			for i = u80 + 1, #t3 do
				local v406 = t3[i]

				v406.Frame.LayoutOrder = v406.Index
				v406.Frame.Parent = u57
				v406.Frame.Visible = true
			end

			v263.ZIndex = 0
		end

		UpdateScrollingFrameCanvasSize()
	end
	local function reset() -- line: 1890
		-- upvalues: clearResults (copy), v262 (copy), s1 (ref)
		clearResults()
		v262.Text = s1
	end
	local function onChanged(p70) -- line: 1895
		-- upvalues: v262 (copy), clearResults (copy), s1 (ref), search (copy), v263 (copy)
		if p70 == "Text" then
			local Text = v262.Text

			if Text == "" then
				clearResults()
			elseif Text ~= s1 then
				search()
			end

			v263.Visible = Text ~= "" and Text ~= s1
		end
	end
	local function onFocused() -- line: 1907
		-- upvalues: v262 (copy), s1 (ref)
		if v262.Text == s1 then
			v262.Text = ""
		end
	end
	local function focusLost(p71) -- line: 1913
		-- upvalues: search (copy), v262 (copy), s1 (ref)
		if p71 then
			search()

			return
		end

		if v262.Text == "" then
			v262.Text = s1
		end
	end

	v262.Focused:connect(onFocused)
	v263.MouseButton1Click:connect(reset)
	v262.Changed:connect(onChanged)
	v262.FocusLost:connect(focusLost)
	table.insert(t9, t1.StateChanged.Event:connect(function(p72) -- line: 1929
		-- upvalues: v263 (copy), clearResults (copy), v262 (copy), s1 (ref)
		v263.Modal = p72

		if not p72 then
			clearResults()
			v262.Text = s1
		end
	end))
	t5[Enum.KeyCode.Escape.Value] = function(p73) -- line: 1937
		-- upvalues: clearResults (copy), v262 (copy), s1 (ref), u54 (ref), t1 (copy)
		if p73 then
			clearResults()
			v262.Text = s1

			return
		end

		if u54 and u54.Visible then
			t1.OpenClose()
		end
	end

	local function detectGamepad(p74) -- line: 1945
		-- upvalues: VRService (copy), v261 (copy)
		if p74 == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
			v261.Visible = false

			return
		end

		v261.Visible = true
	end

	table.insert(t9, UserInputService.LastInputTypeChanged:connect(detectGamepad))

	local function v271(_, p76, _) -- line: 1956
		-- upvalues: GuiService (copy), u80 (ref), t3 (copy)
		if p76 ~= Enum.UserInputState.Begin then
			return
		end

		if not GuiService.SelectedCoreObject then
			return
		end

		for i = 1, u80 do
			if t3[i].Frame == GuiService.SelectedCoreObject and t3[i].Tool then
				t3[i]:MoveToInventory()

				return
			end
		end
	end
	local function openClose() -- line: 1972
		-- upvalues: u54 (ref), t6 (copy), AdjustHotbarFrames (copy), u51 (ref), u80 (ref), t3 (copy), u78 (ref), t2 (copy), UserInputService (copy), resizeGamepadHintsFrame (copy), v258 (copy), ContextActionService (copy), v271 (copy), t1 (copy)
		if not u54 then
			return
		end

		if not next(t6) then
			u54.Visible = not u54.Visible

			local Visible = u54.Visible

			AdjustHotbarFrames()
			u51.Active = not u51.Active

			for i = 1, u80 do
				t3[i]:SetClickability(not Visible)
			end
		end

		if u54.Visible then
			if u78 then
				if t2[UserInputService:GetLastInputType()] then
					resizeGamepadHintsFrame()
					v258.Visible = true
				end

				enableGamepadInventoryControl()
			end
		else
			if u78 then
				v258.Visible = false
			end

			disableGamepadInventoryControl()
		end

		if u54.Visible then
			ContextActionService:BindAction("RBXRemoveSlot", v271, false, Enum.KeyCode.ButtonX)
		else
			ContextActionService:UnbindAction("RBXRemoveSlot")
		end

		t1.IsOpen = u54.Visible
		t1.StateChanged:Fire(u54.Visible)
	end

	t5[BackquoteValue] = function() -- line: 2011
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
	table.insert(t9, UserInputService.TextBoxFocused:connect(function() -- line: 2048
		-- upvalues: u73 (ref)
		u73 = true
	end))
	table.insert(t9, UserInputService.TextBoxFocusReleased:connect(function() -- line: 2054
		-- upvalues: u73 (ref)
		u73 = false
	end))
	t5[BackspaceValue] = function() -- line: 2060
		-- upvalues: u70 (ref), u62 (ref), t4 (copy)
		if u70 and u62 then
			u62:UnequipTools()

			if u70 then
				u70:ToggleSelect()
				t4[u70]:UpdateEquipView()
				u70 = nil
			end
		end
	end
	table.insert(t9, UserInputService.Changed:connect(OnUISChanged))

	local v274 = UserInputService.KeyboardEnabled and not VRService.VREnabled

	for i = 1, u80 do
		t3[i]:TurnNumber(v274)
	end

	if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
		gamepadConnected()
	end

	table.insert(t9, UserInputService.GamepadConnected:connect(function(p78) -- line: 2076
		if p78 == Enum.UserInputType.Gamepad1 then
			gamepadConnected()
		end
	end))
	table.insert(t9, UserInputService.GamepadDisconnected:connect(function(p79) -- line: 2084
		if p79 == Enum.UserInputType.Gamepad1 then
			gamepadDisconnected()
		end
	end))

	if v17 then
		table.insert(t9, SettingsShowSignal:connect(function(p80) -- line: 2095
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

	table.insert(t9, GuiService.MenuOpened:Connect(function() -- line: 2109
		-- upvalues: t1 (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), VRService (copy)
		if t1.IsOpen and (not isInExperienceUIVREnabled or (InExperienceUIVRIXP:isMovePanelToCenter() and true or not VRService.VREnabled)) then
			t1.OpenClose()
		end
	end))
	table.insert(t9, InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p81) -- line: 2125
		-- upvalues: t1 (copy)
		if p81 and t1.IsOpen then
			t1.OpenClose()
		end
	end))

	local function OnPreferredTransparencyChanged() -- line: 2132
		-- upvalues: UserGameSettings (copy), u22 (ref), u54 (ref), u26 (ref), t3 (copy), u32 (ref), v261 (copy)
		local PreferredTransparency = UserGameSettings.PreferredTransparency

		u22 = 0.5 * UserGameSettings.PreferredTransparency

		if u54 then
			u54.BackgroundTransparency = u22
		end

		u26 = 0.5 * PreferredTransparency

		for _, v in ipairs(t3) do
			v.Frame.BackgroundTransparency = u26
		end

		u32 = 0.15 * UserGameSettings.PreferredTransparency
		v261.BackgroundTransparency = u32
	end

	table.insert(t9, UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged))
end
function t1.destroyGui() -- line: 2154
	-- upvalues: t9 (copy), t8 (ref), ContextActionService (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u55 (ref), u56 (ref), u57 (ref), UIGridLayout (ref), u59 (ref), u60 (ref), u61 (ref), u62 (ref), Backpack (ref), u65 (ref), n2 (ref), u70 (ref), u71 (ref), u72 (ref), u73 (ref), u74 (ref), u78 (ref), u47 (ref), n3 (ref), u82 (ref), t1 (copy)
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
		local v282 = t3[i]

		if v282.Tool then
			v282:Clear()
		end
	end

	table.clear(t3)
	table.clear(t4)
	table.clear(t5)
	table.clear(t6)
	table.clear(t7)

	if u50 then
		u50:Destroy()
		u50 = nil
	end

	u51 = nil
	u52 = nil
	u53 = nil
	u54 = nil
	u55 = nil
	u56 = nil
	u57 = nil
	UIGridLayout = nil
	u59 = nil
	u60 = nil
	u61 = nil
	u62 = nil
	Backpack = nil
	u65 = nil
	n2 = 0
	u70 = nil
	u71 = false
	u72 = false
	u73 = false
	u74 = false
	u78 = false
	u47 = false
	n3 = 0
	u82 = nil
	t1.OpenClose = nil
	t1.IsOpen = false
	t1.IsHotbarVisible = false
end
function t1.TopbarEnabledChanged(_, p83) -- line: 2216
	-- upvalues: u46 (ref), setBackpackEnabled (copy), StarterGui (copy)
	u46 = p83
	setBackpackEnabled(StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end

if FFlagTopBarSignalizeSetCores then
	t1.disposeEffect = Signals.createEffect(function(p84) -- line: 2222
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

lifecycle:onEnabledChanged(function(p85) -- line: 2237
	-- upvalues: t1 (copy), setBackpackEnabled (copy)
	if p85 then
		t1.createGui()
	else
		t1.destroyGui()
	end

	setBackpackEnabled(p85)
end)
lifecycle:onVisibilityChanged(function(p86) -- line: 2247
	-- upvalues: t1 (copy)
	if t1.OpenClose and p86 ~= t1.IsOpen then
		t1.OpenClose()
	end

	return t1.IsOpen
end)
t1.StateChanged.Event:connect(function(p87) -- line: 2255
	-- upvalues: lifecycle (copy)
	if lifecycle then
		lifecycle.setVisible(p87)
	end
end)

return t1
