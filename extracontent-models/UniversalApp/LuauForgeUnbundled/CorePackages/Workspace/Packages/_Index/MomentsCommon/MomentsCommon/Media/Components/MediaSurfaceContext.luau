local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local frozen = table.freeze({})

return React.createContext(frozen)
