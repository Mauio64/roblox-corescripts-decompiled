local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local React = require(SduiCoreSystemParent.React)
local Signals = require(SduiCoreSystemParent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)

local checkPresenceConditions = require(SduiCoreSystem.ConditionalProps.checkPresenceConditions)

local function SduiPresenceDetector(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), checkPresenceConditions (copy), Signals (copy)
	local allConditionalProps = t1.allConditionalProps
	local setFailedPresencePropIndexes = t1.setFailedPresencePropIndexes
	local getInGameFriendsByGame = t1.sduiContext.dataStore.social.getInGameFriendsByGame

	React.useLayoutEffect(function() -- line: 28
		-- upvalues: checkPresenceConditions (copy), allConditionalProps (copy), setFailedPresencePropIndexes (copy), getInGameFriendsByGame (copy), Signals (copy)
		local t2 = {}

		local function checkConditions(t3: {[any]: any}) -- line: 31
			-- upvalues: checkPresenceConditions (copy), allConditionalProps (copy), t2 (ref), setFailedPresencePropIndexes (copy)
			local v14 = checkPresenceConditions(allConditionalProps, t3)
			local v15 = nil

			for v16, v17 in v14 do
				if not not t2[v16] ~= not not v17 then
					v15 = true

					break
				end
			end

			if not v15 then
				for v18, v19 in t2 do
					if not not v14[v18] ~= not not v19 then
						v15 = true

						break
					end
				end
			end

			if v15 then
				t2 = v14
				setFailedPresencePropIndexes(v14)
			end
		end

		checkConditions(getInGameFriendsByGame(false))

		return Signals.createEffect(function(p1) -- line: 58
			-- upvalues: checkConditions (copy), getInGameFriendsByGame (copy)
			checkConditions(getInGameFriendsByGame(p1))
		end)
	end, {
		getInGameFriendsByGame,
		allConditionalProps,
		setFailedPresencePropIndexes
	})

	return nil
end

return React.memo(SduiPresenceDetector)
