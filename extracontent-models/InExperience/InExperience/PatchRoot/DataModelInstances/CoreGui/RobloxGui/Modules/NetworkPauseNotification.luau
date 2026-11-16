local udim = UDim2.new(1.1, 0, 1.1, 0)

local udim2 = UDim2.new(0.9, 0, 0.9, 0)

local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine)
local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local defineFastFlag = game:DefineFastFlag("LocalizeGameplayPaused", false)

local function build()
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
		Create("UISizeConstraint")({ MaxSize = Vector2.new(312, 251) }),
		Create("UIPadding")({
			PaddingTop = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		Create("Frame")({
			Name = "Accent",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(66, 66, 66),
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 88),
			BackgroundTransparency = 0
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
					Size = udim2,
					Position = UDim2.new(0.5, 0, 0.88, 0),
					AnchorPoint = Vector2.new(0.5, 0.88),
					ImageTransparency = 0
				})
			}),
			Create("TextLabel")({
				Name = "Label",
				Font = AppFonts.default:getBold(),
				Text = defineFastFlag and RobloxTranslator:FormatByKey("InGame.GameplayPaused.Title") or "Gameplay Paused",
				TextSize = 22,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 22),
				Position = UDim2.new(0, 0, 0, 54),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0
			})
		}),
		Create("TextLabel")({
			Name = "Lower",
			Font = AppFonts.default:getDefault(),
			Text = defineFastFlag and RobloxTranslator:FormatByKey("InGame.GameplayPaused.Body") or "Gameplay has been paused: please wait while the game content loads.",
			TextColor3 = Color3.fromRGB(190, 190, 190),
			TextSize = 18,
			TextWrapped = true,
			Position = UDim2.new(0, 0, 0, 89),
			Size = UDim2.new(1, 0, 1, -89),
			BackgroundTransparency = 1,
			TextTransparency = 0
		})
	})
end

local NetworkPauseNotification = {}
NetworkPauseNotification.__index = NetworkPauseNotification

function NetworkPauseNotification.new()
	local self = setmetatable({}, NetworkPauseNotification)
	local gui = build()

	local tween = TweenService:Create(gui, tweenInfo, { ImageTransparency = 0 })
	local tween2 = TweenService:Create(gui, tweenInfo, { ImageTransparency = 1 })

	local tween3 = TweenService:Create(gui.Upper.IconContainer.Icon, tweenInfo2, {
		Size = udim,
		ImageTransparency = 0.75
	})

	self.__gui = gui
	self.__guiParent = nil
	self.__show = false
	self.__animations = { show = tween, hide = tween2, pulse = tween3 }

	return self
end

function NetworkPauseNotification:Show()
	self.__gui.Upper.IconContainer.Icon.Size = udim2
	self.__gui.Upper.IconContainer.Icon.ImageTransparency = 0
	self.__show = true
	self.__gui.Parent = self.__guiParent
	self.__animations.pulse:Play()
end

function NetworkPauseNotification:Hide()
	self.__show = false
	self.__gui.Parent = nil
	self.__animations.pulse:Cancel()
end

function NetworkPauseNotification:SetParent(p)
	self.__guiParent = p

	if self.__show then
		self.__gui.Parent = p
	end
end

return NetworkPauseNotification
