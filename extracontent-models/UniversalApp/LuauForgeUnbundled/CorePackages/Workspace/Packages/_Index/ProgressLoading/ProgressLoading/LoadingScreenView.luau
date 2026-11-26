local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Roact")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/RoactUtils").ExternalEventConnection
local MockableProxyServices = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/MockableProxyServices")

local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/VerifiedBadges")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/UIBlox").Style.withStyle
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Responsive")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local foundationProvider = Foundation.FoundationProvider
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local localization = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/InExperienceLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").LocalizationProvider

local AutoTranslateBadge = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/AutoTranslateBadge")
local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")
local PolicyContainer = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/PolicyContainer")
local ServerStatus = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/ServerStatus")
local ServerStatusWithCountdown = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/ServerStatusWithCountdown")

local v5 = localization.new(LocalizationService.RobloxLocaleId)

local queueExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SocialExperiments").QueueExperimentation

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags")
local fFlagIncreaseLoadingScreenOrder = SharedFlags.FFlagIncreaseLoadingScreenOrder
local fFlagLoadingScreenControlMilestones = SharedFlags.FFlagLoadingScreenControlMilestones
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
local v6 = fFlagIncreaseLoadingScreenOrder and 8 or 7
local vector2 = Vector2.new(768, 432)

local color = Color3.fromRGB(101, 102, 104)

local v7 = {
	MOBILE_PORTRAIT = { TOP = 44, BOTTOM = 44, LEFT = 24, RIGHT = 24 },
	MOBILE_LANDSCAPE = { TOP = 24, BOTTOM = 24, LEFT = 44, RIGHT = 44 },
	DESKTOP = { TOP = 24, BOTTOM = 24, LEFT = 24, RIGHT = 24 },
	CONSOLE = { TOP = 64, BOTTOM = 64, LEFT = 64, RIGHT = 64 }
}

local tenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/AppCommonLib").isTenFootInterface()
local platform = UserInputService:GetPlatform()
local v8 = platform == Enum.Platform.IOS or platform == Enum.Platform.Android

local v9 = { 150, 256 }

local inputBeganConnection = nil
local v10 = 0
local lastTime = 1e999

local function getPadding(p2)
	if v8 then
		return p2 and v7.MOBILE_PORTRAIT or v7.MOBILE_LANDSCAPE
	end

	if tenFootInterface then
		return v7.CONSOLE
	end

	return v7.DESKTOP
end

