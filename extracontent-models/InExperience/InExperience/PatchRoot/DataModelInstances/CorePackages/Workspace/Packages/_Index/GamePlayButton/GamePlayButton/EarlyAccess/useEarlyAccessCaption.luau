local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent
local useCountdownText = require(GamePlayButton.EarlyAccess.useCountdownText)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function useEarlyAccessCaption(p)
	local v

	if p then
		v = p.unlockTimestamp
	end

	local time = useCountdownText(v)
	local v2 = useLocalization({
		joinIn = {
			"Feature.RobloxSubscription.Action.JoinIn",
			time = time
		}
	})

	return if time ~= "" then v2.joinIn else nil
end

return useEarlyAccessCaption
