local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")

local useState = React.useState

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PromptConnections")
local RsvpPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/RsvpPrompt")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local defineFastFlag = game:DefineFastFlag("FixFocusWhenInGameMenuIsOpen", false)

local v5 = { PromptRsvp = "PromptRsvp" }

local v6 = { PromptRsvp = RsvpPrompt }

return function(p2)
	local state, setState = useState({
		promptType = nil,
		promptData = nil,
		promptQueue = {}
	})

	local promptData = state.promptData
	local promptType = state.promptType

	local v7 = React.useCallback(function()
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

	local v8 = nil

	if promptType then
		local v9 = v6[promptType]

		if v9 then
			v8 = React.createElement(v9, {
				enableInputDelayed = p2.enableInputDelayed,
				promptData = promptData,
				closePrompt = v7,
				overrideUseWideMode = p2.overrideUseWideMode
			})
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local v9 = React.useCallback(function(p3, p4)
		if state.promptType == nil then
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
	local v10 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(GuiService.MenuIsOpen)
		v10 = setState2

		React.useEffect(function()
			if not v8 then
				return
			end

			v10(GuiService.MenuIsOpen)

			local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
				v10(true)
			end)
			local menuClosedConnection = GuiService.MenuClosed:Connect(function()
				v10(false)
			end)
			return function()
				menuOpenedConnection:Disconnect()
				menuClosedConnection:Disconnect()
			end
		end, { v8 })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v12 = {
		PromptConnections = React.createElement(module3, {
			openRsvpPrompt = v9,
			closePrompt = v7
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local v13

	if v8 then
		v13 = React.createElement(focusRoot, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true,
			isFocusable = if defineFastFlag then not state2 else nil
		}, { Prompt = v8 })
	end

	v12.FocusNavigationCoreScriptsWrapper = v13
	return createElement(fragment, {}, v12)
end
