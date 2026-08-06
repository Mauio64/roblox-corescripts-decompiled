local HttpService = game:GetService("HttpService")
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local parseFrame = require(script.Parent.Acp.parseFrame)

require(script.Parent.types)

local t1 = {
	studio_ask_user = true,
	ask_user = true,
	present_plan = true,
	propose_plan = true
}

local function extractRawFrame(p1) -- line: 29
	if typeof(p1) == "string" then
		return p1
	end

	if typeof(p1) ~= "table" then
		return nil
	end

	for _, v18 in {
		"frame",
		"payload",
		"message",
		"data",
		"body"
	} do
		local v19 = p1[v18]

		if typeof(v19) == "string" and v19 ~= "" then
			return v19
		end
	end

	return nil
end
local function normalizeUniverseId(p2) -- line: 45
	if typeof(p2) == "number" and p2 ~= 0 then
		return p2
	end

	if typeof(p2) == "string" and p2 ~= "" then
		local num = tonumber(p2)

		if num ~= nil and num ~= 0 then
			return num
		end

		return nil
	end

	return nil
end
local function getUniverseId(t2: {[any]: any}) -- line: 56
	local universeId = t2.universeId

	if typeof(universeId) == "number" and universeId ~= 0 then
	elseif typeof(universeId) == "string" and universeId ~= "" then
		local num = tonumber(universeId)

		universeId = if num == nil or num == 0 then nil else num
	else
		universeId = nil
	end

	if universeId ~= nil then
		return universeId
	end

	local v25 = t2._meta and t2._meta._roblox

	if typeof(v25) == "table" then
		local universeId2 = v25.universeId

		if typeof(universeId2) == "number" and universeId2 ~= 0 then
			return universeId2
		end

		if typeof(universeId2) == "string" and universeId2 ~= "" then
			local num = tonumber(universeId2)

			if num ~= nil and num ~= 0 then
				return num
			end

			return nil
		end

		return nil
	end

	return nil
end
local function valueLooksLikeLocalTool(p3) -- line: 69
	-- upvalues: t1 (copy)
	return typeof(p3) == "string" and t1[string.lower(p3)] == true
end
local function updateLooksLikeLocalTool(p4) -- line: 73
	-- upvalues: t1 (copy)
	local kind = p4.kind

	if typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true then
		local title = p4.title

		if not (typeof(title) == "string" and t1[string.lower(title)] == true) then
			local rawInput = p4.rawInput

			if typeof(rawInput) == "table" then
				local name = rawInput.name
				local v34 = typeof(name) == "string" and t1[string.lower(name)] == true

				if not v34 then
					local toolName = rawInput.toolName

					v34 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
				end

				return v34
			end

			return false
		end
	end

	return true
end
local function getSessionUpdate(p5) -- line: 86
	-- upvalues: AcpProtocol (copy)
	if p5.kind ~= "notification" then
		return nil, nil, nil
	end

	local notification = p5.notification

	if notification.method ~= AcpProtocol.Notifications.SessionUpdate then
		return nil, nil, nil
	end

	local params = notification.params
	local sessionId = params.sessionId
	local update = params.update

	if typeof(sessionId) ~= "string" or sessionId == "" or typeof(update) ~= "table" then
		return nil, nil, nil
	end

	local universeId = params.universeId

	if typeof(universeId) == "number" and universeId ~= 0 then
	elseif typeof(universeId) == "string" and universeId ~= "" then
		local num = tonumber(universeId)

		universeId = if num == nil or num == 0 then nil else num
	else
		universeId = nil
	end

	if universeId ~= nil then
		return update, sessionId, universeId
	end

	local v43 = params._meta and params._meta._roblox

	if typeof(v43) == "table" then
		local universeId3 = v43.universeId

		if typeof(universeId3) == "number" and universeId3 ~= 0 then
			return update, sessionId, universeId3
		end

		if typeof(universeId3) == "string" and universeId3 ~= "" then
			local num = tonumber(universeId3)

			if num ~= nil and num ~= 0 then
				return update, sessionId, num
			end

			return update, sessionId, nil
		end

		return update, sessionId, nil
	end

	return update, sessionId, nil
