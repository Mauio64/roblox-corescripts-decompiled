local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)

local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local toast = UIBlox.App.Dialog.Toast

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module = require("@luauforge/bundled/edB")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module2 = require("@luauforge/bundled/dCi")
local module3 = require("@luauforge/bundled/dHo")

local module4 = require("@luauforge/bundled/dwB")
local module5 = require("@luauforge/bundled/hKW")

local module6 = require("@luauforge/bundled/gdZ")
local Images = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Resources/Images")
local images = UIBlox.App.ImageSet.Images

local defineFastFlag = game:DefineFastFlag("LuaAppToastUseBlockLogo", false)

local luaAppgraphicic_alert = Images["LuaApp/graphic/ic_alert"]

local v5 = if defineFastFlag then images["icons/logo/block"] else Images["LuaApp/graphic/ic_logo"]

local vector2 = Vector2.new(36, 36)
local iconscommonnotificationOn = images["icons/common/notificationOn"]
local iconscommonnotificationOff = images["icons/common/notificationOff"]

local module8 = require("@luauforge/bundled/edD")

local getNotificationsExperienceDetailsVariant = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetNotificationsExperienceDetailsVariant

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability

local fFlagLuaAppToastV2PerMessageDuration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppToastV2PerMessageDuration
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module10 = require("@luauforge/bundled/fye")
local vrReadyWrapper = module10.VRReadyWrapper
local vrConstants = module10.VRConstants

local v6 = { frequency = 4, damping = 1 }

local extended = Roact.PureComponent:extend("ToastV2")

extended.defaultProps = {
	duration = 3,
	springOptions = { frequency = 150, damping = 1 }
}

local strictInterface = t.strictInterface
local v7 = {
	duration = t.optional(t.integer),
	springOptions = t.optional(t.table),
	displayOrder = t.optional(t.integer),
	localization = t.table,
	currentToastMessage = t.optional(t.table),
	currentRoute = 0,
	currentRouteKey = 0,
	openGameDetails = 0,
	removeCurrentToastMessage = 0,
	enableNotificationsDiscoverability = 0
}
local v8 = if fFlagSignalsNavP3dRouteGated then t.optional(t.table) else t.table
v7.currentRoute = v8
local v9 = if fFlagSignalsNavP3dRouteGated then t.optional(t.string) else nil
v7.currentRouteKey = v9

v7.openGameDetails = t.callback
v7.removeCurrentToastMessage = t.callback

v7.enableNotificationsDiscoverability = t.optional(t.boolean)
extended.validateProps = strictInterface(v7)

function extended:openLuaGameDetails(p3)
	self.props.openGameDetails(p3)
end

function extended:init()
	function self.onDismissed()
		self.props.removeCurrentToastMessage()
	end

	function self.onButtonActivated()
		if self.props.currentToastMessage then
			local currentToastMessage = self.props.currentToastMessage
			local toastType = currentToastMessage.toastType
			local universeId = currentToastMessage.universeId

			if toastType == module4.QuickLaunchError and universeId then
				self:openLuaGameDetails(universeId)
			end

			self.props.removeCurrentToastMessage()
		end
	end
end

function extended:onRender()
	local localization = self.props.localization
	local v10 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or self.props.enableNotificationsDiscoverability

	local currentToastMessage = self.props.currentToastMessage

	local toastMessage = currentToastMessage.toastMessage
	local toastSubMessage = currentToastMessage.toastSubMessage
	local sequenceNumber = currentToastMessage.sequenceNumber
	local isLocalized = currentToastMessage.isLocalized or false

	local v11 = nil
	local onButtonActivated = nil
	local toastType = currentToastMessage.toastType

	if toastType == module4.QuickLaunchError then
		onButtonActivated = self.onButtonActivated
	elseif toastType == module4.SuccessConfirmation then
		v11 = v5
	elseif toastType == module4.NetworkingError then
		v11 = luaAppgraphicic_alert
	elseif toastType == module4.InformationMessage then
		v11 = v5
	elseif v10 and toastType == module4.NotificationsTurnedOn then
		v11 = iconscommonnotificationOn
	elseif v10 and toastType == module4.NotificationsTurnedOff then
		v11 = iconscommonnotificationOff
	end

	if currentToastMessage.toastIcon then
		v11 = currentToastMessage.toastIcon
	end

	local v12 = (UserInputService.StatusBarSize and UserInputService.StatusBarSize.Y or 0) + 20
	local udim = UDim2.new(0.5, 0, 0, v12)

	local function fn(p2)
		local createElement = Roact.createElement
		local v14 = {
			position = udim,
			show = true,
			toastContent = 0,
			duration = 0,
			springOptions = 0
		}

		local v15 = {
			iconImage = v11,
			iconSize = 0,
			iconColorStyle = 0,
			onActivated = 0,
			onDismissed = 0,
			toastSubtitle = 0,
			sequenceNumber = 0,
			toastTitle = 0
		}

		local v16 = if defineFastFlag and v11 == v5 then vector2 else nil
		v15.iconSize = v16

		local v17 = if currentToastMessage and currentToastMessage.toastIconColorStyle then currentToastMessage.toastIconColorStyle else nil
		v15.iconColorStyle = v17

		v15.onActivated = onButtonActivated
		v15.onDismissed = self.onDismissed
		v15.toastSubtitle = p2.toastSubMessage
		v15.sequenceNumber = sequenceNumber
		v15.toastTitle = p2.toastMessage
		v14.toastContent = v15

		local v18 = if fFlagLuaAppToastV2PerMessageDuration then currentToastMessage.duration or self.props.duration else self.props.duration
		v14.duration = v18

		local v19 = if currentToastMessage.slideIn then v6 else self.props.springOptions
		v14.springOptions = v19
		return createElement(toast, v14)
	end

	if module8() then
		if isLocalized then
			return fn({ toastMessage = toastMessage, toastSubMessage = toastSubMessage })
		end

		return withLocalization({
			toastMessage = toastMessage,
			toastSubMessage = toastSubMessage
		})(fn)
	else
		local v13 = isLocalized and {
			toastMessage = toastMessage,
			toastSubMessage = toastSubMessage
		}

		if not v13 then
			v13 = { toastMessage = 0, toastSubMessage = 0 }
			local v14 = if toastMessage then localization:Format(toastMessage) or nil else nil
			v13.toastMessage = v14
			v13.toastSubMessage = toastSubMessage and localization:Format(toastSubMessage) or nil
		end

		return fn(v13)
	end
