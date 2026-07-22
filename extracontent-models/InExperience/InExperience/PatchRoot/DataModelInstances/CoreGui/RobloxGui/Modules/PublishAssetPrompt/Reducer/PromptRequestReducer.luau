local ParentParent = script.Parent.Parent
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local OpenPublishAssetPrompt = require(ParentParent.Actions.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(ParentParent.Actions.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(ParentParent.Actions.OpenPublishAvatarAssetPrompt)
local OpenPublishMakeupLookPrompt = require(ParentParent.Actions.OpenPublishMakeupLookPrompt)
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local OpenResultModal = require(ParentParent.Actions.OpenResultModal)
local CloseResultModal = require(ParentParent.Actions.CloseResultModal)
local OpenValidationErrorModal = require(ParentParent.Actions.OpenValidationErrorModal)
local SetHumanoidModel = require(ParentParent.Actions.SetHumanoidModel)
local SetAccessoryInstance = require(ParentParent.Actions.SetAccessoryInstance)
local SetPriceInRobux = require(ParentParent.Actions.SetPriceInRobux)
local SetPromptVisibility = require(ParentParent.Actions.SetPromptVisibility)
local t1 = {
	promptInfo = {},
	queue = {}
}

return (Rodux.createReducer(t1, {
	[OpenPublishAssetPrompt.name] = function(p1, p2) -- line: 35
		-- upvalues: Cryo (copy)
		if p1.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p1, {
				promptInfo = p2.promptInfo
			})
		end

		return Cryo.Dictionary.join(p1, {
			queue = Cryo.List.join(p1.queue, { p2.promptInfo })
		})
	end,
	[OpenPublishAvatarPrompt.name] = function(p3, p4) -- line: 47
		-- upvalues: Cryo (copy)
		if p3.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p3, {
				promptInfo = p4.promptInfo
			})
		end

		return Cryo.Dictionary.join(p3, {
			queue = Cryo.List.join(p3.queue, { p4.promptInfo })
		})
	end,
	[OpenPublishAvatarAssetPrompt.name] = function(p5, p6) -- line: 59
		-- upvalues: Cryo (copy)
		if p5.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p5, {
				promptInfo = p6.promptInfo
			})
		end

		return Cryo.Dictionary.join(p5, {
			queue = Cryo.List.join(p5.queue, { p6.promptInfo })
		})
	end,
	[OpenPublishMakeupLookPrompt.name] = function(p7, p8) -- line: 71
		-- upvalues: Cryo (copy)
		if p7.promptInfo.promptType == nil then
			return Cryo.Dictionary.join(p7, {
				promptInfo = p8.promptInfo
			})
		end

		return Cryo.Dictionary.join(p7, {
			queue = Cryo.List.join(p7.queue, { p8.promptInfo })
		})
	end,
	[SetHumanoidModel.name] = function(p9, p10) -- line: 81
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			promptInfo = Cryo.Dictionary.join(p9.promptInfo, {
				humanoidModel = p10.humanoidModel
			})
		})
	end,
	[SetAccessoryInstance.name] = function(p11, p12) -- line: 89
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p11, {
			promptInfo = Cryo.Dictionary.join(p11.promptInfo, {
				accessoryInstance = p12.accessoryInstance
			})
		})
	end,
	[SetPriceInRobux.name] = function(p13, p14) -- line: 97
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p13, {
			promptInfo = Cryo.Dictionary.join(p13.promptInfo, {
				priceInRobux = p14.priceInRobux
			})
		})
	end,
	[CloseOpenPrompt.name] = function(p15, _) -- line: 105
		-- upvalues: Cryo (copy)
		if Cryo.isEmpty(p15.queue) then
			return {
				promptInfo = {},
				queue = p15.queue
			}
		end

		return Cryo.Dictionary.join(p15, {
			promptInfo = p15.queue[1],
			queue = Cryo.List.removeIndex(p15.queue, 1)
		})
	end,
	[OpenResultModal.name] = function(p17, p18) -- line: 118
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p17, {
			resultModalType = p18.resultType
		})
	end,
	[CloseResultModal.name] = function(p19, _) -- line: 125
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p19, {
			resultModalType = Cryo.None
		})
	end,
	[OpenValidationErrorModal.name] = function(p21, p22) -- line: 131
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p21, {
			promptInfo = Cryo.Dictionary.join(p21.promptInfo, {
				errorMessage = p22.errorMessage
			})
		})
	end,
	[SetPromptVisibility.name] = function(p23, p24) -- line: 140
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p23, {
			promptInfo = Cryo.Dictionary.join(p23.promptInfo, {
				promptVisible = p24.promptVisible
			})
		})
	end
}))
