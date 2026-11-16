local function fn() end
local function noopRegister(_)
	return fn
end

local function noopNotify(_) end

local function noopRule(_): nil
	return nil
end

local function noopRuleFactory(...)
	return noopRule
end

local function noopFormatter(_, _, _): nil
	return nil
end

local function noopFormatterFactory(_)
	return noopFormatter
end

local function noopPreview(_): nil
	return nil
end

local function noopPreviewFactory(_)
	return noopPreview
end

return {
	register = noopRegister,
	notify = noopNotify,
	Resolvers = {
		fromEventName = noopRuleFactory,
		fromCtx = noopRuleFactory,
		fromField = noopRuleFactory,
		fromEnum = noopRuleFactory,
		eventNameAsLabel = noopRuleFactory,
		fixed = noopRuleFactory,
		walk = function(_, _): nil
			return nil
		end
	},
	Formatters = {
		enumLabel = noopFormatterFactory,
		invertEnum = function(_)
			return {}
		end
	},
	Previews = {
		rbxthumb = noopPreviewFactory,
		fromInstance = noopPreviewFactory,
		chain = noopPreviewFactory,
		isPlausibleId = function(_): boolean
			return false
		end
	}
}
