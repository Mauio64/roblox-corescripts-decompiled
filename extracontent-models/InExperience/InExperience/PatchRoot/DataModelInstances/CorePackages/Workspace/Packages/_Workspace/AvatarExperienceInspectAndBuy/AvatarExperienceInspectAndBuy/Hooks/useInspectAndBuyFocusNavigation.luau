local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local useSelector = require(AvatarExperienceInspectAndBuyParent.RoactUtils).Hooks.RoactRodux.useSelector
local FocusNavigationUtils = require(AvatarExperienceInspectAndBuyParent.FocusNavigationUtils)
local FFlagAXFixIaBTimedOptionsPopoverFocus = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXFixIaBTimedOptionsPopoverFocus

require(AvatarExperienceInspectAndBuy.Types)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useRegistryEntry = FocusNavigableSurfaceRegistry.useRegistryEntry
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local function selectItemBeingPurchased(p1) -- line: 56
	return p1.itemBeingPurchased
end
local function useInspectAndBuyFocusNavigation() -- line: 60
	-- upvalues: React (copy), useSelector (copy), selectItemBeingPurchased (copy), useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), useAutoFocus (copy), useDescendantHasFocus (copy), useLastInputMode (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), MarketplaceService (copy), Players (copy), GuiService (copy)
	local v21, v22 = React.useState(nil)
	local v23, v24 = React.useState(false)
	local v25 = useSelector(selectItemBeingPurchased)
	local v26 = v25 and v25.itemId ~= nil
	local v27 = useRegisterFocusNavigableSurface()
	local v28 = useDeRegisterFocusNavigableSurface()
	local v29 = useAutoFocus({ v21 }, 0.1)
	local v30 = useDescendantHasFocus(v21)
	local v31 = useLastInputMode() == "Focus"
	local v32 = v26 or v23
	local v33 = nil

	if FFlagAXFixIaBTimedOptionsPopoverFocus then
		local v34 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PopUp) ~= nil
		local v35 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ContextualMenu) ~= nil
		local v36 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay) ~= nil

		v33 = v34 or (v35 or v36)
	end

	React.useEffect(function() -- line: 98
		-- upvalues: MarketplaceService (copy), Players (copy), v24 (copy)
		local connection = MarketplaceService.PromptBulkPurchaseRequested:Connect(function(p2) -- line: 99
			-- upvalues: Players (copy), v24 (copy)
			if p2 == Players.LocalPlayer then
				v24(true)
			end
		end)
		local connection2 = MarketplaceService.PromptBulkPurchaseFinished:Connect(function(p3) -- line: 104
			-- upvalues: Players (copy), v24 (copy)
			if p3 == Players.LocalPlayer then
				v24(false)
			end
		end)

		return function() -- line: 110
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 117
		-- upvalues: v32 (copy), v28 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v21 (copy), GuiService (copy), v27 (copy)
		if v32 then
			v28(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v21)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")

			return function() -- line: 123
			end
		end

		if v21 then
			v27(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v21)
			GuiService:AddSelectionParent("InspectAndBuyApp", v21)
		else
			v28(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v21)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end

		return function() -- line: 135
			-- upvalues: v28 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v21 (copy), GuiService (copy)
			v28(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v21)
			GuiService:RemoveSelectionGroup("InspectAndBuyApp")
			GuiService.SelectedCoreObject = nil
		end
	end, {
		v21,
		v32,
		v28,
		v27
	})

	local v37 = v31 and (v21 and (not v30 and (not v32 and not v33)))

	React.useEffect(function() -- line: 149
		-- upvalues: v37 (copy), v29 (copy)
		local u40 = nil

		if v37 then
			u40 = v29()
		end

		return function() -- line: 154
			-- upvalues: u40 (ref)
			if u40 then
				u40.cancel()
			end
		end
	end, {
		v37,
		v29
	})

	return {
		setFocusRef = v22,
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
