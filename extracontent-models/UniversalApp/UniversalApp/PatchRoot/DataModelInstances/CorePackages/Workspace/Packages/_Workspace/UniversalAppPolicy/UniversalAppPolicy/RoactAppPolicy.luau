local ParentParent = script.Parent.Parent
local PolicyProvider = require(ParentParent.PolicyProvider)
local Logger = require(ParentParent.Loggers).Logger
local UniversalAppPolicy = require(script.Parent.UniversalAppPolicy)

PolicyProvider.Logger:setParent(Logger)

return UniversalAppPolicy
