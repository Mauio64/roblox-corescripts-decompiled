local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local RemoveCurrentToastMessage = require(Modules.LuaApp.Actions.RemoveCurrentToastMessage)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local Images = require(Modules.LuaApp.Components.Images)
local Images2 = UIBlox.App.ImageSet.Images
local v23 = Images["LuaApp/graphic/ic_alert"]
local v24 = Images["LuaApp/graphic/ic_logo"]
local v25 = Images2["icons/common/notificationOn"]
local v26 = Images2["icons/common/notificationOff"]
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local GetNotificationsExperienceDetailsVariant = require(CorePackages.Workspace.Packages.SharedFlags).GetNotificationsExperienceDetailsVariant
local GetFFlagNotificationsForceEnableEDPDiscoverability = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNotificationsForceEnableEDPDiscoverability
local FFlagLuaAppToastV2PerMessageDuration = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppToastV2PerMessageDuration
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v35 = if not FFlagSignalsNavP3dRouteGated then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants
local t1 = {
	frequency = 4,
	damping = 1
}
local v40 = Roact.PureComponent:extend("ToastV2")

v40.defaultProps = {
	duration = 3,
	springOptions = {
		frequency = 150,
		damping = 1
	}
}
v40.validateProps = t.strictInterface({
	duration = t.optional(t.integer),
	springOptions = t.optional(t.table),
	displayOrder = t.optional(t.integer),
	localization = t.table,
	currentToastMessage = t.optional(t.table),
	currentRoute = t.table,
	openGameDetails = t.callback,
	removeCurrentToastMessage = t.callback,
	enableNotificationsDiscoverability = t.optional(t.boolean)
})

function v40.openLuaGameDetails(p1, p2) -- line: 96
	p1.props.openGameDetails(p2)
end
function v40.init(p3) -- line: 100
	-- upvalues: ToastType (copy)
	function p3.onDismissed() -- line: 101
		-- upvalues: p3 (copy)
		p3.props.removeCurrentToastMessage()
	end
	function p3.onButtonActivated() -- line: 105
		-- upvalues: p3 (copy), ToastType (copy)
		if p3.props.currentToastMessage then
			local currentToastMessage = p3.props.currentToastMessage
			local toastType = currentToastMessage.toastType
			local universeId = currentToastMessage.universeId

			if toastType == ToastType.QuickLaunchError and universeId then
				p3:openLuaGameDetails(universeId)
			end

			p3.props.removeCurrentToastMessage()
		end
	end
