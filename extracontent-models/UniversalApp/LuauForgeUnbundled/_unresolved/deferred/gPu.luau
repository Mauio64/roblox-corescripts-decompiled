local CollectionService = game:GetService("CollectionService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local unifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

return function(callback, button)
	if not (button and button:IsA("GuiButton") and CollectionService:HasTag(
		button,
		unifiedEventLogConstants.TAG_NAME
	) and button:GetAttribute(unifiedEventLogConstants.HAS_DEFERRED_ACTION) == true) then
		return
	end

	local join = Cryo.Dictionary.join
	local screenSize = unifiedEventLoggingUtils.getScreenSize(button)
	local elementSizeAndPosition = unifiedEventLoggingUtils.getElementSizeAndPosition(button)

	local v6 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
	local v7 = join(screenSize, elementSizeAndPosition, { cartId = v6 })

	task.defer(function()
		if CollectionService:HasTag(button, unifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME) then
			return
		end

		callback(button, v7)
	end)
end
