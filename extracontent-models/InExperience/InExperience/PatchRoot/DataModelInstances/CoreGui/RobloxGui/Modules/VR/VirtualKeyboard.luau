local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

game:GetService("UserInputService")
game:GetService("GuiService")

local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

game:GetService("Players")

local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local color3 = Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)
local color3_2 = Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)
local color3_3 = Color3.new(0, 0.6352941176470588, 1)
local color3_4 = Color3.new(0, 0.6352941176470588, 1)
local color3_5 = Color3.new(1, 1, 1)
local data = HttpService:JSONDecode("[\n  [\n    {\n      \"a\": 7,\n      \"w\": 0.8\n    },\n    \"*\",\n    \"Q\",\n    \"W\",\n    \"E\",\n    \"R\",\n    \"T\",\n    \"Y\",\n    \"U\",\n    \"I\",\n    \"O\",\n    \"P\",\n    {\n      \"w\": 1.8\n    },\n    \"Delete\"\n  ],\n  [\n    {\n      \"w\": 1.6\n    },\n    \"Caps\",\n    \"A\",\n    \"S\",\n    \"D\",\n    \"F\",\n    \"G\",\n    \"H\",\n    \"J\",\n    \"K\",\n    \"L\",\n    \"?\",\n    {\n      \"h\": 2,\n      \"w2\": 2.4,\n      \"h2\": 1,\n      \"x2\": -1.4,\n      \"y2\": 1\n    },\n    \"Enter\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"Shift\",\n    \"Z\",\n    \"X\",\n    \"C\",\n    \"V\",\n    \"B\",\n    \"N\",\n    \"M\",\n    \".\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"123/sym\",\n    {\n      \"w\": 8\n    },\n    \"\",\n    {\n      \"w\": 2.4\n    },\n    \"<Speaker>\"\n  ]\n]\n")
local data2 = HttpService:JSONDecode("[\n  [\n    {\n      \"a\": 7,\n      \"w\": 0.8\n    },\n    \"*\",\n    \"1\",\n    \"2\",\n    \"3\",\n    \"4\",\n    \"5\",\n    \"6\",\n    \"7\",\n    \"8\",\n    \"9\",\n    \"0\",\n    {\n      \"w\": 1.8\n    },\n    \"Delete\"\n  ],\n  [\n    {\n      \"w\": 1.6\n    },\n    \"!\",\n    \"@\",\n    \"#\",\n    \"$\",\n    \"%\",\n    \"^\",\n    \"&\",\n    \"(\",\n    \")\",\n    \"=\",\n    \"?\",\n    {\n      \"h\": 2,\n      \"w2\": 2.4,\n      \"h2\": 1,\n      \"x2\": -1.4,\n      \"y2\": 1\n    },\n    \"Enter\"\n  ],\n  [\n    {\n      \"w\": 1.2\n    },\n    \"/\",\n    \"-\",\n    \"+\",\n    \"_\",\n    \":\",\n    \";\",\n    \"'\",\n    \"\\\"\",\n    \",\",\n    \".\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"abc\",\n    {\n      \"w\": 8\n    },\n    \"\",\n    {\n      \"w\": 2.4\n    },\n    \"<Speaker>\"\n  ]\n]\n")
local t1 = {}

for k, v in pairs({
	"ASR_STATUS_OK",
	"ASR_STATUS_CANCELLED",
	"ASR_STATUS_UNKNOWN",
	"ASR_STATUS_INVALID_ARGUMENTS",
	"ASR_STATUS_DEADLINE_EXCEEDED",
	"ASR_STATUS_NOT_FOUND",
	"ASR_STATUS_ALREADY_EXISTS",
	"ASR_STATUS_PERMISSION_DENIED",
	"ASR_STATUS_UNAUTHENTICATED",
	"ASR_STATUS_RESOURCE_EXHAUSTED",
	"ASR_STATUS_FAILED_PRECONDITION",
	"ASR_STATUS_ABORTED",
	"ASR_STATUS_OUT_OF_RANGE",
	"ASR_STATUS_UNIMPLEMENTED",
	"ASR_STATUS_INTERNAL",
	"ASR_STATUS_UNAVAILABLE",
	"ASR_STATUS_DATA_LOSS",
	"ASR_STATUS_NOT_ENABLED",
	"ASR_STATUS_LOW_CONFIDENCE",
	"ASR_STATUS_INVALID_JSON"
}) do
	t1[v] = k - 1
end

local function tokenizeString(p1, p2) -- line: 223
	local t2 = {}

	for match in string.gmatch(p1, "([^" .. p2 .. "]+)") do
		table.insert(t2, match)
	end

	return t2
end
local function ConvertFontSizeEnumToInt(p3) -- line: 231
	local match = string.match(p3.Name, "%d+")

	return match and tostring(match) or 12
end
local function RayPlaneIntersection(p4, p5, p6) -- line: 240
	local unit = p5.unit
	local Unit = p4.Unit
	local v51 = unit:Dot(Unit.Direction)

	if v51 == 0 then
		return nil
	end

	local v52 = unit:Dot(p6 - Unit.Origin) / v51

	if v52 < 0 then
		return nil
	end

	return Unit.Origin + Unit.Direction * v52
end

function Clamp(p7, p8, p9) -- line: 261
	return (math.max(p7, (math.min(p8, p9))))
end

local function PointInGuiObject(p10, p11, p12) -- line: 266
	local AbsolutePosition = p10.AbsolutePosition
	local v60 = p10.AbsolutePosition + p10.AbsoluteSize

	if p11 >= AbsolutePosition.X and (p11 <= v60.X and p12 >= AbsolutePosition.Y and p12 <= v60.Y) then
		return true
	end

	return false
end
local function FindAncestorOfType(p13, p14) -- line: 275
	-- upvalues: FindAncestorOfType (copy)
	if not p13 then
		return nil
	end

	local p13Parent = p13.Parent

	if p13Parent and p13Parent:IsA(p14) then
		return p13Parent
	end

	return FindAncestorOfType(p13Parent, p14)
