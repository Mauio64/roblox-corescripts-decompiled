local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AddMessage = require(script.Parent.Parent.Actions.AddMessage)
local RemoveMessage = require(script.Parent.Parent.Actions.RemoveMessage)
local PlayerRemoved = require(RobloxGui.Modules.VoiceChat.Actions.PlayerRemoved)

return (Rodux.createReducer({}, {
	[AddMessage.name] = function(p, p2)
		local v = p[p2.message.userId] or {}

		return Cryo.Dictionary.join(p, {
			[p2.message.userId] = Cryo.List.join(v, { p2.message.id })
		})
	end,
	[RemoveMessage.name] = function(p, p2)
		local v = p[p2.message.userId]

		if not v then
			return p
		end

		if #v == 1 and v[1] == p2.message.id then
			return Cryo.Dictionary.join(p, { [p2.message.userId] = Cryo.None })
		end

		return Cryo.Dictionary.join(p, {
			[p2.message.userId] = Cryo.List.filter(v, function(p3): boolean
				return p3 ~= p2.message.id
			end)
		})
	end,
	[PlayerRemoved.name] = function(p, p2)
		if not p[p2.userId] then
			return p
		end

		return Cryo.Dictionary.join(p, { [p2.userId] = Cryo.None })
	end
}))
