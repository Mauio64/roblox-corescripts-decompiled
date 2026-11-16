local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local Signals = require(parent.Signals)

local function createSduiPageEntrySnackbarStore()
	local v = {}

	return {
		getSignal = function(p: string)
			local v2 = v[p]

			if v2 then
				return v2.get
			end

			local signal, set = Signals.createSignal(nil)
			v[p] = { get = signal, set = set }

			return signal
		end,
		show = function(p: string, p2)
			local v2 = v[p]

			if v2 then
				v2.set(p2)
				return
			end

			local signal, set = Signals.createSignal(nil)
			v[p] = { get = signal, set = set }

			set(p2)
		end,
		hide = function(p: string)
			local v2 = v[p]

			if v2 then
				v2.set(nil)
				return
			end

			local signal, set = Signals.createSignal(nil)
			v[p] = { get = signal, set = set }

			set(nil)
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
