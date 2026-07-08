local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local RobloxAppEnums = require(ServerTriggeredModalsParent.RobloxAppEnums)
local CentralOverlay = require(ServerTriggeredModalsParent.CentralOverlay)
local useSignalState = require(ServerTriggeredModalsParent.SignalsReact).useSignalState
local useDispatch = require(ServerTriggeredModalsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local RoactNavigation = require(ServerTriggeredModalsParent.RoactNavigation)
local SharedFlags = require(ServerTriggeredModalsParent.SharedFlags)
local SduiSharedUtilities = require(ServerTriggeredModalsParent.SduiSharedUtilities)
local AppPage = RobloxAppEnums.AppPage
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local EntryPoint = require(ServerTriggeredModals.EntryPoint)
local fetchPrompts = require(ServerTriggeredModals.SduiV2.fetchPrompts)
local PromptsEntryPoint = require(ServerTriggeredModals.SduiV2.PromptsEntryPoint)
local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle

local function isValidPromptEntry(t1: {[any]: any}?) -- line: 38
	return t1 ~= nil and (t1.config ~= nil and (t1.identifier ~= nil and (t1.robloxComponentType ~= nil and t1.title ~= nil)))
end
local function CheckForPrompts(t2: {[any]: any}) -- line: 46
	-- upvalues: useDispatch (copy), useModalSignalStore (copy), useSignalState (copy), EntryPoint (copy), React (copy), PromptsEntryPoint (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), fetchPrompts (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), usePromptEntries (copy), PromptStyle (copy), getSduiApiStore (copy), SetCentralOverlay (copy), CentralOverlayType (copy), AppPage (copy), FFlagPromptsImpressionUsesTitle (copy)
	local v30 = useDispatch()
	local v31 = useModalSignalStore()
	local v32 = useSignalState(v31.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v33 = useSignalState(v31.getHasShownGetter(EntryPoint.HomepageLaunch))
	local isFocused = t2.isFocused
	local v35 = React.useMemo(function() -- line: 53
		-- upvalues: PromptsEntryPoint (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy)
		return {
			surfaceKey = "HomepagePrompts",
			configKey = "HomepagePrompts",
			clearOnEmptyResponse = true,
			entryPoint = PromptsEntryPoint.HomepageLaunch,
			allowNoConfigsBuilt = not not FFlagSduiAllowNoConfigsBuilt or nil,
			loadTimer = SduiLoadTimer.createLoadTimer("HomepagePrompts")
		}
	end, {})

	React.useEffect(function() -- line: 64
		-- upvalues: fetchPrompts (copy), v35 (copy)
		fetchPrompts(v35)
	end, { v35 })

	local u36

	if FFlagEnableHomepagePromptsForModalsAndBanners then
		u36 = usePromptEntries("HomepagePrompts", PromptStyle.Modal)[1]
	else
		local v37 = React.useCallback(function(p1) -- line: 74
			-- upvalues: getSduiApiStore (copy)
			local v39 = getSduiApiStore().getData("HomepagePrompts").data(p1)

			return v39 and v39.HomepagePrompts
		end, {})

		u36 = useSignalState(v37)
	end

	React.useEffect(function() -- line: 82
		-- upvalues: v33 (copy), v32 (copy), isFocused (copy), u36 (ref), v31 (copy), EntryPoint (copy), v30 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), AppPage (copy), FFlagPromptsImpressionUsesTitle (copy)
		if v33 then
			return
		end

		if v32 then
			return
		end

		if not isFocused then
			return
		end

		local v40 = u36

		if v40 == nil or (v40.config == nil or (v40.identifier == nil or (v40.robloxComponentType == nil or v40.title == nil))) then
			return
		end

		v31.setHasShown(EntryPoint.HomepageLaunch, true)
		v30(SetCentralOverlay(CentralOverlayType.SduiPromptModal, {
			configKey = "HomepagePrompts",
			appPage = AppPage.Home,
			modalId = u36.identifier,
			modalType = if not FFlagPromptsImpressionUsesTitle then u36.robloxComponentType else u36.title
		}))
	end, {
		v33,
		v32,
		isFocused,
		v30,
		v31,
		u36
	})

	return nil
end

local v27 = RoactNavigation.withNavigationFocus(CheckForPrompts)

return React.memo(v27)
