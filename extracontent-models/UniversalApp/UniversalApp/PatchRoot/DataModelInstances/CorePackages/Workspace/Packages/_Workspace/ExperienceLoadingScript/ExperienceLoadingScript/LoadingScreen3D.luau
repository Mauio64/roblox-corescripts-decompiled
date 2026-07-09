local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local SplashScreenManager = require(Parent.SplashScreenManager).SplashScreenManager
local v8 = game:DefineFastFlag("LoadingRemoveRemoteCallErrorPrint", false)
local Create = require(Parent.AppCommonLib).Create

local function FadeElements(p1, p2, p3) -- line: 22
	-- upvalues: TweenService (copy), FadeElements (copy)
	local v33 = p3 or 0.5

	if p1 == nil then
		return
	end

	local tweenInfo = TweenInfo.new(v33, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
		TweenService:Create(p1, tweenInfo, {
			ImageTransparency = p2
		}):Play()
	end

	if p1:IsA("GuiObject") then
		TweenService:Create(p1, tweenInfo, {
			BackgroundTransparency = p2
		}):Play()
	end

	if p1:IsA("TextLabel") or p1:IsA("TextBox") or p1:IsA("TextButton") then
		TweenService:Create(p1, tweenInfo, {
			TextTransparency = p2
		}):Play()
	end

	for _, child in pairs(p1:GetChildren()) do
		FadeElements(child, p2, v33)
	end
end

local t1 = {}
local BindableEvent = Instance.new("BindableEvent")

t1.Finished = false
t1.GameAssetInfo = nil
t1.LoadingFinishedEvent = BindableEvent.Event

function t1.GetGameName(p4) -- line: 51
	if p4.GameAssetInfo ~= nil then
		return p4.GameAssetInfo.Name
	end

	return ""
end
function t1.GetCreatorName(p5) -- line: 59
	if p5.GameAssetInfo ~= nil then
		return p5.GameAssetInfo.Creator.Name
	end

	return ""
end
function t1.IsReady(p6) -- line: 67
	return p6.Finished
end
function t1.LoadAssetsAsync(p7) -- line: 71
	-- upvalues: MarketplaceService (copy), v8 (copy), BindableEvent (copy)
	spawn(function() -- line: 72
		-- upvalues: p7 (copy), MarketplaceService (copy), v8 (copy), BindableEvent (copy)
		while game.PlaceId <= 0 do
			wait()
		end

		local ok, result = pcall(function() -- line: 78
			-- upvalues: p7 (copy), MarketplaceService (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				p7.GameAssetInfo = MarketplaceService:GetProductInfoAsync(game.PlaceId)

				return
			end

			p7.GameAssetInfo = MarketplaceService:GetProductInfo(game.PlaceId)
		end)

		if not v8 and not ok then
			print("LoadingScript->GameInfoProvider:LoadAssets:", result)
		end

		p7.Finished = true
		BindableEvent:Fire()
	end)
end

local v13 = Create("Frame")({
	Name = "VRLoadingScreenContainer",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Color3.new(0, 0, 0)
})
local v14 = Create("ImageLabel")({
	Name = "LoadingBackground",
	Image = "rbxasset://textures/ui/LoadingScreen/BackgroundLight.png",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.25, 0),
	Size = UDim2.new(0.5, 0, 0.5, 0),
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(70, 70, 110, 110),
	Parent = v13,
	ImageColor3 = Color3.new(0, 0, 0)
})
local n1 = 0
local v16 = Create("ImageLabel")({
	Name = "Spinner",
	Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
	BackgroundTransparency = 1,
	Size = UDim2.new(0.25, 0, 0.25, 0),
	SizeConstraint = Enum.SizeConstraint.RelativeYY,
	Position = UDim2.new(0.375, 0, 0.325, 0),
	Parent = v14
})
local v17 = Create("TextLabel")({
	Name = "LoadingText",
	Text = "Loading...",
	BackgroundTransparency = 1,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size60,
	Position = UDim2.new(0.5, 0, 0.2, 0),
	Parent = v14,
	TextColor3 = Color3.new(0.30196078431372547, 0.6392156862745098, 0.8784313725490196)
})
local v18 = Create("TextLabel")({
	Name = "GameNameText",
	Text = "",
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size60,
	Size = UDim2.new(0.9, 0, 0.1, 0),
	Position = UDim2.new(0.05, 0, 0.65, 0),
	Parent = v14,
	TextColor3 = Color3.new(0.058823529411764705, 0.9294117647058824, 1)
})
local v19 = Create("Frame")({
	Name = "CreatorTextContainer",
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Size = UDim2.new(0.9, 0, 0.1, 0),
	Position = UDim2.new(0.05, 0, 0.77, 0),
	Parent = v14
})
local n2 = 0
local v21 = Create("TextLabel")({
	Name = "CreatorText",
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.SourceSans,
	FontSize = Enum.FontSize.Size42,
	Size = UDim2.new(1, 0, 1, 0),
	Parent = v19,
	TextColor3 = Color3.new(0.058823529411764705, 0.9294117647058824, 1)
})
local u22 = false
local u23 = true

delay(2.5, function() -- line: 173
	-- upvalues: u23 (ref)
	u23 = false
end)

local function UpdateLayout(p8) -- line: 176
	-- upvalues: v21 (copy), v19 (copy), u23 (ref), n2 (ref), TweenService (copy), u22 (ref), v18 (copy), v16 (copy), v17 (copy)
	if v21.TextBounds.X < v19.AbsoluteSize.X then
		v21.Position = UDim2.new(0, 0, 0, 0)
		v21.Size = UDim2.new(1, 0, 1, 0)
	elseif p8 ~= nil then
		v21.Size = UDim2.new(0, v21.TextBounds.X, 1, 0)

		if not u23 then
			local v42 = n2 - p8 * 25

			if v42 + v21.AbsoluteSize.X < v19.AbsoluteSize.X then
				u23 = true
				spawn(function() -- line: 186
					-- upvalues: TweenService (copy), v21 (copy), u22 (ref), n2 (ref), u23 (ref)
					local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

					TweenService:Create(v21, tweenInfo, {
						TextTransparency = 1
					}):Play()
					wait(1.5)

					if u22 then
						return
					end

					n2 = 0
					TweenService:Create(v21, tweenInfo, {
						TextTransparency = 0
					}):Play()
					wait(1.5)
					u23 = false
				end)
			else
				n2 = v42
			end
		end

		v21.Position = UDim2.new(0, n2, 0, 0)
	end

	if not v18.TextFits then
		v18.Size = UDim2.new(0.9, 0, 0.3, 0)
		v18.Position = UDim2.new(0.05, 0, 0.5, 0)
		v18.TextScaled = true
		v18.TextWrapped = true
		v16.Position = UDim2.new(0.375, 0, 0.225, 0)
		v17.Position = UDim2.new(0.5, 0, 0.15, 0)
	end
end
local function CleanUp() -- line: 217
	-- upvalues: u22 (ref), FadeElements (copy), v13 (copy), RunService (copy)
	if u22 then
		return
	end

	u22 = true
	FadeElements(v13, 1, 2.5)
	wait(2.5)
	RunService:UnbindFromRenderStep("LoadingGui3D")
	v13.Parent = nil
end
local function OnGameInfoLoaded() -- line: 230
	-- upvalues: t1 (copy), v18 (copy), v21 (copy)
	local CreatorName = t1:GetCreatorName()

	if CreatorName and CreatorName ~= "" then
		CreatorName = string.format("By %s", (tostring(CreatorName)))
	end

	v18.Text = t1:GetGameName()
	v21.Text = CreatorName
end
local function OnDefaultLoadingGuiRemoved() -- line: 239
	-- upvalues: u22 (ref), FadeElements (copy), v13 (copy), RunService (copy)
	if u22 then
		return
	end

	u22 = true
	FadeElements(v13, 1, 2.5)
	wait(2.5)
	RunService:UnbindFromRenderStep("LoadingGui3D")
	v13.Parent = nil
end

local timestamp = tick()

RunService:BindToRenderStep("LoadingGui3D", Enum.RenderPriority.Last.Value, function() -- line: 245
	-- upvalues: timestamp (ref), UpdateLayout (copy), n1 (ref), v16 (copy)
	local timestamp2 = tick()
	local v45 = timestamp2 - timestamp

	UpdateLayout(v45)

	local v46 = v45 * 0.5 * 360

	n1 += v46
	v16.Rotation = n1
	timestamp = timestamp2
end)
UpdateLayout()
t1:LoadAssetsAsync()

if t1:IsReady() then
	local CreatorName = t1:GetCreatorName()

	if CreatorName and CreatorName ~= "" then
		CreatorName = string.format("By %s", (tostring(CreatorName)))
	end

	v18.Text = t1:GetGameName()
	v21.Text = CreatorName
end

t1.LoadingFinishedEvent:Connect(OnGameInfoLoaded)

if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
	if not u22 then
		u22 = true
		FadeElements(v13, 1, 2.5)
		wait(2.5)
		RunService:UnbindFromRenderStep("LoadingGui3D")
		v13.Parent = nil
	end
else
	ReplicatedFirst.RemoveDefaultLoadingGuiSignal:connect(OnDefaultLoadingGuiRemoved)
end

GuiService.ErrorMessageChanged:connect(function() -- line: 272
end)
GuiService.UiMessageChanged:connect(function(_, _) -- line: 276
end)
SplashScreenManager.addStatusChangeListener(function(p11) -- line: 280
	-- upvalues: u22 (ref), FadeElements (copy), v13 (copy), RunService (copy)
	if p11 then
		if u22 then
			return
		end

		u22 = true
		FadeElements(v13, 1, 2.5)
		wait(2.5)
		RunService:UnbindFromRenderStep("LoadingGui3D")
		v13.Parent = nil
	end
end)

return v13