end
local function ExtendedInstance(p15) -- line: 286
	local t3 = {}

	setmetatable(t3, {
		__index = function(_, p17) -- line: 291
			-- upvalues: p15 (copy)
			return p15[p17]
		end,
		__newindex = function(_, p19, p20) -- line: 295
			-- upvalues: p15 (copy)
			p15[p19] = p20
		end
	})

	return t3
end
local function CreateVRButton(p21) -- line: 304
	-- upvalues: ExtendedInstance (copy)
	local v67 = ExtendedInstance(p21)

	rawset(v67, "OnEnter", function(_) -- line: 307
	end)
	rawset(v67, "OnLeave", function(_) -- line: 309
	end)
	rawset(v67, "OnDown", function(_) -- line: 311
	end)
	rawset(v67, "OnUp", function(_) -- line: 313
	end)
	rawset(v67, "ContainsPoint", function(_, p27, p28) -- line: 315
		-- upvalues: p21 (copy)
		local v179 = p21
		local AbsolutePosition = v179.AbsolutePosition
		local v181 = v179.AbsolutePosition + v179.AbsoluteSize

		if p27 >= AbsolutePosition.X and (p27 <= v181.X and p28 >= AbsolutePosition.Y and p28 <= v181.Y) then
			return true
		end

		return false
	end)
	rawset(v67, "Update", function(_) -- line: 318
	end)

	return v67
end

Create("ImageLabel")({
	Name = "SelectionRing",
	Image = "rbxasset://textures/ui/menu/buttonHover.png",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.new(0, 4, 0, 3),
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(47, 47, 47, 47)
})

local t4 = {
	["<Speaker>"] = {
		Asset = "rbxasset://textures/ui/Keyboard/mic_icon.png",
		AspectRatio = 0.615
	}
}

