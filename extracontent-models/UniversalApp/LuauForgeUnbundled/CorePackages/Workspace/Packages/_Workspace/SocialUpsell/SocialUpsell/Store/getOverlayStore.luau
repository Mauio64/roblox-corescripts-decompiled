local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Signals")

local createOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Store/createOverlayStore")

return Signals.createComputed(createOverlayStore)
