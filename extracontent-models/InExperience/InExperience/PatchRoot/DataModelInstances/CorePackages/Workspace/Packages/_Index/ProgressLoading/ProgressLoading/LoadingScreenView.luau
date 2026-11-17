local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local Roact = require(parent.Roact)
local RoactUtils = require(parent.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local MockableProxyServices = require(parent.MockableProxyServices)

local VerifiedBadges = require(parent.VerifiedBadges)
local UIBlox = require(parent.UIBlox)

local withStyle = UIBlox.Style.withStyle
local Responsive = require(parent.Responsive)

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local FoundationProvider = Foundation.FoundationProvider
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local AutoTranslateBadge = require(ProgressLoading.Components.AutoTranslateBadge)
local LoadingScreenTelemetry = require(ProgressLoading.LoadingScreenTelemetry)
local PolicyContainer = require(ProgressLoading.Components.PolicyContainer)
local ServerStatus = require(ProgressLoading.Components.ServerStatus)
local ServerStatusWithCountdown = require(ProgressLoading.Components.ServerStatusWithCountdown)

local localization = Localization.new(LocalizationService.RobloxLocaleId)

local SocialExperiments = require(parent.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation

local SharedFlags = require(parent.SharedFlags)
local FFlagIncreaseLoadingScreenOrder = SharedFlags.FFlagIncreaseLoadingScreenOrder
local FFlagLoadingScreenControlMilestones = SharedFlags.FFlagLoadingScreenControlMilestones
local Constants = require(ProgressLoading.LoadingScreenMilestones.Constants)
local v = FFlagIncreaseLoadingScreenOrder and 8 or 7
local vector2 = Vector2.new(768, 432)

local color = Color3.fromRGB(101, 102, 104)

local v2 = {
	MOBILE_PORTRAIT = { TOP = 44, BOTTOM = 44, LEFT = 24, RIGHT = 24 },
	MOBILE_LANDSCAPE = { TOP = 24, BOTTOM = 24, LEFT = 44, RIGHT = 44 },
	DESKTOP = { TOP = 24, BOTTOM = 24, LEFT = 24, RIGHT = 24 },
	CONSOLE = { TOP = 64, BOTTOM = 64, LEFT = 64, RIGHT = 64 }
}

local AppCommonLib = require(parent.AppCommonLib)
local tenFootInterface = AppCommonLib.isTenFootInterface()
local platform = UserInputService:GetPlatform()
local v3 = platform == Enum.Platform.IOS or platform == Enum.Platform.Android

local v4 = { 150, 256 }

local inputBeganConnection = nil
local v5 = 0
local lastTime = 1e999

local function getPadding(isPortrait) -- 1 equivalent call inferred from this helper
	if v3 then
		return isPortrait and v2.MOBILE_PORTRAIT or v2.MOBILE_LANDSCAPE
	end

	return if tenFootInterface then v2.CONSOLE else v2.DESKTOP
end

local function lerp(list, value) -- 19 equivalent calls inferred from this helper
	if type(list) ~= "table" or not (#list >= 2) then
		return 0
	end

	local v6 = math.clamp(value, 0, 1)
	return list[1] * (1 - v6) + list[2] * v6
end

local v6 = {
	FadeIn = function(p, _, data, callback)
		local v6 = { 1, 1 }
		local v7 = { 1, 0 }
		local v8 = { 1, 0.2 }

		if p <= 0.6 then
			local v9 = p / 0.6
			data.iconTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.iconSize(lerp(v6, v9)) -- inferred equivalent call
			data.infoFrameTransparency(lerp(v8, v9)) -- inferred equivalent call
			data.thumbnailTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.placeTextTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.placeTextSize(lerp(v6, v9)) -- inferred equivalent call
			data.creatorTextTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.creatorTextSize(lerp(v6, v9)) -- inferred equivalent call
		else
			data.iconTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.iconSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.infoFrameTransparency((type(v8) ~= "table" or not (#v8 >= 2)) and 0 or v8[1] * 0 + v8[2] * 1)
			data.thumbnailTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.placeTextTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.placeTextSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.creatorTextTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.creatorTextSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			callback()
		end
	end,
	FadeOut = function(p, _, data, callback)
		local v6 = { 1, 0.6 }
		local v7 = { 0, 1 }
		local v8 = { 0.2, 1 }

		if p <= 0.6 then
			local v9 = p / 0.6
			data.iconTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.iconSize(lerp(v6, v9)) -- inferred equivalent call
			data.infoFrameTransparency(lerp(v8, v9)) -- inferred equivalent call
			data.thumbnailTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.placeTextTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.placeTextSize(lerp(v6, v9)) -- inferred equivalent call
			data.creatorTextTransparency(lerp(v7, v9)) -- inferred equivalent call
			data.creatorTextSize(lerp(v6, v9)) -- inferred equivalent call
		else
			RunService:SetRobloxGuiFocused(false)
			data.iconTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.iconSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.infoFrameTransparency((type(v8) ~= "table" or not (#v8 >= 2)) and 0 or v8[1] * 0 + v8[2] * 1)
			data.thumbnailTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.placeTextTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.placeTextSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.creatorTextTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.creatorTextSize((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			callback()
		end
	end
}

local function disconnectAndCloseHealthStat()
	if inputBeganConnection then
		inputBeganConnection:disconnect()
		inputBeganConnection = nil
		GuiService:CloseStatsBasedOnInputString("ConnectionHealth")
	end
end

local extended = Roact.Component:extend("LoadingScreenView")

function extended:playAnimation(animationFunction, p, callback)
	self.animationStartTime = tick()
	self.animationFunction = animationFunction

	if not self.renderSteppedConnection then
		self.renderSteppedConnection = MockableProxyServices.RunService.RenderStepped:Connect(function()
			self.animationFunction(tick() - self.animationStartTime, p, self.updateBindings, function()
				self:stopAnimation()

				if callback then
					callback()
				end
			end)
		end)
	end
end

function extended:stopAnimation()
	if self.renderSteppedConnection then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
	end
end

function extended:renderBackground(p)
	local thumbnailScaledWidth = self.state.thumbnailScaledWidth
	local thumbnailScaledHeight = self.state.thumbnailScaledHeight
	local thumbnailPositionX = self.state.thumbnailPositionX

	local image = not (self.props.placeId and self.props.placeId > 0) and ""
		or ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(self.props.placeId)

	local reducedMotion = p.Settings.ReducedMotion
	return Roact.createElement("ScreenGui", {
		DisplayOrder = self.props.displayOrder or v,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, { Roact.createElement("Frame", {
			Name = "BackgroundFrame",
			[Roact.Change.AbsoluteSize] = self.onAbsoluteSizeChange,
			BackgroundColor3 = p.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Active = true
		}, {
			ThumbnailImage = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = image,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(thumbnailPositionX, 0.5),
				Size = UDim2.fromOffset(thumbnailScaledWidth, thumbnailScaledHeight),
				ImageTransparency = self.bindings.thumbnailTransparency
			}),
			renderStepped = not reducedMotion and Roact.createElement(ExternalEventConnection, {
				event = RunService.renderStepped,
				callback = self.renderBackgroundSteppedCallback
			})
		}) })
end

function extended.showConnnectionHealthDebugMenu(_, _)
	if v5 == 0 then
		v5 = 1
		lastTime = tick()
	else
		if v3 and tick() - lastTime <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v5 = 0
		lastTime = 1e999
	end
end

function extended:renderPlaceIcon(p)
	local shimPos = self.state.shimPos
	local value = self.bindings.iconTransparency:getValue()

	local image = not (self.props.universeId and self.props.universeId > 0) and ""
		or ("rbxthumb://type=GameIcon&id=%d&w=256&h=256"):format(self.props.universeId)

	local reducedMotion = p.Settings.ReducedMotion
	local createElement = Roact.createElement
	local v7 = {
		Name = "IconFrame",
		BackgroundTransparency = self.bindings.iconTransparency,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Size = self.bindings.iconSize,
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true
	}

	local loadingOverlay = not reducedMotion

	if loadingOverlay then
		local createElement2 = Roact.createElement
		local v8 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			ZIndex = 2
		}

		local children = {
			Corner = Roact.createElement("UICorner"),
			Gradient = 0,
			renderStepped = 0
		}
		local createElement3 = Roact.createElement
		local v9 = {
			Rotation = 25,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
			}),
			Transparency = 0,
			Offset = 0
		}

		local numberSequenceKeypoint = NumberSequenceKeypoint.new(0, lerp({ 0.7, 1 }, value)) -- inferred equivalent call
		local numberSequenceKeypoint2 = NumberSequenceKeypoint.new(0.5, lerp({ 0.3, 1 }, value)) -- inferred equivalent call
		local v10 = lerp({ 0.7, 1 }, value) -- inferred equivalent call
		v9.Transparency = NumberSequence.new({
			numberSequenceKeypoint,
			numberSequenceKeypoint2,
			NumberSequenceKeypoint.new(1, v10)
		})

		v9.Offset = Vector2.new(shimPos, 0)
		children.Gradient = createElement3("UIGradient", v9)

		children.renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = self.renderShimmerCallback
		})
		loadingOverlay = createElement2("Frame", v8, children)
	end

	return createElement("Frame", v7, {
		LoadingOverlay = loadingOverlay,
		GameIconImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = image,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			ImageTransparency = self.bindings.iconTransparency
		}, {
			Corner = Roact.createElement("UICorner")
		}),
		Corner = Roact.createElement("UICorner")
	})
end

function extended:renderInfoFrame(p)
	local productInfo = self.props.productInfo
	local name = productInfo and productInfo.Name or ""
	local name2 = productInfo and productInfo.Creator.Name or ""

	if productInfo and productInfo.Creator.HasVerifiedBadge then
		name2 = VerifiedBadges.appendVerifiedBadge(name2)
	end

	local v7 = math.clamp(math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v4[1], v4[1], v4[2])
	return Roact.createElement("Frame", {
		Name = "InfoFrame",
		BackgroundColor3 = p.Theme.BackgroundMuted.Color,
		BackgroundTransparency = self.bindings.infoFrameTransparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = self.isPortrait and UDim2.fromScale(1, 0) or UDim2.fromScale(0.6, 0),
		Active = true,
		[Roact.Change.AbsoluteSize] = function(p2)
			self.updateBindings.updateInfoFrameAbsoluteSize(p2.AbsoluteSize)
		end
	}, {
		PlaceIcon = self:renderPlaceIcon(p),
		TextLayoutFrame = Roact.createElement("Frame", {
			Name = "TextLayout",
			BackgroundColor3 = p.Theme.BackgroundMuted.Color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 0, v7 / 2),
			Size = UDim2.fromScale(1, 0),
			Active = true
		}, {
			PlaceLabel = Roact.createElement("TextLabel", {
				Name = "PlaceLabel",
				BackgroundTransparency = 1,
				TextTransparency = self.bindings.placeTextTransparency,
				Size = UDim2.fromScale(0.8, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				FontFace = normalizeFontFace(p.Tokens.Typography.HeadingLarge.Font),
				TextSize = self.bindings.placeTextSize,
				TextScaled = false,
				TextWrapped = true,
				TextColor3 = p.Theme.TextEmphasis.Color,
				TextStrokeTransparency = 1,
				Text = name,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 2,
				LayoutOrder = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				RichText = false
			}),
			CreatorLabel = Roact.createElement("TextLabel", {
				Name = "CreatorLabel",
				BackgroundTransparency = 1,
				TextTransparency = self.bindings.creatorTextTransparency,
				Size = UDim2.fromScale(0.6, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				AutomaticSize = Enum.AutomaticSize.Y,
				FontFace = normalizeFontFace(p.Tokens.Typography.BodySmall.Font),
				TextSize = self.bindings.creatorTextSize,
				TextWrapped = true,
				TextScaled = false,
				TextColor3 = p.Theme.TextDefault.Color,
				TextStrokeTransparency = 1,
				Text = name2,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 2,
				LayoutOrder = 2,
				TextTruncate = Enum.TextTruncate.AtEnd,
				RichText = false
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v3 and 12 or 36)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v3 and 12 or 36),
				PaddingBottom = UDim.new(0, v3 and 12 or 36)
			})
		}),
		Corner = Roact.createElement("UICorner")
	})
end

function extended:renderMain(p)
	local padding = getPadding(self.isPortrait) -- inferred equivalent call

	local reducedMotion = p.Settings.ReducedMotion
	local createElement = Roact.createElement
	local v7 = {
		DisplayOrder = (self.props.displayOrder or v) + 1,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		OnTopOfCoreBlur = true
	}

	local createElement2 = Roact.createElement
	local v8 = {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}
	local v9 = {
		Gradient = Roact.createElement("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 1),
				NumberSequenceKeypoint.new(1, 0.5)
			})
		}),
		Spinner = reducedMotion and Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				ZIndex = 20
			},
			{ Roact.createElement(Loading, {
					size = IconSize.Medium,
					Position = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(1, 1)
				}) }
		),
		infoFrame = self:renderInfoFrame(p),
		AutoTranslate = self:renderAutoTranslate(),
		serverFrame = 0,
		policyContainer = 0,
		serverStatusContainer = 0,
		closeBtn = 0,
		gamepadCancelBtn = 0,
		Padding = 0
	}
	local serverFrame

	if not self.isQueueTreatmentEnabled then
		serverFrame = self:renderServerFrame(p)
	end

	v9.serverFrame = serverFrame
	local policyContainer

	if self.isQueueTreatmentEnabled then
		policyContainer = self:renderPolicyContainer()
	end

	v9.policyContainer = policyContainer
	local serverStatusContainer

	if self.isQueueTreatmentEnabled then
		serverStatusContainer = self:renderServerStatus()
	end

	v9.serverStatusContainer = serverStatusContainer
	v9.closeBtn = self:renderCloseBtn(p)
	v9.gamepadCancelBtn = self:renderGamepadCancelBtn(p)
	v9.Padding = Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, padding.LEFT),
		PaddingRight = UDim.new(0, padding.RIGHT),
		PaddingTop = UDim.new(0, padding.TOP),
		PaddingBottom = UDim.new(0, padding.BOTTOM)
	})
	return createElement("ScreenGui", v7, {
		DarkGradient = createElement2("Frame", v8, v9)
	})
