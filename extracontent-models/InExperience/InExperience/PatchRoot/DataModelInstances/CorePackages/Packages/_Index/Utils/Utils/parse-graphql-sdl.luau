local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local ParseGraphqlSdl = {}
local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local parse = GraphQL.parse
local Source = GraphQL.Source
local visit = GraphQL.visit
local isTypeSystemDefinitionNode = GraphQL.isTypeSystemDefinitionNode

local Print = GraphQL.print

local comments = require(script.Parent.comments)

local dedentBlockStringValue = comments.dedentBlockStringValue
local getLeadingCommentBlock = comments.getLeadingCommentBlock

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

local transformCommentsToDescriptions
local isDescribable

local function removeCommentsAndTrim(value: string) -- 1 equivalent call inferred from this helper
	local v = string.gsub(value, "(#[^*]*)", "")
	return String.trim(v)
end

function ParseGraphqlSdl.parseGraphQLSDL(location: string?, value: string, p)
	local v = p == nil and {} or p
	local document = nil

	local success, result = pcall(function()
		if Boolean.toJSBoolean(v.commentDescriptions) and String.includes(value, "#") then
			document = transformCommentsToDescriptions(value, v)

			if Boolean.toJSBoolean(v.noLocation) then
				document = parse(Print(document), v)
			end
		else
			document = parse(Source.new(value, location), v)
		end
	end)

	if not success then
		if String.includes(result.message, "EOF") then
			if removeCommentsAndTrim(value) == "" then -- inferred equivalent call
				document = { kind = Kind.DOCUMENT, definitions = {} }
			else
				error(result)
			end
		else
			error(result)
		end
	end

	return { location = location, document = document }
end

transformCommentsToDescriptions = function(value: string, p)
	local v = p == nil and {} or p
	return (visit(parse(value, Object.assign({}, v, { noLocation = false })), {
		leave = function(_, p2)
			if Boolean.toJSBoolean(isDescribable(p2)) then
				local leadingCommentBlock = getLeadingCommentBlock(p2)

				if leadingCommentBlock ~= nil then
					local v2 = dedentBlockStringValue("\n" .. tostring(leadingCommentBlock))

					local includes = String.includes(v2, "\n")

					if Boolean.toJSBoolean(p2.description) then
						return Object.assign({}, p2, {
							description = Object.assign({}, p2.description, {
								value = p2.description.value .. "\n" .. v2,
								block = true
							})
						})
					end

					return Object.assign({}, p2, {
						description = { kind = Kind.STRING, value = v2, block = includes }
					})
				end
			end
		end
	}))
end

ParseGraphqlSdl.transformCommentsToDescriptions = transformCommentsToDescriptions

isDescribable = function(p)
	return isTypeSystemDefinitionNode(p)
		or p.kind == Kind.FIELD_DEFINITION
		or p.kind == Kind.INPUT_VALUE_DEFINITION
		or p.kind == Kind.ENUM_VALUE_DEFINITION
end

ParseGraphqlSdl.isDescribable = isDescribable
return ParseGraphqlSdl
