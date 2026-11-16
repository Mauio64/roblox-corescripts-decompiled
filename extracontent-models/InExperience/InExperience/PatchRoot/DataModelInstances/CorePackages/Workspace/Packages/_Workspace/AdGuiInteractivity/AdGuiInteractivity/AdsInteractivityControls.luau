local parent = script.Parent
local parent2 = parent.Parent
local Roact = require(parent2.Roact)

local Foundation = require(parent2.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local FadeController = require(parent.FadeController)
local AdLabel = require(parent.AdLabel)
local CircularButton = require(parent.CircularButton)
local LivePreviewWatermark = require(parent.LivePreviewWatermark)

local Flags = require(script.Parent.Flags)
local SharedFlags = require(parent2.SharedFlags)
local UIBlox = require(parent2.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local Images = UIBlox.App.ImageSet.Images
local iconscontrolsspeakerMute = Images["icons/controls/speakerMute"]
local iconscontrolsspeaker = Images["icons/controls/speaker"]
local iconsactionspreviewExpand = Images["icons/actions/previewExpand"]
local iconsactionspreviewShrink = Images["icons/actions/previewShrink"]
local iconscontrolsmediaplaylarge = Images["icons/controls/media-play-large"]
local iconscontrolsmediapauselarge = Images["icons/controls/media-pause-large"]
local iconsnavigationclose = Images["icons/navigation/close"]
local component_assetscircle_42_stroke_3 = Images["component_assets/circle_42_stroke_3"]

local fFlagEnableReportAdDropdown = Flags.GetFFlagEnableReportAdDropdown()
local enableHideReportAdModalDuringScreenshot = Flags.GetEnableHideReportAdModalDuringScreenshot()
local FFlagFixReportAdInfoDuringRotation = Flags.FFlagFixReportAdInfoDuringRotation
local FFlagInExperienceUseAppStyleProvider = SharedFlags.FFlagInExperienceUseAppStyleProvider
local ArgCheck

if FFlagFixReportAdInfoDuringRotation then
	ArgCheck = require(parent2.ArgCheck)
else
	ArgCheck = nil
end

local ReportAdPopup

if fFlagEnableReportAdDropdown then
	ReportAdPopup = require(parent.ReportAdPopup)
else
	ReportAdPopup = nil
end

local AdDropdownMenu

if fFlagEnableReportAdDropdown then
	AdDropdownMenu = require(parent.AdDropdownMenu)
else
	AdDropdownMenu = nil
end

local AdsInteractivityTelemetry = require(parent.AdsInteractivityTelemetry)

local extended = Roact.PureComponent:extend("AdsInteractivityControls")

local function opacityToTransparency(p) -- 7 equivalent calls inferred from this helper
	return 1 - p
end

local adGuiInteractivityPixelsPerStud = Flags.GetAdGuiInteractivityPixelsPerStud()

local function getAdornee(adGui) -- 2 equivalent calls inferred from this helper
	if adGui == nil then
		return nil
	end

	if adGui.Adornee ~= nil then
		return adGui.Adornee
	end

	if adGui.Parent == nil or not adGui.Parent:IsA("BasePart") then
		return nil
	end

	return adGui.Parent
end

function extended:init()
	if game:GetEngineFeature("DeprecateCpv15") then
		self.state = {
			adUIType = Enum.AdUIType.None,
			adGuiRectStuds = Vector2.new(0, 0),
			isViewable = false,
			videoPlaying = false,
			isFullscreen = false,
			eudsaPromptActive = false,
			isDropDownOpen = false,
			isReportAdPopupOpen = false,
			hideLivePreviewWatermark = false
		}
	else
		self.state = {
			adUIType = Enum.AdUIType.None,
			adGuiRectStuds = Vector2.new(0, 0),
			isViewable = false,
			videoPlaying = false,
			isFullscreen = false,
			isClickToPlay = false,
			eudsaPromptActive = false,
			isDropDownOpen = false,
			isReportAdPopupOpen = false,
			hideLivePreviewWatermark = false
		}
	end

	local function onAdorneeChanged()
		self:setState({ adornee = getAdornee(self.props.adGui) }) -- inferred equivalent call
	end

	self.signalConnections = {
		self.props.adGui:GetPropertyChangedSignal("Adornee"):Connect(onAdorneeChanged),
		self.props.adGui:GetPropertyChangedSignal("Parent"):Connect(onAdorneeChanged)
	}

	self.props.adGui.adGuiStateChanged:Connect(function(p)
		self:setState(p)
	end)

	self.fadeController = FadeController.new()
	local binding, updateControlsOpacity = Roact.createBinding(1)
	self.controlsOpacity = binding
	self.updateControlsOpacity = updateControlsOpacity

	self.fadeController:subscribe(function(p)
		self.updateControlsOpacity(p)
	end)

	self.props.adGui:forwardStateToLuaUI()
end

function extended.willUnmount(p)
	for _, signalConnection in ipairs(p.signalConnections) do
		signalConnection:Disconnect()
	end
end

function extended.render(props)
	if not props.props.adGui then
		return nil
	end

	local v = props.state.adUIType == Enum.AdUIType.Video
	local v2 = props.state.adUIType == Enum.AdUIType.None

	local image = nil

	if game:GetEngineFeature("DeprecateCpv15") then
		if v and props.state.isFullscreen then
			if props.state.videoPlaying then
				image = iconscontrolsmediapauselarge
			else
				image = iconscontrolsmediaplaylarge
			end
		end
	elseif v then
		if
			props.state.isFullscreen and not props.state.videoPlaying
			or props.state.isClickToPlay and not props.state.isFullscreen
		then
			image = iconscontrolsmediaplaylarge
		elseif props.state.isFullscreen and props.state.videoPlaying then
			image = iconscontrolsmediapauselarge
		end
	end

	local isFullscreen = v and props.state.isFullscreen
	local videoPlaying

	if game:GetEngineFeature("DeprecateCpv15") then
		videoPlaying = v and not props.state.isFullscreen and props.state.videoPlaying
	else
		videoPlaying = v and not props.state.isFullscreen and not props.state.isClickToPlay and props.state.videoPlaying
	end

	local image2 = props.state.volumeEnabled and iconscontrolsspeaker or iconscontrolsspeakerMute
	local image3 = props.state.isFullscreen and iconsactionspreviewShrink or iconsactionspreviewExpand
	local vector2 = Vector2.new(0.10038949275, 0.17847020934)

	if not props.state.isFullscreen then
		vector2 *= 1.5
	end

	local visible = props.controlsOpacity:map(function(p: number)
		return image == iconscontrolsmediaplaylarge or image ~= nil and p and p > 0
	end)

	if not props.state.isViewable then
		visible = false
	end

	local mapped = props.controlsOpacity:map(function(p: number)
		if image == iconscontrolsmediaplaylarge then
			return opacityToTransparency(0.8) -- inferred equivalent call
		end

		return opacityToTransparency(p * 0.8) -- inferred equivalent call
	end)

	local createElement = Roact.createElement
	local zIndexBehavior

	if fFlagEnableReportAdDropdown then
		zIndexBehavior = Enum.ZIndexBehavior.Sibling
	else
		zIndexBehavior = Enum.ZIndexBehavior.Global
	end

	local v3 = {
		ZOffset = 1,
		ZIndexBehavior = zIndexBehavior,
		LightInfluence = 0,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = adGuiInteractivityPixelsPerStud,
		Adornee = getAdornee(props.props.adGui), -- inferred equivalent call
		Face = props.props.adGui.Face,
		AlwaysOnTop = props.state.isFullscreen,
		Brightness = 2
	}

	local createElement2 = Roact.createElement
	local v4 = {
		Size = UDim2.fromOffset(
			props.state.adGuiRectStuds.X * adGuiInteractivityPixelsPerStud,
			props.state.adGuiRectStuds.Y * adGuiInteractivityPixelsPerStud
		),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = props.controlsOpacity:map(function(p: number)
			if image == iconscontrolsmediaplaylarge then
				return opacityToTransparency(0.3) -- inferred equivalent call
			end

			return opacityToTransparency(p * 0.3) -- inferred equivalent call
		end),
		Text = "",
		[Roact.Event.MouseMoved] = function(_, _)
			if v and props.state.isFullscreen then
				props.fadeController:updateLastInputTime()
			end
		end,
		[Roact.Event.Activated] = function(_, p)
			if fFlagEnableReportAdDropdown and props.state.isDropDownOpen then
				props:setState({ isDropDownOpen = false })

				props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)

				props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
				AdsInteractivityTelemetry.logAdMenuEvent("close")
			elseif v then
				if props.state.isFullscreen then
					if props.state.videoPlaying then
						if p.UserInputType ~= Enum.UserInputType.Touch then
							props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)
						elseif props.fadeController:inProgress() and not props.fadeController:isFading() then
							props.fadeController:skipToFade()
						else
							props.fadeController:updateLastInputTime()
						end
					else
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					end
				elseif props.state.isViewable then
					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.FullscreenButtonClicked)
				end
			end
		end
	}
	local abuseReportingModal

	if fFlagEnableReportAdDropdown and ReportAdPopup and props.state.isReportAdPopupOpen then
		local createElement3 = Roact.createElement
		local v5 = {
			showReportAdPopup = props.state.isReportAdPopupOpen,
			onClose = function()
				props:setState({ isReportAdPopupOpen = false })
			end,
			onOpen = enableHideReportAdModalDuringScreenshot and function()
				props:setState({ isReportAdPopupOpen = true })

				AdsInteractivityTelemetry.logReportAdEvent("open")
			end or nil,
			adInfo = 0
		}
		local adInfo

		if FFlagFixReportAdInfoDuringRotation then
			adInfo = ArgCheck.isNotNil(props.state.reportAdInfo, "reportAdInfo")
				or props.props.adGui:GetSingleReportAdInfo()
		else
			adInfo = props.props.adGui:GetSingleReportAdInfo()
		end

		v5.adInfo = adInfo
		abuseReportingModal = createElement3(ReportAdPopup, v5) or nil
	end

	local adDropdownMenu

	if fFlagEnableReportAdDropdown and AdDropdownMenu then
		adDropdownMenu = Roact.createElement(AdDropdownMenu, {
			showDropDownMenu = props.state.isDropDownOpen,
			onWhyThisAdActivated = function()
				props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.WhyThisAdClicked)
				AdsInteractivityTelemetry.logWhyThisAdEvent()
			end,
			onReportAdActivated = function()
				props:setState({ isReportAdPopupOpen = true })
			end,
			transparency = opacityToTransparency(0.8) -- inferred equivalent call
		})
	end

	return createElement("SurfaceGui", v3, {
		InteractiveArea = createElement2("TextButton", v4, {
			AbuseReportingModal = abuseReportingModal,
			AdDropdownMenu = adDropdownMenu,
			AdLabel = Roact.createElement(AdLabel, {
				onActivated = fFlagEnableReportAdDropdown and function()
					if FFlagFixReportAdInfoDuringRotation then
						local v5 = {
							isDropDownOpen = not props.state.isDropDownOpen
						}

						if not props.state.isDropDownOpen then
							v5.reportAdInfo = props.props.adGui:GetSingleReportAdInfo()
						end

						props:setState(v5)
					else
						props:setState({
							isDropDownOpen = not props.state.isDropDownOpen
						})
					end

					if props.state.isDropDownOpen then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					else
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseEventTriggered)
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)
					end

					AdsInteractivityTelemetry.logAdMenuEvent(props.state.isDropDownOpen and "open" or "close")
				end or function()
					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.AdLabelClicked)
				end,
				isMenuOpen = props.state.isDropDownOpen,
				Visible = not v2
			}),
			CloseButton = Roact.createElement(CircularButton, {
				HorizontalScale = 0.06884057971,
				Position = UDim2.fromScale(0.995, 0.005),
				AnchorPoint = Vector2.new(1, 0),
				ImageSize = UDim2.fromScale(0.8, 0.8),
				Image = iconsnavigationclose,
				Visible = isFullscreen,
				Transparency = mapped,
				AutoButtonColor = not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen),
				onActivated = function()
					if not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen) then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.CloseButtonClicked)
						return
					end

					props:setState({ isDropDownOpen = false })

					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					AdsInteractivityTelemetry.logAdMenuEvent("close")
				end
			}),
			PlayPauseButton = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(vector2.X, vector2.Y),
				Visible = visible,
				AutoButtonColor = not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen),
				[Roact.Event.Activated] = function()
					if fFlagEnableReportAdDropdown and props.state.isDropDownOpen then
						props:setState({ isDropDownOpen = false })

						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
						AdsInteractivityTelemetry.logAdMenuEvent("close")
					elseif image == iconscontrolsmediaplaylarge then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					elseif image == iconscontrolsmediapauselarge then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)
					end
				end
			}, {
				circle = Roact.createElement(ImageSetLabel, {
					Image = component_assetscircle_42_stroke_3,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageTransparency = mapped
				}),
				icon = Roact.createElement(ImageSetLabel, {
					Image = image,
					Size = UDim2.fromScale(0.6, 0.6),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageTransparency = mapped
				})
			}),
			VolumeButton = Roact.createElement(CircularButton, {
				Visible = videoPlaying,
				Position = UDim2.fromScale(0.075, 0.75),
				HorizontalScale = 0.12,
				Image = image2,
				ImageSize = UDim2.fromScale(0.8, 0.8),
				AutoButtonColor = not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen),
				onActivated = function()
					if not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen) then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.VolumeButtonClicked)
						return
					end

					props:setState({ isDropDownOpen = false })

					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
					AdsInteractivityTelemetry.logAdMenuEvent("close")
				end,
				Transparency = opacityToTransparency(0.8) -- inferred equivalent call
			}),
			FullscreenButton = Roact.createElement(CircularButton, {
				Visible = videoPlaying,
				Position = UDim2.fromScale(0.87625, 0.75),
				AnchorPoint = Vector2.new(1, 0),
				HorizontalScale = 0.12,
				Image = image3,
				ImageSize = UDim2.fromScale(0.7, 0.7),
				AutoButtonColor = not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen),
				onActivated = function()
					if not (fFlagEnableReportAdDropdown and props.state.isDropDownOpen) then
						props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.FullscreenButtonClicked)
						return
					end

					props:setState({ isDropDownOpen = false })

					props.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
					AdsInteractivityTelemetry.logAdMenuEvent("close")
				end,
				Transparency = opacityToTransparency(0.8) -- inferred equivalent call
			}),
			LivePreviewWatermark = Roact.createElement(LivePreviewWatermark, {
				IsVisible = not props.state.hideLivePreviewWatermark
			} or nil) or nil
		})
	})
end

local function AdsInteractivityFunctionalWrapper(p)
	return Roact.createElement(AppStyleProvider, {
		style = { themeName = ColorMode.Dark }
	}, {
		AdsInteractivityControls = Roact.createElement(extended, p)
	})
end

if FFlagInExperienceUseAppStyleProvider then
	return AdsInteractivityFunctionalWrapper
end

return extended
