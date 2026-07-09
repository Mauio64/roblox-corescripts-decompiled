local Parent = script:FindFirstAncestor("CrossExperience").Parent
local Promise = require(Parent.Promise)
local Rodux = require(Parent.Rodux)
local t = require(Parent.t)
local Cryo = require(Parent.Cryo)
local Lumberyak = require(Parent.Lumberyak)
local SharedFlags = require(Parent.SharedFlags)

return {
	Promise = Promise,
	Rodux = Rodux,
	t = t,
	Cryo = Cryo,
	Lumberyak = Lumberyak,
	SharedFlags = SharedFlags
}
