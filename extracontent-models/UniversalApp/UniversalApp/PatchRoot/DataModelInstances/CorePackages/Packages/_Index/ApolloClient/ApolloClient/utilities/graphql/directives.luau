local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local GraphQL = require(parent2.GraphQL)

local visit = GraphQL.visit

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

local getInclusionDirectives
local Directives = {}

function Directives.shouldInclude(p, p2)
	local directives = p.directives

	if directives and #directives ~= 0 then
		return Array.every(getInclusionDirectives(directives), function(p3)
			local directive = p3.directive
			local ifArgument = p3.ifArgument
			local v

			if ifArgument.value.kind == "Variable" then
				if p2 == nil then
					v = false
				else
					v = p2[ifArgument.value.name.value]
				end

				invariant2(v ~= nil, ("Invalid variable referenced in @%s directive."):format(directive.name.value))
			else
				v = ifArgument.value.value
			end

			if directive.name.value == "skip" then
				return not v
			end

			return v
		end)
	end

	return true
end

local function getDirectiveNames(p)
	local directiveNames = {}

	visit(p, {
		Directive = function(_, p2)
			table.insert(directiveNames, p2.name.value)
		end
	})

	return directiveNames
end

Directives.getDirectiveNames = getDirectiveNames

function Directives.hasDirectives(p, p2)
	return Array.some(getDirectiveNames(p2), function(p3: string): boolean
		return Array.indexOf(p, p3) > -1
	end)
end

function Directives.hasClientExports(p)
	local v

	if p == nil then
		return false
	else
		local v2 = { "client" }
		v = Array.some(getDirectiveNames(p), function(p2: string): boolean
			return Array.indexOf(v2, p2) > -1
		end)

		if v then
			local v3 = { "export" }
			return (Array.some(getDirectiveNames(p), function(p2: string): boolean
				return Array.indexOf(v3, p2) > -1
			end))
		end
	end

	return v
end

local function isInclusionDirective(p): boolean -- 1 equivalent call inferred from this helper
	local value = p.name.value
	return value == "skip" or value == "include"
end

getInclusionDirectives = function(directives)
	local inclusionDirectives = {}

	if directives and #directives > 0 then
		Array.forEach(directives, function(directive)
			if not isInclusionDirective(directive) then -- inferred equivalent call
				return
			end

			local arguments = directive.arguments
			local value = directive.name.value

			if not arguments or #arguments ~= 1 then
				invariant2(false, ("Incorrect number of arguments for the @%s directive."):format(value))
			end

			local argument = arguments[1]

			if not argument.name or argument.name.value ~= "if" then
				invariant2(false, ("Invalid argument for the @%s directive."):format(value))
			end

			local value2 = argument.value

			if not value2 or value2.kind ~= "Variable" and value2.kind ~= "BooleanValue" then
				invariant2(
					false,
					("Argument for the @%s directive must be a variable or a boolean value."):format(value)
				)
			end

			table.insert(inclusionDirectives, { directive = directive, ifArgument = argument })
		end)
	end

	return inclusionDirectives
end

Directives.getInclusionDirectives = getInclusionDirectives

return Directives
