local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local stackRouter = RoactNavigation.StackRouter
local avatarRootNavigationAction = AvatarExperienceNavigation.Enums.AvatarRootNavigationAction
local customGetStateForAction = AvatarExperienceNavigation.Enums.CustomGetStateForAction

return function(p2, options)
	local v5 = stackRouter(p2, (Cryo.Dictionary.join(options or {}, {
		getCustomActionCreators = function(p3, p4)
			return table.clone(avatarRootNavigationAction)
		end
	})))

	local v6 = {}

	setmetatable(v6, { __mode = "v" })

	local getStateForAction = v5.getStateForAction
	function v5.getStateForAction(data, p3)
		if data.type == avatarRootNavigationAction.RegisterCustomGetStateForAction then
			if customGetStateForAction.HandlerId[data.handlerId] then
				v6[data.handlerId] = data.handler
			else
				warn(`Invalid custom getStateForAction handler id: {data.handlerId}`)
			end
		else
			if data.type == avatarRootNavigationAction.DeregisterCustomGetStateForAction then
				v6[data.handlerId] = nil
				return getStateForAction(data, p3)
			end

			for k, v7 in customGetStateForAction.Ordering do
				local v8 = v6[v7]

				if not v8 then
					continue
				end

				local v9, v10 = v8(data, p3)

				if v9 then
					return v10
				end
			end
		end

		return getStateForAction(data, p3)
	end

	return v5
end
