local parent = script.Parent.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local Foundation = require(parent.Foundation)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)

local FFlagExpChatTextChannelWindowWelcomeAndSummary = require(script.Parent.Flags.FFlagExpChatTextChannelWindowWelcomeAndSummary)

local useInExperienceLocalization = ChatUIPrimitives.Hooks.useInExperienceLocalization

local object = setmetatable({}, { __mode = "k" })

local function useSummarySystemMessage(p, callback)
	local v = MessageWriterContext.useMessageWriter()
	local v2 = useInExperienceLocalization()

	React.useEffect(function()
		if not FFlagExpChatTextChannelWindowWelcomeAndSummary or (not v or p == nil) then
			return
		end

		local v3 = p

		if v3.Name == "RBXGeneral" then
			return (Signals.createEffect(function(p2)
				if not callback(p2) or object[v3] then
					return
				end

				local v4 = v2("CoreScripts.TextChat.ChatWindow.SummarySystemMessage")
				local v5 = v4 == "" and "Roblox auto-generates summaries of players' messages." or v4

				object[v3] = true
				v.write(Message.createExperienceSystemMessage(
					v5,
					"Roblox.Summary.Info:" .. v3.Name,
					Foundation.Enums.IconName.Nebula
				))
			end))
		end
	end, { v, v2, p, callback })
end

return useSummarySystemMessage
