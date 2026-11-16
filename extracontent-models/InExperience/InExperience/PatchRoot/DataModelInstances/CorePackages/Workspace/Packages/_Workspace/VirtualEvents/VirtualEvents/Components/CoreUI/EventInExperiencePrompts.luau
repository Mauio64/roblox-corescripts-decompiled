local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

local useState = React.useState

local PromptConnections = require(parent.Components.CoreUI.PromptConnections)
local RsvpPrompt = require(parent.Components.CoreUI.RsvpPrompt)

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local defineFastFlag = game:DefineFastFlag("FixFocusWhenInGameMenuIsOpen", false)

local _ = { PromptRsvp = "PromptRsvp" }

local v = { PromptRsvp = RsvpPrompt }

return function(p)
	local state, setState = useState({ promptType = nil, promptData = nil, promptQueue = {} })

	local promptData = state.promptData
	local promptType = state.promptType

	local closePrompt = React.useCallback(function()
		if Cryo.isEmpty(state.promptQueue) then
			setState({ promptType = nil, promptData = {}, promptQueue = {} })
		else
			setState(Cryo.Dictionary.join(state, {
				promptType = state.promptQueue[1].promptType,
				promptData = state.promptQueue[1].promptData,
				promptQueue = Cryo.List.removeIndex(state.promptQueue, 1)
			}))
		end
	end, { state, setState })

	local prompt = nil

	if promptType then
		local v2 = v[promptType]

		if v2 then
			prompt = React.createElement(v2, {
				enableInputDelayed = p.enableInputDelayed,
				promptData = promptData,
				closePrompt = closePrompt,
				overrideUseWideMode = p.overrideUseWideMode
			})
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local openRsvpPrompt = React.useCallback(function(eventId: string, eventDetails)
		if state.promptType == nil then
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
