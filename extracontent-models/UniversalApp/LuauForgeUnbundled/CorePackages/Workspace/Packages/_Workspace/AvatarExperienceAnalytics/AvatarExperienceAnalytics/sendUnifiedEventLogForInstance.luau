local SessionService = game:GetService("SessionService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local UnifiedEventPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedEventPageStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")

local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isRunningInStudio

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXSendUnifiedEventLogWithInstance = AvatarExperienceFlags.FFlagAXSendUnifiedEventLogWithInstance
local fFlagAXUnifiedEventPageContext = AvatarExperienceFlags.FFlagAXUnifiedEventPageContext
local fFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local FFlagAllowCustomUnifiedEventFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/FFlagAllowCustomUnifiedEventFilter")

local AXUnifiedEventFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AXUnifiedEventFilter")

return function(instance, p2, options)
	local sessionTag = SessionService:GetSessionTag("level2a")
	local v5 = instance:GetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME)

	if not fFlagAXUnifiedEventPageContext and sessionTag ~= v5 and not isRunningInStudio() then
		return
	end

	local v6 = options or {}
	local attributes = {}
	local attributes2 = instance:GetAttributes()

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		attributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(attributes2)
	else
		for k, attribute in attributes2 do
			if UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(k) then
				attributes[UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(k)] = attribute
			end
		end
	end

	if v6.includeScreenSize then
		attributes = Cryo.Dictionary.join(attributes, UnifiedEventLoggingUtils.getScreenSize(instance))
	end

	if v6.includeElementSizeAndPosition then
		attributes = Cryo.Dictionary.join(attributes, UnifiedEventLoggingUtils.getElementSizeAndPosition(instance))
	end

	local joined = Cryo.Dictionary.join(attributes, p2)

	if fFlagAXUnifiedEventPageContext then
		local join = Cryo.Dictionary.join

		if v5 == nil or v5 == "" then
			v5 = UnifiedEventPageStore.UNKNOWN
		end

		joined = join(joined, { elementSessionTag = v5 })
	end

	local v7 = if FFlagAllowCustomUnifiedEventFilter and v6.filter then v6.filter else AXUnifiedEventFilter.filter
	local v8 = v7(joined)

	if not fFlagAXSendUnifiedEventLogWithInstance then
		instance = nil
	end

	sendUnifiedEventLog(joined, instance, fFlagAXUnifiedEventCounters and { filterPassed = v8 } or nil)
end
