local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Modules = RobloxGui.Modules
local Signals = require(CorePackages.Packages.Signals)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local FFlagBackpackResponsiveUnits = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBackpackResponsiveUnits
local v16 = game:DefineFastFlag("EnableHotbarHide", false)
local v17 = game:DefineFastFlag("SAToolEquipLuauFlag", false)

local function featureSAToolEquipEnabled() -- line: 35
	-- upvalues: v17 (copy)
	if v17 and game:GetEngineFeature("SAToolEquipEngineFeature") then
		return workspace.AuthorityMode == Enum.AuthorityMode.Server
	end

	return false
end

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
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local GameTranslator = require(Modules.GameTranslator)

pcall(function() -- line: 133
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
local u58 = nil
local Backpack = nil
local t3 = {}
local u61 = nil
local t4 = {}
local t5 = {}
local t6 = {}
local n2 = 0
local u66 = nil
local u67 = false
local u68 = false
local u69 = false
local u70 = false
local t7 = {}
local t8 = {}
local u73 = false
local n3 = 0
local u75 = not v48 and 10 or 3
local v76 = not v48 and 4 or 2
local u77 = nil

t1.BackpackEmpty = Create("BindableEvent")({
	Name = "BackpackEmpty"
})
t1.BackpackItemAdded = Create("BindableEvent")({
	Name = "BackpackAdded"
})
t1.BackpackItemRemoved = Create("BindableEvent")({
	Name = "BackpackRemoved"
})

local function NewGui(p1, p2) -- line: 206
	-- upvalues: Size14 (ref)
	local v141 = Instance.new(p1)

	v141.Name = p2
	v141.BackgroundColor3 = Color3.new(0, 0, 0)
	v141.BackgroundTransparency = 1
	v141.BorderColor3 = Color3.new(0, 0, 0)
	v141.BorderSizePixel = 0
	v141.Size = UDim2.new(1, 0, 1, 0)

	if p1:match("Text") then
		v141.TextColor3 = Color3.new(1, 1, 1)
		v141.Text = ""
		v141.Font = Enum.Font.SourceSans
		v141.FontSize = Size14
		v141.TextWrapped = true

		if p1 == "TextButton" then
			v141.Font = Enum.Font.SourceSansBold
			v141.BorderSizePixel = 1
		end
	end

	return v141
end
local function FindLowestEmpty() -- line: 228
	-- upvalues: u75 (ref), t3 (copy)
	for i = 1, u75 do
		local v143 = t3[i]

		if not v143.Tool then
			return v143
		end
	end

	return nil
end
local function isInventoryEmpty() -- line: 238
	-- upvalues: u75 (ref), t3 (copy)
	for i = u75 + 1, #t3 do
		local v145 = t3[i]

		if v145 and v145.Tool then
			return false
		end
	end

	return true
end

t1.IsInventoryEmpty = isInventoryEmpty

local function UseGazeSelection() -- line: 250
	return false
end
local function AdjustHotbarFrames(p3) -- line: 254
	-- upvalues: u53 (ref), u75 (ref), n2 (ref), v16 (copy), t3 (copy), u52 (ref), t1 (copy)
	local Visible = u53.Visible
	local v148 = Visible and u75 or n2
	local n4 = 0
	local v150 = if not v16 then v148 >= 1 else v148 >= 1 and not p3
	local g158 = nil
	local v157 = nil

	for i = 1, u75 do
		local v152 = t3[i]

		if ((if not v16 then v152.Tool else v152.Tool and not p3)) or Visible then
			n4 += 1
			v152:Readjust(n4, v148)
			v152.Frame.Visible = true
		else
			v152.Frame.Visible = false
		end
	end

	local v153 = u52
	local v154 = not Visible

	if v154 then
		v154 = v150

		if not v154 then
			for i = u75 + 1, #t3 do
				local v156 = t3[i]

				if v156 and v156.Tool then
					v157 = false
					g158 = true
				end

				if g158 then
					break
				end
			end

			if not g158 then
				v157 = true
			end

			g158 = false
			v154 = not v157
		end
	end

	v153.Visible = v154
	u52.Position = UDim2.new(0.5, -15, 1, not v150 and -50 or -110)
	t1.IsHotbarVisible = v150
end
local function UpdateScrollingFrameCanvasSize() -- line: 277
	-- upvalues: u55 (ref), n1 (ref), u56 (ref)
	local v159 = math.floor(u55.AbsoluteSize.X / (n1 + 5))
	local v160 = math.ceil((#u56:GetChildren() - 1) / v159) * (n1 + 5) + 5

	u55.CanvasSize = UDim2.new(0, 0, 0, v160)
end
local function AdjustInventoryFrames() -- line: 284
	-- upvalues: u75 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
	for i = u75 + 1, #t3 do
		local v162 = t3[i]

		v162.Frame.LayoutOrder = v162.Index
		v162.Frame.Visible = v162.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end
local function UpdateBackpackLayout() -- line: 293
	-- upvalues: u51 (ref), u75 (ref), n1 (ref), u53 (ref), v76 (copy), u55 (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy)
	u51.Size = UDim2.new(0, 5 + u75 * (n1 + 5), 0, n1 + 5 + 5)
	u51.Position = UDim2.new(0.5, -u51.Size.X.Offset / 2, 1, -u51.Size.Y.Offset)
	u53.Size = UDim2.new(0, u51.Size.X.Offset, 0, u51.Size.Y.Offset * v76 + 40)
	u53.Position = UDim2.new(0.5, -u53.Size.X.Offset / 2, 1, u51.Position.Y.Offset - u53.Size.Y.Offset)
	u55.Size = UDim2.new(1, u55.ScrollBarThickness + 1, 1, -40)
	u55.Position = UDim2.new(0, 0, 0, 40)
	AdjustHotbarFrames()
	AdjustInventoryFrames()
end
local function Clamp(p4, p5, p6) -- line: 305
	return (math.min(p5, (math.max(p4, p6))))
end
local function CheckBounds(p7, p8, p9) -- line: 309
	local AbsolutePosition = p7.AbsolutePosition
	local AbsoluteSize = p7.AbsoluteSize

	return p8 > AbsolutePosition.X and (p8 <= AbsolutePosition.X + AbsoluteSize.X and (p9 > AbsolutePosition.Y and p9 <= AbsolutePosition.Y + AbsoluteSize.Y))
end
local function GetOffset(p10, p11) -- line: 315
	return (p10.AbsolutePosition + p10.AbsoluteSize / 2 - p11).magnitude
end
local function DisableActiveHopper() -- line: 320
	-- upvalues: u66 (ref), t4 (copy)
	u66:ToggleSelect()
	t4[u66]:UpdateEquipView()
	u66 = nil
end
local function UnequipAllTools() -- line: 326
	-- upvalues: u58 (ref), u66 (ref), t4 (copy)
	if u58 then
		u58:UnequipTools()

		if u66 then
			u66:ToggleSelect()
			t4[u66]:UpdateEquipView()
			u66 = nil
		end
	end
end
local function EquipNewTool(p12) -- line: 335
	-- upvalues: u58 (ref), u66 (ref), t4 (copy), v17 (copy), LocalPlayer (ref), u57 (ref)
	if u58 then
		u58:UnequipTools()

		if u66 then
			u66:ToggleSelect()
			t4[u66]:UpdateEquipView()
			u66 = nil
		end
	end

	if p12:IsA("HopperBin") then
		p12:ToggleSelect()
		t4[p12]:UpdateEquipView()
		u66 = p12

		return
	end

	if not not v17 and (not not game:GetEngineFeature("SAToolEquipEngineFeature") and workspace.AuthorityMode == Enum.AuthorityMode.Server) then
		LocalPlayer:RequestTool(p12)
	end

	p12.Parent = u57
end
local function IsEquipped(p13) -- line: 351
	-- upvalues: u57 (ref)
	return p13 and (p13:IsA("HopperBin") and p13.Active or p13.Parent == u57)
end
local function MakeSlot(p14, p15) -- line: 355
	-- upvalues: t3 (copy), u26 (ref), color3_2 (copy), color3 (copy), u51 (ref), n1 (ref), GameTranslator (copy), u75 (ref), u53 (ref), n2 (ref), u68 (ref), u47 (ref), ContextActionService (copy), t4 (copy), u61 (ref), u57 (ref), u77 (ref), NewGui (copy), color3_3 (copy), t6 (copy), UpdateScrollingFrameCanvasSize (copy), v17 (copy), LocalPlayer (ref), u58 (ref), u66 (ref), Backpack (ref), EquipNewTool (copy), color3_4 (copy), MakeSlot (copy), u56 (ref), u70 (ref), t5 (copy), ZeroValue (copy), u55 (ref)
	local v177 = p15 or #t3 + 1
	local t9 = {
		Tool = nil,
		Index = v177,
		Frame = nil
	}
	local u179 = nil
	local u180 = nil
	local u181 = nil
	local u182 = nil
	local u183 = nil
	local u184 = nil
	local u185 = nil
	local u186 = nil

	local function UpdateSlotFading() -- line: 380
		-- upvalues: u179 (ref), u26 (ref), color3_2 (copy), color3 (copy)
		u179.SelectionImageObject = nil
		u179.BackgroundTransparency = if not u179.Draggable then u26 else 0
		u179.BackgroundColor3 = u179.Draggable and color3_2 or color3
	end

	function t9.Readjust(_, p17, p18) -- line: 386
		-- upvalues: u51 (ref), n1 (ref), u179 (ref)
		local v324 = u51.Size.X.Offset / 2
		local v325 = n1 + 5
		local v326 = p17 - (p18 / 2 + 0.5)

		u179.Position = UDim2.new(0, v324 - n1 / 2 + v325 * v326, 0, 5)
	end
	function t9.Fill(p19, p20) -- line: 394
		-- upvalues: u181 (ref), u182 (ref), GameTranslator (copy), u185 (ref), u183 (ref), u75 (ref), u53 (ref), u179 (ref), n2 (ref), u68 (ref), u47 (ref), ContextActionService (copy), t4 (copy), u61 (ref), t3 (copy)
		if not p20 then
			return p19:Clear()
		end

		p19.Tool = p20

		local function assignToolData() -- line: 401
			-- upvalues: p20 (copy), u181 (ref), u182 (ref), GameTranslator (copy), u185 (ref)
			local TextureId = p20.TextureId

			u181.Image = TextureId

			if TextureId ~= "" then
				u182.Visible = false
			else
				u182.Visible = true
			end

			GameTranslator:TranslateAndRegister(u182, p20, p20.Name)

			if u185 and p20:IsA("Tool") then
				GameTranslator:TranslateAndRegister(u185, p20, p20.ToolTip)

				local v415 = u185.TextBounds.X + 6

				u185.Size = UDim2.new(0, v415, 0, 16)
				u185.Position = UDim2.new(0.5, -v415 / 2, 0, -25)
			end
		end

		assignToolData()

		local g334 = nil
		local v333 = nil

		if u183 then
			u183:disconnect()
			u183 = nil
		end

		u183 = p20.Changed:connect(function(p21) -- line: 427
			-- upvalues: assignToolData (copy)
			if p21 == "TextureId" or (p21 == "Name" or p21 == "ToolTip") then
				assignToolData()
			end
		end)

		local v330 = p19.Index <= u75
		local Visible = u53.Visible

		if not v330 or Visible then
			u179.Draggable = true
		end

		p19:UpdateEquipView()

		if v330 then
			n2 += 1

			if u68 and n2 >= 1 and not u47 then
				u47 = true
				ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
			end
		end

		t4[p20] = p19

		for i = 1, u75 do
			v333 = t3[i]

			if not v333.Tool then
				g334 = true
			end

			if g334 then
				break
			end
		end

		if not g334 then
			v333 = nil
		end

		g334 = false
		u61 = v333
	end
	function t9.Clear(p22) -- line: 458
		-- upvalues: u183 (ref), u181 (ref), u182 (ref), u185 (ref), u179 (ref), u75 (ref), n2 (ref), u47 (ref), ContextActionService (copy), t4 (copy), u61 (ref), t3 (copy)
		if not p22.Tool then
			return
		end

		local g338 = nil
		local v337 = nil

		if u183 then
			u183:disconnect()
			u183 = nil
		end

		u181.Image = ""
		u182.Text = ""

		if u185 then
			u185.Text = ""
			u185.Visible = false
		end

		u179.Draggable = false
		p22:UpdateEquipView(true)

		if p22.Index <= u75 then
			n2 -= 1

			if n2 < 1 then
				u47 = false
				ContextActionService:UnbindAction("RBXHotbarEquip")
			end
		end

		t4[p22.Tool] = nil
		p22.Tool = nil

		for i = 1, u75 do
			v337 = t3[i]

			if not v337.Tool then
				g338 = true
			end

			if g338 then
				break
			end
		end

		if not g338 then
			v337 = nil
		end

		g338 = false
		u61 = v337
	end
	function t9.UpdateEquipView(p23, p24) -- line: 489
		-- upvalues: u57 (ref), u77 (ref), t9 (copy), u184 (ref), NewGui (copy), u179 (ref), color3_3 (copy), u26 (ref), color3_2 (copy), color3 (copy)
		local g341 = nil
		local Tool = nil

		repeat
			if g341 or not p24 then
				if not g341 then
					Tool = p23.Tool
				end

				if g341 or Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u57) then
					if not g341 then
						u77 = t9

						if not u184 then
							u184 = NewGui("Frame", "Equipped")
							u184.ZIndex = u179.ZIndex

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
								local v345 = NewGui("Frame", "Edge")

								v345.BackgroundTransparency = 0
								v345.BackgroundColor3 = color3_3
								v345.Size = UDim2.new(v[1], 0, v[2], 0)
								v345.Position = UDim2.new(v[3], 0, v[4], 0)
								v345.ZIndex = u184.ZIndex
								v345.Parent = u184
							end
						end

						u184.Parent = u179
					end

					g341 = false
					u179.SelectionImageObject = nil
					u179.BackgroundTransparency = if not u179.Draggable then u26 else 0
					u179.BackgroundColor3 = u179.Draggable and color3_2 or color3

					return
				end
			end

			if u184 then
				u184.Parent = nil
			end

			g341 = true
		until not g341
	end
	function t9.IsEquipped(p25) -- line: 521
		-- upvalues: u57 (ref)
		local Tool = p25.Tool

		return Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u57)
	end
	function t9.Delete(p26) -- line: 525
		-- upvalues: t6 (copy), u179 (ref), t3 (copy), UpdateScrollingFrameCanvasSize (copy)
		t6[u179] = nil
		u179:Destroy()
		table.remove(t3, p26.Index)

		local v349 = #t3

		for i = p26.Index, v349 do
			t3[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end
	function t9.Swap(p27, p28) -- line: 539
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
	function t9.SlideBack(p29) -- line: 553
		-- upvalues: u179 (ref)
		p29.Index = p29.Index - 1
		u179.Name = p29.Index
		u179.LayoutOrder = p29.Index
	end
	function t9.TurnNumber(_, p31) -- line: 559
		-- upvalues: u186 (ref)
		if u186 then
			u186.Visible = p31
		end
	end
	function t9.SetClickability(p32, p33) -- line: 565
		-- upvalues: u179 (ref), u26 (ref), color3_2 (copy), color3 (copy)
		if p32.Tool then
			u179.Draggable = not p33
			u179.SelectionImageObject = nil
			u179.BackgroundTransparency = if not u179.Draggable then u26 else 0
			u179.BackgroundColor3 = u179.Draggable and color3_2 or color3
		end
	end
	function t9.CheckTerms(p34, p35) -- line: 572
		-- upvalues: u182 (ref), u185 (ref)
		local n5 = 0

		local function checkEm(p36, p37) -- line: 574
			-- upvalues: n5 (ref)
			local _, count = p36:lower():gsub(p37, "")

			n5 += count
		end

		local Tool = p34.Tool

		if Tool then
			for k in pairs(p35) do
				local _, count = u182.Text:lower():gsub(k, "")

				n5 += count

				if Tool:IsA("Tool") then
					local _, count2 = (u185 and u185.Text or ""):lower():gsub(k, "")

					n5 += count2
				end
			end
		end

		return n5
	end
	function t9.Select(_, p39) -- line: 592
		-- upvalues: t9 (copy), u57 (ref), v17 (copy), LocalPlayer (ref), u58 (ref), u66 (ref), t4 (copy), Backpack (ref), EquipNewTool (copy)
		if p39 then
			return
		end

		local Tool = t9.Tool

		if Tool then
			if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u57) then
				if not not v17 and (not not game:GetEngineFeature("SAToolEquipEngineFeature") and workspace.AuthorityMode == Enum.AuthorityMode.Server) and not Tool:IsA("HopperBin") then
					LocalPlayer:RequestTool(nil)
				end

				if u58 then
					u58:UnequipTools()

					if u66 then
						u66:ToggleSelect()
						t4[u66]:UpdateEquipView()
						u66 = nil

						return
					end
				end
			elseif Tool.Parent == Backpack then
				EquipNewTool(Tool)
			end
		end
	end

	u179 = NewGui("TextButton", v177)
	u179.BackgroundColor3 = color3
	u179.BorderColor3 = color3_4
	u179.Text = ""
	u179.AutoButtonColor = false
	u179.BorderSizePixel = 0
	u179.Size = UDim2.new(0, n1, 0, n1)
	u179.Active = true
	u179.Draggable = false
	u179.BackgroundTransparency = u26
	u179.MouseButton1Click:connect(function() -- line: 622
		-- upvalues: t9 (copy)
		changeSlot(t9)
	end)
	t9.Frame = u179

	local v188 = NewGui("Frame", "SelectionObjectClipper")

	v188.Visible = false
	v188.Parent = u179

	local v189 = NewGui("ImageLabel", "Selector")

	v189.Size = UDim2.new(1, 0, 1, 0)
	v189.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	v189.ScaleType = Enum.ScaleType.Slice
	v189.SliceCenter = Rect.new(12, 12, 52, 52)
	v189.Parent = v188
	u181 = NewGui("ImageLabel", "Icon")
	u181.Size = UDim2.new(0.8, 0, 0.8, 0)
	u181.Position = UDim2.new(0.1, 0, 0.1, 0)
	u181.Parent = u179
	u182 = NewGui("TextLabel", "ToolName")
	u182.Size = UDim2.new(1, -2, 1, -2)
	u182.Position = UDim2.new(0, 1, 0, 1)
	u182.Parent = u179
	t9.Frame.LayoutOrder = t9.Index

	if v177 <= u75 then
		u185 = NewGui("TextLabel", "ToolTip")
		u185.TextWrapped = false
		u185.TextYAlignment = Enum.TextYAlignment.Top
		u185.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		u185.BackgroundTransparency = 0
		u185.Visible = false
		u185.Parent = u179
		u179.MouseEnter:connect(function() -- line: 660
			-- upvalues: u185 (ref)
			if u185.Text ~= "" then
				u185.Visible = true
			end
		end)
		u179.MouseLeave:connect(function() -- line: 665
			-- upvalues: u185 (ref)
			u185.Visible = false
		end)

		function t9.MoveToInventory(p40) -- line: 667
			-- upvalues: t9 (copy), u75 (ref), MakeSlot (copy), u56 (ref), u57 (ref), u58 (ref), u66 (ref), t4 (copy), u70 (ref), u53 (ref)
			if t9.Index <= u75 then
				local Tool = t9.Tool

				p40:Clear()

				local v375 = MakeSlot(u56)

				v375:Fill(Tool)

				if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u57) and u58 then
					u58:UnequipTools()

					if u66 then
						u66:ToggleSelect()
						t4[u66]:UpdateEquipView()
						u66 = nil
					end
				end

				if u70 then
					v375.Frame.Visible = false
					v375.Parent = u53
				end
			end
		end

		if v177 < 10 or v177 == u75 then
			local v190 = v177 < 10 and v177 or 0

			u186 = NewGui("TextLabel", "Number")
			u186.Text = v190
			u186.Size = UDim2.new(0.15, 0, 0.15, 0)
			u186.Visible = false
			u186.Parent = u179
			t5[ZeroValue + v190] = function(p41) -- line: 693
				-- upvalues: t9 (copy)
				t9:Select(p41)
			end
		end
	end

	local Position = u179.Position
	local n6 = 0
	local Parent = nil

	u179.DragBegin:connect(function(p42) -- line: 704
		-- upvalues: t6 (copy), u179 (ref), Position (ref), u181 (ref), u182 (ref), u186 (ref), u184 (ref), Parent (ref), u56 (ref), u53 (ref), u180 (ref), NewGui (copy)
		t6[u179] = true
		Position = p42
		u179.BorderSizePixel = 2
		u179.ZIndex = 2
		u181.ZIndex = 2
		u182.ZIndex = 2
		u179.Parent.ZIndex = 2

		if u186 then
			u186.ZIndex = 2
		end

		if u184 then
			u184.ZIndex = 2

			for _, child in pairs(u184:GetChildren()) do
				child.ZIndex = 2
			end
		end

		Parent = u179.Parent

		if Parent == u56 then
			local _ = u179.AbsolutePosition
			local uDim2 = UDim2.new(0, u179.AbsolutePosition.X - u53.AbsolutePosition.X, 0, u179.AbsolutePosition.Y - u53.AbsolutePosition.Y)

			u179.Parent = u53
			u179.Position = uDim2
			u180 = NewGui("Frame", "FakeSlot")
			u180.LayoutOrder = u179.LayoutOrder
			u180.Size = u179.Size
			u180.BackgroundTransparency = 1
			u180.Parent = u56
		end
	end)
	u179.DragStopped:connect(function(p43, p44) -- line: 742
		-- upvalues: u180 (ref), u179 (ref), Position (ref), Parent (ref), u181 (ref), u182 (ref), u186 (ref), u184 (ref), t6 (copy), t9 (copy), u53 (ref), u75 (ref), n6 (ref), u61 (ref), u51 (ref), t3 (copy), u57 (ref), u58 (ref), u66 (ref), t4 (copy), u70 (ref)
		if u180 then
			u180:Destroy()
		end

		local timestamp = tick()

		u179.Position = Position
		u179.Parent = Parent
		u179.BorderSizePixel = 0
		u179.ZIndex = 1
		u181.ZIndex = 1
		u182.ZIndex = 1
		Parent.ZIndex = 1

		if u186 then
			u186.ZIndex = 1
		end

		if u184 then
			u184.ZIndex = 1

			for _, child in pairs(u184:GetChildren()) do
				child.ZIndex = 1
			end
		end

		t6[u179] = nil

		if not t9.Tool then
			return
		end

		local v387 = u53
		local AbsolutePosition = v387.AbsolutePosition
		local AbsoluteSize = v387.AbsoluteSize

		if p43 > AbsolutePosition.X and (p43 <= AbsolutePosition.X + AbsoluteSize.X and (p44 > AbsolutePosition.Y and p44 <= AbsolutePosition.Y + AbsoluteSize.Y)) then
			if t9.Index <= u75 then
				t9:MoveToInventory()
			end

			if t9.Index > u75 and timestamp - n6 < 0.5 then
				if u61 then
					local Tool = t9.Tool

					t9:Clear()
					u61:Fill(Tool)
					t9:Delete()
				end

				timestamp = 0
			end
		else
			local v391 = u51
			local AbsolutePosition2 = v391.AbsolutePosition
			local AbsoluteSize2 = v391.AbsoluteSize

			if p43 > AbsolutePosition2.X and (p43 <= AbsolutePosition2.X + AbsoluteSize2.X and (p44 > AbsolutePosition2.Y and p44 <= AbsolutePosition2.Y + AbsoluteSize2.Y)) then
				local t10 = {
					1e999,
					nil
				}

				for i = 1, u75 do
					local v396 = t3[i]
					local Frame = v396.Frame
					local vector2 = Vector2.new(p43, p44)
					local magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - vector2).magnitude

					if magnitude < t10[1] then
						t10 = {
							magnitude,
							v396
						}
					end
				end

				local v400 = t10[2]

				if v400 ~= t9 then
					t9:Swap(v400)

					if t9.Index > u75 then
						local Tool = t9.Tool

						if not Tool then
							t9:Delete()
						else
							if Tool and (Tool:IsA("HopperBin") and Tool.Active or Tool.Parent == u57) and u58 then
								u58:UnequipTools()

								if u66 then
									u66:ToggleSelect()
									t4[u66]:UpdateEquipView()
									u66 = nil
								end
							end

							if u70 then
								t9.Frame.Visible = false
								t9.Frame.Parent = u53
							end
						end
					end
				end
			elseif t9.Index <= u75 then
				t9:MoveToInventory()
			end
		end

		n6 = timestamp
	end)
	u179.Parent = p14
	t3[v177] = t9

	if v177 > u75 then
		UpdateScrollingFrameCanvasSize()

		if u53.Visible and not u70 then
			local v194 = u55.CanvasSize.Y.Offset - u55.AbsoluteSize.Y

			u55.CanvasPosition = Vector2.new(0, (math.max(0, v194)))
		end
	end

	return t9