local function lerp(list, value)
	if type(list) ~= "table" or not (#list >= 2) then
		return 0
	end

	local v11 = math.clamp(value, 0, 1)
	return list[1] * (1 - v11) + list[2] * v11
end

local v11 = {
	FadeIn = function(p2, p3, data, callback)
		local v12 = { 1, 1 }
		local v13 = { 1, 0 }
		local v14 = { 1, 0.2 }

		if p2 <= 0.6 then
			local v15 = p2 / 0.6
			local iconTransparency = data.iconTransparency
			local v16

			if type(v13) == "table" and #v13 >= 2 then
				local v17 = math.clamp(v15, 0, 1)
				v16 = v13[1] * (1 - v17) + v13[2] * v17
			else
				v16 = 0
			end

			iconTransparency(v16)
			local iconSize2 = data.iconSize
			local v17

			if type(v12) == "table" and #v12 >= 2 then
				local v18 = math.clamp(v15, 0, 1)
				v17 = v12[1] * (1 - v18) + v12[2] * v18
			else
				v17 = 0
			end

			iconSize2(v17)
			local infoFrameTransparency = data.infoFrameTransparency
			local v18

			if type(v14) == "table" and #v14 >= 2 then
				local v19 = math.clamp(v15, 0, 1)
				v18 = v14[1] * (1 - v19) + v14[2] * v19
			else
				v18 = 0
			end

			infoFrameTransparency(v18)
			local thumbnailTransparency = data.thumbnailTransparency
			local v19

			if type(v13) == "table" and #v13 >= 2 then
				local v20 = math.clamp(v15, 0, 1)
				v19 = v13[1] * (1 - v20) + v13[2] * v20
			else
				v19 = 0
			end

			thumbnailTransparency(v19)
			local placeTextTransparency = data.placeTextTransparency
			local v20

			if type(v13) == "table" and #v13 >= 2 then
				local v21 = math.clamp(v15, 0, 1)
				v20 = v13[1] * (1 - v21) + v13[2] * v21
			else
				v20 = 0
			end

			placeTextTransparency(v20)
			local placeTextSize = data.placeTextSize
			local v21

			if type(v12) == "table" and #v12 >= 2 then
				local v22 = math.clamp(v15, 0, 1)
				v21 = v12[1] * (1 - v22) + v12[2] * v22
			else
				v21 = 0
			end

			placeTextSize(v21)
			local creatorTextTransparency = data.creatorTextTransparency
			local v22

			if type(v13) == "table" and #v13 >= 2 then
				local v23 = math.clamp(v15, 0, 1)
				v22 = v13[1] * (1 - v23) + v13[2] * v23
			else
				v22 = 0
			end

			creatorTextTransparency(v22)
			local creatorTextSize = data.creatorTextSize
			local v23

			if type(v12) == "table" and #v12 >= 2 then
				local v24 = math.clamp(v15, 0, 1)
				v23 = v12[1] * (1 - v24) + v12[2] * v24
			else
				v23 = 0
			end

			creatorTextSize(v23)
		else
			data.iconTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.iconSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
			data.infoFrameTransparency((type(v14) ~= "table" or not (#v14 >= 2)) and 0 or v14[1] * 0 + v14[2] * 1)
			data.thumbnailTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.placeTextTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.placeTextSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
			data.creatorTextTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.creatorTextSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
			callback()
		end
	end,
	FadeOut = function(p2, p3, data, callback)
		local v12 = { 1, 0.6 }
		local v13 = { 0, 1 }
		local v14 = { 0.2, 1 }

		if p2 <= 0.6 then
			local v15 = p2 / 0.6
			local iconTransparency = data.iconTransparency
			local v16

			if type(v13) == "table" and #v13 >= 2 then
				local v17 = math.clamp(v15, 0, 1)
				v16 = v13[1] * (1 - v17) + v13[2] * v17
			else
				v16 = 0
			end

			iconTransparency(v16)
			local iconSize2 = data.iconSize
			local v17

			if type(v12) == "table" and #v12 >= 2 then
				local v18 = math.clamp(v15, 0, 1)
				v17 = v12[1] * (1 - v18) + v12[2] * v18
			else
				v17 = 0
			end

			iconSize2(v17)
			local infoFrameTransparency = data.infoFrameTransparency
			local v18

			if type(v14) == "table" and #v14 >= 2 then
				local v19 = math.clamp(v15, 0, 1)
				v18 = v14[1] * (1 - v19) + v14[2] * v19
			else
				v18 = 0
			end

			infoFrameTransparency(v18)
			local thumbnailTransparency = data.thumbnailTransparency
			local v19

			if type(v13) == "table" and #v13 >= 2 then
				local v20 = math.clamp(v15, 0, 1)
				v19 = v13[1] * (1 - v20) + v13[2] * v20
			else
				v19 = 0
			end

			thumbnailTransparency(v19)
			local placeTextTransparency = data.placeTextTransparency
			local v20

			if type(v13) == "table" and #v13 >= 2 then
				local v21 = math.clamp(v15, 0, 1)
				v20 = v13[1] * (1 - v21) + v13[2] * v21
			else
				v20 = 0
			end

			placeTextTransparency(v20)
			local placeTextSize = data.placeTextSize
			local v21

			if type(v12) == "table" and #v12 >= 2 then
				local v22 = math.clamp(v15, 0, 1)
				v21 = v12[1] * (1 - v22) + v12[2] * v22
			else
				v21 = 0
			end

			placeTextSize(v21)
			local creatorTextTransparency = data.creatorTextTransparency
			local v22

			if type(v13) == "table" and #v13 >= 2 then
				local v23 = math.clamp(v15, 0, 1)
				v22 = v13[1] * (1 - v23) + v13[2] * v23
			else
				v22 = 0
			end

			creatorTextTransparency(v22)
			local creatorTextSize = data.creatorTextSize
			local v23

			if type(v12) == "table" and #v12 >= 2 then
				local v24 = math.clamp(v15, 0, 1)
				v23 = v12[1] * (1 - v24) + v12[2] * v24
			else
				v23 = 0
			end

			creatorTextSize(v23)
		else
			RunService:SetRobloxGuiFocused(false)
			data.iconTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.iconSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
			data.infoFrameTransparency((type(v14) ~= "table" or not (#v14 >= 2)) and 0 or v14[1] * 0 + v14[2] * 1)
			data.thumbnailTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.placeTextTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.placeTextSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
			data.creatorTextTransparency((type(v13) ~= "table" or not (#v13 >= 2)) and 0 or v13[1] * 0 + v13[2] * 1)
			data.creatorTextSize((type(v12) ~= "table" or not (#v12 >= 2)) and 0 or v12[1] * 0 + v12[2] * 1)
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

function extended:playAnimation(animationFunction, p2, callback)
	self.animationStartTime = tick()
	self.animationFunction = animationFunction

	if not self.renderSteppedConnection then
		self.renderSteppedConnection = MockableProxyServices.RunService.RenderStepped:Connect(function()
			self.animationFunction(tick() - self.animationStartTime, p2, self.updateBindings, function()
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

function extended.renderBackground(props, p2)
	local thumbnailScaledWidth = props.state.thumbnailScaledWidth
	local thumbnailScaledHeight = props.state.thumbnailScaledHeight
	local thumbnailPositionX = props.state.thumbnailPositionX

	local v12 = not (props.props.placeId and props.props.placeId > 0) and ""
		or ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(props.props.placeId)

	local reducedMotion = p2.Settings.ReducedMotion
	return Roact.createElement("ScreenGui", {
		DisplayOrder = props.props.displayOrder or v6,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, { Roact.createElement("Frame", {
			Name = "BackgroundFrame",
			[Roact.Change.AbsoluteSize] = props.onAbsoluteSizeChange,
			BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Active = true
		}, {
			ThumbnailImage = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = v12,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(thumbnailPositionX, 0.5),
				Size = UDim2.fromOffset(thumbnailScaledWidth, thumbnailScaledHeight),
				ImageTransparency = props.bindings.thumbnailTransparency
			}),
			renderStepped = not reducedMotion and Roact.createElement(externalEventConnection, {
				event = RunService.renderStepped,
				callback = props.renderBackgroundSteppedCallback
			})
		}) })
end

function extended.showConnnectionHealthDebugMenu(p2, p3)
	if v10 == 0 then
		v10 = 1
		lastTime = tick()
	else
		if v8 and tick() - lastTime <= 0.5 then
			GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
		end

		v10 = 0
		lastTime = 1e999
	end
end

function extended:renderPlaceIcon(p2)
	local shimPos = self.state.shimPos
	local value = self.bindings.iconTransparency:getValue()

	local v12 = not (self.props.universeId and self.props.universeId > 0) and ""
		or ("rbxthumb://type=GameIcon&id=%d&w=256&h=256"):format(self.props.universeId)

	local reducedMotion = p2.Settings.ReducedMotion
	local createElement = Roact.createElement
	local v14 = {
		Name = "IconFrame",
		BackgroundTransparency = self.bindings.iconTransparency,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Size = self.bindings.iconSize,
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true
	}

	local v15 = not reducedMotion

	if v15 then
		local createElement2 = Roact.createElement
		local v17 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			ZIndex = 2
		}

		local children2 = {
			Corner = Roact.createElement("UICorner"),
			Gradient = 0,
			renderStepped = 0
		}
		local createElement3 = Roact.createElement
		local v19 = {
			Rotation = 25,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
			}),
			Transparency = 0,
			Offset = 0
		}

		local newNumberSequence = NumberSequence.new
		local newNumberSequenceKeypoint = NumberSequenceKeypoint.new
		local v22 = { 0.7, 1 }
		local v23

		if type(v22) == "table" and #v22 >= 2 then
			local v24 = math.clamp(value, 0, 1)
			v23 = v22[1] * (1 - v24) + v22[2] * v24
		else
			v23 = 0
		end

		local numberSequenceKeypoint = newNumberSequenceKeypoint(0, v23)
		local newNumberSequenceKeypoint2 = NumberSequenceKeypoint.new
		local v25 = { 0.3, 1 }
		local v26

		if type(v25) == "table" and #v25 >= 2 then
			local v27 = math.clamp(value, 0, 1)
			v26 = v25[1] * (1 - v27) + v25[2] * v27
		else
			v26 = 0
		end

		local numberSequenceKeypoint2 = newNumberSequenceKeypoint2(0.5, v26)
		local newNumberSequenceKeypoint3 = NumberSequenceKeypoint.new
		local v28 = { 0.7, 1 }
		local v29

		if type(v28) == "table" and #v28 >= 2 then
			local v30 = math.clamp(value, 0, 1)
			v29 = v28[1] * (1 - v30) + v28[2] * v30
		else
			v29 = 0
		end

		v19.Transparency = newNumberSequence({
			numberSequenceKeypoint,
			numberSequenceKeypoint2,
			newNumberSequenceKeypoint3(1, v29)
		})

		v19.Offset = Vector2.new(shimPos, 0)
		children2.Gradient = createElement3("UIGradient", v19)

		children2.renderStepped = Roact.createElement(externalEventConnection, {
			event = RunService.renderStepped,
			callback = self.renderShimmerCallback
		})
		v15 = createElement2("Frame", v17, children2)
	end

	return createElement("Frame", v14, {
		LoadingOverlay = v15,
		GameIconImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = v12,
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

function extended:renderInfoFrame(p2)
	local productInfo = self.props.productInfo
	local name = productInfo and productInfo.Name or ""
	local name2 = productInfo and productInfo.Creator.Name or ""

	if productInfo and productInfo.Creator.HasVerifiedBadge then
		name2 = VerifiedBadges.appendVerifiedBadge(name2)
	end

	local v12 = math.clamp(
		math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v9[1],
		v9[1],
		v9[2]
	)
	return Roact.createElement("Frame", {
		Name = "InfoFrame",
		BackgroundColor3 = p2.Theme.BackgroundMuted.Color,
		BackgroundTransparency = self.bindings.infoFrameTransparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = self.isPortrait and UDim2.fromScale(1, 0) or UDim2.fromScale(0.6, 0),
		Active = true,
		[Roact.Change.AbsoluteSize] = function(p3)
			self.updateBindings.updateInfoFrameAbsoluteSize(p3.AbsoluteSize)
		end
	}, {
		PlaceIcon = self:renderPlaceIcon(p2),
		TextLayoutFrame = Roact.createElement("Frame", {
			Name = "TextLayout",
			BackgroundColor3 = p2.Theme.BackgroundMuted.Color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 0, v12 / 2),
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
				FontFace = normalizeFontFace(p2.Tokens.Typography.HeadingLarge.Font),
				TextSize = self.bindings.placeTextSize,
				TextScaled = false,
				TextWrapped = true,
				TextColor3 = p2.Theme.TextEmphasis.Color,
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
				FontFace = normalizeFontFace(p2.Tokens.Typography.BodySmall.Font),
				TextSize = self.bindings.creatorTextSize,
				TextWrapped = true,
				TextScaled = false,
				TextColor3 = p2.Theme.TextDefault.Color,
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
				Padding = UDim.new(0, v8 and 12 or 36)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v8 and 12 or 36),
				PaddingBottom = UDim.new(0, v8 and 12 or 36)
			})
		}),
		Corner = Roact.createElement("UICorner")
	})
end

function extended:renderMain(p2)
	local isPortrait = self.isPortrait
	local v12

	if v8 then
		v12 = isPortrait and v7.MOBILE_PORTRAIT or v7.MOBILE_LANDSCAPE
	else
		v12 = if tenFootInterface then v7.CONSOLE else v7.DESKTOP
	end

	local reducedMotion = p2.Settings.ReducedMotion
	local createElement = Roact.createElement
	local v14 = {
		DisplayOrder = (self.props.displayOrder or v6) + 1,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		OnTopOfCoreBlur = true
	}

	local createElement2 = Roact.createElement
	local v17 = {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}
	local v18 = {
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
			{ Roact.createElement(loading, {
					size = iconSize.Medium,
					Position = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(1, 1)
				}) }
		),
		infoFrame = self:renderInfoFrame(p2),
		AutoTranslate = self:renderAutoTranslate(),
		serverFrame = 0,
		policyContainer = 0,
		serverStatusContainer = 0,
		closeBtn = 0,
		gamepadCancelBtn = 0,
		Padding = 0
	}
	local v19 = if not self.isQueueTreatmentEnabled then self:renderServerFrame(p2) else nil
	v18.serverFrame = v19
	local v20 = if self.isQueueTreatmentEnabled then self:renderPolicyContainer() else nil
	v18.policyContainer = v20
	local v21 = if self.isQueueTreatmentEnabled then self:renderServerStatus() else nil
	v18.serverStatusContainer = v21
	v18.closeBtn = self:renderCloseBtn(p2)
	v18.gamepadCancelBtn = self:renderGamepadCancelBtn(p2)
	v18.Padding = Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v12.LEFT),
		PaddingRight = UDim.new(0, v12.RIGHT),
		PaddingTop = UDim.new(0, v12.TOP),
		PaddingBottom = UDim.new(0, v12.BOTTOM)
	})
	return createElement("ScreenGui", v14, {
		DarkGradient = createElement2("Frame", v17, v18)
	})
end

function extended:renderCloseBtn(p2)
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
	local v13 = {
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
	local fromOffset = UDim2.fromOffset
	local isQueueTreatmentEnabled = self.isQueueTreatmentEnabled
	local isQueueTreatmentEnabled2 = self.isQueueTreatmentEnabled
	v13.Size = fromOffset(32, 32)

	v13.Active = false
	v13.ZIndex = 10
	v13[Roact.Event.MouseButton1Click] = function()
		if self.props.onCloseButtonActivated then
			self.props.onCloseButtonActivated()
		end
	end

	closeBtn = createElement("ImageButton", v13)
	return closeBtn
end

function extended:renderServerFrame(p2)
	local serverStatusText = self.state.serverStatusText
	local isSubjectToChinaPolicies = self.props.isSubjectToChinaPolicies
	local v12 = tenFootInterface and 16 or 12
	local v13 = tenFootInterface and 16 or 12
	local createElement = Roact.createElement
	local v15 = {
		Name = "ServerFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(1, -48, 0.2, 0),
		Active = true
	}

	local v16 = {
		PolicyLabel = isSubjectToChinaPolicies and Roact.createElement("TextLabel", {
			Name = "PolicyLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 2 * v13),
			Position = UDim2.new(0, 0, 1, -4 * v12 - 2 * v13),
			FontFace = normalizeFontFace(p2.Tokens.Typography.CaptionSmall.Font),
			TextSize = v13,
			TextWrapped = true,
			TextScaled = false,
			TextColor3 = p2.Theme.TextDefault.Color,
			TextStrokeTransparency = 1,
			Text = v5:Format("Authentication.Login.WeChat.AntiAddictionText"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 2
		}),
		JoinServerLabel = 0
	}

	local createElement2 = Roact.createElement
	local v18 = {
		Name = "JoinText",
		BackgroundTransparency = 1,
		["Size"] = UDim2.new(1, 0, 0, 4 * v12),
		Position = UDim2.new(0, 0, 1, -2 * v12),
		FontFace = normalizeFontFace(p2.Tokens.Typography.CaptionSmall.Font),
		TextSize = v12,
		TextWrapped = true,
		TextScaled = false,
		TextColor3 = p2.Theme.TextDefault.Color,
		TextStrokeTransparency = 1,
		Text = serverStatusText,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 2,
		RootLocalizationTable = CoreGui:FindFirstChild("CoreScriptLocalization")
	}
	local inputBegan = Roact.Event.InputBegan
	local v19 = if not self.props.isSubjectToChinaPolicies then self.showConnnectionHealthDebugMenu or nil else nil
	v18[inputBegan] = v19
	v16.JoinServerLabel = createElement2("TextLabel", v18)
	return createElement("Frame", v15, v16)
end

function extended:renderGamepadCancelBtn(p3)
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
				FontFace = normalizeFontFace(p3.Tokens.Typography.TitleLarge.Font),
				TextSize = 24,
				TextWrapped = true,
				TextColor3 = p3.Theme.TextEmphasis.Color,
				TextStrokeTransparency = 1,
				Text = v5:Format("CoreScripts.TopBar.Back"),
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

	self.isQueueTreatmentEnabled = (queueExperimentation.getIsJoinNewServerButtonEnabled() or queueExperimentation.getIsAutoJoinNewServerEnabled())
		and self.props.placeId > 0

	function self.onAbsoluteSizeChange(p2)
		self:setState({ absoluteSize = p2.AbsoluteSize })

		self.isPortrait = p2.AbsoluteSize.X < p2.AbsoluteSize.Y
		self.updateBindings.iconSize(1)
	end

	local binding, v12 = Roact.createBinding(1)
	local binding2, v13 = Roact.createBinding(1)
	local binding3, v14 = Roact.createBinding(0)
	local binding4, v15 = Roact.createBinding(1)
	local binding5, v16 = Roact.createBinding(0)
	local binding6, v17 = Roact.createBinding(1)
	local binding7, v18 = Roact.createBinding(0)
	local binding8, v19 = Roact.createBinding(1)
	local binding9, v20 = Roact.createBinding(Vector2.new(0, 0))

	self.bindings = {
		thumbnailTransparency = binding,
		iconTransparency = binding2,
		iconSize = binding3:map(function(p2)
			local v21 = math.clamp(
				math.max(self.state.absoluteSize.X, self.state.absoluteSize.Y) / 1024 * v9[1],
				v9[1],
				v9[2]
			)
			return UDim2.fromOffset(v21 * p2, v21 * p2)
		end),
		placeTextTransparency = binding4,
		placeTextSize = binding5:map(function(p2)
			return (v8 and 20 or 36) * p2
		end),
		creatorTextTransparency = binding6,
		creatorTextSize = binding7:map(function(p2)
			return 20 * p2
		end),
		infoFrameTransparency = binding8,
		infoFrameAbsoluteSize = binding9
	}

	self.updateBindings = {
		thumbnailTransparency = v12,
		iconTransparency = v13,
		iconSize = v14,
		placeTextTransparency = v15,
		placeTextSize = v16,
		creatorTextTransparency = v17,
		creatorTextSize = v18,
		infoFrameTransparency = v19,
		updateInfoFrameAbsoluteSize = v20
	}

	function self.renderBackgroundSteppedCallback(p2)
		local absoluteSize = self.state.absoluteSize
		local v21 = absoluteSize.x * 1.5
		local v22 = v21 / vector2.x * vector2.y

		if v22 < absoluteSize.y then
			v21 = absoluteSize.y / vector2.y * vector2.x
			v22 = absoluteSize.y
		end

		local v23 = v21 / absoluteSize.x / 2

		local v24 = math.max(v23, 1 - v23)

		local v25 = math.min(v23, 1 - v23)
		local v26 = self.state.thumbnailPositionX + self.thumbnailMoveSpd * p2

		if v24 <= v26 or v26 <= v25 then
			self.thumbnailMoveSpd = -self.thumbnailMoveSpd
			v26 = math.clamp(v26, v25, v24)
		end

		self:setState({
			thumbnailPositionX = v26,
			thumbnailScaledHeight = v22,
			thumbnailScaledWidth = v21
		})
	end

	function self.renderShimmerCallback(p2)
		local v21 = self.state.shimPos + p2 * 1

		self:setState({
			shimPos = v21 > 1 and -1 or v21
		})
	end

	if GuiService:GetUiMessage() ~= "" then
		self:setState({ serverStatusText = GuiService:GetUiMessage() })
	end

	GuiService.UiMessageChanged:Connect(function(p2, p3)
		if p2 == Enum.UiMessageType.UiMessageInfo then
			self:setState({ serverStatusText = p3 })
		end
	end)
	local v21 = false
	ContextActionService:BindCoreAction("CancelGameLoad", function(p2, p3, p4)
		if p3 == Enum.UserInputState.Begin then
			v21 = true
		elseif p3 == Enum.UserInputState.End and v21 then
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
	if queueExperimentation.getIsAutoJoinNewServerEnabled() then
		return Roact.createElement(ServerStatusWithCountdown, {
			anchorPoint = Vector2.new(0.5, 1),
			isSubjectToChinaPolicies = self.props.isSubjectToChinaPolicies,
			placeId = self.props.placeId,
			position = UDim2.fromScale(0.5, 1),
			size = UDim2.fromScale(1, 0.2),
			universeId = self.props.universeId
		})
	end

	if queueExperimentation.getIsJoinNewServerButtonEnabled() then
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

function extended:renderMainWithProviders(p2)
	return Roact.createElement(foundationProvider, {
		theme = Foundation.Enums.Theme.Dark
	}, {
		Roact.createElement(localizationProvider, { localization = v5 }, self:renderMain(p2))
	})
end

function extended:render()
	return withStyle(function(p2)
		return self.state.visible
			and Roact.createElement("Folder", {}, {
				BackgroundScreen = self:renderBackground(p2),
				MainScreen = self:renderMainWithProviders(p2)
			})
	end)
end

function extended.willUpdate(p2, p3, p4) end

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
			self:playAnimation(v11.FadeOut, {}, function()
				if fFlagLoadingScreenControlMilestones and self.props.milestones then
					self.props.milestones.record(Constants.Milestone.ScreenHidden)
				end

				self:setState({ visible = false })
			end)
		end)
	end
end

function extended:didUpdate(p2, p3)
	self:maybeStartFadeOut()
end

function extended:didMount()
	if fFlagLoadingScreenControlMilestones and self.props.milestones then
		self.props.milestones.record(Constants.Milestone.ScreenVisible)
	end

	if self.props.manageRobloxGuiFocus then
		RunService:SetRobloxGuiFocused(true)
	end

	self:playAnimation(v11.FadeIn, {}, function()
		self.fadeinComplete = true
	end)

	self:maybeStartFadeOut()
end

function extended.willUnmount(p2)
	if fFlagLoadingScreenControlMilestones and p2.props.milestones then
		p2.props.milestones.abort(Constants.AbortReason.Unmounted)
	end

	ContextActionService:UnbindCoreAction("CancelGameLoad")

	if p2.props.manageRobloxGuiFocus then
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
