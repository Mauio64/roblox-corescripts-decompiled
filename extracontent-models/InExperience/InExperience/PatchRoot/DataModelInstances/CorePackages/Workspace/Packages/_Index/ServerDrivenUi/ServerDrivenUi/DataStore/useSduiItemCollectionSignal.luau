local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent

require(ServerDrivenUiParent.RobloxAppEnums)
require(ServerDrivenUiParent.Signals)

local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local React = require(ServerDrivenUiParent.React)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local getItemCollectionKey = require(ServerDrivenUi.DataStore.getItemCollectionKey)

require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local FFlagLuaAppFixInlineSignalsReactPattern = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppFixInlineSignalsReactPattern

local function useSduiItemCollectionSignal(p1, p2, n1: number, s1: string?) -- line: 19
	-- upvalues: getItemCollectionKey (copy), FFlagLuaAppFixInlineSignalsReactPattern (copy), React (copy), getSduiFeedStore (copy), SignalsReact (copy)
	local v13 = getItemCollectionKey(p2, n1)
	local v14 = s1 or p1

	if FFlagLuaAppFixInlineSignalsReactPattern then
		local v15 = React.useCallback(function(p3) -- line: 31
			-- upvalues: getSduiFeedStore (copy), v14 (copy), v13 (copy)
			return getSduiFeedStore(v14).getItemCollection(v13, true)(p3)
		end, {
			v13,
			v14
		})

		return (SignalsReact.useSignalState(v15))
	end

	return (SignalsReact.useSignalState(function(p4) -- line: 44
		-- upvalues: getSduiFeedStore (copy), v14 (copy), v13 (copy)
		return getSduiFeedStore(v14).getItemCollection(v13, true)(p4)
	end))
end

return useSduiItemCollectionSignal
