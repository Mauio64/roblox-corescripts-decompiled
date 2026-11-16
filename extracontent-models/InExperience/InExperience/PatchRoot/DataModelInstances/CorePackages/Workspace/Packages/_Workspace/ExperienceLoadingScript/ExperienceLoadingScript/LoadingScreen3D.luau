local parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent

local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

local SplashScreenManager = require(parent.SplashScreenManager)
local splashScreenManager = SplashScreenManager.SplashScreenManager
local defineFastFlag = game:DefineFastFlag("LoadingRemoveRemoteCallErrorPrint", false)
local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create
local function FadeElements(instance, p, value)
	local v = value or 0.5

	if instance == nil then
		return
	end

	local tweenInfo = TweenInfo.new(v, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
		TweenService:Create(instance, tweenInfo, { ImageTransparency = p }):Play()
	end

	if instance:IsA("GuiObject") then
		TweenService:Create(instance, tweenInfo, { BackgroundTransparency = p }):Play()
	end

	if instance:IsA("TextLabel") or instance:IsA("TextBox") or instance:IsA("TextButton") then
		TweenService:Create(instance, tweenInfo, { TextTransparency = p }):Play()
	end

	for _, child in pairs(instance:GetChildren()) do
		FadeElements(child, p, v)
	end
end

local class = {}

local bindableEvent = Instance.new("BindableEvent")
class.Finished = false
class.GameAssetInfo = nil
class.LoadingFinishedEvent = bindableEvent.Event

function class:GetGameName()
	if self.GameAssetInfo == nil then
		return ""
	end

	return self.GameAssetInfo.Name
end

function class:GetCreatorName()
	if self.GameAssetInfo == nil then
		return ""
	end

	return self.GameAssetInfo.Creator.Name
end

function class:IsReady()
	return self.Finished
end

function class:LoadAssetsAsync()
	spawn(function()
		while game.PlaceId <= 0 do
			wait()
		end

		local success, result = pcall(function()
			self.GameAssetInfo = MarketplaceService:GetProductInfoAsync(game.PlaceId)
		end)

		if not (defineFastFlag or success) then
			print("LoadingScript->GameInfoProvider:LoadAssets:", result)
		end

		self.Finished = true
		bindableEvent:Fire()
	end)
end

local parent2 = Create("Frame")({
	Name = "VRLoadingScreenContainer",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BackgroundColor3 = Color3.new(0, 0, 0)
})

local parent3 = Create("ImageLabel")({
	Name = "LoadingBackground",
	Position = UDim2.new(0.25, 0, 0.25, 0),
	Size = UDim2.new(0.5, 0, 0.5, 0),
	Image = "rbxasset://textures/ui/LoadingScreen/BackgroundLight.png",
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(70, 70, 110, 110),
	BackgroundTransparency = 1,
	Parent = parent2,
	ImageColor3 = Color3.new(0, 0, 0)
})

local total = 0
local v = Create("ImageLabel")({
	Name = "Spinner",
	Size = UDim2.new(0.25, 0, 0.25, 0),
	SizeConstraint = Enum.SizeConstraint.RelativeYY,
	Position = UDim2.new(0.375, 0, 0.325, 0),
	Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
	BackgroundTransparency = 1,
	Parent = parent3
})

local v2 = Create("TextLabel")({
	Name = "LoadingText",
	Text = "Loading...",
	BackgroundTransparency = 1,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size60,
	Position = UDim2.new(0.5, 0, 0.2, 0),
	Parent = parent3,
	TextColor3 = Color3.new(77 / 255, 163 / 255, 224 / 255)
})

local v3 = Create("TextLabel")({
	Name = "GameNameText",
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size60,
	Size = UDim2.new(0.9, 0, 0.1, 0),
	Position = UDim2.new(0.05, 0, 0.65, 0),
	ClipsDescendants = true,
	Parent = parent3,
	TextColor3 = Color3.new(1 / 17, 237 / 255, 1)
})

local parent4 = Create("Frame")({
	Name = "CreatorTextContainer",
	Size = UDim2.new(0.9, 0, 0.1, 0),
	Position = UDim2.new(0.05, 0, 0.77, 0),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Parent = parent3
})

local v4 = 0
local v5 = Create("TextLabel")({
	Name = "CreatorText",
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size42,
	Size = UDim2.new(1, 0, 1, 0),
	Parent = parent4,
	TextColor3 = Color3.new(1 / 17, 237 / 255, 1)
})

local flag = false
local v6 = true
delay(2.5, function()
	v6 = false
end)
local function UpdateLayout(p)
	if v5.TextBounds.X < parent4.AbsoluteSize.X then
		v5.Position = UDim2.new(0, 0, 0, 0)
		v5.Size = UDim2.new(1, 0, 1, 0)
	elseif p ~= nil then
		v5.Size = UDim2.new(0, v5.TextBounds.X, 1, 0)

		if not v6 then
			local v7 = v4 - p * 25

			if v7 + v5.AbsoluteSize.X < parent4.AbsoluteSize.X then
				v6 = true
				spawn(function()
					local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

					TweenService:Create(v5, tweenInfo, { TextTransparency = 1 }):Play()
					wait(1.5)

					if flag then
						return
					end

					v4 = 0
					TweenService:Create(v5, tweenInfo, { TextTransparency = 0 }):Play()
					wait(1.5)
					v6 = false
				end)
			else
				v4 = v7
			end
		end

		v5.Position = UDim2.new(0, v4, 0, 0)
	end

	if not v3.TextFits then
		v3.Size = UDim2.new(0.9, 0, 0.3, 0)
		v3.Position = UDim2.new(0.05, 0, 0.5, 0)
		v3.TextScaled = true
		v3.TextWrapped = true

		v.Position = UDim2.new(0.375, 0, 0.225, 0)
		v2.Position = UDim2.new(0.5, 0, 0.15, 0)
	end
end

local function CleanUp() -- 3 equivalent calls inferred from this helper
	if flag then
		return
	end

	flag = true

	FadeElements(parent2, 1, 2.5)
	wait(2.5)

	RunService:UnbindFromRenderStep("LoadingGui3D")
	parent2.Parent = nil
end

local function OnGameInfoLoaded() -- 1 equivalent call inferred from this helper
	local text = class:GetCreatorName()

	if text and text ~= "" then
		text = string.format("By %s", (tostring(text)))
	end

	v3.Text = class:GetGameName()
	v5.Text = text
end

local function OnDefaultLoadingGuiRemoved()
	CleanUp() -- inferred equivalent call
end

local v7 = tick()
RunService:BindToRenderStep("LoadingGui3D", Enum.RenderPriority.Last.Value, function()
	local now = tick()
	local v8 = now - v7

	UpdateLayout(v8)

	local v9 = v8 * 0.5 * 360
	total += v9
	v.Rotation = total

	v7 = now
end)
UpdateLayout()

class:LoadAssetsAsync()

if class:IsReady() then
	OnGameInfoLoaded() -- inferred equivalent call
end

class.LoadingFinishedEvent:Connect(OnGameInfoLoaded)

if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
	CleanUp() -- inferred equivalent call
else
	ReplicatedFirst.RemoveDefaultLoadingGuiSignal:connect(OnDefaultLoadingGuiRemoved)
end

GuiService.ErrorMessageChanged:connect(function() end)

GuiService.UiMessageChanged:connect(function(_, _) end)

splashScreenManager.addStatusChangeListener(function(p)
	if p then
		CleanUp() -- inferred equivalent call
	end
end)

return parent2
