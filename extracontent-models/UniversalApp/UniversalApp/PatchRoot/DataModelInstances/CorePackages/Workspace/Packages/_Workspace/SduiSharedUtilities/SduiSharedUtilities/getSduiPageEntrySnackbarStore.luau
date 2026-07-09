local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local Signals = require(Parent.Signals)

local function createSduiPageEntrySnackbarStore() -- line: 20
	-- upvalues: Signals (copy)
	local t1 = {}

	return {
		getSignal = function(s1: string) -- line: 23
			-- upvalues: t1 (copy), Signals (copy)
			local v8 = t1[s1]

			if v8 then
				return v8.get
			end

			local v9, v10 = Signals.createSignal(nil)

			t1[s1] = {
				get = v9,
				set = v10
			}

			return v9
		end,
		show = function(s2: string, t2: {[any]: any}) -- line: 37
			-- upvalues: t1 (copy), Signals (copy)
			local v13 = t1[s2]

			if v13 then
				v13.set(t2)

				return
			end

			local v14, v15 = Signals.createSignal(nil)

			t1[s2] = {
				get = v14,
				set = v15
			}
			v15(t2)
		end,
		hide = function(s3: string) -- line: 51
			-- upvalues: t1 (copy), Signals (copy)
			local v17 = t1[s3]

			if v17 then
				v17.set(nil)

				return
			end

			local v18, v19 = Signals.createSignal(nil)

			t1[s3] = {
				get = v18,
				set = v19
			}
			v19(nil)
		end
	}
end

local u4 = nil

local function getSduiPageEntrySnackbarStore() -- line: 74
	-- upvalues: u4 (ref), createSduiPageEntrySnackbarStore (copy)
	if u4 == nil then
		u4 = createSduiPageEntrySnackbarStore()
	end

	return u4
end

return getSduiPageEntrySnackbarStore
