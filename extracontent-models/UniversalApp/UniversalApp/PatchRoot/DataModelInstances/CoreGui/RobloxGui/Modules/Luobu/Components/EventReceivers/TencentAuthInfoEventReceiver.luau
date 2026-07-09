local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local TencentAuthInfoModel = require(Modules.Luobu.Models.TencentAuthInfoModel)
local SetTencentAuthInfo = require(Modules.Luobu.Actions.SetTencentAuthInfo)

require(Modules.Luobu.Enum.TencentAuthType)

local v6 = Roact.Component:extend("TencentAuthInfoEventReceiver")

function v6.init(p1) -- line: 11
	-- upvalues: TencentAuthInfoModel (copy)
	p1.connections = { p1.props.RobloxEventReceiver:observeEvent("SyncTencentAuthInfo", function(p2, _) -- line: 13
		-- upvalues: TencentAuthInfoModel (copy), p1 (copy)
		local v15 = TencentAuthInfoModel.fromJsonData(p2)

		p1.props.setTencentAuthInfo(v15)
	end) }
end
function v6.render(_) -- line: 22
end
function v6.willUnmount(p5) -- line: 24
	for _, v in pairs(p5.connections) do
		v:disconnect()
	end
end

return (RoactRodux.connect(nil, function(p6) -- line: 30
	-- upvalues: SetTencentAuthInfo (copy)
	return {
		setTencentAuthInfo = function(p7) -- line: 32
			-- upvalues: p6 (copy), SetTencentAuthInfo (copy)
			return p6(SetTencentAuthInfo(p7))
		end
	}
end)(v6))
