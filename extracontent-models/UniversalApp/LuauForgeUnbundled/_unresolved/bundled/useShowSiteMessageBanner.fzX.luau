local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/bundled/fyS")
local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage
local getSiteMessageStore = require("@luauforge/bundled/fyU").GetSiteMessageStore

local function useShowSiteMessageBanner()
	local v5

	if fFlagUseSignalsForSiteMessage then
		v5 = useSignalState(getSiteMessageStore(false).getText) ~= nil
	else
		v5 = useSelector((React.useCallback(function(p2)
			return p2.SiteMessage and p2.SiteMessage.Text
		end, {}))) ~= nil
	end

	return useAppPolicy(function(p2)
		return p2.getSiteMessageBanner()
	end) and v5 or module2
end

return useShowSiteMessageBanner
