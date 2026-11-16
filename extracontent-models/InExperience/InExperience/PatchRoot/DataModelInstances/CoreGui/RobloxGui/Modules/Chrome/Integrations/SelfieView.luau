local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local VideoCaptureService = game:GetService("VideoCaptureService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local SocialService = game:GetService("SocialService")
local StarterGui = game:GetService("StarterGui")
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local MappedSignal = ChromeUtils.MappedSignal

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local TopBar = RobloxGui.Modules.TopBar
local Constants = require(TopBar.Constants)
local v = Constants.ApplyDisplayScale(Constants.TopBarHeight)

local selfieView = Chrome.Parent.SelfieView
local GetFFlagChromeSelfViewIgnoreCoreGui = require(Chrome.Flags.GetFFlagChromeSelfViewIgnoreCoreGui)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local module = require(selfieView)
local FaceChatUtils = require(selfieView.Utils.FaceChatUtils)
local SizingUtils = require(selfieView.Utils.SizingUtils)
local SelfieViewPolicy = require(selfieView.Utils.SelfieViewPolicy)
local ChromeUtils2 = require(Chrome.ChromeShared.Service.ChromeUtils)
local AvailabilitySignalState = ChromeUtils2.AvailabilitySignalState
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome3.UnibarStyle

local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local size = SizingUtils.getSize(ViewportUtil.screenSize:get(), false)
local windowSize = WindowSizeSignal.new(size.X, size.Y)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)

local Analytics = require(RobloxGui.Modules.SelfView.Analytics)
local v2 = Analytics.new()

local SELFIE_VIEW_ID = Constants2.SELFIE_VIEW_ID

local isActivated = MappedSignal.new(Service:onIntegrationStatusChanged(), function()
	return Service:isWindowOpen(SELFIE_VIEW_ID)
end)

local connection = nil
local connection2 = nil

local v3 = Service:register({
	id = SELFIE_VIEW_ID,
	label = "CoreScripts.TopBar.SelfViewLabel",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	windowSize = windowSize,
	windowDefaultOpen = false,
	initialAvailability = AvailabilitySignalState.Unavailable,
	persistWindowState = true,
	activated = function()
		Service:toggleWindow(SELFIE_VIEW_ID)
	end,
	isActivated = isActivated,
	draggable = true,
	cachePosition = true,
	components = {
		Icon = function(_)
			local ICON_SIZE

			if FFlagTokenizeUnibarConstantsWithStyleProvider then
				ICON_SIZE = UnibarStyle.use().ICON_SIZE
			else
				ICON_SIZE = Constants2.ICON_SIZE
			end

			local createElement = React.createElement
			local v3 = {
				Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
				BackgroundTransparency = 1
			}

			local v4 = { [1] = nil, (CommonIcon("icons/controls/selfieOff", "icons/controls/selfie", isActivated)) }
			local cameraStatusDot

			if module.useCameraOn() and not Service:isWindowOpen(SELFIE_VIEW_ID) then
				cameraStatusDot = React.createElement(module.CameraStatusDot, {
					Position = UDim2.fromScale(0.8, 0.7),
					ZIndex = 2
				})
			end

			v4.CameraStatusDot = cameraStatusDot
			return createElement("Frame", v3, v4, {})
		end,
		Window = function(_)
			local dragConnection = Service:dragConnection(SELFIE_VIEW_ID)
			return React.createElement(module.Window, {
				id = SELFIE_VIEW_ID,
				windowSize = windowSize,
				isDraggedOut = dragConnection ~= nil and dragConnection.connection ~= nil
			}, {})
		end
	}
})

ViewportUtil.screenSize:connect(function(p)
	if not Service:isWindowOpen(SELFIE_VIEW_ID) then
		local size2 = SizingUtils.getSize(p, windowSize:getIsLarge())
		windowSize:requestSize(size2.X, size2.Y)
	end
end, true)

local function fn()
	local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

	if GetFFlagChromeSelfViewIgnoreCoreGui() or coreGuiEnabled then
		local permissions = FaceChatUtils.getPermissions()

		local placeCamEnabled = permissions.placeCamEnabled or permissions.placeMicEnabled
		local userCamEligible = permissions.userCamEligible or permissions.userMicEligible

		if placeCamEnabled and userCamEligible then
			v3.availability:available()
		else
			v3.availability:unavailable()
		end
	else
		if FaceChatUtils.isCameraOn() then
			FaceChatUtils.toggleVideoAnimation()
		end

		v3.availability:unavailable()
	end
end

if FFlagEnableConsoleExpControls then
	local v4 = SelfieViewPolicy.PolicyImplementation.read()
	local v5

	if v4 then
		v5 = SelfieViewPolicy.Mapper(v4).eligibleForSelfieViewFeature()
	else
		v5 = false
	end

	if not v5 then
		v3.availability:forceUnavailable()
	end
end

local function fn2() -- 1 equivalent call inferred from this helper
	local permissions = FaceChatUtils.getPermissions()
	v2:reportExperienceSettings(true, permissions.placeCamEnabled, permissions.placeMicEnabled)
	v2:reportUserAccountSettings(permissions.userCamEnabled, permissions.userMicEnabled)
end

if game:GetEngineFeature("VideoCaptureService") then
	fn()
	VideoCaptureService.Started:Connect(fn)
	VideoCaptureService.Stopped:Connect(fn)
	VideoCaptureService.DevicesChanged:Connect(fn)
	FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(fn)
	FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(fn)
	fn2() -- inferred equivalent call
end

StarterGui.CoreGuiChangedSignal:Connect(fn)

if not game:GetEngineFeature("EnableSelfViewToggleApi") then
	return v3
end

if connection then
	connection:Disconnect()
end

if connection2 then
	connection2:Disconnect()
end

SocialService.SelfViewVisible:Connect(function(p)
	local v4 = Constants.ApplyDisplayScale(Constants.ScreenSideOffset)

	if not Service:isWindowOpen(SELFIE_VIEW_ID) then
		local v5 = windowSize:get()
		local v6 = ViewportUtil.screenSize:get()
		local udim = nil

		if p == Enum.SelfViewPosition.TopLeft then
			udim = UDim2.fromOffset(v4, Constants2.WINDOW_DEFAULT_PADDING)
		elseif p == Enum.SelfViewPosition.TopRight then
			udim = UDim2.fromOffset(v6.X - (v5.X.Offset + v4), Constants2.WINDOW_DEFAULT_PADDING)
		elseif p == Enum.SelfViewPosition.BottomLeft then
			udim = UDim2.fromOffset(v4, v6.Y - (v + v5.Y.Offset + Constants2.WINDOW_DEFAULT_PADDING))
		elseif p == Enum.SelfViewPosition.BottomRight then
			udim = UDim2.fromOffset(
				v6.X - (v5.X.Offset + v4),
				v6.Y - (v + v5.Y.Offset + Constants2.WINDOW_DEFAULT_PADDING)
			)
		end

		Service:toggleWindow(SELFIE_VIEW_ID)

		if udim then
			Service:updateWindowPosition(SELFIE_VIEW_ID, udim)
		end
	end
end)
SocialService.SelfViewHidden:Connect(function()
	if Service:isWindowOpen(SELFIE_VIEW_ID) then
		Service:toggleWindow(SELFIE_VIEW_ID)
	end
end)

return v3
