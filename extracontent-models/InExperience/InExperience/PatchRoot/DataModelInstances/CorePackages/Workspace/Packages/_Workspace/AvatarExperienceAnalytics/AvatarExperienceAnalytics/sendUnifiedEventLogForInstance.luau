local SessionService = game:GetService("SessionService")
local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local Cryo = require(parent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local UnifiedEventPageStore = require(script.Parent.Store.UnifiedEventPageStore)
require(script.Parent.Generated.UnifiedEventTypes)

local AppCommonLib = require(parent.AppCommonLib)
local isRunningInStudio = AppCommonLib.isRunningInStudio

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXSendUnifiedEventLogWithInstance = AvatarExperienceFlags.FFlagAXSendUnifiedEventLogWithInstance
local FFlagAXUnifiedEventPageContext = AvatarExperienceFlags.FFlagAXUnifiedEventPageContext
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local FFlagAllowCustomUnifiedEventFilter = require(script.Parent.FFlagAllowCustomUnifiedEventFilter)

local AXUnifiedEventFilter = require(script.Parent.AXUnifiedEventFilter)

return function(instance, p, options)
	local sessionTag = SessionService:GetSessionTag("level2a")
	local elementSessionTag = instance:GetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME)

	if not FFlagAXUnifiedEventPageContext and sessionTag ~= elementSessionTag and not isRunningInStudio() then
		return
	end

	local v = options or {}
	local attributes = {}
	local attributes2 = instance:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		attributes = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(attributes2)
	else
		for k, attribute in attributes2 do
			if UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(k) then
				attributes[UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(k)] = attribute
			end
		end
	end

	if v.includeScreenSize then
		attributes = Cryo.Dictionary.join(attributes, UnifiedEventLoggingUtils.getScreenSize(instance))
	end

	if v.includeElementSizeAndPosition then
		attributes = Cryo.Dictionary.join(attributes, UnifiedEventLoggingUtils.getElementSizeAndPosition(instance))
	end

	local joined = Cryo.Dictionary.join(attributes, p)

	if FFlagAXUnifiedEventPageContext then
		local join = Cryo.Dictionary.join

		if elementSessionTag == nil or elementSessionTag == "" then
			elementSessionTag = UnifiedEventPageStore.UNKNOWN
		end

		joined = join(joined, { elementSessionTag = elementSessionTag })
	end

	local v2

	if FFlagAllowCustomUnifiedEventFilter and v.filter then
		v2 = v.filter
	else
		v2 = AXUnifiedEventFilter.filter
	end

	local filterPassed = v2(joined)

	if not FFlagAXSendUnifiedEventLogWithInstance then
		instance = nil
	end

	sendUnifiedEventLog(joined, instance, FFlagAXUnifiedEventCounters and {
		filterPassed = filterPassed
	} or nil)
end
