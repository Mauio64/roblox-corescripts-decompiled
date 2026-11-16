local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes")
local checkPresenceConditions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/checkPresenceConditions")

local function SduiPresenceDetector(data): nil
	local allConditionalProps = data.allConditionalProps
	local setFailedPresencePropIndexes = data.setFailedPresencePropIndexes
	local getInGameFriendsByGame = data.sduiContext.dataStore.social.getInGameFriendsByGame

	React.useLayoutEffect(function()
		local v5 = {}

		local function checkConditions(p2)
			local v6 = checkPresenceConditions(allConditionalProps, p2)
			local flag = nil

			for k, v8 in v6 do
				if (v5[k] and true or false) ~= (v8 and true or false) then
					flag = true
					break
				end
			end

			if not flag then
				for k, v9 in v5 do
					if (v6[k] and true or false) ~= (v9 and true or false) then
						flag = true
						break
					end
				end
			end

			if flag then
				v5 = v6
				setFailedPresencePropIndexes(v6)
			end
		end

		checkConditions(getInGameFriendsByGame(false))

		return Signals.createEffect(function(p2)
			checkConditions(getInGameFriendsByGame(p2))
		end)
	end, { getInGameFriendsByGame, allConditionalProps, setFailedPresencePropIndexes })

	return nil
end

return React.memo(SduiPresenceDetector)