end
local function SetNumberOfHotbarSlots(p45) -- line: 851
	-- upvalues: u75 (ref), t3 (copy), MakeSlot (copy), u51 (ref), u61 (ref), n2 (ref), UpdateBackpackLayout (copy)
	if p45 ~= u75 then
		local v196 = u75

		if p45 < v196 then
			for i = v196, p45 + 1, -1 do
				local v198 = t3[i]

				if v198 then
					v198:MoveToInventory()
					v198:Delete()
				end
			end

			for i = v196, p45 + 1, -1 do
				local v200 = t3[i]

				if not v200.Tool then
					v200:Delete()
				end
			end
		else
			for i = v196, p45 do
				u75 = i

				if t3[i] then
					local _ = t3[i]
					local Tool = t3[i].Tool
					local v204 = MakeSlot(u51, i)

					if Tool then
						v204:Fill(Tool)
					elseif not u61 then
						u61 = v204
					end
				else
					local v205 = MakeSlot(u51, i)

					v205.Frame.Visible = false

					if not u61 then
						u61 = v205
					end
				end
			end
		end

		u75 = p45
		n2 = 0

		for i = 1, u75 do
			if t3[i] and t3[i].Tool then
				n2 += 1
			end
		end

		UpdateBackpackLayout()
	end
