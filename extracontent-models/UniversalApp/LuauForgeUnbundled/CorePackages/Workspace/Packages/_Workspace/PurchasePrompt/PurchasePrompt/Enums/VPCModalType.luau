local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").enumerate

local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/addRawValueMethodToEnum")

local v5 = { None = "None", EnablePurchase = "EnablePurchase" }

local v6 = enumerate("VPCModalType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
