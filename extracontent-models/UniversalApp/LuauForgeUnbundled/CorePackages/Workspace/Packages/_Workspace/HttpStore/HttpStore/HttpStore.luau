local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/InternalHttpStore")
local createHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/createHttpStore")

local v5 = nil

local signal, v6 = Signals.createSignal(nil)

return {
	_create = function(p2)
		v5 = createHttpStore(p2)
		v6(v5)
		return v5
	end,
	_dispose = function()
		local v9 = signal()

		if v9 ~= nil then
			v9.cancelAll()
		end

		v6(nil)
	end,
	get = function(p2)
		return signal(p2)
	end
}
