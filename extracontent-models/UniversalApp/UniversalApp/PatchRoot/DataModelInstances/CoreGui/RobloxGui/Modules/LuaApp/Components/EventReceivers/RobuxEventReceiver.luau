local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local v9 = Roact.Component:extend("RobuxEventReceiver")

function v9.init(p1) -- line: 14
	-- upvalues: ArgCheck (copy)
	p1.isMounted = false

	local RobloxEventReceiver = p1.props.RobloxEventReceiver

	function p1.updateRobux() -- line: 19
		-- upvalues: p1 (copy), ArgCheck (copy)
		local localUserId = p1.props.localUserId
		local requestRobuxInfo = p1.props.requestRobuxInfo
		local networking = p1.props.networking

		ArgCheck.isNonEmptyString(localUserId, "RobuxEventReceiver.updateRobux.localUserId")

		if typeof(localUserId) == "string" and localUserId ~= "" then
			requestRobuxInfo(networking, localUserId)
		end
	end

	p1.tokens = { RobloxEventReceiver:observeEvent("AppInput", function(_, p3) -- line: 35
		-- upvalues: p1 (copy)
		if p3 == "Focused" then
			delay(3, function() -- line: 37
				-- upvalues: p1 (copy)
				if not p1.isMounted then
					return
				end

				p1.updateRobux()
			end)
		end
	end) }
end
function v9.render(p4) -- line: 48
	-- upvalues: Roact (copy)
	return Roact.oneChild(p4.props[Roact.Children])
end
function v9.didMount(p5) -- line: 52
	p5.isMounted = true
end
function v9.willUnmount(p6) -- line: 56
	for _, v in pairs(p6.tokens) do
		v:disconnect()
	end

	p6.isMounted = false
end

local v10 = RoactRodux.connect(function(p7, _) -- line: 63
	return {
		localUserId = p7.LocalUserId
	}
end, function(p9) -- line: 67
	-- upvalues: ApiFetchEconomyCurrency (copy)
	return {
		requestRobuxInfo = function(p10, p11) -- line: 69
			-- upvalues: p9 (copy), ApiFetchEconomyCurrency (copy)
			return p9(ApiFetchEconomyCurrency(p10, p11, true))
		end
	}
end)(v9)

return RoactServices.connect({
	networking = RoactNetworking
})(v10)
