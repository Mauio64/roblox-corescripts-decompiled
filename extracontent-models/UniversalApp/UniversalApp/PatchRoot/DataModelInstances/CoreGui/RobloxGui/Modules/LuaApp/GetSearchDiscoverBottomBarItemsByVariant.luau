local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarHeadshotSystemBarIcon = require(Modules.AvatarExperience.Common.Components.AvatarHeadshotSystemBarIcon)
local t1 = {
	badgeCount = 0,
	page = AppPage.Home,
	icon = {
		on = "icons/menu/home_on",
		off = "icons/menu/home_off"
	},
	actionType = Enum.AppShellActionType.TapHomePageTab
}
local t2 = {
	badgeCount = 0,
	page = AppPage.Games,
	icon = {
		on = "icons/menu/games_on",
		off = "icons/menu/games_off"
	},
	actionType = Enum.AppShellActionType.TapGamePageTab
}
local t3 = {
	actionType = nil,
	badgeCount = 0,
	page = AppPage.Games,
	icon = {
		on = "icons/menu/search_on",
		off = "icons/menu/search"
	}
}
local t4 = {
	badgeCount = 0,
	page = AppPage.AvatarExperienceRoot,
	iconComponent = AvatarHeadshotSystemBarIcon,
	actionType = Enum.AppShellActionType.TapAvatarTab
}
local t5 = {
	badgeCount = 0,
	page = AppPage.Chat,
	icon = {
		on = "icons/menu/chat_on",
		off = "icons/menu/chat_off"
	},
	actionType = Enum.AppShellActionType.TapChatTab
}
local t6 = {
	actionType = nil,
	badgeCount = 0,
	page = AppPage.More,
	icon = {
		on = "icons/menu/more_on",
		off = "icons/menu/more_off"
	}
}
local t7 = {
	t1,
	t2,
	t4,
	t5,
	t6
}
local t8 = {
	t1,
	t3,
	t4,
	t5,
	t6
}
local t9 = {
	t1,
	t4,
	t5,
	t6
}

return function(n1: number) -- line: 100
	-- upvalues: t7 (copy), t8 (copy), t9 (copy)
	assert(typeof(n1) == "number", "variant must be a number")

	local v14 = t7

	if n1 == 0 then
		v14 = t7
	elseif n1 == 1 then
		v14 = t8
	elseif n1 == 2 then
		v14 = t9
	else
		warn("Invalid variant requested for bottom bar, returning control")
	end

	local t10 = {}

	for i, v in ipairs(v14) do
		t10[v.page] = i
	end

	return v14, t10
end
