local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local OdpSessionApiProvider = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpSessionApiProvider")

return (React.createContext(OdpSessionApiProvider))
