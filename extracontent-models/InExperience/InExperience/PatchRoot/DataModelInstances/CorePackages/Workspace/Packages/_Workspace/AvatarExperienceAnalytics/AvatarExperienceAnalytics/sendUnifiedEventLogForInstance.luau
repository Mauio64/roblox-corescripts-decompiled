local SessionService = game:GetService("SessionService")
local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local isRunningInStudio = require(AvatarExperienceAnalyticsParent.AppCommonLib).isRunningInStudio
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAllowCustomUnifiedEventFilter = require(script.Parent.FFlagAllowCustomUnifiedEventFilter)
local AXUnifiedEventFilter = require(script.Parent.AXUnifiedEventFilter)

return function(p1, p2, t1: {[any]: any}?) -- line: 25
	-- upvalues: SessionService (copy), UnifiedEventLogConstants (copy), isRunningInStudio (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLoggingUtils (copy), Cryo (copy), FFlagAllowCustomUnifiedEventFilter (copy), AXUnifiedEventFilter (copy), sendUnifiedEventLog (copy)
	if SessionService:GetSessionTag("level2a") ~= p1:GetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME) and not isRunningInStudio() then
		return
	end

	local v15 = t1 or {}
	local t2 = {}
	local Attributes = p1:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		t2 = UnifiedEventLoggingUtils.getFieldsToSendFromInstanceAttributes(Attributes)
	else
		for v18, v19 in Attributes do
			if UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(v18) then
				t2[UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(v18)] = v19
			end
		end
	end

	if v15.includeScreenSize then
		t2 = Cryo.Dictionary.join(t2, UnifiedEventLoggingUtils.getScreenSize(p1))
	end

	if v15.includeElementSizeAndPosition then
		t2 = Cryo.Dictionary.join(t2, UnifiedEventLoggingUtils.getElementSizeAndPosition(p1))
	end

	local v20 = Cryo.Dictionary.join(t2, p2);

	((if not FFlagAllowCustomUnifiedEventFilter or not v15.filter then AXUnifiedEventFilter.filter else v15.filter))(v20)
	sendUnifiedEventLog(v20)
end
