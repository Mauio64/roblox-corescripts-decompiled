local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local equal = require(ParentParent.jsutils.equal)
local DocumentType = require(script.Parent.Parent.parser).DocumentType
local ApolloError = require(ParentParent.errors).ApolloError

require(script.Parent.Parent.types.types)

local OperationData = require(script.Parent.OperationData).OperationData
local mergeOptions = require(ParentParent.core).mergeOptions

require(ParentParent.link.core)

local self = setmetatable({}, {
	__index = OperationData
})

self.__index = self

function self.new(t2: {[any]: any}) -- line: 83
	-- upvalues: OperationData (copy), Boolean (copy), DocumentType (copy), self (copy)
	local v14 = OperationData.new(t2.options, t2.context)

	function v14.runMutation(t3: {[any]: any}?) -- line: 92
		-- upvalues: v14 (copy), Boolean (copy)
		if t3 == nil then
			t3 = {}
		end

		v14:onMutationStart()

		local v41 = v14:generateNewMutationId()

		return v14:mutate(t3):andThen(function(p1) -- line: 100
			-- upvalues: v14 (copy), v41 (copy)
			v14:onMutationCompleted(p1, v41)

			return p1
		end):catch(function(p2) -- line: 104
			-- upvalues: v14 (copy), v41 (copy), Boolean (copy)
			local v44 = v14:getOptions()
			local onError = v44.onError

			v14:onMutationError(p2, v41)

			if Boolean.toJSBoolean(onError) then
				onError(v44, p2)

				return {
					data = nil,
					errors = p2
				}
			end

			error(p2)
		end)
	end

	v14:verifyDocumentType(t2.options.mutation, DocumentType.Mutation)
	v14.result = t2.result
	v14.setResult = t2.setResult
	v14.mostRecentMutationId = 0

	return (setmetatable(v14, self))
end
function self.execute(p3, p4) -- line: 127
	-- upvalues: DocumentType (copy), Object (copy)
	p3.isMounted = true
	p3:verifyDocumentType(p3:getOptions().mutation, DocumentType.Mutation)

	return {
		p3.runMutation,
		Object.assign({}, p4, {
			client = p3:refreshClient().client
		})
	}
end
function self.afterExecute(p5) -- line: 133
	p5.isMounted = true

	return function(...) -- line: 135
		-- upvalues: p5 (copy)
		return p5:unmount(...)
	end
end
function self.cleanup(_) -- line: 140
end
function self.mutate(p7, p8) -- line: 144
	-- upvalues: mergeOptions (copy)
	return p7:refreshClient().client:mutate(mergeOptions(p7:getOptions(), p8))
end
function self.onMutationStart(p9) -- line: 148
	if not p9.result.loading and not p9:getOptions().ignoreResults then
		p9:updateResult({
			loading = true,
			error = nil,
			data = nil,
			called = true
		})
	end
end
function self.onMutationCompleted(t4: {[any]: any}, p10, n1: number) -- line: 160
	-- upvalues: ApolloError (copy), Boolean (copy)
	local v25 = t4:getOptions()
	local onCompleted = v25.onCompleted
	local ignoreResults = v25.ignoreResults
	local data = p10.data
	local errors = p10.errors
	local v30 = if not errors or not (#errors > 0) then nil else ApolloError.new({
		graphQLErrors = errors
	})

	local function callOncomplete() -- line: 172
		-- upvalues: Boolean (copy), onCompleted (copy), data (copy)
		if Boolean.toJSBoolean(onCompleted) then
			return onCompleted(data)
		end

		return nil
	end

	if t4:isMostRecentMutation(n1) and not ignoreResults then
		t4:updateResult({
			called = true,
			loading = false,
			data = data,
			error = v30
		})
	end

	if Boolean.toJSBoolean(onCompleted) then
		onCompleted(data)

		return
	end
end
function self.onMutationError(t5: {[any]: any}, p11, n2: number) -- line: 191
	if t5:isMostRecentMutation(n2) then
		t5:updateResult({
			loading = false,
			data = nil,
			called = true,
			error = p11
		})
	end
end
function self.generateNewMutationId(p12) -- line: 202
	p12.mostRecentMutationId = p12.mostRecentMutationId + 1

	return p12.mostRecentMutationId
end
function self.isMostRecentMutation(t6: {[any]: any}, n3: number) -- line: 207
	return n3 == t6.mostRecentMutationId
end
function self.updateResult(t7: {[any]: any}, t8: {[any]: any}) -- line: 211
	-- upvalues: equal (copy)
	if t7.isMounted and (not t7.previousResult or not equal(t7.previousResult, t8)) then
		t7:setResult(t8)
		t7.previousResult = t8

		return t8
	end

	return nil
end

t1.MutationData = self

return t1
