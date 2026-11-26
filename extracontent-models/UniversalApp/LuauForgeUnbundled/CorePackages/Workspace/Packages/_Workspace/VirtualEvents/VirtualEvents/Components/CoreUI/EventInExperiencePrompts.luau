local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")

local useState = React.useState

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PromptConnections")
local RsvpPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/RsvpPrompt")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/InGameRsvpPushUpsellTypes")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local defineFastFlag = game:DefineFastFlag("FixFocusWhenInGameMenuIsOpen", false)
local fFlagInGameRsvpPushUpsellEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagInGameRsvpPushUpsellEnabled
local FIntInGameRsvpPushUpsellDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FIntInGameRsvpPushUpsellDelayMs")

local v5 = if fFlagInGameRsvpPushUpsellEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchInGameRsvpPushUpsell") else nil

local v6 = if fFlagInGameRsvpPushUpsellEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/isInGameMenuOpen") else nil

local v7 = if fFlagInGameRsvpPushUpsellEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PushUpsellPrompt/PushUpsellPromptContainer") else nil

local v8 = { PromptRsvp = "PromptRsvp", PromptPushUpsell = "PromptPushUpsell" }

local v9 = { PromptRsvp = RsvpPrompt }

if fFlagInGameRsvpPushUpsellEnabled then
	v9.PromptPushUpsell = v7
end

local function enqueuePrompt(p2, p3)
	if p2.promptType == nil then
		return {
			promptType = p3.promptType,
			promptData = p3.promptData,
			promptQueue = {}
		}
	end

	return Cryo.Dictionary.join(p2, {
		promptQueue = Cryo.List.join(p2.promptQueue, { p3 })
	})
end

local function dequeuePrompt(p2)
	if Cryo.isEmpty(p2.promptQueue) then
		return { promptType = nil, promptData = {}, promptQueue = {} }
	end

	return Cryo.Dictionary.join(p2, {
		promptType = p2.promptQueue[1].promptType,
		promptData = p2.promptQueue[1].promptData,
		promptQueue = Cryo.List.removeIndex(p2.promptQueue, 1)
	})
end

local function usePushUpsellPromptQueue(callback)
	local ref = React.useRef(true)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local ref2 = React.useRef(false)

	local v10 = React.useCallback(function(p2)
		if ref2.current then
			return
		end

		ref2.current = true
		callback(function(p3)
			return enqueuePrompt(p3, {
				promptType = "PromptPushUpsell",
				promptData = p2
			})
		end)
	end, { callback })

	return React.useCallback(function(p2)
		v5.fetch():andThen(function(data)
			if data == nil then
				return
			end

			task.delay(FIntInGameRsvpPushUpsellDelayMs / 1000, function()
				if ref.current and not v6() then
					v10({
						promptType = data.promptType,
						path = data.path,
						translations = data.translations,
						eventId = p2
					})
				end
			end)
		end)
	end, { v10 })
end

local function usePushUpsellPromptQueueDisabled(p2): nil
	return nil
end

if fFlagInGameRsvpPushUpsellEnabled then
	usePushUpsellPromptQueueDisabled = usePushUpsellPromptQueue
end

return function(p2)
	local state, setState = useState({
		promptType = nil,
		promptData = nil,
		promptQueue = {}
	})

	local promptData = state.promptData
	local promptType = state.promptType

	local v10 = React.useCallback(function()
		if fFlagInGameRsvpPushUpsellEnabled then
			setState(dequeuePrompt)
		elseif Cryo.isEmpty(state.promptQueue) then
			setState({ promptType = nil, promptData = {}, promptQueue = {} })
		else
			setState(Cryo.Dictionary.join(state, {
				promptType = state.promptQueue[1].promptType,
				promptData = state.promptQueue[1].promptData,
				promptQueue = Cryo.List.removeIndex(state.promptQueue, 1)
			}))
		end
	end, { state, setState })

	local v11 = usePushUpsellPromptQueueDisabled(setState)

	local v12 = nil

	if promptType then
		local v13 = v9[promptType]

		if v13 then
			v12 = React.createElement(v13, {
				enableInputDelayed = p2.enableInputDelayed,
				promptData = promptData,
				closePrompt = v10,
				overrideUseWideMode = p2.overrideUseWideMode,
				onRsvpGoingSucceeded = v11
			})
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local v13 = React.useCallback(function(p3, p4)
		if fFlagInGameRsvpPushUpsellEnabled then
			setState(function(p5)
				return enqueuePrompt(p5, {
					promptType = "PromptRsvp",
					promptData = { eventId = p3, eventDetails = p4 }
				})
			end)
		elseif state.promptType == nil then
			setState({
				promptType = "PromptRsvp",
				promptData = { eventId = p3, eventDetails = p4 },
				promptQueue = {}
			})
		else
			setState(Cryo.Dictionary.join(state, {
				promptQueue = Cryo.List.join(state.promptQueue, {
					{
						promptType = "PromptRsvp",
						promptData = { eventId = p3, eventDetails = p4 }
					}
				})
			}))
		end
	end, { state, setState })

	local state2 = nil
	local v14 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(GuiService.MenuIsOpen)
		v14 = setState2

		React.useEffect(function()
			if not v12 then
				return
			end

			v14(GuiService.MenuIsOpen)

			local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
				v14(true)
			end)
			local menuClosedConnection = GuiService.MenuClosed:Connect(function()
				v14(false)
			end)
			return function()
				menuOpenedConnection:Disconnect()
				menuClosedConnection:Disconnect()
			end
		end, { v12 })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v16 = {
		PromptConnections = React.createElement(module3, {
			openRsvpPrompt = v13,
			closePrompt = v10
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local v17

	if v12 then
		v17 = React.createElement(focusRoot, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true,
			isFocusable = if defineFastFlag then not state2 else nil
		}, { Prompt = v12 })
	end

	v16.FocusNavigationCoreScriptsWrapper = v17
	return createElement(fragment, {}, v16)
end
