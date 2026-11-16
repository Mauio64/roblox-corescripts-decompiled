local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local equal = require(parent.jsutils.equal)
local parser = require(script.Parent.Parent.parser)
local documentType = parser.DocumentType
local errors = require(parent.errors)
local apolloError = errors.ApolloError

require(script.Parent.Parent.types.types)

local OperationData = require(script.Parent.OperationData)
local operationData = OperationData.OperationData

local core = require(parent.core)

local mergeOptions = core.mergeOptions

require(parent.link.core)

local object = setmetatable({}, { __index = operationData })
object.__index = object

function object.new(data)
	local v = operationData.new(data.options, data.context)
	function v.runMutation(p)
		local v2 = p == nil and {} or p

		v:onMutationStart()
		local newMutationId = v:generateNewMutationId()

		return v:mutate(v2):andThen(function(p2)
			v:onMutationCompleted(p2, newMutationId)
			return p2
		end):catch(function(message)
			local options = v:getOptions()
			local onError = options.onError
			v:onMutationError(message, newMutationId)

			if Boolean.toJSBoolean(onError) then
				onError(options, message)
				return { data = nil, errors = message }
			end

			error(message)
		end)
	end

	v:verifyDocumentType(data.options.mutation, documentType.Mutation)
	v.result = data.result
	v.setResult = data.setResult
	v.mostRecentMutationId = 0
	return (setmetatable(v, object))
end

function object:execute(p)
	self.isMounted = true
	self:verifyDocumentType(self:getOptions().mutation, documentType.Mutation)
	return { self.runMutation, Object.assign({}, p, { client = self:refreshClient().client }) }
end

function object:afterExecute()
	self.isMounted = true
	return function(...)
		return self:unmount(...)
	end
end

function object.cleanup(_) end

function object:mutate(p)
	return self:refreshClient().client:mutate(mergeOptions(self:getOptions(), p))
end

function object:onMutationStart()
	if not (self.result.loading or self:getOptions().ignoreResults) then
		self:updateResult({ loading = true, error = nil, data = nil, called = true })
	end
end

function object:onMutationCompleted(p, p2: number)
	local options = self:getOptions()
	local onCompleted = options.onCompleted
	local ignoreResults = options.ignoreResults

	local data = p.data
	local errors2 = p.errors
	local err

	if errors2 and #errors2 > 0 then
		err = apolloError.new({ graphQLErrors = errors2 })
	end

	local function callOncomplete() -- 1 equivalent call inferred from this helper
		if Boolean.toJSBoolean(onCompleted) then
			return onCompleted(data)
		end

		return nil
	end

	if self:isMostRecentMutation(p2) and not ignoreResults then
		self:updateResult({ called = true, loading = false, data = data, error = err })
	end

	callOncomplete() -- inferred equivalent call
end

function object:onMutationError(err, p: number)
	if self:isMostRecentMutation(p) then
		self:updateResult({ loading = false, error = err, data = nil, called = true })
	end
end

function object:generateNewMutationId()
	self.mostRecentMutationId += 1
	return self.mostRecentMutationId
end

function object:isMostRecentMutation(p: number): boolean
	return self.mostRecentMutationId == p
end

function object:updateResult(previousResult)
	if self.isMounted and not (self.previousResult and equal(self.previousResult, previousResult)) then
		self:setResult(previousResult)
		self.previousResult = previousResult
		return previousResult
	end

	return nil
end

return { MutationData = object }
