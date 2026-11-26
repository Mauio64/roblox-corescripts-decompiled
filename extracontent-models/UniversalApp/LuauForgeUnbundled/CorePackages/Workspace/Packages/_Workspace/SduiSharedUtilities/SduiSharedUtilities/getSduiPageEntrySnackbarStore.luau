local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Signals")

local function createSduiPageEntrySnackbarStore()
	local v5 = {}

	return {
		getSignal = function(p2)
			local v6 = v5[p2]

			if v6 then
				return v6.get
			end

			local signal, v7 = Signals.createSignal(nil)
			v5[p2] = { get = signal, set = v7 }

			return signal
		end,
		show = function(p2, p3)
			local v6 = v5[p2]

			if v6 then
				v6.set(p3)
				return
			end

			local signal, v7 = Signals.createSignal(nil)
			v5[p2] = { get = signal, set = v7 }

			v7(p3)
		end,
		hide = function(p2)
			local v6 = v5[p2]

			if v6 then
				v6.set(nil)
				return
			end

			local signal, v7 = Signals.createSignal(nil)
			v5[p2] = { get = signal, set = v7 }

			v7(nil)
		end
	}
end

local sduiPageEntrySnackbarStore = nil

local function getSduiPageEntrySnackbarStore()
	if sduiPageEntrySnackbarStore == nil then
		sduiPageEntrySnackbarStore = createSduiPageEntrySnackbarStore()
	end

	return sduiPageEntrySnackbarStore
end

return getSduiPageEntrySnackbarStore