local function CreateKeyboardKey(p30, p31, p32) -- line: 340
	-- upvalues: Create (copy), color3_5 (copy), color3 (copy), CreateVRButton (copy), t4 (copy), color3_3 (copy), color3_2 (copy), color3_4 (copy)
	local v71 = p31.width2 and (p31.height2 and (p31.x2 and p31.y2))
	local v72 = Create("ImageButton")({
		BorderSizePixel = 0,
		Image = "",
		BackgroundTransparency = 1,
		ZIndex = 1,
		Name = p32[1],
		Position = UDim2.new(p31.x, 0, p31.y, 0),
		Size = UDim2.new(p31.width, 0, p31.height, 0)
	})
	local v73 = Create("TextLabel")({
		Name = "KeyText",
		BackgroundTransparency = 1,
		Selectable = true,
		ZIndex = 2,
		Text = p32[#p32],
		Position = UDim2.new(0, -10, 0, -10),
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color3_5,
		Parent = v72
	})
	local v74 = Create("Frame")({
		Name = "KeyBackground",
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -10, 1, -10),
		Position = UDim2.new(0, -5, 0, -5),
		BackgroundColor3 = color3,
		Parent = v72
	})
	local v75 = Create("ImageLabel")({
		Name = "SelectionObject",
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png",
		ImageTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(12, 12, 52, 52)
	})

	v72.SelectionImageObject = Create("ImageLabel")({
		Visible = false
	})

	local u76 = nil
	local u77 = nil
	local clone = nil
	local clone2 = nil

	if v71 then
		u76 = Create("ImageButton")({
			Name = "KeyBackground",
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = UDim2.new(p31.x2 / p31.width, -5, p31.y2 / p31.height, -5),
			Size = UDim2.new(p31.width2 / p31.width, 0, p31.height2 / p31.height, -10),
			BackgroundColor3 = color3,
			SelectionImageObject = v72.SelectionImageObject,
			Parent = v72
		})

		if p31.x2 <= 0 then
			v73.Size = u76.Size - UDim2.new(0, 10, 0, 0)
			v73.Position = u76.Position
			u76.Size = u76.Size - UDim2.new(1, 0, 0, 0)
		end

		u77 = Create("Frame")({
			Name = "SpecialSelectionObject",
			Size = UDim2.new(1, 0, 0.5, 0),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Create("ImageLabel")({
				Name = "Borders",
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png",
				ImageTransparency = 0,
				Position = UDim2.new(-1, 0, -1, 0),
				Size = UDim2.new(2, 0, 2, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 12, 52, 52)
			})
		})
		clone = u77:Clone()
		clone.Size = UDim2.new(1, 0, 0.5, 5)
		clone.Position = UDim2.new(0, 0, 0, 0)
		clone.Borders.Size = UDim2.new(1, 0, 1, 30)
		clone.Borders.Position = UDim2.new(0, 0, 0, 0)
		clone2 = u77:Clone()
		clone2.Size = UDim2.new(1, 5, 1, 0)
		clone2.Position = UDim2.new(0, 0, 0, 0)
		clone2.Borders.Size = UDim2.new(1, 30, 1, 0)
		clone2.Borders.Position = UDim2.new(0, 0, 0, 0)
	end

	local v80 = CreateVRButton(v72)
	local u81 = false
	local u82 = false
	local v83 = #p32 == 1 and (type(p32[1]) == "string" and (#p32[1] == 1 and (string.byte(p32[1]) >= 65 and string.byte(p32[1]) <= 122)))
	local u84 = nil

	if p32[1] and t4[p32[1]] then
		v73.Visible = false
		u84 = Create("ImageLabel")({
			Name = "KeyIcon",
			BackgroundTransparency = 1,
			Size = UDim2.new(t4[p32[1]].AspectRatio, -20, 1, -20),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Image = t4[p32[1]].Asset,
			Parent = v74
		})

		local function onChanged(p33) -- line: 472
			-- upvalues: u84 (ref)
			if p33 == "AbsoluteSize" then
				u84.Position = UDim2.new(0.5, -u84.AbsoluteSize.X / 2, 0.5, -u84.AbsoluteSize.Y / 2)
			end
		end

		u84.Changed:connect(onChanged)
		u84.Position = UDim2.new(0.5, -u84.AbsoluteSize.X / 2, 0.5, -u84.AbsoluteSize.Y / 2)
	end

	local function onClicked() -- line: 481
		-- upvalues: v80 (copy), p30 (copy), v83 (copy)
		local v184 = nil
		local CurrentKeyValue = v80:GetCurrentKeyValue()

		if CurrentKeyValue == "Shift" then
			p30:SetShift(not p30:GetShift())
		elseif CurrentKeyValue == "Caps" then
			p30:SetCaps(not p30:GetCaps())
		elseif CurrentKeyValue == "Enter" then
			p30:SubmitText(true, true)
		elseif CurrentKeyValue == "Delete" then
			p30:BackspaceAtCursor()
		elseif CurrentKeyValue == "123/sym" then
			p30:SetCurrentKeyset(2)
		elseif CurrentKeyValue == "abc" then
			p30:SetCurrentKeyset(1)
		elseif CurrentKeyValue == "<Speaker>" then
			p30:SetVoiceMode(true)
		else
			v184 = if CurrentKeyValue ~= "Tab" then CurrentKeyValue else "\t"
		end

		if v184 ~= nil then
			p30:SubmitCharacter(v184, v83)
		end
	end
	local function setKeyColor(p34, p35) -- line: 510
		-- upvalues: v74 (copy), u76 (ref), v71 (copy), u77 (ref), clone (ref), clone2 (ref), v75 (copy)
		v74.BackgroundColor3 = p34

		if u76 then
			u76.BackgroundColor3 = p34
		end

		if v71 then
			u77.Parent = p35 and v74 or nil
			clone.Parent = p35 and v74 or nil
			clone2.Parent = p35 and u76 or nil

			return
		end

		v75.Parent = p35 and v74 or nil
	end
	local function update() -- line: 524
		-- upvalues: v80 (copy), u82 (ref), color3_3 (copy), v74 (copy), u76 (ref), v71 (copy), u77 (ref), clone (ref), clone2 (ref), v75 (copy), u81 (ref), color3_2 (copy), p30 (copy), color3_4 (copy), color3 (copy), u84 (ref), v73 (copy)
		local CurrentKeyValue = v80:GetCurrentKeyValue()

		if u82 then
			local v189 = color3_3

			v74.BackgroundColor3 = v189

			if u76 then
				u76.BackgroundColor3 = v189
			end

			if v71 then
				u77.Parent = nil
				clone.Parent = nil
				clone2.Parent = nil
			else
				v75.Parent = nil
			end
		elseif u81 then
			local v190 = color3_2

			v74.BackgroundColor3 = v190

			if u76 then
				u76.BackgroundColor3 = v190
			end

			if v71 then
				u77.Parent = v74 or nil
				clone.Parent = v74 or nil
				clone2.Parent = u76 or nil
			else
				v75.Parent = v74 or nil
			end
		elseif CurrentKeyValue == "Caps" and p30:GetCaps() then
			local v191 = color3_4

			v74.BackgroundColor3 = v191

			if u76 then
				u76.BackgroundColor3 = v191
			end

			if v71 then
				u77.Parent = nil
				clone.Parent = nil
				clone2.Parent = nil
			else
				v75.Parent = nil
			end
		elseif CurrentKeyValue == "Shift" and p30:GetShift() then
			local v192 = color3_4

			v74.BackgroundColor3 = v192

			if u76 then
				u76.BackgroundColor3 = v192
			end

			if v71 then
				u77.Parent = nil
				clone.Parent = nil
				clone2.Parent = nil
			else
				v75.Parent = nil
			end
		elseif CurrentKeyValue == "abc" then
			local v193 = color3_4

			v74.BackgroundColor3 = v193

			if u76 then
				u76.BackgroundColor3 = v193
			end

			if v71 then
				u77.Parent = nil
				clone.Parent = nil
				clone2.Parent = nil
			else
				v75.Parent = nil
			end
		else
			local v194 = color3

			v74.BackgroundColor3 = v194

			if u76 then
				u76.BackgroundColor3 = v194
			end

			if v71 then
				u77.Parent = nil
				clone.Parent = nil
				clone2.Parent = nil
			else
				v75.Parent = nil
			end
		end

		if u84 then
			u84.ImageTransparency = 0.5
		end

		v73.Text = v80:GetCurrentKeyValue()
	end

	local t5 = {}

	rawset(v80, "OnEnter", function(_) -- line: 550
		-- upvalues: u81 (ref), update (copy)
		u81 = true
		update()
	end)
	rawset(v80, "OnLeave", function(_) -- line: 554
		-- upvalues: t5 (copy), u81 (ref), u82 (ref), update (copy)
		if not next(t5) then
			u81 = false
			u82 = false
			update()
		end
	end)
	rawset(v80, "OnDown", function(_) -- line: 561
		-- upvalues: u82 (ref), update (copy), onClicked (copy)
		u82 = true
		update()
		onClicked()
	end)
	rawset(v80, "OnUp", function(_) -- line: 569
		-- upvalues: u82 (ref), update (copy)
		u82 = false
		update()
	end)
	rawset(v80, "GetCurrentKeyValue", function(_) -- line: 573
		-- upvalues: p30 (copy), v83 (copy), p32 (copy)
		local Shift = p30:GetShift()
		local Caps = p30:GetCaps()

		if v83 then
			if Caps and Shift then
				return string.lower(p32[#p32])
			end

			if Caps or Shift then
				return p32[1]
			end

			return string.lower(p32[#p32])
		end

		if Shift then
			return p32[1]
		end

		return p32[#p32]
	end)
	rawset(v80, "ContainsPoint", function(_, p42, p43) -- line: 593
		-- upvalues: v74 (copy), u76 (ref)
		local v205 = v74
		local AbsolutePosition = v205.AbsolutePosition
		local v207 = v205.AbsolutePosition + v205.AbsoluteSize
		local v208 = p42 >= AbsolutePosition.X and (p42 <= v207.X and (p43 >= AbsolutePosition.Y and p43 <= v207.Y))

		if not v208 then
			v208 = u76

			if v208 then
				local v209 = u76
				local AbsolutePosition2 = v209.AbsolutePosition
				local v211 = v209.AbsolutePosition + v209.AbsoluteSize

				if p42 >= AbsolutePosition2.X and p42 <= v211.X and p43 >= AbsolutePosition2.Y and p43 <= v211.Y then
					return true
				end

				v208 = false
			end
		end

		return v208
	end)
	rawset(v80, "Update", function(_) -- line: 597
		-- upvalues: update (copy)
		update()
	end)
	rawset(v80, "GetInstance", function(_) -- line: 600
		-- upvalues: v72 (copy)
		return v72
	end)
	v72.MouseButton1Down:connect(function() -- line: 604
		-- upvalues: v80 (copy)
		v80:OnDown()
	end)
	v72.MouseButton1Up:connect(function() -- line: 605
		-- upvalues: v80 (copy)
		v80:OnUp()
	end)
	v72.SelectionGained:connect(function() -- line: 606
		-- upvalues: t5 (copy), v72 (copy), v80 (copy)
		t5[v72] = true
		v80:OnEnter()
	end)
	v72.SelectionLost:connect(function() -- line: 607
		-- upvalues: t5 (copy), v72 (copy), v80 (copy)
		t5[v72] = nil
		v80:OnLeave()
	end)

	if u76 then
		u76.MouseButton1Down:connect(function() -- line: 613
			-- upvalues: v80 (copy)
			v80:OnDown()
		end)
		u76.MouseButton1Up:connect(function() -- line: 614
			-- upvalues: v80 (copy)
			v80:OnUp()
		end)
		u76.SelectionGained:connect(function() -- line: 615
			-- upvalues: t5 (copy), u76 (ref), v80 (copy)
			t5[u76] = true
			v80:OnEnter()
		end)
		u76.SelectionLost:connect(function() -- line: 619
			-- upvalues: t5 (copy), u76 (ref), v80 (copy)
			t5[u76] = nil
			v80:OnLeave()
		end)
	end

	update()

	return v80
end
local function CreateBaseVoiceState() -- line: 630
	return {
		Name = "Base",
		TransitionFrom = function(_) -- line: 634
		end,
		TransitionTo = function(_) -- line: 636
		end
	}
end
local function CreateListeningVoiceState() -- line: 642
	-- upvalues: CreateBaseVoiceState (copy), SoundService (copy)
	local v90 = CreateBaseVoiceState()

	v90.Name = "Listening"

	function v90.TransitionTo(_) -- line: 647
		-- upvalues: SoundService (copy)
		pcall(function() -- line: 648
			-- upvalues: SoundService (copy)
			SoundService:BeginRecording()
		end)
	end

	return v90
end
local function CreateProcessingVoiceState() -- line: 654
	-- upvalues: CreateBaseVoiceState (copy), SoundService (copy)
	local v91 = CreateBaseVoiceState()

	v91.Name = "Processing"

	local u92 = false
	local u93 = nil

	function v91.TransitionTo(_) -- line: 662
		-- upvalues: u93 (ref), SoundService (copy), u92 (ref)
		coroutine.wrap(function() -- line: 663
			-- upvalues: u93 (ref), SoundService (copy), u92 (ref)
			pcall(function() -- line: 664
				-- upvalues: u93 (ref), SoundService (copy)
				u93 = SoundService:EndRecording()
			end)
			u92 = true
		end)()
	end
	function v91.GetResultAsync(_) -- line: 669
		-- upvalues: u92 (ref), u93 (ref)
		while not u92 do
			wait()
		end

		return u93
	end

	return v91
end
local function CreateWaitingVoiceState() -- line: 679
	-- upvalues: CreateBaseVoiceState (copy)
	local v94 = CreateBaseVoiceState()

	v94.Name = "Waiting"

	return v94
end

local t6 = {
	Listening = {
		Processing = true
	},
	Processing = {
		Waiting = true
	},
	Waiting = {
		Listening = true
	}
}
local t7 = {}
local v34 = CreateBaseVoiceState()

v34.Name = "Waiting"
t7.CurrentState = v34

local BindableEvent = Instance.new("BindableEvent")

function t7.TransitionState(p51, p52) -- line: 695
	-- upvalues: t6 (copy), BindableEvent (copy)
	if t6[p51.CurrentState.Name][p52.Name] then
		p51.CurrentState:TransitionFrom()
		p51.CurrentState = p52
		p51.CurrentState:TransitionTo()
		BindableEvent:Fire(p51.CurrentState)

		return true
	end

	return false
end
function t7.GetCurrentState(p53) -- line: 707
	return p53.CurrentState
end

t7.StateTransitionedEvent = BindableEvent.Event

local function ConstructKeyboardUI(p54) -- line: 716
	-- upvalues: CorePackages (copy), Create (copy), color3_4 (copy), CreateVRButton (copy), color3 (copy), color3_5 (copy), RunService (copy), ExtendedInstance (copy), TextService (copy), t7 (copy), CreateBaseVoiceState (copy), SoundService (copy), ContextActionService (copy), CreateKeyboardKey (copy), t1 (copy)
	local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
	local v100 = Panel3D.Get("Keyboard")

	v100:SetVisible(false)

	local t8 = {}
	local v102 = Create("Frame")({
		Name = "VirtualKeyboard",
		BackgroundTransparency = 1,
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	})
	local v103 = Create("ImageLabel")({
		Name = "TextEntryBackground",
		Image = "",
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(0.5, 0, 0.125, 0),
		Position = UDim2.new(0.25, 0, 0, 0),
		BackgroundColor3 = Color3.new(0.12156862745098039, 0.12156862745098039, 0.12156862745098039),
		Parent = v102
	})
	local v104 = Create("Frame")({
		Name = "TextfieldBackground",
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = true,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.new(0.8196078431372549, 0.8470588235294118, 0.8666666666666667),
		Parent = v103
	})
	local v105 = Create("TextButton")({
		Name = "TextEntryField",
		Text = "",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 4, 0, 4),
		Size = UDim2.new(1, -8, 1, -8),
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size60,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = v104
	})
	local v106 = Create("Frame")({
		Name = "TextfieldCursor",
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = true,
		ZIndex = 2,
		Size = UDim2.new(0, 5, 0.9, 0),
		Position = UDim2.new(0, 0, 0.05, 0),
		BackgroundColor3 = color3_4,
		Parent = v105
	})
	local v107 = Create("ImageButton")({
		Name = "CloseButton",
		Image = "rbxasset://textures/ui/Keyboard/close_button_background.png",
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Size = UDim2.new(0.075, -10, 0.198, -10),
		Position = UDim2.new(0, -5, 0, -35),
		Parent = v102
	})

	v107.SelectionImageObject = Create("ImageLabel")({
		Name = "Selection",
		Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.9, 0, 0.9, 0),
		Position = UDim2.new(0.05, 0, 0.05, 0)
	})
	Create("ImageLabel")({
		Name = "Icon",
		Image = "rbxasset://textures/ui/Keyboard/close_button_icon.png",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		Parent = v107
	})

	local v108 = CreateVRButton(v107)

	table.insert(t8, v108)

	local v109 = Create("Frame")({
		Name = "VoiceRecognitionContainer",
		BackgroundTransparency = 1,
		Active = true,
		Visible = false,
		Size = UDim2.new(1, 0, 0.85, 0),
		Position = UDim2.new(0, 0, 0.15, 0),
		Parent = v102
	})
	local clone = Create("Frame")({
		Name = "voiceRecognitionBackground1",
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Active = true,
		Size = UDim2.new(1, 0, 0.75, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = color3,
		Parent = v109
	}):Clone()

	clone.Size = UDim2.new(0.8, 0, 0.25, 0)
	clone.Position = UDim2.new(0, 0, 0.75, 0)
	clone.Parent = v109

	local v111 = CreateVRButton(Create("TextButton")({
		Name = "DoneButton",
		Text = "Done",
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Size = UDim2.new(0.2, -5, 0.25, -5),
		Position = UDim2.new(0.8, 5, 0.75, 5),
		BackgroundColor3 = color3_4,
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color3_5,
		Parent = v109
	}))

	table.insert(t8, v111)

	local v112 = Create("TextLabel")({
		Name = "VoiceProcessingStatus",
		Text = "",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.33, 0),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color3_5,
		Parent = v109
	})

	local function CreateVoiceVisualizerWidget() -- line: 873
		-- upvalues: Create (copy), color3_5 (copy), RunService (copy)
		local t9 = {}
		local t10 = {}
		local v221 = Create("Frame")({
			Name = "VoiceVisualizerContainer",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		})

		t9.Container = v221

		for i = 1, 50 do
			table.insert(t10, (Create("Frame")({
				Name = "Bar",
				BackgroundTransparency = 0,
				Size = UDim2.new(0.02, -4, 1, 0),
				Position = UDim2.new(i / 50, 0, 0, 0),
				BackgroundColor3 = color3_5,
				Parent = v221
			})))
		end

		function t9.StartAnimation(_) -- line: 903
			-- upvalues: RunService (copy), t10 (copy)
			RunService:UnbindFromRenderStep("VoiceVisualizerWidget")
			RunService:BindToRenderStep("VoiceVisualizerWidget", Enum.RenderPriority.First.Value, function() -- line: 906
				-- upvalues: t10 (copy)
				for k, v in pairs(t10) do
					local v314 = ((math.abs((math.sin(tick() * 2.5 + k * 0.5026548245743669))) + math.abs((math.cos(tick() * 2.5 + k * 0.5026548245743669)))) / 2 - 0.3) * 1.4285714285714286

					v.Size = UDim2.new(0.02, -4, v314, 0)
					v.Position = UDim2.new(k / 50, 0, (1 - v314) / 2, 0)
				end
			end)
		end
		function t9.StopAnimation(_) -- line: 917
			-- upvalues: RunService (copy)
			RunService:UnbindFromRenderStep("VoiceVisualizerWidget")
		end

		return t9
	end

	local v114 = CreateVoiceVisualizerWidget()

	v114.Container.Parent = v109
	v114.Container.Size = UDim2.new(0.5, 0, 0.4, 0)
	v114.Container.Position = UDim2.new(0.25, 0, 0.4, 0)

	local v115 = ExtendedInstance(v102)
	local u116 = nil
	local t11 = {}
	local u118 = false
	local u119 = false
	local n1 = 0
	local BindableEvent2 = Instance.new("BindableEvent")
	local BindableEvent3 = Instance.new("BindableEvent")
	local u123 = false

	local function SetTextFieldCursorPosition(p57) -- line: 943
		-- upvalues: n1 (ref), v105 (copy), TextService (copy), v106 (copy)
		n1 = Clamp(0, #v105.Text, p57)

		if not v105.TextFits then
			n1 = #v105.Text
		end

		local v224 = TextService
		local v225 = string.sub(v105.Text, 1, n1)
		local FontSize = v105.FontSize
		local match = string.match(FontSize.Name, "%d+")
		local TextSize = v224:GetTextSize(v225, match and tostring(match) or 12, v105.Font, v105.AbsoluteSize)

		v106.Position = UDim2.new(0, TextSize.x, v106.Position.Y.Scale, v106.Position.Y.Offset)
	end
	local function UpdateTextEntryFieldText(p58) -- line: 957
		-- upvalues: v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref)
		v105:SetTextFromInput(p58)
		SetTextFieldCursorPosition(n1)
	end

	local s1 = ""

	local function getBufferText() -- line: 963
		-- upvalues: u116 (ref), s1 (ref)
		if u116 and u116.TextBox then
			return u116.TextBox.Text
		end

		return s1
	end
	local function setBufferText(p59) -- line: 969
		-- upvalues: u116 (ref), s1 (ref), v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref)
		if u116 and u116.TextBox then
			u116.TextBox.Text = p59

			return
		end

		if p59 ~= s1 then
			s1 = p59

			local v231 = s1

			v105:SetTextFromInput(v231)
			SetTextFieldCursorPosition(n1)
		end
	end
	local function calculateTextCursorPosition(p60, p61) -- line: 978
		-- upvalues: v105 (copy), TextService (copy)
		local v234 = p60 - v105.AbsolutePosition.x
		local _ = p61 - v105.AbsolutePosition.y

		for i = 1, #v105.Text do
			local v237 = TextService
			local v238 = string.sub(v105.Text, 1, i)
			local FontSize = v105.FontSize
			local match = string.match(FontSize.Name, "%d+")

			if v234 < v237:GetTextSize(v238, match and tostring(match) or 12, v105.Font, v105.AbsoluteSize).x then
				return i - 1
			end
		end

		return #v105.Text
	end

	local u130 = nil

	rawset(v115, "OpenedEvent", BindableEvent2.Event)
	rawset(v115, "ClosedEvent", BindableEvent3.Event)
	rawset(v115, "GetCurrentKeyset", function(_) -- line: 1001
		-- upvalues: t11 (copy), u130 (ref)
		return t11[u130]
	end)
	rawset(v115, "SetCurrentKeyset", function(_, p64) -- line: 1005
		-- upvalues: u130 (ref), t11 (copy)
		if p64 ~= u130 and t11[p64] ~= nil then
			if t11[u130] and t11[u130].container then
				t11[u130].container.Visible = false
			end

			u130 = p64

			if t11[u130] and t11[u130].container then
				t11[u130].container.Visible = true
			end
		end
	end)
	rawset(v115, "SetVoiceMode", function(p65, _) -- line: 1019
		-- upvalues: v109 (copy), t7 (copy), CreateBaseVoiceState (copy), SoundService (copy)
		local v246 = false
		local CurrentKeyset = p65:GetCurrentKeyset()

		if CurrentKeyset and CurrentKeyset.container then
			CurrentKeyset.container.Visible = not v246
		end

		v109.Visible = v246

		if v246 then
			local v248 = t7
			local v249 = CreateBaseVoiceState()

			v249.Name = "Listening"

			function v249.TransitionTo(_) -- line: 647
				-- upvalues: SoundService (copy)
				pcall(function() -- line: 648
					-- upvalues: SoundService (copy)
					SoundService:BeginRecording()
				end)
			end

			v248:TransitionState(v249)
		end
	end)
	rawset(v115, "GetCaps", function(_) -- line: 1035
		-- upvalues: u118 (ref)
		return u118
	end)
	rawset(v115, "SetCaps", function(p69, p70) -- line: 1039
		-- upvalues: u118 (ref)
		u118 = p70

		for _, v in pairs(p69:GetCurrentKeyset().keys) do
			v:Update()
		end
	end)
	rawset(v115, "GetShift", function(_) -- line: 1046
		-- upvalues: u119 (ref)
		return u119
	end)
	rawset(v115, "SetShift", function(p72, p73) -- line: 1050
		-- upvalues: u119 (ref)
		u119 = p73

		for _, v in pairs(p72:GetCurrentKeyset().keys) do
			v:Update()
		end
	end)

	local u131 = false
	local u132 = nil
	local u133 = nil
	local u134 = nil

	local function disconnectKeyboardEvents() -- line: 1063
		-- upvalues: u132 (ref), u133 (ref), u134 (ref)
		if u132 then
			u132:disconnect()
		end

		u132 = nil

		if u133 then
			u133:disconnect()
		end

		u133 = nil

		if u134 then
			u134:disconnect()
		end

		u134 = nil
	end

	rawset(v115, "Open", function(p74, p75) -- line: 1072
		-- upvalues: u123 (ref), u116 (ref), v102 (copy), v100 (copy), u132 (ref), u133 (ref), u134 (ref), v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref), u131 (ref), s1 (ref), Panel3D (copy), ContextActionService (copy), u130 (ref), t11 (copy), BindableEvent2 (copy)
		if u123 then
			return
		end

		u123 = true
		u116 = p75
		p74:SetCurrentKeyset(1)
		p74:SetVoiceMode(false)
		v102.Visible = true
		v100:ResizeStuds(5.9, 2.25, 320)

		local cFrame = CFrame.new()

		if u132 then
			u132:disconnect()
		end

		u132 = nil

		if u133 then
			u133:disconnect()
		end

		u133 = nil

		if u134 then
			u134:disconnect()
		end

		u134 = nil

		if p75.TextBox then
			u132 = p75.TextBox.Changed:connect(function(p76) -- line: 1088
				-- upvalues: p75 (copy), v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref)
				if p76 == "Text" then
					local TextBoxText = p75.TextBox.Text

					v105:SetTextFromInput(TextBoxText)
					SetTextFieldCursorPosition(n1)
				end
			end)
			u133 = p75.TextBox.FocusLost:connect(function(p77) -- line: 1093
				-- upvalues: u131 (ref), p74 (copy)
				if not u131 then
					p74:Close(p77)
				end
			end)

			if p75.TextBox.ClearTextOnFocus then
				if u116 and u116.TextBox then
					u116.TextBox.Text = ""
				elseif s1 ~= "" then
					s1 = ""

					local v263 = s1

					v105:SetTextFromInput(v263)
					SetTextFieldCursorPosition(n1)
				end
			else
				local TextBoxText = p75.TextBox.Text

				v105:SetTextFromInput(TextBoxText)
				SetTextFieldCursorPosition(n1)
			end

			local v265 = Panel3D.FindContainerOf(p75.TextBox)

			if v265 then
				u134 = Panel3D.OnPanelClosed.Event:connect(function(p78) -- line: 1107
					-- upvalues: v265 (copy), p74 (copy)
					if p78 == v265.name then
						p74:Close(false)
					end
				end)

				local v266 = p75.TextBox.AbsolutePosition + Vector2.new(0.5, 1) * p75.TextBox.AbsoluteSize

				cFrame = v265:GetCFrameInCameraSpace() * CFrame.new(v265:GetGuiPositionInPanelSpace(v266)) * CFrame.new(0, -v100.height * 0.65, 0.5) * CFrame.Angles(-0.39269908169872414, 0, 0)
			else
				cFrame = Panel3D.GetHeadLookXZ(true) * CFrame.Angles(0.39269908169872414, 0, 0) * CFrame.new(0, -1, -5)
			end
		elseif u116 and u116.TextBox then
			u116.TextBox.Text = ""
		elseif s1 ~= "" then
			s1 = ""

			local v267 = s1

			v105:SetTextFromInput(v267)
			SetTextFieldCursorPosition(n1)
		end

		ContextActionService:BindCoreAction("VirtualKeyboardControllerInput", function(_, p80, p81) -- line: 1125
			-- upvalues: SetTextFieldCursorPosition (copy), n1 (ref), p74 (copy), u130 (ref), t11 (copy)
			if p80 == Enum.UserInputState.End then
				if p81.KeyCode == Enum.KeyCode.ButtonL1 then
					SetTextFieldCursorPosition(n1 - 1)

					return
				end

				if p81.KeyCode == Enum.KeyCode.ButtonR1 then
					SetTextFieldCursorPosition(n1 + 1)

					return
				end

				if p81.KeyCode == Enum.KeyCode.ButtonX then
					p74:BackspaceAtCursor()

					return
				end

				if p81.KeyCode == Enum.KeyCode.ButtonY then
					p74:SubmitCharacter(" ", false)

					return
				end

				if p81.KeyCode == Enum.KeyCode.ButtonL2 then
					if u130 then
						p74:SetCurrentKeyset(u130 % #t11 + 1)

						return
					end
				else
					if p81.KeyCode == Enum.KeyCode.ButtonL3 then
						p74:SetCaps(not p74:GetCaps())

						return
					end

					if p81.KeyCode == Enum.KeyCode.ButtonB then
						p74:Close(false)
					end
				end
			end
		end, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonL3, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonB)
		p74.Parent = v100:GetGUI()
		v100:SetType(Panel3D.Type.Fixed, {
			CFrame = cFrame
		})
		v100:SetCanFade(false)
		v100:SetVisible(true, true)
		v100:ForceShowUntilLookedAt()

		function v100.OnUpdate(_) -- line: 1157
		end

		BindableEvent2:Fire()
	end)
	rawset(v115, "Close", function(p83, p84) -- line: 1163
		-- upvalues: u123 (ref), u132 (ref), u133 (ref), u134 (ref), ContextActionService (copy), v100 (copy), v102 (copy), Panel3D (copy), BindableEvent3 (copy)
		local v270 = p84 == true

		if not u123 then
			return
		end

		u123 = false

		if u132 then
			u132:disconnect()
		end

		u132 = nil

		if u133 then
			u133:disconnect()
		end

		u133 = nil

		if u134 then
			u134:disconnect()
		end

		u134 = nil
		ContextActionService:UnbindCoreAction("VirtualKeyboardControllerInput")
		v100:OnMouseLeave()
		v100:SetVisible(false, true)
		v102.Visible = false
		Panel3D.Get("Topbar3D"):SetVisible(true)
		p83:SubmitText(v270, false)
		BindableEvent3:Fire()
	end)
	rawset(v115, "SubmitText", function(_, p86, p87) -- line: 1183
		-- upvalues: u116 (ref), s1 (ref), Panel3D (copy), v100 (copy), u131 (ref)
		local v274 = u116 and u116.TextBox

		if v274 then
			if p86 then
				v274.Text = if not u116 or not u116.TextBox then s1 else u116.TextBox.Text
			end

			local v275 = Panel3D.FindContainerOf(v274)
			local v276 = p87 and (v275 and v275.linkedTo == v100)

			if v276 then
				u131 = true
			end

			v274:ReleaseFocus(p86)

			if v276 then
				v274:CaptureFocus()
				u131 = false
			end
		end
	end)
	rawset(v115, "GetCurrentOptions", function(_) -- line: 1206
		-- upvalues: u116 (ref)
		return u116
	end)
	rawset(v115, "BackspaceAtCursor", function(_) -- line: 1210
		-- upvalues: n1 (ref), u116 (ref), s1 (ref), v105 (copy), SetTextFieldCursorPosition (copy)
		if n1 >= 1 then
			local v279 = if not u116 or not u116.TextBox then s1 else u116.TextBox.Text
			local v280 = string.sub(v279, 1, n1 - 1) .. string.sub(v279, n1 + 1, #v279)
			local v281 = n1 - 1

			if u116 and u116.TextBox then
				u116.TextBox.Text = v280
			elseif v280 ~= s1 then
				s1 = v280

				local v282 = s1

				v105:SetTextFromInput(v282)
				SetTextFieldCursorPosition(n1)
			end

			SetTextFieldCursorPosition(v281)
		end
	end)
	rawset(v115, "SubmitCharacter", function(p90, p91, p92) -- line: 1220
		-- upvalues: u116 (ref), s1 (ref), n1 (ref), v105 (copy), SetTextFieldCursorPosition (copy)
		local v286 = if not u116 or not u116.TextBox then s1 else u116.TextBox.Text
		local v287 = string.sub(v286, 1, n1) .. p91 .. string.sub(v286, n1 + 1, #v286)

		if u116 and u116.TextBox then
			u116.TextBox.Text = v287
		elseif v287 ~= s1 then
			s1 = v287

			local v288 = s1

			v105:SetTextFromInput(v288)
			SetTextFieldCursorPosition(n1)
		end

		SetTextFieldCursorPosition(n1 + #p91)

		if p92 and p90:GetShift() then
			p90:SetShift(false)
		end
	end)

	for _, v in pairs(p54) do
		local t12 = {}
		local v139 = Create("Frame")({
			Name = "KeyboardSizeConstrainer",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -20),
			Position = UDim2.new(0, 0, 0, 20),
			Parent = v102
		})
		local n2 = 0
		local n3 = 0
		local n4 = 0

		for _, v2 in pairs(v) do
			local n5 = 0
			local n6 = 1
			local n7 = 1
			local w2 = nil
			local h2 = nil
			local x2 = nil
			local y2 = nil

			for _, v3 in pairs(v2) do
				local v154 = v3

				if type(v154) == "table" then
					if v154.w then
						n6 = v154.w
					end

					if v154.h then
						n7 = v154.h
					end

					if v154.x then
						n5 += v154.x
					end

					if v154.y then
						n4 += v154.y
					end

					if v154.x2 then
						x2 = v154.x2
					end

					if v154.y2 then
						y2 = v154.y2
					end

					if v154.w2 then
						w2 = v154.w2
					end

					if v154.h2 then
						h2 = v154.h2
					end
				elseif type(v154) == "string" then
					if v154 == "" then
						v154 = " "
					end

					local v155 = CreateKeyboardKey
					local t13 = {
						x = n5,
						y = n4,
						width = n6,
						height = n7,
						x2 = x2,
						y2 = y2,
						width2 = w2,
						height2 = h2
					}
					local t14 = {}

					for match in string.gmatch(v154, "([^\n]+)") do
						table.insert(t14, match)
					end

					table.insert(t12, (v155(v115, t13, t14)))
					n5 += n6
					n2 = math.max(n2, n5)
					n3 = math.max(n3, n4 + n7)
					n6 = 1
					n7 = 1
					w2 = nil
					h2 = nil
					x2 = nil
					y2 = nil
				end
			end

			n4 += 1
		end

		for _, v4 in pairs(t12) do
			v4.Position = UDim2.new(v4.Position.X.Scale / n2, 0, v4.Position.Y.Scale / n3, 0)
			v4.Size = UDim2.new(v4.Size.X.Scale / n2, 0, v4.Size.Y.Scale / n3, 0)
			v4.Parent = v139
		end

		v139.SizeConstraint = Enum.SizeConstraint.RelativeXX
		v139.Size = UDim2.new(1, 0, -n3 / n2, 0)
		v139.Position = UDim2.new(0, 0, 1, 0)
		v139.Visible = false
		table.insert(t11, {
			keys = t12,
			container = v139
		})
	end

	v115:SetCurrentKeyset(1)
	v105.MouseButton1Click:connect(function() -- line: 1301
		-- upvalues: SetTextFieldCursorPosition (copy), calculateTextCursorPosition (copy), v100 (copy)
		SetTextFieldCursorPosition((calculateTextCursorPosition(v100.lookAtPixel.X, v100.lookAtPixel.Y)))
	end)
	v108.MouseButton1Click:connect(function() -- line: 1305
		-- upvalues: v115 (copy)
		v115:Close(false)
	end)
	v111.MouseButton1Click:connect(function() -- line: 1309
		-- upvalues: t7 (copy), CreateBaseVoiceState (copy), SoundService (copy)
		if t7:GetCurrentState().Name == "Listening" then
			local v289 = t7
			local v290 = CreateBaseVoiceState()

			v290.Name = "Processing"

			local u291 = false
			local u292 = nil

			function v290.TransitionTo(_) -- line: 662
				-- upvalues: u292 (ref), SoundService (copy), u291 (ref)
				coroutine.wrap(function() -- line: 663
					-- upvalues: u292 (ref), SoundService (copy), u291 (ref)
					pcall(function() -- line: 664
						-- upvalues: u292 (ref), SoundService (copy)
						u292 = SoundService:EndRecording()
					end)
					u291 = true
				end)()
			end
			function v290.GetResultAsync(_) -- line: 669
				-- upvalues: u291 (ref), u292 (ref)
				while not u291 do
					wait()
				end

				return u292
			end

			v289:TransitionState(v290)
		end
	end)

	local function onVoiceProcessingStateChanged(p95) -- line: 1315
		-- upvalues: v112 (copy), v114 (copy), t1 (copy), u116 (ref), s1 (ref), v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref), t7 (copy), CreateBaseVoiceState (copy), v115 (copy)
		if p95.Name == "Listening" then
			v112.Text = "Listening..."
		elseif p95.Name == "Processing" then
			v112.Text = "Processing..."
		elseif p95.Name == "Waiting" then
			v112.Text = "Done"
		end

		if p95.Name == "Processing" then
			coroutine.wrap(function() -- line: 1326
				-- upvalues: v114 (copy), p95 (copy), t1 (copy), u116 (ref), s1 (ref), v105 (copy), SetTextFieldCursorPosition (copy), n1 (ref), v112 (copy), t7 (copy), CreateBaseVoiceState (copy)
				v114:StopAnimation()

				local ResultAsync = p95:GetResultAsync()

				if ResultAsync and ResultAsync.Status == t1.ASR_STATUS_OK then
					local Response = ResultAsync.Response

					if u116 and u116.TextBox then
						u116.TextBox.Text = Response
					elseif Response ~= s1 then
						s1 = Response

						local v309 = s1

						v105:SetTextFromInput(v309)
						SetTextFieldCursorPosition(n1)
					end
				else
					v112.Text = "An error occurred, please try again."
					wait(2)
				end

				local v310 = t7
				local v311 = CreateBaseVoiceState()

				v311.Name = "Waiting"
				v310:TransitionState(v311)
			end)()

			return
		end

		if p95.Name == "Listening" then
			v114:StartAnimation()

			return
		end

		if p95.Name == "Waiting" then
			v115:SetVoiceMode(false)
		end
	end

	t7.StateTransitionedEvent:connect(onVoiceProcessingStateChanged)
	onVoiceProcessingStateChanged(t7:GetCurrentState())

	return v115
end

local u37 = nil

local function GetKeyboard() -- line: 1352
	-- upvalues: u37 (ref), ConstructKeyboardUI (copy), data (copy), data2 (copy)
	if u37 == nil then
		u37 = ConstructKeyboardUI({
			data,
			data2
		})
	end

	return u37
end

local t15 = {
	CreateVirtualKeyboardOptions = function(_, p97) -- line: 1363
		return {
			TextBox = p97
		}
	end,
	ShowVirtualKeyboard = function(_, _) -- line: 1372
	end,
	CloseVirtualKeyboard = function(_) -- line: 1378
	end
}

if u37 == nil then
	u37 = ConstructKeyboardUI({
		data,
		data2
	})
end

t15.OpenedEvent = u37.OpenedEvent

if u37 == nil then
	u37 = ConstructKeyboardUI({
		data,
		data2
	})
end

t15.ClosedEvent = u37.ClosedEvent

return t15
