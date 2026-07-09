local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local Actions = GameInvite.State.Actions
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local RoactUtils = require(GameInviteParent.RoactUtils)
local ReactRoblox = require(GameInviteParent.ReactRoblox)
local Promise = require(GameInviteParent.Promise)
local GetGameNameAndDescription = require(GameInviteParent.GameDetailRodux).GetGameNameAndDescription
local InputHandlers = require(GameInviteParent.InputHandlers)
local FocusNavigationUtils = require(GameInviteParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(GameInvite.gameInviteModalType)

local GameInviteModalManager = require(GameInvite.GameInviteModalManager)
local GameInviteModalLayoutProvider = require(Context.GameInviteModalLayoutProvider)
local GameInviteModalWindow = require(Components.GameInviteModalWindow)
local GameInviteContentWrapper = require(Components.GameInviteContentWrapper)
local GameInviteDependencies = require(GameInvite.GameInviteDependencies)
local GameInviteConstants = require(GameInvite.GameInviteConstants)
local ResetUserInviteStatus = require(Actions.ResetUserInviteStatus)
local IxpUtils = require(GameInviteParent.IxpUtils)
local VrCompatibility = require(GameInviteParent.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local networkImpl = GameInviteDependencies.networkImpl

game:DefineFastFlag("LuaEnableGameInviteModal2023V5", false)

local SharedFlags = require(GameInviteParent.SharedFlags)
local GetFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local isInExperienceUIVREnabled = require(GameInviteParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix
local Responsive = nil
local UIManager = nil
local PanelType = nil
local u42 = nil

if isInExperienceUIVREnabled then
	Responsive = require(GameInviteParent.Responsive)
	u42 = if not FFlagEnableInExperienceUIPCVRFix then nil else require(GameInviteParent.Foundation).Hooks.useStyleSheet

	local VrSpatialUi = require(GameInviteParent.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	PanelType = VrSpatialUi.Constants.PanelType
end

local t1 = {
	[FocusNavigationEventNameEnum.NavigateBack] = {
		handler = InputHandlers.onRelease(function(p1) -- line: 67
			-- upvalues: GameInviteModalManager (copy)
			GameInviteModalManager:closeModal()
			p1:cancel()
		end)
	}
}

return function(t2: {[any]: any}) -- line: 78
	-- upvalues: FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), React (copy), RunService (copy), GameInviteConstants (copy), useDispatch (copy), isInExperienceUIVREnabled (copy), Responsive (ref), FFlagEnableInExperienceUIPCVRFix (copy), u42 (ref), ResetUserInviteStatus (copy), GameInviteModalManager (copy), GuiService (copy), Promise (copy), RobloxReplicatedStorage (copy), GetGameNameAndDescription (copy), networkImpl (copy), GameInviteModalWindow (copy), GameInviteContentWrapper (copy), GetFFlagEnableGameInviteModalVRSupport (copy), VRReadyWrapper (copy), VRConstants (copy), GameInviteModalLayoutProvider (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), t1 (copy), UIManager (ref), PanelType (ref), ReactRoblox (copy)
	if not game:GetFastFlag("LuaEnableGameInviteModal2023V5") then
		return nil
	end

	local v47 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelWidthMultiplier)
	local v48 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelCurvature)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState({})
	local v55, v56 = React.useState({})
	local v57, v58 = React.useState("")
	local v59 = not RunService:IsStudio()
	local v60 = t2.renderLocation == GameInviteConstants.RenderLocation.CoreScripts
	local v61 = t2.renderLocation == GameInviteConstants.RenderLocation.UniversalApp
	local v62 = useDispatch()
	local v63 = nil
	local v64 = nil

	if isInExperienceUIVREnabled then
		v63 = Responsive.useIsSpatial()
		v64 = if not FFlagEnableInExperienceUIPCVRFix then nil else u42()
	end

	local function v65(p2, p3, p4) -- line: 113
		-- upvalues: v50 (copy), v52 (copy), v54 (copy), v61 (copy), v62 (copy), ResetUserInviteStatus (copy)
		v50(p2)
		v52(p3 or false)

		if p4 then
			v54(p4)
		end

		if v61 and not p2 and v62 then
			v62(ResetUserInviteStatus())
		end
	end

	React.useEffect(function() -- line: 125
		-- upvalues: GameInviteModalManager (copy), v65 (copy)
		local connection = GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(v65)

		return function() -- line: 127
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 133
		-- upvalues: v60 (copy), GuiService (copy), v49 (copy), GameInviteModalManager (copy)
		if v60 then
			local connection = GuiService.MenuOpened:Connect(function() -- line: 135
				-- upvalues: v49 (copy), GameInviteModalManager (copy)
				if v49 then
					GameInviteModalManager:closeModal()
				end
			end)

			return function() -- line: 140
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 144
		end
	end, {
		v49,
		v60
	})
	React.useEffect(function() -- line: 149
		-- upvalues: v59 (copy), v49 (copy), v60 (copy), v57 (copy), Promise (copy), RobloxReplicatedStorage (copy), v58 (copy), GetGameNameAndDescription (copy), v55 (copy), networkImpl (copy), v56 (copy)
		if v59 and (v49 and v60) then
			if v57 == "" then
				Promise.try(function() -- line: 153
					-- upvalues: RobloxReplicatedStorage (copy)
					return RobloxReplicatedStorage:WaitForChild("GetServerType", 2):InvokeServer()
				end):andThen(function(p5) -- line: 156
					-- upvalues: v58 (copy)
					v58(p5)
				end)
			end

			if GetGameNameAndDescription and not v55.Created then
				GetGameNameAndDescription(networkImpl, game.GameId):andThen(function(p6) -- line: 162
					-- upvalues: v56 (copy)
					v56(p6)
				end)
			end
		end
	end, { v49 })

	if v49 then
		local v66 = React.createElement(GameInviteModalWindow, {}, {
			GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
				options = v53,
				serverType = v57,
				gameDetails = v55,
				isLoading = v51,
				isCoreScript = v60,
				disableSelectionParentManagement = v61,
				hideCloseButton = v53.hideCloseButton
			})
		})

		if GetFFlagEnableGameInviteModalVRSupport() and v61 then
			return React.createElement(VRReadyWrapper, {
				component = "ScreenGui",
				props = {
					IgnoreGuiInset = true,
					DisplayOrder = t2.displayOrder,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					Name = GameInviteConstants.ParentComponentName
				},
				vrProps = {
					panelName = "GameInviteMenu",
					partSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not v47 then VRConstants.MainScreenSize else Vector2.new(VRConstants.MainScreenSize.X * v47, VRConstants.MainScreenSize.Y),
					offset = if not FFlagLuaAppForceVrAppPanelWidthRollout and (not GetFFlagVRPanelWidthIXPEnabled() or v48 ~= 0) then CFrame.lookAt(VRConstants.MainScreenPosition, VRConstants.DefaultCameraPosition) else CFrame.new(VRConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
					virtualScreenSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not v47 then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * v47, VRConstants.MainScreenResolution.Y),
					curvature = not FFlagLuaAppForceVrAppPanelWidthRollout and v48 or VRConstants.MainScreenCurvature
				}
			}, {
				GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
					isCoreScript = v60
				}, {
					ModalWindowContainer = if not v61 then v66 else React.createElement(FocusNavigableSurfaceWrapper, {
						isAutoFocusRoot = true,
						isIsolated = true,
						isFocusable = true,
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
						customEventHandlers = t1
					}, {
						ModalWindowContainer = v66
					})
				})
			})
		end

		if isInExperienceUIVREnabled and v63 then
			local v67 = UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			local v68 = if not FFlagEnableInExperienceUIPCVRFix then nil else UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu)

			return ReactRoblox.createPortal({
				FoundationStyleLink = if not FFlagEnableInExperienceUIPCVRFix then nil else React.createElement("StyleLink", {
					StyleSheet = v64
				}),
				GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
					isCoreScript = v60,
					screenSizeOverride = if not FFlagEnableInExperienceUIPCVRFix then nil else v68
				}, {
					ModalWindowContainer = React.createElement(GameInviteModalWindow, {}, {
						GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
							options = v53,
							serverType = v57,
							gameDetails = v55,
							isLoading = v51,
							isCoreScript = v60
						})
					})
				})
			}, v67)
		end

		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			DisplayOrder = t2.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Name = GameInviteConstants.ParentComponentName
		}, {
			GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
				isCoreScript = v60
			}, {
				ModalWindowContainer = if not v61 then v66 else React.createElement(FocusNavigableSurfaceWrapper, {
					isAutoFocusRoot = true,
					isFocusable = true,
					isIsolated = true,
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
					customEventHandlers = t1
				}, {
					ModalWindowContainer = v66
				})
			})
		})
	end

	return nil
end
