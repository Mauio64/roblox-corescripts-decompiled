require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")
local getItemCollectionKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getItemCollectionKey")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiFeedStoreTypes")

local fFlagLuaAppFixInlineSignalsReactPattern = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppFixInlineSignalsReactPattern

local function useSduiItemCollectionSignal(p2, p3, p4, p5)
	local v5 = getItemCollectionKey(p3, p4)
	local v6 = p5 or p2

	if not fFlagLuaAppFixInlineSignalsReactPattern then
		return (SignalsReact.useSignalState(function(p6)
			return getSduiFeedStore(v6).getItemCollection(v5, true)(p6)
		end))
	end

	local v7 = React.useCallback(function(p6)
		return getSduiFeedStore(v6).getItemCollection(v5, true)(p6)
	end, { v5, v6 })

	return (SignalsReact.useSignalState(v7))
end

return useSduiItemCollectionSignal
