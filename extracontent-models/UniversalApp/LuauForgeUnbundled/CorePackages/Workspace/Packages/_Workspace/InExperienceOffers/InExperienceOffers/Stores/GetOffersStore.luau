local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Signals")
local createOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore/createOffersStore")

return Signals.createComputed(createOffersStore)
