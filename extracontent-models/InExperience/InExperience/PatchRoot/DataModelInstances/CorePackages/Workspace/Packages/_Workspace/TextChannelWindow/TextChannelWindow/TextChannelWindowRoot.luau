local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Signals = require(ParentParent.Signals)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local TextChannelWindowPerfTracker = require(ParentParent.ChatUIPrimitives).Telemetry.TextChannelWindowPerfTracker
local ChatApp = require(script.Parent.ChatApp)

require(script.Parent.Message)

local mountToTargetInstance = require(script.Parent.mountToTargetInstance)
local useTextChannelWindowProps = require(script.Parent.useTextChannelWindowProps)
local useLocalUserInTextChannel = require(script.Parent.useLocalUserInTextChannel)
local useRobloxSystemMessage = require(script.Parent.useRobloxSystemMessage)
local ChatAvailabilityContext = require(script.Parent.ChatAvailabilityContext)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local createChannelMessagesStore = require(script.Parent.createChannelMessagesStore)
local TextChatServiceBridge = require(script.Parent.TextChatServiceBridge)
local TextChatService = game:GetService("TextChatService")
local useLocalUserChatAvailability = ChatAvailabilityContext.useLocalUserChatAvailability
local v17 = Signals.createSignal({})

local function getWindowName(p1) -- line: 24
	return p1.Name
end
local function getTargetName(p2) -- line: 28
	local p2Target = p2.Target

	if p2Target and p2Target:IsA("TextChannel") then
		return p2Target.Name
	end

	return nil
end
local function TextChannelWindowRoot(t1: {[any]: any}) -- line: 43
	-- upvalues: useTextChannelWindowProps (copy), useLocalUserInTextChannel (copy), useLocalUserChatAvailability (copy), useRobloxSystemMessage (copy), React (copy), v17 (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), TextChatService (copy), Signals (copy), ChatApp (copy)
	local v30 = useTextChannelWindowProps(t1.textChannelWindow)
	local target = v30.target
	local v32 = useLocalUserInTextChannel(target, t1.localUserId)
	local v33 = if target ~= nil then v32 and "member" or "not-member" else "no-channel"
	local v34 = if v33 ~= "member" then nil else target
	local v35 = useLocalUserChatAvailability()
	local v36 = useRobloxSystemMessage()
	local v37 = React.useMemo(function() -- line: 63
		-- upvalues: v34 (copy), t1 (copy), v17 (copy)
		if v34 then
			return t1.getChannelMessages(v34)
		end

		return v17
	end, {
		v34,
		t1.getChannelMessages,
		v17
	})

	React.useEffect(function() -- line: 70
		-- upvalues: v35 (copy), v36 (copy)
		if v35.messageKey then
			v36.displayRobloxSystemMessage(v35.messageKey, v35.messageFallback or "")
		end

		return v36.clearAvailabilityMessage
	end, {
		v36,
		v35.messageKey,
		v35.messageFallback
	})

	local textChannelWindowName = t1.textChannelWindow.Name
	local v39 = React.useRef(false)
	local loadStartTime = t1.loadStartTime

	React.useEffect(function() -- line: 82
		-- upvalues: v39 (copy), TextChannelWindowPerfTracker (copy), textChannelWindowName (copy), TextChannelWindowAnalytics (copy), loadStartTime (copy), TextChatService (copy)
		if not v39.current then
			v39.current = true
			TextChannelWindowPerfTracker.finishMountTTI(textChannelWindowName)

			if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() and loadStartTime then
				local v61 = os.clock() - loadStartTime

				TextChatService:SendExpChatLoadSuccess(v61, nil, "text_channel_window", textChannelWindowName)
			end
		end
	end, {
		textChannelWindowName,
		loadStartTime
	})

	local v41 = React.useRef({})

	React.useEffect(function() -- line: 96
		-- upvalues: TextChannelWindowAnalytics (copy), Signals (copy), v37 (copy), v41 (copy), TextChatService (copy), textChannelWindowName (copy)
		if not TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() or not TextChannelWindowAnalytics.getFFlagExpChatUseUpdatedMessageRendered() then
			return
		end

		return (Signals.createEffect(function(p3) -- line: 103
			-- upvalues: v37 (copy), v41 (copy), TextChannelWindowAnalytics (copy), TextChatService (copy), textChannelWindowName (copy)
			for _, v84 in (v37(p3)) do
				local messageId = v84.messageId

				if messageId and not v41.current[messageId] then
					v41.current[messageId] = true

					if TextChannelWindowAnalytics.shouldSendMessageRenderedTelemetry() then
						local textChatMessageInstance = v84.textChatMessageInstance

						if textChatMessageInstance then
							if game:GetEngineFeature("ExpChatGlobalChatEngineTelemetryEnabled") then
								TextChatService:SendExpChatMessageClientRendered(textChatMessageInstance, "text_channel_window", -1, textChannelWindowName)
							else
								TextChatService:SendExpChatMessageClientRendered(textChatMessageInstance, "text_channel_window")
							end
						end
					end
				end
			end
		end))
	end, {
		v37,
		textChannelWindowName
	})

	return React.createElement(ChatApp, {
		messagesSignal = v37,
		localUserId = t1.localUserId,
		targetChannel = v34,
		channelState = v33,
		canLocalUserChat = v35.canChat,
		backgroundColor = v30.backgroundColor,
		windowName = textChannelWindowName
	})
