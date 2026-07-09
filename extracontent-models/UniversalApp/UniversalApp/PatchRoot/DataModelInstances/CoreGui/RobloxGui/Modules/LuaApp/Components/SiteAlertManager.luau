local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local ApiFetchSiteMessage = require(Modules.LuaApp.Thunks.ApiFetchSiteMessage)
local RefreshSiteAlertInfo = require(Modules.LuaApp.Actions.RefreshSiteAlertInfo)
local v10 = Roact.PureComponent:extend("SiteAlertManager")

function v10.render(_) -- line: 13
end
function v10.didUpdate(p2, p3) -- line: 15
	if not p3.updateRequested and p2.props.updateRequested then
		local timestamp = os.time()
		local messageTime = p2.props.messageTime

		if messageTime and timestamp - messageTime < p2.props.alertRateLimit then
			p2.props.dismissRefresh()

			return
		end

		p2.props.refresh(p2.props.networking)
	end
end

local v11 = RoactRodux.connect(function(p4, _) -- line: 27
	return {
		messageTime = p4.SiteMessage.timestamp,
		updateRequested = p4.SiteMessage.updateRequested
	}
end, function(p6) -- line: 32
	-- upvalues: ApiFetchSiteMessage (copy), RefreshSiteAlertInfo (copy)
	return {
		refresh = function(p7) -- line: 34
			-- upvalues: p6 (copy), ApiFetchSiteMessage (copy)
			p6(ApiFetchSiteMessage(p7))
		end,
		dismissRefresh = function() -- line: 37
			-- upvalues: p6 (copy), RefreshSiteAlertInfo (copy)
			p6(RefreshSiteAlertInfo({
				updateRequested = false
			}))
		end
	}
end)(v10)
local v12 = RoactServices.connect({
	networking = RoactNetworking
})(v11)

return (RoactAppPolicy.connect(function(p8, _) -- line: 49
	return {
		alertRateLimit = p8.getAlertRateLimit()
	}
end)(v12))
