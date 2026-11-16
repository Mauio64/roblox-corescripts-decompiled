local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Players = game:GetService("Players")
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local KeystrokeEvent = require(AppChat.Analytics.KeystrokeEvent)

local getFIntAppChatBehaviorCollectionEnabledPercentage = require(AppChat.Flags.getFIntAppChatBehaviorCollectionEnabledPercentage)

local v = { Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter }

local function useKeystrokeCollection(p)
	local ref = React.useRef(false)
	local ref2 = React.useRef({})
	local ref3 = React.useRef({})
	local ref4 = React.useRef({})

	React.useEffect(function()
		local keystrokeCollectionEnabled = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
		local fIntAppChatBehaviorCollectionEnabledPercentage = getFIntAppChatBehaviorCollectionEnabledPercentage()

		if
			fIntAppChatBehaviorCollectionEnabledPercentage > 0
			and Players.LocalPlayer
			and keystrokeCollectionEnabled
		then
			ref.current = Players.LocalPlayer.UserId % 100 < fIntAppChatBehaviorCollectionEnabledPercentage
		end
	end, {})

	local v2 = React.useCallback(function(chatContext: string)
		if #ref2.current >= 0 then
			p.eventLoggingFunc(default, KeystrokeEvent, {}, {
				chatContext = chatContext,
				keyPressedData = table.concat(ref2.current, ","),
				eventTypeData = table.concat(ref3.current, ","),
				timestampData = table.concat(ref4.current, ",")
			})

			ref2.current = {}
			ref3.current = {}
			ref4.current = {}
		end
	end, { p.eventLoggingFunc })

	return {
		recordKeystroke = React.useCallback(function(flag: boolean, p2)
			if not ref.current then
				return
			end

			if flag then
				table.insert(ref2.current, p2.Name)
				table.insert(ref3.current, 0)
				table.insert(ref4.current, DateTime.now().UnixTimestampMillis)
			elseif Cryo.List.find(v, p2) == nil or #ref2.current ~= 0 then
				table.insert(ref2.current, p2.Name)
				table.insert(ref3.current, 1)
				table.insert(ref4.current, DateTime.now().UnixTimestampMillis)
			end

			if #ref2.current >= (p.maxKeystrokeDataLength or 200) then
				v2("UAMaxLengthReached")
			end
		end, { v2, p.maxKeystrokeDataLength }),
		recordTextChange = React.useCallback(function(value: string)
			if not ref.current then
				return
			end

			local v3 = string.sub(value, -1)
			table.insert(ref2.current, v3)
			table.insert(ref4.current, DateTime.now().UnixTimestampMillis)

			if #ref2.current >= (p.maxKeystrokeDataLength or 200) then
				v2("UAMaxLengthReached")
			end
		end, { v2, p.maxKeystrokeDataLength }),
		sendKeystrokeEventOnSend = React.useCallback(function()
			if ref.current then
				v2("UASendPressed")
			end
		end, { v2 })
	}
end

return useKeystrokeCollection
