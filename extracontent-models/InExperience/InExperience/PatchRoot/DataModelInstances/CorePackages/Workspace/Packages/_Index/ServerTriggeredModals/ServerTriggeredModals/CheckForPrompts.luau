local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlay = require(parent.CentralOverlay)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

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

local function isValidPromptEntry(data): boolean -- 1 equivalent call inferred from this helper
	return data ~= nil
		and data.config ~= nil
		and data.identifier ~= nil
		and data.robloxComponentType ~= nil
		and data.title ~= nil
end

local function CheckForPrompts(p): nil
	local v = useDispatch()
	local v2 = useModalSignalStore()
	local v3 = useSignalState(v2.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v4 = useSignalState(v2.getHasShownGetter(EntryPoint.HomepageLaunch))
	local isFocused = p.isFocused

	local v5 = React.useMemo(function()
		return {
			entryPoint = PromptsEntryPoint.HomepageLaunch,
			surfaceKey = "HomepagePrompts",
			configKey = "HomepagePrompts",
			clearOnEmptyResponse = true,
			allowNoConfigsBuilt = FFlagSduiAllowNoConfigsBuilt and true or nil,
			loadTimer = SduiLoadTimer.createLoadTimer("HomepagePrompts"),
			clientAttributes = nil,
			replaceOnFetch = nil,
			promptStyles = nil
		}
	end, {})

	React.useEffect(function()
		fetchPrompts(v5)
	end, { v5 })
	local v6

	if FFlagEnableHomepagePromptsForModalsAndBanners then
		v6 = usePromptEntries("HomepagePrompts", PromptStyle.Modal)[1]
	else
		v6 = useSignalState((React.useCallback(function(p2)
			local data = getSduiApiStore().getData("HomepagePrompts").data(p2)
			return data and data.HomepagePrompts
		end, {})))
	end

	React.useEffect(function()
		if v4 or v3 or not isFocused or not isValidPromptEntry(v6) then -- inferred equivalent call
			return
		end

		v2.setHasShown(EntryPoint.HomepageLaunch, true)
		local sduiPromptModal = CentralOverlayType.SduiPromptModal
		local v7 = {
			configKey = "HomepagePrompts",
			appPage = AppPage.Home,
			modalId = v6.identifier,
			modalType = 0
		}
		local modalType

		if FFlagPromptsImpressionUsesTitle then
			modalType = v6.title
		else
			modalType = v6.robloxComponentType
		end

		v7.modalType = modalType
		v(SetCentralOverlay(sduiPromptModal, v7))
	end, { v4, v3, isFocused, v, v2, v6 })

	return nil
end

local v = RoactNavigation.withNavigationFocus(CheckForPrompts)

return React.memo(v)
