local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/bundled/hEJ")

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground

local module2 = require("@luauforge/bundled/hEE")

local module3 = require("@luauforge/bundled/hIP")

local module4 = require("@luauforge/bundled/hUF")

local module5 = require("@luauforge/bundled/fAe")

local module6 = require("@luauforge/bundled/hvF")

local set = {}

if module2 then
	set[appPage.Home] = true
	set[appPage.Games] = true
end

if module3 then
	set[appPage.Settings] = true
end

if module4 then
	set[appPage.Build] = true
end

if module5 then
	set[appPage.Accessibility] = true
end

if module6 then
	set[appPage.Chat] = true
end

if module then
	set[appPage.GamesList] = true
	set[appPage.DeeplinkGamesList] = true
end

if fFlagAppThemeHalloween2026FriendsBackground then
	set[appPage.ViewFriends] = true
	set[appPage.ConnectionsHub] = true
end

return set
