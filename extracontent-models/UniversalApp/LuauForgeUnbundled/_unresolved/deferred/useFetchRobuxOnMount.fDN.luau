local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module = require("@luauforge/bundled/fCy")
local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/bundled/egx")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function selectRobuxFetchInfo(p2)
	local localUserId = p2.LocalUserId
	local v5 = p2.UserRobux[localUserId]
	return { localUserId = p2.LocalUserId, userRobux = v5 }
end

local function useFetchRobuxOnMount()
	local v5 = useSelector(selectRobuxFetchInfo, getUseSelectorDeepEquals())
	local v6 = module2(module3)
	local v7 = useDispatch()
	React.useEffect(function()
		if v5.userRobux == nil then
			v7(module(v6, v5.localUserId, false))
		end
	end, {})
end

return useFetchRobuxOnMount
