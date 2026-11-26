local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Navigation").useNavigation
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppNavigation").useNavigationProps

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UrlBuilder").UrlBase
local OverlayWizardHost = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OverlayWizardHost")
local WizardSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardSpinner")
local FlowApiProvider = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FlowApiProvider")
local ComponentRegistry = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry")
local buildEntrypointRequest = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/buildEntrypointRequest")

local function rootFlowOf(p2)
	if p2 == nil or p2.name == "" then
		return nil
	end

	return p2.name
end

local function AmpV2WizardRoute(p2)
	local v5 = useNavigation()
	local v6 = useNavigationProps(function(p3, data)
		return {
			initialFragment = data.initialFragment,
			target = data.target,
			flow = data.flow,
			surface = data.surface or "DeepLink",
			odpEventContext = data.odpEventContext,
			odpEventUniverseId = data.odpEventUniverseId,
			api = data.api,
			registry = data.registry,
			extraProps = data.extraProps,
			onExit = data.onExit,
			onEvent = data.onEvent
		}
	end)

	local api = v6.api or FlowApiProvider
	local registry = v6.registry or ComponentRegistry.default

	local initialFragment = v6.initialFragment
	local state, setState = React.useState(nil)
	local v7 = initialFragment or state

	local v8 = not (v6.flow == nil) and v6.flow.name == "OdpCheckpointResume"
	local ref = React.useRef(nil)
	local v9 = React.useMemo(function()
		if not v8 then
			return nil
		end

		local resumeSourcePage = if v7 then v7.resumeSourcePage else nil
		local v10 = "my/account#!/parental-controls"

		if
			type(resumeSourcePage) == "string"
			and resumeSourcePage ~= ""
			and #resumeSourcePage <= 16384
			and not string.find(resumeSourcePage, "%c")
			and string.sub(resumeSourcePage, 1, 1) ~= "/"
			and not string.find(resumeSourcePage, "\\", 1, true)
			and not string.match(resumeSourcePage, "^[^?#]*:")
		then
			v10 = resumeSourcePage
		end

		return urlBase.new("www") .. "/" .. v10
	end, { v8, v7 })
	local v10 = React.useCallback(function(p3, p4)
		ref.current = { url = p3, title = p4 }
	end, {})

	local onExit = v6.onExit
	local v11 = React.useCallback(function(p3)
		if v9 then
			local current = ref.current
			local replace = v5.replace
			local genericWebPage = appPage.GenericWebPage
			local v13 = if current then current.url else v9

			local v15 = if current then current.title else nil
			replace(genericWebPage, {
				detail = v13,
				extraProps = {
					title = v15,
					titleKey = not current and "CommonUI.Features.Label.Settings" or nil
				}
			})
		else
			v5.pop()
		end

		if onExit then
			onExit(p3)
		end
	end, { v5, onExit, v9 })

	local ref2 = React.useRef(v11)
	ref2.current = v11

	local v12 = React.useMemo(function()
		return buildEntrypointRequest(v6.target, v6.flow, v6.surface, registry, v6.extraProps)
	end, { v6.target, v6.flow, v6.surface, registry, v6.extraProps })

	React.useEffect(function()
		if initialFragment ~= nil then
			return
		end

		local v13 = false
		api.entrypoint(v12):andThen(function(p3)
			if not v13 then
				setState(p3)
			end
		end):catch(function()
			if not v13 then
				ref2.current({ reason = "Error", flowId = "" })
			end
		end)
		return function()
			v13 = true
		end
	end, { initialFragment, api, v12 })

	if v7 == nil then
		return React.createElement(WizardSpinner)
	end

	local createElement = React.createElement
	local v14 = {
		initialFragment = v7,
		onTerminalRedirect = nil,
		target = 0,
		rootFlow = 0,
		flowProps = 0,
		surface = 0,
		odpEventContext = 0,
		odpEventUniverseId = 0,
		api = 0,
		registry = 0,
		onExit = 0,
		onEvent = 0
	}

	if not v8 then
		v10 = nil
	end

	v14.onTerminalRedirect = v10
	v14.target = v6.target
	local v15 = v7.resumeRootFlow

	if not v15 then
		local flow = v6.flow
		v15 = if not (flow == nil or flow.name == "") then flow.name else nil
	end

	v14.rootFlow = v15
	local v16 = if v6.flow then v6.flow.props else nil
	v14.flowProps = v16
	v14.surface = v7.resumeSurface or v6.surface
	v14.odpEventContext = v6.odpEventContext
	v14.odpEventUniverseId = v6.odpEventUniverseId
	v14.api = api
	v14.registry = registry
	v14.onExit = v11
	v14.onEvent = v6.onEvent
	return createElement(OverlayWizardHost, v14)
end

return AmpV2WizardRoute
