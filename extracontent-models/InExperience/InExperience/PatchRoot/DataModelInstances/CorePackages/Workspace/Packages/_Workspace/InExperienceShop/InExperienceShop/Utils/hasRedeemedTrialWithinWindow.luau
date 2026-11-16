local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local FIntRedeemedTrialBlueDotMaxSecondsUntilEnd = require(InExperienceShop.Flags.FIntRedeemedTrialBlueDotMaxSecondsUntilEnd)

local function hasRedeemedTrialWithinWindow(items): boolean
	local unixTimestamp = DateTime.now().UnixTimestamp

	for _, item in items do
		local endTime = item.endTime

		if endTime == nil then
			continue
		end

		local v = endTime.UnixTimestamp - unixTimestamp

		if v >= 0 and v < FIntRedeemedTrialBlueDotMaxSecondsUntilEnd then
			return true
		end
	end

	return false
end

return hasRedeemedTrialWithinWindow
