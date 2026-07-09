local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useInitialFocusOnTag = SduiSharedUtilities.useInitialFocusOnTag
local useSelectionOrderTracking = SduiSharedUtilities.useSelectionOrderTracking
local usePageButtonBindings = SduiSharedUtilities.usePageButtonBindings
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local getSduiFocusActivationStore = SduiSharedUtilities.getSduiFocusActivationStore
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local CollectionService = game:GetService("CollectionService")
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.Play,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.DisplayStatsAndInfo,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function findTaggedDescendant(s1: string, t2: {[any]: any}) -- line: 29
	-- upvalues: CollectionService (copy)
	local current = t2.current

	if not current then
		return nil
	end

	for _, v22 in CollectionService:GetTagged(s1) do
		if v22:IsDescendantOf(current) then
			return v22
		end
	end

	return nil
end
local function useExperienceDetailsFocusNavigation(p1: ((...any) -> ...any)) -- line: 52
	-- upvalues: React (copy), useInitialFocusOnTag (copy), SduiFocusTags (copy), useSelectionOrderTracking (copy), ReactFocusNavigation (copy), getSduiFocusActivationStore (copy), findTaggedDescendant (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), usePageButtonBindings (copy), t1 (copy), useOnNavigateBack (copy)
	local v24 = React.useRef(nil)

	useInitialFocusOnTag(SduiFocusTags.PrimaryAction, v24)
	useSelectionOrderTracking(v24)

	local v25 = ReactFocusNavigation.useFocusGuiObject()
	local v26 = React.useCallback(function() -- line: 59
		-- upvalues: getSduiFocusActivationStore (copy), SduiFocusTags (copy)
		getSduiFocusActivationStore().activate(SduiFocusTags.PrimaryAction)
	end, {})
	local v27 = React.useCallback(function() -- line: 63
		-- upvalues: findTaggedDescendant (copy), SduiFocusTags (copy), v24 (copy), v25 (copy)
		local v31 = findTaggedDescendant(SduiFocusTags.StatsSection, v24)

		if v31 then
			v25(v31)
		end
	end, {
		v25,
		v24
	})
	local v28 = React.useMemo(function() -- line: 70
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v26 (copy), v27 (copy)
		return {
			[FocusNavigationEventNameEnum.Play] = {
				handler = InputHandlers.onRelease(v26)
			},
			[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = {
				handler = InputHandlers.onRelease(v27)
			}
		}
	end, {
		v26,
		v27
	})
	local v29 = usePageButtonBindings(v24, t1, v28)
	local v30 = useOnNavigateBack(p1, v29)

	return (React.useCallback(function(p2) -- line: 84
		-- upvalues: v24 (copy), v30 (copy)
		v24.current = p2

		if type(v30) == "function" then
			v30(p2)

			return
		end

		if v30 ~= nil then
			v30.current = p2
		end
	end, { v30 }))
end

return useExperienceDetailsFocusNavigation
