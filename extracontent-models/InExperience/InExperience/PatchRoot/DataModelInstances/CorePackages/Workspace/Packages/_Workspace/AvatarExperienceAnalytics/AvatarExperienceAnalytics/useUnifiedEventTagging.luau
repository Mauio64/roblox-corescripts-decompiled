local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local addUnifiedEventLogging = require(script.Parent.addUnifiedEventLogging)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
require(script.Parent.Generated.UnifiedEventTypes)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local v = {
	hasDeferredActions = true,
	sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
}

local function useUnifiedEventTagging(data)
	local v2 = React.useMemo(function()
		if not FFlagAXUnifiedEventStrictPayloads then
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
			return v
		end

		local hasDeferredActions

		if options.hasDeferredActions == nil then
			hasDeferredActions = v.hasDeferredActions
		else
			hasDeferredActions = options.hasDeferredActions
		end

		local sessionTagName

		if options.sessionTagName == nil then
			sessionTagName = v.sessionTagName
		else
			sessionTagName = options.sessionTagName
		end

		return {
			hasDeferredActions = hasDeferredActions,
			sessionTagName = sessionTagName,
			isSelected = options.isSelected,
			skipImpressionDetection = options.skipImpressionDetection,
			skipTapDetection = options.skipTapDetection
		}
	end, { data.options })

	React.useEffect(function()
		if data.isReady == false then
			return
		end

		addUnifiedEventLogging(data.ref, data.payload, v2)
	end, { data.ref, data.payload, data.isReady, v2 })
end

return useUnifiedEventTagging
