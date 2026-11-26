local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/ReactFocusNavigation")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local sduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useInitialFocusOnTag = SduiSharedUtilities.useInitialFocusOnTag
local useSelectionOrderTracking = SduiSharedUtilities.useSelectionOrderTracking
local usePageButtonBindings = SduiSharedUtilities.usePageButtonBindings
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local getSduiFocusActivationStore = SduiSharedUtilities.getSduiFocusActivationStore
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport

local CollectionService = game:GetService("CollectionService")

local v5 = { [Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.Play }
local buttonY = Enum.KeyCode.ButtonY

local v6 = if not fFlagLuaAppMediaGalleryGamepadSupport then focusNavigationEventNameEnum.DisplayStatsAndInfo else nil
v5[buttonY] = v6

v5[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
v5[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack

local function findTaggedDescendant(statsSection, ref)
	local current = ref.current

	if not current then
		return nil
	end

	for k, v7 in CollectionService:GetTagged(statsSection) do
		if v7:IsDescendantOf(current) then
			return v7
		end
	end

	return nil
end

local function useExperienceDetailsFocusNavigation(p2)
	local ref = React.useRef(nil)
	useInitialFocusOnTag(sduiFocusTags.PrimaryAction, ref)
	useSelectionOrderTracking(ref)

	local v7 = ReactFocusNavigation.useFocusGuiObject()

	local v8 = React.useCallback(function()
		getSduiFocusActivationStore().activate(sduiFocusTags.PrimaryAction)
	end, {})

	local v9 = React.useCallback(function()
		local taggedDescendant = findTaggedDescendant(sduiFocusTags.StatsSection, ref)

		if taggedDescendant then
			v7(taggedDescendant)
		end
	end, { v7, ref })

	local v12 = useOnNavigateBack(p2, (usePageButtonBindings(ref, v5, (React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.Play] = { handler = InputHandlers.onRelease(v8) },
			[focusNavigationEventNameEnum.DisplayStatsAndInfo] = not fFlagLuaAppMediaGalleryGamepadSupport and {
				handler = InputHandlers.onRelease(v9)
			} or nil
		}
	end, { v8, v9 })))))

	return (React.useCallback(function(current)
		ref.current = current

		if type(v12) == "function" then
			v12(current)
		elseif v12 ~= nil then
			v12.current = current
		end
	end, { v12 }))
end

return useExperienceDetailsFocusNavigation
