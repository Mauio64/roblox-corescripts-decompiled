local ParentParent = script.Parent.Parent
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local OpenPublishAssetPrompt = require(ParentParent.Actions.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(ParentParent.Actions.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(ParentParent.Actions.OpenPublishAvatarAssetPrompt)
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
	[OpenPublishAssetPrompt.name] = function(p1, p2) -- line: 34
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
	[OpenPublishAvatarPrompt.name] = function(p3, p4) -- line: 46
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
	[OpenPublishAvatarAssetPrompt.name] = function(p5, p6) -- line: 58
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
	[SetHumanoidModel.name] = function(p7, p8) -- line: 70
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			promptInfo = Cryo.Dictionary.join(p7.promptInfo, {
				humanoidModel = p8.humanoidModel
			})
		})
	end,
	[SetAccessoryInstance.name] = function(p9, p10) -- line: 78
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			promptInfo = Cryo.Dictionary.join(p9.promptInfo, {
				accessoryInstance = p10.accessoryInstance
			})
		})
	end,
	[SetPriceInRobux.name] = function(p11, p12) -- line: 86
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p11, {
			promptInfo = Cryo.Dictionary.join(p11.promptInfo, {
				priceInRobux = p12.priceInRobux
			})
		})
	end,
	[CloseOpenPrompt.name] = function(p13, _) -- line: 94
		-- upvalues: Cryo (copy)
		if Cryo.isEmpty(p13.queue) then
			return {
				promptInfo = {},
				queue = p13.queue
			}
		end

		return Cryo.Dictionary.join(p13, {
			promptInfo = p13.queue[1],
			queue = Cryo.List.removeIndex(p13.queue, 1)
		})
	end,
	[OpenResultModal.name] = function(p15, p16) -- line: 107
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p15, {
			resultModalType = p16.resultType
		})
	end,
	[CloseResultModal.name] = function(p17, _) -- line: 114
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p17, {
			resultModalType = Cryo.None
		})
	end,
	[OpenValidationErrorModal.name] = function(p19, p20) -- line: 120
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p19, {
			promptInfo = Cryo.Dictionary.join(p19.promptInfo, {
				errorMessage = p20.errorMessage
			})
		})
	end,
	[SetPromptVisibility.name] = function(p21, p22) -- line: 129
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p21, {
			promptInfo = Cryo.Dictionary.join(p21.promptInfo, {
				promptVisible = p22.promptVisible
			})
		})
	end
}))
