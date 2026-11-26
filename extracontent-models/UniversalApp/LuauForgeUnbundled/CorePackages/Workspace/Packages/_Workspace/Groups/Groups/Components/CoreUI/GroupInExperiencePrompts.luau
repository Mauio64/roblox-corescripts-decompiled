local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Cryo")

local useState = React.useState

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/CoreUI/PromptConnections")
local GroupJoinPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/CoreUI/GroupJoinPrompt")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")

local v5 = { PromptJoinGroup = "PromptJoinGroup" }

local v6 = { PromptJoinGroup = GroupJoinPrompt }

return function(p2)
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

	local v7 = React.useCallback(function()
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

	local v8 = nil

	if promptType then
		local v9 = v6[promptType]

		if v9 then
			local createElement = React.createElement
			local v10 = {
				enableInputDelayed = p2.enableInputDelayed,
				groupId = 0,
				data = 0,
				onJoin = 0,
				onClose = 0
			}
			local v11 = if promptData then promptData.groupId else nil
			v10.groupId = v11
			v10.data = data
			local v12 = if callbacks then callbacks.onJoin else nil
			v10.onJoin = v12
			local v13 = if callbacks then callbacks.onClose else nil
			v10.onClose = v13
			v8 = createElement(v9, v10)
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	local v9 = React.useCallback(function(p3, p4, p5)
		if state.promptType == nil then
			setState({
				promptType = "PromptJoinGroup",
				promptData = { groupId = p3 },
				data = p4,
				callbacks = p5,
				promptQueue = {}
			})
		else
			setState(Cryo.Dictionary.join(state, {
				promptQueue = Cryo.List.join(state.promptQueue, {
					{
						promptType = "PromptJoinGroup",
						promptData = { groupId = p3 },
						data = p4,
						callbacks = p5
					}
				})
			}))
		end
	end, { state, setState })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v11 = {
		PromptConnections = React.createElement(module3, {
			openGroupJoinPrompt = v9,
			closePrompt = v7
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}

	local v12 = if v8 then React.createElement(
		focusRoot,
		{
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true
		},
		{ Prompt = v8 }
	) else nil
	v11.FocusNavigationCoreScriptsWrapper = v12
	return createElement(fragment, {}, v11)
end
