local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFocusTags = SduiSharedUtilities.SduiFocusTags
local useInitialFocusOnTag = SduiSharedUtilities.useInitialFocusOnTag
local useSelectionOrderTracking = SduiSharedUtilities.useSelectionOrderTracking
local usePageButtonBindings = SduiSharedUtilities.usePageButtonBindings
local useOnNavigateBack = SduiSharedUtilities.useOnNavigateBack
local getSduiFocusActivationStore = SduiSharedUtilities.getSduiFocusActivationStore
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport

local CollectionService = game:GetService("CollectionService")

local v = { [Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.Play }
local ButtonY = Enum.KeyCode.ButtonY
local v2

if not FFlagLuaAppMediaGalleryGamepadSupport then
	v2 = FocusNavigationEventNameEnum.DisplayStatsAndInfo
end

v[ButtonY] = v2

v[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
v[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack

local function findTaggedDescendant(statsSection: string, ref)
	local current = ref.current

	if not current then
		return nil
	end

	for _, v3 in CollectionService:GetTagged(statsSection) do
		if v3:IsDescendantOf(current) then
			return v3
		end
	end

	return nil
end

local function useExperienceDetailsFocusNavigation(callback)
	local ref = React.useRef(nil)
	useInitialFocusOnTag(SduiFocusTags.PrimaryAction, ref)
	useSelectionOrderTracking(ref)

	local v3 = ReactFocusNavigation.useFocusGuiObject()

	local v4 = React.useCallback(function()
		getSduiFocusActivationStore().activate(SduiFocusTags.PrimaryAction)
	end, {})

	local v5 = React.useCallback(function()
		local taggedDescendant = findTaggedDescendant(SduiFocusTags.StatsSection, ref)

		if taggedDescendant then
			v3(taggedDescendant)
		end
	end, { v3, ref })

	local v6 = useOnNavigateBack(callback, (usePageButtonBindings(ref, v, (React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.Play] = { handler = InputHandlers.onRelease(v4) },
			[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = not FFlagLuaAppMediaGalleryGamepadSupport and {
				handler = InputHandlers.onRelease(v5)
			} or nil
		}
	end, { v4, v5 })))))

	return (React.useCallback(function(current)
		ref.current = current

		if type(v6) == "function" then
			v6(current)
		elseif v6 ~= nil then
			v6.current = current
		end
	end, { v6 }))
end

return useExperienceDetailsFocusNavigation
