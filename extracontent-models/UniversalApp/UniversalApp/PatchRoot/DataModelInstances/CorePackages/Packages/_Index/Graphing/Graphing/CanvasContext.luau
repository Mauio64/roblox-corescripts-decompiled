local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local CanvasUtil = require(Graphing.Util.CanvasUtil)

return (React.createContext(CanvasUtil.createDefaultFunctions()))
