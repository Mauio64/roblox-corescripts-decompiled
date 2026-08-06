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
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local v35 = if not FFlagUseSignalsForGameInvitesStatus then nil else require(GameInviteParent.NotificationsCommon).GetGameInvitesStatusStore
local GetFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local isInExperienceUIVREnabled = require(GameInviteParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix
local Responsive = nil
local UIManager = nil
local PanelType = nil
local u44 = nil

if isInExperienceUIVREnabled then
	Responsive = require(GameInviteParent.Responsive)
	u44 = if not FFlagEnableInExperienceUIPCVRFix then nil else require(GameInviteParent.Foundation).Hooks.useStyleSheet

	local VrSpatialUi = require(GameInviteParent.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	PanelType = VrSpatialUi.Constants.PanelType
end

local t1 = {
	[FocusNavigationEventNameEnum.NavigateBack] = {
		handler = InputHandlers.onRelease(function(p1) -- line: 71
			-- upvalues: GameInviteModalManager (copy)
			GameInviteModalManager:closeModal()
			p1:cancel()
		end)
	}
}

return function(t2: {[any]: any}) -- line: 82
	-- upvalues: FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), React (copy), RunService (copy), GameInviteConstants (copy), useDispatch (copy), isInExperienceUIVREnabled (copy), Responsive (ref), FFlagEnableInExperienceUIPCVRFix (copy), u44 (ref), FFlagUseSignalsForGameInvitesStatus (copy), v35 (copy), ResetUserInviteStatus (copy), GameInviteModalManager (copy), GuiService (copy), Promise (copy), RobloxReplicatedStorage (copy), GetGameNameAndDescription (copy), networkImpl (copy), GameInviteModalWindow (copy), GameInviteContentWrapper (copy), GetFFlagEnableGameInviteModalVRSupport (copy), VRReadyWrapper (copy), VRConstants (copy), GameInviteModalLayoutProvider (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), t1 (copy), UIManager (ref), PanelType (ref), ReactRoblox (copy)
	if not game:GetFastFlag("LuaEnableGameInviteModal2023V5") then
		return nil
	end

	local v49 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelWidthMultiplier)
	local v50 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelCurvature)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState(false)
	local v55, v56 = React.useState({})
	local v57, v58 = React.useState({})
	local v59, v60 = React.useState("")
	local v61 = not RunService:IsStudio()
	local v62 = t2.renderLocation == GameInviteConstants.RenderLocation.CoreScripts
	local v63 = t2.renderLocation == GameInviteConstants.RenderLocation.UniversalApp
	local v64 = useDispatch()
	local v65 = nil
	local v66 = nil

	if isInExperienceUIVREnabled then
		v65 = Responsive.useIsSpatial()
		v66 = if not FFlagEnableInExperienceUIPCVRFix then nil else u44()
	end

	local function v67(p2, p3, p4) -- line: 117
		-- upvalues: v52 (copy), v54 (copy), v56 (copy), FFlagUseSignalsForGameInvitesStatus (copy), v63 (copy), v35 (copy), v64 (copy), ResetUserInviteStatus (copy)
		v52(p2)
		v54(p3 or false)

		if p4 then
			v56(p4)
		end

		if FFlagUseSignalsForGameInvitesStatus then
			if v63 and not p2 then
				v35(false).reset()

				return
			end
		elseif v63 and not p2 and v64 then
			v64(ResetUserInviteStatus())
		end
	end

	React.useEffect(function() -- line: 134
		-- upvalues: GameInviteModalManager (copy), v67 (copy)
		local connection = GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(v67)

		return function() -- line: 136
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 142
		-- upvalues: v62 (copy), GuiService (copy), v51 (copy), GameInviteModalManager (copy)
		if v62 then
			local connection = GuiService.MenuOpened:Connect(function() -- line: 144
				-- upvalues: v51 (copy), GameInviteModalManager (copy)
				if v51 then
					GameInviteModalManager:closeModal()
				end
			end)

			return function() -- line: 149
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 153
		end
	end, {
		v51,
		v62
	})
	React.useEffect(function() -- line: 158
		-- upvalues: v61 (copy), v51 (copy), v62 (copy), v59 (copy), Promise (copy), RobloxReplicatedStorage (copy), v60 (copy), GetGameNameAndDescription (copy), v57 (copy), networkImpl (copy), v58 (copy)
		if v61 and (v51 and v62) then
			if v59 == "" then
				Promise.try(function() -- line: 162
					-- upvalues: RobloxReplicatedStorage (copy)
					return RobloxReplicatedStorage:WaitForChild("GetServerType", 2):InvokeServer()
				end):andThen(function(p5) -- line: 165
					-- upvalues: v60 (copy)
					v60(p5)
				end)
			end

			if GetGameNameAndDescription and not v57.Created then
				GetGameNameAndDescription(networkImpl, game.GameId):andThen(function(p6) -- line: 171
					-- upvalues: v58 (copy)
					v58(p6)
				end)
			end
		end
	end, { v51 })

	if v51 then
		local v68 = React.createElement(GameInviteModalWindow, {}, {
			GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
				options = v55,
				serverType = v59,
				gameDetails = v57,
				isLoading = v53,
				isCoreScript = v62,
				disableSelectionParentManagement = v63,
				hideCloseButton = v55.hideCloseButton
			})
		})

		if GetFFlagEnableGameInviteModalVRSupport() and v63 then
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
					partSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not v49 then VRConstants.MainScreenSize else Vector2.new(VRConstants.MainScreenSize.X * v49, VRConstants.MainScreenSize.Y),
					offset = if not FFlagLuaAppForceVrAppPanelWidthRollout and (not GetFFlagVRPanelWidthIXPEnabled() or v50 ~= 0) then CFrame.lookAt(VRConstants.MainScreenPosition, VRConstants.DefaultCameraPosition) else CFrame.new(VRConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
					virtualScreenSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not v49 then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * v49, VRConstants.MainScreenResolution.Y),
					curvature = not FFlagLuaAppForceVrAppPanelWidthRollout and v50 or VRConstants.MainScreenCurvature
				}
			}, {
				GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
					isCoreScript = v62
				}, {
					ModalWindowContainer = if not v63 then v68 else React.createElement(FocusNavigableSurfaceWrapper, {
						isAutoFocusRoot = true,
						isIsolated = true,
						isFocusable = true,
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
						customEventHandlers = t1
					}, {
						ModalWindowContainer = v68
					})
				})
			})
		end

		if isInExperienceUIVREnabled and v65 then
			local v69 = UIManager.getInstance():getPanelObject(PanelType.MoreMenu)
			local v70 = if not FFlagEnableInExperienceUIPCVRFix then nil else UIManager.getInstance():getPanelSizeInPixel(PanelType.MoreMenu)

			return ReactRoblox.createPortal({
				FoundationStyleLink = if not FFlagEnableInExperienceUIPCVRFix then nil else React.createElement("StyleLink", {
					StyleSheet = v66
				}),
				GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
					isCoreScript = v62,
					screenSizeOverride = if not FFlagEnableInExperienceUIPCVRFix then nil else v70
				}, {
					ModalWindowContainer = React.createElement(GameInviteModalWindow, {}, {
						GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
							options = v55,
							serverType = v59,
							gameDetails = v57,
							isLoading = v53,
							isCoreScript = v62
						})
					})
				})
			}, v69)
		end

		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			DisplayOrder = t2.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Name = GameInviteConstants.ParentComponentName
		}, {
			GameInviteModalLayoutProvider = React.createElement(GameInviteModalLayoutProvider, {
				isCoreScript = v62
			}, {
				ModalWindowContainer = if not v63 then v68 else React.createElement(FocusNavigableSurfaceWrapper, {
					isAutoFocusRoot = true,
					isFocusable = true,
					isIsolated = true,
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
					customEventHandlers = t1
				}, {
					ModalWindowContainer = v68
				})
			})
		})
	end

	return nil
end
