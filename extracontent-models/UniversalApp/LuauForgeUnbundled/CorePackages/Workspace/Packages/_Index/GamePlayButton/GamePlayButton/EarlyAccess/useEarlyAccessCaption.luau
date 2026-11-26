local useCountdownText = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/useCountdownText")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization

local function useEarlyAccessCaption(p2)
	local v5 = if p2 then p2.unlockTimestamp else nil
	local v6 = useCountdownText(v5)
	local v7 = useLocalization({
		joinIn = {
			"Feature.RobloxSubscription.Action.JoinIn",
			time = v6
		}
	})

	if v6 == "" then
		return nil
	end

	return v7.joinIn
end

return useEarlyAccessCaption
