local t1 = {}
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuauPolyfill = require(scriptParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local toJSBoolean = require(script.Parent.utilities.globals.null).toJSBoolean
local invariant = require(scriptParent.jsutils.invariant).invariant
local DEV = require(scriptParent.utilities).DEV

invariant(typeof(DEV) == "boolean", (tostring(DEV)))
require(scriptParentParent.GraphQL)

local isNonEmptyArray = require(scriptParent.utilities).isNonEmptyArray
local hasOwnProperty = require(scriptParent.luaUtils.hasOwnProperty)
local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function t1.isApolloError(p1) -- line: 43
	-- upvalues: hasOwnProperty (copy)
	return hasOwnProperty(p1, "graphQLErrors")
end

local function generateErrorMessage(p2) -- line: 49
	-- upvalues: isNonEmptyArray (copy), Array (copy), Boolean (copy), toJSBoolean (copy)
	local s1 = ""

	if isNonEmptyArray(p2.graphQLErrors) and isNonEmptyArray(p2.graphQLErrors) or isNonEmptyArray(p2.clientErrors) then
		local v18 = Array.concat(Boolean.toJSBoolean(p2.graphQLErrors) and p2.graphQLErrors or {}, Boolean.toJSBoolean(p2.clientErrors) and p2.clientErrors or {})

		for _, v in pairs(v18) do
			s1 ..= ("%s\n"):format(not toJSBoolean(v) and "Error message not found." or v.message)
		end
	end

	if p2.networkError ~= nil then
		local networkError = p2.networkError

		s1 ..= ("%s\n"):format(if typeof(networkError) ~= "string" then if not networkError.message then networkError.error else networkError.message else networkError)
	end

	return (string.gsub(s1, "\n$", ""))
end

function self.new(t2: {[any]: any}) -- line: 104
	-- upvalues: Error (copy), Boolean (copy), generateErrorMessage (copy), self (copy)
	local graphQLErrors = t2.graphQLErrors
	local clientErrors = t2.clientErrors
	local networkError = t2.networkError
	local errorMessage = t2.errorMessage
	local extraInfo = t2.extraInfo
	local v28 = Error.new(errorMessage)

	v28.graphQLErrors = Boolean.toJSBoolean(graphQLErrors) and graphQLErrors or {}
	v28.clientErrors = Boolean.toJSBoolean(clientErrors) and clientErrors or {}
	v28.networkError = Boolean.toJSBoolean(networkError) and networkError or nil
	v28.message = Boolean.toJSBoolean(errorMessage) and errorMessage or generateErrorMessage(v28)
	v28.extraInfo = extraInfo

	return (setmetatable(v28, self))
end

t1.ApolloError = self

return t1
