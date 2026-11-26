local function fn() end
local function noopRegister(p2)
	return fn
end

local function noopNotify(p2) end

local function noopRule(p2): nil
	return nil
end

local function noopRuleFactory(...)
	return noopRule
end

local function noopFormatter(p2, p3, p4): nil
	return nil
end

local function noopFormatterFactory(p2)
	return noopFormatter
end

local function noopPreview(p2): nil
	return nil
end

local function noopPreviewFactory(p2)
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
		walk = function(p2, p3): nil
			return nil
		end
	},
	Formatters = {
		enumLabel = noopFormatterFactory,
		invertEnum = function(p2)
			return {}
		end
	},
	Previews = {
		rbxthumb = noopPreviewFactory,
		fromInstance = noopPreviewFactory,
		chain = noopPreviewFactory,
		isPlausibleId = function(p2): boolean
			return false
		end
	}
}
