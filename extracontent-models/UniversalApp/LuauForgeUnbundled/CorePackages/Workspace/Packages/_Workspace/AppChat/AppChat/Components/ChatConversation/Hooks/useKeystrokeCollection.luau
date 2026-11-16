local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Players = game:GetService("Players")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").getAppFeaturePolicies
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol").default

local KeystrokeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/KeystrokeEvent")

local getFIntAppChatBehaviorCollectionEnabledPercentage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFIntAppChatBehaviorCollectionEnabledPercentage")

local v5 = { Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter }

local function useKeystrokeCollection(p2)
	local ref = React.useRef(false)
	local ref2 = React.useRef({})
	local ref3 = React.useRef({})
	local ref4 = React.useRef({})

	React.useEffect(function()
		local keystrokeCollectionEnabled = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
		local v6 = getFIntAppChatBehaviorCollectionEnabledPercentage()

		if v6 > 0 and Players.LocalPlayer and keystrokeCollectionEnabled then
			ref.current = Players.LocalPlayer.UserId % 100 < v6
		end
	end, {})

	local v6 = React.useCallback(function(p3)
		if #ref2.current >= 0 then
			p2.eventLoggingFunc(default, KeystrokeEvent, {}, {
				chatContext = p3,
				keyPressedData = table.concat(ref2.current, ","),
				eventTypeData = table.concat(ref3.current, ","),
				timestampData = table.concat(ref4.current, ",")
			})

			ref2.current = {}
			ref3.current = {}
			ref4.current = {}
		end
	end, { p2.eventLoggingFunc })

	return {
		recordKeystroke = React.useCallback(function(p3, p4)
			if not ref.current then
				return
			end

			if p3 then
				table.insert(ref2.current, p4.Name)
				table.insert(ref3.current, 0)
				table.insert(ref4.current, DateTime.now().UnixTimestampMillis)
			elseif Cryo.List.find(v5, p4) == nil or #ref2.current ~= 0 then
				table.insert(ref2.current, p4.Name)
				table.insert(ref3.current, 1)
				table.insert(ref4.current, DateTime.now().UnixTimestampMillis)
			end

			if #ref2.current >= (p2.maxKeystrokeDataLength or 200) then
				v6("UAMaxLengthReached")
			end
		end, { v6, p2.maxKeystrokeDataLength }),
		recordTextChange = React.useCallback(function(value)
			if not ref.current then
				return
			end

			local v7 = string.sub(value, -1)
			table.insert(ref2.current, v7)
			table.insert(ref4.current, DateTime.now().UnixTimestampMillis)

			if #ref2.current >= (p2.maxKeystrokeDataLength or 200) then
				v6("UAMaxLengthReached")
			end
		end, { v6, p2.maxKeystrokeDataLength }),
		sendKeystrokeEventOnSend = React.useCallback(function()
			if ref.current then
				v6("UASendPressed")
			end
		end, { v6 })
	}
end

return useKeystrokeCollection
