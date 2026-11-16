local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

require(AvatarExperienceInspectAndBuy.Types)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useRegistryEntry = FocusNavigableSurfaceRegistry.useRegistryEntry
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local function selectItemBeingPurchased(p)
	return p.itemBeingPurchased
end

local function useInspectAndBuyFocusNavigation()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v = useSelector(selectItemBeingPurchased)
	local v2 = v and v.itemId ~= nil

	local v3 = useRegisterFocusNavigableSurface()
	local v4 = useDeRegisterFocusNavigableSurface()
	local v5 = useAutoFocus({ state }, 0.1)
	local v6 = useDescendantHasFocus(state)
	local v7 = useLastInputMode() == "Focus"

	local v8 = v2 or state2

	local v9 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PopUp) ~= nil
	local v10 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ContextualMenu) ~= nil
	local v11 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay) ~= nil

	React.useEffect(function()
		local promptBulkPurchaseRequestedConnection = MarketplaceService.PromptBulkPurchaseRequested:Connect(function(p)
			if p == Players.LocalPlayer then
				setState2(true)
			end
		end)
		local promptBulkPurchaseFinishedConnection = MarketplaceService.PromptBulkPurchaseFinished:Connect(function(p)
			if p == Players.LocalPlayer then
				setState2(false)
			end
		end)

		return function()
			promptBulkPurchaseRequestedConnection:Disconnect()
			promptBulkPurchaseFinishedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if v8 then
			v4(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			return function() end
		end

		if state then
			v3(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:AddSelectionParent("InspectAndBuyApp", state)
		else
			v4(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end

		return function()
			v4(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, state)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end
	end, { state, v8, v4, v3 })
	local v12 = v7 and state and not (v6 or v8 or v9 or v10 or v11)
	React.useEffect(function()
		local v13

		if v12 then
			v13 = v5()
		else
			v13 = nil
		end

		return function()
			if v13 then
				v13.cancel()
			end
		end
	end, { v12, v5 })

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
