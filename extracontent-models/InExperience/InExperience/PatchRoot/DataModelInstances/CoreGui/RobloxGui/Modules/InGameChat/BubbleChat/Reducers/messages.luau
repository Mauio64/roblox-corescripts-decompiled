local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AddMessage = require(script.Parent.Parent.Actions.AddMessage)
local RemoveMessage = require(script.Parent.Parent.Actions.RemoveMessage)
local SetMessageText = require(script.Parent.Parent.Actions.SetMessageText)

return (Rodux.createReducer({}, {
	[AddMessage.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.message.id] = p2.message })
	end,
	[RemoveMessage.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.message.id] = Cryo.None })
	end,
	[SetMessageText.name] = function(p, p2)
		local v = p[p2.messageId]

		if not v then
			return p
		end

		return Cryo.Dictionary.join(p, {
			[p2.messageId] = Cryo.Dictionary.join(v, { text = p2.newText })
		})
	end
}))
