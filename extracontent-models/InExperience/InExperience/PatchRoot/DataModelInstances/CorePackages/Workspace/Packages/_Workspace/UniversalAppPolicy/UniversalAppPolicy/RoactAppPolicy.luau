local parent = script.Parent.Parent
local PolicyProvider = require(parent.PolicyProvider)
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger

local UniversalAppPolicy = require(script.Parent.UniversalAppPolicy)

PolicyProvider.Logger:setParent(Logger)

return UniversalAppPolicy
