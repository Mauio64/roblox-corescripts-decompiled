local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function constantSource() -- line: 31
	return 0
end
local function ChatActionsRow(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), constantSource (copy), SignalsReact (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy)
	local v12 = React.useCallback(function(p1) -- line: 36
		-- upvalues: t1 (copy), constantSource (copy)
		if t1.getIsComposerEmpty ~= nil then
			return t1.getIsComposerEmpty(p1)
		end

		if typeof(p1) == "function" then
			p1(constantSource)
		end

		return t1.isComposerEmpty == true
	end, {
		t1.getIsComposerEmpty,
		t1.isComposerEmpty
	})
	local v13 = SignalsReact.useSignalState(v12)
	local v14 = t1.isAssistantResponding and (t1.canStopAssistantResponse ~= false and not (t1.canSendWhileResponding == true and not v13))
	local v15 = not v14 and (v13 or t1.isSendDisabled == true)

	return React.createElement(IconButton, {
		isCircular = true,
		LayoutOrder = t1.LayoutOrder,
		icon = if not v14 then IconName.ArrowWideShortUp else IconName.StopSmall,
		size = InputSize.Small,
		variant = if not v14 then if v13 then ButtonVariant.Standard else ButtonVariant.Emphasis else ButtonVariant.Standard,
		isDisabled = v15,
		onActivated = function() -- line: 61
			-- upvalues: v14 (copy), t1 (copy)
			if v14 then
				t1.onStop()

				return
			end

			t1.onSend()
		end
	})
end

return ChatActionsRow
