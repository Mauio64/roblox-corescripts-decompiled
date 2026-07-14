local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)

local function useRobloxSystemMessage() -- line: 17
	-- upvalues: MessageWriterContext (copy), useInExperienceLocalization (copy), React (copy), Message (copy)
	local v7 = MessageWriterContext.useMessageWriter()
	local v8 = useInExperienceLocalization()
	local v9 = React.useCallback(function(s1: string, s2: string) -- line: 21
		-- upvalues: v7 (copy), v8 (copy), Message (copy)
		if not v7 then
			return
		end

		local v13 = v8(s1)

		if v13 == "" then
			v13 = s2
		end

		if v13 == "" then
			return
		end

		v7.write(Message.createSystemMessage(v13, "Roblox.ChatDisabled.Info"))
	end, {
		v7,
		v8
	})
	local v10 = React.useCallback(function() -- line: 35
		-- upvalues: v7 (copy)
		if v7 then
			v7.remove("Roblox.ChatDisabled.Info")
		end
	end, { v7 })

	return {
		displayRobloxSystemMessage = v9,
		clearAvailabilityMessage = v10
	}
end

return useRobloxSystemMessage
