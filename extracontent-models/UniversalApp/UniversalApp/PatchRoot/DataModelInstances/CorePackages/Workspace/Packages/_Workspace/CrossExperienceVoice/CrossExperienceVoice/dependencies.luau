local Parent = script:FindFirstAncestor("CrossExperienceVoice").Parent
local Promise = require(Parent.Promise)
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Rodux = require(Parent.Rodux)
local RoactUtils = require(Parent.RoactUtils)
local t = require(Parent.t)
local Cryo = require(Parent.Cryo)
local CrossExperience = require(Parent.CrossExperience)
local Dash = require(Parent.Dash)
local SharedFlags = require(Parent.SharedFlags)
local Lumberyak = require(Parent.Lumberyak)
local LuauPolyfill = require(Parent.LuauPolyfill)
local ExperienceService = require(Parent.ExperienceService)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local ExperimentCacheManager = require(Parent.ExperimentCacheManager)
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	React = React,
	ReactOtter = ReactOtter,
	Rodux = Rodux,
	Cryo = Cryo,
	Dash = Dash,
	t = t,
	ExperienceService = ExperienceService,
	RoactUtils = RoactUtils,
	CrossExperience = CrossExperience,
	SharedFlags = SharedFlags,
	LoggingProtocol = LoggingProtocol,
	Lumberyak = Lumberyak,
	LuauPolyfill = LuauPolyfill,
	SocialLuaAnalytics = SocialLuaAnalytics,
	ExperimentCacheManager = ExperimentCacheManager,
	Promise = Promise
}
