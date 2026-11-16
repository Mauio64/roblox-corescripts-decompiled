local parent = script.Parent
local Cryo = require(parent.Cryo)

local class = {}
class.__index = class

function class:new(p, delimiter)
	return (setmetatable({ ids = class.makeArray(p), delimiter = delimiter }, self))
end

function class:setIds(p)
	self.ids = class.makeArray(p)
end

function class.makeArray(p)
	if type(p) == "table" then
		return p
	end

	return { p }
end

function class.__tostring(p)
	return table.concat(p.ids, p.delimiter)
end

local RequestBuilder = {}
RequestBuilder.__index = RequestBuilder

function RequestBuilder:new(options)
	local v = {
		baseUrl = self:gsub("/*$", ""),
		args = {},
		pathElements = {},
		configurableIds = nil,
		namedIds = {},
		idsDelimiter = ",",
		options = { queryArgs = nil, postBody = nil, headers = nil },
		useExpandedForm = {},
		statusIds = nil,
		additionalData = options or {}
	}

	setmetatable(v, RequestBuilder)

	return v
end

function RequestBuilder.path(p, value: string)
	local v = value:gsub("^/", ""):gsub("/$", "")
	table.insert(p.pathElements, v)
	return p
end

function RequestBuilder:id(p, p2)
	if not p2 and #self.pathElements < 1 then
		warn("Cannot name id or ids because there is no leading path segment and no name is provided")
	end

	local v = p2 or self.pathElements[#self.pathElements]
	self.namedIds[v] = p

	self.configurableIds = class:new(p, self.idsDelimiter)
	table.insert(self.pathElements, self.configurableIds)
	return self
end

function RequestBuilder:queryArgWithIds(p, p2)
	local joined = Cryo.List.join(p2, self.namedIds[p] or {})
	self.namedIds[p] = joined
	self.configurableIds = class:new(joined, self.idsDelimiter)
	self.args = Cryo.Dictionary.join(self.args, { [p] = self.configurableIds })

	return self
end

function RequestBuilder:expandedQueryArgsWithIds(p, p2)
	self.useExpandedForm[p] = true
	self:queryArgWithIds(p, p2)
	return self
end

function RequestBuilder:queryArgs(p)
	self.args = Cryo.Dictionary.join(self.args, p)
	self.options.queryArgs = Cryo.Dictionary.join(p, self.options.queryArgs or {})
	return self
end

function RequestBuilder.body(p, postBody)
	p.options.postBody = postBody
	return p
end

function RequestBuilder.headers(p, headers)
	p.options.headers = headers
	return p
end

function RequestBuilder:makeKeyMapper()
	return function(p)
		return self:getStatusIds() and self:makeStatusUrl(p) or self:makeNamedIdsUrl(p)
	end
end

function RequestBuilder:_normalize(value)
	return value:gsub("/+", "/")
end

function RequestBuilder:makeUri()
	local v = ""

	for _, pathElement in ipairs(self.pathElements) do
		v ..= "/" .. tostring(pathElement)
	end

	return self:_normalize(v)
end

local function concatArguments(value: string, k: string, arg, flag: boolean?)
	if flag then
		for _, id in pairs(arg.ids) do
			value = concatArguments(value, k, id)
		end

		return value
	else
		local v = tostring(k) .. "=" .. tostring(arg)

		if value:len() > 1 then
			return value .. "&" .. v
		end

		return v
	end
end

function RequestBuilder:makeQueryArgs(p, flag: boolean?)
	self:_plugInConfigurableIds(p)
	local v = ""

	for k, arg in pairs(self.args) do
		if flag and self.namedIds[k] or not flag then
			v = concatArguments(v, k, arg, self.useExpandedForm[k])
		end
	end

	if v:len() > 1 then
		return "?" .. v
	end

	return ""
end

function RequestBuilder:makeUrl(p, flag: boolean?)
	self:_plugInConfigurableIds(p)
	return self.baseUrl .. self:makeUri() .. self:makeQueryArgs(p, flag)
end

function RequestBuilder:makeStatusUrl(p)
	local v = self.baseUrl .. self:makeUri()

	if not p then
		return v
	end

	local v2 = type(p) == "table" and p or { p }
	local v3 = ""

	for k, v4 in pairs(v2) do
		if k > 1 then
			v3 = v3 .. "&" .. v4 or v4
		else
			v3 = v4
		end
	end

	return v .. "?" .. v3
end

function RequestBuilder:makeNamedIdsUrl(p)
	return self:makeUrl(p, true)
end

function RequestBuilder.makeOptions(p)
	return p.options
end

function RequestBuilder:_plugInConfigurableIds(p)
	if p ~= nil and self.configurableIds then
		self.configurableIds:setIds(p)
	end
end

function RequestBuilder.getIds(p)
	if p.configurableIds and p.configurableIds.ids then
		return p.configurableIds.ids
	end

	if p.statusIds then
		return p.statusIds
	end

	return {}
end

function RequestBuilder.getNamedIds(p)
	return p.namedIds
end

function RequestBuilder:setStatusIds(p)
	if self.configurableIds then
		warn("Cannot set statusIds because ids already provided in URl")
		return self
	end

	self.statusIds = Cryo.List.join(self.statusIds or {}, p)
	return self
end

function RequestBuilder:getStatusIds()
	return if not self.configurableIds then self.statusIds else nil
end

function RequestBuilder.getAdditionalData(p)
	return p.additionalData or {}
end

return RequestBuilder
