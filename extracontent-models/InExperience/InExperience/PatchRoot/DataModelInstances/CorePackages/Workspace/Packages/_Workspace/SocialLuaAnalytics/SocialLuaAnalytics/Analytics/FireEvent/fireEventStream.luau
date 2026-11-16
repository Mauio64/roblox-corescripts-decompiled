local parent = script.Parent.Parent.Parent

local parent2 = parent.Parent
local dependencies = require(parent.dependencies)

local llama = dependencies.llama
require(script.Parent.Parent.Types)
local toStringAdditionalArgs = require(script.Parent.toStringAdditionalArgs)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local isEnum = require(script.Parent.Parent.Parent.Utils.isEnum)

local Dash = require(parent2.Dash)

local function fn(p, formatRulesForAdditionalInfo)
	if p and formatRulesForAdditionalInfo then
		return llama.Dictionary.map(p, function(p2, p3)
			local v = formatRulesForAdditionalInfo[p3]

			if not v then
				return llama.None
			end

			if type(v) == "function" then
				return (v(p2))
			end

			return p2
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

local function fn3(eventStreamImpl, shouldUseSendEventDeferred: boolean?) -- 1 equivalent call inferred from this helper
	return function(data)
		if shouldUseSendEventDeferred then
			eventStreamImpl:sendEventDeferred(data.context, data.eventType, data.additionalInfo)
			return data
		end

		eventStreamImpl:setRBXEventStream(data.context, data.eventType, data.additionalInfo)

		return data
	end
end

return function(data)
	local eventInfo = getEventInfo(data.eventList)

	return function(p, p2)
		local v = eventInfo(p)
		local v2

		if data.getInfoForAllEvents then
			v2 = data.getInfoForAllEvents()
		else
			v2 = data.infoForAllEvents
		end

		local v3 = Dash.pipe(
			fn3(data.eventStreamImpl, data.shouldUseSendEventDeferred), -- inferred equivalent call
			optionallyLog(data.loggerImpl, fn2)
		)
		local v4 = { context = v.context, eventType = v.eventType, additionalInfo = 0 }
		local join = llama.Dictionary.join

		local additionalInfo = v.additionalInfo
		v4.additionalInfo = join(v2 or {}, llama.Dictionary.map(additionalInfo or {}, function(p3)
			if isEnum(p3) then
				return p3.rawValue()
			end

			return p3
		end), fn(p2, v.formatRulesForAdditionalInfo))
		v3(v4)

		return p, p2
	end
end
