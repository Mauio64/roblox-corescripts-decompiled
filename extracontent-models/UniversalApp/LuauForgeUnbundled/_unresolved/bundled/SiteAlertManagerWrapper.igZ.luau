local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module4 = require("@luauforge/bundled/gfz")
local module5 = require("@luauforge/bundled/dzL")

local fFlagSignalsNavP3Final = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Final
local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)
local createEffect = Signals.createEffect
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module6 = require("@luauforge/bundled/dFy")
local getSiteMessageStore = require("@luauforge/bundled/fyU").GetSiteMessageStore

local extended = module.PureComponent:extend("SiteAlertManager")

function extended.render(p2) end

function extended.didUpdate(p2, p3)
	if not p3.updateRequested and p2.props.updateRequested then
		local now = os.time()
		local messageTime = p2.props.messageTime

		if messageTime and now - messageTime < p2.props.alertRateLimit then
			p2.props.dismissRefresh()
		else
			p2.props.refresh(p2.props.networking)
		end
	end
end

local v5 = useSheetNavigation.connect(not fFlagUseSignalsForSiteMessage and function(p2, p3)
	return {
		messageTime = p2.SiteMessage.timestamp,
		updateRequested = p2.SiteMessage.updateRequested
	}
end or nil, function(callback)
	return {
		refresh = function(p2)
			callback(module4(p2))
		end,
		dismissRefresh = function()
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).refreshSiteAlertInfo(false)
			else
				callback(module5({ updateRequested = false }))
			end
		end
	}
end)(extended)

if fFlagUseSignalsForSiteMessage then
	local v6 = v5
	v5 = React.memo(function(p2)
		local v7 = useSignalState(getSiteMessageStore(false).getTimestamp)
		local v8 = useSignalState(getSiteMessageStore(false).getUpdateRequested)
		return React.createElement(
			v6,
			Cryo.Dictionary.union(p2, { messageTime = v7, updateRequested = v8 })
		)
	end)
end

local v6 = roactServices.connect({ networking = module3 })(v5)

local v7 = roactAppPolicy.connect(function(p2, p3)
	return { alertRateLimit = p2.getAlertRateLimit() }
end)(v6)

if not fFlagSignalsNavP3Final then
	return v7
end

local function SiteAlertManagerWrapper(p2)
	local v8 = useDispatch()

	React.useEffect(function()
		return createEffect(function(p3)
			if module6.getIsNavigating(p3) then
				if fFlagUseSignalsForSiteMessage then
					getSiteMessageStore(false).refreshSiteAlertInfo(true)
				else
					v8(module5({ updateRequested = true }))
				end
			end
		end)
	end, { v8 })

	return React.createElement(v7, p2)
end

return SiteAlertManagerWrapper
