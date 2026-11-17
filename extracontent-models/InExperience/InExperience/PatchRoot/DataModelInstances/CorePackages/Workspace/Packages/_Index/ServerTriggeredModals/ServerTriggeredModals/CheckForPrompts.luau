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
local logPromptModalSkipped = require(ServerTriggeredModals.logPromptModalSkipped)
local FFlagPromptsModalSkipTelemetry = require(ServerTriggeredModals.Flags.FFlagPromptsModalSkipTelemetry)

local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local withNavigationFocusIgnoringNavigation

if FFlagSignalsNavP3hMisc then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	withNavigationFocusIgnoringNavigation = RobloxAppNavigation.withNavigationFocusIgnoringNavigation
end

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

	local v6 = nil
	local v7

	if FFlagEnableHomepagePromptsForModalsAndBanners then
		v6 = usePromptEntries("HomepagePrompts", PromptStyle.Modal)
		v7 = v6[1]
	else
		v7 = useSignalState((React.useCallback(function(p2)
			local data = getSduiApiStore().getData("HomepagePrompts").data(p2)
			return data and data.HomepagePrompts
		end, {})))
	end

	local v8

	if FFlagPromptsModalSkipTelemetry then
		v8 = v6
	end

	React.useEffect(function()
		if v4 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(
					logPromptModalSkipped.Reason.AlreadyShown,
					EntryPoint.HomepageLaunch,
					v6 or { v7 }
				)
			end
		elseif v3 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(
					logPromptModalSkipped.Reason.LegacyMetadata,
					EntryPoint.HomepageLaunch,
					v6 or { v7 }
				)
			end
		elseif isFocused then
			if isValidPromptEntry(v7) then -- inferred equivalent call
				v2.setHasShown(EntryPoint.HomepageLaunch, true)

				if FFlagPromptsModalSkipTelemetry then
					logPromptModalSkipped.markShown(EntryPoint.HomepageLaunch, v7)
				end

				local sduiPromptModal = CentralOverlayType.SduiPromptModal
				local v9 = {
					configKey = "HomepagePrompts",
					appPage = AppPage.Home,
					modalId = v7.identifier,
					modalType = 0
				}
				local modalType

				if FFlagPromptsImpressionUsesTitle then
					modalType = v7.title
				else
					modalType = v7.robloxComponentType
				end

				v9.modalType = modalType
				v(SetCentralOverlay(sduiPromptModal, v9))
			elseif FFlagPromptsModalSkipTelemetry and v7 ~= nil then
				logPromptModalSkipped.log(logPromptModalSkipped.Reason.IncompleteEntry, EntryPoint.HomepageLaunch, v7)
			end
		elseif FFlagPromptsModalSkipTelemetry then
			logPromptModalSkipped.logAll(
				logPromptModalSkipped.Reason.NotFocused,
				EntryPoint.HomepageLaunch,
				v6 or { v7 }
			)
		end
	end, { v4, v3, isFocused, v, v2, v7, v8 })

	return nil
end

if FFlagSignalsNavP3hMisc then
	return withNavigationFocusIgnoringNavigation(CheckForPrompts)
end

local v = RoactNavigation.withNavigationFocus(CheckForPrompts)

return React.memo(v)
