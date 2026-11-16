local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")

local FFlagUseSharedLoadingScreenView = require(ExperienceLoadingScript.Flags.FFlagUseSharedLoadingScreenView)

if FFlagUseSharedLoadingScreenView then
	return require(ExperienceLoadingScript.LoadingScreenWrapper)
end

local parent = ExperienceLoadingScript.Parent

local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local RoactUtils = require(parent.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local GetGameProductInfo = require(ExperienceLoadingScript.Thunks.GetGameProductInfo)
local GetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Thunks.GetIsSubjectToChinaPolicies)
local GetUniverseId = require(ExperienceLoadingScript.Thunks.GetUniverseId)
local ProgressLoading = require(parent.ProgressLoading)
local PlaceLauncherState = ProgressLoading.PlaceLauncherState

local VerifiedBadges = require(parent.VerifiedBadges)
local LoggingProtocol = require(parent.LoggingProtocol)
local UIBlox = require(parent.UIBlox)
local SharedFlags = require(parent.SharedFlags)
local FFlagIncreaseLoadingScreenOrder = SharedFlags.FFlagIncreaseLoadingScreenOrder
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLoadingScreenControlMilestones = SharedFlags2.FFlagLoadingScreenControlMilestones
local LoadingScreenMilestones = require(parent.ProgressLoading.LoadingScreenMilestones)

local withStyle = UIBlox.Style.withStyle
local Responsive = require(parent.Responsive)

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local FoundationProvider = Foundation.FoundationProvider
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local AutoTranslateBadge = ProgressLoading.AutoTranslateBadge
local LoadingScreenTelemetry = require(parent.ProgressLoading.LoadingScreenTelemetry)
local PolicyContainer = ProgressLoading.PolicyContainer
local ServerStatus = ProgressLoading.ServerStatus
local ServerStatusWithCountdown = ProgressLoading.ServerStatusWithCountdown

local localization = Localization.new(LocalizationService.RobloxLocaleId)

