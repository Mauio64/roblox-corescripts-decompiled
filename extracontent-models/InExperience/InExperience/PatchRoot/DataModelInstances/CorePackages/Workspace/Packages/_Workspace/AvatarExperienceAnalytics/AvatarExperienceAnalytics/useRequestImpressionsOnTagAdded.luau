local CollectionService = game:GetService("CollectionService")
local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventPageStore = require(script.Parent.Store.UnifiedEventPageStore)

local set = {
	[RobloxAppEnums.AppPage.AvatarExperienceWrapper] = true,
	[RobloxAppEnums.AppPage.AvatarExperienceWrapperTransparent] = true,
	[RobloxAppEnums.SwitchTab.AvatarExperienceTab] = true
}

for _, v in AvatarScreen do
	set[v] = true
end

local function isAppOnOtherPage(): boolean -- 1 equivalent call inferred from this helper
	local navigationPage = UnifiedEventPageStore.getPageFields().navigationPage
	return navigationPage ~= UnifiedEventPageStore.UNKNOWN and not set[navigationPage]
end

local function useRequestImpressionsOnTagAdded(p, object)
	React.useEffect(function()
		local thread = nil
		local connection = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(instance)
			local current = p.current

			if thread or not (current and instance:IsDescendantOf(current)) then
				return
			end

			thread = task.delay(0, function()
				thread = nil

				if isAppOnOtherPage() then -- inferred equivalent call
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
	end, { p, object })
end

return useRequestImpressionsOnTagAdded
