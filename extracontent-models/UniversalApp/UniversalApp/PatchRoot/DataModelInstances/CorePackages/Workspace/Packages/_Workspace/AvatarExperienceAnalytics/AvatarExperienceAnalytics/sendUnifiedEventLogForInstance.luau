local SessionService = game:GetService("SessionService")
local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local isRunningInStudio = require(AvatarExperienceAnalyticsParent.AppCommonLib).isRunningInStudio
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local AXUnifiedEventFilter = require(script.Parent.AXUnifiedEventFilter)

return function(p1, p2, t1: {[any]: any}?) -- line: 22
	-- upvalues: SessionService (copy), UnifiedEventLogConstants (copy), isRunningInStudio (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLoggingUtils (copy), Cryo (copy), AXUnifiedEventFilter (copy), sendUnifiedEventLog (copy)
	if SessionService:GetSessionTag("level2a") ~= p1:GetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME) and not isRunningInStudio() then
		return
	end

	local v14 = t1 or {}
	local t2 = {}
	local Attributes = p1:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		t2 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(Attributes)
	else
		for v17, v18 in Attributes do
			if UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(v17) then
				t2[UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(v17)] = v18
			end
		end
	end

	if v14.includeScreenSize then
		t2 = Cryo.Dictionary.join(t2, UnifiedEventLoggingUtils.getScreenSize(p1))
	end

	if v14.includeElementSizeAndPosition then
		t2 = Cryo.Dictionary.join(t2, UnifiedEventLoggingUtils.getElementSizeAndPosition(p1))
	end

	local v19 = Cryo.Dictionary.join(t2, p2)

	AXUnifiedEventFilter.filter(v19)
	sendUnifiedEventLog(v19)
end
