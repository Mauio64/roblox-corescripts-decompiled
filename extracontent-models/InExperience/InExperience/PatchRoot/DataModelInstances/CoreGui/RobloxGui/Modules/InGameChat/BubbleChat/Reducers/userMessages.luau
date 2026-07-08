local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AddMessage = require(script.Parent.Parent.Actions.AddMessage)
local RemoveMessage = require(script.Parent.Parent.Actions.RemoveMessage)
local PlayerRemoved = require(RobloxGui.Modules.VoiceChat.Actions.PlayerRemoved)

return (Rodux.createReducer({}, {
	[AddMessage.name] = function(p1, p2) -- line: 18
		-- upvalues: Cryo (copy)
		local v10 = p1[p2.message.userId] or {}

		return Cryo.Dictionary.join(p1, {
			[p2.message.userId] = Cryo.List.join(v10, { p2.message.id })
		})
	end,
	[RemoveMessage.name] = function(p3, p4) -- line: 26
		-- upvalues: Cryo (copy)
		local v13 = p3[p4.message.userId]

		if v13 then
			if #v13 == 1 and v13[1] == p4.message.id then
				return Cryo.Dictionary.join(p3, {
					[p4.message.userId] = Cryo.None
				})
			end

			return Cryo.Dictionary.join(p3, {
				[p4.message.userId] = Cryo.List.filter(v13, function(p5) -- line: 36
					-- upvalues: p4 (copy)
					return p5 ~= p4.message.id
				end)
			})
		end

		return p3
	end,
	[PlayerRemoved.name] = function(p6, p7) -- line: 46
		-- upvalues: Cryo (copy)
		if p6[p7.userId] then
			return Cryo.Dictionary.join(p6, {
				[p7.userId] = Cryo.None
			})
		end

		return p6
	end
}))
