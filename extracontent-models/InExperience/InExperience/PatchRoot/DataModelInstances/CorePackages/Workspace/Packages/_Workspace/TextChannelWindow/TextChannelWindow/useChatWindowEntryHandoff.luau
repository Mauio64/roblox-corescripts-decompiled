local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local React = require(parent.React)
local useSelectionActivateAction = require(script.Parent.FocusNavigation.useSelectionActivateAction)

local function useChatWindowEntryHandoff(data)
	local guiService = data.guiService or GuiService
	local enabled = data.enabled
	local windowInstance = data.windowInstance
	local focusTargetRef = data.focusTargetRef

	local ref = React.useRef(data.setSelection)
	ref.current = data.setSelection

	React.useEffect(function()
		if not enabled or windowInstance == nil then
			return
		end

		local selectable = windowInstance.Selectable
		windowInstance.Selectable = true
		return function()
			windowInstance.Selectable = selectable

			if focusTargetRef.current ~= nil and guiService.SelectedCoreObject == focusTargetRef.current then
				guiService.SelectedCoreObject = nil

				if windowInstance:IsDescendantOf(game) then
					guiService.SelectedObject = windowInstance
				end
			end
		end
	end, { enabled, windowInstance, focusTargetRef, guiService })

	local onAction = React.useCallback(function(p)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Sink
		end

		local current = focusTargetRef.current

		if current ~= nil then
			local current2 = ref.current

			if current2 then
				current2(current)
			else
				guiService.SelectedCoreObject = current
			end
		end

		guiService.SelectedObject = nil

		return Enum.ContextActionResult.Sink
	end, { guiService, focusTargetRef })

	local shouldBind = React.useCallback(function(): boolean
		return guiService.SelectedObject == windowInstance
	end, { guiService, windowInstance })

	local rebindSignal = React.useMemo(function()
		if windowInstance == nil then
			return nil
		end

		return (guiService:GetPropertyChangedSignal("SelectedObject"))
	end, { guiService, windowInstance })

	useSelectionActivateAction({
		enabled = enabled,
		active = windowInstance ~= nil,
		actionNamePrefix = "EnterTextChannelWindow",
		onAction = onAction,
		shouldBind = shouldBind,
		rebindSignal = rebindSignal,
		contextActionService = data.contextActionService
	})
end

return useChatWindowEntryHandoff
