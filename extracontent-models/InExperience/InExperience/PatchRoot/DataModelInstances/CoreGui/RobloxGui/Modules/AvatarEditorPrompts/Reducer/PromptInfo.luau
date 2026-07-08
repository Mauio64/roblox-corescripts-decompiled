local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local PromptType = require(ParentParent.PromptType)
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local OpenPrompt = require(ParentParent.Actions.OpenPrompt)
local CreateOutfitConfirmed = require(ParentParent.Actions.CreateOutfitConfirmed)
local t1 = {
	promptType = nil,
	humanoidDescription = nil,
	rigType = nil,
	itemId = nil,
	itemType = nil,
	itemName = nil,
	isFavorited = nil,
	queue = {},
	infoQueue = {}
}

return (Rodux.createReducer(t1, {
	[CloseOpenPrompt.name] = function(p1, _) -- line: 32
		-- upvalues: Cryo (copy)
		if Cryo.isEmpty(p1.queue) then
			return {
				queue = p1.queue,
				infoQueue = p1.infoQueue
			}
		end

		return Cryo.Dictionary.join(p1.infoQueue[1], {
			promptType = p1.queue[1],
			queue = Cryo.List.removeIndex(p1.queue, 1),
			infoQueue = Cryo.List.removeIndex(p1.infoQueue, 1)
		})
	end,
	[OpenPrompt.name] = function(p3, p4) -- line: 47
		-- upvalues: Cryo (copy)
		if p3.promptType == nil then
			return Cryo.Dictionary.join(p3, {
				promptType = p4.promptType
			}, p4.promptInfo)
		end

		return Cryo.Dictionary.join(p3, {
			queue = Cryo.List.join(p3.queue, { p4.promptType }),
			infoQueue = Cryo.List.join(p3.infoQueue, { p4.promptInfo })
		})
	end,
	[CreateOutfitConfirmed.name] = function(p5, _) -- line: 60
		-- upvalues: Cryo (copy), PromptType (copy)
		return Cryo.Dictionary.join(p5, {
			promptType = PromptType.EnterOutfitName
		})
	end
}))