end

function extended:render()
	local displayOrder = self.props.displayOrder

	if self.props.currentToastMessage then
		return Roact.createElement(vrReadyWrapper, {
			component = module6,
			props = {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = displayOrder
			},
			vrProps = {
				partSize = vrConstants.ToastSize,
				offset = CFrame.lookAt(vrConstants.ToastPosition, vrConstants.DefaultCameraPosition),
				virtualScreenSize = vrConstants.ToastResolution,
				curvature = vrConstants.ToastCurvature,
				panelName = "Toast"
			}
		}, { Toast = self:onRender() })
	end

	return nil
end

function extended.didUpdate(p2, data, p3)
	local currentToastMessage = p2.props.currentToastMessage

	if currentToastMessage then
		if not (next(currentToastMessage) and currentToastMessage.toastMessage) then
			p2.props.removeCurrentToastMessage()
		end

		if fFlagSignalsNavP3dRouteGated then
			if module5(
				data.currentToastMessage,
				currentToastMessage,
				data.currentRouteKey,
				p2.props.currentRouteKey
			) then
				p2.props.removeCurrentToastMessage()
			end
		elseif
			data.currentRoute ~= p2.props.currentRoute
			and currentToastMessage.toastType == module4.QuickLaunchError
		then
			p2.props.removeCurrentToastMessage()
		end
	end
end

local v10 = RoactRodux.connect(function(p2, p3)
	local v11 = {
		currentToastMessage = p2.CurrentToastMessages.currentToastMessage,
		currentRoute = 0
	}
	local v12

	if not fFlagSignalsNavP3dRouteGated then
		if fFlagUseNavigationSelectors then
			v12 = selectors.selectCurrentLegacyRoute(p2)
		else
			v12 = p2.Navigation.history[#p2.Navigation.history]
		end
	end

	v11.currentRoute = v12
	return v11
end, function(callback)
	return {
		removeCurrentToastMessage = function()
			return callback(module2())
		end,
		openGameDetails = function(p2)
			callback(module3(p2))
		end
	}
end)(extended)
local v11

if fFlagSignalsNavP3dRouteGated then
	v11 = React.memo(function(p2)
		local v12 = useSelector(function(p3)
			return p3.CurrentToastMessages.currentToastMessage
		end)

		local v13 = not (v12 == nil) and v12.toastType == module4.QuickLaunchError
		local v14 = React.useMemo(function()
			local legacyNavigationStore = getLegacyNavigationStore(false)
			return Signals.createComputed(function(p3)
				if v13 then
					return (legacyNavigationStore.getCurrentRouteKey(p3))
				end

				return nil
			end)
		end, { v13 })
		return React.createElement(
			v10,
			Cryo.Dictionary.union(p2, { currentRouteKey = useSignalState(v14) })
		)
	end)
else
	v11 = v10
end

if not getFFlagNotificationsForceEnableEDPDiscoverability() then
	v11 = RoactAppExperiment.connectUserLayer({ appUserLayers.ExperienceDetailsPageLayer }, function(p2, p3)
		return {
			enableNotificationsDiscoverability = ((p2[appUserLayers.ExperienceDetailsPageLayer] or {})[getNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
		}
	end)(v11)
end

return roactServices.connect({ localization = module })(v11)
