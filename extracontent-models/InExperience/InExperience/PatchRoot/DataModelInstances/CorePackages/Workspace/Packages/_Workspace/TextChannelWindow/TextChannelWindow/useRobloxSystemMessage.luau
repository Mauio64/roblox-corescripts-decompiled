local parent = script.Parent.Parent

local React = require(parent.React)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useInExperienceLocalization = ChatUIPrimitives.Hooks.useInExperienceLocalization
local FFlagExpChatMemoizeSystemMessage = require(script.Parent.Flags.FFlagExpChatMemoizeSystemMessage)

local function useRobloxSystemMessage()
	local v = MessageWriterContext.useMessageWriter()
	local v2 = useInExperienceLocalization()

	local displayRobloxSystemMessage = React.useCallback(function(p: string, p2: string)
		if not v then
			return
		end

		local v3 = v2(p)

		if v3 == "" then
			v3 = p2
		end

		if v3 == "" then
			return
		end

		v.write(Message.createSystemMessage(v3, "Roblox.ChatDisabled.Info"))
	end, { v, v2 })

	local clearAvailabilityMessage = React.useCallback(function()
		if v then
			v.remove("Roblox.ChatDisabled.Info")
		end
	end, { v })

	local v3 = React.useMemo(function()
		return {
			displayRobloxSystemMessage = displayRobloxSystemMessage,
			clearAvailabilityMessage = clearAvailabilityMessage
		}
	end, { displayRobloxSystemMessage, clearAvailabilityMessage })

	if FFlagExpChatMemoizeSystemMessage then
		return v3
	end

	return {
		displayRobloxSystemMessage = displayRobloxSystemMessage,
		clearAvailabilityMessage = clearAvailabilityMessage
	}
end

return useRobloxSystemMessage
