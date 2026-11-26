local sessionScopedSignal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsUtils").createSessionScopedSignal({})

return { getCampaignLocalizations = sessionScopedSignal, setCampaignLocalizations = v5 }
