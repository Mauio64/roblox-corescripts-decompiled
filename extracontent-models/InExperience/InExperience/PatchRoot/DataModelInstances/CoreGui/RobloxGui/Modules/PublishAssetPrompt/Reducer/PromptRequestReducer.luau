local parent = script.Parent.Parent
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local OpenPublishAssetPrompt = require(parent.Actions.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(parent.Actions.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(parent.Actions.OpenPublishAvatarAssetPrompt)
local OpenPublishMakeupLookPrompt = require(parent.Actions.OpenPublishMakeupLookPrompt)
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)
local OpenResultModal = require(parent.Actions.OpenResultModal)
local CloseResultModal = require(parent.Actions.CloseResultModal)
local OpenValidationErrorModal = require(parent.Actions.OpenValidationErrorModal)
local SetHumanoidModel = require(parent.Actions.SetHumanoidModel)
local SetAccessoryInstance = require(parent.Actions.SetAccessoryInstance)
local SetPriceInRobux = require(parent.Actions.SetPriceInRobux)
local SetPromptVisibility = require(parent.Actions.SetPromptVisibility)

return (Rodux.createReducer({ promptInfo = {}, queue = {} }, {
	[OpenPublishAssetPrompt.name] = function(p, p2)
		if p.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p, { promptInfo = p2.promptInfo })
		end

		return Cryo.Dictionary.join(p, {
			queue = Cryo.List.join(p.queue, { p2.promptInfo })
		})
	end,
	[OpenPublishAvatarPrompt.name] = function(p, p2)
		if p.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p, { promptInfo = p2.promptInfo })
		end

		return Cryo.Dictionary.join(p, {
			queue = Cryo.List.join(p.queue, { p2.promptInfo })
		})
	end,
	[OpenPublishAvatarAssetPrompt.name] = function(p, p2)
		if p.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p, { promptInfo = p2.promptInfo })
		end

		return Cryo.Dictionary.join(p, {
			queue = Cryo.List.join(p.queue, { p2.promptInfo })
		})
	end,
	[OpenPublishMakeupLookPrompt.name] = function(p, p2)
		if p.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p, { promptInfo = p2.promptInfo })
		end

		return Cryo.Dictionary.join(p, {
			queue = Cryo.List.join(p.queue, { p2.promptInfo })
		})
	end,
	[SetHumanoidModel.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			promptInfo = Cryo.Dictionary.join(p.promptInfo, { humanoidModel = p2.humanoidModel })
		})
	end,
	[SetAccessoryInstance.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			promptInfo = Cryo.Dictionary.join(p.promptInfo, {
				accessoryInstance = p2.accessoryInstance
			})
		})
	end,
	[SetPriceInRobux.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			promptInfo = Cryo.Dictionary.join(p.promptInfo, { priceInRobux = p2.priceInRobux })
		})
	end,
	[CloseOpenPrompt.name] = function(p, _)
		if Cryo.isEmpty(p.queue) then
			return { promptInfo = {}, queue = p.queue }
		end

		return Cryo.Dictionary.join(p, {
			promptInfo = p.queue[1],
			queue = Cryo.List.removeIndex(p.queue, 1)
		})
	end,
	[OpenResultModal.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { resultModalType = p2.resultType })
	end,
	[CloseResultModal.name] = function(p, _)
		return Cryo.Dictionary.join(p, { resultModalType = Cryo.None })
	end,
	[OpenValidationErrorModal.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			promptInfo = Cryo.Dictionary.join(p.promptInfo, { errorMessage = p2.errorMessage })
		})
	end,
	[SetPromptVisibility.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			promptInfo = Cryo.Dictionary.join(p.promptInfo, { promptVisible = p2.promptVisible })
		})
	end
}))
