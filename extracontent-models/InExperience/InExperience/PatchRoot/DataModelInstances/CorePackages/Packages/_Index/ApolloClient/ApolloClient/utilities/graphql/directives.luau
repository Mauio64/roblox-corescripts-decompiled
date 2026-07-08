local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local visit = require(ParentParentParent.GraphQL).visit
local invariant = require(ParentParent.jsutils.invariant).invariant
local getInclusionDirectives = nil

function t1.shouldInclude(p1, t2: {[any]: any}?) -- line: 40
	-- upvalues: Array (copy), getInclusionDirectives (ref), invariant (copy)
	local directives = p1.directives

	if not directives or #directives == 0 then
		return true
	end

	return Array.every(getInclusionDirectives(directives), function(p2) -- line: 47
		-- upvalues: t2 (copy), invariant (copy)
		local directive = p2.directive
		local ifArgument = p2.ifArgument
		local v28

		if ifArgument.value.kind == "Variable" then
			v28 = t2 ~= nil and t2[ifArgument.value.name.value]
			invariant(v28 ~= nil, ("Invalid variable referenced in @%s directive."):format(directive.name.value))
		else
			v28 = ifArgument.value.value
		end

		if directive.name.value == "skip" then
			return not v28
		end

		return v28
	end)
end

local function getDirectiveNames(p3) -- line: 68
	-- upvalues: visit (copy)
	local t3 = {}

	visit(p3, {
		Directive = function(_, p5) -- line: 72
			-- upvalues: t3 (copy)
			table.insert(t3, p5.name.value)
		end
	})

	return t3
end

t1.getDirectiveNames = getDirectiveNames

function t1.hasDirectives(p6, p7) -- line: 81
	-- upvalues: Array (copy), getDirectiveNames (copy)
	return Array.some(getDirectiveNames(p7), function(s1: string) -- line: 82
		-- upvalues: Array (copy), p6 (copy)
		return Array.indexOf(p6, s1) > -1
	end)
end
function t1.hasClientExports(p8) -- line: 88
	-- upvalues: Array (copy), getDirectiveNames (copy)
	local v18 = false

	if p8 ~= nil then
		local t4 = { "client" }

		v18 = Array.some(getDirectiveNames(p8), function(s2: string) -- line: 82
			-- upvalues: Array (copy), t4 (copy)
			return Array.indexOf(t4, s2) > -1
		end)

		if v18 then
			local t5 = { "export" }

			v18 = Array.some(getDirectiveNames(p8), function(s3: string) -- line: 82
				-- upvalues: Array (copy), t5 (copy)
				return Array.indexOf(t5, s3) > -1
			end)
		end
	end

	return v18
end

local function isInclusionDirective(p9) -- line: 97
	local value = p9.name.value

	return value == "skip" or value == "include"
end

function getInclusionDirectives(p10) -- line: 102
	-- upvalues: Array (copy), invariant (copy)
	local t6 = {}

	if p10 and #p10 > 0 then
		Array.forEach(p10, function(p11) -- line: 108
			-- upvalues: invariant (copy), t6 (copy)
			local value = p11.name.value

			if value ~= "skip" and value ~= "include" then
				return
			end

			local arguments = p11.arguments
			local value2 = p11.name.value

			if not arguments or #arguments ~= 1 then
				invariant(false, ("Incorrect number of arguments for the @%s directive."):format(value2))
			end

			local v38 = arguments[1]

			if not v38.name or v38.name.value ~= "if" then
				invariant(false, ("Invalid argument for the @%s directive."):format(value2))
			end

			local value3 = v38.value

			if not value3 or value3.kind ~= "Variable" and value3.kind ~= "BooleanValue" then
				invariant(false, ("Argument for the @%s directive must be a variable or a boolean value."):format(value2))
			end

			table.insert(t6, {
				directive = p11,
				ifArgument = v38
			})
		end)
	end

	return t6
end

t1.getInclusionDirectives = getInclusionDirectives

return t1
