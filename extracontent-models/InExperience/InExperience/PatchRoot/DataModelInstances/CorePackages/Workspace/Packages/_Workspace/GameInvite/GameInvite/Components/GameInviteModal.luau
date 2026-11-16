local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local GameInvite = script:FindFirstAncestor("GameInvite")
local Components = GameInvite.Components
local Context = GameInvite.Context
local Actions = GameInvite.State.Actions
local parent = GameInvite.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ReactRoblox = require(parent.ReactRoblox)
local Promise = require(parent.Promise)
local GameDetailRodux = require(parent.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
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

local VrCompatibility = require(parent.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local networkImpl = GameInviteDependencies.networkImpl

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if FFlagUseSignalsForGameInvitesStatus then
	local NotificationsCommon = require(parent.NotificationsCommon)
	getGameInvitesStatusStore = NotificationsCommon.GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

local GetFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix
local Responsive, useStyleSheet, uiManager, panelType

if isInExperienceUIVREnabled then
	Responsive = require(parent.Responsive)

	if FFlagEnableInExperienceUIPCVRFix then
		local Foundation = require(parent.Foundation)
		useStyleSheet = Foundation.Hooks.useStyleSheet
	else
		useStyleSheet = nil
	end

	local VrSpatialUi = require(parent.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
	panelType = VrSpatialUi.Constants.PanelType
else
	Responsive = nil
	useStyleSheet = nil
	uiManager = nil
	panelType = nil
end

local customEventHandlers = {}
customEventHandlers[FocusNavigationEventNameEnum.NavigateBack] = {
	handler = InputHandlers.onRelease(function(object)
		GameInviteModalManager:closeModal()
		object:cancel()
	end)
}

return function(p)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState({})
	local state5, setState5 = React.useState("")

	local v = not RunService:IsStudio()
	local isCoreScript = p.renderLocation == GameInviteConstants.RenderLocation.CoreScripts
	local disableSelectionParentManagement = p.renderLocation == GameInviteConstants.RenderLocation.UniversalApp
	local v2 = useDispatch()
	local v3, styleSheet

	if isInExperienceUIVREnabled then
		v3 = Responsive.useIsSpatial()

		if FFlagEnableInExperienceUIPCVRFix then
			styleSheet = useStyleSheet()
		end
	end

	local function onEvent(p2, p3, p4)
		setState(p2)
		setState2(p3 or false)

		if p4 then
			setState3(p4)
		end

		if FFlagUseSignalsForGameInvitesStatus then
			if disableSelectionParentManagement and not p2 then
				getGameInvitesStatusStore(false).reset()
			end
		elseif disableSelectionParentManagement and not p2 and v2 then
			v2(ResetUserInviteStatus())
		end
	end
	React.useEffect(function()
		local eventConnection = GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(onEvent)
		return function()
			eventConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if not isCoreScript then
			return function() end
		end

		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			if state then
				GameInviteModalManager:closeModal()
			end
		end)
		return function()
			menuOpenedConnection:Disconnect()
		end
	end, { state, isCoreScript })

	React.useEffect(function()
		if v and state and isCoreScript then
			if state5 == "" then
				Promise.try(function()
					return RobloxReplicatedStorage:WaitForChild("GetServerType", 2):InvokeServer()
				end):andThen(function(p2)
					setState5(p2)
				end)
			end

			if GetGameNameAndDescription and not state4.Created then
				GetGameNameAndDescription(networkImpl, game.GameId):andThen(function(p2)
					setState4(p2)
				end)
			end
		end
	end, { state })

	if not state then
		return nil
	end

	local modalWindowContainer = React.createElement(GameInviteModalWindow, {}, {
		GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
			options = state3,
			serverType = state5,
			gameDetails = state4,
			isLoading = state2,
			isCoreScript = isCoreScript,
			disableSelectionParentManagement = disableSelectionParentManagement,
			hideCloseButton = state3.hideCloseButton
		})
	})

	if GetFFlagEnableGameInviteModalVRSupport() and disableSelectionParentManagement then
		local createElement = React.createElement
		local v4 = {
			component = "ScreenGui",
			props = {
				DisplayOrder = p.displayOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true,
				Name = GameInviteConstants.ParentComponentName
			},
			vrProps = {
				partSize = VRConstants.MainScreenSize,
				offset = CFrame.new(VRConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = VRConstants.MainScreenResolution,
				panelName = "GameInviteMenu",
				curvature = VRConstants.MainScreenCurvature
			}
		}

		local createElement2 = React.createElement

		if disableSelectionParentManagement then
			modalWindowContainer = React.createElement(FocusNavigableSurfaceWrapper, {
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				isFocusable = true,
				customEventHandlers = customEventHandlers
			}, { ModalWindowContainer = modalWindowContainer })
		end

		return createElement(VRReadyWrapper, v4, {
			GameInviteModalLayoutProvider = createElement2(
				GameInviteModalLayoutProvider,
				{ isCoreScript = isCoreScript },
				{ ModalWindowContainer = modalWindowContainer }
			)
		})
	elseif isInExperienceUIVREnabled and v3 then
		local panelObject = uiManager.getInstance():getPanelObject(panelType.MoreMenu)
		local screenSizeOverride

		if FFlagEnableInExperienceUIPCVRFix then
			screenSizeOverride = uiManager.getInstance():getPanelSizeInPixel(panelType.MoreMenu)
		end

		local createPortal = ReactRoblox.createPortal
		local foundationStyleLink

		if FFlagEnableInExperienceUIPCVRFix then
			foundationStyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet })
		end

		local createElement = React.createElement
		local v4 = { isCoreScript = isCoreScript, screenSizeOverride = nil }

		if not FFlagEnableInExperienceUIPCVRFix then
			screenSizeOverride = nil
		end

		v4.screenSizeOverride = screenSizeOverride
		return createPortal({
			FoundationStyleLink = foundationStyleLink,
			GameInviteModalLayoutProvider = createElement(GameInviteModalLayoutProvider, v4, {
				ModalWindowContainer = React.createElement(GameInviteModalWindow, {}, {
					GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
						options = state3,
						serverType = state5,
						gameDetails = state4,
						isLoading = state2,
						isCoreScript = isCoreScript
					})
				})
			})
		}, panelObject)
	else
		local createElement = React.createElement
		local v4 = {
			DisplayOrder = p.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true,
			Name = GameInviteConstants.ParentComponentName
		}

		local createElement2 = React.createElement

		if disableSelectionParentManagement then
			modalWindowContainer = React.createElement(FocusNavigableSurfaceWrapper, {
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isFocusable = true,
				isIsolated = true,
				customEventHandlers = customEventHandlers
			}, { ModalWindowContainer = modalWindowContainer })
		end

		return createElement("ScreenGui", v4, {
			GameInviteModalLayoutProvider = createElement2(
				GameInviteModalLayoutProvider,
				{ isCoreScript = isCoreScript },
				{ ModalWindowContainer = modalWindowContainer }
			)
		})
	end
end
