local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local Players = game:GetService("Players")
local getAppFeaturePolicies = require(AppChatParent.UniversalAppPolicy).getAppFeaturePolicies
local default = require(AppChatParent.LoggingProtocol).default
local KeystrokeEvent = require(AppChat.Analytics.KeystrokeEvent)
local getFIntAppChatBehaviorCollectionEnabledPercentage = require(AppChat.Flags.getFIntAppChatBehaviorCollectionEnabledPercentage)
local t1 = {
	Enum.KeyCode.Return,
	Enum.KeyCode.KeypadEnter
}

local function useKeystrokeCollection(t2: {[any]: any}) -- line: 31
	-- upvalues: React (copy), getAppFeaturePolicies (copy), getFIntAppChatBehaviorCollectionEnabledPercentage (copy), Players (copy), default (copy), KeystrokeEvent (copy), Cryo (copy), t1 (copy)
	local v13 = React.useRef(false)
	local v14 = React.useRef({})
	local v15 = React.useRef({})
	local v16 = React.useRef({})

	React.useEffect(function() -- line: 37
		-- upvalues: getAppFeaturePolicies (copy), getFIntAppChatBehaviorCollectionEnabledPercentage (copy), Players (copy), v13 (copy)
		local v21 = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
		local v22 = getFIntAppChatBehaviorCollectionEnabledPercentage()

		if v22 > 0 and (Players.LocalPlayer and v21) then
			v13.current = v22 > Players.LocalPlayer.UserId % 100
		end
	end, {})

	local v17 = React.useCallback(function(s1: string) -- line: 45
		-- upvalues: v14 (copy), t2 (copy), default (copy), KeystrokeEvent (copy), v15 (copy), v16 (copy)
		if #v14.current >= 0 then
			t2.eventLoggingFunc(default, KeystrokeEvent, {}, {
				chatContext = s1,
				keyPressedData = table.concat(v14.current, ","),
				eventTypeData = table.concat(v15.current, ","),
				timestampData = table.concat(v16.current, ",")
			})
			v14.current = {}
			v15.current = {}
			v16.current = {}
		end
	end, { t2.eventLoggingFunc })
	local v18 = React.useCallback(function(b1: boolean, p1) -- line: 59
		-- upvalues: v13 (copy), v14 (copy), v15 (copy), v16 (copy), Cryo (copy), t1 (copy), t2 (copy), v17 (copy)
		if not v13.current then
			return
		end

		if b1 then
			table.insert(v14.current, p1.Name)
			table.insert(v15.current, 0)
			table.insert(v16.current, DateTime.now().UnixTimestampMillis)
		elseif Cryo.List.find(t1, p1) == nil or #v14.current ~= 0 then
			table.insert(v14.current, p1.Name)
			table.insert(v15.current, 1)
			table.insert(v16.current, DateTime.now().UnixTimestampMillis)
		end

		if #v14.current >= (t2.maxKeystrokeDataLength or 200) then
			v17("UAMaxLengthReached")
		end
	end, {
		v17,
		t2.maxKeystrokeDataLength
	})
	local v19 = React.useCallback(function(s2: string) -- line: 84
		-- upvalues: v13 (copy), v14 (copy), v16 (copy), t2 (copy), v17 (copy)
		if not v13.current then
			return
		end

		local v27 = string.sub(s2, -1)

		table.insert(v14.current, v27)
		table.insert(v16.current, DateTime.now().UnixTimestampMillis)

		if #v14.current >= (t2.maxKeystrokeDataLength or 200) then
			v17("UAMaxLengthReached")
		end
	end, {
		v17,
		t2.maxKeystrokeDataLength
	})
	local v20 = React.useCallback(function() -- line: 99
		-- upvalues: v13 (copy), v17 (copy)
		if v13.current then
			v17("UASendPressed")
		end
	end, { v17 })

	return {
		recordKeystroke = v18,
		recordTextChange = v19,
		sendKeystrokeEventOnSend = v20
	}
end

return useKeystrokeCollection
