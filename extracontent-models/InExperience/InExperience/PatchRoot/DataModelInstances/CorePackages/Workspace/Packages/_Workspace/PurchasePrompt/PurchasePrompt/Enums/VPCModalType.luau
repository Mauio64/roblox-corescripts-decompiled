local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local enumerate = require(PurchasePromptParent.PurchasePromptDeps).enumerate
local addRawValueMethodToEnum = require(PurchasePrompt.Utils.addRawValueMethodToEnum)
local t1 = {
	None = "None",
	EnablePurchase = "EnablePurchase"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
