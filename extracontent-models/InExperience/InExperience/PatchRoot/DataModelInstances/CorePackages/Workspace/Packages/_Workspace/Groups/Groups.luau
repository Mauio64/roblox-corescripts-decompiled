local script2 = script

return {
	GroupsInExperienceApp = require(script2.GroupsInExperienceApp),
	GroupsList = require(script2.Components.GroupsList),
	GroupsPage = require(script2.Components.GroupsPage),
	Common = require(script2.Common),
	Networking = require(script2.Networking),
	Contexts = require(script2.Contexts),
	Hooks = require(script2.Hooks),
	Navigation = require(script2.Navigation),
	CommunityListRouting = require(script2.CommunityListRouting),
	getGroupSidebar = function()
		return require(script2.Common.GroupSidebar)
	end,
	["jest.config"] = script["jest.config"]
}