end
local function classifyFrame(p6) -- line: 106
	-- upvalues: AcpProtocol (copy), t1 (copy)
	local g57 = nil
	local title = nil
	local v61 = nil
	local v47, v48, v49

	if p6.kind ~= "notification" then
		v47 = nil
		v48 = nil
		v49 = nil
	else
		local notification = p6.notification

		if notification.method ~= AcpProtocol.Notifications.SessionUpdate then
			v47 = nil
			v48 = nil
			v49 = nil
		else
			local params = notification.params

			v48 = params.sessionId
			v47 = params.update

			if typeof(v48) ~= "string" or v48 == "" or typeof(v47) ~= "table" then
				v47 = nil
				v48 = nil
				v49 = nil
			else
				v49 = params.universeId

				if typeof(v49) == "number" and v49 ~= 0 then
				elseif typeof(v49) == "string" and v49 ~= "" then
					local num = tonumber(v49)

					v49 = if num == nil or num == 0 then nil else num
				else
					v49 = nil
				end

				if v49 ~= nil then
				else
					local v53 = params._meta and params._meta._roblox

					if typeof(v53) == "table" then
						v49 = v53.universeId

						if typeof(v49) == "number" and v49 ~= 0 then
						elseif typeof(v49) == "string" and v49 ~= "" then
							local num = tonumber(v49)

							v49 = if num == nil or num == 0 then nil else num
						else
							v49 = nil
						end
					else
						v49 = nil
					end
				end
			end
		end
	end

	if v47 == nil or v48 == nil then
		return nil
	end

	if v47.sessionUpdate == "state_change" and v47.state == "idle" then
		return {
			kind = "turn_end",
			sessionId = v48,
			universeId = v49
		}
	end

	if v47.sessionUpdate ~= "tool_call_update" then
		return nil
	end

	local status = v47.status

	if status == "completed" or status == "failed" then
		return nil
	end

	local kind = v47.kind

	repeat
		if g57 or (typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true) then
			if not g57 then
				title = v47.title
			end

			if g57 or (typeof(title) ~= "string" or t1[string.lower(title)] ~= true) then
				if not g57 then
					local rawInput = v47.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name

						v61 = typeof(name) == "string" and t1[string.lower(name)] == true

						if not v61 then
							local toolName = rawInput.toolName

							v61 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
						end
					else
						v61 = false
					end
				end

				g57 = false

				if v61 then
					local toolCallId = v47.toolCallId

					return {
						kind = "local_tool_call",
						sessionId = v48,
						universeId = v49,
						toolCallId = if typeof(toolCallId) ~= "string" or toolCallId == "" then nil else toolCallId
					}
				end

				return nil
			end
		end

		v61 = true
		g57 = true
	until not g57
end
local function getResumeDeepLink(t3: {[any]: any}) -- line: 172
	-- upvalues: HttpService (copy)
	local t4 = {}

	if t3.universeId ~= nil then
		table.insert(t4, `universeid={ HttpService:UrlEncode((tostring(t3.universeId))) }`)
	end

	table.insert(t4, `sessionid={ HttpService:UrlEncode(t3.sessionId) }`)

	return `roblox://navigation/build?{ table.concat(t4, "&") }`
end
local function getToastCopy(t5: {[any]: any}) -- line: 182
	if t5.kind == "local_tool_call" then
		return "Assistant needs your input", "Resume your build chat to continue."
	end

	return "Assistant finished", "Resume your build chat to review the result."
end
local function getActionEventParams(t6: {[any]: any}) -- line: 189
	-- upvalues: HttpService (copy), getResumeDeepLink (copy)
	return HttpService:JSONEncode({
		sessionId = t6.sessionId,
		universeId = t6.universeId,
		kind = t6.kind,
		deepLink = getResumeDeepLink(t6)
	})
