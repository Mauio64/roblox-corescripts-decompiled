local parent = script:FindFirstAncestor("CrossExperienceVoice").Parent

local Promise = require(parent.Promise)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Rodux = require(parent.Rodux)
local RoactUtils = require(parent.RoactUtils)
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local CrossExperience = require(parent.CrossExperience)
local Dash = require(parent.Dash)
local SharedFlags = require(parent.SharedFlags)
local Lumberyak = require(parent.Lumberyak)
local LuauPolyfill = require(parent.LuauPolyfill)
local ExperienceService = require(parent.ExperienceService)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local ExperimentCacheManager = require(parent.ExperimentCacheManager)
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
	LoggingProtocol = require(parent.LoggingProtocol),
	Lumberyak = Lumberyak,
	LuauPolyfill = LuauPolyfill,
	SocialLuaAnalytics = SocialLuaAnalytics,
	ExperimentCacheManager = ExperimentCacheManager,
	Promise = Promise
}
