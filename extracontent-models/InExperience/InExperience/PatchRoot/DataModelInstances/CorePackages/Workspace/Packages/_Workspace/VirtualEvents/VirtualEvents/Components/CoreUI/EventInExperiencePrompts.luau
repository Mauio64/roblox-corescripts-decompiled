local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

local useState = React.useState

local PromptConnections = require(parent.Components.CoreUI.PromptConnections)
local RsvpPrompt = require(parent.Components.CoreUI.RsvpPrompt)
require(parent.Common.InGameRsvpPushUpsellTypes)

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local defineFastFlag = game:DefineFastFlag("FixFocusWhenInGameMenuIsOpen", false)
local SharedFlags = require(parent2.SharedFlags)
local FFlagInGameRsvpPushUpsellEnabled = SharedFlags.FFlagInGameRsvpPushUpsellEnabled
local FIntInGameRsvpPushUpsellDelayMs = require(parent.Flags.FIntInGameRsvpPushUpsellDelayMs)
local fetchInGameRsvpPushUpsell

if FFlagInGameRsvpPushUpsellEnabled then
	fetchInGameRsvpPushUpsell = require(parent.Common.fetchInGameRsvpPushUpsell)
else
	fetchInGameRsvpPushUpsell = nil
end

local isInGameMenuOpen

if FFlagInGameRsvpPushUpsellEnabled then
	isInGameMenuOpen = require(parent.Common.isInGameMenuOpen)
else
	isInGameMenuOpen = nil
end

local PushUpsellPromptContainer

if FFlagInGameRsvpPushUpsellEnabled then
	PushUpsellPromptContainer = require(parent.Components.CoreUI.PushUpsellPrompt.PushUpsellPromptContainer)
end

local _ = { PromptRsvp = "PromptRsvp", PromptPushUpsell = "PromptPushUpsell" }

local v = { PromptRsvp = RsvpPrompt }

if FFlagInGameRsvpPushUpsellEnabled then
	v.PromptPushUpsell = PushUpsellPromptContainer
end

local function enqueuePrompt(p, p2)
	if p.promptType == nil then
		return { promptType = p2.promptType, promptData = p2.promptData, promptQueue = {} }
	end

	return Cryo.Dictionary.join(p, {
		promptQueue = Cryo.List.join(p.promptQueue, { p2 })
	})
end

local function dequeuePrompt(p)
	if Cryo.isEmpty(p.promptQueue) then
		return { promptType = nil, promptData = {}, promptQueue = {} }
	end

	return Cryo.Dictionary.join(p, {
		promptType = p.promptQueue[1].promptType,
		promptData = p.promptQueue[1].promptData,
		promptQueue = Cryo.List.removeIndex(p.promptQueue, 1)
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

	local v2 = React.useCallback(function(promptData)
		if ref2.current then
			return
		end

		ref2.current = true
		callback(function(p)
			return enqueuePrompt(p, { promptType = "PromptPushUpsell", promptData = promptData })
		end)
	end, { callback })

	return React.useCallback(function(eventId: string)
		fetchInGameRsvpPushUpsell.fetch():andThen(function(data)
			if data == nil then
				return
			end

			task.delay(FIntInGameRsvpPushUpsellDelayMs / 1000, function()
				if ref.current and not isInGameMenuOpen() then
					v2({
						promptType = data.promptType,
						path = data.path,
						translations = data.translations,
						eventId = eventId
					})
				end
			end)
		end)
	end, { v2 })
end

local function usePushUpsellPromptQueueDisabled(_): nil
	return nil
end

if FFlagInGameRsvpPushUpsellEnabled then
	usePushUpsellPromptQueueDisabled = usePushUpsellPromptQueue
end

return function(p)
	local state, setState = useState({ promptType = nil, promptData = nil, promptQueue = {} })

	local promptData = state.promptData
	local promptType = state.promptType

	local closePrompt = React.useCallback(function()
		if FFlagInGameRsvpPushUpsellEnabled then
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

	local onRsvpGoingSucceeded = usePushUpsellPromptQueueDisabled(setState)

	local prompt = nil

	if promptType then
		local v2 = v[promptType]

		if v2 then
			prompt = React.createElement(v2, {
				enableInputDelayed = p.enableInputDelayed,
				promptData = promptData,
				closePrompt = closePrompt,
				overrideUseWideMode = p.overrideUseWideMode,
				onRsvpGoingSucceeded = onRsvpGoingSucceeded
			})
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local openRsvpPrompt = React.useCallback(function(eventId: string, eventDetails)
		if FFlagInGameRsvpPushUpsellEnabled then
			setState(function(p2)
				return enqueuePrompt(p2, {
					promptType = "PromptRsvp",
					promptData = { eventId = eventId, eventDetails = eventDetails }
				})
			end)
		elseif state.promptType == nil then
			setState({
				promptType = "PromptRsvp",
				promptData = { eventId = eventId, eventDetails = eventDetails },
				promptQueue = {}
			})
		else
			setState(Cryo.Dictionary.join(state, {
				promptQueue = Cryo.List.join(state.promptQueue, {
					{
						promptType = "PromptRsvp",
						promptData = { eventId = eventId, eventDetails = eventDetails }
					}
				})
			}))
		end
	end, { state, setState })

	local state2 = nil
	local v2 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(GuiService.MenuIsOpen)
		v2 = setState2

		React.useEffect(function()
			if not prompt then
				return
			end

			v2(GuiService.MenuIsOpen)

			local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
				v2(true)
			end)
			local menuClosedConnection = GuiService.MenuClosed:Connect(function()
				v2(false)
			end)
			return function()
				menuOpenedConnection:Disconnect()
				menuClosedConnection:Disconnect()
			end
		end, { prompt })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v3 = {
		PromptConnections = React.createElement(PromptConnections, {
			openRsvpPrompt = openRsvpPrompt,
			closePrompt = closePrompt
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local focusNavigationCoreScriptsWrapper

	if prompt then
		local createElement2 = React.createElement
		local v4 = {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true,
			isFocusable = 0
		}
		local isFocusable

		if defineFastFlag then
			isFocusable = not state2
		end

		v4.isFocusable = isFocusable
		focusNavigationCoreScriptsWrapper = createElement2(FocusRoot, v4, { Prompt = prompt })
	end

	v3.FocusNavigationCoreScriptsWrapper = focusNavigationCoreScriptsWrapper
	return createElement(fragment, {}, v3)
end
