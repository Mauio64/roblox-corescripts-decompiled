local Errors = {}

local parent = script.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local null = require(script.Parent.utilities.globals.null)
local toJSBoolean = null.toJSBoolean

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local utilities = require(parent.utilities)
local dev = utilities.DEV
invariant2(typeof(dev) == "boolean", (tostring(dev)))

require(parent2.GraphQL)

local utilities2 = require(parent.utilities)
local isNonEmptyArray = utilities2.isNonEmptyArray

local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)

local object = setmetatable({}, { __index = Error })
object.__index = object

function Errors.isApolloError(p)
	return hasOwnProperty(p, "graphQLErrors")
end

local function generateErrorMessage(data)
	local v = ""

	if
		isNonEmptyArray(data.graphQLErrors) and isNonEmptyArray(data.graphQLErrors)
		or isNonEmptyArray(data.clientErrors)
	then
		local joined = Array.concat(
			Boolean.toJSBoolean(data.graphQLErrors) and data.graphQLErrors or {},
			Boolean.toJSBoolean(data.clientErrors) and data.clientErrors or {}
		)

		for _, v2 in pairs(joined) do
			v ..= ("%s\n"):format(not toJSBoolean(v2) and "Error message not found." or v2.message)
		end
	end

	if data.networkError ~= nil then
		local v2 = data.networkError

		if typeof(v2) ~= "string" then
			v2 = if v2.message then v2.message else v2.error
		end

		v ..= ("%s\n"):format(v2)
	end

	return (string.gsub(v, "\n$", ""))
end

function object.new(data)
	local graphQLErrors = data.graphQLErrors
	local clientErrors = data.clientErrors
	local networkError = data.networkError
	local errorMessage = data.errorMessage
	local extraInfo = data.extraInfo

	local v = Error.new(errorMessage)
	v.graphQLErrors = Boolean.toJSBoolean(graphQLErrors) and graphQLErrors or {}
	v.clientErrors = Boolean.toJSBoolean(clientErrors) and clientErrors or {}
	v.networkError = Boolean.toJSBoolean(networkError) and networkError or nil
	v.message = Boolean.toJSBoolean(errorMessage) and errorMessage or generateErrorMessage(v)
	v.extraInfo = extraInfo

	return (setmetatable(v, object))
end

Errors.ApolloError = object

return Errors
