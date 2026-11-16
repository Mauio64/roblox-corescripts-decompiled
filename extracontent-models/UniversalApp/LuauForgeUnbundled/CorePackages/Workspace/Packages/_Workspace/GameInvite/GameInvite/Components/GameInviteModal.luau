local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactUtils")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ReactRoblox")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Promise")
local getGameNameAndDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameDetailRodux").GetGameNameAndDescription

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")
local GameInviteModalManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteModalManager")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteModalLayoutProvider")
local GameInviteModalWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteModalWindow")
local GameInviteContentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteContentWrapper")
local GameInviteDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteDependencies")
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
local ResetUserInviteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Actions/ResetUserInviteStatus")

local VrCompatibility = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/VrCompatibility")
local vrReadyWrapper = VrCompatibility.VRReadyWrapper
local vrConstants = VrCompatibility.VRConstants

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local networkImpl = GameInviteDependencies.networkImpl

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags")
local fFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local getGameInvitesStatusStore

if fFlagUseSignalsForGameInvitesStatus then
	getGameInvitesStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").GetGameInvitesStatusStore
else
	getGameInvitesStatusStore = nil
end

local getFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedExperimentDefinition").isInExperienceUIVREnabled
local fFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix
local v5, useStyleSheet, uiManager, panelType

if isInExperienceUIVREnabled then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Responsive")

	useStyleSheet = if fFlagEnableInExperienceUIPCVRFix then require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation").Hooks.useStyleSheet else nil

	local VrSpatialUi = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/VrSpatialUi")
	uiManager = VrSpatialUi.UIManager
	panelType = VrSpatialUi.Constants.PanelType
else
	v5 = nil
	useStyleSheet = nil
	uiManager = nil
	panelType = nil
end

local v6 = {}
v6[focusNavigationEventNameEnum.NavigateBack] = {
	handler = InputHandlers.onRelease(function(object)
		GameInviteModalManager:closeModal()
		object:cancel()
	end)
}

return function(p2)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState({})
	local state5, setState5 = React.useState("")

	local v7 = not RunService:IsStudio()
	local v8 = p2.renderLocation == GameInviteConstants.RenderLocation.CoreScripts
	local v9 = p2.renderLocation == GameInviteConstants.RenderLocation.UniversalApp
	local v10 = useDispatch()
	local v11, v12

	if isInExperienceUIVREnabled then
		v11 = v5.useIsSpatial()

		if fFlagEnableInExperienceUIPCVRFix then
			v12 = useStyleSheet()
		end
	end

	local function onEvent(p3, p4, p5)
		setState(p3)
		setState2(p4 or false)

		if p5 then
			setState3(p5)
		end

		if fFlagUseSignalsForGameInvitesStatus then
			if v9 and not p3 then
				getGameInvitesStatusStore(false).reset()
			end
		elseif v9 and not p3 and v10 then
			v10(ResetUserInviteStatus())
		end
	end
	React.useEffect(function()
		local eventConnection = GameInviteModalManager.ToggleGameInviteModalEvent.Event:Connect(onEvent)
		return function()
			eventConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if not v8 then
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
	end, { state, v8 })

	React.useEffect(function()
		if v7 and state and v8 then
			if state5 == "" then
				Promise.try(function()
					return RobloxReplicatedStorage:WaitForChild("GetServerType", 2):InvokeServer()
				end):andThen(function(p3)
					setState5(p3)
				end)
			end

			if getGameNameAndDescription and not state4.Created then
				getGameNameAndDescription(networkImpl, game.GameId):andThen(function(p3)
					setState4(p3)
				end)
			end
		end
	end, { state })

	if not state then
		return nil
	end

	local v13 = React.createElement(GameInviteModalWindow, {}, {
		GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
			options = state3,
			serverType = state5,
			gameDetails = state4,
			isLoading = state2,
			isCoreScript = v8,
			disableSelectionParentManagement = v9,
			hideCloseButton = state3.hideCloseButton
		})
	})

	if getFFlagEnableGameInviteModalVRSupport() and v9 then
		local createElement = React.createElement
		local v15 = {
			component = "ScreenGui",
			props = {
				DisplayOrder = p2.displayOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true,
				Name = GameInviteConstants.ParentComponentName
			},
			vrProps = {
				partSize = vrConstants.MainScreenSize,
				offset = CFrame.new(vrConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = vrConstants.MainScreenResolution,
				panelName = "GameInviteMenu",
				curvature = vrConstants.MainScreenCurvature
			}
		}

		local createElement2 = React.createElement

		if v9 then
			v13 = React.createElement(focusNavigableSurfaceWrapper, {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				isFocusable = true,
				customEventHandlers = v6
			}, { ModalWindowContainer = v13 })
		end

		return createElement(vrReadyWrapper, v15, {
			GameInviteModalLayoutProvider = createElement2(module8, {
				isCoreScript = v8
			}, {
				ModalWindowContainer = v13
			})
		})
	elseif isInExperienceUIVREnabled and v11 then
		local panelObject = uiManager.getInstance():getPanelObject(panelType.MoreMenu)
		local v14

		if fFlagEnableInExperienceUIPCVRFix then
			v14 = uiManager.getInstance():getPanelSizeInPixel(panelType.MoreMenu)
		end

		local createPortal = ReactRoblox.createPortal

		local v16 = if fFlagEnableInExperienceUIPCVRFix then React.createElement("StyleLink", {
			StyleSheet = v12
		}) else nil

		local createElement = React.createElement
		local v18 = { isCoreScript = v8, screenSizeOverride = nil }

		if not fFlagEnableInExperienceUIPCVRFix then
			v14 = nil
		end

		v18.screenSizeOverride = v14
		return createPortal({
			FoundationStyleLink = v16,
			GameInviteModalLayoutProvider = createElement(module8, v18, {
				ModalWindowContainer = React.createElement(GameInviteModalWindow, {}, {
					GameInviteModalContentWrapper = React.createElement(GameInviteContentWrapper, {
						options = state3,
						serverType = state5,
						gameDetails = state4,
						isLoading = state2,
						isCoreScript = v8
					})
				})
			})
		}, panelObject)
	else
		local createElement = React.createElement
		local v15 = {
			DisplayOrder = p2.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true,
			Name = GameInviteConstants.ParentComponentName
		}

		local createElement2 = React.createElement

		if v9 then
			v13 = React.createElement(focusNavigableSurfaceWrapper, {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isFocusable = true,
				isIsolated = true,
				customEventHandlers = v6
			}, { ModalWindowContainer = v13 })
		end

		return createElement("ScreenGui", v15, {
			GameInviteModalLayoutProvider = createElement2(module8, {
				isCoreScript = v8
			}, {
				ModalWindowContainer = v13
			})
		})
	end
end
