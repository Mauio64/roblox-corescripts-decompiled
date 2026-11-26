local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")

local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/addUnifiedEventLogging")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local v5 = { hasDeferredActions = true, sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME }

local function useUnifiedEventTagging(data)
	local v6 = React.useMemo(function()
		if not fFlagAXUnifiedEventStrictPayloads then
			return Cryo.Dictionary.join(
				{
					hasDeferredActions = true,
					sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
				},
				data.options or {}
			)
		end

		local options = data.options

		if options == nil then
			return v5
		end

		local v8 = if options.hasDeferredActions == nil then v5.hasDeferredActions else options.hasDeferredActions
		local v9 = if options.sessionTagName == nil then v5.sessionTagName else options.sessionTagName
		return {
			hasDeferredActions = v8,
			sessionTagName = v9,
			isSelected = options.isSelected,
			skipImpressionDetection = options.skipImpressionDetection,
			skipTapDetection = options.skipTapDetection
		}
	end, { data.options })

	React.useEffect(function()
		if data.isReady == false then
			return
		end

		addUnifiedEventLogging(data.ref, data.payload, v6)
	end, { data.ref, data.payload, data.isReady, v6 })
end

return useUnifiedEventTagging
