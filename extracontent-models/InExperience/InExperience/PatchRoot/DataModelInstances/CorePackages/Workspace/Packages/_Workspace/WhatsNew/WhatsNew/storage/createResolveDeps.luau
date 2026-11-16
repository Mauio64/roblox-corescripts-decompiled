local WhatsNew = script:FindFirstAncestor("WhatsNew")

local Constants = require(WhatsNew.Constants)
local EntryStorage = require(script.Parent.EntryStorage)
require(WhatsNew.Types)

local Players = game:GetService("Players")

local function getAccountAgeDays() -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer
	return if localPlayer == nil then 1e999 else localPlayer.AccountAge
end

return {
	createResolveDeps = function(options)
		local v = options or {}
		local v2 = v.accountAgeDays or getAccountAgeDays() -- inferred equivalent call

		return {
			storage = EntryStorage.getEntries(),
			onboardingEligible = v2 < Constants.OnboardingAccountAge,
			currentTime = v.currentTime or DateTime.now().UnixTimestamp
		}
	end
}
