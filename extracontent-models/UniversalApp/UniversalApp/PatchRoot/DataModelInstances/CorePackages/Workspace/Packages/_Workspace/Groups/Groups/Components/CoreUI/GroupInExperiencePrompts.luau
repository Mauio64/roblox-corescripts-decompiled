local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local useState = React.useState
local PromptConnections = require(ParentParent.Components.CoreUI.PromptConnections)
local GroupJoinPrompt = require(ParentParent.Components.CoreUI.GroupJoinPrompt)
local FocusNavigationUtils = require(ParentParentParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

require(ParentParent.Common.Types)

local _ = {
	PromptJoinGroup = "PromptJoinGroup"
}
local t1 = {
	PromptJoinGroup = GroupJoinPrompt
}

return function(t2: {[any]: any}) -- line: 54
	-- upvalues: useState (copy), React (copy), Cryo (copy), t1 (copy), PromptConnections (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v14, v15 = useState({
		promptType = nil,
		promptData = nil,
		data = nil,
		callbacks = nil,
		promptQueue = {}
	})
	local promptData = v14.promptData
	local promptType = v14.promptType
	local data = v14.data
	local callbacks = v14.callbacks
	local v20 = React.useCallback(function() -- line: 68
		-- upvalues: Cryo (copy), v14 (copy), v15 (copy)
		if not Cryo.isEmpty(v14.promptQueue) then
			v15(Cryo.Dictionary.join(v14, {
				promptType = v14.promptQueue[1].promptType,
				promptData = v14.promptQueue[1].promptData,
				data = v14.promptQueue[1].data,
				callbacks = v14.promptQueue[1].callbacks,
				promptQueue = Cryo.List.removeIndex(v14.promptQueue, 1)
			}))

			return
		end

		v15({
			promptType = nil,
			promptData = nil,
			data = nil,
			callbacks = nil,
			promptQueue = {}
		})
	end, {
		v14,
		v15
	})
	local v21 = nil

	if promptType then
		local v22 = t1[promptType]

		if v22 then
			v21 = React.createElement(v22, {
				enableInputDelayed = t2.enableInputDelayed,
				groupId = if not promptData then nil else promptData.groupId,
				data = data,
				onJoin = if not callbacks then nil else callbacks.onJoin,
				onClose = if not callbacks then nil else callbacks.onClose
			})
		else
			error(`Unexpected prompt type: { promptType }!`)
		end
	end

	local v23 = React.useCallback(function(n1: number, p1, p2) -- line: 105
		-- upvalues: v14 (copy), v15 (copy), Cryo (copy)
		if v14.promptType ~= nil then
			v15(Cryo.Dictionary.join(v14, {
				promptQueue = Cryo.List.join(v14.promptQueue, {{
					promptType = "PromptJoinGroup",
					promptData = {
						groupId = n1
					},
					data = p1,
					callbacks = p2
				}})
			}))

			return
		end

		v15({
			promptType = "PromptJoinGroup",
			promptData = {
				groupId = n1
			},
			data = p1,
			callbacks = p2,
			promptQueue = {}
		})
	end, {
		v14,
		v15
	})

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections, {
			openGroupJoinPrompt = v23,
			closePrompt = v20
		}),
		FocusNavigationCoreScriptsWrapper = if not v21 then nil else React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Prompt = v21
		})
	})
end
