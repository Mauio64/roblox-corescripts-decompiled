local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local EngineFeature = game:GetEngineFeature("FixCASGetButtonYielded")
local v6 = game:DefineFastFlag("FixCASMaxTouchButtons", false)
local _ = UserInputService.TouchEnabled
local t1 = {}
local t2 = {}
local ScreenGui = nil
local Frame = nil
local t3 = {
	[1] = UDim2.new(0, 123, 0, 70),
	[2] = UDim2.new(0, 30, 0, 60),
	[3] = UDim2.new(0, 180, 0, 160),
	[4] = UDim2.new(0, 85, 0, -25),
	[5] = UDim2.new(0, 185, 0, -25),
	[6] = UDim2.new(0, 185, 0, 260),
	[7] = UDim2.new(0, 216, 0, 65)
}
local v13 = #t3

game:GetService("ContentProvider"):Preload("https://www.roblox.com/asset/?id=97166756")
game:GetService("ContentProvider"):Preload("https://www.roblox.com/asset/?id=97166444")

local CoreGui = game:GetService("CoreGui")

game:GetService("CorePackages")

local RobloxGui = CoreGui.RobloxGui
local CoreUtility = require(RobloxGui.Modules.CoreUtility)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v18 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerGui")

function createContextActionGui() -- line: 61
	-- upvalues: ScreenGui (ref), Frame (ref), UserInputService (copy), GuiService (copy)
	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "ContextActionGui"
		ScreenGui.ResetOnSpawn = false
		Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(0.3, 0, 0.5, 0)
		Frame.Position = UDim2.new(0.7, 0, 0.5, 0)
		Frame.Name = "ContextButtonFrame"
		Frame.Parent = ScreenGui

		local function v22() -- line: 73
			-- upvalues: Frame (ref), UserInputService (copy), GuiService (copy)
			Frame.Visible = UserInputService.PreferredInput == Enum.PreferredInput.Touch and GuiService.TouchControlsEnabled
		end

		GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(v22)
		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(v22)
		Frame.Visible = UserInputService.PreferredInput == Enum.PreferredInput.Touch and GuiService.TouchControlsEnabled
	end
end
function setButtonSizeAndPosition(p1) -- line: 84
	local n1 = 55

	if not (game:GetService("CoreGui").RobloxGui.AbsoluteSize.X < 600) then
		n1 = 85
	end

	p1.Size = UDim2.new(0, n1, 0, n1)
end
function contextActionButtonDown(p2, p3, p4) -- line: 99
	-- upvalues: ContextActionService (copy)
	p2.Image = "https://www.roblox.com/asset/?id=97166756"
	ContextActionService:CallFunction(p4, Enum.UserInputState.Begin, p3)
end
function contextActionButtonMoved(p5, p6, p7) -- line: 104
	-- upvalues: ContextActionService (copy)
	p5.Image = "https://www.roblox.com/asset/?id=97166756"
	ContextActionService:CallFunction(p7, Enum.UserInputState.Change, p6)
end
function contextActionButtonUp(p8, p9, p10) -- line: 109
	-- upvalues: ContextActionService (copy)
	p8.Image = "https://www.roblox.com/asset/?id=97166444"
	ContextActionService:CallFunction(p10, Enum.UserInputState.End, p9)
end
function contextActionButtonCancel(p11, p12, p13) -- line: 114
	-- upvalues: ContextActionService (copy)
	p11.Image = "https://www.roblox.com/asset/?id=97166444"
	ContextActionService:CallFunction(p13, Enum.UserInputState.Cancel, p12)
end
function isSmallScreenDevice() -- line: 119
	return game:GetService("GuiService"):GetScreenResolution().Y <= 320
