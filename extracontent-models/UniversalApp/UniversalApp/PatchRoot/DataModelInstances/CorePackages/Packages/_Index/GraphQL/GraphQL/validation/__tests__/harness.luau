local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Array = LuauPolyfill.Array

local parser = require(parent2.language.parser)
local parse = parser.parse

require(parent2.type.schema)

local buildASTSchema = require(parent2.utilities.buildASTSchema)
local buildSchema = buildASTSchema.buildSchema

local validate = require(parent.validate)
local validate2 = validate.validate
local validateSDL = validate.validateSDL

local schema = buildSchema("  interface Being {\n    name(surname: Boolean): String\n  }\n\n  interface Mammal {\n    mother: Mammal\n    father: Mammal\n  }\n\n  interface Pet implements Being {\n    name(surname: Boolean): String\n  }\n\n  interface Canine implements Mammal & Being {\n    name(surname: Boolean): String\n    mother: Canine\n    father: Canine\n  }\n\n  enum DogCommand {\n    SIT\n    HEEL\n    DOWN\n  }\n\n  type Dog implements Being & Pet & Mammal & Canine {\n    name(surname: Boolean): String\n    nickname: String\n    barkVolume: Int\n    barks: Boolean\n    doesKnowCommand(dogCommand: DogCommand): Boolean\n    isHouseTrained(atOtherHomes: Boolean = true): Boolean\n    isAtLocation(x: Int, y: Int): Boolean\n    mother: Dog\n    father: Dog\n  }\n\n  type Cat implements Being & Pet {\n    name(surname: Boolean): String\n    nickname: String\n    meows: Boolean\n    meowsVolume: Int\n    furColor: FurColor\n  }\n\n  union CatOrDog = Cat | Dog\n\n  interface Intelligent {\n    iq: Int\n  }\n\n  type Human implements Being & Intelligent {\n    name(surname: Boolean): String\n    pets: [Pet]\n    relatives: [Human]\n    iq: Int\n  }\n\n  type Alien implements Being & Intelligent {\n    name(surname: Boolean): String\n    numEyes: Int\n    iq: Int\n  }\n\n  union DogOrHuman = Dog | Human\n\n  union HumanOrAlien = Human | Alien\n\n  enum FurColor {\n    BROWN\n    BLACK\n    TAN\n    SPOTTED\n    NO_FUR\n    UNKNOWN\n  }\n\n  input ComplexInput {\n    requiredField: Boolean!\n    nonNullField: Boolean! = false\n    intField: Int\n    stringField: String\n    booleanField: Boolean\n    stringListField: [String]\n  }\n\n  type ComplicatedArgs {\n    # TODO List\n    # TODO Coercion\n    # TODO NotNulls\n    intArgField(intArg: Int): String\n    nonNullIntArgField(nonNullIntArg: Int!): String\n    stringArgField(stringArg: String): String\n    booleanArgField(booleanArg: Boolean): String\n    enumArgField(enumArg: FurColor): String\n    floatArgField(floatArg: Float): String\n    idArgField(idArg: ID): String\n    stringListArgField(stringListArg: [String]): String\n    stringListNonNullArgField(stringListNonNullArg: [String!]): String\n    complexArgField(complexArg: ComplexInput): String\n    multipleReqs(req1: Int!, req2: Int!): String\n    nonNullFieldWithDefault(arg: Int! = 0): String\n    multipleOpts(opt1: Int = 0, opt2: Int = 0): String\n    multipleOptAndReq(req1: Int!, req2: Int!, opt1: Int = 0, opt2: Int = 0): String\n  }\n\n  type QueryRoot {\n    human(id: ID): Human\n    alien: Alien\n    dog: Dog\n    cat: Cat\n    pet: Pet\n    catOrDog: CatOrDog\n    dogOrHuman: DogOrHuman\n    humanOrAlien: HumanOrAlien\n    complicatedArgs: ComplicatedArgs\n  }\n\n  schema {\n    query: QueryRoot\n  }\n\n  directive @onQuery on QUERY\n  directive @onMutation on MUTATION\n  directive @onSubscription on SUBSCRIPTION\n  directive @onField on FIELD\n  directive @onFragmentDefinition on FRAGMENT_DEFINITION\n  directive @onFragmentSpread on FRAGMENT_SPREAD\n  directive @onInlineFragment on INLINE_FRAGMENT\n  directive @onVariableDefinition on VARIABLE_DEFINITION\n")

local function expectValidationErrorsWithSchema(callback, schema2, p, p2: string)
	local v = validate2(schema2, parse(p2), { p })

	return callback((Array.map(v, function(p3)
		return { message = p3.message, locations = p3.locations }
	end)))
end

local Harness = {}
Harness.testSchema = schema
Harness.expectValidationErrorsWithSchema = expectValidationErrorsWithSchema

function Harness.expectValidationErrors(p, p2, p3: string)
	return expectValidationErrorsWithSchema(p, schema, p2, p3)
end

function Harness.expectSDLValidationErrors(callback, p, p2, p3: string)
	local v = validateSDL(parse(p3), p, { p2 })

	return callback((Array.map(v, function(p4)
		return { message = p4.message, locations = p4.locations }
	end)))
end

return Harness
