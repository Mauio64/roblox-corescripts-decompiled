local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local useDeviceType = require(CorePackages.Workspace.Packages.RobloxAppHooks).useDeviceType
local DeviceType = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceType
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local GameDetailsPeekView = require(Modules.LuaApp.Components.GameDetails.GameDetailsPeekView)
local ExperienceDetailsContainer = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsContainer)
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps

require(CorePackages.Workspace.Packages.Navigation)

local FFlagLuaAppSduiEdpEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiEdpEnabled
local FFlagLuaAppSduiEdpLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiEdpLogExposure
local FStringLuaAppSduiEdpIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppSduiEdpIxpLayer
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local FFlagEnableExperienceDetailsBottomSheet = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableExperienceDetailsBottomSheet
local FFlagLuaAppSduiEdpPassPageTimerThroughNav = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiEdpPassPageTimerThroughNav
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

require(CorePackages.Workspace.Packages.SduiSharedUtilities)

local v21 = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else Signals.createComputed(function(p1) -- line: 61
	-- upvalues: Display (copy), Responsive (copy)
	local v26 = Display.GetDisplayStore(p1).getViewportSize(p1)
	local v27 = Responsive.GetInputModeStore(p1).getPreferredInputType(p1)

	return Responsive.getIsCompactTouch(v26, v27)
end)

local function renderGameDetailsPeekView(t1: {[any]: any}) -- line: 68
	-- upvalues: React (copy), GameDetailsPeekView (copy)
	return React.createElement(GameDetailsPeekView, t1)
end
local function renderExperienceDetailsPage(t2: {[any]: any}) -- line: 72
	-- upvalues: React (copy), ExperienceDetailsContainer (copy)
	return React.createElement(ExperienceDetailsContainer, t2)
end
local function ExperienceDetailsSelector(t3: {[any]: any}) -- line: 76
	-- upvalues: useNavigationProps (copy), FFlagLuaAppSduiEdpPassPageTimerThroughNav (copy), Dash (copy), FFlagLuaAppSduiEdpLogExposure (copy), React (copy), IXPService (copy), FStringLuaAppSduiEdpIxpLayer (copy), useDeviceType (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), SignalsReact (copy), v21 (copy), DeviceType (copy), FFlagLuaAppSduiEdpEnabled (copy), CorePackages (copy), FFlagEnableExperienceDetailsBottomSheet (copy), renderGameDetailsPeekView (copy), renderExperienceDetailsPage (copy)
	local v31 = useNavigationProps(function(p2, p3) -- line: 77
		-- upvalues: FFlagLuaAppSduiEdpPassPageTimerThroughNav (copy)
		if p2 ~= nil then
			return {
				universeId = p2,
				source = p3.source,
				index = p3.index,
				onClose = p3.onClose,
				mountAsFullView = p3.mountAsFullView,
				mountAnimation = p3.mountAnimation,
				referralSource = p3.referralSource,
				onPeekViewClosed = p3.onPeekViewClosed,
				showBackButton = p3.showBackButton,
				experienceJoinData = p3.experienceJoinData,
				placeIdOverride = p3.placeIdOverride,
				pageTimer = if not FFlagLuaAppSduiEdpPassPageTimerThroughNav then nil else p3.pageTimer
			}
		end

		return nil
	end)
	local v32 = Dash.join(t3, v31)

	if FFlagLuaAppSduiEdpLogExposure then
		React.useEffect(function() -- line: 99
			-- upvalues: IXPService (copy), FStringLuaAppSduiEdpIxpLayer (copy)
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppSduiEdpIxpLayer)
		end, {})
	end

	local v33 = if not v32.deviceType then useDeviceType() else v32.deviceType
	local v34

	if FFlagLuaAppEdpKeepFullPageOnPortraitRotation then
		v34 = SignalsReact.useSignalState(v21)

		if not v34 and v33 == DeviceType.Phone then
			v33 = DeviceType.Tablet
		end
	else
		v34 = v33 == DeviceType.Phone
	end

	if v34 then
		if FFlagLuaAppSduiEdpEnabled then
			local GameDetail = require(CorePackages.Workspace.Packages.GameDetail)

			if FFlagEnableExperienceDetailsBottomSheet then
				local ExperienceDetailsBottomSheet = GameDetail.ExperienceDetailsBottomSheet

				return React.createElement(ExperienceDetailsBottomSheet, v32)
			end

			local ExperienceDetailsPeekView = GameDetail.ExperienceDetailsPeekView

			return React.createElement(ExperienceDetailsPeekView, v32)
		end

		return renderGameDetailsPeekView(v32)
	end

	local v38 = Dash.join(v32, {
		deviceType = v33
	})

	if FFlagLuaAppSduiEdpEnabled then
		local ExperienceDetailsFullPage = require(CorePackages.Workspace.Packages.GameDetail).ExperienceDetailsFullPage

		return React.createElement(ExperienceDetailsFullPage, v38)
	end

	return renderExperienceDetailsPage(v38)
end

return ExperienceDetailsSelector
