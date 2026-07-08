local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local useState = React.useState
local PromptConnections = require(ParentParent.Components.CoreUI.PromptConnections)
local RsvpPrompt = require(ParentParent.Components.CoreUI.RsvpPrompt)
local FocusNavigationUtils = require(ParentParentParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local v12 = game:DefineFastFlag("FixFocusWhenInGameMenuIsOpen", false)
local _ = {
	PromptRsvp = "PromptRsvp"
}
local t1 = {
	PromptRsvp = RsvpPrompt
}

return function(t2: {[any]: any}) -- line: 52
	-- upvalues: useState (copy), React (copy), Cryo (copy), t1 (copy), v12 (copy), GuiService (copy), PromptConnections (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v16, v17 = useState({
		promptType = nil,
		promptData = nil,
		promptQueue = {}
	})
	local promptData = v16.promptData
	local promptType = v16.promptType
	local v20 = React.useCallback(function() -- line: 62
		-- upvalues: Cryo (copy), v16 (copy), v17 (copy)
		if not Cryo.isEmpty(v16.promptQueue) then
			v17(Cryo.Dictionary.join(v16, {
				promptType = v16.promptQueue[1].promptType,
				promptData = v16.promptQueue[1].promptData,
				promptQueue = Cryo.List.removeIndex(v16.promptQueue, 1)
			}))

			return
		end

		v17({
			promptType = nil,
			promptData = {},
			promptQueue = {}
		})
	end, {
		v16,
		v17
	})
	local u21 = nil

	if promptType then
		local v22 = t1[promptType]

		if v22 then
			u21 = React.createElement(v22, {
				enableInputDelayed = t2.enableInputDelayed,
				promptData = promptData,
				closePrompt = v20,
				overrideUseWideMode = t2.overrideUseWideMode
			})
		else
			error(`Unexpected prompt type: { promptType }!`)
		end
	end

	local v23 = React.useCallback(function(s1: string, t3: {[any]: any}) -- line: 93
		-- upvalues: v16 (copy), v17 (copy), Cryo (copy)
		if v16.promptType ~= nil then
			v17(Cryo.Dictionary.join(v16, {
				promptQueue = Cryo.List.join(v16.promptQueue, {{
					promptType = "PromptRsvp",
					promptData = {
						eventId = s1,
						eventDetails = t3
					}
				}})
			}))

			return
		end

		v17({
			promptType = "PromptRsvp",
			promptData = {
				eventId = s1,
				eventDetails = t3
			},
			promptQueue = {}
		})
	end, {
		v16,
		v17
	})
	local v24 = nil
	local u25 = nil

	if v12 then
		local v26

		v24, v26 = React.useState(GuiService.MenuIsOpen)
		u25 = v26
		React.useEffect(function() -- line: 123
			-- upvalues: u21 (ref), u25 (ref), GuiService (copy)
			if not u21 then
				return
			end

			u25(GuiService.MenuIsOpen)

			local connection = GuiService.MenuOpened:Connect(function() -- line: 131
				-- upvalues: u25 (ref)
				u25(true)
			end)
			local connection2 = GuiService.MenuClosed:Connect(function() -- line: 134
				-- upvalues: u25 (ref)
				u25(false)
			end)

			return function() -- line: 137
				-- upvalues: connection (copy), connection2 (copy)
				connection:Disconnect()
				connection2:Disconnect()
			end
		end, { u21 })
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections, {
			openRsvpPrompt = v23,
			closePrompt = v20
		}),
		FocusNavigationCoreScriptsWrapper = if not u21 then nil else React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isFocusable = if not v12 then nil else not v24
		}, {
			Prompt = u21
		})
	})
end
