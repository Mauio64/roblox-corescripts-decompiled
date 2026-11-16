local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local ChatCardEmphasisContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisContext")
local ChatCardEmphasisPositionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisPositionContext")

local function useChatCardEmphasis(p2, value)
	local v5 = React.useContext(ChatCardEmphasisContext)
	local v6 = React.useMemo(function()
		return {}
	end, {})
	local v7 = React.useContext(ChatCardEmphasisPositionContext)

	React.useLayoutEffect(function()
		if v5 == nil or p2 == nil then
			return nil
		end

		v5.register(v6, p2, value or 0, v7)
		return function()
			v5.unregister(v6)
		end
	end, { v5, v6, p2, value, v7 })

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p3): boolean
			return v5 ~= nil and v5.getEmphasizedKey(p3) == v6
		end)
	end, { v5, v6 })
	local v9 = SignalsReact.useSignalState(v8)

	if v5 == nil then
		return nil
	end

	return v9
end

return useChatCardEmphasis
