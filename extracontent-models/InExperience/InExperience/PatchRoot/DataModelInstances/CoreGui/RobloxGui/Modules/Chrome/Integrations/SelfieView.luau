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
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local TopBar = RobloxGui.Modules.TopBar
local Constants = require(TopBar.Constants)
local v15 = Constants.ApplyDisplayScale(Constants.TopBarHeight)
local SelfieView = Chrome.Parent.SelfieView
local GetFFlagChromeSelfViewIgnoreCoreGui = require(Chrome.Flags.GetFFlagChromeSelfViewIgnoreCoreGui)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local lib = require(SelfieView)
local FaceChatUtils = require(SelfieView.Utils.FaceChatUtils)
local SizingUtils = require(SelfieView.Utils.SizingUtils)
local SelfieViewPolicy = require(SelfieView.Utils.SelfieViewPolicy)
local AvailabilitySignalState = require(Chrome.ChromeShared.Service.ChromeUtils).AvailabilitySignalState
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local v31 = SizingUtils.getSize(ViewportUtil.screenSize:get(), false)
local v32 = WindowSizeSignal.new(v31.X, v31.Y)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)
local v34 = require(RobloxGui.Modules.SelfView.Analytics).new()
local SELFIE_VIEW_ID = Constants2.SELFIE_VIEW_ID
local v36 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 53
	-- upvalues: Service (copy), SELFIE_VIEW_ID (copy)
	return Service:isWindowOpen(SELFIE_VIEW_ID)
end)
local v37 = nil
local v38 = nil
local v39 = Service:register({
	label = "CoreScripts.TopBar.SelfViewLabel",
	windowDefaultOpen = false,
	persistWindowState = true,
	draggable = true,
	cachePosition = true,
	id = SELFIE_VIEW_ID,
	sideSheetPlacement = SideSheetPlacement.Page,
	windowSize = v32,
	initialAvailability = AvailabilitySignalState.Unavailable,
	activated = function() -- line: 72
		-- upvalues: Service (copy), SELFIE_VIEW_ID (copy)
		Service:toggleWindow(SELFIE_VIEW_ID)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 77
		-- upvalues: v36 (copy)
		return v36:get()
	end or v36,
	components = {
		Icon = function(_) -- line: 83
			-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants2 (copy), React (copy), CommonIcon (copy), v36 (copy), lib (copy), Service (copy), SELFIE_VIEW_ID (copy)
			local v44 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants2.ICON_SIZE else UnibarStyle.use().ICON_SIZE

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v44, 0, v44)
			}, {
				CommonIcon("icons/controls/selfieOff", "icons/controls/selfie", v36),
				CameraStatusDot = if not lib.useCameraOn() or Service:isWindowOpen(SELFIE_VIEW_ID) then nil else React.createElement(lib.CameraStatusDot, {
					ZIndex = 2,
					Position = UDim2.fromScale(0.8, 0.7)
				})
			}, {})
		end,
		Window = function(_) -- line: 105
			-- upvalues: Service (copy), SELFIE_VIEW_ID (copy), React (copy), lib (copy), v32 (copy)
			local v46 = Service:dragConnection(SELFIE_VIEW_ID)

			return React.createElement(lib.Window, {
				id = SELFIE_VIEW_ID,
				windowSize = v32,
				isDraggedOut = v46 ~= nil and v46.connection ~= nil
			}, {})
		end
	}
})

ViewportUtil.screenSize:connect(function(p3) -- line: 117
	-- upvalues: Service (copy), SELFIE_VIEW_ID (copy), SizingUtils (copy), v32 (copy)
	if not Service:isWindowOpen(SELFIE_VIEW_ID) then
		local v48 = SizingUtils.getSize(p3, v32:getIsLarge())

		v32:requestSize(v48.X, v48.Y)
	end
end, true)

local function v40() -- line: 124
	-- upvalues: StarterGui (copy), GetFFlagChromeSelfViewIgnoreCoreGui (copy), FaceChatUtils (copy), v39 (copy)
	local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

	if not GetFFlagChromeSelfViewIgnoreCoreGui() and not CoreGuiEnabled then
		if FaceChatUtils.isCameraOn() then
			FaceChatUtils.toggleVideoAnimation()
		end

		v39.availability:unavailable()

		return
	end

	local v50 = FaceChatUtils.getPermissions()
	local v51 = v50.placeCamEnabled or v50.placeMicEnabled
	local v52 = v50.userCamEligible or v50.userMicEligible

	if not v51 or not v52 then
		v39.availability:unavailable()

		return
	end

	v39.availability:available()
end

if FFlagEnableConsoleExpControls then
	local v41 = SelfieViewPolicy.PolicyImplementation.read()

	if not v41 or not SelfieViewPolicy.Mapper(v41).eligibleForSelfieViewFeature() then
		v39.availability:forceUnavailable()
	end
end

if game:GetEngineFeature("VideoCaptureService") then
	v40()
	VideoCaptureService.Started:Connect(v40)
	VideoCaptureService.Stopped:Connect(v40)
	VideoCaptureService.DevicesChanged:Connect(v40)
	FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(v40)
	FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(v40)

	local v42 = FaceChatUtils.getPermissions()

	v34:reportExperienceSettings(true, v42.placeCamEnabled, v42.placeMicEnabled)
	v34:reportUserAccountSettings(v42.userCamEnabled, v42.userMicEnabled)
end

StarterGui.CoreGuiChangedSignal:Connect(v40)

if game:GetEngineFeature("EnableSelfViewToggleApi") then
	if v37 then
		v37:Disconnect()
	end

	if v38 then
		v38:Disconnect()
	end

	SocialService.SelfViewVisible:Connect(function(p4) -- line: 190
		-- upvalues: Constants (copy), Service (copy), SELFIE_VIEW_ID (copy), v32 (copy), ViewportUtil (copy), Constants2 (copy), v15 (copy)
		local v55 = Constants.ApplyDisplayScale(Constants.ScreenSideOffset)

		if not Service:isWindowOpen(SELFIE_VIEW_ID) then
			local v56 = v32:get()
			local v57 = ViewportUtil.screenSize:get()
			local uDim2 = nil

			if p4 == Enum.SelfViewPosition.TopLeft then
				uDim2 = UDim2.fromOffset(v55, Constants2.WINDOW_DEFAULT_PADDING)
			elseif p4 == Enum.SelfViewPosition.TopRight then
				uDim2 = UDim2.fromOffset(v57.X - (v56.X.Offset + v55), Constants2.WINDOW_DEFAULT_PADDING)
			elseif p4 == Enum.SelfViewPosition.BottomLeft then
				uDim2 = UDim2.fromOffset(v55, v57.Y - (v15 + v56.Y.Offset + Constants2.WINDOW_DEFAULT_PADDING))
			elseif p4 == Enum.SelfViewPosition.BottomRight then
				uDim2 = UDim2.fromOffset(v57.X - (v56.X.Offset + v55), v57.Y - (v15 + v56.Y.Offset + Constants2.WINDOW_DEFAULT_PADDING))
			end

			Service:toggleWindow(SELFIE_VIEW_ID)

			if uDim2 then
				Service:updateWindowPosition(SELFIE_VIEW_ID, uDim2)
			end
		end
	end)
	SocialService.SelfViewHidden:Connect(function() -- line: 224
		-- upvalues: Service (copy), SELFIE_VIEW_ID (copy)
		if Service:isWindowOpen(SELFIE_VIEW_ID) then
			Service:toggleWindow(SELFIE_VIEW_ID)
		end
	end)
end

return v39