end
function createNewButton(p14, p15) -- line: 124
	-- upvalues: Frame (ref), UserInputService (copy)
	local ImageButton = Instance.new("ImageButton")

	ImageButton.Name = "ContextActionButton"
	ImageButton.BackgroundTransparency = 1
	ImageButton.Size = UDim2.new(0, 45, 0, 45)
	ImageButton.Active = true

	if isSmallScreenDevice() then
		ImageButton.Size = UDim2.new(0, 35, 0, 35)
	end

	ImageButton.Image = "https://www.roblox.com/asset/?id=97166444"
	ImageButton.Parent = Frame

	local u40 = nil
	local u41 = false

	UserInputService.InputEnded:connect(function(p16) -- line: 151
		-- upvalues: u40 (ref), u41 (ref), ImageButton (copy), p14 (copy)
		if p16.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p16 ~= u40 then
			return
		end

		if p16.UserInputState == Enum.UserInputState.End and u41 then
			contextActionButtonCancel(ImageButton, p16, p14)
		end

		u40 = nil
		u41 = false
	end)
	ImageButton.InputBegan:connect(function(p17) -- line: 167
		-- upvalues: u40 (ref), u41 (ref), ImageButton (copy), p14 (copy)
		if p17.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p17.UserInputState == Enum.UserInputState.Begin then
			u40 = p17
			u41 = false
			contextActionButtonDown(ImageButton, p17, p14)

			return
		end

		if p17.UserInputState == Enum.UserInputState.Change then
			if p17 ~= u40 then
				return
			end

			u41 = false
		end
	end)
	ImageButton.InputEnded:connect(function(p18) -- line: 186
		-- upvalues: u40 (ref), u41 (ref), ImageButton (copy), p14 (copy)
		if p18.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p18 ~= u40 then
			return
		end

		if p18.UserInputState == Enum.UserInputState.End then
			u40 = nil
			u41 = false
			contextActionButtonUp(ImageButton, p18, p14)

			return
		end

		if p18.UserInputState == Enum.UserInputState.Change then
			u41 = true
		end
	end)
	ImageButton.InputChanged:connect(function(p19) -- line: 205
		-- upvalues: u40 (ref), ImageButton (copy), p14 (copy)
		if p19.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if p19 ~= u40 then
			return
		end

		contextActionButtonMoved(ImageButton, p19, p14)
	end)

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "ActionIcon"
	ImageLabel.Position = UDim2.new(0.175, 0, 0.175, 0)
	ImageLabel.Size = UDim2.new(0.65, 0, 0.65, 0)
	ImageLabel.BackgroundTransparency = 1

	if p15.image and type(p15.image) == "string" then
		ImageLabel.Image = p15.image
	end

	ImageLabel.Parent = ImageButton

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "ActionTitle"
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0
	TextLabel.FontSize = Enum.FontSize.Size18
	TextLabel.TextWrapped = true
	TextLabel.Text = ""

	if p15.title and type(p15.title) == "string" then
		TextLabel.Text = p15.title
	end

	TextLabel.Parent = ImageButton

	return ImageButton
end
function createButton(p20, p21) -- line: 243
	-- upvalues: v6 (copy), t2 (copy), v13 (copy), t1 (copy), t3 (copy), Frame (ref), ScreenGui (ref), v18 (copy)
	local v46 = nil

	if not v6 then
		v46 = createNewButton(p20, p21)
	end

	local v47 = nil

	for i = 1, #t2 do
		if t2[i] == "empty" then
			v47 = i

			break
		end
	end

	if not v47 then
		v47 = #t2 + 1
	end

	if v47 > v13 then
		if v6 then
			warn("Maximum of 7 allowed touch buttons, new touch button not created for " .. p20 .. ".")
		end

		return
	end

	if v6 then
		v46 = createNewButton(p20, p21)
	end

	t2[v47] = v46
	t1[p20].button = v46
	v46.Position = t3[v47]
	v46.Parent = Frame

	if ScreenGui and ScreenGui.Parent == nil then
		ScreenGui.Parent = v18

		if not Frame.Parent then
			Frame.Parent = ScreenGui
		end
	end
end
function removeAction(p22) -- line: 286
	-- upvalues: t1 (copy), t2 (copy)
	if not t1[p22] then
		return
	end

	local button = t1[p22].button

	if button then
		button.Parent = nil

		for i = 1, #t2 do
			if button == t2[i] then
				t2[i] = "empty"

				break
			end
		end

		button:Destroy()
	end

	t1[p22] = nil
end
function addAction(p23, p24, p25) -- line: 307
	-- upvalues: t1 (copy)
	if t1[p23] then
		removeAction(p23)
	end

	t1[p23] = { p25 }

	if p24 then
		createContextActionGui()
		createButton(p23, p25)
	end
end

ContextActionService.BoundActionChanged:connect(function(p26, p27, p28) -- line: 319
	-- upvalues: t1 (copy)
	if t1[p26] and p28 then
		local button = t1[p26].button
		local v59 = p28[p27] or (p27 ~= "image" and (p27 ~= "title" and p27 ~= "description") or "")

		if button then
			if p27 == "image" then
				button.ActionIcon.Image = v59

				return
			end

			if p27 == "title" then
				button.ActionTitle.Text = v59

				return
			end

			if p27 == "description" then
				return
			end

			if p27 == "position" then
				button.Position = v59
			end
		end
	end
end)
ContextActionService.BoundActionAdded:connect(function(p29, p30, p31) -- line: 341
	addAction(p29, p30, p31)
end)
ContextActionService.BoundActionRemoved:connect(function(p32, _) -- line: 345
	removeAction(p32)
end)
ContextActionService.GetActionButtonEvent:connect(function(p34) -- line: 349
	-- upvalues: t1 (copy), ContextActionService (copy)
	if t1[p34] then
		ContextActionService:FireActionButtonFoundSignal(p34, t1[p34].button)
	end
end)

local AllBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

for k, v in pairs(AllBoundActionInfo) do
	addAction(k, v.createTouchButton, v)

	if EngineFeature and t1[k] and t1[k].button then
		ContextActionService:FireActionButtonFoundSignal(k, t1[k].button)
	end
end
