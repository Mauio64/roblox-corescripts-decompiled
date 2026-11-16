local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils").Hooks.RoactRodux.useSelector
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/FocusNavigationUtils")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useRegistryEntry = focusNavigableSurfaceRegistry.useRegistryEntry
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local function selectItemBeingPurchased(p2)
	return p2.itemBeingPurchased
end

local function useInspectAndBuyFocusNavigation()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v5 = useSelector(selectItemBeingPurchased)
	local v6 = v5 and v5.itemId ~= nil

	local v7 = useRegisterFocusNavigableSurface()
	local v8 = useDeRegisterFocusNavigableSurface()
	local v9 = useAutoFocus({ state }, 0.1)
	local v10 = useDescendantHasFocus(state)
	local v11 = useLastInputMode() == "Focus"

	local v12 = v6 or state2

	local v13 = useRegistryEntry(focusNavigableSurfaceIdentifierEnum.PopUp) ~= nil
	local v14 = useRegistryEntry(focusNavigableSurfaceIdentifierEnum.ContextualMenu) ~= nil
	local v15 = useRegistryEntry(focusNavigableSurfaceIdentifierEnum.ModerationOverlay) ~= nil

	React.useEffect(function()
		local promptBulkPurchaseRequestedConnection = MarketplaceService.PromptBulkPurchaseRequested:Connect(function(p2)
			if p2 == Players.LocalPlayer then
				setState2(true)
			end
		end)
		local promptBulkPurchaseFinishedConnection = MarketplaceService.PromptBulkPurchaseFinished:Connect(function(p2)
			if p2 == Players.LocalPlayer then
				setState2(false)
			end
		end)

		return function()
			promptBulkPurchaseRequestedConnection:Disconnect()
			promptBulkPurchaseFinishedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if v12 then
			v8(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			return function() end
		end

		if state then
			v7(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:AddSelectionParent("InspectAndBuyApp", state)
		else
			v8(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end

		return function()
			v8(focusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end
	end, { state, v12, v8, v7 })
	local v16 = v11 and state and not (v10 or v12 or v13 or v14 or v15)
	React.useEffect(function()
		local v17 = if v16 then v9() else nil

		return function()
			if v17 then
				v17.cancel()
			end
		end
	end, { v16, v9 })

	return {
		setFocusRef = setState,
		focusNavigationProps = {
			SelectionGroup = true,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}
	}
end

return useInspectAndBuyFocusNavigation
