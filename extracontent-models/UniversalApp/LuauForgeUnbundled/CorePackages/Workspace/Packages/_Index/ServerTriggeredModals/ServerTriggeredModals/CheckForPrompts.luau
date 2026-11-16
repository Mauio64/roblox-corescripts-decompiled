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

local fFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local fFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle

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
	local v10

	if fFlagEnableHomepagePromptsForModalsAndBanners then
		v10 = usePromptEntries("HomepagePrompts", PromptStyle.Modal)[1]
	else
		v10 = useSignalState((React.useCallback(function(p3)
			local data = getSduiApiStore().getData("HomepagePrompts").data(p3)
			return data and data.HomepagePrompts
		end, {})))
	end

	React.useEffect(function()
		if v8 or v7 or not isFocused then
			return
		end

		local v11 = v10
		local v12

		if v11 == nil or v11.config == nil or v11.identifier == nil or v11.robloxComponentType == nil then
			v12 = false
		else
			v12 = v11.title ~= nil
		end

		if not v12 then
			return
		end

		v6.setHasShown(EntryPoint.HomepageLaunch, true)
		local sduiPromptModal = centralOverlayType.SduiPromptModal
		local v15 = {
			configKey = "HomepagePrompts",
			appPage = appPage.Home,
			modalId = v10.identifier,
			modalType = 0
		}
		local v16 = if fFlagPromptsImpressionUsesTitle then v10.title else v10.robloxComponentType
		v15.modalType = v16
		v5(setCentralOverlay(sduiPromptModal, v15))
	end, { v8, v7, isFocused, v5, v6, v10 })

	return nil
end

local v5 = RoactNavigation.withNavigationFocus(CheckForPrompts)

return React.memo(v5)
