local uDim2 = UDim2.new(1.1, 0, 1.1, 0)
local uDim2_2 = UDim2.new(0.9, 0, 0.9, 0)
local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine)
local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v10 = game:DefineFastFlag("LocalizeGameplayPaused", false)

local function build() -- line: 23
	-- upvalues: Create (copy), uDim2_2 (copy), AppFonts (copy), v10 (copy), RobloxTranslator (copy)
	return Create("ImageLabel")({
		Name = "NetworkPause",
		Image = "rbxasset://textures/ui/PurchasePrompt/LoadingBG.png",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 12, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ImageColor3 = Color3.fromRGB(122, 122, 122),
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		Create("UISizeConstraint")({
			MaxSize = Vector2.new(312, 251)
		}),
		Create("UIPadding")({
			PaddingTop = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		Create("Frame")({
			Name = "Accent",
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(66, 66, 66),
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 88)
		}),
		Create("Frame")({
			Name = "Upper",
			Size = UDim2.new(1, 0, 0, 88),
			BackgroundTransparency = 1,
			Create("Frame")({
				Name = "IconContainer",
				Size = UDim2.new(0, 40, 0, 37),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				BackgroundTransparency = 1,
				Create("ImageLabel")({
					Name = "Icon",
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/NetworkPause/no connection.png",
					ImageTransparency = 0,
					Size = uDim2_2,
					Position = UDim2.new(0.5, 0, 0.88, 0),
					AnchorPoint = Vector2.new(0.5, 0.88)
				})
			}),
			Create("TextLabel")({
				Name = "Label",
				TextSize = 22,
				TextWrapped = true,
				BackgroundTransparency = 1,
				TextTransparency = 0,
				Font = AppFonts.default:getBold(),
				Text = v10 and RobloxTranslator:FormatByKey("InGame.GameplayPaused.Title") or "Gameplay Paused",
				Size = UDim2.new(1, 0, 0, 22),
				Position = UDim2.new(0, 0, 0, 54),
				TextColor3 = Color3.fromRGB(255, 255, 255)
			})
		}),
		Create("TextLabel")({
			Name = "Lower",
			TextSize = 18,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextTransparency = 0,
			Font = AppFonts.default:getDefault(),
			Text = v10 and RobloxTranslator:FormatByKey("InGame.GameplayPaused.Body") or "Gameplay has been paused: please wait while the game content loads.",
			TextColor3 = Color3.fromRGB(190, 190, 190),
			Position = UDim2.new(0, 0, 0, 89),
			Size = UDim2.new(1, 0, 1, -89)
		})
	})
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 122
	-- upvalues: t1 (copy), build (copy), TweenService (copy), tweenInfo (copy), tweenInfo2 (copy), uDim2 (copy)
	local self = setmetatable({}, t1)
	local v14 = build()
	local tween = TweenService:Create(v14, tweenInfo, {
		ImageTransparency = 0
	})
	local tween2 = TweenService:Create(v14, tweenInfo, {
		ImageTransparency = 1
	})
	local tween3 = TweenService:Create(v14.Upper.IconContainer.Icon, tweenInfo2, {
		ImageTransparency = 0.75,
		Size = uDim2
	})

	self.__gui = v14
	self.__guiParent = nil
	self.__show = false
	self.__animations = {
		show = tween,
		hide = tween2,
		pulse = tween3
	}

	return self
end
function t1.Show(p1) -- line: 146
	-- upvalues: uDim2_2 (copy)
	p1.__gui.Upper.IconContainer.Icon.Size = uDim2_2
	p1.__gui.Upper.IconContainer.Icon.ImageTransparency = 0
	p1.__show = true
	p1.__gui.Parent = p1.__guiParent
	p1.__animations.pulse:Play()
end
function t1.Hide(p2) -- line: 154
	p2.__show = false
	p2.__gui.Parent = nil
	p2.__animations.pulse:Cancel()
end
function t1.SetParent(p3, p4) -- line: 160
	p3.__guiParent = p4

	if p3.__show then
		p3.__gui.Parent = p4
	end
end

return t1