end

local v21 = React.Component:extend("TextChannelWindowErrorBoundary")

function v21.init(p4) -- line: 146
	p4.state = {
		hasError = false
	}
end
function v21.getDerivedStateFromError(_) -- line: 150
	return {
		hasError = true
	}
end
function v21.componentDidCatch(_, _, _) -- line: 154
end
function v21.render(p9) -- line: 156
	if p9.state.hasError then
		return nil
	end

	return p9.props.children
end

local function onScriptError(_: string, _: string?, _) -- line: 164
end

local t2 = {}
local t3 = {}
local u25 = false

return {
	start = function() -- line: 173
		-- upvalues: createChannelMessagesStore (copy), TextChannelWindowAnalytics (copy), t3 (copy), TextChatService (copy), t2 (copy), TextChannelWindowPerfTracker (copy), React (copy), v21 (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), TextChannelWindowRoot (copy), mountToTargetInstance (copy), u25 (ref), onScriptError (copy), TextChatServiceBridge (copy)
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		local str = tostring(LocalPlayer.UserId)
		local v54 = createChannelMessagesStore()

		local function flushWindowStatus(p11) -- line: 183
			-- upvalues: TextChannelWindowAnalytics (copy), t3 (copy), TextChatService (copy)
			if not TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
				return
			end

			local v63 = t3[p11]

			if v63 then
				local v64 = os.clock() - v63.lastChangeTime
				local v65 = v63.openDuration + (not v63.isOpen and 0 or v64)
				local v66 = v63.closedDuration + (v63.isOpen and 0 or v64)

				TextChatService:SendExpChatWindowStatusChange(v66, v65, 0, 0, "text_channel_window", p11.Name)
				t3[p11] = nil
			end
		end
		local function onRemoved(p12) -- line: 204
			-- upvalues: t2 (copy), TextChannelWindowPerfTracker (copy), flushWindowStatus (copy)
			local v68 = t2[p12]

			if v68 then
				local p12Target = p12.Target
				local v70 = if not p12Target or not p12Target:IsA("TextChannel") then nil else p12Target.Name

				if v70 then
					TextChannelWindowPerfTracker.cancelForChannel(v70)
				end

				flushWindowStatus(p12)
				v68()
				t2[p12] = nil
			end
		end
		local function onAdded(p13) -- line: 218
			-- upvalues: v54 (copy), TextChannelWindowAnalytics (copy), React (copy), v21 (copy), MessageWriterContext (copy), ChatAvailabilityContext (copy), LocalPlayer (copy), TextChannelWindowRoot (copy), str (copy), TextChannelWindowPerfTracker (copy), mountToTargetInstance (copy), t2 (copy), t3 (copy), flushWindowStatus (copy)
			local v72 = if not TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then nil else os.clock()
			local v73 = React.createElement(v21, nil, {
				inner = React.createElement(MessageWriterContext.Provider, {
					upsertMessage = function(p14) -- line: 219
						-- upvalues: p13 (copy), v54 (copy)
						local p13Target = p13.Target

						if p13Target and p13Target:IsA("TextChannel") then
							v54.upsertMessage(p13Target, p14)
						end
					end,
					removeMessage = function(s3: string) -- line: 226
						-- upvalues: p13 (copy), v54 (copy)
						local p13Target = p13.Target

						if p13Target and p13Target:IsA("TextChannel") then
							v54.removeMessage(p13Target, s3)
						end
					end
				}, {
					availability = React.createElement(ChatAvailabilityContext.Provider, {
						subjectPlayer = LocalPlayer
					}, {
						root = React.createElement(TextChannelWindowRoot, {
							localUserId = str,
							textChannelWindow = p13,
							getChannelMessages = v54.getMessagesForChannel,
							loadStartTime = v72
						})
					})
				})
			})

			TextChannelWindowPerfTracker.startMountTTI(p13.Name)

			local v74 = mountToTargetInstance(p13, v73)

			if v74 then
				t2[p13] = v74

				local p13Target = p13.Target
				local v76 = if not p13Target or not p13Target:IsA("TextChannel") then nil else p13Target.Name

				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Mount, {
					result = "success",
					has_target = v76 ~= nil,
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(v76)
				})
			else
				local p13Target = p13.Target
				local v78 = if not p13Target or not p13Target:IsA("TextChannel") then nil else p13Target.Name

				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Mount, {
					result = "failed",
					has_target = v78 ~= nil,
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(v78)
				})
			end

			if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
				local v79 = p13.IsRendering == true

				t3[p13] = {
					openDuration = 0,
					closedDuration = 0,
					isOpen = v79,
					lastChangeTime = os.clock()
				}
				p13:GetPropertyChangedSignal("IsRendering"):Connect(function() -- line: 285
					-- upvalues: t3 (copy), p13 (copy)
					local v91 = t3[p13]

					if v91 then
						local elapsed = os.clock()
						local v93 = elapsed - v91.lastChangeTime
						local v94 = p13.IsRendering == true

						t3[p13] = {
							isOpen = v94,
							lastChangeTime = elapsed,
							openDuration = v91.openDuration + (not v91.isOpen and 0 or v93),
							closedDuration = v91.closedDuration + (v91.isOpen and 0 or v93)
						}
					end
				end)
			end

			p13.AncestryChanged:Connect(function() -- line: 301
				-- upvalues: p13 (copy), t2 (copy), TextChannelWindowPerfTracker (copy), flushWindowStatus (copy)
				if not p13:IsDescendantOf(game) then
					local v95 = p13
					local v96 = t2[v95]

					if v96 then
						local Target = v95.Target
						local v98 = if not Target or not Target:IsA("TextChannel") then nil else Target.Name

						if v98 then
							TextChannelWindowPerfTracker.cancelForChannel(v98)
						end

						flushWindowStatus(v95)
						v96()
						t2[v95] = nil
					end
				end
			end)
		end

		if not u25 then
			u25 = true
			game:GetService("ScriptContext").Error:Connect(onScriptError)
		end

		local TextChatService2 = game:GetService("TextChatService")

		TextChatServiceBridge(TextChatService2, str, v54)

		for _, v60 in TextChatService2:GetTextChannelWindows() do
			onAdded(v60)
		end

		TextChatService2.TextChannelWindowAdded:Connect(onAdded)
		TextChatService2.TextChannelWindowRemoved:Connect(onRemoved)

		if TextChannelWindowAnalytics.getFFlagExpChatTelemetryEnabled() then
			Players.PlayerRemoving:Connect(function(player) -- line: 325
				-- upvalues: LocalPlayer (copy), t3 (copy), flushWindowStatus (copy)
				if player == LocalPlayer then
					for v81 in t3 do
						flushWindowStatus(v81)
					end
				end
			end)
		end
	end,
	_onScriptError = onScriptError,
	_TextChannelWindowErrorBoundary = v21
}
