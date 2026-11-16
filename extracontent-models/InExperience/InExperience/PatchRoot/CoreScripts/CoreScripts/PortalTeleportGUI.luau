local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local teleportColorCorrectionEffect = nil
local count = 0

local RobloxGui = CoreGui.RobloxGui
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts

local teleportEffectGui = Instance.new("ScreenGui")
teleportEffectGui.Name = "TeleportEffectGui"
teleportEffectGui.IgnoreGuiInset = true
teleportEffectGui.Enabled = false
teleportEffectGui.DisplayOrder = 7
teleportEffectGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
teleportEffectGui.Parent = CoreGui

local topFrame = Instance.new("Frame")
topFrame.Name = "TopFrame"
topFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
topFrame.BorderSizePixel = 0
topFrame.AnchorPoint = Vector2.new(0.5, 1)
topFrame.Position = UDim2.new(0.5, 0, 0, 0)
topFrame.Size = UDim2.new(1, 0, 1, 0)
topFrame.ZIndex = 1
topFrame.Parent = teleportEffectGui
local clone = topFrame:Clone()
clone.AnchorPoint = Vector2.new(0.5, 0)
clone.Position = UDim2.new(0.5, 0, 1, 0)
clone.Parent = teleportEffectGui

local spinnerContainer = Instance.new("Frame")
spinnerContainer.Name = "SpinnerContainer"
spinnerContainer.ZIndex = 2
spinnerContainer.BackgroundTransparency = 1
spinnerContainer.AnchorPoint = Vector2.new(1, 1)
spinnerContainer.Size = UDim2.new(0.125, 0, 0.125, 0)
spinnerContainer.Position = UDim2.new(1, 0, 1, 0)
spinnerContainer.Parent = teleportEffectGui
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
uiAspectRatioConstraint.AspectRatio = 1
uiAspectRatioConstraint.Parent = spinnerContainer
local spinnerRobloxTilt = Instance.new("ImageLabel")
spinnerRobloxTilt.Name = "SpinnerRobloxTilt"
spinnerRobloxTilt.BackgroundTransparency = 1
spinnerRobloxTilt.ImageTransparency = 1
spinnerRobloxTilt.Image = "rbxasset://textures/loading/robloxTilt.png"
spinnerRobloxTilt.ZIndex = 2
spinnerRobloxTilt.AnchorPoint = Vector2.new(0.5, 0.5)
spinnerRobloxTilt.Size = UDim2.new(1, 0, 1, 0)
spinnerRobloxTilt.Position = UDim2.new(0, 0, 0, 0)
spinnerRobloxTilt.Parent = spinnerContainer
local uiAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
uiAspectRatioConstraint2.AspectRatio = 1
uiAspectRatioConstraint2.Parent = spinnerRobloxTilt

local textLabel = Instance.new("TextLabel")
textLabel.Text = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.Teleporting")
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextTransparency = 1
textLabel.BackgroundTransparency = 1
textLabel.ZIndex = 2
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.Size = UDim2.new(0.6, 0, 0, 48)
textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
textLabel.Font = AppFonts.default:getDefault()
textLabel.TextScaled = true
textLabel.Parent = teleportEffectGui

local v = false
function spinSpinner()
	if not v then
		v = true
		local lastTime = os.clock()
		RunService:BindToRenderStep("PortalLoadingSpinner", Enum.RenderPriority.Last.Value, function()
			if not (spinnerRobloxTilt and spinnerRobloxTilt.Parent) then
				stopSpinner()

				return
			end

			local v2 = (os.clock() - lastTime) / 4 % 1
			local v3, v4

			if v2 <= 0.75 then
				v3 = math.cos(3.141592653589793 * (v2 / 0.75)) * -0.5 + 0.5
				v4 = 2.25
			else
				v3 = math.cos(3.141592653589793 + 3.141592653589793 * ((v2 - 0.75) / 0.25)) * -0.5 + 0.5
				v4 = 0.25
			end

			local v5 = v3 * 0.25 + 1
			spinnerRobloxTilt.Size = UDim2.new(v5, 0, v5, 0)
			spinnerRobloxTilt.Rotation = v3 * 360 * v4
		end)
	end
end
function stopSpinner()
	RunService:UnbindFromRenderStep("PortalLoadingSpinner")
	v = false
end

function cover()
	count += 1
	local v2 = count

	if teleportColorCorrectionEffect then
		if teleportColorCorrectionEffect.Parent then
			teleportColorCorrectionEffect:Destroy()
		end

		teleportColorCorrectionEffect = nil
	end

	teleportColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
	teleportColorCorrectionEffect.Name = "TeleportColorCorrectionEffect"
	teleportColorCorrectionEffect.Parent = Lighting

	TweenService:Create(
		teleportColorCorrectionEffect,
		TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{ Brightness = 1 }
	):Play()

	task.delay(0.25, function()
		if v2 ~= count then
			return
		end

		if teleportEffectGui and teleportEffectGui.Parent then
			teleportEffectGui.Enabled = true
		end

		if topFrame and topFrame.Parent and clone and clone.Parent then
			TweenService:Create(topFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
			TweenService:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		end
	end)

	task.delay(1.25, function()
		if v2 ~= count then
			return
		end

		if spinnerRobloxTilt and spinnerRobloxTilt.Parent then
			TweenService:Create(
				spinnerRobloxTilt,
				TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{ ImageTransparency = 0 }
			):Play()
			spinSpinner()
		end

		if textLabel and textLabel.Parent then
			TweenService:Create(textLabel, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				TextTransparency = 0
			}):Play()
		end
	end)
end

function uncover()
	count += 1
	local v2 = count

	if spinnerRobloxTilt and spinnerRobloxTilt.Parent then
		TweenService:Create(
			spinnerRobloxTilt,
			TweenInfo.new(0.6000000000000001, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ ImageTransparency = 1 }
		):Play()
	end

	if textLabel and textLabel.Parent then
		TweenService:Create(
			textLabel,
			TweenInfo.new(0.6000000000000001, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ TextTransparency = 1 }
		):Play()
	end

	if teleportColorCorrectionEffect and teleportColorCorrectionEffect.Parent then
		TweenService:Create(
			teleportColorCorrectionEffect,
			TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ Brightness = 0 }
		):Play()
	end

	if topFrame and topFrame.Parent and clone and clone.Parent then
		TweenService:Create(topFrame, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = UDim2.new(0.5, 0, 0, 0)
		}):Play()
		TweenService:Create(clone, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Position = UDim2.new(0.5, 0, 1, 0)
		}):Play()
	end

	task.delay(3, function()
		if v2 ~= count then
			return
		end

		if teleportColorCorrectionEffect then
			if teleportColorCorrectionEffect.Parent then
				teleportColorCorrectionEffect:Destroy()
			end

			teleportColorCorrectionEffect = nil
		end

		if teleportEffectGui and teleportEffectGui.Parent then
			teleportEffectGui.Enabled = false
		end

		stopSpinner()
	end)
end

AdService.AdTeleportInitiated:Connect(cover)
AdService.AdTeleportEnded:Connect(uncover)