end

function extended:renderCloseBtn(_)
	if
		self.props.preferredInputRef.current ~= Responsive.Input.Directional
		and not self.state.showCloseBtn
		and tick() - self.startTime > 5
	then
		self:setState({ showCloseBtn = true })
	end

	local closeBtn = self.state.showCloseBtn

	if not closeBtn then
		return closeBtn
	end

	local createElement = Roact.createElement
	local v7 = {
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		Name = "CloseButton",
		Image = "rbxasset://textures/loading/cancelButton.png",
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0)
	}

	local _isQueueTreatmentEnabled = self.isQueueTreatmentEnabled
	local _isQueueTreatmentEnabled2 = self.isQueueTreatmentEnabled
	v7.Size = UDim2.fromOffset(32, 32)

	v7.Active = false
	v7.ZIndex = 10
	v7[Roact.Event.MouseButton1Click] = function()
		if self.props.onCloseButtonActivated then
			self.props.onCloseButtonActivated()
		end
	end

	closeBtn = createElement("ImageButton", v7)
	return closeBtn
end

function extended:renderServerFrame(p)
	local serverStatusText = self.state.serverStatusText
	local isSubjectToChinaPolicies = self.props.isSubjectToChinaPolicies
	local textSize = tenFootInterface and 16 or 12
	local textSize2 = tenFootInterface and 16 or 12
	local createElement = Roact.createElement
	local v7 = {
		Name = "ServerFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(1, -48, 0.2, 0),
		Active = true
	}

	local v8 = {
		PolicyLabel = isSubjectToChinaPolicies and Roact.createElement("TextLabel", {
			Name = "PolicyLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 2 * textSize2),
			Position = UDim2.new(0, 0, 1, -4 * textSize - 2 * textSize2),
			FontFace = normalizeFontFace(p.Tokens.Typography.CaptionSmall.Font),
			TextSize = textSize2,
			TextWrapped = true,
			TextScaled = false,
			TextColor3 = p.Theme.TextDefault.Color,
			TextStrokeTransparency = 1,
			Text = localization:Format("Authentication.Login.WeChat.AntiAddictionText"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 2
		}),
		JoinServerLabel = 0
	}

	local createElement2 = Roact.createElement
	local v9 = {
		Name = "JoinText",
		BackgroundTransparency = 1,
		["Size"] = UDim2.new(1, 0, 0, 4 * textSize),
		Position = UDim2.new(0, 0, 1, -2 * textSize),
		FontFace = normalizeFontFace(p.Tokens.Typography.CaptionSmall.Font),
		TextSize = textSize,
		TextWrapped = true,
		TextScaled = false,
		TextColor3 = p.Theme.TextDefault.Color,
		TextStrokeTransparency = 1,
		Text = serverStatusText,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 2,
		RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
	}
	local inputBegan = Roact.Event.InputBegan
	local v10

	if not self.props.isSubjectToChinaPolicies then
		v10 = self.showConnnectionHealthDebugMenu or nil
	end

	v9[inputBegan] = v10
	v8.JoinServerLabel = createElement2("TextLabel", v9)
	return createElement("Frame", v7, v8)
end

function extended:renderGamepadCancelBtn(p)
	local gamepadCancelBtn

	if self.props.preferredInputRef.current == Responsive.Input.Directional then
		gamepadCancelBtn = not self.state.gamepadCancelPressed and Roact.createElement("Frame", {
			Name = "GamepadCancelFrame",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromOffset(150, 48),
			Active = true
		}, {
			CancelIcon = Roact.createElement("ImageLabel", {
				Name = "GamepadCancel",
				Image = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(24, 24),
				Active = false,
				ZIndex = 10,
				LayoutOrder = 0
			}),
			CancelLabel = Roact.createElement("TextLabel", {
				Name = "CancelText",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				FontFace = normalizeFontFace(p.Tokens.Typography.TitleLarge.Font),
				TextSize = 24,
				TextWrapped = true,
				TextColor3 = p.Theme.TextEmphasis.Color,
				TextStrokeTransparency = 1,
				Text = localization:Format("CoreScripts.TopBar.Back"),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 2,
				LayoutOrder = 1
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 5)
			})
		})
	else
		gamepadCancelBtn = false
	end

	return gamepadCancelBtn
