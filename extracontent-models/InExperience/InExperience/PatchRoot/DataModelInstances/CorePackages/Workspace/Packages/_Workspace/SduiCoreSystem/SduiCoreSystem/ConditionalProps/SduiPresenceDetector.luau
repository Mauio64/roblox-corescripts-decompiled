local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local checkPresenceConditions = require(SduiCoreSystem.ConditionalProps.checkPresenceConditions)

local function SduiPresenceDetector(data): nil
	local allConditionalProps = data.allConditionalProps
	local setFailedPresencePropIndexes = data.setFailedPresencePropIndexes
	local getInGameFriendsByGame = data.sduiContext.dataStore.social.getInGameFriendsByGame

	React.useLayoutEffect(function()
		local v = {}

		local function checkConditions(p)
			local v2 = checkPresenceConditions(allConditionalProps, p)
			local flag = nil

			for k, v3 in v2 do
				if (v[k] and true or false) ~= (v3 and true or false) then
					flag = true
					break
				end
			end

			if not flag then
				for k, v3 in v do
					if (v2[k] and true or false) ~= (v3 and true or false) then
						flag = true
						break
					end
				end
			end

			if flag then
				v = v2
				setFailedPresencePropIndexes(v2)
			end
		end

		checkConditions(getInGameFriendsByGame(false))

		return Signals.createEffect(function(p)
			checkConditions(getInGameFriendsByGame(p))
		end)
	end, { getInGameFriendsByGame, allConditionalProps, setFailedPresencePropIndexes })

	return nil
end

return React.memo(SduiPresenceDetector)
