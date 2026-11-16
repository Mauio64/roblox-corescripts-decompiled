local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerSpecialGroupIcon = require(Actions.SetPlayerSpecialGroupIcon)
local SetPlayerIsCreator = require(Actions.SetPlayerIsCreator)
local SetPlayerAvatarIcon = require(Actions.SetPlayerAvatarIcon)

return (Rodux.createReducer({}, {
	[AddPlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isPlaceOwner = game.CreatorType == Enum.CreatorType.User and p2.userId == game.CreatorId,
				avatarIcon = nil,
				specialGroupIcon = nil
			}
		})
	end,
	[RemovePlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.userId] = Cryo.None })
	end,
	[SetPlayerAvatarIcon.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isPlaceOwner = p[p2.userId].isPlaceOwner,
				avatarIcon = p2.avatarIcon,
				specialGroupIcon = p[p2.userId].specialGroupIcon
			}
		})
	end,
	[SetPlayerIsCreator.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isPlaceOwner = p2.isCreator,
				avatarIcon = p[p2.userId].avatarIcon,
				specialGroupIcon = p[p2.userId].specialGroupIcon
			}
		})
	end,
	[SetPlayerSpecialGroupIcon.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isPlaceOwner = p[p2.userId].isPlaceOwner,
				avatarIcon = p[p2.userId].avatarIcon,
				specialGroupIcon = p2.specialGroupIcon
			}
		})
	end
}))