end

function extended:init()
	self.thumbnailMoveSpd = 0.05
	self.fadeinComplete = false
	self.isPortrait = false
	self.startTime = tick()
	self.fadeOutTriggered = false

	self.numberOfTaps = 0
	self.lastTapTime = 1e999

	self:setState({
		visible = true,
		absoluteSize = Vector2.new(0, 0),
		thumbnailPositionX = 0.5,
		thumbnailScaledWidth = vector2.x,
		thumbnailScaledHeight = vector2.y,
		shimPos = 0,
		serverStatusText = "",
		showCloseBtn = false,
		showTenFootCancelBtn = tenFootInterface,
		gamepadCancelPressed = false
	})

	self.isQueueTreatmentEnabled = (QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled())
		and self.props.placeId > 0

	function self.onAbsoluteSizeChange(p)
		self:setState({ absoluteSize = p.AbsoluteSize })

		self.isPortrait = p.AbsoluteSize.X < p.AbsoluteSize.Y
		self.updateBindings.iconSize(1)
	end

	local binding, thumbnailTransparency = Roact.createBinding(1)
	local binding2, iconTransparency = Roact.createBinding(1)
	local binding3, iconSize = Roact.createBinding(0)
	local binding4, placeTextTransparency = Roact.createBinding(1)
	local binding5, placeTextSize = Roact.createBinding(0)
	local binding6, creatorTextTransparency = Roact.createBinding(1)
	local binding7, creatorTextSize = Roact.createBinding(0)
	local binding8, infoFrameTransparency = Roact.createBinding(1)
	local binding9, updateInfoFrameAbsoluteSize = Roact.createBinding(Vector2.new(0, 0))

	self.bindings = {
		thumbnailTransparency = binding,
		iconTransparency = binding2,
		iconSize = binding3:map(function(p)
			local v7 = math.clamp(
				math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v4[1],
				v4[1],
				v4[2]
			)
			return UDim2.fromOffset(v7 * p, v7 * p)
		end),
		placeTextTransparency = binding4,
		placeTextSize = binding5:map(function(p)
			return (v3 and 20 or 36) * p
		end),
		creatorTextTransparency = binding6,
		creatorTextSize = binding7:map(function(p)
			return 20 * p
		end),
		infoFrameTransparency = binding8,
		infoFrameAbsoluteSize = binding9
	}

	self.updateBindings = {
		thumbnailTransparency = thumbnailTransparency,
		iconTransparency = iconTransparency,
		iconSize = iconSize,
		placeTextTransparency = placeTextTransparency,
		placeTextSize = placeTextSize,
		creatorTextTransparency = creatorTextTransparency,
		creatorTextSize = creatorTextSize,
		infoFrameTransparency = infoFrameTransparency,
		updateInfoFrameAbsoluteSize = updateInfoFrameAbsoluteSize
	}

	function self.renderBackgroundSteppedCallback(p)
		local absoluteSize = self.state.absoluteSize
		local thumbnailScaledWidth = absoluteSize.x * 1.5
		local thumbnailScaledHeight = thumbnailScaledWidth / vector2.x * vector2.y

		if thumbnailScaledHeight < absoluteSize.y then
			thumbnailScaledWidth = absoluteSize.y / vector2.y * vector2.x
			thumbnailScaledHeight = absoluteSize.y
		end

		local v7 = thumbnailScaledWidth / absoluteSize.x / 2

		local v8 = math.max(v7, 1 - v7)

		local v9 = math.min(v7, 1 - v7)
		local thumbnailPositionX = self.state.thumbnailPositionX + self.thumbnailMoveSpd * p

		if v8 <= thumbnailPositionX or thumbnailPositionX <= v9 then
			self.thumbnailMoveSpd = -self.thumbnailMoveSpd
			thumbnailPositionX = math.clamp(thumbnailPositionX, v9, v8)
		end

		self:setState({
			thumbnailPositionX = thumbnailPositionX,
			thumbnailScaledHeight = thumbnailScaledHeight,
			thumbnailScaledWidth = thumbnailScaledWidth
		})
	end

	function self.renderShimmerCallback(p)
		local v7 = self.state.shimPos + p * 1

		self:setState({
			shimPos = v7 > 1 and -1 or v7
		})
	end

	if GuiService:GetUiMessage() ~= "" then
		self:setState({ serverStatusText = GuiService:GetUiMessage() })
	end

	GuiService.UiMessageChanged:Connect(function(p, serverStatusText)
		if p == Enum.UiMessageType.UiMessageInfo then
			self:setState({ serverStatusText = serverStatusText })
		end
	end)
	local v7 = false
	ContextActionService:BindCoreAction("CancelGameLoad", function(_, p, _)
		if p == Enum.UserInputState.Begin then
			v7 = true
		elseif p == Enum.UserInputState.End and v7 then
			self:setState({ showTenFootCancelBtn = false })

			self:setState({ gamepadCancelPressed = true })

			ContextActionService:UnbindCoreAction("CancelGameLoad")

			if self.props.onGamepadCancel then
				self.props.onGamepadCancel()
			end
		end
	end, false, Enum.KeyCode.ButtonB)
