local User = require(script.User)
local ProfileInsights = require(script.ProfileInsights)
local Experience = require(script.Experience)
local Media = require(script.Media)
local OmniFeed = require(script.OmniFeed)
local VirtualEvent = require(script.VirtualEvent)
local UserProfile = require(script.UserProfile)
local AmpUpsell = require(script.AmpUpsell)
local Friends = require(script.Friends)
local Presence = require(script.Presence)
return {
	User,
	ProfileInsights,
	Experience,
	Media,
	OmniFeed,
	VirtualEvent,
	UserProfile,
	AmpUpsell,
	Friends,
	Presence,
	require(script.ShareLink)
}
