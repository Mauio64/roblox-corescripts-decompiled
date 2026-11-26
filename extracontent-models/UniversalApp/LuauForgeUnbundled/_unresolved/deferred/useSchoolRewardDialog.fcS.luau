local module = require("@luauforge/deferred/eko")
local dataStatus = require("@luauforge/deferred/ekt").DataStatus

local module2 = require("@luauforge/deferred/eku")
local useExperienceIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/InExperienceSideSheet/Hooks/useExperienceIcon")
local module4 = require("@luauforge/deferred/ekM")
local module5 = require("@luauforge/deferred/ekx")

local isShown = module4.isShown
local markShown = module4.markShown

local function useSchoolRewardDialog()
	local v5 = module5()
	local v6 = v5.status == dataStatus.Ready
	local school = v5.school

	local state, setState = module.useState(function()
		return isShown(module2.SchoolRewardDialog.APP_STORAGE_KEY)
	end)

	local v7 = module.useMemo(function()
		if not v6 or school == nil or school.rewards == nil then
			return nil
		end

		for k, reward in school.rewards do
			if reward.owned then
				return reward.assetId
			end
		end

		return nil
	end, { v6, school })

	local v8 = not (v7 == nil) and not state

	local v9 = module.useCallback(function()
		setState(true)
		markShown(module2.SchoolRewardDialog.APP_STORAGE_KEY)
	end, {})

	return {
		shouldShow = v8,
		rewardAssetId = v7,
		mediaImage = not v7 and "" or useExperienceIcon(v7),
		dismiss = v9
	}
end

return useSchoolRewardDialog