end

function extended:renderAutoTranslate()
	if self.props.universeId <= 0 then
		LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
		return nil
	end

	return Roact.createElement(AutoTranslateBadge, {
		universeId = self.props.universeId,
		positionBinding = self.bindings.infoFrameAbsoluteSize,
		transparencyBinding = self.bindings.infoFrameTransparency
	})
end

function extended:renderPolicyContainer()
	if self.props.isSubjectToChinaPolicies then
		return React.createElement(PolicyContainer, { position = UDim2.new(0, 0, 0, 32) })
	end

	return nil
end

function extended:renderServerStatus()
	if QueueExperimentation.getIsAutoJoinNewServerEnabled() then
		return Roact.createElement(ServerStatusWithCountdown, {
			anchorPoint = Vector2.new(0.5, 1),
			isSubjectToChinaPolicies = self.props.isSubjectToChinaPolicies,
			placeId = self.props.placeId,
			position = UDim2.fromScale(0.5, 1),
			size = UDim2.fromScale(1, 0.2),
			universeId = self.props.universeId
		})
	end

	if QueueExperimentation.getIsJoinNewServerButtonEnabled() then
		return Roact.createElement(ServerStatus, {
			anchorPoint = Vector2.new(0.5, 1),
			isSubjectToChinaPolicies = self.props.isSubjectToChinaPolicies,
			placeId = self.props.placeId,
			position = UDim2.fromScale(0.5, 1),
			size = UDim2.fromScale(1, 0.2),
			universeId = self.props.universeId
		})
	end

	return nil
