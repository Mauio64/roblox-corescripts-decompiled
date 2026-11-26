local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/CentralOverlay")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact").useSignalState
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useDispatch
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")

local appPage = RobloxAppEnums.AppPage
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local useModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/useModalSignalStore")
local EntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/EntryPoint")
local fetchPrompts = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/fetchPrompts")
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local usePromptEntries = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/usePromptEntries")
local logPromptModalSkipped = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logPromptModalSkipped")
local FFlagPromptsModalSkipTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsModalSkipTelemetry")

local fFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local fFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local withNavigationFocusIgnoringNavigation

if fFlagSignalsNavP3hMisc then
	withNavigationFocusIgnoringNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppNavigation").withNavigationFocusIgnoringNavigation
end

local function isValidPromptEntry(data): boolean
	return data ~= nil
		and data.config ~= nil
		and data.identifier ~= nil
		and data.robloxComponentType ~= nil
		and data.title ~= nil
end

local function CheckForPrompts(p2): nil
	local v5 = useDispatch()
	local v6 = useModalSignalStore()
	local v7 = useSignalState(v6.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v8 = useSignalState(v6.getHasShownGetter(EntryPoint.HomepageLaunch))
	local isFocused = p2.isFocused

	local v9 = React.useMemo(function()
		return {
			entryPoint = PromptsEntryPoint.HomepageLaunch,
			surfaceKey = "HomepagePrompts",
			configKey = "HomepagePrompts",
			clearOnEmptyResponse = true,
			allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
			loadTimer = sduiLoadTimer.createLoadTimer("HomepagePrompts"),
			clientAttributes = nil,
			replaceOnFetch = nil,
			promptStyles = nil
		}
	end, {})

	React.useEffect(function()
		fetchPrompts(v9)
	end, { v9 })

	local v10 = nil
	local v11

	if fFlagEnableHomepagePromptsForModalsAndBanners then
		v10 = usePromptEntries("HomepagePrompts", PromptStyle.Modal)
		v11 = v10[1]
	else
		v11 = useSignalState((React.useCallback(function(p3)
			local data = getSduiApiStore().getData("HomepagePrompts").data(p3)
			return data and data.HomepagePrompts
		end, {})))
	end

	React.useEffect(function()
		if v8 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.AlreadyShown, EntryPoint.HomepageLaunch, v10 or { v11 })
			end
		elseif v7 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.LegacyMetadata, EntryPoint.HomepageLaunch, v10 or { v11 })
			end
		elseif isFocused then
			local v13 = v11
			local v14

			if
				v13 == nil
				or v13.config == nil
				or v13.identifier == nil
				or v13.robloxComponentType == nil
			then
				v14 = false
			else
				v14 = v13.title ~= nil
			end

			if v14 then
				v6.setHasShown(EntryPoint.HomepageLaunch, true)

				if FFlagPromptsModalSkipTelemetry then
					logPromptModalSkipped.markShown(EntryPoint.HomepageLaunch, v11)
				end

				local sduiPromptModal = centralOverlayType.SduiPromptModal
				local v17 = {
					configKey = "HomepagePrompts",
					appPage = appPage.Home,
					modalId = v11.identifier,
					modalType = 0
				}
				local v18 = if fFlagPromptsImpressionUsesTitle then v11.title else v11.robloxComponentType
				v17.modalType = v18
				v5(setCentralOverlay(sduiPromptModal, v17))
			elseif FFlagPromptsModalSkipTelemetry and v11 ~= nil then
				logPromptModalSkipped.log(logPromptModalSkipped.Reason.IncompleteEntry, EntryPoint.HomepageLaunch, v11)
			end
		elseif FFlagPromptsModalSkipTelemetry then
			logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.NotFocused, EntryPoint.HomepageLaunch, v10 or { v11 })
		end
	end, {
		v8,
		v7,
		isFocused,
		v5,
		v6,
		v11,
		if FFlagPromptsModalSkipTelemetry then v10 else nil
	})

	return nil
end

if fFlagSignalsNavP3hMisc then
	return withNavigationFocusIgnoringNavigation(CheckForPrompts)
end

local v5 = RoactNavigation.withNavigationFocus(CheckForPrompts)

return React.memo(v5)
