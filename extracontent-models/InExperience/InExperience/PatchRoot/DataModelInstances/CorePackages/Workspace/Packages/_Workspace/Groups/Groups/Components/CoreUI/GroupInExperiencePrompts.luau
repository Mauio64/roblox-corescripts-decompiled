local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

local useState = React.useState

local PromptConnections = require(parent.Components.CoreUI.PromptConnections)
local GroupJoinPrompt = require(parent.Components.CoreUI.GroupJoinPrompt)

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

require(parent.Common.Types)

local _ = { PromptJoinGroup = "PromptJoinGroup" }

local v = { PromptJoinGroup = GroupJoinPrompt }

return function(p)
	local state, setState = useState({
		promptType = nil,
		promptData = nil,
		data = nil,
		callbacks = nil,
		promptQueue = {}
	})

	local promptData = state.promptData
	local promptType = state.promptType
	local data = state.data
	local callbacks = state.callbacks

	local closePrompt = React.useCallback(function()
		if Cryo.isEmpty(state.promptQueue) then
			setState({
				promptType = nil,
				promptData = nil,
				data = nil,
				callbacks = nil,
				promptQueue = {}
			})
		else
			setState(Cryo.Dictionary.join(state, {
				promptType = state.promptQueue[1].promptType,
				promptData = state.promptQueue[1].promptData,
				data = state.promptQueue[1].data,
				callbacks = state.promptQueue[1].callbacks,
				promptQueue = Cryo.List.removeIndex(state.promptQueue, 1)
			}))
		end
	end, { state, setState })

	local prompt = nil

	if promptType then
		local v2 = v[promptType]

		if v2 then
			local createElement = React.createElement
			local v3 = {
				enableInputDelayed = p.enableInputDelayed,
				groupId = 0,
				data = 0,
				onJoin = 0,
				onClose = 0
			}
			local groupId

			if promptData then
				groupId = promptData.groupId
			end

			v3.groupId = groupId
			v3.data = data
			local onJoin

			if callbacks then
				onJoin = callbacks.onJoin
			end

			v3.onJoin = onJoin
			local onClose

			if callbacks then
				onClose = callbacks.onClose
			end

			v3.onClose = onClose
			prompt = createElement(v2, v3)
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local openGroupJoinPrompt = React.useCallback(function(groupId: number, p2, callbacks2)
		if state.promptType == nil then
			setState({
				promptType = "PromptJoinGroup",
				promptData = { groupId = groupId },
				data = p2,
				callbacks = callbacks2,
				promptQueue = {}
			})
		else
			setState(Cryo.Dictionary.join(state, {
				promptQueue = Cryo.List.join(state.promptQueue, {
					{
						promptType = "PromptJoinGroup",
						promptData = { groupId = groupId },
						data = p2,
						callbacks = callbacks2
					}
				})
			}))
		end
	end, { state, setState })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v2 = {
		PromptConnections = React.createElement(PromptConnections, {
			openGroupJoinPrompt = openGroupJoinPrompt,
			closePrompt = closePrompt
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local focusNavigationCoreScriptsWrapper

	if prompt then
		focusNavigationCoreScriptsWrapper = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{ Prompt = prompt }
		)
	end

	v2.FocusNavigationCoreScriptsWrapper = focusNavigationCoreScriptsWrapper
	return createElement(fragment, {}, v2)
end
