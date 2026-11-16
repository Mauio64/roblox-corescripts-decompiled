local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local llama = dependencies.llama
require(script.Parent.Types)
local toStringAdditionalArgs = require(script.Parent.toStringAdditionalArgs)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local compose = require(script.Parent.Parent.Parent.RoduxTools.compose)
local isEnum = require(script.Parent.Parent.Parent.Utils.isEnum)

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

return function(data)
	local eventInfo = getEventInfo(data.eventList)

	return function(p, p2)
		local v = eventInfo(p)

		local v2 = optionallyLog(data.loggerImpl, fn2)
		local eventStreamImpl = data.eventStreamImpl
		local v3 = compose(v2, function(data2)
			eventStreamImpl:setRBXEventStream(data2.context, data2.eventType, data2.additionalInfo)

			return data2
		end)
		local v4 = {
			context = v.context.rawValue(),
			eventType = v.eventType.rawValue(),
			additionalInfo = 0
		}
		local join = llama.Dictionary.join
		local infoForAllEvents = data.infoForAllEvents or {}
		local additionalInfo = v.additionalInfo
		v4.additionalInfo = join(infoForAllEvents, llama.Dictionary.map(additionalInfo or {}, function(p3)
			if isEnum(p3) then
				return p3.rawValue()
			end

			return p3
		end), fn(p2, v.formatRulesForAdditionalInfo))
		v3(v4)

		return p, p2
	end
end
