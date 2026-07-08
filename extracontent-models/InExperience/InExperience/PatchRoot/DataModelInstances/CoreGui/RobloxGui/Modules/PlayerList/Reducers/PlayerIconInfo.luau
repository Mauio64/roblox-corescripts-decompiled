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
	[AddPlayer.name] = function(p1, p2) -- line: 15
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.userId] = {
				avatarIcon = nil,
				specialGroupIcon = nil,
				isPlaceOwner = game.CreatorType == Enum.CreatorType.User and p2.userId == game.CreatorId
			}
		})
	end,
	[RemovePlayer.name] = function(p3, p4) -- line: 25
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.userId] = Cryo.None
		})
	end,
	[SetPlayerAvatarIcon.name] = function(p5, p6) -- line: 31
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.userId] = {
				isPlaceOwner = p5[p6.userId].isPlaceOwner,
				avatarIcon = p6.avatarIcon,
				specialGroupIcon = p5[p6.userId].specialGroupIcon
			}
		})
	end,
	[SetPlayerIsCreator.name] = function(p7, p8) -- line: 41
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			[p8.userId] = {
				isPlaceOwner = p8.isCreator,
				avatarIcon = p7[p8.userId].avatarIcon,
				specialGroupIcon = p7[p8.userId].specialGroupIcon
			}
		})
	end,
	[SetPlayerSpecialGroupIcon.name] = function(p9, p10) -- line: 51
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			[p10.userId] = {
				isPlaceOwner = p9[p10.userId].isPlaceOwner,
				avatarIcon = p9[p10.userId].avatarIcon,
				specialGroupIcon = p10.specialGroupIcon
			}
		})
	end
}))
