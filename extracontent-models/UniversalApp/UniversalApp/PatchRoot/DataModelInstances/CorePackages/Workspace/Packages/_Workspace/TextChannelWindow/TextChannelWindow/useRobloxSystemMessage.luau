local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(script.Parent.ChatApp)

local MessageWriterContext = require(script.Parent.MessageWriterContext)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)

local function useRobloxSystemMessage() -- line: 18
	-- upvalues: MessageWriterContext (copy), useInExperienceLocalization (copy), React (copy)
	local v6 = MessageWriterContext.useMessageWriter()
	local v7 = useInExperienceLocalization()
	local v8 = React.useCallback(function(s1: string, s2: string) -- line: 22
		-- upvalues: v6 (copy), v7 (copy)
		if not v6 then
			return
		end

		local v12 = v7(s1)

		if v12 == "" then
			v12 = s2
		end

		if v12 == "" then
			return
		end

		v6.write({
			messageType = "system-roblox",
			messageId = "Roblox.ChatDisabled.Info",
			content = v12,
			timestamp = DateTime.now()
		})
	end, {
		v6,
		v7
	})
	local v9 = React.useCallback(function() -- line: 41
		-- upvalues: v6 (copy)
		if v6 then
			v6.remove("Roblox.ChatDisabled.Info")
		end
	end, { v6 })

	return {
		displayRobloxSystemMessage = v8,
		clearAvailabilityMessage = v9
	}
end

return useRobloxSystemMessage
