local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Roact = require(scriptParentParent.Roact)
local FadeController = require(scriptParent.FadeController)
local AdLabel = require(scriptParent.AdLabel)
local CircularButton = require(scriptParent.CircularButton)
local LivePreviewWatermark = require(scriptParent.LivePreviewWatermark)
local Flags = require(script.Parent.Flags)
local SharedFlags = require(scriptParentParent.SharedFlags)
local UIBlox = require(scriptParentParent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Images = UIBlox.App.ImageSet.Images
local v14 = Images["icons/controls/speakerMute"]
local v15 = Images["icons/controls/speaker"]
local v16 = Images["icons/actions/previewExpand"]
local v17 = Images["icons/actions/previewShrink"]
local v18 = Images["icons/controls/media-play-large"]
local v19 = Images["icons/controls/media-pause-large"]
local v20 = Images["icons/navigation/close"]
local v21 = Images["component_assets/circle_42_stroke_3"]
local v22 = Flags.GetFFlagEnableReportAdDropdown()
local v23 = Flags.GetEnableHideReportAdModalDuringScreenshot()
local FFlagInExperienceUseAppStyleProvider = SharedFlags.FFlagInExperienceUseAppStyleProvider
local v25 = if not v22 then nil else require(scriptParent.ReportAdPopup)
local v26 = if not v22 then nil else require(scriptParent.AdDropdownMenu)
local AdsInteractivityTelemetry = require(scriptParent.AdsInteractivityTelemetry)
local v28 = Roact.PureComponent:extend("AdsInteractivityControls")

local function opacityToTransparency(p1) -- line: 39
	return 1 - p1
end

local v30 = Flags.GetAdGuiInteractivityPixelsPerStud()

local function getAdornee(p2) -- line: 46
	if p2 == nil then
		return nil
	end

	if p2.Adornee ~= nil then
		return p2.Adornee
	end

	if p2.Parent ~= nil and p2.Parent:IsA("BasePart") then
		return p2.Parent
	end

	return nil
end

function v28.init(p3) -- line: 61
	-- upvalues: FadeController (copy), Roact (copy)
	if game:GetEngineFeature("DeprecateCpv15") then
		p3.state = {
			isViewable = false,
			videoPlaying = false,
			isFullscreen = false,
			eudsaPromptActive = false,
			isDropDownOpen = false,
			isReportAdPopupOpen = false,
			hideLivePreviewWatermark = false,
			adUIType = Enum.AdUIType.None,
			adGuiRectStuds = Vector2.new(0, 0)
		}
	else
		p3.state = {
			isViewable = false,
			videoPlaying = false,
			isFullscreen = false,
			isClickToPlay = false,
			eudsaPromptActive = false,
			isDropDownOpen = false,
			isReportAdPopupOpen = false,
			hideLivePreviewWatermark = false,
			adUIType = Enum.AdUIType.None,
			adGuiRectStuds = Vector2.new(0, 0)
		}
	end

	local function onAdorneeChanged() -- line: 89
		-- upvalues: p3 (copy)
		local v58 = p3
		local t1 = {}
		local adGui = p3.props.adGui

		t1.adornee = if adGui ~= nil then if adGui.Adornee == nil then if adGui.Parent == nil or not adGui.Parent:IsA("BasePart") then nil else adGui.Parent else adGui.Adornee else nil
		v58:setState(t1)
	end

	p3.signalConnections = {
		p3.props.adGui:GetPropertyChangedSignal("Adornee"):Connect(onAdorneeChanged),
		p3.props.adGui:GetPropertyChangedSignal("Parent"):Connect(onAdorneeChanged)
	}
	p3.props.adGui.adGuiStateChanged:Connect(function(p4) -- line: 100
		-- upvalues: p3 (copy)
		p3:setState(p4)
	end)
	p3.fadeController = FadeController.new()

	local v37, v38 = Roact.createBinding(1)

	p3.controlsOpacity = v37
	p3.updateControlsOpacity = v38
	p3.fadeController:subscribe(function(p5) -- line: 107
		-- upvalues: p3 (copy)
		p3.updateControlsOpacity(p5)
	end)
	p3.props.adGui:forwardStateToLuaUI()
end
function v28.willUnmount(p6) -- line: 114
	for _, v in ipairs(p6.signalConnections) do
		v:Disconnect()
	end
end
function v28.render(p7) -- line: 120
	-- upvalues: v19 (copy), v18 (copy), v15 (copy), v14 (copy), v17 (copy), v16 (copy), Roact (copy), v22 (copy), v30 (copy), AdsInteractivityTelemetry (copy), v25 (copy), v23 (copy), v26 (copy), AdLabel (copy), CircularButton (copy), v20 (copy), ImageSetLabel (copy), v21 (copy), LivePreviewWatermark (copy)
	if not p7.props.adGui then
		return nil
	end

	local v43 = p7.state.adUIType == Enum.AdUIType.Video
	local v44 = p7.state.adUIType == Enum.AdUIType.None
	local u45 = nil

	if game:GetEngineFeature("DeprecateCpv15") then
		if v43 and p7.state.isFullscreen then
			u45 = if not p7.state.videoPlaying then v18 else v19
		end
	elseif v43 then
		if p7.state.isFullscreen and not p7.state.videoPlaying or p7.state.isClickToPlay and not p7.state.isFullscreen then
			u45 = v18
		elseif p7.state.isFullscreen and p7.state.videoPlaying then
			u45 = v19
		end
	end

	local v46 = v43 and p7.state.isFullscreen
	local v47 = if not game:GetEngineFeature("DeprecateCpv15") then v43 and (not p7.state.isFullscreen and (not p7.state.isClickToPlay and p7.state.videoPlaying)) else v43 and (not p7.state.isFullscreen and p7.state.videoPlaying)
	local v48 = p7.state.volumeEnabled and v15 or v14
	local v49 = p7.state.isFullscreen and v17 or v16
	local vector2 = Vector2.new(0.10038949275, 0.17847020934)

	if not p7.state.isFullscreen then
		vector2 *= 1.5
	end

	local v51 = p7.controlsOpacity:map(function(n1: number) -- line: 166
		-- upvalues: u45 (ref), v18 (copy)
		if u45 == v18 then
			return true
		end

		return u45 ~= nil and (n1 and n1 > 0)
	end)

	if not p7.state.isViewable then
		v51 = false
	end

	local v52 = p7.controlsOpacity:map(function(n2: number) -- line: 177
		-- upvalues: u45 (ref), v18 (copy)
		if u45 == v18 then
			return 0.19999999999999996
		end

		return 1 - n2 * 0.8
	end)
	local createElement = Roact.createElement
	local t2 = {
		ZOffset = 1,
		LightInfluence = 0,
		Brightness = 2,
		ZIndexBehavior = if not v22 then Enum.ZIndexBehavior.Global else Enum.ZIndexBehavior.Sibling,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = v30
	}
	local adGui = p7.props.adGui

	t2.Adornee = if adGui ~= nil then if adGui.Adornee == nil then if adGui.Parent == nil or not adGui.Parent:IsA("BasePart") then nil else adGui.Parent else adGui.Adornee else nil
	t2.Face = p7.props.adGui.Face
	t2.AlwaysOnTop = p7.state.isFullscreen

	return createElement("SurfaceGui", t2, {
		InteractiveArea = Roact.createElement("TextButton", {
			Size = UDim2.fromOffset(p7.state.adGuiRectStuds.X * v30, p7.state.adGuiRectStuds.Y * v30),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = p7.controlsOpacity:map(function(n3: number) -- line: 204
				-- upvalues: u45 (ref), v18 (copy)
				if u45 == v18 then
					return 0.7
				end

				return 1 - n3 * 0.3
			end),
			Text = "",
			[Roact.Event.MouseMoved] = function(_, _) -- line: 213
				-- upvalues: v43 (copy), p7 (copy)
				if v43 and p7.state.isFullscreen then
					p7.fadeController:updateLastInputTime()
				end
			end,
			[Roact.Event.Activated] = function(_, p11) -- line: 218
				-- upvalues: v22 (copy), p7 (copy), AdsInteractivityTelemetry (copy), v43 (copy)
				if v22 and p7.state.isDropDownOpen then
					p7:setState({
						isDropDownOpen = false
					})
					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					AdsInteractivityTelemetry.logAdMenuEvent("close")

					return
				end

				if v43 then
					if not p7.state.isFullscreen then
						if p7.state.isViewable then
							p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.FullscreenButtonClicked)

							return
						end
					else
						if p7.state.videoPlaying then
							if p11.UserInputType == Enum.UserInputType.Touch then
								if p7.fadeController:inProgress() and not p7.fadeController:isFading() then
									p7.fadeController:skipToFade()

									return
								end

								p7.fadeController:updateLastInputTime()

								return
							end

							p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)

							return
						end

						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					end
				end
			end
		}, {
			AbuseReportingModal = v22 and (not not v25 and (not not p7.state.isReportAdPopupOpen and Roact.createElement(v25, {
				showReportAdPopup = p7.state.isReportAdPopupOpen,
				onClose = function() -- line: 256
					-- upvalues: p7 (copy)
					p7:setState({
						isReportAdPopupOpen = false
					})
				end,
				onOpen = if not v23 then nil else function() -- line: 262
					-- upvalues: p7 (copy), AdsInteractivityTelemetry (copy)
					p7:setState({
						isReportAdPopupOpen = true
					})
					AdsInteractivityTelemetry.logReportAdEvent("open")
				end,
				adInfo = p7.props.adGui:GetSingleReportAdInfo()
			}))) or nil,
			AdDropdownMenu = if not v22 or not v26 then nil else Roact.createElement(v26, {
				showDropDownMenu = p7.state.isDropDownOpen,
				onWhyThisAdActivated = function() -- line: 276
					-- upvalues: p7 (copy), AdsInteractivityTelemetry (copy)
					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.WhyThisAdClicked)
					AdsInteractivityTelemetry.logWhyThisAdEvent()
				end,
				onReportAdActivated = function() -- line: 281
					-- upvalues: p7 (copy)
					p7:setState({
						isReportAdPopupOpen = true
					})
				end,
				transparency = 0.19999999999999996
			}),
			AdLabel = Roact.createElement(AdLabel, {
				onActivated = not v22 and function() -- line: 305
					-- upvalues: p7 (copy)
					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.AdLabelClicked)
				end or function() -- line: 291
					-- upvalues: p7 (copy), AdsInteractivityTelemetry (copy)
					p7:setState({
						isDropDownOpen = not p7.state.isDropDownOpen
					})

					if p7.state.isDropDownOpen then
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
					else
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseEventTriggered)
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)
					end

					AdsInteractivityTelemetry.logAdMenuEvent(not p7.state.isDropDownOpen and "close" or "open")
				end,
				isMenuOpen = p7.state.isDropDownOpen,
				Visible = not v44
			}),
			CloseButton = Roact.createElement(CircularButton, {
				HorizontalScale = 0.06884057971,
				Position = UDim2.fromScale(0.995, 0.005),
				AnchorPoint = Vector2.new(1, 0),
				ImageSize = UDim2.fromScale(0.8, 0.8),
				Image = v20,
				Visible = v46,
				Transparency = v52,
				AutoButtonColor = not v22 or not p7.state.isDropDownOpen,
				onActivated = function() -- line: 320
					-- upvalues: v22 (copy), p7 (copy), AdsInteractivityTelemetry (copy)
					if v22 and p7.state.isDropDownOpen then
						p7:setState({
							isDropDownOpen = false
						})
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
						AdsInteractivityTelemetry.logAdMenuEvent("close")

						return
					end

					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.CloseButtonClicked)
				end
			}),
			PlayPauseButton = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(vector2.X, vector2.Y),
				Visible = v51,
				AutoButtonColor = not v22 or not p7.state.isDropDownOpen,
				[Roact.Event.Activated] = function() -- line: 341
					-- upvalues: v22 (copy), p7 (copy), AdsInteractivityTelemetry (copy), u45 (ref), v18 (copy), v19 (copy)
					if v22 and p7.state.isDropDownOpen then
						p7:setState({
							isDropDownOpen = false
						})
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)
						AdsInteractivityTelemetry.logAdMenuEvent("close")

						return
					end

					if u45 == v18 then
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayButtonClicked)

						return
					end

					if u45 == v19 then
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PauseButtonClicked)
					end
				end
			}, {
				circle = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v21,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageTransparency = v52
				}),
				icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = u45,
					Size = UDim2.fromScale(0.6, 0.6),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageTransparency = v52
				})
			}),
			VolumeButton = Roact.createElement(CircularButton, {
				HorizontalScale = 0.12,
				Visible = v47,
				Position = UDim2.fromScale(0.075, 0.75),
				Image = v48,
				ImageSize = UDim2.fromScale(0.8, 0.8),
				AutoButtonColor = not v22 or not p7.state.isDropDownOpen,
				onActivated = function() -- line: 383
					-- upvalues: v22 (copy), p7 (copy), AdsInteractivityTelemetry (copy)
					if v22 and p7.state.isDropDownOpen then
						p7:setState({
							isDropDownOpen = false
						})
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						AdsInteractivityTelemetry.logAdMenuEvent("close")

						return
					end

					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.VolumeButtonClicked)
				end,
				Transparency = 0.19999999999999996
			}),
			FullscreenButton = Roact.createElement(CircularButton, {
				HorizontalScale = 0.12,
				Visible = v47,
				Position = UDim2.fromScale(0.87625, 0.75),
				AnchorPoint = Vector2.new(1, 0),
				Image = v49,
				ImageSize = UDim2.fromScale(0.7, 0.7),
				AutoButtonColor = not v22 or not p7.state.isDropDownOpen,
				onActivated = function() -- line: 405
					-- upvalues: v22 (copy), p7 (copy), AdsInteractivityTelemetry (copy)
					if v22 and p7.state.isDropDownOpen then
						p7:setState({
							isDropDownOpen = false
						})
						p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.PlayEventTriggered)
						AdsInteractivityTelemetry.logAdMenuEvent("close")

						return
					end

					p7.props.adGui:HandleLuaUIEvent(Enum.AdUIEventType.FullscreenButtonClicked)
				end,
				Transparency = 0.19999999999999996
			}),
			LivePreviewWatermark = Roact.createElement(LivePreviewWatermark, {
				IsVisible = not p7.state.hideLivePreviewWatermark
			} or nil) or nil
		})
	})
end

local function AdsInteractivityFunctionalWrapper(p12) -- line: 427
	-- upvalues: UIBlox (copy), Roact (copy), AppStyleProvider (copy), v28 (copy)
	local Dark = UIBlox.App.Style.Constants.ThemeName.Dark

	return Roact.createElement(AppStyleProvider, {
		style = {
			themeName = Dark
		}
	}, {
		AdsInteractivityControls = Roact.createElement(v28, p12)
	})
end

if FFlagInExperienceUseAppStyleProvider then
	return AdsInteractivityFunctionalWrapper
end

return v28
