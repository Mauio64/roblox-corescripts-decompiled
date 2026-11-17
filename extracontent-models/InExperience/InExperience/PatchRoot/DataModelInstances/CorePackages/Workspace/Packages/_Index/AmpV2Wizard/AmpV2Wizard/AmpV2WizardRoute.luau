local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps

require(AmpV2Wizard.Types)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase
local OverlayWizardHost = require(AmpV2Wizard.OverlayWizardHost)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local FlowApiProvider = require(AmpV2Wizard.FlowApiProvider)
local ComponentRegistry = require(AmpV2Wizard.ComponentRegistry)
local buildEntrypointRequest = require(AmpV2Wizard.buildEntrypointRequest)

local function rootFlowOf(flow) -- 1 equivalent call inferred from this helper
	if flow == nil or flow.name == "" then
		return nil
	end

	return flow.name
end

local function AmpV2WizardRoute(_)
	local v = useNavigation()
	local v2 = useNavigationProps(function(_, data)
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

	local api = v2.api or FlowApiProvider
	local registry = v2.registry or ComponentRegistry.default

	local initialFragment = v2.initialFragment
	local state, setState = React.useState(nil)
	local initialFragment2 = initialFragment or state
	local v3

	if v2.flow == nil then
		v3 = false
	else
		v3 = v2.flow.name == "OdpCheckpointResume"
	end

	local ref = React.useRef(nil)
	local v4 = React.useMemo(function()
		if not v3 then
			return nil
		end

		local resumeSourcePage

		if initialFragment2 then
			resumeSourcePage = initialFragment2.resumeSourcePage
		end

		local v4 = "my/account#!/parental-controls"

		if
			type(resumeSourcePage) == "string"
			and resumeSourcePage ~= ""
			and #resumeSourcePage <= 16384
			and not string.find(resumeSourcePage, "%c")
			and string.sub(resumeSourcePage, 1, 1) ~= "/"
			and not string.find(resumeSourcePage, "\\", 1, true)
			and not string.match(resumeSourcePage, "^[^?#]*:")
		then
			v4 = resumeSourcePage
		end

		return UrlBase.new("www") .. "/" .. v4
	end, { v3, initialFragment2 })
	local onTerminalRedirect = React.useCallback(function(url: string, title: string)
		ref.current = { url = url, title = title }
	end, {})

	local onExit = v2.onExit
	local v5 = React.useCallback(function(p)
		if v4 then
			local current = ref.current
			local replace = v.replace
			local genericWebPage = AppPage.GenericWebPage
			local detail = if current then current.url else v4
			local title

			if current then
				title = current.title
			end

			replace(genericWebPage, {
				detail = detail,
				extraProps = {
					title = title,
					titleKey = not current and "CommonUI.Features.Label.Settings" or nil
				}
			})
		else
			v.pop()
		end

		if onExit then
			onExit(p)
		end
	end, { v, onExit, v4 })

	local ref2 = React.useRef(v5)
	ref2.current = v5

	local v6 = React.useMemo(function()
		return buildEntrypointRequest(v2.target, v2.flow, v2.surface, registry, v2.extraProps)
	end, { v2.target, v2.flow, v2.surface, registry, v2.extraProps })

	React.useEffect(function()
		if initialFragment ~= nil then
			return
		end

		local v7 = false
		api.entrypoint(v6):andThen(function(p)
			if not v7 then
				setState(p)
			end
		end):catch(function()
			if not v7 then
				ref2.current({ reason = "Error", flowId = "" })
			end
		end)
		return function()
			v7 = true
		end
	end, { initialFragment, api, v6 })

	if initialFragment2 == nil then
		return React.createElement(WizardSpinner)
	end

	local createElement = React.createElement
	local v7 = {
		initialFragment = initialFragment2,
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

	if not v3 then
		onTerminalRedirect = nil
	end

	v7.onTerminalRedirect = onTerminalRedirect
	v7.target = v2.target
	v7.rootFlow = initialFragment2.resumeRootFlow or rootFlowOf(v2.flow) -- inferred equivalent call
	local flowProps

	if v2.flow then
		flowProps = v2.flow.props
	end

	v7.flowProps = flowProps
	v7.surface = initialFragment2.resumeSurface or v2.surface
	v7.odpEventContext = v2.odpEventContext
	v7.odpEventUniverseId = v2.odpEventUniverseId
	v7.api = api
	v7.registry = registry
	v7.onExit = v5
	v7.onEvent = v2.onEvent
	return createElement(OverlayWizardHost, v7)
end

return AmpV2WizardRoute
