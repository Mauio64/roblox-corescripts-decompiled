local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local Kind = GraphQL.Kind
local parse = GraphQL.parse
local GraphQLSource = GraphQL.Source
local visit = GraphQL.visit
local isTypeSystemDefinitionNode = GraphQL.isTypeSystemDefinitionNode
local print = GraphQL.print
local comments = require(script.Parent.comments)
local dedentBlockStringValue = comments.dedentBlockStringValue
local getLeadingCommentBlock = comments.getLeadingCommentBlock

require(script.Parent.Interfaces)

local String = LuauPolyfill.String
local transformCommentsToDescriptions = nil
local isDescribable = nil

local function removeCommentsAndTrim(s1: string) -- line: 51
	-- upvalues: String (copy)
	local v21 = string.gsub(s1, "(#[^*]*)", "")

	return String.trim(v21)
end

function t1.parseGraphQLSDL(s2: string?, s3: string, p1) -- line: 56
	-- upvalues: Boolean (copy), String (copy), transformCommentsToDescriptions (ref), parse (copy), print (copy), GraphQLSource (copy), Kind (copy)
	local v25 = if p1 == nil then {} else p1
	local u26 = nil
	local ok, result = pcall(function() -- line: 62
		-- upvalues: Boolean (copy), v25 (copy), String (copy), s3 (copy), u26 (ref), transformCommentsToDescriptions (ref), parse (copy), print (copy), GraphQLSource (copy), s2 (copy)
		if Boolean.toJSBoolean(v25.commentDescriptions) and String.includes(s3, "#") then
			u26 = transformCommentsToDescriptions(s3, v25)

			if Boolean.toJSBoolean(v25.noLocation) then
				u26 = parse(print(u26), v25)

				return
			end
		else
			u26 = parse(GraphQLSource.new(s3, s2), v25)
		end
	end)
	local g30

	if not ok then
		g30 = nil

		if String.includes(result.message, "EOF") then
			local v29 = string.gsub(s3, "(#[^*]*)", "")

			if String.trim(v29) == "" then
				u26 = {
					kind = Kind.DOCUMENT,
					definitions = {}
				}
				g30 = true
			end
		end

		if not g30 then
			error(result)
			g30 = true
		end
	end

	g30 = false

	return {
		location = s2,
		document = u26
	}
end
function transformCommentsToDescriptions(s4: string, p2) -- line: 122
	-- upvalues: parse (copy), Object (copy), visit (copy), Boolean (copy), isDescribable (ref), getLeadingCommentBlock (copy), dedentBlockStringValue (copy), String (copy), Kind (copy)
	local v33 = if p2 == nil then {} else p2
	local v34 = parse(s4, Object.assign({}, v33, {
		noLocation = false
	}))

	return (visit(v34, {
		leave = function(_, p4) -- line: 129
			-- upvalues: Boolean (copy), isDescribable (ref), getLeadingCommentBlock (copy), dedentBlockStringValue (copy), String (copy), Object (copy), Kind (copy)
			if Boolean.toJSBoolean(isDescribable(p4)) then
				local v38 = getLeadingCommentBlock(p4)

				if v38 ~= nil then
					local v39 = dedentBlockStringValue("\n" .. tostring(v38))
					local v40 = String.includes(v39, "\n")

					if not Boolean.toJSBoolean(p4.description) then
						return Object.assign({}, p4, {
							description = {
								kind = Kind.STRING,
								value = v39,
								block = v40
							}
						})
					end

					return Object.assign({}, p4, {
						description = Object.assign({}, p4.description, {
							block = true,
							value = p4.description.value .. "\n" .. v39
						})
					})
				end
			end
		end
	}))
end

t1.transformCommentsToDescriptions = transformCommentsToDescriptions

function isDescribable(p5) -- line: 176
	-- upvalues: isTypeSystemDefinitionNode (copy), Kind (copy)
	return isTypeSystemDefinitionNode(p5) or (p5.kind == Kind.FIELD_DEFINITION or (p5.kind == Kind.INPUT_VALUE_DEFINITION or p5.kind == Kind.ENUM_VALUE_DEFINITION))
end

t1.isDescribable = isDescribable

return t1
