local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies").llama
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")
local toStringAdditionalArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/toStringAdditionalArgs")
local getEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getEventInfo")
local optionallyLog = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/optionallyLog")
local isEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Utils/isEnum")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Dash")
local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SharedFlags").FFlagPymkCarouselExtendProps

local function fn(p2, formatRulesForAdditionalInfo)
	if p2 and formatRulesForAdditionalInfo then
		return llama.Dictionary.map(p2, function(p3, p4)
			local v5 = formatRulesForAdditionalInfo[p4]

			if not v5 then
				return llama.None
			end

			if type(v5) == "function" then
				return (v5(p3))
			end

			return p3
		end)
	end

	return {}
end

local function fn2(data)
	return string.format(
		"context: (%s), eventName: (%s), additionalInfo: (%s)",
		data.context,
		data.eventType,
		toStringAdditionalArgs(data.additionalInfo)
	)
end

local function fn3(object, p2)
	return function(data)
		if p2 then
			object:sendEventDeferred(data.context, data.eventType, data.additionalInfo)
			return data
		end

		object:setRBXEventStream(data.context, data.eventType, data.additionalInfo)

		return data
	end
end

return function(data)
	local v5 = getEventInfo(data.eventList)

	return function(p2, p3)
		local v6 = v5(p2)

		local v7 = if data.getInfoForAllEvents then data.getInfoForAllEvents() else data.infoForAllEvents

		local pipe = Dash.pipe
		local eventStreamImpl = data.eventStreamImpl
		local shouldUseSendEventDeferred = data.shouldUseSendEventDeferred
		local v8 = pipe(function(data2)
			if shouldUseSendEventDeferred then
				eventStreamImpl:sendEventDeferred(data2.context, data2.eventType, data2.additionalInfo)
				return data2
			end

			eventStreamImpl:setRBXEventStream(data2.context, data2.eventType, data2.additionalInfo)

			return data2
		end, optionallyLog(data.loggerImpl, fn2))

		local v10 = if fFlagPymkCarouselExtendProps and data.context then data.context else v6.context
		local v9 = { context = v10, eventType = v6.eventType, additionalInfo = 0 }
		local join = llama.Dictionary.join

		local additionalInfo = v6.additionalInfo
		v9.additionalInfo = join(v7 or {}, llama.Dictionary.map(additionalInfo or {}, function(p4)
			if isEnum(p4) then
				return p4.rawValue()
			end

			return p4
		end), fn(p3, v6.formatRulesForAdditionalInfo))
		v8(v9)

		return p2, p3
	end
end