end

function extended:renderMainWithProviders(p)
	return Roact.createElement(FoundationProvider, { theme = Foundation.Enums.Theme.Dark }, {
		Roact.createElement(LocalizationProvider, { localization = localization }, self:renderMain(p))
	})
end

function extended:render()
	return withStyle(function(p)
		return self.state.visible
			and Roact.createElement("Folder", {}, {
				BackgroundScreen = self:renderBackground(p),
				MainScreen = self:renderMainWithProviders(p)
			})
	end)
end

function extended.willUpdate(_, _, _) end

function extended:maybeStartFadeOut()
	if self.props.shouldStartFadeOut and not self.fadeOutTriggered then
		self.fadeOutTriggered = true

		if tenFootInterface then
			ContextActionService:UnbindCoreAction("CancelGameLoad")
		end

		task.spawn(function()
			while not self.fadeinComplete do
				wait()
			end

			self:stopAnimation()
			self:playAnimation(v6.FadeOut, {}, function()
				if FFlagLoadingScreenControlMilestones and self.props.milestones then
					self.props.milestones.record(Constants.Milestone.ScreenHidden)
				end

				self:setState({ visible = false })
			end)
		end)
	end
end

function extended:didUpdate(_, _)
	self:maybeStartFadeOut()
end

function extended:didMount()
	if FFlagLoadingScreenControlMilestones and self.props.milestones then
		self.props.milestones.record(Constants.Milestone.ScreenVisible)
	end

	if self.props.manageRobloxGuiFocus then
		RunService:SetRobloxGuiFocused(true)
	end

	self:playAnimation(v6.FadeIn, {}, function()
		self.fadeinComplete = true
	end)

	self:maybeStartFadeOut()
end

function extended.willUnmount(p)
	if FFlagLoadingScreenControlMilestones and p.props.milestones then
		p.props.milestones.abort(Constants.AbortReason.Unmounted)
	end

	ContextActionService:UnbindCoreAction("CancelGameLoad")

	if p.props.manageRobloxGuiFocus then
		RunService:SetRobloxGuiFocused(false)
	end

	if not inputBeganConnection then
		inputBeganConnection = UserInputService.InputBegan:Connect(function()
			if inputBeganConnection then
				inputBeganConnection:disconnect()
				inputBeganConnection = nil
				GuiService:CloseStatsBasedOnInputString("ConnectionHealth")
			end
		end)
	end
end

return extended
