local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/fBo")
local edpGameLeavePromptsHandler = module.EdpGameLeavePromptsHandler
local edpOpenPromptsHandler = module.EdpOpenPromptsHandler
local useDeviceType = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceType
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceType
local Signals = require(CorePackages.Packages.Signals)
local module2 = require("@luauforge/bundled/dXA")
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local module3 = require("@luauforge/deferred/gBC")
local module4 = require("@luauforge/deferred/gFa")
local paneHostContext = require("@luauforge/bundled/dIW").PaneHostContext
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps

require("@game/CorePackages/Workspace/Packages/Navigation")

local fFlagLuaAppSduiEdpEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiEdpEnabled
local fFlagLuaAppSduiEdpLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiEdpLogExposure

local fFlagLuaAppSduiEdpLogExposureLayoutEffect = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiEdpLogExposureLayoutEffect
local fStringLuaAppSduiEdpIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppSduiEdpIxpLayer

local fFlagLuaAppEdpKeepFullPageOnPortraitRotation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpKeepFullPageOnPortraitRotation

local fFlagEnableExperienceDetailsBottomSheet = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableExperienceDetailsBottomSheet

local fFlagEdpGameLeavePromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEdpGameLeavePromptsHandlerEnabled

local fFlagEdpOpenPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEdpOpenPromptsHandlerEnabled
local fFlagEnableSplitPaneEDPFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneEDPFix
local defineFastFlag = game:DefineFastFlag("EdpGameLeavePromptsHandlerLogExposure", false)

local defineFastString = game:DefineFastString(
	"EdpGameLeavePromptsHandlerIxpLayer",
	"PlayerApp.ExperienceDetailsPrompts.Exposure"
)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
require("@luauforge/bundled/dXB")
local v5

if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then
	v5 = Signals.createComputed(function(p2)
		local viewportSize = module2.GetDisplayStore(p2).getViewportSize(p2)
		local preferredInputType = Responsive.GetInputModeStore(p2).getPreferredInputType(p2)
		return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
	end)
else
	v5 = nil
end

local function renderGameDetailsPeekView(joined)
	return React.createElement(module3, joined)
end

local function renderExperienceDetailsPage(joined)
	return React.createElement(module4, joined)
end

local function ExperienceDetailsSelectorInner(p2)
	local v6 = useNavigationProps(function(p3, data)
		if p3 == nil then
			return nil
		end

		return {
			universeId = p3,
			source = data.source,
			index = data.index,
			onClose = data.onClose,
			mountAsFullView = data.mountAsFullView,
			mountAnimation = data.mountAnimation,
			referralSource = data.referralSource,
			onPeekViewClosed = data.onPeekViewClosed,
			showBackButton = data.showBackButton,
			experienceJoinData = data.experienceJoinData,
			placeIdOverride = data.placeIdOverride,
			pageTimer = data.pageTimer
		}
	end)

	local joined = Dash.join(p2, v6)

	if fFlagLuaAppSduiEdpLogExposure then
		if fFlagLuaAppSduiEdpLogExposureLayoutEffect then
			React.useLayoutEffect(function()
				IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppSduiEdpIxpLayer)
			end, {})
		else
			React.useEffect(function()
				IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppSduiEdpIxpLayer)
			end, {})
		end
	end

	local v7 = if joined.deviceType then joined.deviceType else useDeviceType()
	local v8

	if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then
		v8 = SignalsReact.useSignalState(v5)

		if not v8 and v7 == deviceType.Phone then
			v7 = deviceType.Tablet
		end
	else
		v8 = v7 == deviceType.Phone
	end

	local v9 = if fFlagEnableSplitPaneEDPFix then React.useContext(paneHostContext) else nil

	if v8 then
		if not fFlagLuaAppSduiEdpEnabled then
			return renderGameDetailsPeekView(joined)
		end

		local module6 = require("@luauforge/bundled/dCK")

		if fFlagEnableExperienceDetailsBottomSheet then
			local experienceDetailsBottomSheet = module6.ExperienceDetailsBottomSheet
			return React.createElement(experienceDetailsBottomSheet, joined)
		end

		local experienceDetailsPeekView = module6.ExperienceDetailsPeekView
		return React.createElement(experienceDetailsPeekView, joined)
	else
		local join = Dash.join

		local v11 = if v9 then not v9.isFullScreen else nil
		local v12 = if v9 then v9.isHostCloseVisible else nil
		local joined2 = join(joined, {
			deviceType = v7,
			showBottomActionBar = v11,
			hideCloseButtonOnHeader = v12
		})

		if not fFlagLuaAppSduiEdpEnabled then
			return renderExperienceDetailsPage(joined2)
		end

		local experienceDetailsFullPage = require("@luauforge/bundled/dCK").ExperienceDetailsFullPage
		return React.createElement(experienceDetailsFullPage, joined2)
	end
end

local function ExperienceDetailsSelector(p2)
	if defineFastFlag then
		React.useEffect(function()
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end, {})
	end

	if not (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) then
		return ExperienceDetailsSelectorInner(p2)
	end

	local v6 = useNavigationProps(function(p3)
		if p3 == nil then
			return nil
		end

		return { universeId = p3 }
	end)

	local universeId = if v6 == nil then p2.universeId else v6.universeId

	local createElement = React.createElement
	local fragment = React.Fragment
	local v8 = {
		ExperienceDetailsPage = React.createElement(ExperienceDetailsSelectorInner, p2),
		LeavePrompts = 0,
		OpenPrompts = 0
	}

	local v9 = if fFlagEdpGameLeavePromptsHandlerEnabled then React.createElement(edpGameLeavePromptsHandler, {
		universeId = universeId
	}) else nil
	v8.LeavePrompts = v9

	local v10 = if fFlagEdpOpenPromptsHandlerEnabled then React.createElement(edpOpenPromptsHandler, {
		universeId = universeId
	}) else nil
	v8.OpenPrompts = v10
	return createElement(fragment, nil, v8)
end

return ExperienceDetailsSelector