end
local function OnChildAdded(p46) -- line: 913
	-- upvalues: u57 (ref), u58 (ref), n3 (ref), u66 (ref), t4 (copy), u67 (ref), LocalPlayer (ref), u61 (ref), MakeSlot (copy), u56 (ref), t3 (copy), Backpack (ref), AdjustHotbarFrames (copy), u75 (ref), u53 (ref), t1 (copy)
	if not p46:IsA("Tool") and not p46:IsA("HopperBin") then
		if p46:IsA("Humanoid") and p46.Parent == u57 then
			u58 = p46
		end

		return
	end

	if p46.Parent == u57 then
		n3 = tick()
	end

	if u66 and p46.Parent == u57 then
		u66:ToggleSelect()
		t4[u66]:UpdateEquipView()
		u66 = nil
	end

	if not u67 and p46.Parent == u57 and not t4[p46] then
		local StarterGear = LocalPlayer:FindFirstChild("StarterGear")

		if StarterGear and StarterGear:FindFirstChild(p46.Name) then
			u67 = true

			for i = (u61 or MakeSlot(u56)).Index, 1, -1 do
				local v210 = t3[i]
				local v211 = i - 1

				if v211 > 0 then
					t3[v211]:Swap(v210)
				else
					v210:Fill(p46)
				end
			end

			for _, child in pairs(u57:GetChildren()) do
				if child:IsA("Tool") and child ~= p46 then
					child.Parent = Backpack
				end
			end

			AdjustHotbarFrames()

			return
		end
	end

	local v214 = t4[p46]

	if v214 then
		v214:UpdateEquipView()
	else
		local v215 = u61 or MakeSlot(u56)

		v215:Fill(p46)

		if v215.Index <= u75 and not u53.Visible then
			AdjustHotbarFrames()
		end

		if p46:IsA("HopperBin") and p46.Active then
			if u58 then
				u58:UnequipTools()

				if u66 then
					u66:ToggleSelect()
					t4[u66]:UpdateEquipView()
					u66 = nil
				end
			end

			u66 = p46
		end
	end

	t1.BackpackItemAdded:Fire()
