local DEV = require(script.DEV)
local Globals = {}

Globals.DEV = DEV.default

local graphql = require(script.graphql)
local removeTemporaryGlobals = graphql.removeTemporaryGlobals
Globals.removeTemporaryGlobals = removeTemporaryGlobals

local null = require(script.null)
Globals.NULL = null.NULL

removeTemporaryGlobals()

return Globals
