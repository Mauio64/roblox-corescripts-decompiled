local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local u7 = nil
local n1 = 0
local _ = CoreGui.RobloxGui
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TeleportEffectGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false
ScreenGui.DisplayOrder = 7
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")

Frame.Name = "TopFrame"
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 0, 0)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.ZIndex = 1
Frame.Parent = ScreenGui

local clone = Frame:Clone()

clone.AnchorPoint = Vector2.new(0.5, 0)
clone.Position = UDim2.new(0.5, 0, 1, 0)
clone.Parent = ScreenGui

local Frame2 = Instance.new("Frame")

Frame2.Name = "SpinnerContainer"
Frame2.ZIndex = 2
Frame2.BackgroundTransparency = 1
Frame2.AnchorPoint = Vector2.new(1, 1)
Frame2.Size = UDim2.new(0.125, 0, 0.125, 0)
Frame2.Position = UDim2.new(1, 0, 1, 0)
Frame2.Parent = ScreenGui

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

UIAspectRatioConstraint.AspectRatio = 1
UIAspectRatioConstraint.Parent = Frame2

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "SpinnerRobloxTilt"
ImageLabel.BackgroundTransparency = 1
ImageLabel.ImageTransparency = 1
ImageLabel.Image = "rbxasset://textures/loading/robloxTilt.png"
ImageLabel.ZIndex = 2
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Size = UDim2.new(1, 0, 1, 0)
ImageLabel.Position = UDim2.new(0, 0, 0, 0)
ImageLabel.Parent = Frame2

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

UIAspectRatioConstraint2.AspectRatio = 1
UIAspectRatioConstraint2.Parent = ImageLabel

local TextLabel = Instance.new("TextLabel")

TextLabel.Text = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.Teleporting")
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextTransparency = 1
TextLabel.BackgroundTransparency = 1
TextLabel.ZIndex = 2
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(0.6, 0, 0, 48)
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Font = AppFonts.default:getDefault()
TextLabel.TextScaled = true
TextLabel.Parent = ScreenGui

local u20 = false

function spinSpinner() -- line: 93
	-- upvalues: u20 (ref), RunService (copy), ImageLabel (copy)
	if not u20 then
		u20 = true

		local elapsed = os.clock()

		RunService:BindToRenderStep("PortalLoadingSpinner", Enum.RenderPriority.Last.Value, function() -- line: 97
			-- upvalues: ImageLabel (copy), elapsed (copy)
			if ImageLabel and ImageLabel.Parent then
				local v24 = (os.clock() - elapsed) / 4 % 1
				local v25, n2

				if v24 <= 0.75 then
					v25 = math.cos(3.141592653589793 * (v24 / 0.75)) * -0.5 + 0.5
					n2 = 2.25
				else
					v25 = math.cos(3.141592653589793 + 3.141592653589793 * ((v24 - 0.75) / 0.25)) * -0.5 + 0.5
					n2 = 0.25
				end

				local v27 = v25 * 0.25 + 1

				ImageLabel.Size = UDim2.new(v27, 0, v27, 0)
				ImageLabel.Rotation = v25 * 360 * n2

				return
			end

			stopSpinner()
		end)
	end
end
function stopSpinner() -- line: 119
	-- upvalues: RunService (copy), u20 (ref)
	RunService:UnbindFromRenderStep("PortalLoadingSpinner")
	u20 = false
end
function cover() -- line: 124
	-- upvalues: n1 (ref), u7 (ref), Lighting (copy), TweenService (copy), ScreenGui (copy), Frame (copy), clone (copy), ImageLabel (copy), TextLabel (copy)
	n1 += 1

	local v22 = n1

	if u7 then
		if u7.Parent then
			u7:Destroy()
		end

		u7 = nil
	end

	u7 = Instance.new("ColorCorrectionEffect")
	u7.Name = "TeleportColorCorrectionEffect"
	u7.Parent = Lighting
	TweenService:Create(u7, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		Brightness = 1
	}):Play()
	task.delay(0.25, function() -- line: 144
		-- upvalues: v22 (copy), n1 (ref), ScreenGui (copy), Frame (copy), clone (copy), TweenService (copy)
		if v22 ~= n1 then
			return
		end

		if ScreenGui and ScreenGui.Parent then
			ScreenGui.Enabled = true
		end

		if Frame and Frame.Parent and clone and clone.Parent then
			TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
			TweenService:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		end
	end)
	task.delay(1.25, function() -- line: 165
		-- upvalues: v22 (copy), n1 (ref), ImageLabel (copy), TweenService (copy), TextLabel (copy)
		if v22 ~= n1 then
			return
		end

		if ImageLabel and ImageLabel.Parent then
			TweenService:Create(ImageLabel, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				ImageTransparency = 0
			}):Play()
			spinSpinner()
		end

		if TextLabel and TextLabel.Parent then
			TweenService:Create(TextLabel, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				TextTransparency = 0
			}):Play()
		end
	end)
end
function uncover() -- line: 187
	-- upvalues: n1 (ref), ImageLabel (copy), TweenService (copy), TextLabel (copy), u7 (ref), Frame (copy), clone (copy), ScreenGui (copy)
	n1 += 1

	local v23 = n1

	if ImageLabel and ImageLabel.Parent then
		TweenService:Create(ImageLabel, TweenInfo.new(0.6000000000000001, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			ImageTransparency = 1
		}):Play()
	end

	if TextLabel and TextLabel.Parent then
		TweenService:Create(TextLabel, TweenInfo.new(0.6000000000000001, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			TextTransparency = 1
		}):Play()
	end

	if u7 and u7.Parent then
		TweenService:Create(u7, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Brightness = 0
		}):Play()
	end

	if Frame and Frame.Parent and clone and clone.Parent then
		TweenService:Create(Frame, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = UDim2.new(0.5, 0, 0, 0)
		}):Play()
		TweenService:Create(clone, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = UDim2.new(0.5, 0, 1, 0)
		}):Play()
	end

	task.delay(3, function() -- line: 226
		-- upvalues: v23 (copy), n1 (ref), u7 (ref), ScreenGui (copy)
		if v23 ~= n1 then
			return
		end

		if u7 then
			if u7.Parent then
				u7:Destroy()
			end

			u7 = nil
		end

		if ScreenGui and ScreenGui.Parent then
			ScreenGui.Enabled = false
		end

		stopSpinner()
	end)
end

AdService.AdTeleportInitiated:Connect(cover)
AdService.AdTeleportEnded:Connect(uncover)