end
local function OnChildRemoved(p47) -- line: 980
	-- upvalues: n3 (ref), u57 (ref), Backpack (ref), t4 (copy), u75 (ref), u53 (ref), AdjustHotbarFrames (copy), u66 (ref), t1 (copy), t3 (copy)
	if not p47:IsA("Tool") and not p47:IsA("HopperBin") then
		return
	end

	n3 = tick()

	local p47Parent = p47.Parent

	if p47Parent == u57 or p47Parent == Backpack then
		return
	end

	local v218 = t4[p47]
	local g222 = nil
	local v221 = nil

	if v218 then
		v218:Clear()

		if v218.Index > u75 then
			v218:Delete()
		elseif not u53.Visible then
			AdjustHotbarFrames()
		end
	end

	if p47 == u66 then
		u66 = nil
	end

	t1.BackpackItemRemoved:Fire()

	for i = u75 + 1, #t3 do
		local v220 = t3[i]

		if v220 and v220.Tool then
			v221 = false
			g222 = true
		end

		if g222 then
			break
		end
	end

	if not g222 then
		v221 = true
	end

	g222 = false

	if v221 then
		t1.BackpackEmpty:Fire()
	end
end
local function OnCharacterAdded(p48) -- line: 1014
	-- upvalues: t3 (copy), u75 (ref), u66 (ref), t8 (ref), u57 (ref), OnChildRemoved (copy), OnChildAdded (copy), Backpack (ref), LocalPlayer (ref), AdjustHotbarFrames (copy)
	for i = #t3, 1, -1 do
		local v225 = t3[i]

		if v225.Tool then
			v225:Clear()
		end

		if i > u75 then
			v225:Delete()
		end
	end

	u66 = nil

	for _, v in pairs(t8) do
		v:disconnect()
	end

	t8 = {}
	u57 = p48
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
local function OnInputBegan(p49, p50) -- line: 1053
	-- upvalues: u69 (ref), u68 (ref), BackspaceValue (copy), t5 (copy), u53 (ref), t1 (copy)
	if p49.UserInputType == Enum.UserInputType.Keyboard and not u69 and (u68 or p49.KeyCode.Value == BackspaceValue) then
		local v234 = t5[p49.KeyCode.Value]

		if v234 then
			v234(p50)
		end
	end

	local UserInputType = p49.UserInputType

	if not p50 and ((UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and u53.Visible) then
		t1.OpenClose()
	end
end
local function OnUISChanged(p51) -- line: 1072
	-- upvalues: UserInputService (copy), VRService (copy), u75 (ref), t3 (copy)
	if p51 == "KeyboardEnabled" or p51 == "VREnabled" then
		local v237 = UserInputService.KeyboardEnabled and not VRService.VREnabled

		for i = 1, u75 do
			t3[i]:TurnNumber(v237)
		end
	end
end

local u100 = nil
local timestamp = nil

local function v102() -- line: 1084
end

local vector2 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions() -- line: 1088
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
	ContextActionService:UnbindAction("RBXCloseInventory")
end

local function setHotbarVisibility(p52, p53) -- line: 1093
	-- upvalues: u75 (ref), t3 (copy)
	for i = 1, u75 do
		local v242 = t3[i]

		if v242 and v242.Frame and (p53 or v242.Tool) then
			v242.Frame.Visible = p52
		end
	end
end
local function getInputDirection(p54) -- line: 1102
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

function changeToolFunc(_, p56, p57) -- line: 1163
	-- upvalues: u100 (ref), timestamp (ref), u58 (ref), u66 (ref), t4 (copy), u75 (ref), t3 (copy), u77 (ref)
	if p56 ~= Enum.UserInputState.Begin then
		return
	end

	if u100 and ((u100.KeyCode == Enum.KeyCode.ButtonR1 and p57.KeyCode == Enum.KeyCode.ButtonL1 or u100.KeyCode == Enum.KeyCode.ButtonL1 and p57.KeyCode == Enum.KeyCode.ButtonR1) and tick() - timestamp <= 0.06) then
		if u58 then
			u58:UnequipTools()

			if u66 then
				u66:ToggleSelect()
				t4[u66]:UpdateEquipView()
				u66 = nil
			end
		end

		u100 = p57
		timestamp = tick()

		return
	end

	u100 = p57
	timestamp = tick()
	delay(0.06, function() -- line: 1183
		-- upvalues: u100 (ref), p57 (copy), u75 (ref), t3 (copy), u58 (ref), u66 (ref), t4 (copy), u77 (ref)
		if u100 ~= p57 then
			return
		end

		local v402 = p57.KeyCode ~= Enum.KeyCode.ButtonL1 and 1 or -1

		for i = 1, u75 do
			if t3[i]:IsEquipped() then
				local v404 = v402 + i
				local v405 = false

				if v404 > u75 then
					v404 = 1
					v405 = true
				elseif v404 < 1 then
					v404 = u75
					v405 = true
				end

				local v406 = v404

				while not t3[v406].Tool do
					v406 += v402

					if v406 == v404 then
						return
					end

					if v406 > u75 then
						v406 = 1
						v405 = true
					elseif v406 < 1 then
						v406 = u75
						v405 = true
					end
				end

				if v405 then
					if u58 then
						u58:UnequipTools()

						if u66 then
							u66:ToggleSelect()
							t4[u66]:UpdateEquipView()
							u66 = nil
						end
					end

					u77 = nil

					return
				end

				t3[v406]:Select()

				return
			end
		end

		if u77 and u77.Tool then
			u77:Select()

			return
		end

		for i = v402 == -1 and u75 or 1, if v402 ~= -1 then u75 else 1, v402 do
			if t3[i].Tool then
				t3[i]:Select()

				return
			end
		end
	end)
end
function getGamepadSwapSlot() -- line: 1247
	-- upvalues: t3 (copy)
	for i = 1, #t3 do
		if t3[i].Frame.BorderSizePixel > 0 then
			return t3[i]
		end
	end
end
function changeSlot(p58) -- line: 1255
	-- upvalues: GamepadService (copy), GuiService (copy), u54 (ref), u75 (ref)
	local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if p58.Frame == GuiService.SelectedCoreObject and not GamepadCursorEnabled then
		local v259 = getGamepadSwapSlot()

		if not v259 then
			local FrameSize = p58.Frame.Size
			local FramePosition = p58.Frame.Position

			p58.Frame:TweenSizeAndPositionInternal(FrameSize + UDim2.new(0, 10, 0, 10), FramePosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 1284
				-- upvalues: p58 (copy), FrameSize (copy), FramePosition (copy)
				p58.Frame:TweenSizeAndPositionInternal(FrameSize, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
			end)
			p58.Frame.BorderSizePixel = 3
			u54.SelectionImageObject.Visible = true

			return
		end

		v259.Frame.BorderSizePixel = 0

		if v259 ~= p58 then
			p58:Swap(v259)
			u54.SelectionImageObject.Visible = false

			if p58.Index > u75 and not p58.Tool then
				if GuiService.SelectedCoreObject == p58.Frame then
					GuiService.SelectedCoreObject = v259.Frame
				end

				p58:Delete()
			end

			if v259.Index > u75 and not v259.Tool then
				if GuiService.SelectedCoreObject == v259.Frame then
					GuiService.SelectedCoreObject = p58.Frame
				end

				v259:Delete()

				return
			end
		end
	else
		p58:Select()
		u54.SelectionImageObject.Visible = false
	end
end
function enableGamepadInventoryControl() -- line: 1294
	-- upvalues: u53 (ref), t1 (copy), ContextActionService (copy), v102 (copy), GuiService (copy), u51 (ref)
	ContextActionService:BindAction("RBXBackpackHasGamepadFocus", v102, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("RBXCloseInventory", function(_, inputState, _) -- line: 1295
		-- upvalues: u53 (ref), t1 (copy)
		if inputState ~= Enum.UserInputState.Begin then
			return
		end

		if getGamepadSwapSlot() then
			local v411 = getGamepadSwapSlot()

			if v411 then
				v411.Frame.BorderSizePixel = 0

				return
			end
		elseif u53.Visible then
			t1.OpenClose()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

	if not false then
		GuiService.SelectedCoreObject = u51:FindFirstChild("1")
	end
end
function disableGamepadInventoryControl() -- line: 1320
	-- upvalues: u75 (ref), t3 (copy), GuiService (copy), u50 (ref)
	unbindAllGamepadEquipActions()

	for i = 1, u75 do
		local v263 = t3[i]

		if v263 and v263.Frame then
			v263.Frame.BorderSizePixel = 0
		end
	end

	if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(u50) then
		GuiService.SelectedCoreObject = nil
	end
end

local function bindBackpackHotbarAction() -- line: 1336
	-- upvalues: u68 (ref), u47 (ref), ContextActionService (copy)
	if u68 and not u47 then
		u47 = true
		ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
	end
end
local function unbindBackpackHotbarAction() -- line: 1343
	-- upvalues: u47 (ref), ContextActionService (copy)
	disableGamepadInventoryControl()
	u47 = false
	ContextActionService:UnbindAction("RBXHotbarEquip")
end

function gamepadDisconnected() -- line: 1349
	-- upvalues: VRService (copy), u73 (ref)
	if not VRService.VREnabled then
		u73 = false
		disableGamepadInventoryControl()
	end
end
function gamepadConnected() -- line: 1356
	-- upvalues: VRService (copy), u73 (ref), GuiService (copy), u50 (ref), n2 (ref), u68 (ref), u47 (ref), ContextActionService (copy), u53 (ref)
	if not VRService.VREnabled then
		u73 = true
		GuiService:AddSelectionParent("RBXBackpackSelection", u50)

		if n2 >= 1 and u68 and not u47 then
			u47 = true
			ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end

		if u53.Visible then
			enableGamepadInventoryControl()
		end
	end
end

local function OnCoreGuiChanged(p61, p62) -- line: 1371
	-- upvalues: u46 (ref), u68 (ref), FFlagMountCoreGuiBackpack (copy), u50 (ref), RobloxGui (copy), t7 (copy), GuiService (copy), n2 (ref), u47 (ref), ContextActionService (copy)
	if p61 == Enum.CoreGuiType.Backpack or p61 == Enum.CoreGuiType.All then
		local v266 = p62 and u46

		u68 = v266

		if FFlagMountCoreGuiBackpack then
			if v266 then
				u50.Parent = RobloxGui
			else
				u50.Parent = nil
			end
		else
			u50.Visible = v266
		end

		for _, v in pairs(t7) do
			if v266 then
				GuiService:AddKey(v)
			else
				GuiService:RemoveKey(v)
			end
		end

		if v266 then
			if n2 >= 1 and u68 and not u47 then
				u47 = true
				ContextActionService:BindAction("RBXHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)

				return
			end
		else
			disableGamepadInventoryControl()
			u47 = false
			ContextActionService:UnbindAction("RBXHotbarEquip")
		end
	end
end
local function MakeVRRoundButton(p63, p64) -- line: 1406
	-- upvalues: NewGui (copy)
	local v271 = NewGui("ImageButton", p63)

	v271.Size = UDim2.new(0, 40, 0, 40)
	v271.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local v272 = NewGui("ImageLabel", "Icon")

	v272.Size = UDim2.new(0.5, 0, 0.5, 0)
	v272.Position = UDim2.new(0.25, 0, 0.25, 0)
	v272.Image = p64
	v272.Parent = v271

	local v273 = NewGui("ImageLabel", "Selection")

	v273.Size = UDim2.new(0.9, 0, 0.9, 0)
	v273.Position = UDim2.new(0.05, 0, 0.05, 0)
	v273.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	v271.SelectionImageObject = v273

	return v271, v272, v273
end

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

for i = 1, u75 do
	local v111 = MakeSlot(u51, i)

	v111.Frame.Visible = false

	if not u61 then
		u61 = v111
	end
end

u52 = NewGui("ImageButton", "OpenInventory")
u52.Size = UDim2.new(0, 30, 0, 30)
u52.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
u52.MouseButton1Click:connect(function() -- line: 1458
	-- upvalues: t1 (copy)
	t1.OpenClose()
end)
u52.SelectionGained:connect(function() -- line: 1461
	-- upvalues: u52 (ref), color3_5 (copy)
	u52.ImageColor3 = color3_5
end)
u52.SelectionLost:connect(function() -- line: 1464
	-- upvalues: u52 (ref)
	u52.ImageColor3 = Color3.new(1, 1, 1)
end)

local v112 = NewGui("Frame", "Selection")

v112.Visible = false
u52.SelectionImageObject = v112

local v113 = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")

v113.Position = UDim2.new(0, 0, 0, -50)
v113.MouseButton1Click:connect(function() -- line: 1474
	-- upvalues: u53 (ref), t1 (copy)
	if u53.Visible then
		t1.OpenClose()
	end
end)
LeftBumperButton = NewGui("ImageLabel", "LeftBumper")
LeftBumperButton.Size = UDim2.new(0, 40, 0, 40)
LeftBumperButton.Position = UDim2.new(0, -LeftBumperButton.Size.X.Offset, 0.5, -LeftBumperButton.Size.Y.Offset / 2)
RightBumperButton = NewGui("ImageLabel", "RightBumper")
RightBumperButton.Size = UDim2.new(0, 40, 0, 40)
RightBumperButton.Position = UDim2.new(1, 0, 0.5, -RightBumperButton.Size.Y.Offset / 2)
u53 = NewGui("Frame", "Inventory")
u53.BackgroundTransparency = u22
u53.BackgroundColor3 = color3
u53.Active = true
u53.Visible = false
u53.Parent = u50
u54 = NewGui("TextButton", "VRInventorySelector")
u54.Position = UDim2.new(0, 0, 0, 0)
u54.Size = UDim2.new(1, 0, 1, 0)
u54.BackgroundTransparency = 1
u54.Text = ""
u54.Parent = u53

local v114 = NewGui("ImageLabel", "Selector")

v114.Size = UDim2.new(1, 0, 1, 0)
v114.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
v114.ScaleType = Enum.ScaleType.Slice
v114.SliceCenter = Rect.new(12, 12, 52, 52)
v114.Visible = false
u54.SelectionImageObject = v114
u55 = NewGui("ScrollingFrame", "ScrollingFrame")
u55.Selectable = false
u55.CanvasSize = UDim2.new(0, 0, 0, 0)
u55.Parent = u53
u56 = NewGui("Frame", "UIGridFrame")
u56.Selectable = false
u56.Size = UDim2.new(1, -10, 1, 0)
u56.Position = UDim2.new(0, 5, 0, 0)
u56.Parent = u55

local UIGridLayout = Instance.new("UIGridLayout")

UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0, n1, 0, n1)
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
UIGridLayout.Parent = u56

local u116 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

u116.Size = UDim2.new(0, 34, 0, 34)
u116.Position = UDim2.new(0.5, -u116.Size.X.Offset / 2, 0, 43)
u116.Icon.Position = u116.Icon.Position - UDim2.new(0, 0, 0, 2)
u116.MouseButton1Click:connect(function() -- line: 1533
	-- upvalues: u55 (ref), n1 (ref)
	u55.CanvasPosition = Vector2.new(u55.CanvasPosition.X, (math.min(u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y, (math.max(0, u55.CanvasPosition.Y - (n1 + 5))))))
end)

local u117 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

u117.Rotation = 180
u117.Icon.Position = u117.Icon.Position - UDim2.new(0, 0, 0, 2)
u117.Size = UDim2.new(0, 34, 0, 34)
u117.Position = UDim2.new(0.5, -u117.Size.X.Offset / 2, 1, -u117.Size.Y.Offset - 3)
u117.MouseButton1Click:connect(function() -- line: 1544
	-- upvalues: u55 (ref), n1 (ref)
	u55.CanvasPosition = Vector2.new(u55.CanvasPosition.X, (math.min(u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y, (math.max(0, u55.CanvasPosition.Y + (n1 + 5))))))
end)
u55.Changed:connect(function(p65) -- line: 1550
	-- upvalues: u55 (ref), u116 (ref), u117 (ref)
	if p65 == "AbsoluteWindowSize" or (p65 == "CanvasPosition" or p65 == "CanvasSize") then
		local v275 = u55.CanvasPosition.Y ~= 0
		local v276 = u55.CanvasPosition.Y < u55.CanvasSize.Y.Offset - u55.AbsoluteWindowSize.Y

		u116.Visible = v275
		u117.Visible = v276
	end
end)
UpdateBackpackLayout()

local v118 = Create("Frame")({
	Name = "GamepadHintsFrame",
	BackgroundTransparency = 1,
	Visible = false,
	Size = UDim2.new(0, u51.Size.X.Offset, 0, not v43 and 60 or 95),
	Parent = u50
})

local function addGamepadHint(p66, p67, p68) -- line: 1573
	-- upvalues: Create (copy), v118 (copy), v43 (copy)
	local v280 = Create("Frame")({
		Name = "HintFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -5),
		Position = UDim2.new(0, 0, 0, 0),
		Parent = v118
	})

	Create("ImageLabel")({
		Name = "HintImage",
		BackgroundTransparency = 1,
		Size = v43 and UDim2.new(0, 90, 0, 90) or UDim2.new(0, 60, 0, 60),
		Image = v43 and p67 or p66,
		Parent = v280
	})

	local v281 = Create("TextLabel")({
		Name = "HintText",
		BackgroundTransparency = 1,
		TextWrapped = true,
		Position = UDim2.new(0, not v43 and 70 or 100, 0, 0),
		Size = UDim2.new(1, -(not v43 and 70 or 100), 1, 0),
		Font = Enum.Font.SourceSansBold,
		FontSize = v43 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
		Text = p68,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = v280
	})

	Instance.new("UITextSizeConstraint", v281).MaxTextSize = v281.TextSize
end
local function resizeGamepadHintsFrame() -- line: 1610
	-- upvalues: v118 (copy), u51 (ref), v43 (copy), u53 (ref)
	v118.Size = UDim2.new(u51.Size.X.Scale, u51.Size.X.Offset, 0, not v43 and 60 or 95)
	v118.Position = UDim2.new(u51.Position.X.Scale, u51.Position.X.Offset, u53.Position.Y.Scale, u53.Position.Y.Offset - v118.Size.Y.Offset)

	local n8 = 0
	local children = v118:GetChildren()

	for i = 1, #children do
		children[i].Size = UDim2.new(1, 0, 1, -5)
		children[i].Position = UDim2.new(0, 0, 0, 0)
		n8 += children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X
	end

	local v285 = (v118.AbsoluteSize.X - n8) / (#children - 1)

	for i = 1, #children do
		children[i].Position = i == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, children[i - 1].Position.X.Offset + children[i - 1].Size.X.Offset + v285, 0, 0)
		children[i].Size = UDim2.new(0, children[i].HintText.Position.X.Offset + children[i].HintText.TextBounds.X, 1, -5)
	end
end

addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonX@2x.png", "Remove From Hotbar")
addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonA@2x.png", "Select/Swap")
addGamepadHint("rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png", "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png", "Close Backpack")

local v121 = NewGui("Frame", "Search")

v121.BackgroundColor3 = color3_6
v121.BackgroundTransparency = u32
v121.Size = UDim2.new(0, 190, 0, 30)
v121.Position = UDim2.new(1, -v121.Size.X.Offset - 5, 0, 5)
v121.Parent = u53

local v122 = NewGui("TextBox", "TextBox")

v122.Text = s1
v122.ClearTextOnFocus = false
v122.FontSize = Enum.FontSize.Size24
v122.TextXAlignment = Enum.TextXAlignment.Left
v122.Size = v121.Size - UDim2.new(0, 0, 0, 0)
v122.Position = UDim2.new(0, 0, 0, 0)
v122.Parent = v121

local v123 = NewGui("TextButton", "X")

v123.Text = "x"
v123.TextColor3 = color3_3
v123.FontSize = Enum.FontSize.Size24
v123.TextYAlignment = Enum.TextYAlignment.Bottom
v123.BackgroundColor3 = color3_6
v123.BackgroundTransparency = 0
v123.Size = UDim2.new(0, v121.Size.Y.Offset - 10, 0, v121.Size.Y.Offset - 10)
v123.Position = UDim2.new(1, -v123.Size.X.Offset - 10, 0.5, -v123.Size.Y.Offset / 2)
v123.ZIndex = 0
v123.Visible = false
v123.BorderSizePixel = 0
v123.Parent = v121

local function search() -- line: 1667
	-- upvalues: v122 (copy), u75 (ref), t3 (copy), u53 (ref), u70 (ref), u56 (ref), u55 (ref), UpdateScrollingFrameCanvasSize (copy), v123 (copy)
	local t11 = {}

	for match in v122.Text:gmatch("%S+") do
		t11[match:lower()] = true
	end

	local t12 = {}

	for i = u75 + 1, #t3 do
		local v291 = t3[i]

		table.insert(t12, {
			v291,
			(v291:CheckTerms(t11))
		})
		v291.Frame.Visible = false
		v291.Frame.Parent = u53
	end

	table.sort(t12, function(p69, p70) -- line: 1682
		return p69[2] > p70[2]
	end)
	u70 = true

	local n9 = 0

	for _, v in ipairs(t12) do
		local v295 = v[1]

		if v[2] > 0 then
			v295.Frame.Visible = true
			v295.Frame.Parent = u56
			v295.Frame.LayoutOrder = u75 + n9
			n9 += 1
		end
	end

	u55.CanvasPosition = Vector2.new(0, 0)
	UpdateScrollingFrameCanvasSize()
	v123.ZIndex = 3
end
local function clearResults() -- line: 1704
	-- upvalues: v123 (copy), u70 (ref), u75 (ref), t3 (copy), u56 (ref), UpdateScrollingFrameCanvasSize (copy)
	if v123.ZIndex > 0 then
		u70 = false

		for i = u75 + 1, #t3 do
			local v297 = t3[i]

			v297.Frame.LayoutOrder = v297.Index
			v297.Frame.Parent = u56
			v297.Frame.Visible = true
		end

		v123.ZIndex = 0
	end

	UpdateScrollingFrameCanvasSize()
end
local function reset() -- line: 1718
	-- upvalues: clearResults (copy), v122 (copy), s1 (ref)
	clearResults()
	v122.Text = s1
end
local function onChanged(p71) -- line: 1723
	-- upvalues: v122 (copy), clearResults (copy), s1 (ref), search (copy), v123 (copy)
	if p71 == "Text" then
		local Text = v122.Text

		if Text == "" then
			clearResults()
		elseif Text ~= s1 then
			search()
		end

		v123.Visible = Text ~= "" and Text ~= s1
	end
end
local function onFocused() -- line: 1735
	-- upvalues: v122 (copy), s1 (ref)
	if v122.Text == s1 then
		v122.Text = ""
	end
end
local function focusLost(p72) -- line: 1741
	-- upvalues: search (copy), v122 (copy), s1 (ref)
	if p72 then
		search()

		return
	end

	if v122.Text == "" then
		v122.Text = s1
	end
end

v122.Focused:connect(onFocused)
v123.MouseButton1Click:connect(reset)
v122.Changed:connect(onChanged)
v122.FocusLost:connect(focusLost)
t1.StateChanged.Event:connect(function(p73) -- line: 1755
	-- upvalues: v123 (copy), clearResults (copy), v122 (copy), s1 (ref)
	v123.Modal = p73

	if not p73 then
		clearResults()
		v122.Text = s1
	end
end)
t5[Enum.KeyCode.Escape.Value] = function(p74) -- line: 1762
	-- upvalues: clearResults (copy), v122 (copy), s1 (ref), u53 (ref), t1 (copy)
	if p74 then
		clearResults()
		v122.Text = s1

		return
	end

	if u53.Visible then
		t1.OpenClose()
	end
end

local function detectGamepad(p75) -- line: 1770
	-- upvalues: VRService (copy), v121 (copy)
	if p75 == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
		v121.Visible = false

		return
	end

	v121.Visible = true
end

UserInputService.LastInputTypeChanged:connect(detectGamepad)

local function v131(_, p77, _) -- line: 1781
	-- upvalues: GuiService (copy), u75 (ref), t3 (copy)
	if p77 ~= Enum.UserInputState.Begin then
		return
	end

	if not GuiService.SelectedCoreObject then
		return
	end

	for i = 1, u75 do
		if t3[i].Frame == GuiService.SelectedCoreObject and t3[i].Tool then
			t3[i]:MoveToInventory()

			return
		end
	end
end
local function openClose() -- line: 1793
	-- upvalues: t6 (copy), u53 (ref), AdjustHotbarFrames (copy), u51 (ref), u75 (ref), t3 (copy), u73 (ref), t2 (copy), UserInputService (copy), resizeGamepadHintsFrame (copy), v118 (copy), ContextActionService (copy), v131 (copy), t1 (copy)
	if not next(t6) then
		u53.Visible = not u53.Visible

		local Visible = u53.Visible

		AdjustHotbarFrames()
		u51.Active = not u51.Active

		for i = 1, u75 do
			t3[i]:SetClickability(not Visible)
		end
	end

	if u53.Visible then
		if u73 then
			if t2[UserInputService:GetLastInputType()] then
				resizeGamepadHintsFrame()
				v118.Visible = true
			end

			enableGamepadInventoryControl()
		end
	else
		if u73 then
			v118.Visible = false
		end

		disableGamepadInventoryControl()
	end

	if u53.Visible then
		ContextActionService:BindAction("RBXRemoveSlot", v131, false, Enum.KeyCode.ButtonX)
	else
		ContextActionService:UnbindAction("RBXRemoveSlot")
	end

	t1.IsOpen = u53.Visible
	t1.StateChanged:Fire(u53.Visible)
end

t5[BackquoteValue] = function() -- line: 1829
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

LocalPlayer.CharacterAdded:connect(OnCharacterAdded)

if LocalPlayer.Character then
	OnCharacterAdded(LocalPlayer.Character)
end

for i = 0, 9 do
	table.insert(t7, (tostring(i)))
end

table.insert(t7, "`")
UserInputService.InputBegan:connect(OnInputBegan)
UserInputService.TextBoxFocused:connect(function() -- line: 1864
	-- upvalues: u69 (ref)
	u69 = true
end)
UserInputService.TextBoxFocusReleased:connect(function() -- line: 1865
	-- upvalues: u69 (ref)
	u69 = false
end)
t5[BackspaceValue] = function() -- line: 1868
	-- upvalues: u66 (ref), u58 (ref), t4 (copy)
	if u66 and u58 then
		u58:UnequipTools()

		if u66 then
			u66:ToggleSelect()
			t4[u66]:UpdateEquipView()
			u66 = nil
		end
	end
end
UserInputService.Changed:connect(OnUISChanged)

local v134 = UserInputService.KeyboardEnabled and not VRService.VREnabled

for i = 1, u75 do
	t3[i]:TurnNumber(v134)
end

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
	gamepadConnected()
end

UserInputService.GamepadConnected:connect(function(p79) -- line: 1882
	if p79 == Enum.UserInputType.Gamepad1 then
		gamepadConnected()
	end
end)
UserInputService.GamepadDisconnected:connect(function(p80) -- line: 1887
	if p80 == Enum.UserInputType.Gamepad1 then
		gamepadDisconnected()
	end
end)

function t1.TopbarEnabledChanged(_, p82) -- line: 1894
	-- upvalues: u46 (ref), OnCoreGuiChanged (copy), StarterGui (copy)
	u46 = p82
	OnCoreGuiChanged(Enum.CoreGuiType.Backpack, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
end

if FFlagTopBarSignalizeSetCores then
	t1.disposeEffect = Signals.createEffect(function(p83) -- line: 1901
		-- upvalues: InExperienceTopBar (copy), t1 (copy)
		local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

		if GetTopBarStore then
			t1:TopbarEnabledChanged(GetTopBarStore(p83).getTopBarCoreGuiEnabled(p83))
		end
	end)
end

StarterGui.CoreGuiChangedSignal:connect(OnCoreGuiChanged)

local Backpack2 = Enum.CoreGuiType.Backpack
local Health = Enum.CoreGuiType.Health

OnCoreGuiChanged(Backpack2, StarterGui:GetCoreGuiEnabled(Backpack2))
OnCoreGuiChanged(Health, StarterGui:GetCoreGuiEnabled(Health))

if v16 then
	SettingsShowSignal:connect(function(p84) -- line: 1916
		-- upvalues: t1 (copy), AdjustHotbarFrames (copy)
		if p84 then
			if t1.IsHotbarVisible then
				AdjustHotbarFrames(true)

				return
			end
		else
			AdjustHotbarFrames(false)
		end
	end)
end

GuiService.MenuOpened:Connect(function() -- line: 1927
	-- upvalues: t1 (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), VRService (copy)
	if t1.IsOpen and (not isInExperienceUIVREnabled or (InExperienceUIVRIXP:isMovePanelToCenter() and true or not VRService.VREnabled)) then
		t1.OpenClose()
	end
end)
InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p85) -- line: 1936
	-- upvalues: t1 (copy)
	if p85 and t1.IsOpen then
		t1.OpenClose()
	end
end)

local function OnPreferredTransparencyChanged() -- line: 1942
	-- upvalues: UserGameSettings (copy), u22 (ref), u53 (ref), u26 (ref), t3 (copy), u32 (ref), v121 (copy)
	local PreferredTransparency = UserGameSettings.PreferredTransparency

	u22 = 0.5 * UserGameSettings.PreferredTransparency
	u53.BackgroundTransparency = u22
	u26 = 0.5 * PreferredTransparency

	for _, v in ipairs(t3) do
		v.Frame.BackgroundTransparency = u26
	end

	u32 = 0.15 * UserGameSettings.PreferredTransparency
	v121.BackgroundTransparency = u32
end

UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)

return t1