local SocialExperiments = require(parent.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation

local GetFFlagReportFirstExperienceCancelled = require(ExperienceLoadingScript.Flags.GetFFlagReportFirstExperienceCancelled)

local createNetworking = ProgressLoading.createNetworking
local displayOrder = FFlagIncreaseLoadingScreenOrder and 8 or 7
local vector2 = Vector2.new(768, 432)

local color = Color3.fromRGB(101, 102, 104)

local v = {
	MOBILE_PORTRAIT = { TOP = 44, BOTTOM = 44, LEFT = 24, RIGHT = 24 },
	MOBILE_LANDSCAPE = { TOP = 24, BOTTOM = 24, LEFT = 44, RIGHT = 44 },
	DESKTOP = { TOP = 24, BOTTOM = 24, LEFT = 24, RIGHT = 24 },
	CONSOLE = { TOP = 64, BOTTOM = 64, LEFT = 64, RIGHT = 64 }
}

local AppCommonLib = require(parent.AppCommonLib)
local tenFootInterface = AppCommonLib.isTenFootInterface()
local platform = UserInputService:GetPlatform()
local v2 = platform == Enum.Platform.IOS or platform == Enum.Platform.Android

local v3 = { 150, 256 }

local inputBeganConnection = nil
local v4 = 0
local lastTime = 1e999

local function getPadding(isPortrait) -- 1 equivalent call inferred from this helper
	if v2 then
		return isPortrait and v.MOBILE_PORTRAIT or v.MOBILE_LANDSCAPE
	end

	return if tenFootInterface then v.CONSOLE else v.DESKTOP
end

local function lerp(list, value) -- 19 equivalent calls inferred from this helper
	if type(list) ~= "table" or not (#list >= 2) then
		return 0
	end

	local v5 = math.clamp(value, 0, 1)
	return list[1] * (1 - v5) + list[2] * v5
end

local v5 = {
	FadeIn = function(p, _, data, callback)
		local v5 = { 1, 1 }
		local v6 = { 1, 0 }
		local v7 = { 1, 0.2 }

		if p <= 0.6 then
			local v8 = p / 0.6
			data.iconTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.iconSize(lerp(v5, v8)) -- inferred equivalent call
			data.infoFrameTransparency(lerp(v7, v8)) -- inferred equivalent call
			data.thumbnailTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.placeTextTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.placeTextSize(lerp(v5, v8)) -- inferred equivalent call
			data.creatorTextTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.creatorTextSize(lerp(v5, v8)) -- inferred equivalent call
		else
			data.iconTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.iconSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
			data.infoFrameTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.thumbnailTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.placeTextTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.placeTextSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
			data.creatorTextTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.creatorTextSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
			callback()
		end
	end,
	FadeOut = function(p, _, data, callback)
		local v5 = { 1, 0.6 }
		local v6 = { 0, 1 }
		local v7 = { 0.2, 1 }

		if p <= 0.6 then
			local v8 = p / 0.6
			data.iconTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.iconSize(lerp(v5, v8)) -- inferred equivalent call
			data.infoFrameTransparency(lerp(v7, v8)) -- inferred equivalent call
			data.thumbnailTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.placeTextTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.placeTextSize(lerp(v5, v8)) -- inferred equivalent call
			data.creatorTextTransparency(lerp(v6, v8)) -- inferred equivalent call
			data.creatorTextSize(lerp(v5, v8)) -- inferred equivalent call
		else
			RunService:SetRobloxGuiFocused(false)
			data.iconTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.iconSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
			data.infoFrameTransparency((type(v7) ~= "table" or not (#v7 >= 2)) and 0 or v7[1] * 0 + v7[2] * 1)
			data.thumbnailTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.placeTextTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.placeTextSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
			data.creatorTextTransparency((type(v6) ~= "table" or not (#v6 >= 2)) and 0 or v6[1] * 0 + v6[2] * 1)
			data.creatorTextSize((type(v5) ~= "table" or not (#v5 >= 2)) and 0 or v5[1] * 0 + v5[2] * 1)
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

local extended = Roact.Component:extend("LoadingScreen")

function extended:playAnimation(animationFunction, p, callback)
	self.animationStartTime = tick()
	self.animationFunction = animationFunction

	if not self.renderSteppedConnection then
		self.renderSteppedConnection = RunService.RenderStepped:Connect(function()
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
	return Roact.createElement(
		"ScreenGui",
		{
			DisplayOrder = displayOrder,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		},
		{ Roact.createElement("Frame", {
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
			}) }
	)
end

function extended.showConnnectionHealthDebugMenu(_, _)
	if v4 == 0 then
		v4 = 1
		lastTime = tick()
	else
		if v2 and tick() - lastTime <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v4 = 0
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
	local v6 = {
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
		local v7 = {
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
		local v8 = {
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
		local v9 = lerp({ 0.7, 1 }, value) -- inferred equivalent call
		v8.Transparency = NumberSequence.new({
			numberSequenceKeypoint,
			numberSequenceKeypoint2,
			NumberSequenceKeypoint.new(1, v9)
		})

		v8.Offset = Vector2.new(shimPos, 0)
		children.Gradient = createElement3("UIGradient", v8)

		children.renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = self.renderShimmerCallback
		})
		loadingOverlay = createElement2("Frame", v7, children)
	end

	return createElement("Frame", v6, {
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

function extended:renderInfoFrame(props)
	local productInfo = self.props.productInfo
	local name = productInfo and productInfo.Name or ""
	local name2 = productInfo and productInfo.Creator.Name or ""

	if productInfo and productInfo.Creator.HasVerifiedBadge then
		name2 = VerifiedBadges.appendVerifiedBadge(name2)
	end

	local v6 = math.clamp(math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v3[1], v3[1], v3[2])
	local createElement = Roact.createElement
	local v7 = {
		Name = "InfoFrame",
		BackgroundColor3 = props.Theme.BackgroundMuted.Color,
		BackgroundTransparency = self.bindings.infoFrameTransparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = self.isPortrait and UDim2.fromScale(1, 0) or UDim2.fromScale(0.6, 0),
		Active = true,
		[Roact.Change.AbsoluteSize] = function(p)
			self.updateBindings.updateInfoFrameAbsoluteSize(p.AbsoluteSize)
		end
	}
	local children = { PlaceIcon = self:renderPlaceIcon(props), TextLayoutFrame = 0, Corner = 0 }
	local createElement2 = Roact.createElement
	local v8 = {
		Name = "TextLayout",
		BackgroundColor3 = props.Theme.BackgroundMuted.Color,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0.5, 0, 0, v6 / 2),
		Size = UDim2.fromScale(1, 0),
		Active = true
	}

	local createElement3 = Roact.createElement
	local placeLabel = {
		Name = "PlaceLabel",
		BackgroundTransparency = 1,
		TextTransparency = self.bindings.placeTextTransparency,
		Size = UDim2.fromScale(0.8, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextScaled = false,
		TextWrapped = true,
		TextColor3 = 0,
		TextStrokeTransparency = 1,
		Text = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ZIndex = 2,
		LayoutOrder = 1,
		TextTruncate = 0,
		RichText = false
	}
	local font

	if not FoundationFontFaceMigration then
		font = props.Font.Title.Font
	end

	placeLabel.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(props.Tokens.Typography.HeadingLarge.Font)
	end

	placeLabel.FontFace = fontFace

	placeLabel.TextSize = self.bindings.placeTextSize

	placeLabel.TextColor3 = props.Theme.TextEmphasis.Color

	placeLabel.Text = name
	placeLabel.TextXAlignment = Enum.TextXAlignment.Center
	placeLabel.TextYAlignment = Enum.TextYAlignment.Center

	placeLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local children2 = {
		PlaceLabel = createElement3("TextLabel", placeLabel),
		CreatorLabel = 0,
		UIListLayout = 0,
		Padding = 0
	}

	local createElement4 = Roact.createElement
	local creatorLabel = {
		Name = "CreatorLabel",
		BackgroundTransparency = 1,
		TextTransparency = self.bindings.creatorTextTransparency,
		Size = UDim2.fromScale(0.6, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextWrapped = true,
		TextScaled = false,
		TextColor3 = 0,
		TextStrokeTransparency = 1,
		Text = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ZIndex = 2,
		LayoutOrder = 2,
		TextTruncate = 0,
		RichText = false
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = props.Font.CaptionBody.Font
	end

	creatorLabel.Font = font2
	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
	end

	creatorLabel.FontFace = fontFace2

	creatorLabel.TextSize = self.bindings.creatorTextSize

	creatorLabel.TextColor3 = props.Theme.TextDefault.Color

	creatorLabel.Text = name2
	creatorLabel.TextXAlignment = Enum.TextXAlignment.Center
	creatorLabel.TextYAlignment = Enum.TextYAlignment.Center

	creatorLabel.TextTruncate = Enum.TextTruncate.AtEnd
	children2.CreatorLabel = createElement4("TextLabel", creatorLabel)

	children2.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, v2 and 12 or 36)
	})

	children2.Padding = Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v2 and 12 or 36),
		PaddingBottom = UDim.new(0, v2 and 12 or 36)
	})
	children.TextLayoutFrame = createElement2("Frame", v8, children2)

	children.Corner = Roact.createElement("UICorner")
	return createElement("Frame", v7, children)
end

function extended:renderMain(p)
	local padding = getPadding(self.isPortrait) -- inferred equivalent call

	local reducedMotion = p.Settings.ReducedMotion
	local createElement = Roact.createElement
	local v6 = {
		DisplayOrder = displayOrder + 1,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		OnTopOfCoreBlur = true
	}

	local createElement2 = Roact.createElement
	local v7 = {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}
	local v8 = {
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

	v8.serverFrame = serverFrame
	local policyContainer

	if self.isQueueTreatmentEnabled then
		policyContainer = self:renderPolicyContainer()
	end

	v8.policyContainer = policyContainer
	local serverStatusContainer

	if self.isQueueTreatmentEnabled then
		serverStatusContainer = self:renderServerStatus()
	end

	v8.serverStatusContainer = serverStatusContainer
	v8.closeBtn = self:renderCloseBtn(p)
	v8.gamepadCancelBtn = self:renderGamepadCancelBtn(p)
	v8.Padding = Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, padding.LEFT),
		PaddingRight = UDim.new(0, padding.RIGHT),
		PaddingTop = UDim.new(0, padding.TOP),
		PaddingBottom = UDim.new(0, padding.BOTTOM)
	})
	return createElement("ScreenGui", v6, {
		DarkGradient = createElement2("Frame", v7, v8)
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
	local v6 = {
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
	v6.Size = UDim2.fromOffset(32, 32)

	v6.Active = false
	v6.ZIndex = 10
	v6[Roact.Event.MouseButton1Click] = function()
		if FFlagLoadingScreenControlMilestones and self.props.milestones then
			self.props.milestones.abort(LoadingScreenMilestones.AbortReason.Cancelled)
		end

		if GetFFlagReportFirstExperienceCancelled then
			LoggingProtocol.default:logEventOnce("first_experience_cancelled")
		end

		game:Shutdown()
	end

	closeBtn = createElement("ImageButton", v6)
	return closeBtn
end

function extended:renderServerFrame(props)
	local serverStatusText = self.state.serverStatusText
	local policyLabel2 = self.props.isSubjectToChinaPolicies
	local textSize = tenFootInterface and 16 or 12
	local textSize2 = tenFootInterface and 16 or 12
	local createElement = Roact.createElement
	local v6 = {
		Name = "ServerFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(1, -48, 0.2, 0),
		Active = true
	}

	if policyLabel2 then
		local createElement2 = Roact.createElement
		local policyLabel = {
			Name = "PolicyLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 2 * textSize2),
			Position = UDim2.new(0, 0, 1, -4 * textSize - 2 * textSize2),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextWrapped = true,
			TextScaled = false,
			TextColor3 = 0,
			TextStrokeTransparency = 1,
			Text = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ZIndex = 2
		}
		local font

		if not FoundationFontFaceMigration then
			font = props.Font.Footer.Font
		end

		policyLabel.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font)
		end

		policyLabel.FontFace = fontFace

		policyLabel.TextSize = textSize2

		policyLabel.TextColor3 = props.Theme.TextDefault.Color

		policyLabel.Text = localization:Format("Authentication.Login.WeChat.AntiAddictionText")
		policyLabel.TextXAlignment = Enum.TextXAlignment.Center
		policyLabel.TextYAlignment = Enum.TextYAlignment.Center
		policyLabel2 = createElement2("TextLabel", policyLabel)
	end

	local createElement2 = Roact.createElement
	local v7 = {
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		["Name"] = nil,
		Name = "JoinText",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 4 * textSize),
		Position = UDim2.new(0, 0, 1, -2 * textSize)
	}
	local font

	if not FoundationFontFaceMigration then
		font = props.Font.Footer.Font
	end

	v7.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font)
	end

	v7.FontFace = fontFace

	v7.TextSize = textSize
	v7.TextWrapped = true
	v7.TextScaled = false
	v7.TextColor3 = props.Theme.TextDefault.Color
	v7.TextStrokeTransparency = 1
	v7.Text = serverStatusText
	v7.TextXAlignment = Enum.TextXAlignment.Center
	v7.TextYAlignment = Enum.TextYAlignment.Center
	v7.ZIndex = 2
	v7.RootLocalizationTable = CoreGui.CoreScriptLocalization
	local inputBegan = Roact.Event.InputBegan
	local v8

	if not self.props.isSubjectToChinaPolicies then
		v8 = self.showConnnectionHealthDebugMenu or nil
	end

	v7[inputBegan] = v8
	return createElement("Frame", v6, {
		PolicyLabel = policyLabel2,
		JoinServerLabel = createElement2("TextLabel", v7)
	})
end

function extended:renderGamepadCancelBtn(props)
	local gamepadCancelBtn

	if self.props.preferredInputRef.current == Responsive.Input.Directional then
		gamepadCancelBtn = not self.state.gamepadCancelPressed

		if gamepadCancelBtn then
			local createElement = Roact.createElement
			local v6 = {
				Name = "GamepadCancelFrame",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromOffset(150, 48),
				Active = true
			}

			local children = {
				CancelIcon = Roact.createElement("ImageLabel", {
					Name = "GamepadCancel",
					Image = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png",
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(24, 24),
					Active = false,
					ZIndex = 10,
					LayoutOrder = 0
				}),
				CancelLabel = 0,
				UIListLayout = 0
			}

			local createElement2 = Roact.createElement
			local cancelText = {
				Name = "CancelText",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Font = 0,
				FontFace = 0,
				TextSize = 24,
				TextWrapped = true,
				TextColor3 = 0,
				TextStrokeTransparency = 1,
				Text = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				ZIndex = 2,
				LayoutOrder = 1
			}
			local font

			if not FoundationFontFaceMigration then
				font = props.Font.SubHeader1.Font
			end

			cancelText.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			cancelText.FontFace = fontFace

			cancelText.TextColor3 = props.Theme.TextEmphasis.Color

			cancelText.Text = localization:Format("CoreScripts.TopBar.Back")
			cancelText.TextXAlignment = Enum.TextXAlignment.Left
			cancelText.TextYAlignment = Enum.TextYAlignment.Center
			children.CancelLabel = createElement2("TextLabel", cancelText)

			children.UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 5)
			})
			gamepadCancelBtn = createElement("Frame", v6, children)
		end
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

	game.Loaded:Connect(function()
		if tenFootInterface then
			ContextActionService:UnbindCoreAction("CancelGameLoad")
		end

		while not self.fadeinComplete do
			wait()
		end

		self:stopAnimation()
		self:playAnimation(v5.FadeOut, {}, function()
			if FFlagLoadingScreenControlMilestones and self.props.milestones then
				self.props.milestones.record(LoadingScreenMilestones.Milestone.ScreenHidden)
				self.props.milestones.complete()
			end

			self:setState({ visible = false })
		end)
	end)

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
			local v6 = math.clamp(
				math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v3[1],
				v3[1],
				v3[2]
			)
			return UDim2.fromOffset(v6 * p, v6 * p)
		end),
		placeTextTransparency = binding4,
		placeTextSize = binding5:map(function(p)
			return (v2 and 20 or 36) * p
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

		local v6 = thumbnailScaledWidth / absoluteSize.x / 2

		local v7 = math.max(v6, 1 - v6)

		local v8 = math.min(v6, 1 - v6)
		local thumbnailPositionX = self.state.thumbnailPositionX + self.thumbnailMoveSpd * p

		if v7 <= thumbnailPositionX or thumbnailPositionX <= v8 then
			self.thumbnailMoveSpd = -self.thumbnailMoveSpd
			thumbnailPositionX = math.clamp(thumbnailPositionX, v8, v7)
		end

		self:setState({
			thumbnailPositionX = thumbnailPositionX,
			thumbnailScaledHeight = thumbnailScaledHeight,
			thumbnailScaledWidth = thumbnailScaledWidth
		})
	end

	function self.renderShimmerCallback(p)
		local v6 = self.state.shimPos + p * 1

		self:setState({
			shimPos = v6 > 1 and -1 or v6
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
	local v6 = false
	ContextActionService:BindCoreAction("CancelGameLoad", function(_, p, _)
		if p == Enum.UserInputState.Begin then
			v6 = true
		elseif p == Enum.UserInputState.End and v6 then
			self:setState({ showTenFootCancelBtn = false })

			self:setState({ gamepadCancelPressed = true })

			ContextActionService:UnbindCoreAction("CancelGameLoad")

			if not game:IsLoaded() then
				if FFlagLoadingScreenControlMilestones and self.props.milestones then
					self.props.milestones.abort(LoadingScreenMilestones.AbortReason.Cancelled)
				end

				game:Shutdown()
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
	return Roact.createElement(FoundationProvider, { colorMode = Foundation.Enums.ColorMode.Dark }, {
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

function extended:didMount()
	if FFlagLoadingScreenControlMilestones and self.props.milestones then
		self.props.milestones.record(LoadingScreenMilestones.Milestone.ScreenVisible)
	end

	RunService:SetRobloxGuiFocused(true)

	self.props.fetchUniverseId(self.props.placeId)

	self.props.fetchGameProductInfo(self.props.placeId)

	self.props.fetchSubjectToChinaPolicies()

	self:playAnimation(v5.FadeIn, {}, function()
		self.fadeinComplete = true
	end)

	if QueueExperimentation.isInExperiment() and ExperienceService:GetFollowUserId() > 0 and self.props.placeId > 0 then
		if ExperienceService:GetPlaceJoinState() == PlaceLauncherState.Queued then
			QueueExperimentation.logExposure()
		else
			self.placeJoinStateConnection = ExperienceService.PlaceJoinStateChanged:Connect(function(p)
				if p == PlaceLauncherState.Queued then
					QueueExperimentation.logExposure()
				end
			end)
		end
	end
end

function extended:willUnmount()
	if FFlagLoadingScreenControlMilestones and self.props.milestones then
		self.props.milestones.abort(LoadingScreenMilestones.AbortReason.Unmounted)
	end

	ContextActionService:UnbindCoreAction("CancelGameLoad")
	RunService:SetRobloxGuiFocused(false)

	if not inputBeganConnection then
		inputBeganConnection = UserInputService.InputBegan:Connect(function()
			if inputBeganConnection then
				inputBeganConnection:disconnect()
				inputBeganConnection = nil
				GuiService:CloseStatsBasedOnInputString("ConnectionHealth")
			end
		end)
	end

	if QueueExperimentation.isInExperiment() and self.placeJoinStateConnection then
		self.placeJoinStateConnection:Disconnect()
		self.placeJoinStateConnection = nil
	end
end

local v6 = RoactRodux.connect(function(data, p)
	return {
		productInfo = data.productInfo,
		isSubjectToChinaPolicies = data.isSubjectToChinaPolicies,
		placeId = data.gameIds and data.gameIds.placeId or p.placeId,
		universeId = data.gameIds and data.gameIds.universeId or 0,
		settings = data.settings
	}
end, function(callback)
	return {
		fetchGameProductInfo = function(p)
			callback(GetGameProductInfo(p))
		end,
		fetchSubjectToChinaPolicies = function()
			callback(GetIsSubjectToChinaPolicies())
		end,
		fetchUniverseId = function(p)
			callback(GetUniverseId(createNetworking, p))
		end
	}
end)(extended)
return function(p)
	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput()

	return React.createElement(v6, Cryo.Dictionary.join(p, { preferredInputRef = ref }))
end
