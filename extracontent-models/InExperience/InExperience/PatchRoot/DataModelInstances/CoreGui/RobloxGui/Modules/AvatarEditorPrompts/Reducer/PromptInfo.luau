local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent

local PromptType = require(parent.PromptType)

local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)
local OpenPrompt = require(parent.Actions.OpenPrompt)
local CreateOutfitConfirmed = require(parent.Actions.CreateOutfitConfirmed)

return (Rodux.createReducer({
	promptType = nil,
	humanoidDescription = nil,
	rigType = nil,
	itemId = nil,
	itemType = nil,
	itemName = nil,
	isFavorited = nil,
	queue = {},
	infoQueue = {}
}, {
	[CloseOpenPrompt.name] = function(p, _)
		if Cryo.isEmpty(p.queue) then
			return { queue = p.queue, infoQueue = p.infoQueue }
		end

		return Cryo.Dictionary.join(p.infoQueue[1], {
			promptType = p.queue[1],
			queue = Cryo.List.removeIndex(p.queue, 1),
			infoQueue = Cryo.List.removeIndex(p.infoQueue, 1)
		})
	end,
	[OpenPrompt.name] = function(data, p)
		if data.promptType == nil then
			return Cryo.Dictionary.join(data, { promptType = p.promptType }, p.promptInfo)
		end

		return Cryo.Dictionary.join(data, {
			queue = Cryo.List.join(data.queue, { p.promptType }),
			infoQueue = Cryo.List.join(data.infoQueue, { p.promptInfo })
		})
	end,
	[CreateOutfitConfirmed.name] = function(p, _)
		return Cryo.Dictionary.join(p, { promptType = PromptType.EnterOutfitName })
	end
}))
