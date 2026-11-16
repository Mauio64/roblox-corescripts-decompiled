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
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local color = Color3.new(49 / 255, 49 / 255, 49 / 255)
local color2 = Color3.new(49 / 255, 49 / 255, 49 / 255)
local color3 = Color3.new(0, 162 / 255, 1)
local color4 = Color3.new(0, 162 / 255, 1)

local color5 = Color3.new(1, 1, 1)

local jsonDecode = HttpService:JSONDecode("[\n  [\n    {\n      \"a\": 7,\n      \"w\": 0.8\n    },\n    \"*\",\n    \"Q\",\n    \"W\",\n    \"E\",\n    \"R\",\n    \"T\",\n    \"Y\",\n    \"U\",\n    \"I\",\n    \"O\",\n    \"P\",\n    {\n      \"w\": 1.8\n    },\n    \"Delete\"\n  ],\n  [\n    {\n      \"w\": 1.6\n    },\n    \"Caps\",\n    \"A\",\n    \"S\",\n    \"D\",\n    \"F\",\n    \"G\",\n    \"H\",\n    \"J\",\n    \"K\",\n    \"L\",\n    \"?\",\n    {\n      \"h\": 2,\n      \"w2\": 2.4,\n      \"h2\": 1,\n      \"x2\": -1.4,\n      \"y2\": 1\n    },\n    \"Enter\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"Shift\",\n    \"Z\",\n    \"X\",\n    \"C\",\n    \"V\",\n    \"B\",\n    \"N\",\n    \"M\",\n    \".\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"123/sym\",\n    {\n      \"w\": 8\n    },\n    \"\",\n    {\n      \"w\": 2.4\n    },\n    \"<Speaker>\"\n  ]\n]\n")

local jsonDecode2 = HttpService:JSONDecode("[\n  [\n    {\n      \"a\": 7,\n      \"w\": 0.8\n    },\n    \"*\",\n    \"1\",\n    \"2\",\n    \"3\",\n    \"4\",\n    \"5\",\n    \"6\",\n    \"7\",\n    \"8\",\n    \"9\",\n    \"0\",\n    {\n      \"w\": 1.8\n    },\n    \"Delete\"\n  ],\n  [\n    {\n      \"w\": 1.6\n    },\n    \"!\",\n    \"@\",\n    \"#\",\n    \"$\",\n    \"%\",\n    \"^\",\n    \"&\",\n    \"(\",\n    \")\",\n    \"=\",\n    \"?\",\n    {\n      \"h\": 2,\n      \"w2\": 2.4,\n      \"h2\": 1,\n      \"x2\": -1.4,\n      \"y2\": 1\n    },\n    \"Enter\"\n  ],\n  [\n    {\n      \"w\": 1.2\n    },\n    \"/\",\n    \"-\",\n    \"+\",\n    \"_\",\n    \":\",\n    \";\",\n    \"'\",\n    \"\\\"\",\n    \",\",\n    \".\"\n  ],\n  [\n    {\n      \"w\": 2.2\n    },\n    \"abc\",\n    {\n      \"w\": 8\n    },\n    \"\",\n    {\n      \"w\": 2.4\n    },\n    \"<Speaker>\"\n  ]\n]\n")

local v = {}

