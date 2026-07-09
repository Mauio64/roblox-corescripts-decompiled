local AvatarEditorService = game:GetService("AvatarEditorService")
local Parent = script:FindFirstAncestor("AvatarExperienceSave").Parent
local Promise = require(Parent.Promise)

require(Parent.LuauPolyfill)

local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local AVATAR_EDITOR_SERVICE_ERRORS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_ERRORS

local function saveProfileConfiguration(n1: number) -- line: 29
	-- upvalues: Promise (copy), AvatarEditorService (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), AVATAR_EDITOR_SERVICE_ERRORS (copy)
	return Promise.new(function(resolve, reject) -- line: 30
		-- upvalues: n1 (copy), AvatarEditorService (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), AVATAR_EDITOR_SERVICE_ERRORS (copy)
		local t1 = {
			BackgroundAssetId = n1
		}
		local v12 = AvatarEditorService:NoPromptApplyProfileConfiguration(t1)

		while not v12 do
			AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()
			reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.NoPromptApplyProfileConfiguration)
			v12 = AvatarEditorService:NoPromptApplyProfileConfiguration(t1)
		end

		local v13 = AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

		if v13 == Enum.AvatarPromptResult.Success then
			resolve({
				avatarPromptResult = v13
			})

			return
		end

		reportAvatarEventCounterNoAnalyticsArgument(AVATAR_EDITOR_SERVICE_ERRORS.PromptApplyProfileConfigurationCompleted)
		reject({
			avatarPromptResult = v13
		})
	end)
end

return saveProfileConfiguration
