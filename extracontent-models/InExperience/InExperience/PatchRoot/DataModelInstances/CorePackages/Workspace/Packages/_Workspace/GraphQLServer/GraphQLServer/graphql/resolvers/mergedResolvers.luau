local parent = script:FindFirstAncestor("GraphQLServer").Parent
require(parent.LuauPolyfill)

local utils = require(script.Parent.Parent.utils)
local mergeResolvers = utils.mergeResolvers

local UserResolver = require(script.Parent.UserResolver)
local default = UserResolver.default
local PlayerResolver = require(script.Parent.PlayerResolver)
local default2 = PlayerResolver.default
local OmniFeed = require(script.Parent.OmniFeed)
local default3 = OmniFeed.default
local ScalarResolver = require(script.Parent.ScalarResolver)
local default4 = ScalarResolver.default
local VirtualEventResolver = require(script.Parent.VirtualEventResolver)
local ExperienceResolver = require(script.Parent.ExperienceResolver)
local ProfileInsightsResolver = require(script.Parent.ProfileInsightsResolver)
local AmpUpsellResolver = require(script.Parent.AmpUpsellResolver)
local default5 = AmpUpsellResolver.default
local UserProfileResolver = require(script.Parent.UserProfileResolver)
local FriendsResolver = require(script.Parent.FriendsResolver)
local ShareLinkResolver = require(script.Parent.ShareLinkResolver)
return {
	default = mergeResolvers({
		default,
		default2,
		default3,
		default4,
		VirtualEventResolver,
		ExperienceResolver,
		ProfileInsightsResolver,
		default5,
		UserProfileResolver,
		FriendsResolver,
		ShareLinkResolver
	})
}