for k, v2 in pairs({
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
	v[v2] = k - 1
end

local function tokenizeString(value, p)
	local result = {}

	for k in string.gmatch(value, "([^" .. p .. "]+)") do
		table.insert(result, k)
	end

	return result
end

local function ConvertFontSizeEnumToInt(fontSize) -- 2 equivalent calls inferred from this helper
	local v2 = string.match(fontSize.Name, "%d+")
	return v2 and tostring(v2) or 12
end

local function RayPlaneIntersection(p, p2, p3)
	local unit = p2.unit
	local unit2 = p.Unit

	local dot = unit:Dot(unit2.Direction)

	if dot == 0 then
		return nil
	end

	local v2 = unit:Dot(p3 - unit2.Origin) / dot

	if v2 < 0 then
		return nil
	end

	return unit2.Origin + unit2.Direction * v2
end

function Clamp(p, p2, p3)
	return (math.max(p, (math.min(p2, p3))))
end

local function PointInGuiObject(p, p2, p3): boolean -- 3 equivalent calls inferred from this helper
	local absolutePosition = p.AbsolutePosition
	local v2 = p.AbsolutePosition + p.AbsoluteSize
	return absolutePosition.X <= p2 and p2 <= v2.X and absolutePosition.Y <= p3 and p3 <= v2.Y
end

local function FindAncestorOfType(parent, className)
	if not parent then
		return nil
	end

	local parent2 = parent.Parent

	if parent2 and parent2:IsA(className) then
		return parent2
	end

	return FindAncestorOfType(parent2, className)
end

local function ExtendedInstance(p)
	local v2 = {}

	setmetatable(v2, {
		__index = function(_, p2)
			return p[p2]
		end,
		__newindex = function(_, p2, p3)
			p[p2] = p3
		end
	})

	return v2
end

local function CreateVRButton(p)
	local vrButton = ExtendedInstance(p)

	rawset(vrButton, "OnEnter", function(_) end)
	rawset(vrButton, "OnLeave", function(_) end)
	rawset(vrButton, "OnDown", function(_) end)
	rawset(vrButton, "OnUp", function(_) end)
	rawset(vrButton, "ContainsPoint", function(_, p2, p3)
		return PointInGuiObject(p, p2, p3) -- inferred equivalent call
	end)

	rawset(vrButton, "Update", function(_) end)

	return vrButton
end

Create("ImageLabel")({
	Name = "SelectionRing",
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.new(0, 4, 0, 3),
	Image = "rbxasset://textures/ui/menu/buttonHover.png",
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(47, 47, 47, 47),
	BackgroundTransparency = 1
})

local v2 = {
	["<Speaker>"] = { Asset = "rbxasset://textures/ui/Keyboard/mic_icon.png", AspectRatio = 0.615 }
}

local function CreateKeyboardKey(object, data, list)
	local y2 = data.width2 and data.height2 and data.x2 and data.y2

	local parent = Create("ImageButton")({
		Name = list[1],
		Position = UDim2.new(data.x, 0, data.y, 0),
		Size = UDim2.new(data.width, 0, data.height, 0),
		BorderSizePixel = 0,
		Image = "",
		BackgroundTransparency = 1,
		ZIndex = 1
	})

	local v3 = Create("TextLabel")({
		Name = "KeyText",
		Text = list[#list],
		Position = UDim2.new(0, -10, 0, -10),
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color5,
		BackgroundTransparency = 1,
		Selectable = true,
		ZIndex = 2,
		Parent = parent
	})

	local parent2 = Create("Frame")({
		Name = "KeyBackground",
		Size = UDim2.new(1, -10, 1, -10),
		Position = UDim2.new(0, -5, 0, -5),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = parent
	})

	local v4 = Create("ImageLabel")({
		Name = "SelectionObject",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png",
		ImageTransparency = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(12, 12, 52, 52),
		BorderSizePixel = 0
	})

	parent.SelectionImageObject = Create("ImageLabel")({ Visible = false })
	local v5, v6, clone, clone2

	if y2 then
		v5 = Create("ImageButton")({
			Name = "KeyBackground",
			Position = UDim2.new(data.x2 / data.width, -5, data.y2 / data.height, -5),
			Size = UDim2.new(data.width2 / data.width, 0, data.height2 / data.height, -10),
			BackgroundColor3 = color,
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			SelectionImageObject = parent.SelectionImageObject,
			Parent = parent
		})

		if data.x2 <= 0 then
			v3.Size = v5.Size - UDim2.new(0, 10, 0, 0)
			v3.Position = v5.Position
			v5.Size -= UDim2.new(1, 0, 0, 0)
		end

		v6 = Create("Frame")({
			Name = "SpecialSelectionObject",
			Size = UDim2.new(1, 0, 0.5, 0),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Create("ImageLabel")({
				Name = "Borders",
				Position = UDim2.new(-1, 0, -1, 0),
				Size = UDim2.new(2, 0, 2, 0),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png",
				ImageTransparency = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 12, 52, 52)
			})
		})

		clone = v6:Clone()
		clone.Size = UDim2.new(1, 0, 0.5, 5)
		clone.Position = UDim2.new(0, 0, 0, 0)
		clone.Borders.Size = UDim2.new(1, 0, 1, 30)
		clone.Borders.Position = UDim2.new(0, 0, 0, 0)

		clone2 = v6:Clone()
		clone2.Size = UDim2.new(1, 5, 1, 0)
		clone2.Position = UDim2.new(0, 0, 0, 0)
		clone2.Borders.Size = UDim2.new(1, 30, 1, 0)
		clone2.Borders.Position = UDim2.new(0, 0, 0, 0)
	else
		v5 = nil
		v6 = nil
		clone = nil
		clone2 = nil
	end

	local keyboardKey = CreateVRButton(parent)

	local flag = false
	local flag2 = false
	local v7

	if #list == 1 and type(list[1]) == "string" and #list[1] == 1 and string.byte(list[1]) >= 65 then
		v7 = string.byte(list[1]) <= 122
	else
		v7 = false
	end

	local v8

	if list[1] and v2[list[1]] then
		v3.Visible = false
		v8 = Create("ImageLabel")({
			Name = "KeyIcon",
			Size = UDim2.new(v2[list[1]].AspectRatio, -20, 1, -20),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			Image = v2[list[1]].Asset,
			Parent = parent2
		})

		local function onChanged(p) -- 1 equivalent call inferred from this helper
			if p == "AbsoluteSize" then
				v8.Position = UDim2.new(0.5, -v8.AbsoluteSize.X / 2, 0.5, -v8.AbsoluteSize.Y / 2)
			end
		end
		v8.Changed:connect(onChanged)
		onChanged("AbsoluteSize") -- inferred equivalent call
	else
		v8 = nil
	end

	local function onClicked()
		local v9 = nil
		local currentKeyValue = keyboardKey:GetCurrentKeyValue()

		if currentKeyValue == "Shift" then
			object:SetShift(not object:GetShift())
		elseif currentKeyValue == "Caps" then
			object:SetCaps(not object:GetCaps())
		elseif currentKeyValue == "Enter" then
			object:SubmitText(true, true)
		elseif currentKeyValue == "Delete" then
			object:BackspaceAtCursor()
		elseif currentKeyValue == "123/sym" then
			object:SetCurrentKeyset(2)
		elseif currentKeyValue == "abc" then
			object:SetCurrentKeyset(1)
		elseif currentKeyValue == "<Speaker>" then
			object:SetVoiceMode(true)
		else
			v9 = currentKeyValue == "Tab" and "\t" or currentKeyValue
		end

		if v9 ~= nil then
			object:SubmitCharacter(v9, v7)
		end
	end

	local function setKeyColor(color6, p) -- 6 equivalent calls inferred from this helper
		parent2.BackgroundColor3 = color6

		if v5 then
			v5.BackgroundColor3 = color6
		end

		if not y2 then
			v4.Parent = p and parent2 or nil

			return
		end

		v6.Parent = p and parent2 or nil
		clone.Parent = p and parent2 or nil
		clone2.Parent = p and v5 or nil
	end

	local function update()
		local currentKeyValue = keyboardKey:GetCurrentKeyValue()

		if flag2 then
			setKeyColor(color3, false) -- inferred equivalent call
		elseif flag then
			setKeyColor(color2, true) -- inferred equivalent call
		elseif currentKeyValue == "Caps" and object:GetCaps() then
			setKeyColor(color4, false) -- inferred equivalent call
		elseif currentKeyValue == "Shift" and object:GetShift() then
			setKeyColor(color4, false) -- inferred equivalent call
		elseif currentKeyValue == "abc" then
			setKeyColor(color4, false) -- inferred equivalent call
		else
			setKeyColor(color, false) -- inferred equivalent call
		end

		if v8 then
			v8.ImageTransparency = 0.5
		end

		v3.Text = keyboardKey:GetCurrentKeyValue()
	end

	local v9 = {}

	rawset(keyboardKey, "OnEnter", function(_)
		flag = true
		update()
	end)
	rawset(keyboardKey, "OnLeave", function(_)
		if not next(v9) then
			flag = false
			flag2 = false
			update()
		end
	end)
	rawset(keyboardKey, "OnDown", function(_)
		flag2 = true
		update()

		onClicked()
	end)
	rawset(keyboardKey, "OnUp", function(_)
		flag2 = false
		update()
	end)
	rawset(keyboardKey, "GetCurrentKeyValue", function(_)
		local shift = object:GetShift()
		local caps = object:GetCaps()

		if v7 then
			if caps and shift then
				return string.lower(list[#list])
			end

			if caps or shift then
				return list[1]
			end

			return string.lower(list[#list])
		elseif shift then
			return list[1]
		else
			return list[#list]
		end
	end)

	rawset(keyboardKey, "ContainsPoint", function(_, p, p2)
		local pointInGuiObject = PointInGuiObject(parent2, p, p2) -- inferred equivalent call

		if pointInGuiObject then
			return pointInGuiObject
		end

		pointInGuiObject = v5

		if not pointInGuiObject then
			return pointInGuiObject
		end

		if PointInGuiObject(v5, p, p2) then -- inferred equivalent call
			return true
		end

		pointInGuiObject = false
		return false
	end)

	rawset(keyboardKey, "Update", function(_)
		update()
	end)
	rawset(keyboardKey, "GetInstance", function(_)
		return parent
	end)

	parent.MouseButton1Down:connect(function()
		keyboardKey:OnDown()
	end)
	parent.MouseButton1Up:connect(function()
		keyboardKey:OnUp()
	end)
	parent.SelectionGained:connect(function()
		v9[parent] = true
		keyboardKey:OnEnter()
	end)
	parent.SelectionLost:connect(function()
		v9[parent] = nil
		keyboardKey:OnLeave()
	end)

	if v5 then
		v5.MouseButton1Down:connect(function()
			keyboardKey:OnDown()
		end)
		v5.MouseButton1Up:connect(function()
			keyboardKey:OnUp()
		end)
		v5.SelectionGained:connect(function()
			v9[v5] = true
			keyboardKey:OnEnter()
		end)
		v5.SelectionLost:connect(function()
			v9[v5] = nil
			keyboardKey:OnLeave()
		end)
	end

	update()

	return keyboardKey
end

local function CreateBaseVoiceState()
	return {
		Name = "Base",
		TransitionFrom = function(self) end,
		TransitionTo = function(self) end
	}
end

local function CreateListeningVoiceState()
	local listening = CreateBaseVoiceState()

	listening.Name = "Listening"

	function listening:TransitionTo()
		pcall(function()
			SoundService:BeginRecording()
		end)
	end

	return listening
end

local function CreateProcessingVoiceState() -- 1 equivalent call inferred from this helper
	local processing = CreateBaseVoiceState()

	processing.Name = "Processing"

	local v3 = false
	local resultAsync = nil

	function processing:TransitionTo()
		coroutine.wrap(function()
			pcall(function()
				resultAsync = SoundService:EndRecording()
			end)
			v3 = true
		end)()
	end

	function processing:GetResultAsync()
		while not v3 do
			wait()
		end

		return resultAsync
	end

	return processing
end

local function CreateWaitingVoiceState() -- 2 equivalent calls inferred from this helper
	local waiting = CreateBaseVoiceState()

	waiting.Name = "Waiting"

	return waiting
end

local v3 = {
	Listening = { Processing = true },
	Processing = { Waiting = true },
	Waiting = { Listening = true }
}

local class = {}
class.CurrentState = CreateWaitingVoiceState() -- inferred equivalent call
local bindableEvent = Instance.new("BindableEvent")

function class:TransitionState(currentState): boolean
	if not v3[self.CurrentState.Name][currentState.Name] then
		return false
	end

	self.CurrentState:TransitionFrom()
	self.CurrentState = currentState
	self.CurrentState:TransitionTo()
	bindableEvent:Fire(self.CurrentState)
	return true
end

function class:GetCurrentState()
	return self.CurrentState
end

class.StateTransitionedEvent = bindableEvent.Event

local function ConstructKeyboardUI(items)
	local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
	local panel3D = VrCommon.Panel3D
	local keyboard = panel3D.Get("Keyboard")
	keyboard:SetVisible(false)

	local v4 = {}

	local parent = Create("Frame")({
		Name = "VirtualKeyboard",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Active = true,
		Visible = false
	})

	local parent2 = Create("ImageLabel")({
		Name = "TextEntryBackground",
		Size = UDim2.new(0.5, 0, 0.125, 0),
		Position = UDim2.new(0.25, 0, 0, 0),
		Image = "",
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.new(31 / 255, 31 / 255, 31 / 255),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = parent
	})

	local parent3 = Create("Frame")({
		Name = "TextfieldBackground",
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.new(209 / 255, 216 / 255, 221 / 255),
		BorderSizePixel = 0,
		Visible = true,
		Parent = parent2
	})

	local parent4 = Create("TextButton")({
		Name = "TextEntryField",
		Text = "",
		Position = UDim2.new(0, 4, 0, 4),
		Size = UDim2.new(1, -8, 1, -8),
		Font = Enum.Font.SourceSans,
		FontSize = Enum.FontSize.Size60,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent3
	})

	local v5 = Create("Frame")({
		Name = "TextfieldCursor",
		Size = UDim2.new(0, 5, 0.9, 0),
		Position = UDim2.new(0, 0, 0.05, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = color4,
		BorderSizePixel = 0,
		Visible = true,
		ZIndex = 2,
		Parent = parent4
	})

	local parent5 = Create("ImageButton")({
		Name = "CloseButton",
		Size = UDim2.new(0.075, -10, 0.198, -10),
		Position = UDim2.new(0, -5, 0, -35),
		Image = "rbxasset://textures/ui/Keyboard/close_button_background.png",
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Parent = parent
	})

	parent5.SelectionImageObject = Create("ImageLabel")({
		Name = "Selection",
		Size = UDim2.new(0.9, 0, 0.9, 0),
		Position = UDim2.new(0.05, 0, 0.05, 0),
		Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png",
		BackgroundTransparency = 1
	})

	Create("ImageLabel")({
		Name = "Icon",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		Image = "rbxasset://textures/ui/Keyboard/close_button_icon.png",
		BackgroundTransparency = 1,
		Parent = parent5
	})

	local vrButton = CreateVRButton(parent5)
	table.insert(v4, vrButton)

	local parent6 = Create("Frame")({
		Name = "VoiceRecognitionContainer",
		Size = UDim2.new(1, 0, 0.85, 0),
		Position = UDim2.new(0, 0, 0.15, 0),
		BackgroundTransparency = 1,
		Active = true,
		Visible = false,
		Parent = parent
	})

	local clone = Create("Frame")({
		Name = "voiceRecognitionBackground1",
		Size = UDim2.new(1, 0, 0.75, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Active = true,
		Parent = parent6
	}):Clone()
	clone.Size = UDim2.new(0.8, 0, 0.25, 0)
	clone.Position = UDim2.new(0, 0, 0.75, 0)
	clone.Parent = parent6

	local vrButton2 = CreateVRButton(Create("TextButton")({
		Name = "DoneButton",
		Size = UDim2.new(0.2, -5, 0.25, -5),
		Position = UDim2.new(0.8, 5, 0.75, 5),
		Text = "Done",
		BackgroundColor3 = color4,
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color5,
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = parent6
	}))

	table.insert(v4, vrButton2)

	local v6 = Create("TextLabel")({
		Name = "VoiceProcessingStatus",
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.33, 0),
		Text = "",
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size96,
		TextColor3 = color5,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent6
	})

	local function CreateVoiceVisualizerWidget()
		local v7 = Create("Frame")({
			Name = "VoiceVisualizerContainer",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		})
		local voiceVisualizerWidget = {}
		voiceVisualizerWidget.Container = v7
		local v8 = {}

		for i = 1, 50 do
			table.insert(v8, (Create("Frame")({
				Name = "Bar",
				Size = UDim2.new(0.02, -4, 1, 0),
				Position = UDim2.new(i / 50, 0, 0, 0),
				BackgroundTransparency = 0,
				BackgroundColor3 = color5,
				Parent = v7
			})))
		end

		function voiceVisualizerWidget:StartAnimation()
			RunService:UnbindFromRenderStep("VoiceVisualizerWidget")
			RunService:BindToRenderStep("VoiceVisualizerWidget", Enum.RenderPriority.First.Value, function()
				for k, v9 in pairs(v8) do
					local v10 = ((math.abs((math.sin(tick() * 2.5 + k * 0.5026548245743669))) + math.abs((math.cos(tick() * 2.5 + k * 0.5026548245743669)))) / 2 - 0.3) * (10 / 7)
					v9.Size = UDim2.new(0.02, -4, v10, 0)
					v9.Position = UDim2.new(k / 50, 0, (1 - v10) / 2, 0)
				end
			end)
		end

		function voiceVisualizerWidget:StopAnimation()
			RunService:UnbindFromRenderStep("VoiceVisualizerWidget")
		end

		return voiceVisualizerWidget
	end

	local voiceVisualizerWidget = CreateVoiceVisualizerWidget()
	voiceVisualizerWidget.Container.Parent = parent6
	voiceVisualizerWidget.Container.Size = UDim2.new(0.5, 0, 0.4, 0)
	voiceVisualizerWidget.Container.Position = UDim2.new(0.25, 0, 0.4, 0)

	local extendedInstance = ExtendedInstance(parent)

	local v7 = nil
	local v8 = {}

	local v9 = false
	local v10 = false

	local v11 = 0

	local bindableEvent2 = Instance.new("BindableEvent")
	local bindableEvent3 = Instance.new("BindableEvent")
	local flag = false

	local function SetTextFieldCursorPosition(p)
		v11 = Clamp(0, #parent4.Text, p)

		if not parent4.TextFits then
			v11 = #parent4.Text
		end

		local textSize = TextService:GetTextSize(
			string.sub(parent4.Text, 1, v11),
			ConvertFontSizeEnumToInt(parent4.FontSize), -- inferred equivalent call
			parent4.Font,
			parent4.AbsoluteSize
		)
		v5.Position = UDim2.new(0, textSize.x, v5.Position.Y.Scale, v5.Position.Y.Offset)
	end

	local function UpdateTextEntryFieldText(p) -- 3 equivalent calls inferred from this helper
		parent4:SetTextFromInput(p)
		SetTextFieldCursorPosition(v11)
	end

	local v12 = ""
	local function getBufferText() -- 3 equivalent calls inferred from this helper
		return if v7 and v7.TextBox then v7.TextBox.Text else v12
	end

	local function setBufferText(text) -- 5 equivalent calls inferred from this helper
		if v7 and v7.TextBox then
			v7.TextBox.Text = text
		elseif v12 ~= text then
			v12 = text
			UpdateTextEntryFieldText(v12) -- inferred equivalent call
		end
	end

	local function calculateTextCursorPosition(x, y)
		local v13 = x - parent4.AbsolutePosition.x
		y -= parent4.AbsolutePosition.y

		for i = 1, #parent4.Text do
			if v13 < TextService:GetTextSize(
				string.sub(parent4.Text, 1, i),
				ConvertFontSizeEnumToInt(parent4.FontSize), -- inferred equivalent call
				parent4.Font,
				parent4.AbsoluteSize
			).x then
				return i - 1
			end
		end

		return #parent4.Text
	end

	local v13 = nil

	rawset(extendedInstance, "OpenedEvent", bindableEvent2.Event)
	rawset(extendedInstance, "ClosedEvent", bindableEvent3.Event)

	rawset(extendedInstance, "GetCurrentKeyset", function(_)
		return v8[v13]
	end)

	rawset(extendedInstance, "SetCurrentKeyset", function(_, p)
		if p ~= v13 and v8[p] ~= nil then
			if v8[v13] and v8[v13].container then
				v8[v13].container.Visible = false
			end

			v13 = p

			if v8[v13] and v8[v13].container then
				v8[v13].container.Visible = true
			end
		end
	end)

	rawset(extendedInstance, "SetVoiceMode", function(object, _)
		local currentKeyset = object:GetCurrentKeyset()

		if currentKeyset and currentKeyset.container then
			currentKeyset.container.Visible = true
		end

		parent6.Visible = false
	end)

	rawset(extendedInstance, "GetCaps", function(_)
		return v9
	end)

	rawset(extendedInstance, "SetCaps", function(object, p)
		v9 = p

		for _, key in pairs(object:GetCurrentKeyset().keys) do
			key:Update()
		end
	end)

	rawset(extendedInstance, "GetShift", function(_)
		return v10
	end)

	rawset(extendedInstance, "SetShift", function(object, p)
		v10 = p

		for _, key in pairs(object:GetCurrentKeyset().keys) do
			key:Update()
		end
	end)

	local v14 = false

	local changedConnection = nil
	local focusLostConnection = nil
	local eventConnection = nil

	local function disconnectKeyboardEvents() -- 2 equivalent calls inferred from this helper
		if changedConnection then
			changedConnection:disconnect()
		end

		changedConnection = nil

		if focusLostConnection then
			focusLostConnection:disconnect()
		end

		focusLostConnection = nil

		if eventConnection then
			eventConnection:disconnect()
		end

		eventConnection = nil
	end

	rawset(extendedInstance, "Open", function(object, p)
		if flag then
			return
		end

		flag = true

		v7 = p

		object:SetCurrentKeyset(1)
		object:SetVoiceMode(false)
		parent.Visible = true

		keyboard:ResizeStuds(5.9, 2.25, 320)

		local cframe = CFrame.new()
		disconnectKeyboardEvents() -- inferred equivalent call

		if p.TextBox then
			changedConnection = p.TextBox.Changed:connect(function(p2)
				if p2 == "Text" then
					UpdateTextEntryFieldText(p.TextBox.Text) -- inferred equivalent call
				end
			end)
			focusLostConnection = p.TextBox.FocusLost:connect(function(p2)
				if not v14 then
					object:Close(p2)
				end
			end)

			if p.TextBox.ClearTextOnFocus then
				setBufferText("") -- inferred equivalent call
			else
				UpdateTextEntryFieldText(p.TextBox.Text) -- inferred equivalent call
			end

			local containerOf = panel3D.FindContainerOf(p.TextBox)

			if containerOf then
				eventConnection = panel3D.OnPanelClosed.Event:connect(function(p2)
					if p2 == containerOf.name then
						object:Close(false)
					end
				end)

				local v15 = p.TextBox.AbsolutePosition + Vector2.new(0.5, 1) * p.TextBox.AbsoluteSize
				cframe = containerOf:GetCFrameInCameraSpace() * CFrame.new(containerOf:GetGuiPositionInPanelSpace(v15)) * CFrame.new(0, -keyboard.height * 0.65, 0.5) * CFrame.Angles(-0.39269908169872414, 0, 0)
			else
				cframe = panel3D.GetHeadLookXZ(true) * CFrame.Angles(0.39269908169872414, 0, 0) * CFrame.new(0, -1, -5)
			end
		else
			setBufferText("") -- inferred equivalent call
		end

		ContextActionService:BindCoreAction("VirtualKeyboardControllerInput", function(_, p2, p3)
			if p2 == Enum.UserInputState.End then
				if p3.KeyCode == Enum.KeyCode.ButtonL1 then
					SetTextFieldCursorPosition(v11 - 1)
				elseif p3.KeyCode == Enum.KeyCode.ButtonR1 then
					SetTextFieldCursorPosition(v11 + 1)
				elseif p3.KeyCode == Enum.KeyCode.ButtonX then
					object:BackspaceAtCursor()
				elseif p3.KeyCode == Enum.KeyCode.ButtonY then
					object:SubmitCharacter(" ", false)
				elseif p3.KeyCode == Enum.KeyCode.ButtonL2 then
					if v13 then
						object:SetCurrentKeyset(v13 % #v8 + 1)
					end
				elseif p3.KeyCode == Enum.KeyCode.ButtonL3 then
					object:SetCaps(not object:GetCaps())
				elseif p3.KeyCode == Enum.KeyCode.ButtonB then
					object:Close(false)
				end
			end
		end, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonL3, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonB)

		object.Parent = keyboard:GetGUI()

		keyboard:SetType(panel3D.Type.Fixed, { CFrame = cframe })
		keyboard:SetCanFade(false)
		keyboard:SetVisible(true, true)
		keyboard:ForceShowUntilLookedAt()

		function keyboard.OnUpdate(_) end

		bindableEvent2:Fire()
	end)

	rawset(extendedInstance, "Close", function(object, p)
		local v15 = p == true

		if not flag then
			return
		end

		flag = false
		disconnectKeyboardEvents() -- inferred equivalent call
		ContextActionService:UnbindCoreAction("VirtualKeyboardControllerInput")

		keyboard:OnMouseLeave()
		keyboard:SetVisible(false, true)
		parent.Visible = false

		panel3D.Get("Topbar3D"):SetVisible(true)

		object:SubmitText(v15, false)
		bindableEvent3:Fire()
	end)

	rawset(extendedInstance, "SubmitText", function(_, p, p2)
		local textBox = v7 and v7.TextBox

		if textBox then
			if p then
				textBox.Text = getBufferText() -- inferred equivalent call
			end

			local containerOf = panel3D.FindContainerOf(textBox)
			local v15 = p2 and containerOf and containerOf.linkedTo == keyboard

			if v15 then
				v14 = true
			end

			textBox:ReleaseFocus(p)

			if v15 then
				textBox:CaptureFocus()
				v14 = false
			end
		end
	end)

	rawset(extendedInstance, "GetCurrentOptions", function(_)
		return v7
	end)

	rawset(extendedInstance, "BackspaceAtCursor", function(_)
		if v11 >= 1 then
			local bufferText = getBufferText() -- inferred equivalent call
			local text = string.sub(bufferText, 1, v11 - 1) .. string.sub(bufferText, v11 + 1, #bufferText)
			local v15 = v11 - 1
			setBufferText(text) -- inferred equivalent call
			SetTextFieldCursorPosition(v15)
		end
	end)

	rawset(extendedInstance, "SubmitCharacter", function(object, list, p)
		local bufferText = getBufferText() -- inferred equivalent call
		setBufferText(string.sub(bufferText, 1, v11) .. list .. string.sub(bufferText, v11 + 1, #bufferText)) -- inferred equivalent call

		SetTextFieldCursorPosition(v11 + #list)

		if p and object:GetShift() then
			object:SetShift(false)
		end
	end)

	for _, item in pairs(items) do
		local v15 = Create("Frame")({
			Name = "KeyboardSizeConstrainer",
			Size = UDim2.new(1, 0, 1, -20),
			Position = UDim2.new(0, 0, 0, 20),
			BackgroundTransparency = 1,
			Parent = parent
		})
		local total = 0
		local keys = {}
		local maxValue = 0
		local maxValue2 = 0

		for _, v16 in pairs(item) do
			local total2 = 0
			local width = 1
			local height = 1
			local x2 = nil
			local y2 = nil
			local w2 = nil
			local h2 = nil

			for _, v17 in pairs(v16) do
				if type(v17) == "table" then
					if v17.w then
						width = v17.w
					end

					if v17.h then
						height = v17.h
					end

					if v17.x then
						total2 += v17.x
					end

					if v17.y then
						total += v17.y
					end

					if v17.x2 then
						x2 = v17.x2
					end

					if v17.y2 then
						y2 = v17.y2
					end

					if v17.w2 then
						w2 = v17.w2
					end

					if v17.h2 then
						h2 = v17.h2
					end
				elseif type(v17) == "string" then
					local v18 = v17 == "" and " " or v17
					local v19 = {}

					for k in string.gmatch(v18, "([^\n]+)") do
						table.insert(v19, k)
					end

					table.insert(keys, CreateKeyboardKey(extendedInstance, {
						x = total2,
						y = total,
						width = width,
						height = height,
						x2 = x2,
						y2 = y2,
						width2 = w2,
						height2 = h2
					}, v19))

					total2 += width
					maxValue = math.max(maxValue, total2)
					maxValue2 = math.max(maxValue2, total + height)
					width = 1
					height = 1
					x2 = nil
					y2 = nil
					w2 = nil
					h2 = nil
				end
			end

			total += 1
		end

		for _, v16 in pairs(keys) do
			v16.Position = UDim2.new(v16.Position.X.Scale / maxValue, 0, v16.Position.Y.Scale / maxValue2, 0)
			v16.Size = UDim2.new(v16.Size.X.Scale / maxValue, 0, v16.Size.Y.Scale / maxValue2, 0)
			v16.Parent = v15
		end

		v15.SizeConstraint = Enum.SizeConstraint.RelativeXX
		v15.Size = UDim2.new(1, 0, -maxValue2 / maxValue, 0)
		v15.Position = UDim2.new(0, 0, 1, 0)
		v15.Visible = false

		table.insert(v8, { keys = keys, container = v15 })
	end

	extendedInstance:SetCurrentKeyset(1)

	parent4.MouseButton1Click:connect(function()
		SetTextFieldCursorPosition(calculateTextCursorPosition(keyboard.lookAtPixel.X, keyboard.lookAtPixel.Y))
	end)

	vrButton.MouseButton1Click:connect(function()
		extendedInstance:Close(false)
	end)

	vrButton2.MouseButton1Click:connect(function()
		if class:GetCurrentState().Name == "Listening" then
			class:TransitionState(CreateProcessingVoiceState()) -- inferred equivalent call
		end
	end)

	local function onVoiceProcessingStateChanged(currentState)
		if currentState.Name == "Listening" then
			v6.Text = "Listening..."
		elseif currentState.Name == "Processing" then
			v6.Text = "Processing..."
		elseif currentState.Name == "Waiting" then
			v6.Text = "Done"
		end

		if currentState.Name == "Processing" then
			coroutine.wrap(function()
				voiceVisualizerWidget:StopAnimation()
				local resultAsync = currentState:GetResultAsync()

				if resultAsync and resultAsync.Status == v.ASR_STATUS_OK then
					setBufferText(resultAsync.Response) -- inferred equivalent call
				else
					v6.Text = "An error occurred, please try again."
					wait(2)
				end

				class:TransitionState(CreateWaitingVoiceState()) -- inferred equivalent call
			end)()
		elseif currentState.Name == "Listening" then
			voiceVisualizerWidget:StartAnimation()
		elseif currentState.Name == "Waiting" then
			extendedInstance:SetVoiceMode(false)
		end
	end
	class.StateTransitionedEvent:connect(onVoiceProcessingStateChanged)
	onVoiceProcessingStateChanged(class:GetCurrentState())

	return extendedInstance
end

local keyboard = nil
local function GetKeyboard() -- 2 equivalent calls inferred from this helper
	if keyboard == nil then
		keyboard = ConstructKeyboardUI({ jsonDecode, jsonDecode2 })
	end

	return keyboard
end

local VirtualKeyboard = {}

function VirtualKeyboard.CreateVirtualKeyboardOptions(_, textBox)
	return { TextBox = textBox }
end

function VirtualKeyboard.ShowVirtualKeyboard(_, _) end

function VirtualKeyboard.CloseVirtualKeyboard(_) end

VirtualKeyboard.OpenedEvent = GetKeyboard().OpenedEvent -- inferred equivalent call
VirtualKeyboard.ClosedEvent = GetKeyboard().ClosedEvent -- inferred equivalent call
return VirtualKeyboard
