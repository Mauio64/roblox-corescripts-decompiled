local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

require(Parent.FocusNavigationUtils)

local function createButtonHoldStore() -- line: 21
	-- upvalues: Signals (copy), React (copy), SignalsReact (copy)
	local v6, v7 = Signals.createSignal({})

	local function updateButtonHoldState(p1, p2) -- line: 24
		-- upvalues: v7 (copy)
		v7(function(p3) -- line: 25
			-- upvalues: p1 (copy), p2 (copy)
			if p3[p1] ~= p2 then
				local v12 = table.clone(p3)

				v12[p1] = p2

				return v12
			end

			return p3
		end)
	end

	return {
		getButtonHoldState = v6,
		setButtonHoldState = v7,
		useDispatchButtonHoldStarted = function() -- line: 35
			-- upvalues: React (copy), v7 (copy), updateButtonHoldState (copy)
			return (React.useCallback(function(p4, p5) -- line: 37
				-- upvalues: v7 (copy)
				v7(function(p6) -- line: 25
					-- upvalues: p4 (copy), p5 (copy)
					if p6[p4] ~= p5 then
						local v18 = table.clone(p6)

						v18[p4] = p5

						return v18
					end

					return p6
				end)
			end, { updateButtonHoldState }))
		end,
		useDispatchButtonHoldEnded = function() -- line: 45
			-- upvalues: React (copy), v7 (copy), updateButtonHoldState (copy)
			return (React.useCallback(function(p7) -- line: 46
				-- upvalues: v7 (copy)
				local v16 = nil

				v7(function(p8) -- line: 25
					-- upvalues: p7 (copy), v16 (copy)
					if p8[p7] ~= v16 then
						local v20 = table.clone(p8)

						v20[p7] = v16

						return v20
					end

					return p8
				end)
			end, { updateButtonHoldState }))
		end,
		useHeldProgressByEvent = function() -- line: 52
			-- upvalues: SignalsReact (copy), v6 (copy)
			return SignalsReact.useSignalState(v6)
		end
	}
end

return createButtonHoldStore