end
local function getToastVisualItems(t7: {[any]: any}, s1: string, s2: string, s3: string) -- line: 198
	local t8 = {}

	if t7.universeId ~= nil then
		table.insert(t8, {
			thumbnail = {
				idType = "gameThumbnail",
				visualItemType = "thumbnail",
				id = tostring(t7.universeId)
			}
		})
	end

	table.insert(t8, {
		textBody = {
			eventName = "CreatorAgentResume",
			visualItemType = "textBody",
			title = {
				text = s1
			},
			label = {
				text = s2
			},
			actions = {},
			actionEventParams = s3
		}
	})
	table.insert(t8, {
		button = {
			buttonStyle = "Secondary",
			eventName = "CreatorAgentResumeDismiss",
			visualItemType = "button",
			label = {
				text = "Dismiss"
			},
			actions = {{
				actionType = "dismiss"
			}}
		}
	})
	table.insert(t8, {
		button = {
			buttonStyle = "Primary",
			eventName = "CreatorAgentResume",
			visualItemType = "button",
			label = {
				text = "Resume"
			},
			actions = {},
			actionEventParams = s3
		}
	})

	return t8
end

return {
	NotificationType = "CreatorAgentResume",
	ResumeEventName = "CreatorAgentResume",
	CapRtnNamespace = AcpProtocol.CapRtnNamespace,
	classifyFrame = classifyFrame,
	classifyRtnDetail = function(p7) -- line: 136
		-- upvalues: extractRawFrame (copy), parseFrame (copy), classifyFrame (copy)
		local v65 = extractRawFrame(p7)

		if v65 == nil then
			return nil
		end

		local v66 = parseFrame(v65)

		if v66 == nil then
			return nil
		end

		return (classifyFrame(v66))
	end,
	targetMatchesNotification = function(t9: {[any]: any}?, t10: {[any]: any}) -- line: 150
		if t9 == nil then
			return false
		end

		if t9.sessionId ~= nil and t9.sessionId ~= "" and t9.sessionId == t10.sessionId then
			return true
		end

		return t9.universeId ~= nil and (t10.universeId ~= nil and t9.universeId == t10.universeId)
	end,
	getNotificationId = function(t11: {[any]: any}) -- line: 165
		if t11.kind == "local_tool_call" and t11.toolCallId ~= nil then
			return `CreatorAgentResume-{ t11.sessionId }-{ t11.toolCallId }`
		end

		return `CreatorAgentResume-{ t11.sessionId }-{ t11.kind }`
	end,
	getResumeDeepLink = getResumeDeepLink,
	buildToastNotification = function(t12: {[any]: any}) -- line: 251
		-- upvalues: HttpService (copy), getResumeDeepLink (copy), getToastVisualItems (copy)
		local s4, s5

		if t12.kind == "local_tool_call" then
			s4 = "Assistant needs your input"
			s5 = "Resume your build chat to continue."
		else
			s4 = "Assistant finished"
			s5 = "Resume your build chat to review the result."
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local json = HttpService:JSONEncode({
			sessionId = t12.sessionId,
			universeId = t12.universeId,
			kind = t12.kind,
			deepLink = getResumeDeepLink(t12)
		})

		return {
			notificationType = "CreatorAgentResume",
			deliverTimestamp = UnixTimestampMillis,
			notificationReceivedTimestampMs = UnixTimestampMillis,
			content = {
				currentState = "Default",
				notificationType = "CreatorAgentResume",
				minVersion = 0,
				priority = 1,
				id = if t12.kind ~= "local_tool_call" or t12.toolCallId == nil then `CreatorAgentResume-{ t12.sessionId }-{ t12.kind }` else `CreatorAgentResume-{ t12.sessionId }-{ t12.toolCallId }`,
				clientEventsPayload = {},
				states = {
					Default = {
						layoutKey = "CreatorAgentResume",
						name = "Default",
						timeOnScreenMs = 12000,
						visualItems = getToastVisualItems(t12, s4, s5, json)
					}
				}
			}
		}
	end
}