end
function v40.onRender(p4) -- line: 118
	-- upvalues: GetFFlagNotificationsForceEnableEDPDiscoverability (copy), ToastType (copy), v24 (copy), v23 (copy), v25 (copy), v26 (copy), UserInputService (copy), Roact (copy), Toast (copy), FFlagLuaAppToastV2PerMessageDuration (copy), t1 (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local localization = p4.props.localization
	local v48 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or p4.props.enableNotificationsDiscoverability
	local currentToastMessage = p4.props.currentToastMessage
	local toastMessage = currentToastMessage.toastMessage
	local toastSubMessage = currentToastMessage.toastSubMessage
	local sequenceNumber = currentToastMessage.sequenceNumber
	local v53 = currentToastMessage.isLocalized or false
	local u54 = nil
	local onButtonActivated = nil
	local toastType = currentToastMessage.toastType

	if toastType == ToastType.QuickLaunchError then
		onButtonActivated = p4.onButtonActivated
	elseif toastType == ToastType.SuccessConfirmation then
		u54 = v24
	elseif toastType == ToastType.NetworkingError then
		u54 = v23
	elseif toastType == ToastType.InformationMessage then
		u54 = v24
	elseif v48 and toastType == ToastType.NotificationsTurnedOn then
		u54 = v25
	elseif v48 and toastType == ToastType.NotificationsTurnedOff then
		u54 = v26
	end

	if currentToastMessage.toastIcon then
		u54 = currentToastMessage.toastIcon
	end

	local v57 = (UserInputService.StatusBarSize and UserInputService.StatusBarSize.Y or 0) + 20
	local uDim2 = UDim2.new(0.5, 0, 0, v57)

	local function v59(p5) -- line: 157
		-- upvalues: Roact (copy), Toast (copy), uDim2 (copy), u54 (ref), currentToastMessage (copy), onButtonActivated (ref), p4 (copy), sequenceNumber (copy), FFlagLuaAppToastV2PerMessageDuration (copy), t1 (copy)
		return Roact.createElement(Toast, {
			show = true,
			position = uDim2,
			toastContent = {
				iconImage = u54,
				iconColorStyle = if not currentToastMessage or not currentToastMessage.toastIconColorStyle then nil else currentToastMessage.toastIconColorStyle,
				onActivated = onButtonActivated,
				onDismissed = p4.onDismissed,
				toastSubtitle = p5.toastSubMessage,
				sequenceNumber = sequenceNumber,
				toastTitle = p5.toastMessage
			},
			duration = if not FFlagLuaAppToastV2PerMessageDuration then p4.props.duration else currentToastMessage.duration or p4.props.duration,
			springOptions = if not currentToastMessage.slideIn then p4.props.springOptions else t1
		})
	end

	if GetFFlagLuaAppUseWithLocalization() then
		if v53 then
			return v59({
				toastMessage = toastMessage,
				toastSubMessage = toastSubMessage
			})
		end

		return withLocalization({
			toastMessage = toastMessage,
			toastSubMessage = toastSubMessage
		})(v59)
	end

	return v59(v53 and {
		toastMessage = toastMessage,
		toastSubMessage = toastSubMessage
	} or {
		toastMessage = toastMessage and localization:Format(toastMessage) or nil,
		toastSubMessage = toastSubMessage and localization:Format(toastSubMessage) or nil
	})
end
function v40.render(p6) -- line: 203
	-- upvalues: Roact (copy), VRReadyWrapper (copy), ScreenGuiWithBlurControl (copy), VRConstants (copy)
	local displayOrder = p6.props.displayOrder

	if not p6.props.currentToastMessage then
		return nil
	end

	return Roact.createElement(VRReadyWrapper, {
		component = ScreenGuiWithBlurControl,
		props = {
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = displayOrder
		},
		vrProps = {
			panelName = "Toast",
			partSize = VRConstants.ToastSize,
			offset = CFrame.lookAt(VRConstants.ToastPosition, VRConstants.DefaultCameraPosition),
			virtualScreenSize = VRConstants.ToastResolution,
			curvature = VRConstants.ToastCurvature
		}
	}, {
		Toast = p6:onRender()
	})
end
function v40.didUpdate(p7, p8, _) -- line: 229
	-- upvalues: ToastType (copy)
	local currentToastMessage = p7.props.currentToastMessage

	if currentToastMessage then
		if not next(currentToastMessage) or not currentToastMessage.toastMessage then
			p7.props.removeCurrentToastMessage()
		end

		if p8.currentRoute ~= p7.props.currentRoute and currentToastMessage.toastType == ToastType.QuickLaunchError then
			p7.props.removeCurrentToastMessage()
		end
	end
end

local v41 = RoactRodux.connect(function(p10, _) -- line: 248
	-- upvalues: FFlagSignalsNavP3dRouteGated (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		currentToastMessage = p10.CurrentToastMessages.currentToastMessage,
		currentRoute = if not FFlagSignalsNavP3dRouteGated then if not FFlagUseNavigationSelectors then p10.Navigation.history[#p10.Navigation.history] else Selectors.selectCurrentLegacyRoute(p10) else nil
	}
end, function(p12) -- line: 257
	-- upvalues: RemoveCurrentToastMessage (copy), OpenGameDetails (copy)
	return {
		removeCurrentToastMessage = function() -- line: 259
			-- upvalues: p12 (copy), RemoveCurrentToastMessage (copy)
			return p12(RemoveCurrentToastMessage())
		end,
		openGameDetails = function(p13) -- line: 262
			-- upvalues: p12 (copy), OpenGameDetails (copy)
			p12(OpenGameDetails(p13))
		end
	}
end)(v40)

if FFlagSignalsNavP3dRouteGated then
	local v42 = v41

	function v41(p14) -- line: 270
		-- upvalues: v35 (copy), useSignalState (copy), React (copy), v42 (copy), Cryo (copy)
		local v70 = v35(false)
		local v71 = useSignalState(v70.getCurrentLegacyRoute)

		return React.createElement(v42, Cryo.Dictionary.union(p14, {
			currentRoute = v71
		}))
	end
end

if not GetFFlagNotificationsForceEnableEDPDiscoverability() then
	v41 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ExperienceDetailsPageLayer }, function(p15, _) -- line: 286
		-- upvalues: AppUserLayers (copy), GetNotificationsExperienceDetailsVariant (copy)
		return {
			enableNotificationsDiscoverability = ((p15[AppUserLayers.ExperienceDetailsPageLayer] or {})[GetNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
		}
	end)(v41)
end

return RoactServices.connect({
	localization = RoactLocalization
})(v41)
