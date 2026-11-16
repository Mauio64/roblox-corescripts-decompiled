local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/RobloxAppEnums")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.AvatarScreen
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedEventPageStore")

local set = {
	[RobloxAppEnums.AppPage.AvatarExperienceWrapper] = true,
	[RobloxAppEnums.AppPage.AvatarExperienceWrapperTransparent] = true,
	[RobloxAppEnums.SwitchTab.AvatarExperienceTab] = true
}

for k, v5 in avatarScreen do
	set[v5] = true
end

local function isAppOnOtherPage(): boolean
	local navigationPage = UnifiedEventPageStore.getPageFields().navigationPage
	return navigationPage ~= UnifiedEventPageStore.UNKNOWN and not set[navigationPage]
end

local function useRequestImpressionsOnTagAdded(p2, object)
	React.useEffect(function()
		local thread = nil
		local connection = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(instance)
			local current = p2.current

			if thread or not (current and instance:IsDescendantOf(current)) then
				return
			end

			thread = task.delay(0, function()
				thread = nil
				local navigationPage = UnifiedEventPageStore.getPageFields().navigationPage
				local v5 = not (navigationPage == UnifiedEventPageStore.UNKNOWN) and not set[navigationPage]

				if v5 then
					return
				end

				object:fire()
			end)
		end)

		return function()
			connection:Disconnect()

			if thread then
				task.cancel(thread)
			end
		end
	end, { p2, object })
end

return useRequestImpressionsOnTagAdded
